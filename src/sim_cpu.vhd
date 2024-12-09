library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;

entity sim_cpu is
end sim_cpu;

architecture sim of sim_cpu is
  component cpu is
    port (
      reset, clk: in std_logic;
      hab_w : out std_logic;
      lectura : in std_logic_vector(31 downto 0);
      dir : out std_logic_vector(31 downto 2);
      escritura : out std_logic_vector(31 downto 0)
    );
  end component; -- fin del componente cpu
  component ram_256x32 is
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
      end component;
  signal clk, reset, hab_w : std_logic;
  signal lectura, escritura : std_logic_vector(31 downto 0);
  signal dir : std_logic_vector(31 downto 2);
begin
  -- Dispositivo bajo prueba
  dut : cpu port map (reset=>reset,clk=>clk,lectura=>lectura,escritura=>escritura,hab_w=>hab_w);
  memoria : ram_256x32 generic map(archivo=>"C:/Facet/Tercer_anio/Anio2024/Electronica_II/Proyecto_10/eii_proyecto_10/src/origen.mem") port map (
    clk_w=>clk,clk_r=>clk,
    dir_w=>dir(9 downto 2),
    dir_r=>dir(9 downto 2),
    hab_w=>hab_w,
    hab_r=>'1',
    dat_w=>escritura,
    dat_r=>lectura
  );--direccion de archivo

  reloj : process
  begin
    clk<='0';
    wait for 1 ns;
    clk<='1';
    wait for 1 ns;
    end process;
  
  estimulo : process
  procedure espera_ciclo is
    begin
    wait until rising_edge_clk;
    wait for 0.5 ns;
    end procedure;
  begin
    reset<='1';
    espera_ciclo;
    reset<='0';
    for i in 0 to 9999 loop
      espera_ciclo;
    end loop;
    finish;
  end process; -- excitaciones
end sim;
