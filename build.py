#!/usr/bin/env python3

"""The builder, Bob the builder.

Usage:
	build.py build [<target>] [--no-container] [(debug|release)]
	build.py debug [<target>]
	build.py format
	build.py test
	build.py -h | --help
	build.py --version

Possible commands:
	build: build the project for the a target.
	debug: enter the debugger.
	format: apply the code format. 
	test: (build and) execute the unit-tests.

Target: optional command to select the target to build for.
	Might be omited for automatic/native target selection, or
	any of the following values:
		- linux
		- stm32
		- native

Options:
	-h --help		Show this screen.
	--version		Show version.
	---no-container	Do not use the appropriate container to build the target.

Todo:
 * report size: arm-none-eabi-nm --print-size --size-sort --radix=d 00_reference.elf
"""

import enum
import logging
import pathlib
import subprocess
import time

import docopt


class Command(enum.Enum):
	Build = 1
	Debug = 2
	Format = 4
	Test = 3

	def __str__(self):
		return self.name.lower()


class BuildConfig(enum.Enum):
	Release = 1
	Debug = 2

	def __str__(self):
		return self.name.lower()


class BuildTarget(enum.Enum):
	Native = 1
	Linux = 2
	Stm32 = 3

	def __str__(self):
		return self.name.lower()


class ExecutionTimer:
	def __init__(self):
		self._start = None
		self.duration = None

	def __enter__(self):
		self._start = time.perf_counter()
		return self

	def __exit__(self, exc_type, exc_value, exc_traceback):
		stop = time.perf_counter()
		self.duration = stop - self._start
		return False


def determine_command(args):
	if args['build']:
		return Command.Build
	elif args['debug']:
		return Command.Debug
	elif args['test']:
		return Command.Test
	elif args['format']:
		return Command.Format

	raise ValueError("Unsupported command")


def determine_build_config(args):
	if args['release']:
		return BuildConfig.Release
	elif args['debug']:
		return BuildConfig.Debug

	logging.warning("No build config selected, defaulting to release build config")
	return BuildConfig.Release


def determine_build_target(args):
	try:
		target = args['<target>'].lower()
		if target == 'stm32':
			return BuildTarget.Stm32
		elif target == 'linux':
			return BuildTarget.Linux
		return BuildTarget.Native
	except:
		return BuildTarget.Native


def determine_options(args):
	return {
		'build' : {
			'config': determine_build_config(arguments),
			'target': determine_build_target(arguments),
		},
		'use-container': not args['--no-container']
	}


def determine_output_folder(options):
	lookup = {
		BuildTarget.Stm32: 'stm32-',
		BuildTarget.Linux: 'linux64-',
		BuildTarget.Native: 'native-',
	}
	return lookup[options['target']] + str(options['config']).lower()


def container_command(target, cwd):
	if target == BuildTarget.Native:
		return []
	elif target == BuildTarget.Stm32:
		return ["docker",
			"run",
			"--rm",
			"-v", "{}:/work/".format(cwd),
			"renemoll/builder_arm_gcc"]
	elif target == BuildTarget.Linux:
		return ["docker",
			"run",
			"--rm",
			"-v", "{}:/work/".format(cwd),
			"renemoll/builder_clang"]

	raise ValueError("Unsupported container requested: '%s'", str(target))


def build_stm32():
	return ["-DCMAKE_TOOLCHAIN_FILE=cmake/bbuilder/toolchain-stm32f767.cmake"]


def build_system_command(options, output_folder):
	cmd = ["cmake",
		"-B", "build/{}".format(output_folder),
		"-S", ".",
		"-DCMAKE_BUILD_TYPE={}".format(str(options['build']['config']))
		# "–warn-uninitialized"
	]

	if options['build']['target'] in (BuildTarget.Linux, BuildTarget.Stm32):
		cmd += [
			"-G", "Ninja",
		]

	return cmd


def build_project_command(output_folder):
	return ["cmake", "--build", "build/{}".format(output_folder)]


def bob_build(options, cwd):
	output_folder = determine_output_folder(options['build'])
	logging.debug("Determined output folder: %s", output_folder)

	def generate_build_env():
		steps = []
		if options['use-container']:
			steps += container_command(options['build']['target'], cwd)

		steps += build_system_command(options, output_folder)

		if options['build']['target'] == BuildTarget.Stm32:
			steps += build_stm32()

		return steps

	def build_project():
		steps = []

		if options['use-container']:
			steps += container_command(options['build']['target'], cwd)

		steps += build_project_command(output_folder)

		return steps

	return [
		generate_build_env(),
		build_project()
	]


def bob_debug(options, cwd):
	"""
	Todo:
	- actually enter gdb
	- lldb?
	- make container optional
	"""
	def build_gdb():
		return [
			"docker",
			"run",
			"--rm",
			"-it",
			"-v", "{}:/work/".format(cwd),
			"renemoll/builder_arm_gcc",
			"/bin/bash"
		]

	return [build_gdb()]


def bob_test(options):
	pass


def bob_format(options, cwd):
	folders = ['src', 'include']
	filetypes = ['*.c', '*.h', '*.cpp', '*.hpp']

	files = []
	for f in folders:
		base = cwd / f
		for type in filetypes:
			files += base.rglob(type)

	steps = []
	for file in files:
		steps.append(container_command(BuildTarget.Linux, cwd) + [
			"clang-format",
			"-style=file",
			"-i",
			"-fallback-style=none",
			str(pathlib.PurePosixPath(file.relative_to(cwd)))
		])
	return steps


def bob(command, options):
	logging.info("Command: %s, options: %s", command, options)

	cwd = pathlib.Path(__file__).parent.resolve()
	logging.debug("Determined working directory: %s", cwd)

	tasks = []
	if command == Command.Build:
		tasks += bob_build(options, cwd)
	if command == Command.Debug:
		tasks += bob_debug(options, cwd)
	if command == Command.Test:
		tasks += bob_test(options)
	if command == Command.Format:
		tasks += bob_format(options, cwd)

	logging.debug("Processing %d tasks", len(tasks))
	for task in tasks:
		logging.debug(" ".join(task))
		with ExecutionTimer() as timer:
			result = subprocess.run(task)
		logging.debug("Result: %s in %f seconds", result, timer.duration)


if __name__ == "__main__":
	logging.basicConfig(
		level=logging.DEBUG,
		format="%(asctime)s - %(filename)s:%(lineno)s - %(levelname)s: %(message)s",
		datefmt='%Y.%m.%d %H:%M:%S'
	)

	arguments = docopt.docopt(__doc__, version='Bob 1.0')
	command = determine_command(arguments)
	options = determine_options(arguments)
	bob(command, options)