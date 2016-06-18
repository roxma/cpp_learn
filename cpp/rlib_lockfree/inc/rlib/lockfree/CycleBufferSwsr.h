#ifndef RLF_CYCLEBUFFERSWSR_H
#define RLF_CYCLEBUFFERSWSR_H

#include <atomic>
#include <stddef.h>
#include <memory>
#include <type_traits>
#include <algorithm>
#include  <stdexcept>

#include "rlib/lockfree/_LightWeightMutex.h"

namespace rlib{ namespace lockfree{

/**
 * Single Writer single Reader cycle buffer.
 * This is a data structor that ensures any writer not block any reader, and any reader will
 * not block any writer. However if you have multi writers, writers may block each other.
 * If you have multi readers, they may block each other too.
 */
class CycleBufferSwsr{
private:

	typedef char ElemT;

	static_assert(std::is_object<ElemT>::value, "ElemT must be an object type");

	size_t readPos;
	size_t writePos;
	size_t capacity;
	std::atomic<size_t> readableCount;

	std::unique_ptr<ElemT[]> buffer;

	rlib::lockfree::_LightWeightMutex writerMutex;
	rlib::lockfree::_LightWeightMutex readerMutex;

	CycleBufferSwsr(CycleBufferSwsr&&);
	CycleBufferSwsr(const CycleBufferSwsr&);


	void privateReaderContinuousPop(ElemT* o_pos, size_t i_popCount){
		ElemT* readBase = &(this->buffer[this->readPos]);
		for (size_t i = 0; i < i_popCount; ++i){
			o_pos[i] = readBase[i];
		}
		privateReaderContinuousPop(i_popCount);
	}

	/**
     * Adjust read offset
	 */
	void privateReaderContinuousPop(size_t i_popCount){
		this->readPos += i_popCount;
		this->readPos = this->readPos % this->capacity;
		this->readableCount.fetch_sub(i_popCount, std::memory_order_relaxed);
	}


	void privateWriterContinuousPush(ElemT const* i_pos, size_t i_pushCount){
		ElemT* writeBase = &(this->buffer[this->writePos]);
		for (size_t i = 0; i < i_pushCount; ++i){
			writeBase[i] = i_pos[i];
		}
		privateWriterContinuousPush(i_pushCount);
	}

	/**
	 * Adjust write offset
	 */
	void privateWriterContinuousPush(size_t i_pushCount){
		this->writePos += i_pushCount;
		this->writePos = this->writePos % this->capacity;
		this->readableCount.fetch_add(i_pushCount, std::memory_order_relaxed);
	}


	void privateReaderGetReadableCount(size_t* o_total, size_t* o_continuousCount = nullptr){
		size_t currentReadPos = this->readPos;
		*o_total = this->readableCount.load(std::memory_order_relaxed);

		if (o_continuousCount){
			if (currentReadPos + *o_total > this->capacity){
				*o_continuousCount = this->capacity - currentReadPos;
			}
			else{
				*o_continuousCount = *o_total;
			}
		}
	}

    void privateWriterGetWritableCount(size_t* o_total, size_t* o_continuousCount = nullptr){
		size_t currentWritePos = this->writePos;
		*o_total = this->capacity - this->readableCount.load(std::memory_order_relaxed);

		if (o_continuousCount){
			if (currentWritePos + *o_total > this->capacity){
				*o_continuousCount = this->capacity - currentWritePos;
			}
			else{
				*o_continuousCount = *o_total;
			}
		}
	}

public:
	class Tester;
	friend class Tester;
public:

	CycleBufferSwsr(){
		ReInit(0);
	};

	CycleBufferSwsr(size_t i_capacity){
		ReInit(i_capacity);
	}

	/**
	 * Please ensure there's no other operations during ReInit.
	 */
	void ReInit(size_t i_capacity){
	    _LightWeightMutexLockGuard<std::memory_order_seq_cst> readerGuard(readerMutex);
	    _LightWeightMutexLockGuard<std::memory_order_seq_cst> writerGuard(writerMutex);

		this->readPos = 0;
		this->writePos = 0;
		this->capacity = i_capacity;
		this->readableCount = 0;
		this->buffer = std::unique_ptr<ElemT[]>(i_capacity ? new ElemT[i_capacity] : nullptr);
	}

	void ReaderGetReadableCount(size_t* o_total){
        _LightWeightMutexLockGuard<std::memory_order_seq_cst> guard(readerMutex);
        privateReaderGetReadableCount(o_total,nullptr);
	}

	/**
	 * For reading thread only
	 */
	bool ReaderPop(ElemT* const o_buffer, size_t const i_bufferSize){
        _LightWeightMutexLockGuard<std::memory_order_seq_cst> guard(readerMutex);

		if (this->readableCount.load(std::memory_order_relaxed) < i_bufferSize) return false;

		ElemT* pos = o_buffer;
		size_t sizeLeft = i_bufferSize;

		while (sizeLeft){

			size_t dummy = 0, continuousCount = 0;
			privateReaderGetReadableCount(&dummy, &continuousCount);

			if (continuousCount >= sizeLeft){
				privateReaderContinuousPop(pos, sizeLeft);

				pos += sizeLeft;
				sizeLeft = 0;
			}
			else{

				privateReaderContinuousPop(pos, continuousCount);

				pos += continuousCount;
				sizeLeft -= continuousCount;
			}
		}

		return true;
	}

	/**
	 * For wirting thread only
	 */
	void WriterGetWritableCount(size_t* o_total){
	    _LightWeightMutexLockGuard<std::memory_order_seq_cst> guard(writerMutex);
        privateWriterGetWritableCount(o_total,nullptr);
	}

	/**
	 * For wirting thread only
	 */
	bool WriterPush(ElemT const * const i_buffer, size_t const i_bufferSize){
        _LightWeightMutexLockGuard<std::memory_order_seq_cst> guard(writerMutex);

		if ((this->capacity - this->readableCount.load(std::memory_order_relaxed)) < i_bufferSize) return false;

		ElemT const * pos = i_buffer;
		size_t sizeLeft = i_bufferSize;

		while (sizeLeft){

			size_t dummy = 0, continuousCount = 0;
			this->privateWriterGetWritableCount(&dummy, &continuousCount);

			if (continuousCount >= sizeLeft){

				this->privateWriterContinuousPush(pos, sizeLeft);

				pos += sizeLeft;
				sizeLeft = 0;
			}
			else{

				this->privateWriterContinuousPush(pos, continuousCount);

				pos += continuousCount;
				sizeLeft -= continuousCount;
			}
		}

		return true;
	}
};

}} // namespace rlib::lockfree


#endif
