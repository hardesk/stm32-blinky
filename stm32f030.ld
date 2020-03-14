MEMORY
{
	ram (rwx) :  ORIGIN = 0x20000000, LENGTH = 4K
	flash (rx) : ORIGIN = 0x08000000, LENGTH = 16K
}

SECTIONS
{
	.vector_table :
	{
		. = ALIGN(4);
		KEEP(*(.interrupt_vector))
		KEEP(*(.vectors))
		. = ALIGN(4);
	} > flash

	.text :
	{
		*(.init*)
		. = ALIGN(4);
		_init_array_start = .;
		*(init_array)
		_init_array_end = .;

		_fini_array_start = .;
		*(fini_array)
		_fini_array_end = .;

		*(.fini*)

		*(.text)
		*(.text*)
		*(.eh_frame)
		*(.strtab)
		*(.shstrtab)
		*(.rodata)
		*(.rodata*)
		. = ALIGN(4);
	} > flash

	. = ALIGN(4);
	_data_flash = .;
	_data_initial = .;

	.data : AT(_data_flash)
	{
		. = ALIGN(4);
		_data_start = .;
		__copy_table_start__ = _data_start;
		*(.data)
		*(.data*)
		. = ALIGN(4);
		_data_end = .;
		__copy_table_end__ = _data_end;
	} > ram

	.bss :
	{
		. = ALIGN(4);
		_bss_start = .;
		__bss_start__ = _bss_start;
		__zero_table_start__ = _bss_start;
		*(.bss)
		*(.bss*)
		. = ALIGN(4);
		_bss_end = .;
		__bss_end__ = _bss_end;
		__zero_table_end__ = _bss_end;
	} > ram

	_stack_size = 1024;
	_stack_end = ORIGIN(ram) + LENGTH(ram);
	__StackTop = _stack_end;
	_stack_start = _stack_end - _stack_size;
	. = _stack_start;
	.stack :
	{
		. = . + _stack_size;
	} > ram
}

