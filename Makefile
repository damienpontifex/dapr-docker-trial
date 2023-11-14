DOCKER_COMPOSE:=docker compose --file docker-compose.yaml --file compose/dapr-docker-compose.yaml
PUBSUB_NAME:=pubsub
TOPIC_NAME:=counter
PAYLOAD:=3

define EVENT_PAYLOAD
endef

start:
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) rm --stop --force

pull:
	$(DOCKER_COMPOSE) pull

processor.logs:
	$(DOCKER_COMPOSE) logs -f queueprocessor

restart: stop start

pub:
	$(DOCKER_COMPOSE) exec queueprocessor \
		curl "http://localhost:3500/v1.0/publish/$(PUBSUB_NAME)/$(TOPIC_NAME)?metadata.rawPayload=false" \
		--header "Content-Type: application/json" \
		--data 3

pending:
	redis-cli XRANGE $(TOPIC_NAME) - +

clear:
	redis-cli XTRIM $(TOPIC_NAME) MAXLEN = 0

monitor:
	redis-cli MONITOR
