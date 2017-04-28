#!/bin/bash -x
exec > >(tee -i /tmp/"$(basename "$0" .sh)"_"$(date '+%Y-%m-%d_%H-%M-%S')".log) 2>&1

salt -C 'I@docker:swarm' state.sls docker.host
salt -C 'I@docker:swarm:role:master' state.sls docker.swarm
salt -C 'I@docker:swarm' state.sls salt.minion.grains
salt -C 'I@docker:swarm' mine.update
salt -C 'I@docker:swarm:role:manager' state.sls docker.swarm -b 1
salt -C 'I@docker:swarm:role:master' cmd.run 'docker node ls'
