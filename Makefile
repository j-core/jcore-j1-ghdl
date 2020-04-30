TARGET = cpu_lattice
LIB_RTL = \
cpu2j0_pkg.vhd components_pkg.vhd mult_pkg.vhd decode_pkg.vhd decode_body.vhd datapath_pkg.vhd \
cpu.vhd decode.vhd decode_core.vhm decode_table.vhd datapath.vhm register_file_sync.vhd mult.vhm \
decode_table_reverse.vhd
#decode_table_rom.vhd
#decode_table_simple.vhd
EXTRA_RTL = \
data_bus_pkg.vhd monitor_pkg.vhd ram_init.vhd lattice_ebr.vhd bus_monitor.vhd timeout_cnt.vhm \
cpu_simple_sram.vhd lattice_spr_wrap.vhd cpu_bulk_sram.vhd
DEVICE = up5k
PACKAGE = sg48

STOP_TIME = 40us

RTL = $(LIB_RTL) $(TARGET)_pkg.vhd $(EXTRA_RTL) $(TARGET).vhm
TB_RTL = $(TARGET)_tb.vhd

PREPROC_RTL = $(shell echo $(RTL) | sed -e s/\.vhm/\.vhd/g)
OBJS =  $(shell echo $(RTL)    | sed -e s/\.vh[md]/\.o/g)
TB_OBJS = $(shell echo $(TB_RTL) | sed -e s/\.vh[md]/\.o/g)

.PRECIOUS: %.vhd %.txt

all: $(TARGET).bin

sim: $(TARGET)_tb

wave: $(TARGET)_tb.ghw

program: $(TARGET).bin
	iceprog $(TARGET).bin

$(TARGET).json: $(OBJS)
	ghdl -e $(TARGET)
	yosys -m ghdl -p "ghdl $(TARGET); opt; opt_mem; synth_ice40 -device u -dsp -abc2 -retime -top $(TARGET) -json $@"

$(TARGET)_tb: $(OBJS) $(TB_OBJS)
	ghdl -e $@
	@touch $@

$(TARGET)_tb.ghw: $(TARGET)_tb
	ghdl -r $(TARGET)_tb --wave=$(TARGET)_tb.ghw --stop-time=$(STOP_TIME)

%.txt: %.json %.pcf
	nextpnr-ice40 --$(DEVICE) --opt-timing --package=$(PACKAGE) --json $< --pcf `basename -s .json $<`.pcf --asc $@ --sdf $@.sdf

%.bin: %.txt
	icepack $< $@

%.vhd: %.vhm
	perl tools/v2p < $< > $@

%.o: %.vhd
	ghdl -a $<
	@touch $@

unload_ftdi:
	sudo kextunload -b com.apple.driver.AppleUSBFTDI

clean:
	- rm *.json *.txt *.bin
	- rm $(shell echo $(RTL) | sed -e "s/[^ ]*\.vhd//g" -e "s/\.vhm/.vhd/g")
	- rm *.[oa] *.cf $(TARGET)_tb $(TARGET)_tb.ghw core
	true
