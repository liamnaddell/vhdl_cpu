library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- An MMU converts virtual addresses to physical addresses.
-- It needs an address of a page dir
-- it needs a virtual address.
-- it outputs a physical address
-- it outputs a valid bit.
entity mmu is
  port (
   clk: in std_logic;
   pagedir: in std_logic_vector(0 to 31);
   virtual_addr: in std_logic_vector(0 to 31);
   physical_addr: out std_logic_vector(0 to 31);
   valid: out std_logic_vector(0 to 31)
  );
end;

--
-- TODO: Come up with a paging scheme. Investigate upping page size.
-- page size: 256 bytes
-- amount of frames: 128
-- frame number: 8 bits
-- page offset: 8 bits
-- rwx: 3 bits
-- this means 2 byte ptes, 256/2=128 frames can be mapped.
-- virtual addr = 8b pte index | 8b page offset
architecture behavioral of mmu is
begin
  process(clk)

  begin
    i
  end process;
end architecture behavioral;
