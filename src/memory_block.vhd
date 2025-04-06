library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity mem_block is
    Port (
        clk     : in  STD_LOGIC;                      -- Horloge
        reset   : in  STD_LOGIC;                      -- Réinitialisation
        RnW     : in  STD_LOGIC;                      -- Lecture/Écriture
        addr    : in  STD_LOGIC_VECTOR(11 downto 0);  -- Bus d'adresses (12 bits)
        data_in : in  STD_LOGIC_VECTOR(15 downto 0);  -- Données d'entrée (16 bits)
        data_out: out STD_LOGIC_VECTOR(15 downto 0)   -- Données de sortie (16 bits)
    );
end mem_block;



architecture Behavioral_mem of mem_block is

    -- Déclaration de la mémoire : 4096 mots (2^12 adresses), 16 bits chacun

    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(15 downto 0);

    signal memory : memory_array := (

        -- Instructions principales

        0    => X"2100",  -- LDA @100h (opcode 21, adresse 0100h)

        1    => X"3101",  -- ADD @101h (opcode 31, adresse 0101h)

        2    => X"5404",  -- JNE  @004h (opcode 54, adresse 0004h)

        3    => X"4100",  -- SUB @100h (opcode 41, adresse 0100h)

        4    => X"4100",  -- SUB @100h

        5    => X"3100",  -- ADD @100h

        6    => X"0000",  -- STP  (Stop)



        -- Données aléatoires

        256  => X"ABCD",  -- Donnée aléatoire à l'adresse 100h

        257  => X"1234",  -- Donnée aléatoire à l'adresse 101h

        258  => X"5678",  -- Donnée aléatoire

        259  => X"9ABC",  -- Donnée aléatoire

        260  => X"DEFA",  -- Donnée aléatoire

        261  => X"1357",  -- Donnée aléatoire

        262  => X"2468",  -- Donnée aléatoire

        263  => X"FACE",  -- Donnée aléatoire

        264  => X"BEAD",  -- Donnée aléatoire

        265  => X"C0DE",  -- Donnée aléatoire

        others => (others => '0') -- Initialisation des autres adresses à 0

    );

begin

    process(clk, reset)

    begin

        if reset = '1' then
            -- Réinitialisation de la mémoire
            memory <= (others => (others => '0'));
            data_out <= (others => '0');
        elsif rising_edge(clk) then

            if RnW = '0' then  -- Mode écriture
                memory(to_integer(unsigned(addr))) <= data_in;
            else  -- Mode lecture
                data_out <= memory(to_integer(unsigned(addr)));
            end if;

        end if;

    end process;

end Behavioral_mem;

