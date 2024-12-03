library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fn_suma_resta is
  port (
    A       : in  std_logic_vector(31 downto 0);
    B       : in  std_logic_vector(31 downto 0);
    --AmasB   : out std_logic_vector(31 downto 0);
    --AmenosB : out std_logic_vector(31 downto 0);
    sel     : in std_logic;
    Y       : out std_logic_vector(31 downto 0)
  );
end fn_suma_resta;

architecture arch of fn_suma_resta is
signal AmasB : std_logic_vector(31 downto 0);
signal AmenosB : std_logic_vector(31 downto 0);
begin
  AmasB <= std_logic_vector(unsigned(A)+unsigned(B));
  AmenosB <= std_logic_vector(unsigned(A)-unsigned(B));
  Y <= AmenosB when sel else AmasB;
end arch;
