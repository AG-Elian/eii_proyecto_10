library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
  port (
    reset, clk: in std_logic;
    lectura : in std_logic_vector(31 downto 0);
    hab_w : out std_logic;
    dir : out std_logic_vector(31 downto 2);
    escritura : out std_logic_vector(31 downto 0)
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
      clk, hab, reset: in  std_logic;
      D : in std_logic_vector(31 downto 0); -- datos de entrada
      Q : out std_logic_vector(31 downto 0) --datos de salida
    );
    end component;

  component control_alu is
    port(
      funct3   : in std_logic_vector(2 downto 0);
      funct7_5 : in std_logic;
      modo     : in std_logic_vector(1 downto 0);
      fn_alu   : out std_logic_vector(3 downto 0)
      );
    end component;
  component valor_inmediato is
    port(
      instr : in  std_logic_vector(31 downto 7);
      sel : in  std_logic_vector(2 downto 0);
      inmediato : out std_logic_vector(31 downto 0)
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
  R_pc_instr : registro32 port map(clk<=clk, reset<='0',hab=>esc_instr, D=>pc,Q=>pc_instr); --registro de instruccion de pc
  R_instr : registro32 port map(clk=>clk,reset=>'0',hab=>esc_instr,D=>lectura,Q=>instr); -- registro de instruccion
  U_control : MEF_control port map(clk=>clk,reset=>reset,w_pc=>esc_pc,branch=>branch,sel_dir=>sel_dir,w_mem=>esc_mem,w_instr=>esc_instr,w_reg=>esc_reg,
  modo_alu=>modo_alu,sel_op1=>sel_op1,sel_op2=>sel_op2,sel_Y=>sel_y);
  U_registro : registro_32x32 port map(clk=>clk,dir_r1=>instr(19 downto 15),
                dir_r2=>instr(24 downto 20),dir_w=>instr(11 downto 0),hab_w=>esc_reg,dat_w=>Y,dat_r1=>rs1,dat_r2=>rs2);
  valor_inmediato : valor_inmediato port map(instr=>instr(31 downto 7), inmediato=>inmediato,sel=>sel_inmediato);
  U_sel_alu : control_alu port map(funct3=>instr(14 downto 0), funct5_7=>inst(30),modo=>modo_alu,fn_alu=>sel_alu);
  U_Z_branch : branch_condition port map(funct3=>instr(14 downto 12), Z_branch=>Z_branch);
  mux_op1 : with sel select 
            op1<=pc   when "00",
                 pc_instr  when "01",
                 rs1       when others;
  -- fin del multiplexor de seleccion 1
  mux_op2 : with sel select 
            op2<=rs2        when "00",
                 inmediato  when "01",
                 32x"4"     when others;
  -- fin del multiplexor de seleccion 2
  ALU : alu_32bits port map(A=>op1,B=>op2,sel=>sel_alu,Y=>Y_alu,Z=>Z);
  U_retardo : registro32 port map(
    clk=>clk,
    hab=>'1',
    reset=>'0',
    D=>Y_alu, Q=>Y_alu_r
  );
  mux_sel_Y : with sel select
  Y<= lectura when "00",
      y_alu       when "01",
      y_alu_r     when others;--10
      --fin del multiplexor de seleccion de salida Y
end arch;
