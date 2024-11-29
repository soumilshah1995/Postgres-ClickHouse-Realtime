CREATE DATABASE kafka;

CREATE TABLE kafka.users
(
    user_id UInt32,
    username String,
    account_type String,
    updated_at DateTime,
    created_at DateTime,
    kafka_time Nullable(DateTime),
    kafka_offset UInt64
)ENGINE = ReplacingMergeTree
ORDER BY (user_id, updated_at)
SETTINGS index_granularity = 8192;

SELECT * FROM kafka.users
OPTIMIZE TABLE kafka.users FINAL;
CREATE TABLE kafka.kafka__users
(
    user_id UInt32,
    username String,
    account_type String,
    updated_at UInt64,
    created_at UInt64
)ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:29092',
kafka_topic_list = 'postgres.public.users',
kafka_group_name = 'clickhouse',
kafka_format = 'AvroConfluent',
format_avro_schema_registry_url='http://schema-registry:8081';


CREATE MATERIALIZED VIEW kafka.consumer__users TO kafka.users
(
    user_id UInt32,
    username String,
    account_type String,
    updated_at DateTime,
    created_at DateTime,
    kafka_time Nullable(DateTime),
    kafka_offset UInt64
) AS
SELECT
    user_id,
    username,
    account_type,
    toDateTime(updated_at / 1000000) AS updated_at,
    toDateTime(created_at / 1000000) AS created_at,
    _timestamp AS kafka_time,
    _offset AS kafka_offset
FROM kafka.kafka__users;



