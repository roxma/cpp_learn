#ifndef RLF_PRIVATE_LIGHTWEIGHTMUTEX_H
#define RLF_PRIVATE_LIGHTWEIGHTMUTEX_H

#include <atomic>
#include <thread>
#include <chrono>
#include <condition_variable>

namespace rlib{ namespace lockfree{

/**
 * For situations in which it is very likely to acquire the lock immediately.
 * @note This is not a recursive lock. Don't try to lock the mutex twice in the same thread!
 */
class _LightWeightMutexAtomicFlag;
typedef _LightWeightMutexAtomicFlag _LightWeightMutex;

class _LightWeightMutexAtomicInt{

	std::atomic<int> locked;
	std::condition_variable condition;

    _LightWeightMutexAtomicInt(const _LightWeightMutexAtomicInt&);

public:

	_LightWeightMutexAtomicInt() :locked(false){}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void Lock(){
		int expected = 0;
		while (locked.compare_exchange_weak(expected, 1, memoryOrder) != true){
			std::mutex dummy;
			std::unique_lock<std::mutex> lk(dummy);
			auto now = std::chrono::system_clock::now();
			this->condition.wait_until(lk, now + std::chrono::milliseconds(1000), [&](){return locked == false; });
		}
	}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void UnLock(){
		locked.store(0, memoryOrder);
	}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void lock(){
        this->template Lock<memoryOrder>();
	}

	template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void unlock(){
		this->template UnLock<memoryOrder>();
	}

};

class _LightWeightMutexAtomicBool{

	std::atomic<bool> locked;
	std::condition_variable condition;

    _LightWeightMutexAtomicBool(const _LightWeightMutexAtomicBool&);

public:

	_LightWeightMutexAtomicBool() :locked(false){}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void Lock(){
		bool expected = false;
		while (locked.compare_exchange_weak(expected, true, memoryOrder) != true){
			std::mutex dummy;
			std::unique_lock<std::mutex> lk(dummy);
			auto now = std::chrono::system_clock::now();
			this->condition.wait_until(lk, now + std::chrono::milliseconds(1000), [&](){return locked == false; });
		}
	}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void UnLock(){
		locked.store(false, memoryOrder);
	}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void lock(){
        this->template Lock<memoryOrder>();
	}

	template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void unlock(){
		this->template UnLock<memoryOrder>();
	}

};


class _LightWeightMutexAtomicFlag{

	std::atomic_flag locked;

	std::condition_variable condition;

    _LightWeightMutexAtomicFlag(const _LightWeightMutexAtomicFlag&);

public:

	_LightWeightMutexAtomicFlag() {
	    this->locked.clear();
    }

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void Lock(){
		bool shouldBreak = false;
		while ( this->locked.test_and_set(memoryOrder) != false){

			std::mutex dummy;
			std::unique_lock<std::mutex> lk(dummy);

			this->condition.wait_until(lk, std::chrono::system_clock::now() + std::chrono::seconds(5), [&](){
                if(locked.test_and_set()==true){
                    return false;
                }
                shouldBreak = true;
                return true;
            });

            if(shouldBreak)
                break;
		}
	}

    template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void UnLock(){
		this->locked.clear(memoryOrder);
	}

	template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void lock(){
        this->template Lock<memoryOrder>();
	}

	template<std::memory_order memoryOrder = std::memory_order_seq_cst>
	void unlock(){
		this->template UnLock<memoryOrder>();
	}

};

template<std::memory_order memoryOrder = std::memory_order_seq_cst>
class _LightWeightMutexLockGuard{
    _LightWeightMutex& lightMutex;
public:
    _LightWeightMutexLockGuard(_LightWeightMutex& io_mutex):lightMutex(io_mutex){
        lightMutex.Lock<memoryOrder>();
    }
    ~_LightWeightMutexLockGuard(){
        lightMutex.UnLock<memoryOrder>();
    }
};

}} // namespace rlib::lockfree


#endif // RLF_PRIVATE_LIGHTWEIGHTMUTEX_H
