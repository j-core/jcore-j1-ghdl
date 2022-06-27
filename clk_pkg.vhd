library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package clk_pkg is

component SB_HFOSC is
  generic (CLKHF_DIV : string := "0b00");
  port (CLKHFEN : in  std_logic;
        CLKHF   : out std_logic;
        CLKHFPU : in  std_logic);
end component SB_HFOSC;

end clk_pkg;
