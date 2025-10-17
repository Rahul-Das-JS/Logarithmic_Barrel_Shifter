# 🧮 Logarithmic Barrel Shifter (32-bit) — Structural Verilog Implementation

## 📘 Overview
This project implements a **32-bit Logarithmic Barrel Shifter** in **structural Verilog**, designed to efficiently perform multiple **shift** and **rotate** operations.  
It supports:
- Logical Left Shift  
- Logical Right Shift  
- Arithmetic Right Shift  
- Rotate Left  
- Rotate Right  

The design uses a **logarithmic architecture** based on staged multiplexing to achieve fast, scalable data shifting with minimal delay.  
A **Verilog testbench** and **Python-based verification script** were developed to ensure correctness across all operation types and shift magnitudes.

---

## ⚙️ Specifications

### 🧩 Inputs
- **Data (32-bit):** The operand to be shifted or rotated.  
- **Command Word (8-bit):** Controls the operation.  

| Bit(s) | Signal | Description |
|:-------:|:--------|:-------------|
| cmd[4:0] | Shift Amount | Number of bit positions (0–31) |
| cmd[5] | Direction | 0 = Left, 1 = Right |
| cmd[6] | Operation Type | 0 = Shift, 1 = Rotate |
| cmd[7] | Shift Mode | 1 = Arithmetic (only for right shift), 0 = Logical |

---

## 🧠 Design Architecture

The **logarithmic barrel shifter** is implemented using a **hierarchical multiplexer structure**.  
Each stage performs a shift corresponding to a power-of-two number of bits (1, 2, 4, 8, 16).  
The final output is determined by combining intermediate results based on the shift amount and control signals.

### Key Features:
- Fully **combinational** structural Verilog design (no sequential logic).  
- Implements **bidirectional shifting/rotation** with minimal logic depth.  
- **Arithmetic right shift** implemented with sign bit extension.  
- Optimized for **synthesis and simulation efficiency**.

---

## 🧪 Testbench Description

A non-synthesizable **Verilog testbench** was created to validate all possible operations.  
It:
- Reads **16 data words (32-bit)** and **8-bit command words** from an input file (`test.mem`).  
- Applies each combination sequentially to the barrel shifter.  
- Compares the output with precomputed reference values from a file (`ref_file.mem`).  
- Reports mismatches during simulation.

### Simulation Flow:
1. Open test and reference files.  
2. For each line:  
   - Read input data and command word.  
   - Wait for output stabilization.  
   - Compare with expected output.  
3. Display mismatches and summary results.  

---

## 🐍 Python Verification Script

Two Python scripts were used for:
1. **Generating test vectors** (`test.mem`)  
2. **Computing reference outputs** (`ref_file.mem`)

### Python Workflow:
- Generates 16 random 32-bit data words.
- Creates command combinations for all operation types.
- Computes expected shift/rotate results using bitwise operations.
- Writes binary results to reference output files.

### Key Functions:
- **`generate_test_file()`** → Creates input test cases.  
- **`ref_result_generate()`** → Computes and stores expected outputs.  

---

## 🧰 Tools & Environment

| Tool | Purpose |
|------|----------|
| **Xilinx Vivado** | Simulation and Verification |
| **Python 3.x** | Test Data and Reference Generation |
| **Verilog (Structural)** | Hardware Description |
| **Operating System** | Windows/Linux Compatible |

---

## 🧾 File Structure
