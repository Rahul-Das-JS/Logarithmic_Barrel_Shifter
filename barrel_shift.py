# -*- coding: utf-8 -*-
"""
Created on Mon Feb 24 02:22:38 2025

@author: rahul
"""

import random
from itertools import product

def generate_three_bit_combinations():
    return [''.join(bits) for bits in product('01', repeat=3)]

def generate_test_file():
    file_path = "C:/Users/rahul/Vivado Projects/Barrel_shifter/Barrel_shifter.srcs/sim_1/new/test.mem"
    with open(file_path, "w") as file:
        for _ in range(16):
            data = "".join(random.choice("01") for _ in range(32))  # Generate 32-bit binary number
            for a in generate_three_bit_combinations():
                cmd = a + "00011"  # Combine "00011" with each 3-bit combination
                file.write(f"{data} {cmd}\n")

def ref_result_generate():
    input_file_path = "C:/Users/rahul/Vivado Projects/Barrel_shifter/Barrel_shifter.srcs/sim_1/new/test.mem"
    output_file_path = "C:/Users/rahul/Vivado Projects/Barrel_shifter/Barrel_shifter.srcs/sim_1/new/ref_file.mem"
    
    results = []
    
    with open(input_file_path, "r") as infile:
        for line in infile:
            parts = line.strip().split()
            if len(parts) != 2:
                continue  # Skip malformed lines
            
            data = int(parts[0], 2) & 0xFFFFFFFF  # Read 32-bit binary number (force 32-bit)
            cmd = int(parts[1], 2)  # Read 8-bit binary number
            
            # Extracting components from cmd
            shift_amount = cmd & 0x1F  # cmd[4:0] - Least 5 bits for shift amount
            direction = (cmd >> 5) & 0x1  # cmd[5] - Direction (0 = left, 1 = right)
            rotate = (cmd >> 6) & 0x1  # cmd[6] - Rotate (1 = rotate, 0 = shift)
            arithmetic = (cmd >> 7) & 0x1  # cmd[7] - Arithmetic shift (valid only for right shift)
            
            # Compute result
            if shift_amount == 0:
                ref = data  # No change if shift_amount is zero
            elif rotate:  # Rotate operation
                if direction:  # Right rotate
                    ref = ((data >> shift_amount) | (data << (32 - shift_amount))) & 0xFFFFFFFF
                else:  # Left rotate
                    ref = ((data << shift_amount) | (data >> (32 - shift_amount))) & 0xFFFFFFFF
            else:  # Shift operation
                if direction:  # Right shift
                    if arithmetic:  # Arithmetic shift (preserve sign bit)
                        sign_extend = (0xFFFFFFFF << (32 - shift_amount)) & 0xFFFFFFFF if (data & 0x80000000) else 0
                        ref = ((data >> shift_amount) | sign_extend) & 0xFFFFFFFF
                    else:  # Logical shift
                        ref = (data >> shift_amount) & 0xFFFFFFFF
                else:  # Left shift (logical only)
                    ref = (data << shift_amount) & 0xFFFFFFFF  # Force 32-bit result
            
            # Format the result as a 32-bit binary string
            results.append(f"{ref:032b}")
    
    # Writing to output file
    with open(output_file_path, "w") as outfile:
        outfile.write("\n".join(results))
    
    print(f"Results saved to {output_file_path}")




generate_test_file()
ref_result_generate()