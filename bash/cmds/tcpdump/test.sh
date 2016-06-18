

# for ((; 1 < 2; )); do sleep 2 ;  udpsend -h localhost -p 1234 -d 123 ; done


# -X
#	show content in hex format and ASCII format
# -i any
#	monitoring any interface
# port 1234
#	both udp port 1234 and tcp port 1234
# -nn
#	don't resolve host name and port name
tcpdump -X -nn -i any port 1234

