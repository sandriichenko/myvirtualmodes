#!/bin/bash -x
exec > >(tee -i /tmp/"$(basename "$0" .sh)"_"$(date '+%Y-%m-%d_%H-%M-%S')".log) 2>&1

install_infra () {
  # DOP config and rundeck files should be created before container start
  salt -C 'I@devops_portal:config' state.sls devops_portal.config
  salt -C 'I@rundeck:server' state.sls rundeck.server
}

install_services () {
  # Up containers
  salt -C 'I@docker:swarm:role:master' state.sls docker.client

  # XXX: first run may fails
  salt -C 'I@postgresql:client' cmd.run 'while true; do if docker service logs postgresql_db | grep "ready to accept"; then break; else sleep 5; fi; done'
  for i in $(seq 2); do
      salt -C 'I@postgresql:client' state.sls postgresql.client
      sleep 10
  done

  # Rundeck client, jobs, and etc
  salt -C 'I@rundeck:client' cmd.run 'while true; do curl -sf 172.16.10.254:4440 >/dev/null && break; done'
  salt -C 'I@rundeck:client' state.sls rundeck.client

  # ElasticSearch indicies
  salt -C 'I@elasticsearch:client' cmd.run 'while true; do curl -sf 172.16.10.254:9200 >/dev/null && break; done'
  for i in $(seq 3); do
    salt -C 'I@elasticsearch:client' state.sls elasticsearch.client
    sleep 10
  done
}

case "$1" in
  "infra")
    install_infra
  ;;
  "services")
    install_services
  ;;
esac
