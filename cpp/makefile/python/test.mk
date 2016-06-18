
define pythonCode
print "hello"
endef

define PrintMessagePy
if 1:
	print "$(1)"
endef

all:
	@echo $(shell python -c '$(pythonCode)')
	@echo $(shell python -c '$(call PrintMessagePy,hello world)')

