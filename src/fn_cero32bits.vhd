library IEEE;
use IEEE.std_logic_1164.all;

entity fn_cero32bits is
  port (
    A : in  std_logic_vector(31 downto 0); -- Señal de entrada de 32 bits
    Y : out std_logic                      -- Señal de salida de 1 bit
  );
end fn_cero32bits;

architecture arch of fn_cero32bits is
begin
  Y <= '1' when A="00000000000000000000000000000000" else '0';
end arch;
