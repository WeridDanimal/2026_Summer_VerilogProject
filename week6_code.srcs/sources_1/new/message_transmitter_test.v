`timescale 1ns / 1ps

/*
objective: learning how to design a flexible message transmitter


currently untested:
    1. long, fixed messages
    2. messages embedded with non-static information

*/

module message_transmitter_test

#(parameter IDLE=0, parameter PRINT_CHAR=1, parameter UART_WAIT=2, parameter NEXT_CHAR=3)
(input clock, input reset, input transmitButton,
input rx,
output tx,
output [1:0] stateOutput,    // for simulation only
output [4:0] charIndex,
output [7:0] sentCharacter 
    );
    
wire [7:0] testMessage [3:0];
reg [1:0] messageState;
assign stateOutput=messageState;


reg [7:0] messageCounter;
assign charIndex=messageCounter;
assign sentCharacter=fullMessage[messageCounter];

assign testMessage[0]="H";
assign testMessage[1]="i";
assign testMessage[2]="\n";


//wire [7:0] fullMessage[27:0];   //confirmed to work at this scale
wire [7:0] fullMessage [224:0];   //needs 8 bits to store all indexes. functionality unkown
//wait a minute, my tests suggest that if simply send a 0 or 1, the receiver might not read it that way and just 
//print whatever character is assigned to unicode-8 uses


reg [15:0] testRegisters [7:0];

assign fullMessage[0]="R";
assign fullMessage[1]="e";
assign fullMessage[2]="g";
assign fullMessage[3]="i";
assign fullMessage[4]="s";
assign fullMessage[5]="t";
assign fullMessage[6]="e";
assign fullMessage[7]="r";
assign fullMessage[8]=" ";
assign fullMessage[9]="0";
assign fullMessage[10]=":";

assign fullMessage[11]="0"+testRegisters[0][0];
assign fullMessage[12]="0"+testRegisters[0][1];
assign fullMessage[13]="0"+testRegisters[0][2];
assign fullMessage[14]="0"+testRegisters[0][3];
assign fullMessage[15]="0"+testRegisters[0][4];
assign fullMessage[16]="0"+testRegisters[0][5];
assign fullMessage[17]="0"+testRegisters[0][6];
assign fullMessage[18]="0"+testRegisters[0][7];
assign fullMessage[19]="0"+testRegisters[0][8];
assign fullMessage[20]="0"+testRegisters[0][9];
assign fullMessage[21]="0"+testRegisters[0][10];
assign fullMessage[22]="0"+testRegisters[0][11];
assign fullMessage[23]="0"+testRegisters[0][12];
assign fullMessage[24]="0"+testRegisters[0][13];
assign fullMessage[25]="0"+testRegisters[0][14];
assign fullMessage[26]="0"+testRegisters[0][15];
assign fullMessage[27]="\n";


assign fullMessage[28]="R";
assign fullMessage[29]="e";
assign fullMessage[30]="g";
assign fullMessage[31]="i";
assign fullMessage[32]="s";
assign fullMessage[33]="t";
assign fullMessage[34]="e";
assign fullMessage[35]="r";
assign fullMessage[36]=" ";
assign fullMessage[37]="1";
assign fullMessage[38]=":";

assign fullMessage[39]="0"+testRegisters[1][0];
assign fullMessage[40]="0"+testRegisters[1][1];
assign fullMessage[41]="0"+testRegisters[1][2];
assign fullMessage[42]="0"+testRegisters[1][3];
assign fullMessage[43]="0"+testRegisters[1][4];
assign fullMessage[44]="0"+testRegisters[1][5];
assign fullMessage[45]="0"+testRegisters[1][6];
assign fullMessage[46]="0"+testRegisters[1][7];
assign fullMessage[47]="0"+testRegisters[1][8];
assign fullMessage[48]="0"+testRegisters[1][9];
assign fullMessage[49]="0"+testRegisters[1][10];
assign fullMessage[50]="0"+testRegisters[1][11];
assign fullMessage[51]="0"+testRegisters[1][12];
assign fullMessage[52]="0"+testRegisters[1][13];
assign fullMessage[53]="0"+testRegisters[1][14];
assign fullMessage[54]="0"+testRegisters[1][15];
assign fullMessage[55]="\n";

assign fullMessage[56]="R";
assign fullMessage[57]="e";
assign fullMessage[58]="g";
assign fullMessage[59]="i";
assign fullMessage[60]="s";
assign fullMessage[61]="t";
assign fullMessage[62]="e";
assign fullMessage[63]="r";
assign fullMessage[64]=" ";
assign fullMessage[65]="2";
assign fullMessage[66]=":";

assign fullMessage[67]="0"+testRegisters[2][0];
assign fullMessage[68]="0"+testRegisters[2][1];
assign fullMessage[69]="0"+testRegisters[2][2];
assign fullMessage[70]="0"+testRegisters[2][3];
assign fullMessage[71]="0"+testRegisters[2][4];
assign fullMessage[72]="0"+testRegisters[2][5];
assign fullMessage[73]="0"+testRegisters[2][6];
assign fullMessage[74]="0"+testRegisters[2][7];
assign fullMessage[75]="0"+testRegisters[2][8];
assign fullMessage[76]="0"+testRegisters[2][9];
assign fullMessage[77]="0"+testRegisters[2][10];
assign fullMessage[78]="0"+testRegisters[2][11];
assign fullMessage[79]="0"+testRegisters[2][12];
assign fullMessage[81]="0"+testRegisters[2][13];
assign fullMessage[82]="0"+testRegisters[2][14];
assign fullMessage[83]="0"+testRegisters[2][15];
assign fullMessage[84]="\n";

assign fullMessage[85]="R";
assign fullMessage[86]="e";
assign fullMessage[87]="g";
assign fullMessage[88]="i";
assign fullMessage[89]="s";
assign fullMessage[90]="t";
assign fullMessage[91]="e";
assign fullMessage[92]="r";
assign fullMessage[93]=" ";
assign fullMessage[94]="3";
assign fullMessage[95]=":";

assign fullMessage[96]="0"+testRegisters[3][0];
assign fullMessage[97]="0"+testRegisters[3][1];
assign fullMessage[98]="0"+testRegisters[3][2];
assign fullMessage[99]="0"+testRegisters[3][3];
assign fullMessage[100]="0"+testRegisters[3][4];
assign fullMessage[101]="0"+testRegisters[3][5];
assign fullMessage[102]="0"+testRegisters[3][6];
assign fullMessage[103]="0"+testRegisters[3][7];
assign fullMessage[104]="0"+testRegisters[3][8];
assign fullMessage[105]="0"+testRegisters[3][9];
assign fullMessage[106]="0"+testRegisters[3][10];
assign fullMessage[107]="0"+testRegisters[3][11];
assign fullMessage[108]="0"+testRegisters[3][12];
assign fullMessage[109]="0"+testRegisters[3][13];
assign fullMessage[110]="0"+testRegisters[3][14];
assign fullMessage[111]="0"+testRegisters[3][15];
assign fullMessage[112]="\n";

assign fullMessage[113]="R";
assign fullMessage[114]="e";
assign fullMessage[115]="g";
assign fullMessage[116]="i";
assign fullMessage[117]="s";
assign fullMessage[118]="t";
assign fullMessage[119]="e";
assign fullMessage[120]="r";
assign fullMessage[121]=" ";
assign fullMessage[122]="4";
assign fullMessage[123]=":";

assign fullMessage[124]="0"+testRegisters[4][0];
assign fullMessage[125]="0"+testRegisters[4][1];
assign fullMessage[126]="0"+testRegisters[4][2];
assign fullMessage[127]="0"+testRegisters[4][3];
assign fullMessage[128]="0"+testRegisters[4][4];
assign fullMessage[129]="0"+testRegisters[4][5];
assign fullMessage[130]="0"+testRegisters[4][6];
assign fullMessage[131]="0"+testRegisters[4][7];
assign fullMessage[132]="0"+testRegisters[4][8];
assign fullMessage[133]="0"+testRegisters[4][9];
assign fullMessage[134]="0"+testRegisters[4][10];
assign fullMessage[135]="0"+testRegisters[4][11];
assign fullMessage[136]="0"+testRegisters[4][12];
assign fullMessage[137]="0"+testRegisters[4][13];
assign fullMessage[138]="0"+testRegisters[4][14];
assign fullMessage[139]="0"+testRegisters[4][15];
assign fullMessage[140]="\n";

assign fullMessage[141]="R";
assign fullMessage[142]="e";
assign fullMessage[143]="g";
assign fullMessage[144]="i";
assign fullMessage[145]="s";
assign fullMessage[146]="t";
assign fullMessage[147]="e";
assign fullMessage[148]="r";
assign fullMessage[149]=" ";
assign fullMessage[150]="5";
assign fullMessage[151]=":";

assign fullMessage[152]="0"+testRegisters[5][0];
assign fullMessage[153]="0"+testRegisters[5][1];
assign fullMessage[154]="0"+testRegisters[5][2];
assign fullMessage[155]="0"+testRegisters[5][3];
assign fullMessage[156]="0"+testRegisters[5][4];
assign fullMessage[157]="0"+testRegisters[5][5];
assign fullMessage[158]="0"+testRegisters[5][6];
assign fullMessage[159]="0"+testRegisters[5][7];
assign fullMessage[160]="0"+testRegisters[5][8];
assign fullMessage[161]="0"+testRegisters[5][9];
assign fullMessage[162]="0"+testRegisters[5][10];
assign fullMessage[163]="0"+testRegisters[5][11];
assign fullMessage[164]="0"+testRegisters[5][12];
assign fullMessage[165]="0"+testRegisters[5][13];
assign fullMessage[166]="0"+testRegisters[5][14];
assign fullMessage[167]="0"+testRegisters[5][15];
assign fullMessage[168]="\n";

assign fullMessage[169]="R";
assign fullMessage[170]="e";
assign fullMessage[171]="g";
assign fullMessage[172]="i";
assign fullMessage[173]="s";
assign fullMessage[174]="t";
assign fullMessage[175]="e";
assign fullMessage[176]="r";
assign fullMessage[177]=" ";
assign fullMessage[178]="6";
assign fullMessage[179]=":";

assign fullMessage[180]="0"+testRegisters[6][0];
assign fullMessage[181]="0"+testRegisters[6][1];
assign fullMessage[182]="0"+testRegisters[6][2];
assign fullMessage[183]="0"+testRegisters[6][3];
assign fullMessage[184]="0"+testRegisters[6][4];
assign fullMessage[185]="0"+testRegisters[6][5];
assign fullMessage[186]="0"+testRegisters[6][6];
assign fullMessage[187]="0"+testRegisters[6][7];
assign fullMessage[188]="0"+testRegisters[6][8];
assign fullMessage[189]="0"+testRegisters[6][9];
assign fullMessage[190]="0"+testRegisters[6][10];
assign fullMessage[191]="0"+testRegisters[6][11];
assign fullMessage[192]="0"+testRegisters[6][12];
assign fullMessage[193]="0"+testRegisters[6][13];
assign fullMessage[194]="0"+testRegisters[6][14];
assign fullMessage[195]="0"+testRegisters[6][15];
assign fullMessage[196]="\n";

assign fullMessage[197]="R";
assign fullMessage[198]="e";
assign fullMessage[199]="g";
assign fullMessage[200]="i";
assign fullMessage[201]="s";
assign fullMessage[202]="t";
assign fullMessage[203]="e";
assign fullMessage[204]="r";
assign fullMessage[205]=" ";
assign fullMessage[206]="7";
assign fullMessage[207]=":";

assign fullMessage[208]="0"+testRegisters[7][0];
assign fullMessage[209]="0"+testRegisters[7][1];
assign fullMessage[210]="0"+testRegisters[7][2];
assign fullMessage[211]="0"+testRegisters[7][3];
assign fullMessage[212]="0"+testRegisters[7][4];
assign fullMessage[213]="0"+testRegisters[7][5];
assign fullMessage[214]="0"+testRegisters[7][6];
assign fullMessage[215]="0"+testRegisters[7][7];
assign fullMessage[216]="0"+testRegisters[7][8];
assign fullMessage[217]="0"+testRegisters[7][9];
assign fullMessage[218]="0"+testRegisters[7][10];
assign fullMessage[219]="0"+testRegisters[7][11];
assign fullMessage[220]="0"+testRegisters[7][12];
assign fullMessage[221]="0"+testRegisters[7][13];
assign fullMessage[222]="0"+testRegisters[7][14];
assign fullMessage[223]="0"+testRegisters[7][15];
assign fullMessage[224]="\n";




wire slowclock;
slow_clk slower(clock,reset,slowclock);

//instantiating button debouncers
   wire transmit_pulse;
   debouncer DEBOUNCE (
        .clk(clock),
        .PB(transmitButton),
        .PB_down(transmit_pulse)
        );  

    //  instantiate uart_tx
    wire active, char_done;
    uart_tx TX (
        .i_Clock(clock),
        //.i_Clocks_per_Bit('d1),   //if using the simulator, change this to 1
        .i_Clocks_per_Bit('d100),   //if using the simulator, change this to 1
        .i_Tx_DV(transmitAuthorizer),
        .i_Reset(reset),
        .i_Tx_Byte(fullMessage[messageCounter]),
        //.i_Tx_Byte(testMessage[messageCounter]),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(char_done)
    );

reg transmitAuthorizer;

always @(posedge clock or posedge reset)
//always @(posedge slowclock or posedge reset)
begin

    if(reset)
        begin
        transmitAuthorizer<=0;
        messageState<=0;
        testRegisters[0]<=16'hffff;
        testRegisters[1]<=0;
        testRegisters[2]<=0;
        testRegisters[3]<=0;
        testRegisters[4]<=0;
        testRegisters[5]<=0;
        testRegisters[6]<=0;
        testRegisters[7]<=0;
        end
    else
        begin
        
        case(messageState)
            IDLE:
                begin
                messageCounter<=0;
                transmitAuthorizer<=0;
                if(transmit_pulse)
                //if(transmitButton)
                    messageState<=PRINT_CHAR;
                else
                    messageState<=IDLE;
                end
            PRINT_CHAR:
                begin
                transmitAuthorizer<=1;
                messageState<=UART_WAIT;
                end
            UART_WAIT:
                begin
                transmitAuthorizer<=0;
                
                if(char_done)
                    messageState<=NEXT_CHAR;
                else
                    messageState<=UART_WAIT;
                end
            NEXT_CHAR:
                begin
                /*if(messageCounter==27)
                    messageState<=IDLE;
                */
                if(messageCounter==224)
                    messageState<=IDLE;
                else
                    begin
                    messageState<=PRINT_CHAR;
                    messageCounter<=messageCounter+1;
                    end
                end
        endcase
        
        
        end
end

//assign transmitAuthorizer=(messageState==)

endmodule
