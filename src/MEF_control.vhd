library IEEE;
use IEEE.std_logic_1164.all;

entity MEF_control is
  port (
    reset, hab_pc, clk : std_logic;
    w_pc, branch, sel_dir, w_mem, w_instr, w_reg : out std_logic;
    sal_inmediato : out std_logic_vector(2 downto 0);
    modo_alu, sel_op1, sel_op2, sel_Y : out std_logic_vector(1 downto 0)
  );
end MEF_control;

architecture arch of MEF_control is
begin
  Y <= A and B;
end arch;
