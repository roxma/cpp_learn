# author       : roxma
# version      : 6
# Descriptions : A generic makefiles under linux, to help you build 
#                your c/c++ programs easily without writing a long 
#                long tedious makefile.
# github       : https://github.com/roxma/easymake

# Execute "make show" for debug information.

# basic settings

SETTINGS_ROOT?=build_settings
# do not use ./bin
BUILD_ROOT?=bin
# TARGET=
# VPATH=

CPPEXT?=cpp
CEXT?=c
GCC?=gcc
GXX?=g++
LINKER?=g++

################################################################

##
# A function to Check whether a string is begin with a non-empty 
# substring. If not, the result is empty string. Otherwise the result 
# is the substring.
# @param 1 substring to begin with
# @param 2 source string
BeginWith=$(if $(2),$(if $(patsubst $(1)%,,$(2)),,$(1)),)

##
# A function to read settings from a text file. Any line begin with
# a '#' character will be treated as comment and ommitted. Others
# will be in the result.
# $(call ReadSettings, $(file_name))
ReadSettings=$(shell if [ -f $(1) ]; then grep -v "^\#" $(1); fi;)

##
# A function to read the n-th line of a text file.
# $(call ReadLine, fine_name, line_num)
ReadLine=$(shell if [ -f $(1) ]; then sed -n $(2)p $(1); fi;)

## 
# @param 1 The word to find.
# @param 2 list of words
WordExist=$(strip $(foreach word,$(2),$(if $(patsubst $(strip $(1)),,$(strip $(word))),,$(1))))

##
# @param 1 A sub-word.
# @param 2 list of words.
# @param 3 error to show if no matched. If empty, this parameter has no
#   effect.
SelectFirstMatch=$(if $(word 1,$(foreach word,$(2),$(if $(findstring $(1),$(word)),$(word),) )),$(word 1,$(foreach word,$(2),$(if $(findstring $(1),$(word)),$(word),) )),$(if $(3),$(error $(3)),))

##
# Check if the file exists
# # @param 1 The file name
# # @note A name with $(VPATH) as base will fail here
FileExist=$(if $(wildcard $(1)),yes,)

##
# Search the path of the files, if a file name is based on $(VPATH), Then the
# corresopnding result of that element will be $(VPATH)/$(1)
# @param 1 A list of file name
SearchFilePath=$(foreach file,$(1),$(if $(call FileExist,$(file)),$(file),$(foreach vpathDir,$(VPATH),$(if $(call FileExist,$(vpathDir)/$(file)),$(vpathDir)/$(file)))))

##
# @param 1 Entry name
GetEntryPath4Timestamp=$(if $(call SearchFilePath,$(1)),$(call SearchFilePath,$(1)),$(shell if [ ! -f $(BUILD_ROOT)/easy_make_entry_timestamp_$(1) ]; then  touch $(BUILD_ROOT)/easy_make_entry_timestamp_$(1); fi)$(BUILD_ROOT)/easy_make_entry_timestamp_$(1))

##
# If the user specifies $(ENTRY), and the $(ENTRY) is not a file, update its 
# timestamp
ifneq ($(ENTRY),)
ifeq ($(strip $(call SearchFilePath,$(ENTRY))),)
    $(shell mkdir -p $(dir $(BUILD_ROOT)/easy_make_entry_timestamp_$(ENTRY)))
    $(shell  touch $(BUILD_ROOT)/easy_make_entry_timestamp_$(ENTRY))
endif
endif

##
# Get the file with the newest timestamp
# @param 1 A list of files
# @return The index of files in the list
GetNewestFileIndex=$(shell newestIndex=1 && index=1 && newest=$(call GetEntryPath4Timestamp,$(word 1,$(1))) && for file in $(foreach file,$(1),$(call GetEntryPath4Timestamp,$(file)) ) ; do if [ $$file -nt $$newest ] ; then newest=$$file; newestIndex=$$index; fi; let index+=1; done && echo $$newestIndex)

##
# A function to decide the actual entry file.
# @param 1 entry
# @param 2 entry_list
# @param 3 error message if this function failed. If the entry is neither
# empty nor in the entry_list.
GetEntry=$(if $(1),$(if $(call WordExist,$(1),$(2)),$(1),$(call SelectFirstMatch,$(1),$(2),$(3))),$(word $(call GetNewestFileIndex,$(2)),$(2)))

##
# Filter-out the sources that will not finally be linked into the target.
# @param 1 SOURCES 
# @param 2 ENTRY 
# @param 3 ENTRY_LIST
SourcesToLink=$(filter-out $(filter-out $(2),$(3)), $(1))

