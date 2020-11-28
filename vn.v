`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 27.11.2020 12:20:16
// Design Name:
// Module Name: vn
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module vn(clk,reset,beta,vout,vout_en);
input clk;
input reset;
input [5:0]beta;
output reg [5:0]vout;
output reg vout_en;
reg [5:0]state,next_state;
reg [5:0]B; // register to take in BETA
reg [9:0]index;




reg enable,enable1,enable2,reset1,reset2;
wire [13:0]count,outcount;
wire [13:0]idbram;
//all the set of counters used are declared here
//defparam c1.COUNT_LEN=14,c2.COUNT_LEN=4,c3.COUNT_LEN=10;
counter_block c1(reset,clk,enable,count);
counter_block c2(reset1,clk,enable1,outcount);
counter_block c3(reset2,clk,enable2,idbram);




//BRAM declaration
  reg[3:0] addrB[767:0];
  reg[3:0] addrB_[767:0];
  reg weB[767:0];
  reg[5:0]dinB[767:0];
  wire[5:0]doutB[767:0];

  reg[3:0] addrB1[767:0];
  reg weB1[767:0];
  reg[5:0]dinB1[767:0];
  wire[5:0]doutB1[767:0];
  reg ena[767:0],enb[767:0];


  //STATE DECLARATION
`define RESET_STATE 6'd0
`define betain 6'd1
`define betain1 6'd2
`define betaout 6'd3
 `define betaout1 6'd4
 `define wait2 6'd5
`define finish 6'd6
`define testwait 6'd7
`define testwait1 6'd8
`define testwait2 6'd9
`define testwait3 6'd10
 `define testwait4 6'd11
  `define wait1 6'd12

  genvar i;
  generate
  for(i=0;i<768;i=i+1)
  begin
  blk_mem_gen_0 BETA (
    .clka(clk),    // input wire clka
    .ena(ena[i]),      // input wire ena
    .wea(weB[i]),      // input wire [0 : 0] wea
    .addra(addrB[i]),  // input wire [3 : 0] addra
    .dina(dinB[i]),    // input wire [5 : 0] dina
    .douta(doutB[i]),  // output wire [5 : 0] douta
    .clkb(clk),    // input wire clkb
    .enb(enb[i]),      // input wire enb
    .web(weB1[i]),      // input wire [0 : 0] web
    .addrb(addrB1[i]),  // input wire [3 : 0] addrb
    .dinb(dinB1[i]),    // input wire [5 : 0] dinb
    .doutb(doutB1[i])  // output wire [5 : 0] doutb
  );
  end
  endgenerate
//state for next state
always@(posedge clk or posedge reset) begin
if(reset)
state=6'd0;
else
state=next_state;
end




// code to register the input in
always@(posedge clk,posedge reset) begin
if(reset) begin
B=6'd0;
end
else begin
B=beta;
end
end



//COUNTER NEEEDED FOR BETA
always@(state or reset)
begin
if(reset) begin enable=1'b0; end
else
begin
case(state)
`RESET_STATE: begin
enable=1'b0;
end
`betain: begin
enable=1'b1;
end
`betain1: begin
enable=1'b1;
end

default: begin
enable=1'b0;
end
endcase
end
end


//BRAM_A ASSIGNEMENT
always@(state or reset)
begin
if(reset) begin enable1=1'b0; reset1=1'b1; end
else
begin
case(state)
`RESET_STATE: begin
enable1=1'b0;
reset1=1'b0;
end
`betain: begin
enable1=1'b0;
reset1=1'b0;
end

`betaout:begin enable1=1'b1; reset1=1'b0; end



default: begin
enable1=1'b0;
reset1=1'b0;
end

endcase
end
end


// RESET AND ENABLE FOR BRAMID COUNTER
always@(state or reset)
begin
if(reset) begin enable2=1'b0; reset2=1'b1;  end
else
begin
case(state)
`RESET_STATE: begin
enable2=1'b0;
reset2=1'b0;
end
`betain: begin
enable2=1'b0;
reset2=1'b0;
end

`testwait: begin
reset2=1'b1;
enable2=1'b0;
end
`testwait1: begin
reset2=1'b0;
enable2=1'b0;
end
`betaout1: begin
enable2=1'b1;
reset2=1'b0;
end

default: begin
enable2=1'b0;
reset2=1'b0;
end

endcase
end
end
/*
//counter needed for output
always@(state or reset)
begin
if(reset) enable1=1'b0;
else
begin
case(state)
`RESET_STATE: begin
enable1=1'b0;
end
`betain: begin
enable1=1'b0;
end
`betain1: begin
enable1=1'b0;
end

