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
 
#include <time.h>
 
int main(void)
{
 
	vector<char> buffer(1000000);

	int socketFd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if ( socketFd == -1) {
		return __LINE__;
    }

	struct sockaddr_in serverAddr;
    memset((char *) &serverAddr, 0, sizeof(serverAddr));
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(1234);
	serverAddr.sin_addr.s_addr = htonl(INADDR_ANY);

    int bindResult = bind(socketFd, (struct sockaddr*)&serverAddr, sizeof(serverAddr));
    if ( bindResult != 0) {
		return __LINE__;
    }
 
	struct sockaddr_in clientAddr;
	socklen_t  clientAddrLen = sizeof(clientAddr);
	int recvLen = recvfrom(socketFd, &(buffer[0]), buffer.size(), 0, (struct sockaddr *) &clientAddr, &clientAddrLen);
	if(recvLen<0){
		cout<<"recvLen="<<recvLen<<endl;
		return __LINE__;
	}

	cout<<"recvLen="<<recvLen<<endl;
	int check = 0;
	for(size_t i=0; i< recvLen; ++i){
		check ^= buffer[i];
	}
	cout<<"check="<<check<<endl;


	
	int sendToRet = sendto(socketFd, "hello", 6, 0 , (struct sockaddr *)&clientAddr, sizeof(clientAddr));

    close(socketFd);

    return 0;
}

int Receive();

