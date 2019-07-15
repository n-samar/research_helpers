2SHELL:=/bin/bash
CC := gcc
VERILOG := iverilog
VVP := vvp
LIST_INPUT_SIZE := 128

clean :
	rm -f *.txt datagen *.vcd *.txt~

merger_1 : MERGER.v MERGER_tb.v BITONIC_NETWORK.v FIFO.v
	iverilog -o _merger FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v  MERGER_tb.v

datagen :
	gcc -o datagen test/datagen.c

chunk_data : datagen
	./datagen 4096 9 1 1; \
	./datagen 40 64 1 1; \
	./datagen 32 512 1 1; \
	./datagen 32 4096 1 1;

data : datagen
	python test/datagen.py \
	./datagen 2 $(LIST_INPUT_SIZE) 1; \
	./datagen 16 $(LIST_INPUT_SIZE) 1; \
	./datagen 32 $(LIST_INPUT_SIZE) 1; \
	./datagen 64 $(LIST_INPUT_SIZE) 1; \
	./datagen 128 $(LIST_INPUT_SIZE) 1; \
	./datagen 128 32 1; \
	./datagen 2 $(LIST_INPUT_SIZE) 1 2; \
	./datagen 16 $(LIST_INPUT_SIZE) 1 2; \
	./datagen 2 $(LIST_INPUT_SIZE) 1 4; \
	./datagen 2 $(LIST_INPUT_SIZE) 1 8; \
	./datagen 256 16 1; \
	./datagen 1 128 1 1 2; \
	./datagen 2 16 1 16; \
	./datagen 2 16 1 32; \
	./datagen 8 960 1 1 4; \
	./datagen 16 128 1 1 8; \
	./datagen 256 16 1 1 16; \
	./datagen 256 16 1 1 32; \
	cat ans_16_128.txt > ans_16_128_gl2.txt; \
	cat ans_16_128.txt >> ans_16_128_gl2.txt; \
	cat ans_16_128_gl2.txt > ans_16_128_gl4.txt; \
	cat ans_16_128_gl2.txt >> ans_16_128_gl4.txt; \
	cat ans_32_128.txt > ans_32_128_gl2.txt; \
	cat ans_32_128.txt >> ans_32_128_gl2.txt; \
	cat ans_32_128_gl2.txt > ans_32_128_gl4.txt; \
	cat ans_32_128_gl2.txt >> ans_32_128_gl4.txt; \
	cat ans_64_128.txt > ans_64_128_gl2.txt; \
	cat ans_64_128.txt >> ans_64_128_gl2.txt; \
	cat ans_64_128_gl2.txt > ans_64_128_gl4.txt; \
	cat ans_64_128_gl2.txt >> ans_64_128_gl4.txt; \
	cat ans_128_32.txt > ans_128_32_gl2.txt; \
	cat ans_128_32.txt >> ans_128_32_gl2.txt; \
	cat ans_128_32_gl2.txt > ans_128_32_gl4.txt; \
	cat ans_128_32_gl2.txt >> ans_128_32_gl4.txt; \
	cat ans_16_128_2.txt > ans_16_128_2_gl2.txt; \
	cat ans_16_128_2.txt >> ans_16_128_2_gl2.txt; \
	cat ans_16_128_2_gl2.txt > ans_16_128_2_gl4.txt; \
	cat ans_16_128_2_gl2.txt >> ans_16_128_2_gl4.txt;

compile_coupler : data FIFO.v COUPLER.v COUPLER_tb.v
	$(VERILOG) -o _coupler FIFO.v COUPLER.v COUPLER_tb.v

compile_merger_1 : data FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v  MERGER_tb.v
	$(VERILOG) -o _merger_1 FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v  MERGER_tb.v

compile_merger_2 : data FIFO.v MERGER_2.v CONTROL.v BITONIC_NETWORK_4.v  MERGER_2_AUTO_tb.v
	$(VERILOG) -o _merger_2 FIFO.v MERGER_2.v CONTROL.v BITONIC_NETWORK_4.v  MERGER_2_AUTO_tb.v;

compile_merger_4 : data FIFO.v MERGER_4.v CONTROL.v BITONIC_NETWORK_8.v  MERGER_4_tb.v
	$(VERILOG) -o _merger_4 FIFO.v MERGER_4.v CONTROL.v BITONIC_NETWORK_8.v  MERGER_4_tb.v;

