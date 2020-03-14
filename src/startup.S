
.cpu cortex-m0

.text
.thumb
.syntax unified

.extern _stack_end
.extern main

.extern _data_start, _data_end, _data_initial
.extern _bss_start, _bss_end

.global _reset_handler
.func _reset_handler
.thumb_func
_reset_handler:
	ldr r0, =_stack_end
	mov sp, r0

	// move data to ram
	ldr r1, =_data_start
	ldr r2, =_data_end
	ldr r3, =_data_initial
	subs r3, r3, r1
	b data_lstart

data_loop:
	ldr r0, [r3, r1]
	str r0, [r1, #0]
	adds r1, r1, #4

data_lstart:
	cmp r1, r2
	bne data_loop

	// clear bss
	ldr r1, =_bss_start
	ldr r2, =_bss_end
	movs r0, #0
	b bss_lstart

bss_loop:
	str r0, [r1]
	adds r1, r1, #4
bss_lstart:
	cmp r1, r2
	bne bss_loop

bss_done:

	b main
.endfunc

.global default_handler
.func default_handler
.thumb_func
default_handler:
	b .
.endfunc

// arm specifies hard fault as a separate function to ease debugging
.func hard_fault_handler
.thumb_func
.weak hard_fault_handler
	b .
.endfunc

.macro	defha handler
.weak	\handler
.thumb_set	\handler, default_handler
.word	\handler
.endm

.section .vectors, "ax", %progbits
.type vector_table,#object
vector_table:

	.word _stack_end
	.word _reset_handler
	defha NMI_handler
	.word hard_fault_handler
	.word 0
	.word 0
	.word 0
	.word 0

	.word 0
	.word 0
	.word 0
	defha svc_handler
	.word 0
	.word 0
	defha pendsv_handler
	defha systick_handler

	defha irq0_handler
	defha irq1_handler
	defha irq2_handler
	defha irq3_handler
	defha irq4_handler
	defha irq5_handler
	defha irq6_handler
	defha irq7_handler
	
	defha irq8_handler
	defha irq9_handler
	defha irq10_handler
	defha irq11_handler
	defha irq12_handler
	defha irq13_handler
	defha irq14_handler
	defha irq15_handler

	defha irq16_handler
	defha irq17_handler
	defha irq18_handler
	defha irq19_handler
	defha irq20_handler
	defha irq21_handler
	defha irq22_handler
	defha irq23_handler

	defha irq24_handler
	defha irq25_handler
	defha irq26_handler
	defha irq27_handler
	defha irq28_handler
	defha irq29_handler
	defha irq30_handler
	defha irq31_handler

.size vectors_size, . - vector_table

