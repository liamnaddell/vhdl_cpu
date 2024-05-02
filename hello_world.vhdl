--  Hello world program
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all; -- Imports the standard textio package.

--  Defines a design entity, without any ports.
entity hello_world is
  port (clk : in std_logic);
end hello_world;

architecture behaviour of hello_world is
begin
  process(clk)
    variable l : LINE;
  begin
    readline (input,l);
    writeline (output, l);
  end process;
end behaviour;
