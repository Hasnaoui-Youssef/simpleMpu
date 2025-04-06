library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpu is
    port (
        clk : in std_logic;
        reset: in std_logic
    );
end entity mpu;

architecture rtl of mpu is

    component sequencer is
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
    end component;
    component memValMux is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0); -- bus de donnees
        B : in STD_LOGIC_VECTOR(11 downto 0); -- bus d'addresse
        sel : in STD_LOGIC;
        s : out STD_LOGIC_VECTOR(15 downto 0)
    );
    end component;
    component acc is
    port (
        data_in : in std_logic_vector(15 downto 0);
        acc_ld : in std_logic;
        clk : in std_logic;
        data_out : out std_logic_vector(15 downto 0);
        accZ : out std_logic;
        acc15 : out std_logic
    );
    end component;
    component alu is
    port (
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        alufs : in std_logic_vector(3 downto 0);
        S : out std_logic_vector(15 downto 0)
    );
    end component;
    component ir is
    Port (
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        ir_ld        : in  STD_LOGIC;
        clk : in std_logic;
        data_out  : out STD_LOGIC_VECTOR(11 downto 0);
        opcode  : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;
    component mem_block is
    Port (
        clk     : in  STD_LOGIC;                      -- Horloge
        reset   : in  STD_LOGIC;                      -- Réinitialisation
        RnW     : in  STD_LOGIC;                      -- Lecture/Écriture
        addr    : in  STD_LOGIC_VECTOR(11 downto 0);  -- Bus d'adresses (12 bits)
        data : inout  STD_LOGIC_VECTOR(15 downto 0)  -- Données d'entrée (16 bits)
    );
    end component;
    component oe is
    port (
        data_in : in std_logic_vector(15 downto 0);
        en : in std_logic;
        data_out : out std_logic_vector(15 downto 0)
    );
    end component;

    component pc is
    Port (
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        pc_ld        : in  STD_LOGIC;
        clk : in std_logic;
        reset : in std_logic;
        data_out  : out STD_LOGIC_VECTOR(11 downto 0)
    );
    end component;
    component pcIrMux is
    Port (
        A : in STD_LOGIC_VECTOR(11 downto 0); -- pc
        B : in STD_LOGIC_VECTOR(11 downto 0); -- ir
        sel : in STD_LOGIC;
        s : out STD_LOGIC_VECTOR(11 downto 0)
    );
    end component;

    signal selA, selB, RnW, pc_ld, ir_ld, acc_ld, acc_oe, accZ, acc15 : std_logic;
    signal opcode, alufs : std_logic_vector(3 downto 0);
    signal alu_in1, alu_in2, alu_out: std_logic_vector(15 downto 0);
    signal ir_out, pc_out : std_logic_vector(11 downto 0);
    signal memBus : std_logic_vector(15 downto 0);
    signal addressBus : std_logic_vector(11 downto 0);

begin
sequencer_inst: sequencer
 port map(
    clk => clk,
    reset => reset,
    opcode => opcode,
    accZ => accZ,
    acc15 => acc15,
    selA => selA,
    selB => selB,
    RnW => RnW,
    pc_ld => pc_ld,
    ir_ld => ir_ld,
    acc_ld => acc_ld,
    acc_oe => acc_oe,
    alufs => alufs
);

mem_block_inst: mem_block
 port map(
    clk => clk,
    reset => reset,
    RnW => RnW,
    addr => addressBus,
    data => memBus
);

memValMux_inst: memValMux
 port map(
    A => memBus,
    B => addressBus,
    sel => selB,
    s => alu_in2
);

acc_inst: acc
 port map(
    clk => clk,
    data_in => alu_out,
    acc_ld => acc_ld,
    data_out => alu_in1,
    accZ => accZ,
    acc15 => acc15
);

alu_inst: alu
 port map(
    A => alu_in1,
    B => alu_in2,
    alufs => alufs,
    S => alu_out
);

oe_inst: oe
 port map(
    data_in => alu_in1,
    en => acc_oe,
    data_out => memBus
);
ir_inst: ir
 port map(
    data_in => memBus,
    ir_ld => ir_ld,
    clk => clk,
    data_out => ir_out,
    opcode => opcode
);

pc_inst: pc
 port map(
    data_in => alu_out,
    clk => clk,
    reset => reset,
    pc_ld => pc_ld,
    data_out => pc_out
);

pcIrMux_inst: pcIrMux
 port map(
    A => pc_out,
    B => ir_out,
    sel => selA,
    s => addressBus
);

end architecture rtl;