compile_merger_8 : data FIFO.v MERGER_8.v CONTROL.v BITONIC_NETWORK_16.v  MERGER_8_tb.v
	$(VERILOG) -o _merger_8 FIFO.v MERGER_8.v CONTROL.v BITONIC_NETWORK_16.v  MERGER_8_tb.v;

compile_merger_16 : data FIFO.v MERGER_16.v CONTROL.v BITONIC_NETWORK_32.v  MERGER_16_tb.v
	$(VERILOG) -o _merger_16 FIFO.v MERGER_16.v CONTROL.v BITONIC_NETWORK_32.v  MERGER_16_tb.v;

compile_merger_32 : data FIFO.v MERGER_32.v CONTROL.v BITONIC_NETWORK_64.v  MERGER_32_tb.v
	$(VERILOG) -o _merger_32 FIFO.v MERGER_32.v CONTROL.v BITONIC_NETWORK_64.v  MERGER_32_tb.v;

compile_tree_P1_L8 : data FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L8.v MERGER_TREE_P1_L8_AUTOMATIC_tb.v
	$(VERILOG) -o tree_P1_L8 FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L8.v MERGER_TREE_P1_L8_AUTOMATIC_tb.v;

compile_tree_P2_L8 : data FIFO.v MERGER_2.v CONTROL.v BITONIC_NETWORK_4.v MERGER_TREE_P2_L8.v MERGER_TREE_P2_L8_tb.v
	$(VERILOG) -o tree_P2_L8 FIFO.v MERGER_2.v CONTROL.v BITONIC_NETWORK_4.v MERGER_TREE_P2_L8.v MERGER_TREE_P2_L8_tb.v;

compile_tree_P2_L8_global_reset : data FIFO.v MERGER_2.v CONTROL.v BITONIC_NETWORK_4.v MERGER_TREE_P2_L8.v MERGER_TREE_P2_L8_GLOBAL_RESET_tb.v
	$(VERILOG) -o tree_P2_L8_gl FIFO.v MERGER_2.v CONTROL.v BITONIC_NETWORK_4.v MERGER_TREE_P2_L8.v MERGER_TREE_P2_L8_GLOBAL_RESET_tb.v;

compile_tree_P1_L8_global_reset : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L8.v MERGER_TREE_P1_L8_AUTOMATIC_GLOBAL_RESET_tb.v
	$(VERILOG) -o tree_P1_L8_gl FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L8.v MERGER_TREE_P1_L8_AUTOMATIC_GLOBAL_RESET_tb.v

compile_tree_P1_L16 : data FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L16.v MERGER_TREE_P1_L16_tb.v
	$(VERILOG) -o tree_P1_L16 FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L16.v MERGER_TREE_P1_L16_tb.v

compile_tree_P1_L16_global_reset : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L16.v MERGER_TREE_P1_L16_GLOBAL_RESET_tb.v
	$(VERILOG) -o tree_P1_L16_gl FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L16.v MERGER_TREE_P1_L16_GLOBAL_RESET_tb.v

compile_tree_P1_L32 : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L32.v MERGER_TREE_P1_L32_tb.v
	$(VERILOG) -o tree_P1_L32 FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L32.v MERGER_TREE_P1_L32_tb.v

compile_tree_P1_L32_global_reset : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L32.v MERGER_TREE_P1_L32_GLOBAL_RESET_tb.v
	$(VERILOG) -o tree_P1_L32_gl FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L32.v MERGER_TREE_P1_L32_GLOBAL_RESET_tb.v

compile_tree_P1_L64 : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L64.v MERGER_TREE_P1_L64_tb.v
	$(VERILOG) -o tree_P1_L64 FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L64.v MERGER_TREE_P1_L64_tb.v

compile_tree_P1_L64_global_reset : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L64.v MERGER_TREE_P1_L64_GLOBAL_RESET_tb.v
	$(VERILOG) -o tree_P1_L64_gl FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L64.v MERGER_TREE_P1_L64_GLOBAL_RESET_tb.v

