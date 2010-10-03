###############################################################################
# Requires: GNU make and basic GNU utilities
#           Xilinx ISE
#
# Asbjørn Djupdal 2003, 2008
###############################################################################

# IMPORTANT: ucf-file must be named $(PROJECT_NAME).ucf

###############################################################################
# the following variables must be set according to your project
###############################################################################

# select a name for your project (used as basename for most generated files)
PROJECT_NAME = multicycle

# list VHDL sourcefiles (separated with spaces) in correct synthesis order
SOURCE_FILES = package.vhd control_const.vhd regfile_mux.vhd sr.vhd alu.vhd pc.vhd control.vhd cpu.vhd cpucom.vhd mem.vhd regfile.vhd toplevel.vhd 

# name of top level entity
TOP_LEVEL = toplevel

# target device
DEVICE = xcv1000e-6-fg860

# synthesis (xst) options
SYNTH_OPTS = -opt_mode Speed -opt_level 1 -register_duplication no \
	-hierarchy_separator / -keep_hierarchy yes

# options for bitfile generation
BITGEN_OPTS = -g ConfigRate:4 -g DriveDone:No -g StartUpClk:JTAGCLK \
		-g DONE_cycle:4 -g GTS_cycle:5 -g GSR_cycle:6 -g DonePipe:No \
		-g GWE_cycle:6 -g LCK_cycle:NoWait -g Security:NONE

###############################################################################
# rules, no need to change anything below this line
###############################################################################

# default rule: create both bitfile and files for timing simulation
.PHONY : default
default : $(PROJECT_NAME).bit time_sim.vhd 

# create temporary project and script files for XST
$(PROJECT_NAME).xst : $(SOURCE_FILES) 
	echo $(SOURCE_FILES) | xargs -n 1 > $(PROJECT_NAME).prj 
	echo -n "run -ifn $(PROJECT_NAME).prj -ofn $(PROJECT_NAME).ngc " > $@
	echo -n "-ofmt NGC -p $(DEVICE) -top $(TOP_LEVEL) -ifmt VHDL " >> $@
	echo "$(SYNTH_OPTS)" >> $@

# synthesis with XST
$(PROJECT_NAME).ngc : $(PROJECT_NAME).xst
	xst -ifn $<

# implementation
$(PROJECT_NAME).ncd : $(PROJECT_NAME).ngc
	xflow -p $(DEVICE) -implement high_effort.opt $<

# bitfile generation
$(PROJECT_NAME).bit : $(PROJECT_NAME).ncd $(PROJECT_NAME).pcf
	bitgen -l -w -m -intstyle xflow $(BITGEN_OPTS) $<

# generate files for timing simulation
time_sim.vhd : $(PROJECT_NAME).ncd $(PROJECT_NAME).pcf
	xflow -p $(DEVICE) -tsim modelsim_vhdl.opt $<

.PHONY : clean
clean :
	rm -rf *.opt *.flw *.bgn *.bit *.bld *.drc *.ll *.msk *.ncd *.ngc \
		*.ngd *.pad *.par *.pcf *.prj *.rbt *.twr *.twx *.xpi *_map* \
		*_pad* *_timing* *_xst* *.lst *.nlf *.sdf xflow* xst *.xst \
		*.srp .prj .srp .xst

