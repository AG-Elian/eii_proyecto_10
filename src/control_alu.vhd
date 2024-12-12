library IEEE;
use IEEE.std_logic_1164.all;

entity control_alu is
  port (
    funct3   : in std_logic_vector(2 downto 0);
    funct7_5 : in std_logic;
    modo_alu : in std_logic_vector(1 downto 0);
    fn_alu   : out std_logic_vector(3 downto 0)
  );
end control_alu;

architecture arch of control_alu is
begin
  selector : process(all)
  begin
    case (modo_alu) is
      when "01" => --se realiza operacion con valor inmediato (addi, .., )
        fn_alu(3 downto 1)<= funct3;
        fn_alu(0)<=(funct3?="101") and funct7_5;
      when "10" => --se realiza una operacion entre registros (add, ...,)
        fn_alu <= funct3&funct7_5;
      when "11" => -- condicion de salto
        fn_alu <= "0"&funct3(2 downto 1)&"1";
      when others => --para otros casos, ej. "00", se establecerá en modo siempre suma
        fn_alu <= "0000"; -- modo suma
      end case;
    end process;
end arch;