##
# @param 1 sources
# @param 2 build_root
# @param 3 source file extension
CorrendingObjects=$(foreach _src,$(1),$(2)/$(_src:.$(3)=.o))

##
# Recursive wildcard
RWildcard=$(foreach d,$(wildcard $1*),$(call RWildcard,$d/,$2) $(filter $(subst *,%,$2),$d))


# A list of directories where compiler search for headers.
COMPILE_SEARCH_PATH += $(call ReadSettings,$(SETTINGS_ROOT)/compile_search_path) . $(VPATH)

COMPILE_FLAGS += $(call ReadSettings, $(SETTINGS_ROOT)/compile_flags)

LINK_SEARCH_PATH += $(call ReadSettings, $(SETTINGS_ROOT)/link_search_path)

LINK_FLAGS += $(call ReadSettings, $(SETTINGS_ROOT)/link_flags)

easy_make_f_info:=$(BUILD_ROOT)/easy_make_current_entry_file

prev_entry:=$(call ReadLine,$(easy_make_f_info),1)
prev_target:=$(call ReadLine,$(easy_make_f_info),2)
# If $(ENTRY) is set by user, store it to file $(easy_make_f_info).
# Otherwise, use the previous entry by default.
ifneq (,$(ENTRY))
    $(shell mkdir -p $(dir $(easy_make_f_info)))
    $(shell echo "$(ENTRY)" > $(easy_make_f_info))
    $(shell echo "$(prev_target)" >> $(easy_make_f_info))
else
#    ENTRY:=$(prev_entry)
endif


# For unit testing, a list of source files that contains the main function.
# by default, only the first file will be in the $(SOURCES) list, others will 
# be filter out
ENTRY_LIST += $(call ReadSettings,$(SETTINGS_ROOT)/entry_list)

# read the previous settings for 'TARGET', if empty, set to 'target'
TARGET?=$(call ReadLine,$(easy_make_f_info),2)
ifeq (,$(strip $(TARGET)))
    TARGET:=target
endif


################################################################

