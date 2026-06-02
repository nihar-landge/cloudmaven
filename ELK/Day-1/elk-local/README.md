# Local ELK Stack (Elasticsearch, Logstash, Kibana)

A simple Docker Compose setup to run the ELK stack locally for development and testing.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Components

- **Elasticsearch 8.13.0**: Search and analytics engine (Port 9200)
- **Logstash 8.13.0**: Server-side data processing pipeline (Port 5044)
- **Kibana 8.13.0**: Visualization platform (Port 5601)

## Project Structure

```text
.
├── README.md
├── docker-compose.yml
└── logstash
    └── pipeline
        └── logstash.conf
```

## Docker Compose Configuration

The `docker-compose.yml` file defines the three core services. It uses **Elasticsearch 8.13.0**, **Kibana 8.13.0**, and **Logstash 8.13.0**.

### `docker-compose.yml`

```yaml
version: "3.8"

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.13.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
    volumes:
      - esdata:/usr/share/elasticsearch/data
    networks:
      - elk
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9200"]
      interval: 10s
      timeout: 10s
      retries: 5

  kibana:
    image: docker.elastic.co/kibana/kibana:8.13.0
    container_name: kibana
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      elasticsearch:
        condition: service_healthy
    networks:
      - elk

  logstash:
    image: docker.elastic.co/logstash/logstash:8.13.0
    container_name: logstash
    ports:
      - "5044:5044"
      - "9600:9600"
    environment:
      - "xpack.monitoring.enabled=false"
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline
    depends_on:
      elasticsearch:
        condition: service_healthy
    networks:
      - elk

volumes:
  esdata:

networks:
  elk:
    driver: bridge
```

## Configuration Details

### 1. Environment Variables
- **`discovery.type=single-node`**: Configures Elasticsearch to run without a cluster.
- **`xpack.security.enabled=false`**: Disables authentication for easy local access (No login/password required).
- **`ES_JAVA_OPTS`**: Limits JVM heap size to 512MB to save local system memory.
- **`ELASTICSEARCH_HOSTS`**: Tells Kibana where to find the Elasticsearch service.

### 2. Healthchecks
The stack uses Docker Healthchecks to ensure services start in the correct order:
- **Elasticsearch** must be fully "Healthy" (responding to pings) before **Kibana** and **Logstash** start.
- This prevents connection errors during the initial startup phase.

## Getting Started

1. **Clone the repository** (or ensure you are in the project directory).

2. **Start the ELK stack**:
   ```bash
   docker-compose up -d
   ```

3. **Verify the services are running**:
   - **Elasticsearch**: [http://localhost:9200](http://localhost:9200)
   - **Kibana**: [http://localhost:5601](http://localhost:5601)

## Logstash Configuration

Logstash is configured to receive data via the **Beats** input on port `5044`. The pipeline configuration is located in `./logstash/pipeline/logstash.conf`.

Default Pipeline:
```conf
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
}
```


## Stopping the Stack

To stop and remove the containers:
```bash
docker-compose down
```

To remove the containers and the persisted Elasticsearch data:
```bash
docker-compose down -v
```
