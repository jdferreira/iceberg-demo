import json
import os

import fastavro
import requests

response = requests.get("http://localhost:8181/v1/namespaces/app/tables/journeys")

data = response.json()

current_snapshot_id = data["metadata"]["current-snapshot-id"]
current_snapshot = next(s for s in data["metadata"]["snapshots"] if s["snapshot-id"] == current_snapshot_id)
manifest_list = current_snapshot["manifest-list"]
manifest_list_path = manifest_list.replace("s3://", "minio/")

os.system(f"docker compose exec mc mc cat {manifest_list_path} > /tmp/manifest_list.avro")


def json_skip_bytes(record):
    """
    Recursively convert a record to a JSON-serializable format, skipping any bytes fields
    """

    if isinstance(record, list):
        return [json_skip_bytes(item) for item in record if not isinstance(item, bytes)]
    elif isinstance(record, dict):
        return {k: json_skip_bytes(v) for k, v in record.items() if not isinstance(v, bytes)}
    else:
        return record


with open("/tmp/manifest_list.avro", "rb") as f:
    reader = fastavro.reader(f)
    for record in reader:
        manifest_file = record["manifest_path"].replace("s3://", "minio/")
        os.system(f"docker compose exec mc mc cat {manifest_file} > /tmp/manifest.avro")
        with open("/tmp/manifest.avro", "rb") as mf:
            manifest_reader = fastavro.reader(mf)
            for manifest_record in manifest_reader:
                print(manifest_record)

        print(json.dumps(json_skip_bytes(record)))
