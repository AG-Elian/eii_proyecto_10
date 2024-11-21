library IEEE;
use IEEE.std_logic_1164.all;

entity MEF_control is
  port (
    A : in  std_logic;
    B : in  std_logic;
    Y : out std_logic
  );
end MEF_control;

architecture arch of MEF_control is
begin
  Y <= A and B;
end arch;
