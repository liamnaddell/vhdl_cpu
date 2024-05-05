GHDL=/opt/ghdl/bin/ghdl
OPTS := --std=08
all:
	$(GHDL) -a $(OPTS) clock.vhdl
	$(GHDL) -a $(OPTS) alu.vhdl
	$(GHDL) -a $(OPTS) register_file.vhdl
	$(GHDL) -a $(OPTS) memory.vhdl
	$(GHDL) -a $(OPTS) main.vhdl
	$(GHDL) -e $(OPTS) main
	$(GHDL) -r  $(OPTS)  main --wave=wave.ghw

lint:
	ghdl -lint *.vhdl