compile_tree_P1_L128 : FIFO.v MERGER.v CONTROL.v BITONIC_NETWORK.v MERGER_TREE_P1_L128.v MERGER_TREE_P1_L128_tb.v
	$(VERILOG) -o tree_P1_L128 FIFO.v BITONIC_NETWORK.v MERGER.v CONTROL.v MERGER_TREE_P1_L128.v MERGER_TREE_P1_L128_tb.v

compile_tree_P16_L128 : COUPLER.v FIFO.v MERGER.v MERGER_2.v MERGER_4.v MERGER_8.v MERGER_16.v CONTROL.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v BITONIC_NETWORK_16.v BITONIC_NETWORK_32.v BITONIC_NETWORK_64.v MERGER_TREE_P16_L128.v MERGER_TREE_P16_L128_tb.v
	$(VERILOG) -o tree_P16_L128 COUPLER.v FIFO.v MERGER.v MERGER_2.v MERGER_4.v MERGER_8.v MERGER_16.v CONTROL.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v BITONIC_NETWORK_16.v BITONIC_NETWORK_32.v BITONIC_NETWORK_64.v MERGER_TREE_P16_L128.v MERGER_TREE_P16_L128_tb.v

compile_tree_P32_L128 : COUPLER.v FIFO.v MERGER.v MERGER_2.v MERGER_4.v MERGER_8.v MERGER_16.v MERGER_32.v CONTROL.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v BITONIC_NETWORK_16.v BITONIC_NETWORK_32.v BITONIC_NETWORK_64.v MERGER_TREE_P32_L128.v MERGER_TREE_P32_L128_tb.v
	$(VERILOG) -o tree_P32_L128 COUPLER.v FIFO.v MERGER.v MERGER_2.v MERGER_4.v MERGER_8.v MERGER_16.v MERGER_32.v CONTROL.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v BITONIC_NETWORK_16.v BITONIC_NETWORK_32.v BITONIC_NETWORK_64.v MERGER_TREE_P32_L128.v MERGER_TREE_P32_L128_tb.v


compile_tree_P4_L4 : FIFO.v MERGER.v MERGER_4.v MERGER_2.v CONTROL.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v MERGER_TREE_P4_L4.v MERGER_TREE_P4_L4_tb.v COUPLER.v
	$(VERILOG) -o tree_P4_L4 COUPLER.v FIFO.v MERGER.v MERGER_4.v MERGER_2.v CONTROL.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v MERGER_TREE_P4_L4.v MERGER_TREE_P4_L4_tb.v

compile_tree_P8_L8 : src/FIFO.v src/MERGER.v src/MERGER_8.v src/MERGER_4.v src/MERGER_2.v src/CONTROL.v src/BITONIC_NETWORK.v src/BITONIC_NETWORK_4.v src/BITONIC_NETWORK_8.v src/BITONIC_NETWORK_16.v src/MERGER_TREE_P8_L8_32b.v test/MERGER_TREE_P8_L8_tb.v src/COUPLER.v
	$(VERILOG) -o tree_P8_L8 src/COUPLER.v src/FIFO.v src/MERGER.v src/MERGER_8.v src/MERGER_4.v src/MERGER_2.v src/CONTROL.v src/BITONIC_NETWORK.v src/BITONIC_NETWORK_4.v src/BITONIC_NETWORK_8.v src/BITONIC_NETWORK_16.v src/MERGER_TREE_P8_L8_32b.v test/MERGER_TREE_P8_L8_tb.v

sim_coupler : compile_coupler
	$(VVP) coupler

sim_merger_1 : compile_merger_1 
	$(VVP) _merger_1

sim_merger_2 : compile_merger_2 
	$(VVP) _merger_2

sim_merger_4 : compile_merger_4 
	$(VVP) _merger_4

sim_merger_8 : compile_merger_8 
	$(VVP) _merger_8

sim_merger_16 : compile_merger_16
	$(VVP) _merger_16

sim_merger_32 : compile_merger_32
	$(VVP) _merger_32

sim_tree_P1_L8 : compile_tree_P1_L8
	$(VVP) tree_P1_L8;

sim_tree_P2_L8 : compile_tree_P2_L8 tree_P2_L8
	$(VVP) tree_P2_L8;

sim_tree_P4_L4 : compile_tree_P4_L4 tree_P4_L4
	$(VVP) tree_P4_L4;

