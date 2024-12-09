library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity ram_256x32 is
  generic(
    constant archivo : string:=""
  );
  port (
    clk_w : in  std_logic; -- reloj de escritura
    dir_w : in  std_logic_vector(7 downto 0); -- direccion de escritura
    hab_w : in std_logic; -- habilitacion de escritura
    dat_w : in std_logic(31 downto 0); -- datos de escritura
    clk_r : in std_logic; -- reloj de lectura
    dir_r : in std_logic_vector(7 downto 0); -- direccion de lectura
    hab_r : in std_logic; -- habilitacion de lectura
    dat_r : out std_logic_vector(31 downto 0) -- datos de lectura
  );
end ram_256x32;

architecture Behavioral of ram_256x32 is
  -- Declaración de la memoria: 256 posiciones de 32 bits
  type ram_type is array (255 downto 0) of std_logic_vector(31 downto 0);
  signal ram : ram_type := (others => (others => '0')); -- Inicialización de memoria
  signal read_data : std_logic_vector(31 downto 0); -- Dato leído temporal

  begin
  -- Proceso de escritura
    process(clk_w)
    begin
      if rising_edge(clk_w) then
        if hab_w = '1' then
          ram(to_integer(unsigned(dir_w))) <= dat_w; -- Escribe el dato en la dirección especificada
        end if;
      end if;
    end process;

    -- Proceso de lectura
    process(clk_r)
    begin
      if rising_edge(clk_r) then
        if hab_r = '1' then
          read_data <= ram(to_integer(unsigned(dir_r))); -- Lee el dato de la dirección especificada
        else
          read_data <= (others => '0'); -- Si no está habilitada, devuelve ceros
        end if;
      end if;
    end process;

    -- Asignación del dato leído al puerto de salida
    dat_r <= read_data;

end Behavioral;