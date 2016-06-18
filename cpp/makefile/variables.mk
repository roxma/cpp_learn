
all: MSG += hello

all:
	@echo $(MSG)
	@echo "$(.VARIABLES)"
	@echo "$_"

all: MSG += world

