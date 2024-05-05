--  Hello world program
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  Defines a design entity, without any ports.
entity memory is
  port (
         read : in std_logic;
         write : in std_logic;
         addr : in std_logic_vector(0 to 7);
         data : in std_logic_vector(0 to 7)
  );
end memory;

architecture behaviour of memory is
  type ram_array is array (0 to 15) of std_logic_vector (7 downto 0);
  signal ram_data: ram_array;
begin
  process(read,write)
  begin
    if write='1' then 
        ram_data(to_integer(unsigned(addr))) <= data;
    end if;
    --if read = '1' then
    --  data <= ram_data(to_integer(unsigned(addr)));
    --end if;
  end process;
end behaviour;
