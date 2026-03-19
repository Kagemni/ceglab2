LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY singleCycleProc IS
    PORT(
        GClock      : IN  STD_LOGIC;
        GReset      : IN  STD_LOGIC;
        ValueSelect : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        MuxOut         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        InstructionOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        BranchOut      : OUT STD_LOGIC;
        ZeroOut        : OUT STD_LOGIC;
        MemWriteOut    : OUT STD_LOGIC;
        RegWriteOut    : OUT STD_LOGIC
    );
END singleCycleProc;

ARCHITECTURE structural OF singleCycleProc IS

    COMPONENT se16_32 IS
        PORT(
            i_in  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            o_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT sl2_32bit IS
        PORT(
            i_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            o_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT slj_26_28 IS
        PORT(
            i_in  : IN  STD_LOGIC_VECTOR(25 DOWNTO 0);
            o_out : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MUX2v1_5bit IS
        PORT(
            sel : IN  STD_LOGIC;
            a   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            b   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            z   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MUX2v1_8bit IS
        PORT(
            sel : IN  STD_LOGIC;
            a   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            b   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            z   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MUX4v1_32bit IS
        PORT(
            sel : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            a   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            b   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            c   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            d   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            z   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT AdderSubber_nBit IS
        GENERIC (N : integer := 32);
        PORT(
            AddSubCtrl  : IN  STD_LOGIC;
            x, y        : IN  STD_LOGIC_VECTOR(N-1 downto 0);
            Sum         : OUT STD_LOGIC_VECTOR(N-1 downto 0);
            CarryOut    : OUT STD_LOGIC;
            OverflowOut : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Alu8bits IS
        PORT(
            A          : IN  STD_LOGIC_VECTOR(7 downto 0);
            B          : IN  STD_LOGIC_VECTOR(7 downto 0);
            ALU_Sel    : IN  STD_LOGIC_VECTOR(2 downto 0);
            Result     : OUT STD_LOGIC_VECTOR(7 downto 0);
            Zero       : OUT STD_LOGIC;
            overflow   : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ControlPath IS
        PORT(
            Opcode   : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
            RegDst   : OUT STD_LOGIC;
            Jump     : OUT STD_LOGIC;
            Branch   : OUT STD_LOGIC;
            MemRead  : OUT STD_LOGIC;
            MemtoReg : OUT STD_LOGIC;
            ALUOp    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            MemWrite : OUT STD_LOGIC;
            ALUSrc   : OUT STD_LOGIC;
            RegWrite : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ALUControlUnit IS
        PORT(
            ALUOp  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            Funct  : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
            Operation : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT regfile IS
        PORT(
            clock       : IN  STD_LOGIC;
            reset       : IN  STD_LOGIC;
            read_reg1   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            read_reg2   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            write_reg   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            write_data  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            reg_write   : IN  STD_LOGIC;
            read_data1  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            read_data2  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT InstructionMemory IS
        PORT(
            address  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
				clock 	: IN STD_LOGIC;
            data     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT DataMemory IS
        PORT(
            clock      : IN  STD_LOGIC;
            address    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            write_data : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            mem_write  : IN  STD_LOGIC;
            mem_read   : IN  STD_LOGIC;
            read_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
   END COMPONENT; 
	COMPONENT Register_32bit
    PORT (
    Clk : IN std_logic;
    enable : IN std_logic;
    reset : IN std_logic;
    Data_IN : IN std_logic_vector(31 downto 0);
    Data_out : OUT std_logic_vector(31 downto 0)
    );
	 END COMPONENT;
	
	

    SIGNAL s_PC              : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_PC_next         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_PC_plus4        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_Instruction     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    SIGNAL s_RegDst          : STD_LOGIC;
    SIGNAL s_Jump            : STD_LOGIC;
    SIGNAL s_Branch          : STD_LOGIC;
    SIGNAL s_MemRead         : STD_LOGIC;
    SIGNAL s_MemtoReg        : STD_LOGIC;
    SIGNAL s_ALUOp           : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL s_MemWrite        : STD_LOGIC;
    SIGNAL s_ALUSrc          : STD_LOGIC;
    SIGNAL s_RegWrite        : STD_LOGIC;
    
    SIGNAL s_WriteReg        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL s_ReadData1       : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_ReadData2       : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_WriteData       : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL s_SignExtImm      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_ShiftedImm      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_BranchTarget    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_JumpAddr        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    SIGNAL s_ALU_B_input     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_ALU_Result      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_ALU_Zero        : STD_LOGIC;
    SIGNAL s_ALU_Control     : STD_LOGIC_VECTOR(2 DOWNTO 0);
    
    SIGNAL s_MemReadData     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL s_BranchTaken     : STD_LOGIC;
    SIGNAL s_PC_Source       : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
    SIGNAL s_ShiftedJump     : STD_LOGIC_VECTOR(27 DOWNTO 0);
    
    SIGNAL s_ControlMuxOut   : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  
	 PC_reg: Register_32bit
		PORT MAP(
			
			Clk => GClock,
			enable => '1',
			reset => GReset,
			Data_IN =>s_PC_next,
			Data_out =>s_PC
		);

    inst_mem: InstructionMemory
        PORT MAP(
            address => s_PC(9 DOWNTO 2),
				clock   => GClock,
            data    => s_Instruction
        );

    Adder_PC4: AdderSubber_nBit
        GENERIC MAP (N => 32)
        PORT MAP(
            AddSubCtrl  => '0',
            x           => s_PC,
            y           => X"00000004",
            Sum         => s_PC_plus4,
            CarryOut    => OPEN,
            OverflowOut => OPEN
        );

    se_inst: se16_32
        PORT MAP(
            i_in  => s_Instruction(15 DOWNTO 0),
            o_out => s_SignExtImm
        );

    sl2_branch: sl2_32bit
        PORT MAP(
            i_in  => s_SignExtImm,
            o_out => s_ShiftedImm
        );

    Adder_Branch: AdderSubber_nBit
        GENERIC MAP (N => 32)
        PORT MAP(
            AddSubCtrl  => '0',
            x           => s_PC_plus4,
            y           => s_ShiftedImm,
            Sum         => s_BranchTarget,
            CarryOut    => OPEN,
            OverflowOut => OPEN
        );

    slj_inst: slj_26_28
        PORT MAP(
            i_in  => s_Instruction(25 DOWNTO 0),
            o_out => s_ShiftedJump
        );

    s_JumpAddr <= s_PC_plus4(31 DOWNTO 28) & s_ShiftedJump;

    ctrl_unit: ControlPath
        PORT MAP(
            Opcode   => s_Instruction(31 DOWNTO 26),
            RegDst   => s_RegDst,
            Jump     => s_Jump,
            Branch   => s_Branch,
            MemRead  => s_MemRead,
            MemtoReg => s_MemtoReg,
            ALUOp    => s_ALUOp,
            MemWrite => s_MemWrite,
            ALUSrc   => s_ALUSrc,
            RegWrite => s_RegWrite
        );

    s_BranchTaken <= s_Branch AND s_ALU_Zero AND not s_Jump;
    s_PC_Source   <= s_Jump & s_BranchTaken;

    Mux_PC: MUX4v1_32bit
        PORT MAP(
            sel => s_PC_Source,
            a   => s_PC_plus4,
            b   => s_BranchTarget,
            c   => s_JumpAddr,
            d   => s_PC_plus4,
            z   => s_PC_next
        );

    Mux_RegDst: MUX2v1_5bit
        PORT MAP(
            sel => s_RegDst,
            a   => s_Instruction(20 DOWNTO 16),
            b   => s_Instruction(15 DOWNTO 11),
            z   => s_WriteReg
        );

    reg_file: regfile
        PORT MAP(
            clock      => GClock,
            reset      => GReset,
            read_reg1  => s_Instruction(25 DOWNTO 21),
            read_reg2  => s_Instruction(20 DOWNTO 16),
            write_reg  => s_WriteReg,
            write_data => s_WriteData,
            reg_write  => s_RegWrite,
            read_data1 => s_ReadData1,
            read_data2 => s_ReadData2
        );

    Mux_ALUSrc: MUX2v1_8bit
        PORT MAP(
            sel => s_ALUSrc,
            a   => s_ReadData2,
            b   => s_SignExtImm(7 DOWNTO 0),
            z   => s_ALU_B_input
        );

    alu_ctrl: AluControlUnit
        PORT MAP(
            AluOp  => s_ALUOp,
            Funct  => s_Instruction(5 DOWNTO 0),
            Operation => s_ALU_Control
        );

    ALU_inst: Alu8bits
        PORT MAP(
            A        => s_ReadData1,
            B        => s_ALU_B_input,
            ALU_Sel  => s_ALU_Control,
            Result   => s_ALU_Result,
            Zero     => s_ALU_Zero,
            overflow => OPEN
        );

    data_mem: DataMemory
        PORT MAP(
            clock      => GClock,
            address    => s_ALU_Result,
            write_data => s_ReadData2,
            mem_write  => s_MemWrite,
            mem_read   => s_MemRead,
            read_data  => s_MemReadData
        );

    Mux_MemtoReg: MUX2v1_8bit
        PORT MAP(
            sel => s_MemtoReg,
            a   => s_ALU_Result,
            b   => s_MemReadData,
            z   => s_WriteData
        );

    InstructionOut <= s_Instruction;
    BranchOut      <= s_Branch;
    ZeroOut        <= s_ALU_Zero;
    MemWriteOut    <= s_MemWrite;
    RegWriteOut    <= s_RegWrite;

    s_ControlMuxOut <= "0" & s_RegDst & s_Jump & s_MemRead & s_MemtoReg & s_ALUOp & s_ALUSrc;

    WITH ValueSelect SELECT
        MuxOut <= s_PC(7 DOWNTO 0)        WHEN "000",
                  s_ALU_Result             WHEN "001",
                  s_ReadData1              WHEN "010",
                  s_ReadData2              WHEN "011",
                  s_WriteData              WHEN "100",
                  s_ControlMuxOut          WHEN OTHERS;

END structural;