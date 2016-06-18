#include <mutex>
#include <chrono>
#include <iostream>

#ifdef _WIN32
    #include <windows.h>
#endif

#include "rlib/lockfree/_LightWeightMutex.h"
using namespace rlib::lockfree;

template<typename M,std::memory_order memoryOrder = std::memory_order_seq_cst>
class MyLockGuard{
    M& mtx;
public:
    MyLockGuard(M& io_mutex):mtx(io_mutex){
         mtx.template Lock<memoryOrder>();
    }
    ~MyLockGuard(){
        mtx.template UnLock<memoryOrder>();
    }
};

template <typename M> static
void TestMutex(uint32_t cnt ){
    M mtx;
    auto before = std::chrono::system_clock::now();

    for(uint32_t i=0; i<cnt; ++i){
        MyLockGuard<M,std::memory_order::memory_order_relaxed> guard(mtx);
    }

    auto after =  std::chrono::system_clock::now();

    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();

    std::cout
            <<typeid(M).name()<<std::endl
            <<"cnt: "<<cnt<<std::endl
            <<"time: "<<micros /  1000000.0 << "seconds" <<std::endl
            <<std::endl;
}

void BasicTest(uint32_t cnt){
    {
        std::mutex mtx;
        auto before = std::chrono::system_clock::now();
        for(uint32_t i=0; i<cnt; ++i){
            mtx.lock();
            mtx.unlock();
        }
        auto after =  std::chrono::system_clock::now();

        auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
        std::cout
                <<"std::mutex:"<<std::endl
                <<"cnt: "<<cnt<<std::endl
                <<"time: "<<micros /  1000000.0 << "seconds" <<std::endl
                <<std::endl;
    }

    {
        auto before = std::chrono::system_clock::now();
        CRITICAL_SECTION section;
        InitializeCriticalSection(&section);
        for(uint32_t i=0; i<cnt; ++i){
            EnterCriticalSection(&section);
            LeaveCriticalSection(&section);
        }
        auto after =  std::chrono::system_clock::now();

        auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
        std::cout
                <<"CRITICAL_SECTION:"<<std::endl
                <<"cnt: "<<cnt<<std::endl
                <<"time: "<<micros /  1000000.0 << "seconds" <<std::endl
                <<std::endl;
    }
}

void LightWeightMutexTest()
{
    uint32_t cnt = 4000000;

    BasicTest(cnt);

    for(int i=0; i<1; ++i){
        TestMutex<_LightWeightMutexAtomicFlag>(cnt);
        TestMutex<_LightWeightMutexAtomicBool>(cnt);
        TestMutex<_LightWeightMutexAtomicInt>(cnt);
    }

    return  ;
}

int main(){
    LightWeightMutexTest();
}
