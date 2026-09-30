# Parameterized ALU and UVM Verification Environment

## Project Description

SystemVerilog implementation of a parameterized ALU with a full UVM verification environment including functional coverage.
The ALU has eight distinct operations and a three bit function select input:

  3'b000: ADD
  3'b001: SUB
  3'b010: AND
  3'b011: OR
  3'b100: NOT
  3'b101: XOR
  3'b110: SHIFT LEFT
  3'b111: SHIFT RIGHT

## Implementation

The ALU uses ripple adders to implement binary addition and subtraction, and treats operands as two's complement signed values when determining
status flags. Subtraction uses the standard two's complement method of A - B = A + ~B + 1. The standard logic operations use SystemVerilog's
bitwise logic operators. The logical shift operations implement one bit logical shifts in the left and right directions using 2-to-1 MUXs, and
require a bit width of at least 2 bits to execute correctly.

## Status Flags

The ALU has four status flags: negative (N), zero (Z), carry (C) and overflow (V).

| Flag | ADD | SUB | LOGIC OPERATIONS | LEFT SHIFT | RIGHT SHIFT |
|----|----|----|----|----|----|
| N | MSB of result | MSB of result | MSB of result | MSB of result| Always 0 |
| Z | 1 if result = 0 | 1 if result = 0 | 1 if result = 0 | 1 if result = 0 | 1 if result = 0 |
| C | Carry-out of adder | Carry-out of subtracter | 0 | Bit shifted out | Bit shifted out |
| V | A and B have the same sign and the result's sign differs | A and B have different signs and the result's sign differs from A | 0 | 0 | 0 |

<img width="7289" height="2313" alt="Untitled diagram-2026-09-29-014609" src="https://github.com/user-attachments/assets/8bbef804-7440-4906-8e4a-a9705243e74b" />

## Verification Environment

The sequences generate transactions that are sent to the sequencer. The sequencer routes the transactions from a sequence to the driver. The driver applies transactions to the DUT through a virtual interface. The monitor samples the inputs and outputs of the DUT through a virtual interface and broadcasts them as a transaction using an analysis port. The scoreboard receives transactions from the monitor, and uses the inputs to compare the actual outputs to expected outputs determined using a high-level reference model. The coverage subscriber receives the same transactions from the monitor, and samples the functional coverage model.

The agent creates the sequencer, driver, and monitor through the factory and connects the driver to the sequencer. The environment creates the agent, scoreboard, and coverage subscriber, and connects the monitor's analysis port to both. The test creates the environment, then starts a sequence on the sequencer and holds an objection until it completes.

## Scoreboard

The scoreboard computes expected results with a case statement on alu_function_select, using behavioral SystemVerilog operators: + for ADD, - for SUB, bitwise operators for the logic operations, and << / >> for the shifts.

Carry: for ADD, from the extra bit of a width+1-bit sum. For SUB, from the carry-out of A + ~B + 1, so C = 1 means no borrow. For shifts, the bit shifted out.
Overflow: computed as the XOR of the carry into and out of the MSB. The DUT uses the sign-comparison rule, so the two methods cross-check each other.
Negative: evaluated as $signed(expected_out) < 0.
Zero: set when the expected output is 0.

Each mismatch is reported with its own UVM error ID, so a failure identifies exactly which value was wrong.

## Coverage Model

The coverage model has one overarching covergroup, which is sampled with each transaction.

### Coverpoints
- `operation_cp`: one bin per operation (8 bins)
- `inp_a_cp`, `inp_b_cp`, `out_cp`: zero, all-ones, negative, and positive non-zero ranges
- `zero_cp`, `carry_cp`, `overflow_cp`, `negative_cp`: each flag set and clear

### Crosses
Each flag is crossed with the operation to confirm every operation produces
every flag value it can. Unreachable combinations are excluded with `ignore_bins`:

| Cross | Excluded | Reason |
|---|---|---|
| operation × negative | Right shift with negative = 1 | A logical right shift always clears the MSB |
| operation × zero | None | Every operation can produce a zero result |
| operation × carry | Logic ops with carry = 1 | Logic operations never set carry |
| operation × overflow | Non-arithmetic ops with overflow = 1 | Only ADD and SUB can overflow |

## Tests

The verification environment implements two tests: a random test and a directed test. The random test sends 1000 fully randomized transactions. Every combination of inputs and operations is legal for the ALU. The directed test sends specific transactions for each operation exercising different combinations of boundary bit patterns.
