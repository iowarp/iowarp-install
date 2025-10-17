#!/bin/bash
set -e

echo "Starting DataHub GMS..."

# Start DataHub GMS with all required environment variables
/home/hyoklee/miniconda3/bin/podman run -d \
  --name datahub-gms \
  --hostname datahub-gms \
  --network datahub_network \
  -p 8080:8080 \
  -v /home/hyoklee/.datahub/plugins:/etc/datahub/plugins:rw \
  -v /home/hyoklee/.datahub/search:/etc/datahub/search:rw \
  -e ALTERNATE_MCP_VALIDATION=true \
  -e DATAHUB_SERVER_TYPE=quickstart \
  -e DATAHUB_TELEMETRY_ENABLED=false \
  -e DATAHUB_UPGRADE_HISTORY_KAFKA_CONSUMER_GROUP_ID=generic-duhe-consumer-job-client-gms \
  -e EBEAN_DATASOURCE_DRIVER=com.mysql.jdbc.Driver \
  -e EBEAN_DATASOURCE_HOST=mysql:3306 \
  -e EBEAN_DATASOURCE_PASSWORD=datahub \
  -e EBEAN_DATASOURCE_URL='jdbc:mysql://mysql:3306/datahub?verifyServerCertificate=false&useSSL=true&useUnicode=yes&characterEncoding=UTF-8&enabledTLSProtocols=TLSv1.2' \
  -e EBEAN_DATASOURCE_USERNAME=datahub \
  -e ELASTICSEARCH_HOST=search \
  -e ELASTICSEARCH_INDEX_BUILDER_MAPPINGS_REINDEX=true \
  -e ELASTICSEARCH_INDEX_BUILDER_SETTINGS_REINDEX=true \
  -e ELASTICSEARCH_LIMIT_RESULTS_STRICT=true \
  -e ELASTICSEARCH_PORT=9200 \
  -e ELASTICSEARCH_PROTOCOL=http \
  -e ELASTICSEARCH_USE_SSL=false \
  -e ENTITY_REGISTRY_CONFIG_PATH=/datahub/datahub-gms/resources/entity-registry.yml \
  -e ENTITY_SERVICE_ENABLE_RETENTION=true \
  -e ENTITY_VERSIONING_ENABLED=true \
  -e ES_BULK_REFRESH_POLICY=WAIT_UNTIL \
  -e GRAPH_SERVICE_DIFF_MODE_ENABLED=true \
  -e GRAPH_SERVICE_IMPL=elasticsearch \
  -e JAVA_OPTS='-Xms1g -Xmx1g' \
  -e KAFKA_BOOTSTRAP_SERVER=broker:29092 \
  -e KAFKA_SCHEMAREGISTRY_URL=http://datahub-gms:8080/schema-registry/api/ \
  -e MAE_CONSUMER_ENABLED=true \
  -e MCE_CONSUMER_ENABLED=true \
  -e METADATA_SERVICE_AUTH_ENABLED=true \
  -e NEO4J_HOST=http://neo4j:7474 \
  -e NEO4J_PASSWORD=datahub \
  -e NEO4J_URI=bolt://neo4j \
  -e NEO4J_USERNAME=neo4j \
  -e PE_CONSUMER_ENABLED=true \
  -e SCHEMA_REGISTRY_TYPE=INTERNAL \
  -e STRICT_URN_VALIDATION_ENABLED=true \
  -e THEME_V2_DEFAULT=true \
  -e UI_INGESTION_ENABLED=true \
  -e UI_INGESTION_DEFAULT_CLI_VERSION=1.2.0 \
  -e NO_PROXY='localhost,127.0.0.1,broker,mysql,search,datahub-gms,opensearch' \
  -e no_proxy='localhost,127.0.0.1,broker,mysql,search,datahub-gms,opensearch' \
  -e DATAHUB_PRECONDITION_SKIP=true \
  acryldata/datahub-gms:v1.2.0

echo "Waiting for GMS to start (this may take 2-3 minutes)..."
sleep 120

