library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEF_control is
  port (
    reset, hab_pc, clk : in std_logic;
    op : in std_logic_vector(6 downto 0);
    w_pc, branch, sel_dir, w_mem, w_instr, w_reg : out std_logic;
    sel_inmediato : out std_logic_vector(2 downto 0);
    modo_alu, sel_op1, sel_op2, sel_Y : out std_logic_vector(1 downto 0)
  );
end MEF_control;

architecture arch of MEF_control is
  type estado_t is (
    ESPERA,     --Espera que la RAM lea la instrucción a cargar
    CARGA,      --Carga una instrucción y avanza el contador de programa (PC)
    DECODIFICA, --Carga los valores de rs1 y rs2
    EJECUTA,    --Realiza un cálculo, carga rs2 en memoria o lee dato de memoria
    ALMACENA    --Almacena un resultado en RD o en el destino de un branch en PC
  );
  signal estado : estado_t;
  signal estado_sig : estado_t;
begin
  mem_estado : process(clk)
  begin
    if rising_edge(clk) then
      if reset then
        estado<=ESPERA;
      else estado <= estado_sig;
      end if;
    end if;
  end process;
  LES : process(all) -- Lógica de Estado Siguiente
  begin
    case (estado) is
      when ESPERA =>
      estado_sig<=CARGA;
      when CARGA =>
      estado_sig<=DECODIFICA;
      when DECODIFICA =>
      estado_sig<=EJECUTA;
      when EJECUTA =>
      estado_sig<=ALMACENA;
      when ALMACENA =>
      estado_sig <= ESPERA when hab_pc='1' else CARGA;
      when others =>
      estado_sig<=ESPERA; -- Valor por defecto para estados no especificados
      end case;
    end process;

    LS : process(all) -- Lógica de Salida
    begin
      -- Valores por defecto
      w_pc<='0';            --Escritura del contador de programa deshabilitado
      branch<='0';          --Salto inhabilitado
      w_mem<='0';           --Escritura de memoria deshabilitada
      w_instr<='0';         --Escritura de instruccion deshabilitada
      w_reg<='0';           --Escritura de registro deshabilitada
      sel_inmediato<="000"; --Valor inmediato siempre en cero
      modo_alu<="00";     --Seleccion en siempre suma
      sel_op1<="00";        --Selecciona PC por defecto
      sel_op2<="00";        --Selecciona por defecto a rs2
      sel_Y<="01";          --Salida Y directa de ALU
      
      case(estado) is
        when ESPERA =>
          --lectura*<=mem(PC)
        when CARGA =>
        --instr*<=lectura
        --pc_instr*<=PC
        w_instr<='1';
        --PC*<=PC+4
        sel_op1<="00";    --Selecciono PC
        sel_op2<="10";    --Selecciono la constante 4
        modo_alu<="00";   --ALU en modo suma
        sel_Y<="10";    --
        w_pc<='1';    --
        when DECODIFICA =>
        --carga rs1 y rs2
        when EJECUTA=>
          case(op) is
            when 7x"03"=>
            --lectura*<=mem(rs1+inmediato)
            sel_inmediato<="001";    --Segun rs1
            sel_op1<="10";    --Selecciona rs1
            sel_op2<="01";    --Selecciona el valor inmediato
            modo_alu<="01";   --Siempre suma
            sel_Y<="01";      --Selecciona la salida Y directamente desde la ALU para luego conectarla al contador de programa
            sel_dir<='1';     --Seleciona directamente la salida Y
            when 7x"13" =>
            --Y_alu_r*<=<op_alu>(rs1.inmediato)
            sel_inmediato<="001";    --
            sel_op1<="10";    --
            sel_op2<="01";    --
            modo_alu<="01";    --
            when 7x"23" =>
            --mem(rs1+inmediato)*<=rs2
            sel_inmediato<="010";    --
            sel_op1<="10";    --
            sel_op2<="01";    --
            modo_alu<="00";    --
            sel_Y<="01";    --
            sel_dir<='1';    --
            w_mem<='1';    --
            when 7x"33" =>
            --y_alu_r*<= <op_alu>(rs1,rs2)
            sel_op1<="10";    --
            sel_op2<="00";    --
            modo_alu<="10";    --
            when 7x"63" =>
            --Y_alu_r*<=pc_instr+inmediato
            sel_inmediato<="001";    --
            sel_op1<="01";    --
            sel_op2<="01";    --
            when 7x"67" =>
            --pc*<=rs1+inmediato
            sel_inmediato<="001";    --
            sel_op1<="10";    --
            sel_op2<="01";    --
            modo_alu<="00";    --
            sel_Y<="01";    --
            w_pc<='1';    --
            when 7x"6F" =>
            --pc*<=pc_instr+inmediato
            sel_inmediato<="101";    --
            sel_op1<="01";    --
            sel_op2<="01";    --
            sel_Y<="01";    --
            w_pc<='1';    --
            when others =>
            --No hace nada
            end case;
        when ALMACENA =>
        case (op) is
          when 7x"03" =>
          --RD*<=lectura
          sel_Y<="00";    --
          w_reg<='1';    
          --Inicio de bloque que genera conflicto
          --when 7x"13"|7x"33" =>
          --RD*<=Y_alu_r
          --sel_Y<="10";    --
          --w_reg<='1';    
          --Fin del bloque que genera conflicto

          --Inicio de solución al conflicto
          when 7x"13" =>
          --dat_lectura*<=mem(PC)
          sel_Y<="10";    --
          w_reg<='1'; 
          when 7x"33" =>
          --RD*<=Y_alu_r
          sel_Y<="10";    --
          w_reg<='1'; 
          -- Fin de solucion al conflicto
          
          when 7x"63" =>
          --Z<= <comp>(rs1,rs2)?=0
          sel_op1<="10";    --
          sel_op2<="00";    --
          modo_alu<="11";    --
          --si Z=Z_branch: PC*<=Y_alu_r
          sel_Y<="10";    --
          branch<='1';    --
          when 7x"67"|7x"6F" =>
          --RD*<=pc_instr+4
          sel_op1<="01";    --
          sel_op2<="10";    --
          modo_alu<="00";    --
          sel_Y<="01";    --
          w_reg<='1';    --
          when others =>
          --No hace nada
        end case; --Termina el caso op
      when others =>
      --No hace nada, no debería ocurrir
      end case; --Termina el caso estado
    end process; --Termina el proceso de Lógica de salida

end arch;
