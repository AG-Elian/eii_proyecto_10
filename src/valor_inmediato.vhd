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
  U1 : with sel select
  inmediato<=(31 downto 11=>instr(31)&instr(30 downto 20)) when "001", -- Tipo I
              (31 downto 11=>instr(31))&instr(30 downto 25)&instr(11 downto 7) when "010", -- Tipo s
              (31 downto 12=>instr(31))&instr(7)&instr(30 downto 25)&instr(11 downto 8)&"0" when "011", -- Tipo B
              instr(31 downto 20)&instr(19 downto 12)&(11 downto 0=>'0') when "100", -- Tipo U
              (30 downto 20=>instr(31))&instr(19 downto 12)&instr(20)&instr(30 downto 25)&instr(24 downto 2)&"0" when "101", -- Tipo J
              x"00000000" when others;
              -- end U1

end arch;
