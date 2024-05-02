--  Hello world program
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  Defines a design entity, without any ports.
entity memory is
  port (
         clk : in std_logic;
         rdwrt : in std_logic;
         addr : in std_logic_vector(0 to 31);
         data : inout std_logic_vector(0 to 31);
  -- 0=8, 1=16, 2=32
         size : in std_logic_vector(0 to 1)

  );
end memory;

architecture behaviour of memory is
  type ram_array is array (0 to 4096) of std_logic_vector (7 downto 0);
  signal ram_data: ram_array;
begin
  process(clk)
    variable op_size : integer range 0 to 37;
  begin
    if(rising_edge(clk)) then
        if (size(1) = '1') then
          -- 32 bit
          op_size := 31;
        --elseif (size(0)) then
          -- 16 bit
          --op_size := 16;
        else
          op_size := 7;
        end if;
      if(rdwrt='1') then 
          ram_data(to_integer(unsigned(addr))) <= data(0 to op_size);
      end if;
      data(0 to op_size) <= ram_data(to_integer(unsigned(addr)));
    end if;
  end process;
end behaviour;
