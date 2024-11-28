library IEEE;
use IEEE.std_logic_1164.all;

entity desplaza_izq is
  port (
    A : in  std_logic_vector(31 downto 0);
    B : in  std_logic_vector(4 downto 0);
    Y : out std_logic_vector(31 downto 0)
  );
end desplaza_izq;

architecture arch of desplaza_izq is
  signal s16,s8,s4,s2,s1 : std_logic_vector(31 downto 0);
  constant relleno  : std_logic_vector(15 downto 0) := (others => '0');
begin
  s16 <= A(15 downto 0)&relleno(15 downto 0) when B(4) else A;
  s8  <= s16(23 downto 0)&relleno(7 downto 0) when B(3) else s16;
  s4 <= s8(27 downto 0)&relleno(3 downto 0) when B(2) else s8;
  s2 <= s4(29 downto 0)&relleno(1 downto 0) when B(1) else s4;
  s1 <= s2(30 downto 0)&relleno(0) when B(0) else s2;
  Y<=s1;
end arch;
