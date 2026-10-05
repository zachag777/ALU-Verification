# Parameterized ALU and UVM Verification Environment

Run it using the EDA Playground link: https://edaplayground.com/x/rLKd

## Project Description

SystemVerilog implementation of a parameterized Arithmetic Logic Unit (ALU) with a full UVM verification environment including functional coverage.
The ALU supports eight operations with distinct input signals for the two operands and a 3-bit operation select.

## Implementation

The ALU uses separate modules for each operation, with a multiplexer selecting the appropriate result based on the operation select. The ALU takes one parameter, width, which determines the bit width of the input operands and output.

The ALU supports addition and subtraction using full adders and a ripple-carry adder structure. The logical operations perform bitwise operations on the input operands, while the shift operations perform logical left and right shifts.
The ALU has four status flags: negative, zero, carry, and overflow. The negative flag is set if the most significant bit of the result is logic high. The zero flag is set if the result is zero. The carry flag indicates a carry-out for addition and subtraction, or a bit shifted out during a shift operation. The overflow flag indicates whether a signed arithmetic operation produces a result outside the representable range.

## Operations and Status Flags

The ALU supports eight operations selected using a 3-bit input.

| Operation   | Select |
| ----------- | ------ |
| ADD         | `000`  |
| SUB         | `001`  |
| AND         | `010`  |
| OR          | `011`  |
| NOT         | `100`  |
| XOR         | `101`  |
| Left Shift  | `110`  |
| Right Shift | `111`  |

The ALU has four status flags.

| Flag     | Definition                                                            |
| -------- | --------------------------------------------------------------------- |
| Negative | Result's most significant bit                                         |
| Zero     | Result is all zeroes                                                  |
| Carry    | Carry-out from addition/subtraction or bit shifted out during a shift |
| Overflow | Signed arithmetic overflow                                            |

<img width="7289" height="2313" alt="Test Sequence Flow for ALU-2026-10-05-021042" src="https://github.com/user-attachments/assets/228bf157-6e08-41ee-8334-45fa52e3caa0" />

## Verification Environment

The sequences generate transactions that are sent to the sequencer. The sequencer routes the transactions from a sequence to the driver. The driver applies transactions to the DUT through a virtual interface. The monitor samples the inputs and outputs of the DUT through a virtual interface and broadcasts them as a transaction using an analysis port. The scoreboard receives transactions from the monitor, and uses the inputs to compare the actual outputs to expected outputs determined using a high-level reference model. The coverage subscriber receives the same transactions from the monitor, and samples the functional coverage model.

The agent creates the sequencer, driver, and monitor through the factory and connects the driver to the sequencer. The environment creates the agent, scoreboard, and coverage subscriber, and connects the monitor's analysis port to both. The test creates the environment, then starts a sequence on the sequencer and holds an objection until it completes.

## Scoreboard

The scoreboard uses a high-level reference model to determine the expected result and status flags for each transaction based on the input operands and operation select. The scoreboard compares the expected result and flags against the actual outputs sampled from the DUT by the monitor.

The expected result is determined independently of the internal implementation of the ALU. The negative and zero flags are determined using the expected result, while the carry and overflow flags are determined based on the operation being performed.

Any mismatch between the expected and actual outputs is reported as a verification error.

## Coverage Model

The coverage model has one overarching covergroup, which is sampled with each transaction.

### Coverpoints

* `operation_cp`: ADD, SUB, AND, OR, NOT, XOR, left shift, right shift
* Result and input boundary conditions
* Negative, zero, carry, and overflow flags

### Crosses

Each operation is crossed with the relevant flag conditions to confirm that the different flag states are tested for each operation.

## Tests

The verification environment implements two tests: a random test and a directed test. The random test sends transactions with randomized inputs and operation selects to exercise the ALU across a broad range of input combinations.

The directed test uses randomized inputs with set operations and specific input patterns to exercise boundary conditions and status flags. The directed test includes logic operations, shift operations, addition and subtraction cases, carry conditions, and positive and negative overflow conditions.

## Simulating

The ALU and verification environment were tested in EDA Playground because my university does not provide access to a license that can use UVM and functional coverage. To test this project in EDA Playground use the EDA Playground link provided at the top of this README.
