library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_32x32 is
  port (
    clk, hab_w : in  std_logic;
    dir_w, dir_r1, dir_r2 : in  std_logic_vector(4 downto 0); -- direcciones de lectura/escritura
    dat_w : in std_logic_vector(31 downto 0); -- datos de escritura
    dat_r1, dat_r2 : out std_logic_vector(31 downto 0) --datos de lectura
  );
end reg_32x32;

architecture behavioral of reg_32x32 is
  type mem_t is array(0 to 31) of std_logic_vector(31 downto 0);
  signal mem : mem_t:=(others=>x"0");
begin
  puertos : process (clk)
  begin
    if rising_edge(clk) then
      if hab_w = '1' then
        mem(to_integer(unsigned(dir_w)))<=dat_w;
        end if;
        dat_r1<=mem(to_integer(unsigned(dir_r1)));
        dat_r2<=mem(to_integer(unsigned(dir_r2)));
      end if;
    end process;
end behavioral;
