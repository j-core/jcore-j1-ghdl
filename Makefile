TARGET = top
LIB_RTL =
EXTRA_RTL =

DEVICE = up5k
PACKAGE = sg48

#STOP_TIME = 5sec
STOP_TIME = 50ms

RTL = $(LIB_RTL) $(TARGET)_pkg.vhd $(EXTRA_RTL) $(TARGET).vhm
TB_RTL = $(TARGET)_tb.vhd

PREPROC_RTL = $(shell echo $(RTL) | sed -e s/\.vhm/\.vhd/g)
OBJS = $(shell echo $(RTL) $(TB_RTL) | sed -e s/\.vh[md]/\.o/g)

.PRECIOUS: %.vhd %.txt

all: $(TARGET).bin

sim: $(TARGET)_tb

wave: $(TARGET)_tb.ghw

program: $(TARGET).bin
	iceprog $(TARGET).bin

$(TARGET).json: $(OBJS)
	ghdl -e $(TARGET)
	yosys -m ghdl -p "ghdl $(TARGET); opt; opt_mem; synth_ice40 -device u -dsp -abc2 -retime -top $(TARGET) -json $@"

$(TARGET)_tb: $(OBJS)
	echo $(OBJS)
	ghdl -e $@
	@touch $@

$(TARGET)_tb.ghw: $(TARGET)_tb
	ghdl -r $(TARGET)_tb --wave=$(TARGET)_tb.ghw --stop-time=$(STOP_TIME)

%.txt: %.json %.pcf
	nextpnr-ice40 --$(DEVICE) --opt-timing --package=$(PACKAGE) --json $< --pcf `basename -s .json $<`.pcf --asc $@

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
	- rm $(TARGET).vhd *.json *.txt *.bin
	- rm *.[oa] *.cf $(TARGET)_tb $(TARGET)_tb.ghw core
	true
