library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fn_menor_que is
  port (
    A : in  std_logic_vector(31 downto 0);
    B : in  std_logic_vector(31 downto 0);
    sin_signo: std_logic;
    Y : out std_logic
  );
end fn_menor_que;

architecture arch of fn_menor_que is
begin
  with sin_signo select
  Y <= signed(A) ?< signed(B) when '0',
       unsigned(A) ?< unsigned(B) when '1',
       '0' when others;

end arch;
