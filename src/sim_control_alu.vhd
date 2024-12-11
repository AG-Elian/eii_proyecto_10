library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;
use work.util_sim.all;

entity sim_control_alu is
end sim_control_alu;

architecture sim of sim_control_alu is
  component control_alu is
    port (
      funct3   : in std_logic_vector(2 downto 0);
      funct7_5 : in std_logic;
      modo_alu : in std_logic_vector(1 downto 0);
      fn_alu   : out std_logic_vector(3 downto 0)
    );
  end component; -- control_alu
  signal instruccion : std_logic_vector (31 downto 0);
  signal modo_alu : std_logic_vector(1 downto 0);
  signal fn_alu : std_logic_vector(3 downto 0);
begin
  -- Dispositivo bajo prueba
  dut : control_alu port map (funct3=>instruccion(14 downto 12),funct7_5=>instruccion(30),modo_alu=>modo_alu,fn_alu=>fn_alu);

  excitaciones: process
  variable aleatorio : aleatorio_t;
  begin
    for i in 0 to 20 loop
      instruccion <= aleatorio.genera_vector(32);
      modo_alu <= aleatorio.genera_vector(2);
      wait for 1 ns;
    end loop;
    wait for 1 ns; -- Espera extra antes de salir
    finish;
  end process; -- excitaciones
end sim;
