library IEEE;
use IEEE.std_logic_1164.all;

entity and_32 is
  port (
    A : in  std_logic_vector(31 downto 0);
    B : in  std_logic_vector(31 downto 0);
    Y : out std_logic_vector(31 downto 0)
  );
end and_32;

architecture arch of and_32 is
begin
  Y <= A and B;
end arch;