echo "Checking GMS health..."
/home/hyoklee/miniconda3/bin/podman exec datahub-gms sh -c 'curl -s http://localhost:8080/health' || echo "GMS still starting..."

echo ""
echo "Starting DataHub Frontend..."

# Start DataHub Frontend
/home/hyoklee/miniconda3/bin/podman run -d \
  --name datahub-frontend \
  --hostname datahub-frontend-react \
  --network datahub_network \
  -p 9002:9002 \
  -v /home/hyoklee/.datahub/plugins:/etc/datahub/plugins:rw \
  -e DATAHUB_APP_VERSION=1.0 \
  -e DATAHUB_GMS_HOST=datahub-gms \
  -e DATAHUB_GMS_PORT=8080 \
  -e DATAHUB_PLAY_MEM_BUFFER_SIZE=10MB \
  -e DATAHUB_SECRET=YouKnowNothing \
  -e DATAHUB_TRACKING_TOPIC=DataHubUsageEvent_v1 \
  -e ELASTIC_CLIENT_HOST=elasticsearch \
  -e ELASTIC_CLIENT_PORT=9200 \
  -e 'JAVA_OPTS=-Xms512m -Xmx512m -Dhttp.port=9002 -Dconfig.file=datahub-frontend/conf/application.conf -Djava.security.auth.login.config=datahub-frontend/conf/jaas.conf -Dlogback.configurationFile=datahub-frontend/conf/logback.xml -Dlogback.debug=false -Dpidfile.path=/dev/null' \
  -e KAFKA_BOOTSTRAP_SERVER=broker:29092 \
  -e THEME_V2_DEFAULT=true \
  -e NO_PROXY='localhost,127.0.0.1,broker,mysql,search,datahub-gms,opensearch' \
  -e no_proxy='localhost,127.0.0.1,broker,mysql,search,datahub-gms,opensearch' \
  acryldata/datahub-frontend-react:v1.2.0

echo ""
echo "Starting DataHub Actions..."

# Start DataHub Actions
/home/hyoklee/miniconda3/bin/podman run -d \
  --name datahub-actions \
  --hostname actions \
  --network datahub_network \
  -e ACTIONS_CONFIG='' \
  -e ACTIONS_EXTRA_PACKAGES='' \
  -e DATAHUB_GMS_HOST=datahub-gms \
  -e DATAHUB_GMS_PORT=8080 \
  -e DATAHUB_GMS_PROTOCOL=http \
  -e DATAHUB_SYSTEM_CLIENT_ID=__datahub_system \
  -e DATAHUB_SYSTEM_CLIENT_SECRET=JohnSnowKnowsNothing \
  -e ELASTICSEARCH_HOST=search \
  -e ELASTICSEARCH_PORT=9200 \
  -e ELASTICSEARCH_PROTOCOL=http \
  -e ELASTICSEARCH_USE_SSL=false \
  -e KAFKA_BOOTSTRAP_SERVER=broker:29092 \
  -e KAFKA_PROPERTIES_SECURITY_PROTOCOL=PLAINTEXT \
  -e METADATA_AUDIT_EVENT_NAME=MetadataAuditEvent_v4 \
  -e METADATA_CHANGE_LOG_VERSIONED_TOPIC_NAME=MetadataChangeLog_Versioned_v1 \
  -e SCHEMA_REGISTRY_URL=http://datahub-gms:8080/schema-registry/api/ \
  -e NO_PROXY='localhost,127.0.0.1,broker,mysql,search,datahub-gms,opensearch' \
  -e no_proxy='localhost,127.0.0.1,broker,mysql,search,datahub-gms,opensearch' \
  acryldata/datahub-actions:v1.2.0-slim

echo ""
echo "DataHub deployment initiated!"
echo ""
echo "Services:"
echo "  - GMS API: http://localhost:8080"
echo "  - Frontend UI: http://localhost:9002"
echo ""
echo "Checking container status..."
/home/hyoklee/miniconda3/bin/podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep datahub
