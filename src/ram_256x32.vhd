library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_256x32 is
  port (
    clk_w : in  std_logic;
    dir_w : in  std_logic_vector(7 downto 0);
    hab_w : in std_logic;
    dat_w : in std_logic(31 downto 0);
    clk_r : in std_logic;
    dir_r : in std_logic_vector(7 downto 0);
    hab_r : in std_logic;
    dat_r : out std_logic_vector(31 downto 0)
  );
end ram_256x32;

architecture arch of ram_256x32 is
  type mem_t is array (0 to 255) of std_logic_vector(31 to 0);
  signal mem : mem_t;
begin
  puerto_lectura : process (clk_r)
  begin
    if rising_edge(clk_r) then
      if hab_r = '1' then
        dat_r <= mem(to_integer(unsigned(dat_r)));
        end if;
      end if;
    end process;
  puerto_escritura : process(clk_w)
  variable dir, pos : integer;
  begin
    if rising_edge(clk_w) then
      dir := to_integer(unsigned(dir_w));
      for k in 0 to 3 loop
        pos := k*8;
        if hab_w(k)='1' then
          mem(dir)(pos + 7 down to pos)<=dat_w(pos+7 downto pos);
          end if;
      end loop;
    end if;
    end process;
end arch;
