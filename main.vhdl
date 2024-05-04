library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use std.env.finish;

entity main is
end;


architecture behavioral of main is
    function to_bstring(sl : std_logic) return string is
      variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
    begin
      sl_str_v := std_logic'image(sl);
      return "" & sl_str_v(2);  -- "" & character to get string
    end function;
    function to_bstring(sl : std_logic_vector) return string is
    begin
      return "0x" & to_hstring(sl);
    end function;
    function to_istring(sl : unsigned) return string is
    begin
      return "" & integer'image(to_integer(sl));
    end function;
  signal clk: std_logic := '0';

  signal reg_data_in : std_logic_vector(0 to 7);
  signal reg_data_out : std_logic_vector(0 to 7);
  signal reg_select : std_logic_vector(0 to 1);
  signal reg_write : std_logic;

  signal instruction: std_logic_vector (0 to 7);
  signal rd: std_logic_vector (0 to 1);
  signal rs: std_logic_vector (0 to 1);
  signal imm: std_logic_vector (0 to 1);
  signal op: std_logic_vector (0 to 1);

  signal mem_write: std_logic := '0';
  signal mem_read: std_logic := '0';
  signal mem_addr: std_logic_vector (0 to 7);
  signal mem_data: std_logic_vector (0 to 7);

  signal alu_op : std_logic_vector (0 to 1);
  signal alu_in1 : std_logic_vector (0 to 7);
  signal alu_in2 : std_logic_vector (0 to 7);
  signal alu_out : std_logic_vector (0 to 7);
  signal reg_enabled : std_logic := '0';
  type cpu_state is (init,fetch,store,halt);
  signal state : cpu_state := init;
begin
  clock_inst: entity work.clock 
    port map(
        clk => clk
    );
  alu_inst: entity work.alu 
    port map(
        clk => clk,
        op => alu_op,
        in1 => alu_in1,
        in2 => alu_in2,
        a_out => alu_out
    );
  register_inst: entity work.register_file
    port map(
      clk => clk,
      data_in => reg_data_in,
      data_out => reg_data_out,
      write => reg_write,
      r_select => reg_select,
      enabled => reg_enabled
    );
    memory_inst: entity work.memory
      port map(
        clk => clk,
        write => mem_write,
        read => mem_read,
        addr => mem_addr,
        data => mem_data
      );

    process (clk,state)
      type c_file is file of character;
      constant zero: std_logic_vector (0 to 7) := "00000000";
      file program_file: c_file;
      variable read_instruction: character;
      variable read_line: line;
      variable pc: unsigned(0 to 7);
      variable instn_count: integer range 0 to 255;
      --OORDRSII
    begin
      if (rising_edge(clk)) then
        if state = init then
          pc := "00000000";
          report "Initializing";
          file_open(program_file, "input.bin", read_mode);
          while not endfile(program_file) loop
            read(program_file,read_instruction);
            instn_count := instn_count + 1;
          end loop;
          file_close(program_file);
          state <= fetch;
        elsif state = fetch then
          report "Fetching " & to_istring(pc);
          mem_addr <= std_logic_vector(pc);
          instruction <= mem_data;
          mem_read <= '1';
          --decode the instruction
          op <= instruction(0 to 1);
          rd <= instruction(2 to 3);
          rs <= instruction(4 to 5);
          imm <= instruction(6 to 7);
          --configure the register file to select the register from the instruction
          reg_select <= rs;
          --configure the register file to write the alu output to a register
          alu_op <= op;
          alu_in1 <= "01001010";
          alu_in2 <= "11111111";
          pc := pc+1;
          if pc < instn_count then
            state <= store;
          else
            state <= halt;
          end if;
        elsif state = store then
          --report "Storing";
          reg_data_in <= alu_out;
          reg_select <= rd;
          reg_write <= '1';
          state <= fetch;
        elsif state = halt then
          report "Halting";
          reg_select <= "00";
          reg_write <= '0';
          report "t0=" & to_bstring(reg_data_out);
          finish;
        end if;
      end if;
    end process;
end architecture behavioral;
