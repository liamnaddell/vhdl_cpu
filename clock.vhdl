library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is
  PORT(clk : out std_logic);
end;

architecture behave of clock is
begin
  do_lock: process
  begin
    clk <= '0';
    wait for 0.5 ns;
    clk <= '1';
    wait for 0.5 ns;
  end process;
end;
