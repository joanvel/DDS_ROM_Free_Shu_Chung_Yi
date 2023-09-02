library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity TB is
	generic (g_bits:integer:=16);
end TB;

Architecture RTL of TB is
	component DDS_sine_and_cosine is
		generic(g_bits:integer:=g_bits);
		port
				(i_Clk:in std_logic
				;i_fctrl:in std_logic_vector(g_bits-1 downto 0)
				;i_reset:in std_logic
				;o_sin:out std_logic_vector(g_bits-1 downto 0)
				;o_cos:out std_logic_vector(g_bits-1 downto 0)
				);
	end component;
	
	signal s_Clk:std_logic;
	signal s_fctrl:std_logic_vector(g_bits-1 downto 0);
	signal s_reset:std_logic;
	signal s_sin:std_logic_vector(g_bits-1 downto 0);
	signal s_cos:std_logic_vector(g_bits-1 downto 0);
	file fsin:text;
	file fcos:text;
begin
	--Señal de frecuencia de control
	s_fctrl<="0010000000000000";
	--Señal de reinicio
	process
	begin
		s_reset<='0';
		wait for 5 ns;
		s_reset<='1';
		wait;
	end process;
	--señal de reloj
	process
	begin
		s_clk<='1';
		wait for 5 ns;
		s_clk<='0';
		wait for 5 ns;
	end process;
	--Almacenamiento de datos
	process(s_sin, s_cos)
		variable l:line;
		variable status:file_open_status;
	begin
		file_open(status,fsin,"C:\Users\joane\Documents\Signals\Sinusoidales\sin14.txt",append_mode);
		assert status=open_ok
			report "No se pudo crear sin.txt"
			severity failure;
		write(l,to_integer(signed(s_sin)));
		writeline(fsin,l);
		file_close(fsin);
	end process;
	process(s_cos,s_sin)
		variable l:line;
		variable status:file_open_status;
	begin
		file_open(status,fcos,"C:\Users\joane\Documents\Signals\Sinusoidales\cos14.txt",append_mode);
		assert status=open_ok
			report "No se pudo crear cos.txt"
			severity failure;
		write(l,to_integer(signed(s_cos)));
		writeline(fcos,l);
		file_close(fcos);
	end process;
	--llamo al componente
	DDS:	DDS_sine_and_cosine	port map (s_clk,s_fctrl,s_reset,s_sin,s_cos);
end RTL;
	
	