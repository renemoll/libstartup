import pathlib

from elftools.elf.elffile import ELFFile
import elftools
import openpyxl


def process_file(sheet, filename):
	print('In file:', filename)
	with open(filename, 'rb') as f:
		elffile = ELFFile(f)

		ignored_types = [
			elftools.elf.sections.ARMAttributesSection,
			elftools.elf.sections.SymbolTableSection,
			elftools.elf.sections.StringTableSection,
			elftools.elf.sections.NullSection
		]
		sizes = {}
		for section in elffile.iter_sections():
			if section.name.startswith('.debug') or section.name.startswith('.comment'):
				continue
			if type(section) in ignored_types:
				continue

			sizes[section.name] = section.data_size

		print("Sections:")
		for k,v in sizes.items():
			print(f' * {k}: {v}')

		mapping = {
			'FLASH': ['.text', '.rodata', '.gnu_build_id', '.ARM', '.data'],
			'RAM': ['.bss', '.data', '._user_heap', '._user_stack'],
			'RAM (no stack&heap': ['.bss', '.data'],
		}

		result = {}
		for k,v in mapping.items():
			result[k] = sum([sizes[x] if x in sizes else 0 for x in v])

		sheet.append([
			filename.stem,
			filename.stem[filename.stem.rfind('_')+1:],
			result['FLASH'],
			result['RAM'],
			result['RAM (no stack&heap'],
			sizes['.text'],
			sizes['.rodata'],
			sizes['.data'],
			sizes['.bss'],
			sizes['._user_heap'],
			sizes['._user_stack'],
			sizes['.gnu_build_id'],
			sizes['.ARM'] if '.ARM' in sizes else 0
		])

		print("Footprint:")
		for k,v in result.items():
			print(f' * {k}: {v}')


if __name__ == '__main__':
	wb = openpyxl.Workbook()
	sheet = wb.active
	sheet.title = "O3"

	sheet.append(["File", "linkerscript", "FLASH", "RAM", "RAM (exl. stack + heap)", '.text', '.rodata', '.data', '.bss', '._user_heap', '._user_stack', '.gnu_build_id', '.ARM'])	
	sheet.column_dimensions["A"].width = 40
	sheet.column_dimensions["B"].width = 12

	path = pathlib.Path.cwd() / "build" / "stm32-release" / "example"
	files = [x for x in path.iterdir() if x.suffix == '.elf']
	for f in files:
		process_file(sheet, f)

	wb.save("export.xlsx")
