library IEEE;
use IEEE.std_logic_1164.all;

entity valor_inmediato is
  port (
    instr : in  std_logic_vector(31 downto 7);
    sel : in  std_logic_vector(2 downto 0);
    inmediato : out std_logic_vector(31 downto 0)
  );
end valor_inmediato;

architecture arch of valor_inmediato is
begin
  with sel select
  inmediato<=(31 downto 12=>instr(31))&instr(31 downto 20)    when "000", -- Tipo I
            (31 downto 12=>instr(31))&instr(31 downto 25)&instr(11 downto 7) when "001", -- Tipo S
            (31 downto 13=>instr(31))&instr(31 downto 25)&instr(11 downto 7)&"0" when "010", -- Tipo B
            instr(21 downto 12)&(11 downto 0='0'>) when "011", --Tipo U
            (31 downto 21=>instr(31))&instr(31 downto 12)&'0' when "100",
            
end arch;
