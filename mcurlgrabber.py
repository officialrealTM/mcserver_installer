import sys
import urllib.request
import json

def find_version_info(ver):
    versions_raw = urllib.request.urlopen("https://launchermeta.mojang.com/mc/game/version_manifest.json").read()
    versions = json.loads(versions_raw)["versions"]

    for version_info in filter(lambda x: x["type"] in ["release", "snapshot"], versions):
        if version_info["id"] == ver:
            version_info_raw = urllib.request.urlopen(version_info["url"]).read()
            return json.loads(version_info_raw)

    sys.exit(1)


def get_java_version(ver):
    version_info = find_version_info(ver)
    if "javaVersion" in version_info:
        java_version = version_info["javaVersion"]["majorVersion"]
    else:
        java_version = 8
    print(java_version)


def get_server_url(ver):
    version_info = find_version_info(ver)
    if "downloads" in version_info and "server" in version_info["downloads"]:
        server_url = version_info["downloads"]["server"]["url"]
        print(server_url)
    else:
        sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        raise Exception("Invalid arguments")

    v = sys.argv[2]

    if sys.argv[1] == "server-url":
        get_server_url(v)
    elif sys.argv[1] == "java-version":
        get_java_version(v)
    else:
        sys.exit(1)