library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;

entity sim_control_alu is
end sim_control_alu;

architecture sim of sim_control_alu is
  component control_alu is
    port (
      A : in  std_logic;
      B : in  std_logic;
      Y : out std_logic
    );
  end component; -- control_alu
  signal entradas : std_logic_vector (1 downto 0);
  signal salida : std_logic;
begin
  -- Dispositivo bajo prueba
  dut : control_alu port map (A=>entradas(1),B=>entradas(0),Y=>salida);

  excitaciones: process
  begin
    for i in 0 to (2**entradas'length)-1 loop
      entradas <= std_logic_vector(to_unsigned(i,entradas'length));
      wait for 1 ns;
    end loop;
    wait for 1 ns; -- Espera extra antes de salir
    finish;
  end process; -- excitaciones
end sim;
