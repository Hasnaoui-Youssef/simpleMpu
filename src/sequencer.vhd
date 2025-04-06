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
    type state_type is (fetch, decode, execute, halt);
    signal curr_state, next_state : state_type := fetch;
begin
    state_reg:process(clk, reset)
    begin
        if reset = '1' then
            curr_state <= fetch;
        elsif rising_edge(clk) then
            curr_state <= next_state;
        end if;
    end process;
    next_state_logic: process(curr_state, opcode, accZ, acc15)
    begin
        case curr_state is
            when fetch =>
                next_state <= decode;
            when decode =>
                if opcode = "0111" then
                    next_state <= halt;
                else
                    next_state <= execute;
                end if;
            when execute =>
                next_state <= fetch;
            when halt =>
                next_state <= halt;
        end case;
    end process;
    output_logic: process(curr_state, opcode, accZ, acc15)
    begin
        selA <= '0';
        selB <= '0';
        RnW <= '0';
        pc_ld <= '0';
        ir_ld <= '0';
        acc_ld <= '0';
        acc_oe <= '0';
        alufs <= "0000";
        case curr_state is
            when fetch =>
                RnW <= '1';
                selA <= '0';
                ir_ld <= '1';
            when decode =>

            when execute =>
                case opcode is
                    when "0000" =>
                        RnW <= '1';
                        selB <= '1';
                        selA <= '1';
                        acc_ld <= '1';
                        alufs <= "0000";
                    when "0001" =>
                        RnW <= '0';
                        selA <= '1';
                        acc_oe <= '1';
                        acc_ld <= '1';
                    when "0010" =>
                        selA <= '1';
                        selB <= '1';
                        acc_ld <= '1';
                        RnW <= '1';
                        alufs <= "0010";
                    when "0011" =>
                        selA <= '1';
                        selB <= '1';
                        acc_ld <= '1';
                        RnW <= '1';
                        alufs <= "0001";
                    when "0100" =>
                        RnW <= '1';
                        selB <= '0';
                        alufs <= "0000";
                        pc_ld <= '1';
                    when "0101" =>
                        if acc15 = '1' then
                            RnW <= '1';
                            selB <= '0';
                            alufs <= "0000";
                            pc_ld <= '1';
                        end if;
                    when "0110" =>
                        if accZ = '0' then
                            RnW <= '1';
                            selB <= '0';
                            alufs <= "0000";
                            pc_ld <= '1';
                        end if;
                    when "0111" =>
                        selA <= '0';
                        selB <= '0';
                        RnW <= '0';
                        pc_ld <= '0';
                        ir_ld <= '0';
                        acc_ld <= '0';
                        acc_oe <= '0';
                        alufs <= "0000";
                    when others =>
                end case;
            when halt =>
        end case;
    end process;
end structural_seq;

