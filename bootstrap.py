#!/usr/bin/env python3

"""Bootstrap

Usage:
	bootstrap.py [--no-toolchain]
	bootstrap.py -h | --help
	bootstrap.py --version

Options:
	-h --help		Show this screen.
	--version		Show version.
	---no-toolchain	Do not use retrieve the toolchain/compiler/etc.
"""

import logging
import urllib.request
import platform
import pathlib
import shutil
import subprocess

import docopt

toolchain = {
	'gcc-arm': {
		'windows': 'https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-rel1/binrel/arm-gnu-toolchain-12.2.mpacbti-rel1-mingw-w64-i686-arm-none-eabi.zip',
		'linux': 'https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-rel1/binrel/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi.tar.xz'
	},
}

deps = {
	'stm32f7': {
		'repo': 'https://github.com/STMicroelectronics/stm32f7xx_hal_driver.git'
	},
	'cmsis_device_f7': {
		'repo': 'https://github.com/STMicroelectronics/cmsis_device_f7.git'
	},
	'cmsis5': {
		'repo': 'https://github.com/ARM-software/CMSIS_5.git'
	}
}

def ensure_path(path):
	if not path.exists():
		logging.debug('Creating directory %s', path)
		path.mkdir(parents=True, exist_ok=True)

def get_package(url, destination_path):
	path = destination_path / pathlib.Path(url).name
	logging.info("Retrieving: %s", pathlib.Path(url).name)

	if not path.exists():
		logging.info("Downloading: %s", url)
		urllib.request.urlretrieve(url, path)
	else:
		logging.info("Archive found: %s", path)

	return path

def extract_package(archive, destination_path):
	logging.info("Extracting: %s to %s", archive, destination_path)
	if not (destination_path / archive.name).exists():
		shutil.unpack_archive(archive, destination_path)

def retrieve_repo(url, destination_path):
	"""
	Todo:
	 - remove .git from the path
	"""
	path = destination_path / pathlib.Path(url).name
	logging.info("Retrieving: %s", pathlib.Path(url).name)

	if not path.exists():
		logging.info("Downloading: %s", url)
		subprocess.call(['git', 'clone', url, str(path)])
	else:
		logging.info("Archive found: %s", path)

	return path

def main(retrieve_toolchain):
	cwd = pathlib.Path(__file__).resolve().parent
	os = platform.system().lower()
	logging.info("Bootstrapping for %s", os)

	config = {
		'paths': {
			'base': 'external',
			'downloads': 'download',
			'source': 'src'
		}
	}

	#
	# App logic
	#

	vendor_path = cwd / config['paths']['base']
	dl_path = vendor_path / config['paths']['downloads']
	ensure_path(dl_path)
	source_path = vendor_path / config['paths']['source']
	ensure_path(source_path)

	def process(pkg_list):
		for pkg in pkg_list:
			# OS specific
			try:
				url = pkg_list[pkg][os]
				archive = get_package(url, dl_path)
				extract_package(archive, source_path)
			except KeyError:
				pass

			# repo
			try:
				url = pkg_list[pkg]['repo']
				retrieve_repo(url, source_path)
			except KeyError:
				pass

	if retrieve_toolchain:
		process(toolchain)
	process(deps)

if __name__ == '__main__':
	logging.basicConfig(level=logging.INFO)
	arguments = docopt.docopt(__doc__, version='Bootstrap 1.0')
	retrieve_toolchain = not arguments['--no-toolchain']
	main(retrieve_toolchain)
