import pathlib

from elftools.elf.elffile import ELFFile, SymbolTableSection, Section
import elftools
import openpyxl


def get_symbols(filename):
	symbols = {}

	with open(filename, 'rb') as f:
		elffile = ELFFile(f)
		text_idx = [idx for idx, s in enumerate(elffile.iter_sections()) if s.name == '.text']
		symbol_tables = [s for idx, s in enumerate(elffile.iter_sections()) if isinstance(s, SymbolTableSection)]
		for st in symbol_tables:
			for nsym, symbol in enumerate(st.iter_symbols()):
				if symbol['st_shndx'] != text_idx[0]:
					continue
				if symbol['st_info']['type'] == 'STT_SECTION' \
						or symbol['st_info']['type'] == 'STT_NOTYPE' \
						or symbol['st_info']['type'] == 'STT_FILE':
					continue

				# if symbol.name == 'vectorTable' or symbol.name == 'g_pfnVectors':
					# import pdb; pdb.set_trace()

				symbols[symbol.name] = symbol['st_size']
	return symbols

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
			'FLASH': ['.text', '.rodata', '.gnu_build_id', '.ARM', '.data', '.isr_vector'],
			'RAM': ['.bss', '.data', '._user_heap', '._user_stack', '._user_heap_stack'],
			'RAM (no stack&heap)': ['.bss', '.data'],
		}

		result = {}
		for k,v in mapping.items():
			result[k] = sum([sizes[x] if x in sizes else 0 for x in v])

		sheet.append([
			filename.stem,
			filename.stem[filename.stem.find('_')+1:],
			result['FLASH'],
			result['RAM'],
			result['RAM (no stack&heap)'],
			sizes['.text'],
			sizes['.rodata'],
			sizes['.data'],
			sizes['.bss'],
			result['RAM'] - result['RAM (no stack&heap)'],
			sizes['.gnu_build_id'] if '.gnu_build_id' in sizes else 0,
			sizes['.ARM'] if '.ARM' in sizes else 0
		])

		print("Footprint:")
		for k,v in result.items():
			print(f' * {k}: {v}')


def gather_elf_files(basepath: pathlib.Path):
	results = []
	experiments = [x for x in basepath.iterdir() if x.is_dir()]
	for exp in experiments:
		files = [x for x in exp.iterdir() if x.suffix == '.elf']
		results += files
	results.sort()
	return results


if __name__ == '__main__':
	wb = openpyxl.Workbook()
	sheet = wb.active
	sheet.title = "O3"

	sheet.append(["File", "experiment", "FLASH", "RAM", "RAM (exl. stack + heap)", '.text', '.rodata', '.data', '.bss', 'heap&stack','.gnu_build_id', '.ARM'])	
	sheet.column_dimensions["A"].width = 40
	sheet.column_dimensions["B"].width = 12

	path = pathlib.Path.cwd() / "build" / "stm32-release" / "experiments"
	experiments = gather_elf_files(path)
	for f in experiments:
		process_file(sheet, f)

	for f in experiments:
		sh = wb.create_sheet(f.stem)
		st = get_symbols(f)
		k = sorted(st.items())
		for name, size in k:
			if 'IRQHandler' in name:
				continue
			sh.append([name, size])

	wb.save("export.xlsx")