sim_tree_P8_L8 : compile_tree_P8_L8 tree_P8_L8
	$(VVP) tree_P8_L8;

sim_tree_P2_L8_global_reset : compile_tree_P2_L8_global_reset tree_P2_L8_gl
	$(VVP) tree_P2_L8_gl;

sim_tree_P1_L8_global_reset : compile_tree_P1_L8_global_reset merger
	$(VVP) tree_P1_L8_gl;

sim_tree_P1_L16 : compile_tree_P1_L16 merger
	$(VVP) tree_P1_L16

sim_tree_P1_L16_global_reset : compile_tree_P1_L16_global_reset merger
	$(VVP) tree_P1_L16_gl

sim_tree_P1_L32 : compile_tree_P1_L32 merger
	$(VVP) tree_P1_L32

sim_tree_P1_L32_global_reset : compile_tree_P1_L32_global_reset merger
	$(VVP) tree_P1_L32_gl

sim_tree_P1_L64 : compile_tree_P1_L64 merger
	$(VVP) tree_P1_L64

sim_tree_P1_L64_global_reset : compile_tree_P1_L64_global_reset merger
	$(VVP) tree_P1_L64

sim_tree_P1_L128 : compile_tree_P1_L128
	$(VVP) tree_P1_L128

sim_tree_P16_L128 : compile_tree_P16_L128
	$(VVP) tree_P16_L128

sim_tree_P32_L128 : compile_tree_P32_L128
	$(VVP) tree_P32_L128

filter_output_coupler : sim_coupler data
	sed '/^0000000000000000$$/d' out_1_128.txt > out_no_zeros_1_128.txt
	sed '/^0000000000000000$$/d' ans_1_128_1.txt > ans_no_zeros_1_128.txt

filter_output_merger_1 : sim_merger_1 data
	sed '/^00000000$$/d' out_2_128.txt > out_no_zeros_2_128.txt
	sed '/^00000000$$/d' ans_2_128.txt > ans_no_zeros_2_128.txt

filter_output_merger_2 : sim_merger_4 data
	sed '/^0000000000000000$$/d' out_2_128_2.txt > out_no_zeros_2_128_2.txt
	sed '/^0000000000000000$$/d' ans_2_128_2.txt > ans_no_zeros_2_128_2.txt

filter_output_merger_4 : sim_merger_4 data
	sed '/^00000000000000000000000000000000$$/d' out_2_128_4.txt > out_no_zeros_2_128_4.txt
	sed '/^00000000000000000000000000000000$$/d' ans_2_128_4.txt > ans_no_zeros_2_128_4.txt

filter_output_merger_8 : sim_merger_8 data
	sed '/^0000000000000000000000000000000000000000000000000000000000000000$$/d' out_2_128_8.txt > out_no_zeros_2_128_8.txt
	sed '/^0000000000000000000000000000000000000000000000000000000000000000$$/d' ans_2_128_8.txt > ans_no_zeros_2_128_8.txt

filter_output_merger_16 : sim_merger_16 data
	sed '/^00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' out_2_16_16.txt > out_no_zeros_2_16_16.txt
	sed '/^00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' ans_2_16_16.txt > ans_no_zeros_2_16_16.txt

filter_output_merger_32 : sim_merger_32 data
	sed '/^0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' out_2_16_32.txt > out_no_zeros_2_16_32.txt
	sed '/^0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' ans_2_16_32.txt > ans_no_zeros_2_16_32.txt

filter_output_tree_P1_L8 : data sim_tree_P1_L8
	sed '/^00000000$$/d' out_16_128.txt > out_no_zeros_16_128.txt
	sed '/^00000000$$/d' ans_16_128.txt > ans_no_zeros_16_128.txt

filter_output_tree_P4_L4 : data sim_tree_P4_L4
	sed '/^00000000000000000000000000000000$$/d' out_8_4_4_1_4.txt > out_no_zeros_8_4_4_1_4.txt
	sed '/^00000000000000000000000000000000$$/d' ans_8_4_4_1_4.txt > ans_no_zeros_8_4_4_1_4.txt

filter_output_tree_P8_L8 : data sim_tree_P8_L8
	sed '/^0000000000000000000000000000000000000000000000000000000000000000$$/d' out_16_128_1_8.txt > out_no_zeros_16_128_1_8.txt
	sed '/^0000000000000000000000000000000000000000000000000000000000000000$$/d' ans_16_128_1_8.txt > ans_no_zeros_16_128_1_8.txt

