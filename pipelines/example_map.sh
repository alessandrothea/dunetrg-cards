#!/usr/bin/bash


sample="eminus"

declare -A stages_configs

stages_configs["gen"]="prodbackground_radiological_decay0_dunevd10kt_1x8x14.fcl"
stages_configs["g4"]="${HOME}/work/dune/dune-trg-sandbox/fcl/vd/standard_g4_dunevd10kt_1x8x14_3view_30deg.fcl"
stages_configs["detsim"]="${HOME}/work/dune/dune-trg-sandbox/fcl/vd/detsim_dunevd10kt_1x8x14_3view_30deg_notpcsigproc.fcl"

stages=("gen" "g4" "detsim")
n_ev=3



#-------------------------------------
# Don't touch beyond this point

base_dir=$(pwd)
for i in "${!stages[@]}"; do
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



