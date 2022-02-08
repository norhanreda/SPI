
module Slave(reset,din,dout,sclk,cs,mosi,miso);
input wire reset,sclk,cs,mosi;
input wire[7:0]din;//to send
output reg[7:0]dout;//received
output reg miso;
reg [7:0]regi;
integer k;

always@(negedge cs)
begin
regi<=din;
k<=0;
end
always@(posedge reset)begin
regi=8'b00000000;
dout<=8'b00000000;
miso<=0;
k<=-1;
end
always@(posedge sclk)begin//shifting=sending
if(reset==0)begin
if(cs==0)begin
if(k>=0&&k<=8)begin
miso<=regi[7];
end
else if(k==9)
k=-1;
end
if(cs==1)miso=1'bZ;//elsee
end
end 
always@(negedge sclk)begin//receiving
if(reset==0)begin
if(cs==0)begin//reset==0&&
if(k>=0&&k<=8)begin
regi<=regi<<<1;
regi[0]<=0;
regi[0]<=mosi;
k=k+1;
end
if(k==9)
begin
dout<=regi;
end
end
end
end
endmodule
