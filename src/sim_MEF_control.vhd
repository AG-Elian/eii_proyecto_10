library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.finish;
use work.util_sim.all;

entity sim_MEF_control is
end sim_MEF_control;

architecture sim of sim_MEF_control is
  component MEF_control is
    port (
      reset, hab_pc, clk : in std_logic;
      op : in std_logic_vector(6 downto 0);
      w_pc, branch, sel_dir, w_mem, w_instr, w_reg : out std_logic;
      sel_inmediato : out std_logic_vector(2 downto 0);
      modo_alu, sel_op1, sel_op2, sel_Y : out std_logic_vector(1 downto 0)
    );
  end component; -- MEF_control
  --Señales de entrada
  signal reset, hab_pc, clk : std_logic;
  signal instruccion : std_logic_vector(31 downto 0);
  --Señales de salida
  signal w_pc, branch, sel_dir, w_mem, w_instr, w_reg : std_logic;
  signal sel_inmediato : std_logic_vector(2 downto 0);
  signal modo_alu, sel_op1, sel_op2, sel_Y : std_logic_vector(1 downto 0);
begin
  -- Dispositivo bajo prueba
  dut : MEF_control port map (
    --Señales de entrada
    reset=>reset,hab_pc=>hab_pc,clk=>clk,
    op=>instruccion(6 downto 0),
    --Señales de salida
    w_pc=>w_pc,branch=>branch,sel_dir=>sel_dir,w_mem=>w_mem,w_instr=>w_instr,w_reg=>w_reg,
    sel_inmediato=>sel_inmediato,
    modo_alu=>modo_alu,sel_op1=>sel_op1,sel_op2=>sel_op2,sel_Y=>sel_Y
    );

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
        for k in 0 to 20 loop
          instruccion <= aleatorio.genera_vector(32);
          hab_pc <= leatorio.genera_bit;
          reset <= aleatorio.genera_bit;
          sig_ciclo;
          end loop;
          wait for 1 ns;
          finish;
      end process; -- excitaciones
end sim;
