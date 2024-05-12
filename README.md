# CpuVHDL

This project is a test project, designed to help me learn VHDL. The CPU implemented here is very similar to a CPU implmented in Logisim Evolution for CSCB58.

## Synthesis

I tried to use as many synthesisable constructs as possible for this CPU, that way I would get the best experience with VHDL in practice. Unfortunately, I don't own an FPGA, so I had to use simulation-only constructs to get the CPU to interface with the outside world. If/when I get an FPGA, I can hopefully easily refactor in order to acheive synthesis, likely by removing the CLK driver, changing the memory read/write code to use whatever memory is on the board, and changing the initialization code to read starting code from ROM, which could be programmed to load instructions from an external device.

## CPU Design.

* The cpu is an 8 bit cpu, with 4 opcodes, 00=add, 01=mul, 10=and, 11=xor. 
* The instruction format is OORDRSII, where OO=opcode, RD=Destination reg, RS=Source reg, and II=Instruction. It is impossible for instruction decoding to fail.
* Memory is used to store instructions loaded from a file (input.bin) on cpu initialization. 
* The CPU powers itself off once all loaded instructions are executed.
* The CPU prints out the contents of its registers before powering itself off.
* The CPU has no exception mechanism, because it is impossible to generate an invalid sequence of instructions.

## How to load programs.

* Use `./assembler.hs` to create programs. Then, this will output a file `input.bin`. This contains the assembled code
* The `$(GHDL)` Makefile variable points to the installation of the `ghdl` binary.
* Running `make` will run the cpu, which will use VHDL file I/O to load `input.bin` from disk.
* Running `make wave` will also create a signal trace, then attempt to display that trace using `gtkwave`

