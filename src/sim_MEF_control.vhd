library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;

entity sim_MEF_control is
end sim_MEF_control;

architecture sim of sim_MEF_control is
  component MEF_control is
    port (
      reset, hab_pc, clk : std_logic;
      w_pc, branch, sel_dir, w_mem, w_instr, w_reg : out std_logic;
      sal_inmediato : out std_logic_vector(2 downto 0);
      modo_alu, sel_op1, sel_op2, sel_Y : out std_logic_vector(1 downto 0)
    );
  end component; -- MEF_control
  signal entradas : std_logic_vector (1 downto 0);
  signal salida : std_logic;
begin
  -- Dispositivo bajo prueba
  dut : MEF_control port map (A=>entradas(1),B=>entradas(0),Y=>salida);

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
