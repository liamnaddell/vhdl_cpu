library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  port (
    clk: in std_logic;
    r_select: in std_logic_vector(0 to 1);
    data: inout std_logic_vector(0 to 7);
    write : in std_logic
  );
end;

architecture RTL of register_file is
  type reg is array (1 to 3) of std_logic_vector (0 to 7);
  constant reg_zero : std_logic_vector (0 to 7) 
    := "00000000" ;
  signal registers: reg;
begin
  process(clk)
  begin
    if (rising_edge(clk)) then
      data <=
        reg_zero when to_integer(unsigned(r_select)) = 0 else
        registers(to_integer(unsigned(r_select)));
    end if;
  end process;
end architecture rtl;