filter_output_tree_P2_L8 : data sim_tree_P2_L8
	sed '/^0000000000000000$$/d' out_16_128_2.txt > out_no_zeros_16_128_2.txt
	sed '/^0000000000000000$$/d' ans_16_128_2.txt > ans_no_zeros_16_128_2.txt

filter_output_tree_P2_L8_global_reset : data sim_tree_P2_L8_global_reset
	sed '/^0000000000000000$$/d' out_16_128_2_gl4.txt > out_no_zeros_16_128_2_gl4.txt
	sed '/^0000000000000000$$/d' ans_16_128_2_gl4.txt > ans_no_zeros_16_128_2_gl4.txt

filter_output_tree_P1_L8_global_reset : data sim_tree_P1_L8_global_reset
	sed '/^00000000$$/d' out_16_128_gl4.txt > out_no_zeros_16_128_gl4.txt
	sed '/^00000000$$/d' ans_16_128_gl4.txt > ans_no_zeros_16_128_gl4.txt

filter_output_tree_P1_L16 : data sim_tree_P1_L16
	sed '/^00000000$$/d' out_32_128.txt > out_no_zeros_32_128.txt
	sed '/^00000000$$/d' ans_32_128.txt > ans_no_zeros_32_128.txt

filter_output_tree_P1_L16_global_reset : data sim_tree_P1_L16_global_reset
	sed '/^00000000$$/d' out_32_128_gl4.txt > out_no_zeros_32_128_gl4.txt
	sed '/^00000000$$/d' ans_32_128_gl4.txt > ans_no_zeros_32_128_gl4.txt

filter_output_tree_P1_L32 : data sim_tree_P1_L32
	sed '/^00000000$$/d' out_64_128.txt > out_no_zeros_64_128.txt
	sed '/^00000000$$/d' ans_64_128.txt > ans_no_zeros_64_128.txt

filter_output_tree_P1_L32_global_reset : data sim_tree_P1_L32_global_reset
	sed '/^00000000$$/d' out_64_128_gl4.txt > out_no_zeros_64_128_gl4.txt
	sed '/^00000000$$/d' ans_64_128_gl4.txt > ans_no_zeros_64_128_gl4.txt

filter_output_tree_P1_L64 : data sim_tree_P1_L64
	sed '/^00000000$$/d' out_128_128.txt > out_no_zeros_128_128.txt
	sed '/^00000000$$/d' ans_128_128.txt > ans_no_zeros_128_128.txt

filter_output_tree_P1_L64_global_reset : data sim_tree_P1_L64_global_reset
	sed '/^00000000$$/d' out_128_32_gl4.txt > out_no_zeros_128_32_gl4.txt
	sed '/^00000000$$/d' ans_128_32_gl4.txt > ans_no_zeros_128_32_gl4.txt

filter_output_tree_P1_L128 : data sim_tree_P1_L128
	sed '/^00000000$$/d' out_256_16.txt > out_no_zeros_256_16.txt
	sed '/^00000000$$/d' ans_256_16.txt > ans_no_zeros_256_16.txt

filter_output_tree_P16_L128 : data sim_tree_P16_L128
	sed '/^00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' out_256_16_1_16.txt > out_no_zeros_256_16_1_16.txt
	sed '/^00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' ans_256_16_1_16.txt > ans_no_zeros_256_16_1_16.txt

filter_output_tree_P32_L128 : data sim_tree_P32_L128
	sed '/^0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' out_256_16_1_32.txt > out_no_zeros_256_16_1_32.txt
	sed '/^0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000$$/d' ans_256_16_1_32.txt > ans_no_zeros_256_16_1_32.txt

