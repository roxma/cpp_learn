#ifndef RLF_CYCLEBUFFERMWSR_H
#define RLF_CYCLEBUFFERMWSR_H

#include <memory>
#include <atomic>
#include <stddef.h>
#include <tuple>

namespace rlib{ namespace lockfree{

class CycleBufferMwsr{
	typedef char ElemT;

	typedef uint64_t WholeUint;
	typedef uint32_t HalfUint;
	typedef uint16_t QuarterUint;

	static_assert(sizeof(WholeUint) / sizeof(HalfUint) == 2, "");
	static_assert(sizeof(WholeUint) / sizeof(QuarterUint) == 4, "");
	static_assert(sizeof(std::atomic<WholeUint> ) == sizeof(WholeUint), "");

	struct CommitInfo{
		HalfUint pos;
		HalfUint commitSize;
		std::atomic<bool> committed;
		CommitInfo() :pos(0),commitSize(0), committed(false){}
	};

	HalfUint bufferCapacity;

	std::unique_ptr <ElemT[]> buffer;
	HalfUint readPos;
	std::atomic<WholeUint> readableCountWritePos;

	std::unique_ptr<CommitInfo[]> commitInfos;
	HalfUint commitInfosReadPos;
	std::atomic<WholeUint> commitInfoReadableCountWritePos;

	CycleBufferMwsr(){
        bufferCapacity = 0;
        readPos = 0;
        readableCountWritePos = 0;
        commitInfos = 0;
        commitInfosReadPos = 0;
        commitInfoReadableCountWritePos = 0;
	}

    struct ReadableCountWritePosParser{
        union{
            HalfUint values[2];
            WholeUint value;
        }v;
        static_assert(sizeof(v)==sizeof(WholeUint),"");

        ReadableCountWritePosParser(WholeUint i_value){
            this->v.value = i_value;
        }

        HalfUint& WritePos()      { return this->v.values[0]; };
        HalfUint& ReadableCount() { return this->v.values[1]; }

        void GetValue(WholeUint& o_value){
            o_value = this->v.value;
        }
    };

    bool Write(const ElemT* i_buffer, HalfUint i_size){

        // writing procedure:
        // 1. atomically update write pos and readable count (using CAS)
        // 2. atomically push a commitInfo
        // 3. write values
        // 4. update commitInfo to commit the write

        // atomically update write pos and readable count (using CAS)
        WholeUint oldValue = this->readableCountWritePos.load(std::memory_order_relaxed);
        HalfUint oldWritePos;
        WholeUint newValue;
        do{
            ReadableCountWritePosParser parser(oldValue);
            if( this->bufferCapacity - parser.ReadableCount() < i_size ){
                return false;   // no enough room
            }
            parser.ReadableCount() += i_size;
            oldWritePos = parser.WritePos();
            parser.WritePos() = (oldWritePos + i_size)%bufferCapacity;
            parser.GetValue(newValue);
        }while(false == this->readableCountWritePos.compare_exchange_weak(oldValue, newValue,std::memory_order_relaxed));

        // atomically push a commit Info
        WholeUint commitInfoOldValue = this->commitInfoReadableCountWritePos.load(std::memory_order_relaxed);
        HalfUint commitInfoOldWritePos;
        WholeUint commitInfoNewValue;
        do{
            ReadableCountWritePosParser parser(commitInfoOldValue);
             if( this->bufferCapacity - parser.ReadableCount() < i_size ){
                return false;   // no enough room
            }
            parser.ReadableCount() += 1;
            commitInfoOldWritePos = parser.WritePos();
            parser.WritePos() = (commitInfoOldWritePos + 1)%bufferCapacity;
            parser.GetValue(commitInfoNewValue);
        }while(false == this->commitInfoReadableCountWritePos.compare_exchange_weak(commitInfoOldValue, commitInfoNewValue,std::memory_order_relaxed));

        // write values
        for(HalfUint i=0; i<i_size; ++i){
            buffer[(oldWritePos+i) % this->bufferCapacity] = i_buffer[i];
        }

        // update commitInfo to commit the write
        commitInfos[commitInfoOldWritePos].committed.store(true, std::memory_order_seq_cst);

        return true;
    }



	// Read:
	// 1. GetReadableCount
	// 2. if size is too small, return false
	// 3. read value
	// 4. atomically update readable count, update read pos

	// commitInfo queue get readable count procedure
	//
	// 1.  find the next commit info
    // 2.  if not found, return current readable count
	// 3.  if not committed, return current readable count
	// 4.  update readable count
	// 5.  reset the commit info
    // 6.  if continuous
    // 7.      update commit info queue read offset
    // 8.      update commit info queue readable count atomically
    // 9.  go to step one

};

}} // namespace rlib::lockfree


#endif
