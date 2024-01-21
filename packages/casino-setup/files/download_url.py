#!/usr/bin/python2

# Download script for CASINO written by Synge Todo

import os
import sys
import subprocess

import config

def DownloadTemporary(url, targetdir):
    if (not os.path.isdir(targetdir)):
        os.mkdir(targetdir)
    print "Downloading " + config.url + "..."
    cmd = ['wget', '--output-document=' + targetdir + '/' + config.file, url]
    p = subprocess.check_call(cmd)
    print "Done."
    return 0

if __name__ == '__main__':
    if (len(sys.argv) != 3):
        print "Usage:", sys.argv[0], "url", "target_directory"
        sys.exit(127)
    url = sys.argv[1]
    targetdir = sys.argv[2]
    ret = DownloadTemporary(url, targetdir)
    sys.exit(ret)
