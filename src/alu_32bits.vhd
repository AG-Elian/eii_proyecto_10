library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_32bits is
  port (
    A, B : in  std_logic_vector(31 downto 0);
    sel  : in  std_logic_vector(3 downto 0);
    Z    : out std_logic;
    Y    : out std_logic_vector(31 downto 0)
  );
end alu_32bits;

architecture structural of alu_32bits is
  component fn_cero32bits is -- Componente cero de 32 bits
    port (
      A : in std_logic_vector(31 downto 0);
      Y : out std_logic
    );
    end component;
  
  component and_32 is --Componente AND con entradas y salida de 32 bits
    port(
      A,B : in std_logic_vector(31 downto 0);
      Y   : out std_logic_vector(31 downto 0)
    );
    end component;

  component or_32 is --Función OR con entradas y salida de 32bits
    port(
      A,B : in std_logic_vector(31 downto 0);
      Y   : out std_logic_vector(31 downto 0)
    );
  end component;

  component xor_32 is -- Componente XOR con entrada y salida de 32 bits
    port(
      A,B : in std_logic_vector(31 downto 0);
      Y   : out std_logic_vector(31 downto 0)
    );
    end component;
  
  component fn_suma_resta is -- Componente SUMA/RESTA con entrada A y B 32 bits y selección. Salida de 32 bits
    port(
      A, B : in std_logic_vector(31 downto 0);
      sel : in std_logic;
      Y : out std_logic_vector(31 downto 0)
    );
    end component;
  component fn_menor_que is  -- Componente MENOR QUE con entradas de 32 bits y salida de 1 bit
    port(
      A, B : in std_logic_vector(31 downto 0);
      sin_signo : in std_logic;
      Y : out std_logic
    );
    end component;
    component desplaza_izq is -- Componente DESPLAZAMIENTO A LA IZQUIERDA: ingresa ceros desde la izquierda
      port(
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(4 downto 0);
        Y : out std_logic_vector(31 downto 0)
      );
      end component;

  component desplaza_der_32bits is -- Componente DESPLAZAMIENTO A LA DERECHA: ingresa ceros o unos desde la derecha
    port(
      A : in std_logic_vector(31 downto 0);
      B : in std_logic_vector(4 downto 0);
      con_signo : std_logic;
      Y : out std_logic_vector(31 downto 0)
    );
    end component;
  signal y_and, y_or, y_xor, y_suma_resta, y_desp_der, y_desp_izq, y_sel, y_menor : std_logic_vector(31 downto 0);
  constant relleno : std_logic_vector(30 downto 0) := (others => '0') ;
  signal resta, menor_sin_signo, desp_consigno, y_menorb : std_logic;
begin
  U1 : fn_suma_resta port map(A=>A, B=>B, sel=>resta, Y=>y_suma_resta);

  U2 : fn_menor_que port map(A=>A, B=>B, sin_signo=>menor_sin_signo, Y=>y_menorb); -- Debe corregirse la la salida

  U3 : desplaza_izq port map(A=>A, B=>B(4 downto 0), Y=>y_desp_izq);
  
  U4 : desplaza_der_32bits port map(A=>A, B=>B(4 downto 0), con_signo=>desp_consigno, Y=>y_desp_der);

  U5 : xor_32 port map(A=>A, B=>B, Y=>y_xor);

  U6 : and_32 port map( A=>A, B=>B, Y=>y_and);

  U7 : or_32 port map( A=>A, B=>B, Y=>y_or);

  y_menor <= relleno(30 downto 0)&y_menorb;

  with sel select
  y_sel <= y_suma_resta when "0000"|"0001",
           y_desp_izq when "0010"|"0011",
           y_menor when "0100"|"0101"|"0110"|"0111",
           y_desp_der when "1010"|"1011",
           y_xor when "1000"|"1001",
           y_or when "1100"|"1101",
           y_and when others;
  U8 : fn_cero32bits port map(A=>y_sel, Y=>Z);
  resta <= sel(0);
  menor_sin_signo <= sel(1);
  desp_consigno <= sel(0);

end structural;
