`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2025 14:58:26
// Design Name: 
// Module Name: Barrel_shifter
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


module Barrel_shifter( 
    input [31:0] data,
    input [7:0] cmd,
    output [31:0] out 
    );
    wire [31:0] Q,P,R,S,T,U;
    wire asr;
    wire [15:0] q;
    wire [7:0] p;
    wire [3:0] r;
    wire [1:0] s;
    wire t;
    
    
    
    // direction
    // Combining Left and Right Shift/Rotate input part
    genvar a;
    generate
        begin
            for(a=0; a<32; a= a+1) begin
                mux m1(data[a],data[31-a],cmd[5],Q[31-a]); //right = cmd[5]
            end
        end
    endgenerate
    
    // Combining Rotate and Shift
    // ASR = cmd[7] if asr = 1 ? arithmetic shift
    mux m2(1'b0,Q[31],cmd[7] & cmd[5],asr);
    
    
    // rotate = cmd[6]  rotate = 1 ? do rotate, no data is lost
    // total required stage = 5
    // stage = 1
    genvar b,c;
    generate
        begin
            for(b=0; b<16; b= b+1) begin
                mux m3(asr,Q[15-b],cmd[6],q[15-b]); // rotate = cmd[6]
            end
        end
    endgenerate
    
    generate
        begin
            for(c=0; c<16; c= c+1) begin
                mux m4(Q[31-c],q[15-c],cmd[4],P[31-c]); //n[4] = cmd[4]
                mux m5(Q[15-c],Q[31-c],cmd[4],P[15-c]); //n[4] = cmd[4]
            end
        end
    endgenerate
    
    // stage 2
    genvar d,e,f;
    generate
        begin
            for(d=0;d<8;d=d+1) begin
                mux m6(asr,P[7-d],cmd[6],p[7-d]); // rotate = cmd[6]
            end
        end
    endgenerate
    
    generate
        begin
            for(e=0;e<8;e=e+1) begin
                mux m7(P[31-e],p[7-e],cmd[3],R[31-e]); //n[3] = cmd[3]
                end
            for(f=0;f<24;f=f+1) begin
                mux m8(P[23-f],P[31-f],cmd[3],R[23-f]); //n[3] = cmd[3]
            end
        end
    endgenerate
    
    // stage = 3
    genvar g,h,i;
    generate
        begin
            for(g=0;g<4;g=g+1) begin
                mux m9(asr,R[3-g],cmd[6],r[3-g]); // rotate = cmd[6]
            end
        end
    endgenerate
    
    generate
        begin
            for(h=0;h<4;h=h+1) begin
                mux m10(R[31-h],r[3-h],cmd[2],S[31-h]); //n[2] = cmd[2]
                end
            for(i=0;i<28;i=i+1) begin
                mux m11(R[27-i],R[31-i],cmd[2],S[27-i]); //n[2] = cmd[2]
            end
        end
    endgenerate
    
    // stage = 4
    
    genvar j, k, l;
    generate
        begin
            for(j=0;j<2;j=j+1) begin
                mux m12(asr,S[1-j],cmd[6],s[1-j]); // rotate = cmd[6]
            end
        end
    endgenerate
    
    generate
        begin
            for(k=0;k<2;k=k+1) begin
                mux m13(S[31-k],s[1-k],cmd[1],T[31-k]); //n[1] = cmd[1]
            end
            for(l=0;l<30;l=l+1) begin
                mux m14(S[29-l],S[31-l],cmd[1],T[29-l]); //n[1] = cmd[1]
            end
        end
    endgenerate

    // stage = 5
    genvar n;
    mux m15(asr,T[0],cmd[6],t);
    generate
        begin
            mux m16(T[31],t,cmd[0],U[31]); //n[0] = cmd[0]
            for(n=0;n<31;n=n+1) begin
                mux m17(T[30-n],T[31-n],cmd[0],U[30-n]); //n[0] = cmd[0]
            end
        end
    endgenerate
    
    // Combining Left and Right Shift/Rotate output part
    genvar o;
    generate
        begin
            for(o=0; o<32; o= o+1) begin
                mux m18(U[o],U[31-o],cmd[5],out[31-o]); //right = cmd[5]
            end
        end
    endgenerate
    
    
endmodule





module mux( 
    input a,     // Input 0
    input b,     // Input 1
    input sel,   // Select line
    output y     // Output
);
    
    not (not_sel, sel);      
    and (and_a, a, not_sel); 
    and (and_b, b, sel); 
    or (y, and_a, and_b); 
    
endmodule