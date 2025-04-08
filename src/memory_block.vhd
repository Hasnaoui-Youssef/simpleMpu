library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity mem_block is
    Port (
        reset   : in  STD_LOGIC;                      -- Réinitialisation
        clk : in std_logic;
        RnW     : in  STD_LOGIC;                      -- Lecture/Écriture
        addr    : in  STD_LOGIC_VECTOR(11 downto 0);  -- Bus d'adresses (12 bits)
        data : inout  STD_LOGIC_VECTOR(15 downto 0)  -- Données d'entrée (16 bits)
    );
end mem_block;



architecture Behavioral_mem of mem_block is

    -- Déclaration de la mémoire : 4096 mots (2^12 adresses), 16 bits chacun

    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(15 downto 0);

    signal memory : memory_array;
    signal data_in : std_logic_vector(15 downto 0);
    signal data_out : std_logic_vector(15 downto 0);

begin

    process(reset, clk)

    begin

        if reset = '1' then
         memory <= (
	    	      0    => X"0100",  -- LDA @100h (opcode 0, adresse 0100h)

	    	      1    => X"2101",  -- ADD @101h (opcode 0010, adresse 0101h)

	    	      2    => X"6005",  -- JNE  @004h (opcode 0110, adresse 0005h)

	    	      3    => X"3100",  -- SUB @100h (opcode 0011, adresse 0100h)

	    	      4    => X"3100",  -- SUB @100h

	    	      5    => X"2100",  -- ADD @100h

	    	      6    => X"7000",  -- STP  (Stop)


	    	      256  => X"1111",  -- Donnée aléatoire à l'adresse 100h

	    	      257  => X"2222",  -- Donnée aléatoire à l'adresse 101h

	    	      others => (others => '0') -- Initialisation des autres adresses à 0
	    	      );

        elsif rising_edge(clk) then
            if RnW = '0' then  -- Mode écriture
                memory(to_integer(unsigned(addr))) <= data_in;
            else  -- Mode lecture
                data_out <= memory(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
    data <= data_out when RnW = '1' else data_in;
end Behavioral_mem;

