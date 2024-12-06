library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;

entity sim_registro32 is
end sim_registro32;

architecture sim of sim_registro32 is
  component registro32 is
    port (
      clk, hab, reset: in  std_logic;
      D : in std_logic_vector(31 downto 0); -- datos de entrada
      Q : out std_logic_vector(31 downto 0) --datos de salida
    );
  end component; -- registro32
  signal clk, hab, reset : std_logic;
  signal salida, entrada : std_logic_vector(31 downto 0);
begin
  -- Dispositivo bajo prueba
  dut : registro32 port map (D=>entrada,clk=>clk,hab=>hab,reset=>reset,Q=>salida);

  reloj: process
  begin
    clk<='0';
    wait for 1 ns;
    clk<='1';
    wait for 1 ns;
    end process; -- fin del proceso de reloj

  excitaciones: process
  variable aleatorio : aleatorio_t;
  procedure sig_ciclo is
    begin
      wait until rising_edge(clk);
      wait for 0.5 ns;
      end procedure;
      begin
        for k in 0 to 10 loop
          entrada <= aleatorio.genera_vector(32);
          hab <=aleatorio.genera_bit;
          sig_ciclo;
          finish;
      end process; -- excitaciones
  
end sim;
