`timescale 1ns / 1ps

module Barrel_shifter_tb;
    reg clk;
    reg [31:0] data;
    reg [7:0] cmd;
    wire [31:0] out;
    reg [31:0] ref_out;
    reg flag;
    integer file, ref_file, status, ref_status, line;
    
    Barrel_shifter uut(.data(data), .cmd(cmd), .out(out));
    
    always #5 clk = ~clk; // Clock toggles every 5 time units
    
    initial begin
        clk = 0;
        file = $fopen("test.mem", "r"); // Open test file for reading
        ref_file = $fopen("ref_file.mem", "r"); // Open reference file for reading
        if (file == 0 || ref_file == 0) begin
            $display("Error: File not found!");
            $finish;
        end
        
        line = 0;
        while (!$feof(file) && !$feof(ref_file)) begin
            status = $fscanf(file, "%b %b\n", data, cmd); // Read data and cmd
            ref_status = $fscanf(ref_file, "%b\n", ref_out); // Read reference output
            
            if (status != 2 || ref_status != 1) begin
                $display("Error reading file at line %d", line);
                $finish;
            end
            
            #10;
            line = line + 1;
        end
        
        $fclose(file); // Close the files
        $fclose(ref_file);
        $finish;
    end
    
    always @(posedge clk) begin
        if (out == ref_out) begin
            flag = 1;
        end else begin
            flag = 0;
            $display("Mismatch at line %d: Expected %b, Got %b", line, ref_out, out);
        end
    end
endmodule
