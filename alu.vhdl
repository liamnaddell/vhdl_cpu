library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
   clk: in std_logic;
   op: in std_logic_vector(0 to 1);
   in1: in std_logic_vector(0 to 7);
   in2: in std_logic_vector(0 to 7);
   done: out std_logic;
   a_out: out std_logic_vector(0 to 7)
  );
end;

architecture behavioral of alu is
begin
  process(clk)
  begin
    if (rising_edge(clk)) then
      case op is
        when "00" => a_out <= in1 & in2;
        when others => assert (false);
      end case;
      done <= '1';
    end if;
  end process;
end architecture behavioral;
