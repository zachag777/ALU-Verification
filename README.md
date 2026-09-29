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

The ALU uses ripple adders to implement binary addition and subtraction, and treats operands as two's complement signed values when determining
status flags. Subtraction uses the standard two's complement method of A - B = A + ~B + 1. The standard logic operations use SystemVerilog's
bitwise logic operators. The logical shift operations implement one bit logical shifts in the left and right directions using 2-to-1 MUXs, and
require a bit width of at least 2 bits to execute correctly.

The ALU has four status flags: negative (N), zero (Z), carry (C) and overflow (V).

| Flag | ADD | SUB | LOGIC OPERATIONS | LEFT SHIFT | RIGHT SHIFT |
|----|----|----|----|----|----|
| N | MSB of result | MSB of result | MSB of result | MSB of result| Always 0 |
| Z | 1 if result = 0 | 1 if result = 0 | 1 if result = 0 | 1 if result = 0 | 1 if result = 0 |
| C | Carry-out of adder | Carry-out of subtracter | 0 | Bit shifted out | Bit shifted out |
| V | A and B have the same sign and the result's sign differs | A and B have different signs and the result's sign differs from A | 0 | 0 | 0 |


