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

architecture arch of ram_256x32 is
  type mem_t is array (0 to 255) of std_logic_vector(31 to 0);
  impure function inicializa(archivo : string) return mem_t is --impure quiere decir que esa funcion va a interactuar sobre el entorno
    file origen : text; -- selecciona el origen del archivo
    variable linea : line; -- se leera linea por linea
    variable contenido : mem_t ; --lo que se va a leer

    begin
      puerto_lectura : process (clk_r)
      begin
        if archivo="" then; -- si el archivo esta vacio, se pone en cero
        contenido:=(others=>32x"0");
        else 
          file_open(origen, archivo, READ_MODE);
          for k in contenido'range loop
            exit when endfile(origen);
            readline(origen,linea);
            hread(linea,contenido(k));
          end loop;
          file_close(origen);
        end if;
    return contenido;
  end function;

  signal mem : mem_t:=inicializa(archivo);

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
