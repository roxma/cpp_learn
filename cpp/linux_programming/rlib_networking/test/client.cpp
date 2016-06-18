
#include "rlibns/networking/UdpClient.h"

#include <iostream>

int main(){

	rlibns::networking::UdpClient client;

	int openErr = client.Open("127.0.0.1",1234);
	std::cout<<"openErr="<<openErr<<std::endl;

	int sendErr = client.Send("haha",4);
	std::cout<<"sendErr="<<sendErr<<std::endl;

	std::string ip;
	short port;

	char buffer[30] = {0};
	size_t length = 30-1;
	size_t recvLength = 0;
	int recvErr = client.Receive(buffer, length, &recvLength, &ip, &port);

	std::cout<<"recvErr="<<recvErr<<std::endl
		<<"recvLength="<<recvLength<<std::endl
		<<"ip="<<ip<<std::endl
		<<"port="<<port<<std::endl
		<<"buffer: "<<buffer<<std::endl;

	
	return 0;
}