`wait1:begin enable1=1'b1; end
`wait2: begin enable1=1'b0; end
default: begin
enable=1'b0;
end
endcase
end
end
*/

// enable ports
always@(state,reset,count) begin
 if(reset) begin
 for(index=0;index<768;index=index+1) begin
 ena[index]=1'b0;
 enb[index]=1'b0;
 end
 end
 else begin
 case(state)
 `RESET_STATE: begin
  for(index=0;index<768;index=index+1) begin
 ena[index]=1'b0;
 enb[index]=1'b0;
 end
 end
 `betain: begin
for(index=0;index<768;index=index+1) begin
enb[index]=0;
if(index==count[13:4]) begin
ena[index]=1'd1;
end
else
begin
ena[index]=1'd0;
end
end
end

 `betain1: begin
for(index=0;index<768;index=index+1) begin
enb[index]=0;
if(index==count[13:4]) begin
ena[index]=1'd1;
end
else
begin
ena[index]=1'd0;
end
end
end


`wait1 :begin
for(index=0;index<768;index=index+1) begin
ena[index]=1;
end
end
`wait2 :begin
for(index=0;index<768;index=index+1) begin
ena[index]=1;
end
end
`betaout :begin
for(index=0;index<768;index=index+1) begin
ena[index]=1;
end
end
default: for(index=0;index<768;index=index+1) ena[index]=1;
endcase
end
end









//state changes here
always@(state,reset,count,outcount,idbram)
begin
if(reset)
begin
next_state=6'd0;
end
else begin
case(state)
`RESET_STATE: begin next_state=`betain; end
`betain: begin if(count[3:0]==4'd15) begin next_state=`betain1;  end else next_state=`betain; end
`betain1: begin if(count[13:4]==10'd768) begin next_state=`betaout; end else next_state=`betain; end
/*
`wait1: begin next_state=`wait2; end
`wait2: begin next_state=`testwait; end
`testwait: begin next_state=`betaout; end
`betaout: begin if(outcount[13:4]==10'd768) next_state=`finish; else next_state=`wait1; end

*/


`betaout: begin next_state=`testwait;   end
`testwait: begin  next_state=`testwait1;  end
`testwait1: begin  next_state=`testwait2;  end
`testwait2: begin  next_state=`testwait3;   end
`testwait3: begin next_state=`betaout1; end
`betaout1: begin if(idbram==13'b0_001_100_000_000) begin next_state=`testwait4;  end else next_state=`betaout1; end
`testwait4: begin  if(outcount==13'd16) next_state=`finish; else next_state=`betaout;  end







endcase
end
end

//functionality begins here
always@(state,reset,count,B,outcount,idbram)
begin
if(reset) begin
for(index=0;index<768;index=index+1) begin
weB[index]=0;
addrB[index]=0;
dinB[index]=0;
weB1[index]=0;
addrB1[index]=0;
dinB1[index]=0;
end
vout_en=1'd0;
vout=6'd0;
end
else begin
case(state)
`RESET_STATE: begin

end
`betain: begin
for(index=0;index<768;index=index+1) begin
dinB[index]=B;
addrB[index]=count[3:0];
weB[index]=1'b1;
end
end

`betain1: begin
for(index=0;index<768;index=index+1) begin
dinB[index]=B;
addrB[index]=count[3:0];
weB[index]=1'b1;
end
end


/*
`wait1: begin

vout_en=1'b0;

for(index=0;index<768;index=index+1) begin
weB[index]=1'd0;
addrB[index]=outcount[3:0];
end


end

`wait2:begin end

`betaout: begin

vout=doutB[outcount[13:4]];
if(outcount[13:4]!=10'd768)
vout_en=1'b1;
else
vout_en=1'b0;

end
*/

`betaout: begin //bramout

vout_en=1'b0;

for(index=0;index<768;index=index+1) begin
weB[index]=1'd0;
addrB[index]=outcount[3:0];
end


end


`betaout1: begin

vout=doutB[idbram];
if(idbram!=13'd768)
vout_en=1'b1;
else
vout_en=1'b0;

end



`finish : begin vout_en=0; end

default: begin end

endcase
end
end




endmodule
