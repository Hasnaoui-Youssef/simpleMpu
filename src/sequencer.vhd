library IEEE;

use IEEE.STD_LOGIC_1164.ALL;



entity sequencer is

    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        opcode : in  std_logic_vector(3 downto 0);
        accZ   : in  std_logic;
        acc15  : in  std_logic;
        selA   : out std_logic;
        selB   : out std_logic;
        RnW   : out std_logic;
        pc_ld  : out std_logic;
        ir_ld  : out std_logic;
        acc_ld : out std_logic;
        acc_oe : out std_logic;
        alufs : out std_logic_vector(3 downto 0)
    );

end sequencer;





architecture structural_seq of sequencer is
    signal Q      : std_logic_vector(3 downto 0);

    signal Q_next : std_logic_vector(3 downto 0);
begin



    -- Processus pour l'état présent : registre synchrone

    process(clk, reset)

    begin

        if reset = '1' then

            Q <= "0000";  -- Etat initial

        elsif rising_edge(clk) then

            Q <= Q_next;  -- Mise à jour avec l'état futur

        end if;

    end process;



    -- Logique combinatoire pour l'état futur

    Q_next(0) <= (not Q(3) and not Q(1) and not Q(0) and opcode(2) and opcode(1) and opcode(0)) or

                 (not Q(1) and Q(0) and opcode(2) and not opcode(1) and not opcode(0)) or

                 (not Q(2) and Q(1) and not Q(0) and not opcode(2) and not opcode(1) and opcode(0)) or

                 (not Q(3) and Q(2) and not Q(1)) or

                 (not Q(3) and Q(2) and Q(0)) or

                 (Q(3) and not Q(1) and Q(0)) or

                 (Q(3) and Q(1) and not Q(0));



    Q_next(1) <= (not Q(3) and not Q(1) and Q(0) and opcode(2) and not opcode(1) and not opcode(0)) or

                 (not Q(3) and not Q(1) and Q(0) and not acc15 and accZ and opcode(2) and not opcode(1)) or

                 (not Q(3) and not Q(1) and Q(0) and acc15 and not accZ and opcode(2) and not opcode(0)) or

                 (not Q(3) and Q(0) and not Q(1)) or

                 (not Q(3) and Q(2)) or

                 (Q(2) and not Q(1) and Q(0));



    Q_next(2) <= (not Q(3) and not Q(2) and Q(0) and not acc15) or

                 (not Q(3) and not Q(2) and Q(0) and not opcode(2)) or

                 (not Q(3) and not Q(2) and Q(0) and not accZ and not opcode(1)) or

                 (not Q(3) and not Q(2) and Q(0) and opcode(0)) or

                 (not Q(3) and not Q(2) and Q(0) and accZ and opcode(1)) or

                 (Q(1) and not Q(0) and opcode(1) and not opcode(0)) or

                 (Q(3) and Q(1) and not Q(0)) or

                 (Q(3) and Q(2) and not Q(1) and Q(0)) or

                 (not Q(3) and not Q(2) and Q(1) and not opcode(0)) or

                 (not Q(3) and not Q(2) and Q(1) and opcode(1));



    Q_next(3) <= (not Q(3) and not Q(2) and not Q(1) and not opcode(2)) or

                 (not Q(3) and not Q(2) and not Q(1) and not accZ and opcode(0)) or

                 (not Q(3) and not Q(2) and not Q(1) and opcode(1)) or

                 (not Q(3) and not Q(2) and not Q(1) and acc15 and opcode(0)) or

                 (not Q(3) and Q(2) and Q(1) and not Q(0) and not opcode(0)) or

                 (Q(3) and not Q(2) and Q(1) and not Q(0)) or

                 (Q(3) and Q(2) and not Q(1) and Q(0)) or

                 (not Q(3) and not Q(2) and not Q(1) and not Q(0)) or

                 (not Q(3) and not Q(2) and not Q(0) and not opcode(1) and opcode(0));



    -- Logique combinatoire pour les sorties

    selA    <= (Q(1) and not Q(0)) or Q(2) or Q(3);

    selB    <= Q(2) or Q(3);

    ir_ld   <= (not Q(2) and not Q(1) and Q(0));

    acc_ld  <= (not Q(3) and not Q(2) and Q(1) and not Q(0)) or (Q(3) and Q(2) and not Q(1) and not Q(0));

    acc_oe  <= (Q(3) and Q(2) and not Q(1) and Q(0));

    pc_ld   <= (Q(3) and not Q(2) and Q(1) and Q(0));

    RnW <= (not Q(3)) or (not Q(2)) or (not Q(0)) or Q(1);

    alufs(1) <= Q(1);

    alufs(0) <= (not Q(2)) or (not Q(0));

    alufs(3 downto 2) <= "00";



end structural_seq;

