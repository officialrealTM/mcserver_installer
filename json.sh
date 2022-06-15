#!/bin/bash
function json_extract {

    curl -s 'https://launchermeta.mojang.com/mc/game/version_manifest.json' | \
    python3 -c "import sys, json; print(json.load(sys.stdin(data)['versions']['id'][0])"

}

json_extract

## Maximum Numbers of ID: 639