ifneq (,$(call BeginWith,./,$(BUILD_ROOT)))
    # "./" in BUILD_ROOT may cause entry detecting problem.
    $(error Please don't use prefix "./" in variable BUILD_ROOT=$(BUILD_ROOT))
endif

# if CPPSOURCES are not specified, automatically scan all .$(CPPEXT) files in the 
# current directories.
ifeq ($(strip $(CPPSOURCES)),)
    CPPSOURCES:=$(call RWildcard,,*.$(CPPEXT)) $(foreach dir,$(VPATH),$(foreach src,$(call RWildcard,$(dir),*.$(CPPEXT)),$(src:$(dir)/%=%)))
    CPPSOURCES:=$(strip $(CPPSOURCES))
endif
ifneq (,$(findstring ..,$(CPPSOURCES)))
    $(error ".." should not appear in the cpp source list: $(CPPSOURCES))
endif
# delete "./" in file path, which may cause dependency problems.
CPPSOURCES:=$(subst ./,,$(CPPSOURCES)) 

# if CSOURCES are not specified, automatically scan all .$(CEXT) files in the 
# current directories.
ifeq ($(strip $(CSOURCES)),)
    CSOURCES:=$(call RWildcard,,*.$(CEXT)) $(foreach dir,$(VPATH),$(foreach src,$(call RWildcard,$(dir),*.$(CEXT)),$(src:$(dir)/%=%)))
    CSOURCES:=$(strip $(CSOURCES))
endif
ifneq (,$(findstring ..,$(CSOURCES)))
    $(error ".." should not appear in the c source list: $(CSOURCES))
endif
# delete "./" in file path, which may cause dependency problems.
CSOURCES:=$(subst ./,,$(CSOURCES))


easy_make_all_cppobjects:=$(call CorrendingObjects,$(CPPSOURCES),$(BUILD_ROOT),$(CPPEXT))
easy_make_all_cobjects:=$(call CorrendingObjects,$(CSOURCES),$(BUILD_ROOT),$(CEXT))
easy_make_target:=$(BUILD_ROOT)/$(TARGET)
# $(easy_make_f_detected_entries) - A file that contains a list of entries detected by easy_make.
easy_make_f_detected_entries:=$(BUILD_ROOT)/easy_make_detected_entries

# The file $(easy_make_f_info) would be updated when making $(easy_make_target).
.PHONY:all
all:$(easy_make_target)
	@echo "BUILD_ROOT/TARGET: $(easy_make_target)"
	@echo "ENTRY: $(call ReadLine,$(easy_make_f_info),1)"


# clean all .o .d .a .so files and the target recursively in the BUILD_ROOT
.PHONY: clean
clean:
	rm -f $$(find $(BUILD_ROOT) -name *.o)
	rm -f $$(find $(BUILD_ROOT) -name *.d)
	rm -f $$(find $(BUILD_ROOT) -name *.a)
	rm -f $$(find $(BUILD_ROOT) -name *.so)
	rm -f $$(find $(BUILD_ROOT) -name *.out)
	rm -f $(easy_make_target)

.PHONY: help show
help:show
# show variables in this make file
show:
	@echo "---------------------"
	@echo "basic settings:"
	@echo "SETTINGS_ROOT       : $(SETTINGS_ROOT)"
	@echo "BUILD_ROOT          : $(BUILD_ROOT)"
	@echo "TARGET              : $(TARGET)"
	@echo "VPATH               : $(VPATH)"
	@echo "CPPEXT              : $(CPPEXT)"
	@echo "CEXT                : $(CEXT)"
	@echo "GCC                 : $(GCC)"
	@echo "GXX                 : $(GXX)"
	@echo "LINKER              : $(LINKER)"
	@echo "---------------------"
	@echo "user settings files:"
	@echo "$(SETTINGS_ROOT)/entry_list"
	@echo "$(SETTINGS_ROOT)/compile_flags"
	@echo "$(SETTINGS_ROOT)/compile_search_path"
	@echo "$(SETTINGS_ROOT)/link_flags"
	@echo "$(SETTINGS_ROOT)/link_search_path"
	@echo "---------------------"
	@echo "user settings:"
	@echo "ENTRY_LIST          : $(ENTRY_LIST)"
	@echo "ENTRY               : $(ENTRY)"
	@echo "COMPILE_FLAGS       : $(COMPILE_FLAGS)"
	@echo "COMPILE_SEARCH_PATH : $(COMPILE_SEARCH_PATH)"
	@echo "LINK_FLAGS          : $(LINK_FLAGS)"
	@echo "LINK_SEARCH_PATH    : $(LINK_SEARCH_PATH)"
	@echo "CPPSOURCES          : $(CPPSOURCES)"
	@echo "CSOURCES            : $(CSOURCES)"
	@echo "---------------------"
	@echo "internal informations:"
	@echo "easy_make_target           : $(easy_make_target)"
	@echo "easy_make_all_cppobjects   : $(easy_make_all_cppobjects)"
	@echo "easy_make_all_cobjects     : $(easy_make_all_cobjects)"
	@echo "----------"
	@echo "The following variable is valid after make"
	@echo "newest entry index           : $(call GetNewestFileIndex,$(easy_make_entry_list))"
	@echo "newest entry                 : $(word $(call GetNewestFileIndex,$(easy_make_entry_list)),$(easy_make_entry_list))"
	@echo "files for entry timestamp    : $(foreach file,$(easy_make_entry_list),$(call GetEntryPath4Timestamp,$(file)) )"
	@echo "  easy_make_entry_list       : $(easy_make_entry_list)"
	@echo "  easy_make_entry            : $(easy_make_entry)"
	@echo "  easy_make_entry_link_flags : $(easy_make_entry_link_flags)"
	@echo "  easy_make_cppsources       : $(easy_make_cppsources)"
	@echo "  easy_make_csources         : $(easy_make_csources)"
	@echo "  easy_make_objects          : $(easy_make_objects)"
	@echo "  easy_make_entry_link_flags : $(easy_make_entry_link_flags)"


# Pattern rule Descriptions:
# 1. Prepare the directories, where the object file is gonna be created.
# 2. Generate the .d dependency file, which specify what files this object 
#    files depends on. This is useful in the next make.
# 3. Compile the source code to object file.
# 4. Prepare $(easy_make_f_detected_entries), which is not empty.
# 5. 
# 6. Delete the name of the source file this target corresponds to, if it is 
#    listed in file $(easy_make_f_detected_entries). Note that the grep command 
#    returns non-zero code if its output is empty, thus we have to make sure 
#    that the file $(easy_make_f_detected_entries) is not empty.
# 7. If there is a main function defined in this object, add this file into the 
#    list defined in the file $(easy_make_f_detected_entries).
$(BUILD_ROOT)/%.o: %.$(CPPEXT)
	@mkdir -p $(dir $@)
	@$(GXX) -MM -MP -MF"$(@:.o=.d)" -MT"$@" $(COMPILE_FLAGS) $(addprefix -I,$(COMPILE_SEARCH_PATH))  $(word 1,$^) 
	$(GXX) -c -o $@ $(word 1,$^) $(COMPILE_FLAGS) $(addprefix -I,$(COMPILE_SEARCH_PATH))
	@if [ ! -f $(easy_make_f_detected_entries) ]; then echo " " > $(easy_make_f_detected_entries); fi;
	@grep -v "^$(patsubst $(BUILD_ROOT)/%.o,%.$(CPPEXT),$@)$$" $(easy_make_f_detected_entries) > $(BUILD_ROOT)/easy_make_entries_tmp.d 
	@cp $(BUILD_ROOT)/easy_make_entries_tmp.d $(easy_make_f_detected_entries)
	@if [ $$(nm -g -C --format="posix" $@ | grep -c "^main T") -eq 1 ]; then echo "$(patsubst $(BUILD_ROOT)/%.o,%.$(CPPEXT),$@)" >> $(easy_make_f_detected_entries) && echo "    entry detected"; fi;

$(BUILD_ROOT)/%.o: %.$(CEXT)
	@mkdir -p $(dir $@)
	@$(GCC) -MM -MP -MF"$(@:.o=.d)" -MT"$@" $(COMPILE_FLAGS) $(addprefix -I,$(COMPILE_SEARCH_PATH))  $(word 1,$^) 
	$(GCC) -c -o $@ $(word 1,$^) $(COMPILE_FLAGS) $(addprefix -I,$(COMPILE_SEARCH_PATH))
	@if [ ! -f $(easy_make_f_detected_entries) ]; then echo " " > $(easy_make_f_detected_entries); fi;
	@grep -v "^$(patsubst $(BUILD_ROOT)/%.o,%.$(CEXT),$@)$$" $(easy_make_f_detected_entries) > $(BUILD_ROOT)/easy_make_entries_tmp.d 
	@cp $(BUILD_ROOT)/easy_make_entries_tmp.d $(easy_make_f_detected_entries)
	@if [ $$(nm -g -C --format="posix" $@ | grep -c "^main T") -eq 1 ]; then echo "$(patsubst $(BUILD_ROOT)/%.o,%.$(CEXT),$@)" >> $(easy_make_f_detected_entries) && echo "    entry detected"; fi;


# include all generated dependency files
ifneq ($(strip $(easy_make_all_cppobjects)),)
    sinclude $(easy_make_all_cppobjects:.o=.d)
endif
ifneq ($(strip $(easy_make_all_cobjects)),)
    sinclude $(easy_make_all_cobjects:.o=.d)
endif

.PHONY: easy_make_phony
# do nothing to make this target.
easy_make_phony:
	@true


easy_make_entry_list=$(ENTRY_LIST) $(call ReadSettings,$(easy_make_f_detected_entries))
easy_make_entry=$(call GetEntry,$(ENTRY),$(easy_make_entry_list),"ENTRY=$(ENTRY) is neither defined in the entry_list nor detected by easy_make.")
# easy_make_cppsources: cpp files with unused entries filtered-out.
easy_make_cppsources=$(call SourcesToLink,$(CPPSOURCES),$(easy_make_entry),$(easy_make_entry_list))
easy_make_csources=$(call SourcesToLink,$(CSOURCES),$(easy_make_entry),$(easy_make_entry_list))
easy_make_objects=$(call CorrendingObjects,$(easy_make_cppsources),$(BUILD_ROOT),$(CPPEXT)) $(call CorrendingObjects,$(easy_make_csources),$(BUILD_ROOT),$(CEXT))
easy_make_entry_link_flags=$(call ReadSettings,$(SETTINGS_ROOT)/$(easy_make_entry).link_flags) $(ENTRY_$(strip $(easy_make_entry))_LINK_FLAGS)
# The $(if ...) block makes sure that the $(easy_make_target) is re-created
# when different $(TARGET) or different $(ENTRY) is set by user at command line
$(easy_make_target): $(easy_make_all_cppobjects) $(easy_make_all_cobjects) $(if $(filter-out $(prev_entry) $(prev_target),$(if $(ENTRY),$(ENTRY),$(prev_entry)) $(TARGET)),easy_make_phony,)
	$(if $(call ENTRY_$(strip $(easy_make_entry))_LinkCmd,$@,$(easy_make_objects)),@ true || ,)$(LINKER) -o $@ $(easy_make_objects) $(LINK_FLAGS) $(easy_make_entry_link_flags) $(addprefix -L,$(LINK_SEARCH_PATH))
	$(call ENTRY_$(strip $(easy_make_entry))_LinkCmd,$@,$(easy_make_objects))
	@echo "$(easy_make_entry)" > $(easy_make_f_info)
	@echo "$(TARGET)" >> $(easy_make_f_info)
