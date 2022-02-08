module Slave_tb();
reg sclk;
reg reset;
reg cs;
reg [7:0] slaveDataToSend; //din
wire [7:0] slaveDataReceived; //dout
reg MOSI;
wire MISO;
reg[7:0] masterDatatoSend;
reg[7:0] masterDataReceived;
integer k;
integer i;
integer index;

wire [7:0] testcase_masterData [1:5];
wire [7:0] testcase_slaveData  [1:5];

assign testcase_masterData[1] = 8'b11001100;
assign testcase_slaveData [1] = 8'b00110011;

assign testcase_masterData[2] = 8'b11000011;
assign testcase_slaveData [2] = 8'b10101010;

assign testcase_masterData[3] = 8'b11110000;
assign testcase_slaveData [3] = 8'b01110001;

assign testcase_masterData[4] = 8'b10010011;
assign testcase_slaveData [4] = 8'b10010000;

assign testcase_masterData[5] = 8'b10110010;
assign testcase_slaveData [5] = 8'b10100101;


Slave uut( reset, slaveDataToSend,slaveDataReceived,sclk,cs, MOSI, MISO);
initial begin
sclk=0;
reset=1;
k=0; 
cs=1;
index=1;
#5
cs=0;

assign slaveDataToSend=testcase_slaveData[index];
assign masterDatatoSend=testcase_masterData[index];
masterDataReceived=8'b00000000;

#10
reset=0;
for(i=0;i<300;i=i+1)begin
#5 sclk=~sclk;
end
#5
cs=1;
end

always@(posedge sclk)begin
if(cs==0)begin
MOSI<=masterDatatoSend[7-k];
k<=k+1;
#10 masterDataReceived[8-k]<=MISO;
if(k==9)begin
$display();
if(slaveDataReceived==masterDatatoSend)
$display(" SUCCESS from master to slave , masterDatatoSend %b , slaveDataReceived %b ",masterDatatoSend,slaveDataReceived);
else
$display(" FAILURE from master to slave , masterDatatoSend %b , slaveDataReceived %b ",masterDatatoSend,slaveDataReceived);
if(masterDataReceived==slaveDataToSend) 
$display("SUCCESS from slave to master , slaveDataToSend %b , masterDataReceived %b ",slaveDataToSend, masterDataReceived);
else
$display("FAILURE from slave to master , slaveDataToSend %b , masterDataReceived %b ",slaveDataToSend, masterDataReceived);
end
if(k==10&&index<5)begin
 k=0;
 index=index+1;

cs=1;
reset=1;
#5 cs=0;
reset=0;
end
end
end

endmodule
















