#!/bin/bash

#!/bin/bash

# compile_bench(bench, nprocs, class)
compile_bench() {
	local bench="${1}"
	local nprocs="${2}"
	local class="${3}"

	make "${bench}" NPROCS="${nprocs}" CLASS="${class}"
}

for class in A B C D; do
	compile_bench lu 1 "${class}"
	compile_bench sp 1 "${class}"
	compile_bench sp 1 "${class}"
	compile_bench bt 1 "${class}"
	compile_bench bt 1 "${class}"
done

