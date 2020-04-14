library ieee;
use ieee.std_logic_1164.all;

package cpu_lattice_pack is

   component cpu_lattice is port (
      clk : in std_logic;
      led : out std_logic_vector(7 downto 0));
   end component cpu_lattice;

end cpu_lattice_pack;
