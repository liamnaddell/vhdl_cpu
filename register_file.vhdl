library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  port (
    r_select: in std_logic_vector(0 to 1);
    data_in: in std_logic_vector(0 to 7);
    write : in std_logic;
    enable : in std_logic;
    data_out : out std_logic_vector(0 to 7)
  );
end;

architecture RTL of register_file is
  type reg is array (0 to 3) of std_logic_vector (0 to 7);
  signal registers: reg := 
    ("00000000","00000000","00000000","00000000");
begin
  process(enable)
  begin
    if enable = '1' then
      if write = '1' then
        registers(to_integer(unsigned(r_select))) <= data_in;
      end if;
      data_out <= registers(to_integer(unsigned(r_select)));
    end if;
  end process;
end architecture rtl;
