#!/bin/bash -x

CWD="$(dirname "$(readlink -f "$0")")"

"$CWD"/fuel_config_verify.sh
"$CWD"/fuel_infra_install.sh
"$CWD"/docker_swarm.sh
"$CWD"/k8s.sh
