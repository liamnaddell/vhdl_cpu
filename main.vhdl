library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity main is
end;


architecture behavioral of main is
    function to_bstring(sl : std_logic) return string is
      variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
    begin
      sl_str_v := std_logic'image(sl);
      return "" & sl_str_v(2);  -- "" & character to get string
    end function;
  signal clk: std_logic := '0';
  signal reg_data : std_logic_vector(0 to 7);
  signal reg_select : std_logic_vector(0 to 1);
  signal reg_write : std_logic;
  signal instruction: std_logic_vector (0 to 7);
  signal rd: std_logic_vector (0 to 1);
  signal rs: std_logic_vector (0 to 1);
  signal imm: std_logic_vector (0 to 1);
  signal op: std_logic_vector (0 to 1);

  signal mem_write: std_logic := '0';
  signal mem_addr: std_logic_vector (0 to 7);
  signal mem_data: std_logic_vector (0 to 7);

  signal alu_op : std_logic_vector (0 to 1);
  signal alu_in1 : std_logic_vector (0 to 7);
  signal alu_in2 : std_logic_vector (0 to 7);
  signal alu_out : std_logic_vector (0 to 7);
  signal reg_enabled : std_logic := '0';
  type cpu_state is (init,fetch,store);
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
      data => reg_data,
      write => reg_write,
      r_select => reg_select,
      enabled => reg_enabled
    );
    memory_inst: entity work.memory
      port map(
        clk => clk,
        rdwrt => mem_write,
        addr => mem_addr,
        data => mem_data
      );

    process (clk,state)
      type c_file is file of character;
      constant zero: std_logic_vector (0 to 7) := "00000000";
      file program_file: c_file;
      variable read_instruction: character;
      variable read_line: line;
      --OORDRSII
    begin
      if (rising_edge(clk)) then
        if state = init then
          report "Initializing";
          file_open(program_file, "input.bin", read_mode);
          while not endfile(program_file) loop
            read(program_file,read_instruction);

          end loop;
          file_close(program_file);
          state <= fetch;
        elsif state = fetch then
          report "Fetching";
          instruction <= "00000001";
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
          state <= store;
        elsif state = store then
          report "Storing";
          reg_data <= alu_out;
          reg_select <= rd;
          reg_write <= '1';
          state <= fetch;
        end if;
      end if;
    end process;
end architecture behavioral;
