import yaml
import json
with open('build-config.yml', 'r') as stream:
  print(json.dumps(yaml.safe_load(stream)))

