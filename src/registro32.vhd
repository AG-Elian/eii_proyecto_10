library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registro32 is
  port (
    clk, hab, reset: in  std_logic;
    D : in std_logic_vector(31 downto 0); -- datos de entrada
    Q : out std_logic_vector(31 downto 0) --datos de salida
  );
end registro32;

architecture behavioral of registro32 is
  
begin
  U1 : process (clk)
  begin
    if rising_edge(clk) then
      if reset then --modificacion realizada
        Q<=32x"0"; 
      elsif hab then
        Q<=D; -- fin de modificacion
        end if;
      end if;
    end process;
end behavioral;