#ifndef RLIBNS_NETWORKING_UDPSOCKET_H
#define RLIBNS_NETWORKING_UDPSOCKET_H

/**
 * @author roxma
 */

#include<string.h>		//memset
#include <unistd.h>		// close
#include<arpa/inet.h>
#include<sys/socket.h>

#include <string>


namespace rlibns{ namespace networking{

class UdpClient{

public:

	UdpClient() { DefaultInit(); }

	~UdpClient(){ if(m_socketFd!=-1) close(m_socketFd); }

	bool IsOpen() { return m_socketFd!=-1; }

	int Open(const std::string& i_host, short i_port);

	int Send(const char* i_buffer, size_t i_bufferLength);

	/**
	 * Receive a UDP package from the socket. No matter who sent the package.
	 */
	int Receive(char* o_buffer, size_t i_maxLength, size_t* o_recvLength, std::string* o_remoteIp=NULL, short* o_remotePort = NULL);

private:

	int m_socketFd;
	struct sockaddr_in m_addr;

	void DefaultInit() { m_socketFd = -1; }

}; // class UdpClient

}} // namespace rlibns::networking


/////////////////////////////////
// inline members implementations

namespace rlibns{ namespace networking{

inline 
int rlibns::networking::UdpClient::Open(const std::string& i_host, short i_port){

	if(IsOpen()) return 0;

	memset((char *) &m_addr, 0, sizeof(m_addr));
	m_addr.sin_family = AF_INET;

	m_addr.sin_port = htons(i_port);

	int atonResult = inet_aton(i_host.c_str() , &(m_addr.sin_addr) );
	if ( atonResult == 0) {
		return __LINE__;	// host to ip error
	}

	m_socketFd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if ( m_socketFd == -1) {
		return __LINE__; // open socket error
	}

	return 0;
}

inline
int rlibns::networking::UdpClient::Send(const char* i_buffer, size_t i_bufferLength){

	if( !IsOpen() ) return __LINE__;

	int sendToRet = sendto(m_socketFd, &(i_buffer[0]), i_bufferLength, 0 , (struct sockaddr *)&m_addr, sizeof(m_addr));
	if( sendToRet < 0){
		return sendToRet;
	}

	return 0;
}

int rlibns::networking::UdpClient::Receive(char* o_buffer, size_t i_maxLength, size_t* o_recvLength, std::string* o_remoteIp, short* o_remotePort){

	if( !IsOpen() ) return __LINE__;
	if(o_buffer==NULL) return __LINE__;

	struct sockaddr_in clientAddr;
	socklen_t  clientAddrLen = sizeof(clientAddr);

	int recvLen = recvfrom(m_socketFd, &(o_buffer[0]), i_maxLength, 0, (struct sockaddr *) &clientAddr, &clientAddrLen);
	if(recvLen<0){
		return recvLen;
	}

	if(o_recvLength)
		*o_recvLength = recvLen;

	if(o_remoteIp){
		*o_remoteIp = inet_ntoa(clientAddr.sin_addr);
	}
	if(o_remotePort){
		*o_remotePort = ntohs(clientAddr.sin_port);
	}

	return 0;
}

}}

// inline members implementations
/////////////////////////////////

#endif

