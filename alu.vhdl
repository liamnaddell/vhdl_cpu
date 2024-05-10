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
    function to_bstring(sl : std_logic) return string is
      variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
    begin
      sl_str_v := std_logic'image(sl);
      return "" & sl_str_v(2);  -- "" & character to get string
    end function;
begin
  process(enable)
  begin
    if enable = '1' then
      report "in1: " & to_bstring(in1);
      report "in2: " & to_bstring(in2);
      case op is
        when "00" => a_out <= std_logic_vector(unsigned(in1) + unsigned(in2));
        when "01" => a_out <= std_logic_vector(unsigned(in1(0 to 3)) * unsigned(in2(0 to 3)));
        when "10" => a_out <= in1 and in2;
        when "11" => a_out <= in1 xor in2;
        when others => a_out <= in1;
      end case;
      done <= '1';
    else
      done <= '0';
    end if;
  end process;
end architecture behavioral;
