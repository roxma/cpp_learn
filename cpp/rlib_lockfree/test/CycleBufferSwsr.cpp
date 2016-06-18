#include <thread>
#include <mutex>
#include <string>
#include <iostream>
#include <chrono>
#include <sstream>
using namespace std;

#include "rlib/lockfree/CycleBufferSwsr.h"
#include "rlib/lockfree/_LightWeightMutex.h"
using namespace rlib::lockfree;

template<typename Mutex>
void test(size_t cnt, Mutex& writerMutex, Mutex& readerMutex){

    CycleBufferSwsr buffer(2*cnt);

    for(size_t i=0; i<cnt; ++i){ // ensure there's enough data to read
        char value=1;
        while(atomic<bool>((buffer.WriterPush(&value,1)))!=true);
    }

    auto before = std::chrono::system_clock::now();

    thread writer([&](){
        char value = 1;
        try{
        for(size_t i=0; i<cnt; ++i){
            writerMutex.lock();
            while(atomic<bool>((buffer.WriterPush(&value,1)))!=true);
            writerMutex.unlock();
        }}catch(...){
            cout<<"exception"<<endl;
        }
    });

    thread reader([&](){
        char value = 0;
        try{
        for(size_t i=0; i<cnt; ++i){
            readerMutex.lock();
            while(atomic<bool>((buffer.ReaderPop(&value,1)))!=true);
            readerMutex.unlock();
        }}catch(...){
            cout<<"exception"<<endl;
        }
    });

    writer.join();
    reader.join();

    auto after =  std::chrono::system_clock::now();

    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
    std::cout<<"Mutex name:"<< typeid(Mutex).name()<<std::endl
            << (((&writerMutex)==(&readerMutex)) ? "Lock." : "Lock-free") <<std::endl
            <<"cnt: "<<cnt<<std::endl
            <<"time: "<<micros / 1000000.0 <<" seconds" << std::endl
            <<std::endl;
}

void CycleBufferSwsrPerformanceTest(){

    size_t cnt = 2000000;

    std::mutex mutex1;
    std::mutex mutex2;

    test(cnt,mutex1,mutex1); // lock
    test(cnt,mutex1,mutex2); // lockfree

    _LightWeightMutex lightMutex1;
    _LightWeightMutex lightMutex2;

    test(cnt,lightMutex1,lightMutex1); // lock
    test(cnt,lightMutex1,lightMutex2); // lockfree

    return;
}

int main(){

    CycleBufferSwsrPerformanceTest();
    void CycleBufferSwsrLogicTest();
    CycleBufferSwsrLogicTest();
    return 0;
}

class CycleBufferSwsr::Tester{
public:
	static void PrintBuffer(CycleBufferSwsr& buffer){
		cout << "printing buffer:" << endl;
		// cout << "[" << buffer.buffer.get() << "]" << endl;

		ostringstream line1;
		ostringstream line2;
		ostringstream line3;
		ostringstream line4;
		ostringstream line5;

		line1 << "content   :";
		line2 << "ascii     :";
		line3 << "read pos  :";
		line4 << "write pos :";
		line5 << "readable  :";

		for (size_t i = 0; i < buffer.capacity; ++i){

			unsigned char val = (unsigned char)(buffer.buffer[i]);

			line1 << " ";
			line1 << hex << int(val % 16) << int(val / 16);

			char ascii = ' ';

			if (isprint(val)){
				ascii = buffer.buffer[i];
			}
			line2 << " " << ascii << " ";

			if (buffer.readPos == i){
				line3 << " * ";
			}
			else{
				line3 << "   ";
			}

			if (buffer.writePos == i){
				line4 << " * ";
			}
			else{
				line4 << "   ";
			}

			if (buffer.readableCount + buffer.readPos >= buffer.capacity){
				if ((i >= buffer.readPos) || (i < (buffer.readPos + buffer.readableCount) % buffer.capacity)){
					line5 << " * ";
				}
				else{
					line5 << "   ";
				}
			}
			else if (((i >= buffer.readPos) && (i < (buffer.readPos + buffer.readableCount)))) {
				line5 << " * ";
			}
			else{
				line5 << "   ";
			}

		}

		cout
			<< line1.str() << endl
			<< line2.str() << endl
			<< line3.str() << endl
			<< line4.str() << endl
			<< line5.str() << endl;

		cout << "cnt       :" << buffer.readableCount << endl;

		cout << endl;


	}

	static void ReadSome(CycleBufferSwsr& buffer){
		cin.clear();
		cout << "Enter the read count:";
		int readCnt;
		cin >> readCnt;
		unique_ptr<char[]> readBuf(new char[readCnt + 1]);
		readBuf[readCnt] = 0;

		bool success = buffer.ReaderPop(readBuf.get(), readCnt);
		cout << "result:" << (success ? "success" : "failed") << endl;
		cout << "read: [" << readBuf.get() << "]" << endl;
	}

	static void WriteSome(CycleBufferSwsr& buffer){
		cin.clear();
		cout << "Enter characters to write:";
		std::string toWrite;
		cin >> toWrite;
		bool success = buffer.WriterPush(toWrite.c_str(), toWrite.length());
		cout << "Write cout:" << toWrite.length() << ", result:" << (success ? "success" : "failed") << endl;
	}

	static void Entry(){
		CycleBufferSwsr buff;
		buff.ReInit(10);
		while (1){
			cin.clear();
			cout << "what do you want? 1 for write, 2 for read, and 3 for print, and 4 for exit.";
			int cmd;
			cin >> cmd;
			switch (cmd){
			case 1: CycleBufferSwsr::Tester::WriteSome(buff); break;
			case 2: CycleBufferSwsr::Tester::ReadSome(buff); break;
			case 3: CycleBufferSwsr::Tester::PrintBuffer(buff); break;
			}
			if (cmd == 4)
				break;
		}
	}
};

void CycleBufferSwsrLogicTest(){
    CycleBufferSwsr::Tester::Entry();
}
