/*
    Simple udp client
    Silver Moon (m00n.silv3r@gmail.com)
*/
#include<stdio.h> //printf
#include<string.h> //memset
#include<stdlib.h> //exit(0);
#include<arpa/inet.h>
#include<sys/socket.h>

#include <cstdlib>

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;
 
#define SERVER "127.0.0.1"
#define BUFLEN 10000  //Max length of buffer
#define PORT 1234   //The port on which to send data
 
#include <time.h>
 

int UdpSend(const std::string& host, int port, const char* buffer, size_t length, size_t* sendedLength);

int main(void)
{
	srand(time(NULL));

	int check = 0;
	vector<char> buffer(BUFLEN);
	for(size_t i=0; i<buffer.size(); ++i){
		buffer[i] = rand();
		check ^= buffer[i];
	}
	cout<<"check="<<check<<endl;

	size_t sended = 0;
	int errorCode = UdpSend(SERVER, PORT, &(buffer[0]), buffer.size(), &sended);

	if(errorCode){
		std::cout<<"errorCode="<<errorCode<<std::endl;
	}

	std::cout<<"sendedLength="<<sended<<std::endl;

    return 0;
}

int UdpSend(const std::string& host, int port, const char* buffer, size_t length, size_t* sendedLength){

	*sendedLength = 0;

	int socketFd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if ( socketFd == -1) {
		return __LINE__;
	}
	struct FdAutoClose{ int fd; FdAutoClose(int r_fd){fd=r_fd;} ~FdAutoClose(){close(this->fd);}}fdAutoClose(socketFd);

	struct sockaddr_in addr;
	memset((char *) &addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;

	addr.sin_port = htons(port);

	int atonResult = inet_aton(host.c_str() , &addr.sin_addr);
	if ( atonResult == 0) {
		return __LINE__;
	}

	int sendToRet = sendto(socketFd, &(buffer[0]), length, 0 , (struct sockaddr *) &addr, sizeof(addr));
	if( sendToRet < 0){
		return sendToRet;
	}

	*sendedLength = sendToRet;
	return 0;
}




