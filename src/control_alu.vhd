library IEEE;
use IEEE.std_logic_1164.all;

entity control_alu is
  port (
    A : in  std_logic;
    B : in  std_logic;
    Y : out std_logic
  );
end control_alu;

architecture arch of control_alu is
begin
  Y <= A and B;
end arch;
