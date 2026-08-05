# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

import os
from pprint import pprint

import click
from ruamel.yaml import YAML

"""
The purpose of this script is to find log files from a tmt output directory so that they can be archived individually.
There are a few assumptions made:
  1. at least one plan was executed
  2. the plan had an execute phase
"""


def find_plan_execute_result_files(tmt_run_dir):
    """Find the result.yaml files from tmt plan executions"""
    plans_dir = os.path.join(tmt_run_dir, "plans")
    if not os.path.exists(plans_dir):
        raise Exception("Plans directory does not exist: {}".format(plans_dir))

    discovered_plans = os.listdir(plans_dir)
    if len(discovered_plans) == 0:
        raise Exception("No plans found in {}".format(plans_dir))

    result_yaml_files = []
    for plan in discovered_plans:
        result_yaml_path = os.path.join(plans_dir, plan, "execute", "results.yaml")
        if os.path.exists(result_yaml_path):
            result_yaml_files.append(result_yaml_path)

    return result_yaml_files


def parse_result_file(result_yaml_file_path):
    yaml = YAML(typ="safe")
    with open(result_yaml_file_path, "r") as f:
        yaml_docs = yaml.load(f)

    yaml_doc = yaml_docs[0]

    return {
        "logs": yaml_doc["log"],
        "name": yaml_doc["name"],
        "result": yaml_doc["result"],
        "data_path": yaml_doc["data-path"],
        "start_time": yaml_doc["start-time"],
        "end_time": yaml_doc["end-time"],
        "duration": yaml_doc["duration"],
    }


def find_last_run(tmt_basedir):
    """Assume that the runs are using the default tmt naming convention tmt-XXX and that the highest numbered run was
    the most recent run."""
    all_runs = os.listdir(tmt_basedir)
    return str(sorted(all_runs)[-1])


supported_log_types = ["output.txt", "failures.yaml"]


@click.command()
@click.option(
    "--tmt_basedir",
    default="/var/tmt/tmt",
    type=str,
    help="Base directory for TMT output files.",
)
@click.option(
    "--tmt_run_id",
    default=None,
    type=str,
    help="Specific TMT run ID to extract output file paths for.",
)
@click.option("-j", "--just-file-paths", is_flag=True)
@click.option(
    "--log_type",
    default=None,
    type=str,
    help="Specific log type to extract output file paths for.",
)
def main(tmt_basedir, tmt_run_id, just_file_paths, log_type):

    if log_type is not None:
        if log_type not in supported_log_types:
            raise Exception("Log type must be one of {}".format(supported_log_types))

    if not just_file_paths:
        print("Extracting output files from runs at {}".format(tmt_basedir), flush=True)

    target_run = tmt_run_id
    if target_run is None:
        target_run = find_last_run(tmt_basedir)

    if not just_file_paths:
        print("target run is {}".format(target_run), flush=True)

    tmt_run_dir = os.path.abspath(os.path.join(tmt_basedir, target_run))

    result_yaml_files = find_plan_execute_result_files(tmt_run_dir)

    if not just_file_paths:
        print("result yaml files:", flush=True)
        for result_yaml_file in result_yaml_files:
            print(result_yaml_file, flush=True)

    result_data = []
    for result_yaml_file in result_yaml_files:
        result_data.append(parse_result_file(result_yaml_file))

    if not just_file_paths:
        print("results:")
        for result_data in result_data:
            pprint(result_data)
    else:
        found_file_paths = []
        for result_data in result_data:
            for log_file_path in result_data["logs"]:
                if log_type is not None:
                    basename = os.path.basename(log_file_path)
                    if log_type != basename:
                        continue
                found_file_paths.append(log_file_path)
        for found_file_path in found_file_paths:
            print(found_file_path, flush=True)


if __name__ == "__main__":
    main()
