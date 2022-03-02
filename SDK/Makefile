# Makefile for Playdate SDK targets
#
# 2022-03-01 - SL - initial version

##############################################
# config

# this is the directory with the main.lua file
PROJ := Source

#SingleFileExamples


##############################################
# generate these...

# generate the PDX destination path name
PDX := $(PROJ).pdx

# add wildcard for including all directory files
SRCS:= $(wildcard $(PROJ)/*.lua)


##############################################
# Main targets

# all: default target... build & simulate
all: simulate

build: $(PDX)

# Dependencies
$(PROJ).pdx: $(SRCS)

# build rules
%.pdx:%/ $(SRCS)
	@echo Building $<
	@pdc $<

##############################################
# utility targets

# simulate: run the PDX in the simulator
simulate: $(PDX)
	@echo Opening in simulator...
	@open $<
.phony: simulate

# dir: open the directory with the content
dir:
	@open $(PROJ)
.phony: open

# clean: remove all built files/PDX
clean:
	@echo Removing generated PDX
	@rm -r $(PDX)
.phony: clean