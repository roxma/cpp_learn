#include <iostream>
#include <sstream>
#include <string>

void UpdateProgress(std::ostream& o, size_t current, size_t total, int bars = 50){
    o<<'\r';
    o<<"[";
    size_t percents = current*100/total;
    for(int i=0; i<bars; ++i){
        if((i+1)*100/bars<=percents){
            o<<'|';
        }else{
            o<<' ';
        }
    }
    o<<"] ";

    std::ostringstream ossTotal;
    ossTotal<<total;
    std::string strTotal = ossTotal.str();

    std::ostringstream ossCurrent;
    ossCurrent<<current;
    std::string strCurrent = ossCurrent.str();
    for(int i=0; strCurrent.length()<strTotal.length();) strCurrent = ' ' + strCurrent;


    std::ostringstream oss;
    oss<<"["<<strCurrent
        <<"] / ["<<strTotal<<"]";
    std::string str = oss.str();

    o<<str;
}

#include <chrono>
#include <thread>
using namespace std;

int main(){
    cout<<"hello world"<<endl;
    int cnt = 40;
    for(int i=0; i<cnt; ++i){
        auto start_time = std::chrono::steady_clock::now();
        auto end_time = start_time + chrono::milliseconds(100);
        std::this_thread::sleep_until(end_time);
        UpdateProgress(std::cout,(i+1),cnt,50);
    }
}
