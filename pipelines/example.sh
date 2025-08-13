#!/usr/bin/env bash
sample="bkg_rad_dec0_1x8x14"
# set -x
n_ev=1
k=4
skip_ev=40

base_dir=$(pwd)


gen_fcl="prodbackground_radiological_decay0_dunevd10kt_1x8x14.fcl"
gen_fname=" ${base_dir}/gen/gen_${sample}.root"


mkdir -p ${base_dir}/gen
cd ${base_dir}/gen
cmd_line="lar -c ${gen_fcl} -o ${gen_fname} -n ${n_ev}"
echo -e "\nExecuting '${cmd_line}'\n"
# ${cmd_line}


g4_fcl="${HOME}/work/dune/dune-trg-sandbox/fcl/vd/standard_g4_dunevd10kt_1x8x14_3view_30deg.fcl"
g4_fname=" ${base_dir}/g4/g4_${sample}.root"

mkdir -p ${base_dir}/g4
cd ${base_dir}/g4
cmd_line="lar -c ${g4_fcl} -s ${gen_fname} -o ${g4_fname} -n -1"
echo -e "\nExecuting '${cmd_line}'\n"
# ${cmd_line}


detsim_fcl="${HOME}/work/dune/dune-trg-sandbox/fcl/vd/detsim_dunevd10kt_1x8x14_3view_30deg_notpcsigproc.fcl"
detsim_fname=" ${base_dir}/detsim/detsim_${sample}.root"

mkdir -p ${base_dir}/detsim
cd ${base_dir}/detsim
cmd_line="lar -c ${detsim_fcl} -s ${gen_fname} -o ${detsim_fname} -n -1"
echo -e "\nExecuting '${cmd_line}'\n"
${cmd_line}







