library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
   enable: in std_logic;
   op: in std_logic_vector(0 to 1);
   in1: in std_logic_vector(0 to 7);
   in2: in std_logic_vector(0 to 7);
   done: out std_logic;
   a_out: out std_logic_vector(0 to 7)
  );
end;

architecture behavioral of alu is
begin
  process(enable)
  begin
    if enable = '1' then
      case op is
        when "00" => a_out <= in1 and in2;
        when others => a_out <= in1;
      end case;
      done <= '1';
    else
      done <= '0';
    end if;
  end process;
end architecture behavioral;
