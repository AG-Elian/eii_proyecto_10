library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;
use work.util_sim.all;

entity sim_branch_condition is
end sim_branch_condition;

architecture sim of sim_branch_condition is
  component branch_condition is
    port (
      funct3 : in  std_logic_vector(2 downto 0);
      Z_branch : out  std_logic
    );
  end component; -- branch_condition
  signal instruccion : std_logic_vector (31 downto 0);
  signal Z_branch : std_logic;
begin
  -- Dispositivo bajo prueba
  dut : branch_condition port map (funct3=>instruccion(31 downto 7),Z_branch=>Z_branch);

  excitaciones: process
  variable aleatorio : aleatorio_t;
  begin
    for i in 0 to 20 loop
      instruccion <= aleatorio.genera_vector(32);
      wait for 1 ns;
    end loop;
    wait for 1 ns; -- Espera extra antes de salir
    finish;
  end process; -- excitaciones
end sim;
