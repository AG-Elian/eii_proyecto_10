library IEEE;
use IEEE.std_logic_1164.all;

entity cpu is
  port (
    reset, clk, hab_w: in std_logic;
    lectura : in std_logic_vector(31 downto 0);
    dir : out std_logic_vector(31 downto 2);
    escritura : out std_logic_vector(31 downto 0);
  );
end cpu;

architecture arch of cpu is
  --Aqui se declaran los compoenentes
  component alu_32bits is
    port(
      A, B : in  std_logic_vector(31 downto 0);
      sel  : in  std_logic_vector(3 downto 0);
      Z    : out std_logic;
      Y    : out std_logic_vector(31 downto 0)
    );
    end component;

  component branch_condition is
    port(
      funct3 : in  std_logic_vector(2 downto 0);
      Z_branch : out  std_logic
    );
    end component;

  component reg_32x32 is
    port(
      clk, hab_w : in  std_logic;
      dir_w, dir_r1, dir_r2 : in  std_logic_vector(4 downto 0); -- direcciones de lectura/escritura
      dat_w : in std_logic_vector(31 downto 0); -- datos de escritura
      dat_r1, dat_r2 : out std_logic_vector(31 downto 0) --datos de lectura
    );
    end component;
  
  component MEF_control is
    port(
      reset, hab_pc, clk : std_logic;
      w_pc, branch, sel_dir, w_mem, w_instr, w_reg : out std_logic;
      sal_inmediato : out std_logic_vector(2 downto 0);
      modo_alu, sel_op1, sel_op2, sel_Y : out std_logic_vector(1 downto 0)
    );
    end component;
  component registro32 is
    port(
      A,B : in std_logic_vector;
    );
    end component;

  component control_alu is
    port(
        A,B : in std_logic_vector;
      );
    end component;
  component valor_inmediato is
    port(
        A,B : in std_logic_vector;
      );
    end component;
      --Señales de la MEF
  signal esc_pc, branch, sel_dir, esc_mem, esc_instr, esc_reg : std_logic;
  signal sel_inmediato : std_logic_vector(2 downto 0);
  signal modo_alu, sel_op1, sel_op2, sel_y : std_logic_vector(1 downto 0);
  --Salidas de registros
  signal pc, pc_instr, instr, y_alu_r : std_logic_vector(31 downto 0);
  --Señales de conjunto de registros (dat1 y dat2)
  signal rs1, rs2 : std_logic_vector(31 downto 0);
  --Señales varias
  signal inmediato : std_logic_vector(31 downto 0);
  signal sel_alu : std_logic_vector(3 downto 0);
  signal Z_branch, hab_pc, Z : std_logic;
  signal Y_alu, Y, op1, op2 : std_logic_vector(31 downto 0);

begin
  hab_pc<=esc_pc or (branch and (Z xor Z_branch));
  R_pc : registro32 port map(clk=>clk, reset=>reset, hab=>hab_pc, D=>Y, Q=>pc);
  dir <= Y when sel_dir else PC;
  escritura <= rs2;
  R_pc_instr : registro32 port map(clk<=clk, rst<='0',hab=>);
  U_control : MEF_control port map();
  U_registro : registro_32x32 port map();
  valor_inmediato : valor_inmediato port map(instr=>, inmediato=>inmediato,sel=>sel_inmediato);
  U_sel_alu : control_alu port map();
  U_Z_branch : branch_condition port map(funct3=>instr(14 downto 12), Z_branch=>Z_branch);
  mux_op1 : ;
  -- fin del multiplexor de seleccion 1
  mux_op2 : ;
  -- fin del multiplexor de seleccion 2
  ALU : alu_32bits port map(A=>op1,B=>op2,sel=>sel_alu,Y=>Y_alu,Z=>Z);
  U_retardo : registro32 port map();
  mux_sel_Y : with sel select
  Y<= dat_lectura when '00',
      y_alu,
      y_alu_r;
      --fin del multiplexor de seleccion de salida Y
end arch;
