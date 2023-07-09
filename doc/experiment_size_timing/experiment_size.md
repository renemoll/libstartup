# Experiment with code size & timing


## Baseline

```
Memory region         Used Size  Region Size  %age Used
         ITCMRAM:          0 GB        16 KB      0.00%
           FLASH:        1812 B         2 MB      0.09%
         DTCMRAM:        1544 B       128 KB      1.18%
             RAM:          0 GB       384 KB      0.00%
         BKPSRAM:          0 GB         4 KB      0.00%
```

RAM usage is straighforward: stack and heap take up 1536 bytes, are not tuned and irrelevant for this experiment.

The main contributors to the code size are:

Function | Size [bytes]
--- | ---
ISR vector table		| 504
LL_GPIO_Init			| 372
memcpy					| 308
memset					| 164
__prepare_environment	| 136

Now, `LL_GPIO_Init` is part of the example and not really part of the start-up code. Taking out all code part of the example we end up with:

Function | Size [bytes]
--- | ---
ISR vector table		| 504
memcpy					| 308
memset					| 164
__prepare_environment	| 136
__start					| 36

The ISR vector cannot be changed, this is defined by the microcontroller. What I can influence are the other functions.

Based on the map file and disassembly file, we can already conclude the compiler already inlined the helper functions defined in `system.cpp` (such as `copy_data_section` and `table_call`.)

What if I replace `memset` and `memcpy` with a (naive) tiny implemenation?

# Tiny `memset` and `memcpy`

Now, since I am building a release build, we need to tell to compiler to disable a certain optimization: `-fno-tree-loop-distribute-patterns`. Otherwise, GCC will detect I mean to implement a `memset` and `memcpy` pattern and replace it with a library call.

Function | Size [bytes]
--- | ---
ISR vector table		| 504
__prepare_environment	| 252
__start					| 36

Differences:

Function | Size [bytes]
--- | ---
memcpy					| -308
memset					| -164
__prepare_environment	| +116
ARM.exidx				| -8
fill					| +4
--- | ---
Difference				| -360

1. https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-ftree-loop-distribute-patterns