test_merger_1 : compile_merger_1 sim_merger_1 filter_output_merger_1 out_no_zeros_2_128.txt ans_no_zeros_2_128.txt
	if [[ $$(diff -u out_no_zeros_2_128.txt ans_no_zeros_2_128.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST MERGER_1' 1>&2; \
	else \
		echo 'SUCESS! merger_1' 1>&2; \
	fi

test_merger_2 : data compile_merger_2 sim_merger_2 filter_output_merger_2 out_no_zeros_2_128_2.txt ans_no_zeros_2_128_2.txt _merger_2
	if [[ $$(diff -u out_no_zeros_2_128_2.txt ans_no_zeros_2_128_2.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST MERGER_2' 1>&2; \
	else \
		echo 'SUCESS! merger_2' 1>&2; \
	fi

test_merger_4 : data compile_merger_4 sim_merger_4 filter_output_merger_4 out_no_zeros_2_128_4.txt ans_no_zeros_2_128_4.txt _merger_4
	if [[ $$(diff -u out_no_zeros_2_128_4.txt ans_no_zeros_2_128_4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST MERGER_4' 1>&2; \
	else \
		echo 'SUCESS! merger_4' 1>&2; \
	fi

test_merger_8 : data compile_merger_8 sim_merger_8 filter_output_merger_8 out_no_zeros_2_128_8.txt ans_no_zeros_2_128_8.txt _merger_8
	if [[ $$(diff -u out_no_zeros_2_128_8.txt ans_no_zeros_2_128_8.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST MERGER_8' 1>&2; \
	else \
		echo 'SUCESS! merger_8' 1>&2; \
	fi

test_merger_16 : data compile_merger_16 sim_merger_16 filter_output_merger_16 out_no_zeros_2_16_16.txt ans_no_zeros_2_16_16.txt _merger_16
	if [[ $$(diff -u out_no_zeros_2_16_16.txt ans_no_zeros_2_16_16.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST MERGER_16' 1>&2; \
	else \
		echo 'SUCESS! merger_16' 1>&2; \
	fi

test_merger_32 : data compile_merger_32 sim_merger_32 filter_output_merger_32 out_no_zeros_2_16_32.txt ans_no_zeros_2_16_32.txt _merger_32
	if [[ $$(diff -u out_no_zeros_2_16_32.txt ans_no_zeros_2_16_32.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST MERGER_32' 1>&2; \
	else \
		echo 'SUCESS! merger_32' 1>&2; \
	fi

test_tree_P1_L8 : compile_tree_P1_L8 filter_output_tree_P1_L8 out_no_zeros_16_128.txt ans_no_zeros_16_128.txt sim_tree_P1_L8 
	if [[ $$(diff -u out_no_zeros_16_128.txt ans_no_zeros_16_128.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L8' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L8' 1>&2; \
	fi

test_tree_P2_L8 : data compile_tree_P2_L8 sim_tree_P2_L8 filter_output_tree_P2_L8 out_no_zeros_16_128_2.txt ans_no_zeros_16_128_2.txt
	if [[ $$(diff -u out_no_zeros_16_128_2.txt ans_no_zeros_16_128_2.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P2_L8' 1>&2; \
	else \
		echo 'SUCESS! tree_P2_L8' 1>&2; \
	fi

test_tree_P4_L4 : data compile_tree_P4_L4 sim_tree_P4_L4 filter_output_tree_P4_L4
	if [[ $$(diff -u out_no_zeros_8_4_4_1_4.txt ans_no_zeros_8_4_4_1_4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P4_L4' 1>&2; \
	else \
		echo 'SUCESS! tree_P4_L4' 1>&2; \
	fi

test_tree_P8_L8 : data compile_tree_P8_L8 sim_tree_P8_L8 filter_output_tree_P8_L8 out_no_zeros_16_128_1_8.txt ans_no_zeros_16_128_1_8.txt
	if [[ $$(diff -u out_no_zeros_16_128_1_8.txt ans_no_zeros_16_128_1_8.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P8_L8' 1>&2; \
	else \
		echo 'SUCESS! tree_P8_L8' 1>&2; \
	fi

test_tree_P2_L8_global_reset : data compile_tree_P2_L8_global_reset sim_tree_P2_L8_global_reset filter_output_tree_P2_L8_global_reset out_no_zeros_16_128_2_gl4.txt ans_no_zeros_16_128_2_gl4.txt
	if [[ $$(diff -u out_no_zeros_16_128_2_gl4.txt ans_no_zeros_16_128_2_gl4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P2_L8_GLOBAL_RESET' 1>&2; \
	else \
		echo 'SUCESS! tree_P2_L8_global_reset' 1>&2; \
	fi

test_tree_P1_L8_global_reset : compile_tree_P1_L8 filter_output_tree_P1_L8_global_reset out_no_zeros_16_128_gl4.txt ans_no_zeros_16_128_gl4.txt sim_tree_P1_L8 merger 
	if [[ $$(diff -u out_no_zeros_16_128_gl4.txt ans_no_zeros_16_128_gl4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L8_GLOBAL_RESET' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L8_global_reset' 1>&2; \
	fi


test_tree_P1_L16 : compile_tree_P1_L16 filter_output_tree_P1_L16 out_no_zeros_32_128.txt ans_no_zeros_32_128.txt sim_tree_P1_L16 merger 
	if [[ $$(diff -u out_no_zeros_32_128.txt ans_no_zeros_32_128.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L16' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L16' 1>&2; \
	fi

test_tree_P1_L16_global_reset : filter_output_tree_P1_L16_global_reset out_no_zeros_32_128_gl4.txt ans_no_zeros_32_128_gl4.txt sim_tree_P1_L16 merger 
	if [[ $$(diff -u out_no_zeros_32_128_gl4.txt ans_no_zeros_32_128_gl4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L16_GLOBAL_RESET' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L16_global_reset' 1>&2; \
	fi

test_tree_P1_L32 : compile_tree_P1_L32 filter_output_tree_P1_L32 out_no_zeros_64_128.txt ans_no_zeros_64_128.txt sim_tree_P1_L32 merger 
	if [[ $$(diff -u out_no_zeros_64_128.txt ans_no_zeros_64_128.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L32' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L32' 1>&2; \
	fi

test_tree_P1_L32_global_reset : filter_output_tree_P1_L32_global_reset out_no_zeros_64_128_gl4.txt ans_no_zeros_64_128_gl4.txt sim_tree_P1_L32 merger 
	if [[ $$(diff -u out_no_zeros_64_128_gl4.txt ans_no_zeros_64_128_gl4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L32_GLOBAL_RESET' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L32_global_reset' 1>&2; \
	fi

test_tree_P1_L64 : compile_tree_P1_L64 filter_output_tree_P1_L64 out_no_zeros_128_128.txt ans_no_zeros_128_128.txt sim_tree_P1_L64 merger 
	if [[ $$(diff -u out_no_zeros_128_128.txt ans_no_zeros_128_128.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L64' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L64' 1>&2; \
	fi

test_tree_P1_L64_global_reset : filter_output_tree_P1_L64_global_reset out_no_zeros_128_32_gl4.txt ans_no_zeros_128_32_gl4.txt sim_tree_P1_L64 merger 
	if [[ $$(diff -u out_no_zeros_128_32_gl4.txt ans_no_zeros_128_32_gl4.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L64_GLOBAL_RESET' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L64_global_reset' 1>&2; \
	fi

test_tree_P1_L128 : compile_tree_P1_L128 filter_output_tree_P1_L128 out_no_zeros_256_16.txt ans_no_zeros_256_16.txt sim_tree_P1_L128
	if [[ $$(diff -u out_no_zeros_256_16.txt ans_no_zeros_256_16.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P1_L128' 1>&2; \
	else \
		echo 'SUCESS! tree_P1_L128' 1>&2; \
	fi

test_tree_P16_L128 : compile_tree_P16_L128 filter_output_tree_P16_L128 out_no_zeros_256_16_1_16.txt ans_no_zeros_256_16_1_16.txt sim_tree_P16_L128 
	if [[ $$(diff -u out_no_zeros_256_16_1_16.txt ans_no_zeros_256_16_1_16.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P16_L128' 1>&2; \
	else \
		echo 'SUCESS! tree_P16_L128' 1>&2; \
	fi

test_tree_P32_L128 : compile_tree_P32_L128 filter_output_tree_P32_L128 out_no_zeros_256_16_1_16.txt ans_no_zeros_256_16_1_16.txt sim_tree_P32_L128 
	if [[ $$(diff -u out_no_zeros_256_16_1_32.txt ans_no_zeros_256_16_1_32.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST TREE_P32_L128' 1>&2; \
	else \
		echo 'SUCESS! tree_P32_L128' 1>&2; \
	fi

test_coupler : compile_coupler filter_output_coupler out_no_zeros_1_128.txt ans_no_zeros_1_128.txt sim_coupler _coupler
	if [[ $$(diff -u out_no_zeros_1_128.txt ans_no_zeros_1_128.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST COUPLER' 1>&2; \
	else \	
		echo 'SUCESS! coupler' 1>&2; \
	fi

test_tree_P4_L4_8_chunk: chunk_data
	iverilog -o tree_P4_L4_8_chunk MERGER_TREE_P4_L4_8_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_8_chunk
	python clean_data.py out_P4_L4_8_chunk.txt out.txt;
	cat out.txt | uniq > data_P4_L4_64_chunk.txt;

test_tree_P4_L4_64_chunk: chunk_data
	iverilog -o tree_P4_L4_64_chunk MERGER_TREE_P4_L4_64_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_64_chunk
	python clean_data.py out_P4_L4_64_chunk.txt out.txt;
	cat out.txt | uniq > data_P4_L4_512_chunk.txt;

test_tree_P4_L4_512_chunk: chunk_data
	iverilog -o tree_P4_L4_512_chunk MERGER_TREE_P4_L4_512_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_512_chunk
	python clean_data.py out_P4_L4_512_chunk.txt out.txt;
	cat out.txt | uniq > data_P4_L4_4096_chunk.txt

test_tree_P4_L4_4096_chunk: chunk_data
	iverilog -o tree_P4_L4_4096_chunk MERGER_TREE_P4_L4_4096_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_4096_chunk
	python clean_data.py out_P4_L4_4096_chunk.txt out.txt;
	cat out.txt | uniq > result.txt
	sort data_4096_9_1.txt | uniq > sort.txt
	sed -i '/^$$/d' sort.txt;
	sed -i '/^00000000$$/d' result.txt;
	sed -i '/^00000000$$/d' sort.txt;
	if [[ $$(diff -u result.txt sort.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST 4096' 1>&2; \
	else \
		echo 'SUCESS! TEST 4096' 1>&2; \
	fi

test_tree_P4_L4_integrated: chunk_data
	iverilog -o tree_P4_L4_8_chunk MERGER_TREE_P4_L4_8_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_8_chunk
	python clean_data.py out_P4_L4_8_chunk.txt out.txt;
	cat out.txt | uniq > data_P4_L4_64_chunk.txt;
	iverilog -o tree_P4_L4_64_chunk MERGER_TREE_P4_L4_64_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_64_chunk
	python clean_data.py out_P4_L4_64_chunk.txt out.txt;
	cat out.txt | uniq > data_P4_L4_512_chunk.txt;
	iverilog -o tree_P4_L4_512_chunk MERGER_TREE_P4_L4_512_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_512_chunk
	python clean_data.py out_P4_L4_512_chunk.txt out.txt;
	cat out.txt | uniq > data_P4_L4_4096_chunk.txt
	iverilog -o tree_P4_L4_4096_chunk MERGER_TREE_P4_L4_4096_CHUNK_tb.v MERGER_TREE_P4_L4.v MERGER.v MERGER_2.v MERGER_4.v BITONIC_NETWORK.v BITONIC_NETWORK_4.v BITONIC_NETWORK_8.v COUPLER.v FIFO.v CONTROL.v
	vvp tree_P4_L4_4096_chunk
	python clean_data.py out_P4_L4_4096_chunk.txt out.txt;
	cat out.txt | uniq > result.txt;
	sort data_4096_9_1.txt | uniq > sort.txt
	sed -i '/^$$/d' sort.txt;
	sed -i '/^00000000$$/d' sort.txt;
	sed -i '/^00000000$$/d' result.txt;
	if [[ $$(diff -u result.txt sort.txt) ]]; then \
		echo 'ERROR! OUTPUT MISMATCH FOR TEST 4096' 1>&2; \
	else \
		echo 'SUCESS! TEST 4096' 1>&2; \
	fi

test_all : test_coupler test_merger_4 test_tree_P2_L8_global_reset test_tree_P2_L8 test_merger_2 test_tree_P1_L64_global_reset test_tree_P1_L64 test_tree_P1_L32_global_reset test_tree_P1_L32 test_tree_P1_L16_global_reset test_tree_P1_L16 data test_tree_P1_L8 test_tree_P1_L8_global_reset test_merger_1 
	echo "All tests run." 1>&2;