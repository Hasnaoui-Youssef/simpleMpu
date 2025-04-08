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
        pc_inc : out std_logic;
        pc_ld  : out std_logic;
        ir_ld  : out std_logic;
        acc_ld : out std_logic;
        acc_oe : out std_logic;
        alufs : out std_logic_vector(3 downto 0)
    );

end sequencer;





architecture structural_seq of sequencer is
    type state_type is (fetch,decode, execute, halt, rst);
    signal curr_state, next_state : state_type := fetch;
begin
    state_reg:process(clk, reset)
    begin
        if reset = '1' then
            curr_state <= rst;
        elsif rising_edge(clk) then
            curr_state <= next_state;
        end if;
    end process;

    next_state <=
        halt when (curr_state = decode and opcode = "0111") else
        execute when (curr_state = decode) else
        decode when (curr_state = fetch) else
        fetch when (curr_state = execute or curr_state = rst) else
        rst when reset = '1' else halt;

    output_logic: process(curr_state, opcode, accZ, acc15)
    begin
        selA <= '0';
        selB <= '0';
        RnW <= '1';
        pc_ld <= '0';
        pc_inc <= '0';
        ir_ld <= '0';
        acc_ld <= '0';
        acc_oe <= '0';
        alufs <= "0000";
        case curr_state is
            when fetch =>
                ir_ld <= '1';
            when decode =>
                case opcode is
                    when "0000" =>
                        pc_inc <= '1';
                        selB <= '1';
                        selA <= '1';
                    when "0001" =>
                        RnW <= '0';
                        selA <= '1';
                        pc_inc <= '1';
                        acc_oe <= '1';
                    when "0010" =>
                        selA <= '1';
                        pc_inc <= '1';
                        selB <= '1';
                    when "0011" =>
                        selA <= '1';
                        pc_inc <= '1';
                        selB <= '1';
                    when "0100" =>
                        selB <= '0';
                        pc_ld <= '1';
                    when "0101" =>
                        if acc15 = '1' then
                            selB <= '0';
                            pc_ld <= '1';
                        end if;
                    when "0110" =>
                        if accZ = '0' then
                            selB <= '0';
                            pc_ld <= '1';
                        end if;
                    when "0111" =>
                        selA <= '0';
                        selB <= '0';
                        RnW <= '0';
                        ir_ld <= '0';
                        acc_ld <= '0';
                        acc_oe <= '0';
                        alufs <= "0000";
                    when others =>
                    end case;
            when execute =>
                case opcode is
                    when "0000" =>
                        acc_ld <= '1';
                    when "0001" =>
                        acc_ld <= '1';
                    when "0010" =>
                        acc_ld <= '1';
                        alufs <= "0010";
                    when "0011" =>
                        alufs <= "0001";
                        acc_ld <= '1';
                    when others =>
                    end case;
            when halt =>
            when rst =>
        end case;
    end process;
end structural_seq;

