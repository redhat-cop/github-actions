"""
Short and sweet, this just adds an extra image to relatedImages if it doesn't already
exist. "Already exists" means "there's a relatedImage with a value field that matches
the provided ref on the command line".

Updates the ClusterServiceVersion YAML file in place.
"""

import argparse
from ruamel.yaml import YAML

argparse = argparse.ArgumentParser()
argparse.add_argument("csv_file", type=str, help="Path to ClusterServiceVersion YAML")
argparse.add_argument("name", type=str, help="Name of the related image")
argparse.add_argument("ref", type=str, help="Reference to the related image")
args = argparse.parse_args()

with open(args.csv_file, "r") as stream:
    yaml = YAML()
    csv = yaml.load(stream)

if not 'relatedImages' in csv['spec']:
    csv['spec']['relatedImages'] = []

present = False

for image in csv['spec']['relatedImages']:
    if image['image'] == args.ref:
        # already present, skip
        present = True

if not present:
    csv['spec']['relatedImages'].append({ 'name': args.name, 'image': args.ref })

with open(args.csv_file, 'w') as stream_out:
    yaml = YAML()
    yaml.dump(csv, stream_out)

