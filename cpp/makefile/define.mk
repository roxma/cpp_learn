
# if using gnu make version 3.8.2 or greater, use 'define canned ='
define canned
echo hello world
endef


all:
	$(canned)

