DOCKER_COMPOSE:=docker compose
PUBSUB_NAME:=pubsub
TOPIC_NAME:=counter
PAYLOAD:=3

define EVENT_PAYLOAD
endef

start:
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) rm --stop --force

restart: stop start

pub:
	docker compose exec queueprocessor \
		curl "http://localhost:3500/v1.0/publish/$(PUBSUB_NAME)/$(TOPIC_NAME)" \
		--header "Content-Type: text/plain" \
		--data 3

pending:
	redis-cli XRANGE $(TOPIC_NAME) - +

clear:
	redis-cli FLUSHDB

monitor:
	redis-cli MONITOR
