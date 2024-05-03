--  Hello world program
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  Defines a design entity, without any ports.
entity memory is
  port (
         clk : in std_logic;
         rdwrt : in std_logic;
         addr : in std_logic_vector(0 to 7);
         data : inout std_logic_vector(0 to 7)
  );
end memory;

architecture behaviour of memory is
  type ram_array is array (0 to 4096) of std_logic_vector (7 downto 0);
  signal ram_data: ram_array;
begin
  process(clk)
  begin
    if(rising_edge(clk)) then
      if(rdwrt='1') then 
          ram_data(to_integer(unsigned(addr))) <= data(0 to 7);
      end if;
      data(0 to 7) <= ram_data(to_integer(unsigned(addr)));
    end if;
  end process;
end behaviour;
