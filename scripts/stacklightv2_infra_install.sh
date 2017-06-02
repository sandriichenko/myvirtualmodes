#!/bin/bash -x
exec > >(tee -i /tmp/"$(basename "$0" .sh)"_"$(date '+%Y-%m-%d_%H-%M-%S')".log) 2>&1

CWD="$(dirname "$(readlink -f "$0")")"

# Import common functions
COMMONS="$CWD"/common_functions.sh
if [ ! -f "$COMMONS" ]; then
    echo "File $COMMONS does not exist"
    exit 1
fi
. "$COMMONS"

# Configure Telegraf
salt -C 'I@telegraf:agent' state.sls telegraf

# Configure Elasticsearch/Kibana services
salt -C 'I@elasticsearch:server' state.sls elasticsearch.server -b 1
salt -C 'I@kibana:server' state.sls kibana.server -b 1
salt -C 'I@elasticsearch:client' state.sls elasticsearch.client.service
salt -C 'I@elasticsearch:client' --async service.restart salt-minion
sleep 10
salt -C 'I@elasticsearch:client' state.sls elasticsearch.client
salt -C 'I@kibana:client' state.sls kibana.client

# Collect grains needed to configure the services
salt -C 'I@salt:minion' state.sls salt.minion.grains
salt -C 'I@salt:minion' saltutil.refresh_modules
salt -C 'I@salt:minion' mine.update
sleep 5

# Configure the services running in Docker Swarm
salt -C 'I@docker:swarm' state.sls prometheus.server,prometheus.alertmanager -b 1
for img in pushgateway alertmanager prometheus; do
    salt -C 'I@docker:swarm' dockerng.pull "docker-sandbox.sandbox.mirantis.net/bkupidura/$img"
    salt -C 'I@docker:swarm' dockerng.tag "docker-sandbox.sandbox.mirantis.net/bkupidura/$img:latest" "$img:latest"
done
salt -C 'I@docker:swarm:role:master' state.sls docker
salt -C 'I@docker:swarm' dockerng.ps

# Configure Grafana dashboards and datasources
stacklight_vip=$(get_param_value stacklight_monitor_address)
wait_for_http_service "http://${stacklight_vip}:15013/"
salt -C 'I@grafana:client' state.sls grafana.client
