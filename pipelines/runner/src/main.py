#!/usr/bin/env python

from rich import print
from pathlib import Path
import yaml

from typing import Dict, List
from pydantic import BaseModel, Field

class PipelineConfig(BaseModel):
    pipeline_name: str = Field(description="Name of the pipeline")
    lar_area: str = Field(description="Path to larsoft area")
    n_ev: int = Field(10, description="Number of events")
    skip_stages: int = Field(0, description="Number of stages to skip")

    stages: Dict[str, str] = Field(
        description="Mapping of stage names to their configuration files"
    )

    sequence: List[str] = Field(
        description="Ordered list of stages to execute"
    )

import click

@click.command()
@click.argument('card_file', type=click.Path(exists=True, dir_okay=False))
def main(card_file):
    # print("Hello from runner!")

    # from subprocess import call
    # with open('/afs/cern.ch/work/t/thea/dune/dune-trg-sandbox/pipelines/example_map.sh', 'rb') as file:
    #     script = file.read()


    #     print(script)
    #     # rc = call(script, shell=True)

    # Load YAML from file
    yaml_path = Path(card_file)
    with yaml_path.open("r") as f:
        data = yaml.safe_load(f)
    # Parse into Pydantic model
    config = PipelineConfig(**data)


    script=f"""
source {config.lar_area}/setup_dunesw.sh
"""

    work_dir = Path.cwd()
    for i, stage in enumerate(config.sequence):
        print(f"Stage {i} : '{stage}'")

        if i == 0:
            k=config.n_ev
            src_file_opt = ''
        else:
            k=-1
            src_file_opt = f'-s {out_file}'


        cfg_file=config.stages[stage]
        out_dir=work_dir / stage 
        out_file= out_dir /f'{stage}_{config.pipeline_name}.root'


        print(cfg_file)
        print(out_dir)
        print(out_file)


        script += f"""

# ---- {config.pipeline_name} stage {i} : '{stage}' ----
mkdir -p {out_dir}    
cd {out_dir}

cmd_line="lar -c {cfg_file} {src_file_opt} -o {out_file} -n {k}"
echo -e "\\nExecuting '${{cmd_line}}'\\n"
${{cmd_line}}
"""

    print(script)


if __name__ == "__main__":
    main()
