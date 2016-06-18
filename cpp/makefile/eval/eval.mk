
# make -f eval.mk
# make -f eval.mk hello

define func
include hello.mk
endef

all:
	@echo all

$(eval $(call func))

