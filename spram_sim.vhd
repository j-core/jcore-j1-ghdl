library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SB_SPRAM256KA is
          Port (  CLOCK   : in std_logic ;
                ADDRESS : in std_logic_vector(13 downto 0);
                DATAIN  : in std_logic_vector(15 downto 0);
                MASKWREN : in std_logic_vector(3 downto 0);
                WREN    : in std_logic;
                CHIPSELECT: in std_logic ;
                STANDBY : in std_logic := 'L' ;
                SLEEP   : in std_logic := 'L' ;
                POWEROFF: in std_logic := 'H' ;         --  Note : 1'b0 to POWEROFF RAM  , 1'b1 to POWERON RAM block at wrapper level.
                DATAOUT : out std_logic_vector(15 downto 0)
             );
end SB_SPRAM256KA;

architecture beh of SB_SPRAM256KA is
type ram_t is array (0 to (2**14)-1) of std_logic_vector(15 downto 0);
signal storage : ram_t;

begin
   p0 : process(CLOCK, CHIPSELECT, ADDRESS, DATAIN, WREN)
   begin
      if CLOCK='1' and CLOCK'event and CHIPSELECT = '1' then
         DATAOUT <= storage(to_integer(unsigned(ADDRESS)));
      end if;
          
      if CLOCK='1' and CLOCK'event and CHIPSELECT = '1' and WREN='1' then
         if MASKWREN(3)='1' then storage(to_integer(unsigned(ADDRESS)))(15 downto 12) <= DATAIN(15 downto 12); end if;
         if MASKWREN(2)='1' then storage(to_integer(unsigned(ADDRESS)))(11 downto  8) <= DATAIN(11 downto  8); end if;
         if MASKWREN(1)='1' then storage(to_integer(unsigned(ADDRESS)))( 7 downto  4) <= DATAIN( 7 downto  4); end if;
         if MASKWREN(0)='1' then storage(to_integer(unsigned(ADDRESS)))( 3 downto  0) <= DATAIN( 3 downto  0); end if;
      end if;
   end process;

end beh;
