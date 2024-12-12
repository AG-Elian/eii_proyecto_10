library IEEE;
use IEEE.std_logic_1164.all;

entity branch_condition is
  port (
    funct3 : in  std_logic_vector(2 downto 0);
    Z_branch : out  std_logic
  );
end branch_condition;

architecture arch of branch_condition is
begin
  with funct3 select
  Z_branch<= '1' when "000"|"101"|"111", -- beq,bge,bgev
              '0' when others;            -- bne, bit, bltv
              -- fin with
end arch;
