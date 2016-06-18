
# make -f recursive_eval.mk

define funca
COUNT_A := $$(COUNT_A)a
$$(eval $$(if $$(findstring aaaaaa,$$(COUNT_A)),,$$(call funca)))
endef

$(eval $(call funca))

define funcb
COUNT_B := $(COUNT_B)b
$(eval $(if $(findstring bbbbbb,$(COUNT_B)),,$(value funcb)))
endef

$(eval $(value funcb))

all:
	@echo $(COUNT_A)
	@echo $(COUNT_B)
	@echo all done


