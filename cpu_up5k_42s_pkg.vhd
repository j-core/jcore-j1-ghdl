library ieee;
use ieee.std_logic_1164.all;

package cpu_up5k_pack is

component cpu_up5k_42s is port (
   x   : inout std_logic_vector(6 downto 1);
   y   : inout std_logic_vector(7 downto 1);
   pon : inout std_logic;
   mfcs: inout std_logic;
   mrcs: inout std_logic;
   msck: inout std_logic;
   msi : inout std_logic;
   mso : inout std_logic;
   mio2: inout std_logic;
   mio3: inout std_logic;
   lcs : inout std_logic;
   la0 : inout std_logic;
   lscl : inout std_logic;
   lsi : inout std_logic);
end component;

end cpu_up5k_pack;
