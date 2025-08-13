#!/usr/bin/bash

# Configuration

sample="eminus"

declare -A stages_configs

stages_configs["gen"]="${HOME}/app/dune-trg-sandbox/fcl/vd/prodbackground_radiological_decay0_dunevd10kt_1x8x6_patched.fcl"
stages_configs["g4"]="${HOME}/app/dune-trg-sandbox/fcl/vd/standard_g4_dunevd10kt_1x8x6_3view_30deg.fcl"
stages_configs["detsim"]="${HOME}/app/dune-trg-sandbox/fcl/vd/detsim_dunevd10kt_1x8x6_3view_30deg_notpcsigproc.fcl"
stages_configs["tpg"]="${HOME}/app/dune-trg-sandbox/fcl/vd/trig_studies_tpg_st_rs_ars.fcl"

stages=("gen" "g4" "detsim" "tpg")
n_ev=3
skip_stages=0

#-------------------------------------
# Don't touch beyond this point

base_dir=$(pwd)
for i in "${!stages[@]}"; do
    cd ${base_dir}
    stage=${stages[$i]}
    echo ">>> Stage: '$stage' <<< "

    if [[ $i -eq 0 ]]; then
        k=${n_ev}
        src_file_opt=''
    else
        k='-1'
        src_file_opt="-s ${out_file}"
    fi
    
    cfg_file=${stages_configs[$stage]}
    out_dir=${base_dir}/${stage} 
    out_file=${out_dir}/${stage}_${sample}.root

    if [[ $i -lt $skip_stages ]]; then
        echo "   <skipping>"
        continue
    fi

    mkdir -p ${out_dir}    
    cd ${out_dir}

    cmd_line="lar -c ${cfg_file} ${src_file_opt} -o ${out_file} -n ${k}"
    echo -e "\nExecuting '${cmd_line}'\n"
    ${cmd_line}

done



# gen_fcl="prodbackground_radiological_decay0_dunevd10kt_1x8x14.fcl"
# gen_fname=" ${base_dir}/gen/gen_${sample}.root"


# mkdir -p ${base_dir}/gen
# cd ${base_dir}/gen
# cmd_line="lar -c ${gen_fcl} -o ${gen_fname} -n ${n_ev}"
# echo -e "\nExecuting '${cmd_line}'\n"
# # ${cmd_line}



