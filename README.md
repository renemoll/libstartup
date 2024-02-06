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

# Work in progress

> bob build stm32f7

Output:
```bash
2024.02.06 20:57:02 - bob.py:112 - DEBUG: docker run --rm -v /home/rene/work/experiments/startup:/work/ renemoll/builder_arm_gcc cmake -B build/stm32f7-release -S . -DCMAKE_BUILD_TYPE=Release
gmake: /usr/bin/cmake: Operation not permitted
gmake: *** [Makefile:152: cmake_check_build_system] Error 127
```

```bash
docker run -it --rm -v /home/rene/work/experiments/startup:/work/ renemoll/builder_arm_gcc /bin/bash
```

Adding: `--security-opt seccomp=unconfined`
 -> git config --global http.sslverify false
