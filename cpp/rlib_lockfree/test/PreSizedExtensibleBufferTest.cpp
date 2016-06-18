#include <stddef.h>

#include <streambuf>
#include <vector>
#include <algorithm>

template<size_t preSize, typename _CharT=char, typename _Traits= std::char_traits<_CharT>, typename _Alloc= std::allocator<_CharT>>
class PreSizedExtensibleBuffer: public std::basic_streambuf<_CharT, _Traits>
{
	typedef  _Traits traits_type;

	typedef typename traits_type::int_type int_type;

protected:

	virtual int_type overflow(int_type c)
	{
		using namespace std;
		if (c == traits_type::eof()){
			return traits_type::not_eof(c);
		}

		if (this->isFirstPut.value){ // first put
			this->isFirstPut.value = false;
			this->buffer[0] = traits_type::to_char_type(c);
			this->setp(buffer, buffer + bufferSize);
			return this->sputc(traits_type::to_char_type(c));
		}

		if (this->pbase() == this->buffer) { // second put

            size_t dataSize = this->bufferSize+1;
            this->more.resize( dataSize );
            for(size_t i=0; i<bufferSize; ++i){
                this->more[i] = this->buffer[i];
            }
			this->more[dataSize-1] = traits_type::to_char_type(c);

			this->more.resize( this->more.capacity() );
			this->setp(this->more.data() + dataSize, this->more.data() + this->more.size());
			return c;
		}

		auto oldPos = this->more.size();

		// more put
		more.push_back(traits_type::to_char_type(c));
		this->more.resize( this->more.capacity() );
		this->setp(this->more.data() + oldPos + 1, this->more.data() + this->more.size());
		return c;
	}

private:

	struct IsFirstPut{
		bool value;
		IsFirstPut(){ value = true; }
	}isFirstPut;

	enum{
		bufferSize = preSize
	};
	_CharT buffer[bufferSize];
	std::vector<_CharT,_Alloc> more;

public:

    size_t size() const{
        if (this->isFirstPut.value==true){ // never put before
            return 0;
        }
        if (this->pbase() == this->buffer){ // only use buffer
            return (this->pptr() - this->pbase());
        }
        return this->pptr() - this->more.data();
    }

    const _CharT* data() const{
        if (this->isFirstPut.value==true){ // never put before
            return buffer;
        }
        if (this->pbase() == this->buffer){ // only use buffer
            return buffer;
        }
        return this->more.data();
    }

};

#include <sstream>
#include <iostream>

#include <atomic>
#include <thread>
#include <chrono>
#include <condition_variable>

#include <thread>
#include <atomic>

using namespace std;

void ConcurrenceTestFun_OssOptimized(size_t i_cnt, const std::string* i_pStr){
    for(size_t i=0; i<i_cnt; ++i){
        PreSizedExtensibleBuffer<512> buf;
        std::basic_ostream<char> ossOptimized(&buf);

        ossOptimized<<*i_pStr;
        size_t size = buf.size(); (volatile void)size;
        const char* mem = buf.data(); (volatile void)mem;
    }
}

void ConcurrenceTestFun_Oss(size_t i_cnt, const std::string* i_pStr){
    for(size_t i=0; i<i_cnt; ++i){
        std::ostringstream oss;
        oss<<*i_pStr;
        //string tmp = oss.str(); (volatile void)tmp;
    }
}

void PreSizedExtensibleBufferTest()
{
    {
	PreSizedExtensibleBuffer<5> buf;
	std::basic_ostream<char> oss(&buf);

    cout << "size=" << buf.size()<< endl;
    cout << "data=" << (void*)buf.data() <<endl;
    for(int i=0; i<20; ++i){

        oss<< char('0'+i%10);

        cout << "size=" << buf.size()<< endl;
        cout << "data=" << (void*)buf.data() <<endl;

        cout<<"values[";
        for(size_t j=0; j<buf.size(); ++j){
            cout<<buf.data()[j];
        }
        cout<<"]"<<endl;
    }
    cout<<endl;
    }

    {
    cout<<"performance test begin";
    size_t cnt = 1000000;
    size_t stringSize = 500;
    std::string s;
    for(size_t i=0; i<stringSize; ++i){
        s += ('1');
    }

    {
    auto before = std::chrono::system_clock::now();
    ConcurrenceTestFun_OssOptimized(cnt,&s);
    auto after =  std::chrono::system_clock::now();
    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
    std::cout
        <<"ConcurrenceTestFun_OssOptimized:"<<std::endl
        <<"cnt="<<cnt<<std::endl
        <<"micros="<<micros<<std::endl
        <<std::endl;
    }

    {
    auto before = std::chrono::system_clock::now();
    ConcurrenceTestFun_Oss(cnt,&s);
    auto after =  std::chrono::system_clock::now();
    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
    std::cout
        <<"ConcurrenceTestFun_Oss:"<<std::endl
        <<"cnt="<<cnt<<std::endl
        <<"micros="<<micros<<std::endl
        <<std::endl;
    }
    }
    cout<<endl;

    {
    cout<<"Concurrency test begin";
    size_t cnt = 1000000;
    size_t threadCnt = 4;
    size_t stringSize = 500;
    std::string s;
    for(size_t i=0; i<stringSize; ++i){
        s += ('1');
    }

    atomic<bool> shouldExit (false);
    thread other([&](){ while(!shouldExit){int* a = new int[1000]; int* b = new int[1000];  delete[] b; delete[] a;}} );

    {
    auto fun = [&](){ConcurrenceTestFun_OssOptimized(cnt,&s);};
    std::vector<thread> threads; threads.reserve(threadCnt);
    auto before = std::chrono::system_clock::now();
    for(size_t i=0; i< threadCnt; ++i){
        threads.push_back(thread(fun));
    }
    for(size_t i=0; i< threadCnt; ++i){
        threads[i].join();
    }
    auto after =  std::chrono::system_clock::now();
    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
    std::cout
        <<"ConcurrenceTestFun_OssOptimized:"<<std::endl
        <<"cnt="<<cnt<<std::endl
        <<"micros="<<micros<<std::endl
        <<std::endl;
    }

    {
    auto fun = [&](){ConcurrenceTestFun_Oss(cnt,&s);};
    std::vector<thread> threads; threads.reserve(threadCnt);
    auto before = std::chrono::system_clock::now();
    for(size_t i=0; i< threadCnt; ++i){
        threads.push_back(thread(fun));
    }
    for(size_t i=0; i< threadCnt; ++i){
        threads[i].join();
    }
    auto after =  std::chrono::system_clock::now();
    auto micros = std::chrono::duration_cast<std::chrono::microseconds>(after-before).count();
    std::cout
        <<"ConcurrenceTestFun_Oss:"<<std::endl
        <<"cnt="<<cnt<<std::endl
        <<"micros="<<micros<<std::endl
        <<std::endl;
    }

    shouldExit = true;
    other.join();
    }
    cout<<endl;
}
