OUT=sim_out

rm -rf $OUT
mkdir -p $OUT

vcs -full64 -sverilog \
    -ntb_opts uvm-1.2 \
    -debug_access+all -kdb \
    -timescale=1ns/1ps \
    -Mdir=$OUT/csrc \
    -o $OUT/simv \
    -f run.f