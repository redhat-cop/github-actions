import sys
from ruamel.yaml import YAML

path = sys.argv[1]
chart_version = sys.argv[2]
app_version = sys.argv[3]

yaml = YAML()
yaml.default_flow_style = False

with open(f"{path}/Chart.yaml") as f:
    data = yaml.load(f)

if chart_version != "false":
    data["version"] = chart_version
if app_version != "false":
    data["appVersion"] = app_version

with open(f"{path}/Chart.yaml", "w") as f:
    yaml.dump(data, f)
