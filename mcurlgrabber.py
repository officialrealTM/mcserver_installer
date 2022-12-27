import sys
import urllib.request
import json
from packaging import version

def find_version_info(ver):
    versions_raw = urllib.request.urlopen("https://launchermeta.mojang.com/mc/game/version_manifest.json").read()
    versions = json.loads(versions_raw)["versions"]

    for version_info in filter(lambda x: x["type"] == "release", versions):
        if version.parse(version_info["id"]) == ver:
            version_info_raw = urllib.request.urlopen(version_info["url"]).read()
            return json.loads(version_info_raw)

    sys.exit(1)


def get_java_version(ver):
    version_info = find_version_info(ver)
    java_version = version_info["javaVersion"]["majorVersion"]
    print(java_version)


def get_server_url(ver):
    version_info = find_version_info(ver)
    server_url = version_info["downloads"]["server"]["url"]
    print(server_url)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        raise Exception("Invalid arguments")

    v = version.parse(sys.argv[2])
    if not isinstance(v, version.Version):
        sys.exit(1)

    if sys.argv[1] == "server-url":
        get_server_url(v)
    elif sys.argv[1] == "java-version":
        get_java_version(v)