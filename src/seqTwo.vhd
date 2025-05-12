library IEEE;

use IEEE.STD_LOGIC_1164.ALL;



entity seqTwo is

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

end seqTwo;





architecture st_st of seqTwo is
    signal cs : std_logic_vector(1 downto 0) := "00"; -- fetch = 01, decode = 10, execute = 11, rst = halt = 00
    signal ns : std_logic_vector(1 downto 0) := "00";
begin
    state_reg:process(clk, reset)
    begin
        if rising_edge(clk) then
            cs <= ns;
        end if;
    end process;

    ns(0) <= (not cs(0) or cs(1)) and not reset and not (opcode(2) and opcode(1) and opcode(0));
    ns(1) <= ( (cs(0) and not cs(1)) or (cs(1) and not cs(0) ) ) and not reset and not (opcode(2) and opcode(1) and opcode(0));

    ir_ld <= cs(0) and not cs(1);
    Rnw <= '0' when (cs(1) = '1' and cs(0) = '0' and opcode = "0001") else '1';
    selA <= cs(1) and not cs(0) and not opcode(2) and not opcode(3);
    selB <= cs(1) and not cs(0) and not opcode(3) and not opcode(2) and not (opcode(0) and not opcode(1));
    acc_ld <= cs(1) and cs (0) and not opcode(3) and not opcode(2) and not ( opcode(0) and not opcode(1) );
    pc_ld <= cs(1) and not cs(0) and not opcode(3) and opcode(2) and ((opcode(1) and not opcode(0) and not accZ) or (opcode(0) and not opcode(1) and acc15));
    pc_inc <= cs(1) and not cs(0) and not opcode(3) and (not opcode(2) or (opcode(2) and ((opcode(1) and not opcode(0) and accZ) or (opcode(0) and not opcode(1) and not accZ))));
    acc_oe <= cs(1) and not cs(0) and not opcode(3) and not opcode(2) and not opcode (1) and opcode(0);
    alufs(3) <= '0';
    alufs(2) <= '0';
    alufs(1) <= cs(1) and cs(0) and not opcode(3) and not opcode(2) and opcode(1) and not opcode(0);
    alufs(0) <= cs(1) and cs(0) and not opcode(3) and not opcode(2) and opcode(1) and opcode(0);

end st_st;

