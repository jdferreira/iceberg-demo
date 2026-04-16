# Iceberg Local Demo (Spark + REST Catalog + MinIO)

This repository provides a deterministic local demo for showcasing Apache Iceberg table semantics on top of object storage.

## Stack

- Spark SQL engine (`tabulario/spark-iceberg`)
- Iceberg REST catalog (`apache/iceberg-rest-fixture`)
- MinIO object storage
- MinIO CLI (`mc`) for object inspection

## What this demo proves

- DDL and DML on Iceberg tables (`CREATE`, `INSERT`, `UPDATE`, `DELETE`, `SELECT`)
- Snapshot lineage and metadata inspection
- Time travel queries
- Rollback to a previous snapshot
- Physical layout in object storage (metadata + Parquet files)

# Iceberg Demo Narrative

Use this script while sharing your screen.

## Two terminals

- Use `tmux` to spawn 2 terminal in the same emulator: `scripts/start-tmux.sh`
- Terminal 1 - left - used for interactive Spark SQL
- Terminal 2 - right - table state checks

## 0) Pre-demo setup (before the presentation starts)

```bash
cd /home/jdferreira/Repos/Personal/iceberg-demo
scripts/reset.sh
docker compose up -d
scripts/start-tmux.sh
```

Then on terminal 1:
```bash
docker compose exec spark spark-sql
SET spark.sql.cli.print.header=true;
```

## 1) Bootstrap and seed data

Narrative:
- First I create the a `journeys` table and seed it with some data

Terminal 1:
```sql
SOURCE /opt/demo/sql/bootstrap-and-seed.sql;
```

## 2) Baseline query

Narrative:
- Now I query the table. I'm using Spark SQL as the engine on top of the Iceberg table. This means I need to interact with the table using Spark's SQL dialect.
- Here I'm getting the number of stations in the journey and the name of the first station

Terminal 1:
```sql
SELECT journey_id, user_id, start_time, price, SIZE(stations) AS station_count, ELEMENT_AT(stations.name, 1) AS first_station_name FROM journeys ORDER BY start_time;
```

Narrative:
- Now we can look at the storage layer
- Inside the metadata, Iceberg stores `current-snapshot-id`

Terminal 2:
```bash
scripts/storage-tree.sh
scripts/table-state.sh
```


## 3) Apply mutations and re-check

Narrative:
- Now on for some mutation: an update and a deletion
- Iceberg does not mutate files in place; it commits a new snapshot new files
- The state confirms the new snapshots, and we can confirms file-level changes at the storage layer level

Terminal 1:
```sql
UPDATE journeys SET price = price + 10 WHERE user_id = 'u1';
DELETE FROM journeys WHERE journey_id = 'j4';
SELECT journey_id, user_id, start_time, price, SIZE(stations) AS station_count, ELEMENT_AT(stations.name, 1) AS first_station_name FROM journeys ORDER BY start_time;
```

Terminal 2:
```bash
scripts/storage-tree.sh
scripts/table-state.sh
```

## 4) Time travel

Narrative:
- We can query an older snapshot
- Time travel is not approximate; it is snapshot-addressed and deterministic
- It works because we don't old delete data

Terminal 1:
```sql
SELECT journey_id, user_id, start_time, price, SIZE(stations) AS station_count, ELEMENT_AT(stations.name, 1) AS first_station_name FROM journeys VERSION AS OF _________ ORDER BY start_time;
```

