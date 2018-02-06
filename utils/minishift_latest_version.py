#!/usr/bin/env python

import requests
import re
import os

OS = os.getenv('OS', 'linux')

def main():
    pattern = re.compile(".*%s-amd64.(tgz|zip)$" % OS)
    r = requests.get('https://api.github.com/repos/minishift/minishift/releases/latest')
    for asset in r.json()['assets']:
        if pattern.match(asset['name']):
            print asset['browser_download_url']

if __name__ == "__main__":
    main()
