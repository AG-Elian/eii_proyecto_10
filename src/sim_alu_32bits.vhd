library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;
use work.util_sim.all;

entity sim_alu_32bits is
end sim_alu_32bits;

architecture sim of sim_alu_32bits is
  component alu_32bits is
    port (
    A, B : in  std_logic_vector(31 downto 0);
    sel  : in  std_logic_vector(3 downto 0);
    Z    : out std_logic;
    Y    : out std_logic_vector(31 downto 0)
  );
  end component; -- alu_32bits
  signal entradaA, entradaB, salida : std_logic_vector (31 downto 0);
  signal salida_cero : std_logic;
  signal sel : std_logic_vector(3 downto 0);
begin
  -- Dispositivo bajo prueba
  dut : alu_32bits port map (A=>entradaA,B=>entradaB,sel=>sel,Y=>salida,Z=>salida_cero);

  excitaciones: process
  variable aleatorio : aleatorio_t;
  begin
    for i in 0 to 10 loop
      entradaA  <= aleatorio.genera_vector(32);
      entradaB  <= aleatorio.genera_vector(32);
      sel <= aleatorio.genera_vector(4);
      wait for 1 ns;
    end loop;
    wait for 1 ns; -- Espera extra antes de salir
    finish;
  end process; -- excitaciones
end sim;
