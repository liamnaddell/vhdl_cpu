library ieee;
use ieee.std_logic_1164.all;

entity main is
end;

architecture behavioral of main is
  signal clk: std_logic := '0';
  -- used for when loading is done
  signal done_load : std_logic;

  signal reg_data : std_logic_vector(0 to 7);
  signal reg_select : std_logic_vector(0 to 1);
  signal reg_write : std_logic;
  signal instruction: std_logic_vector (0 to 7);
  signal rd: std_logic_vector (0 to 1);
  signal rs: std_logic_vector (0 to 1);
  signal imm: std_logic_vector (0 to 1);
  signal op: std_logic_vector (0 to 1);
  signal alu_op : std_logic_vector (0 to 1);
  signal alu_in1 : std_logic_vector (0 to 7);
  signal alu_in2 : std_logic_vector (0 to 7);
  signal alu_out : std_logic_vector (0 to 7);
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
      r_select => reg_select
    );

    load_instructions: process (clk)
      constant zero: std_logic_vector (0 to 7) := "00000000";
      --OORDRSII
    begin
      if (rising_edge(clk)) then
        report "HI";
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
        done_load <= '1';
      end if;
    end process;
    store_alu_output: process (done_load)
    begin 
      if (done_load) then
        report "HI";
        reg_data <= alu_out;
        reg_select <= rd;
        reg_write <= '1';
        done_load <= '0';
      end if;
    end process;
end architecture behavioral;
