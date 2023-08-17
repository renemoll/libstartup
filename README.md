# startup

Simple and explainatory start-up code for STM32(F7).

# TODO

* code format
* debug symbols?
* Now building with O3, what about Os?

CMAKE:
* BUILD_INTERFACE?

# Build

> python ./build.py build stm32 release


# notes

* Stack is placed directly after the heap. Either place it at the end of the memory or at a specific address?