#!/usr/bin/python3
# -*- coding: utf-8 -*-

# The script creates a tar.xz tarball from git-repository of LAMMPS-project
# ./get_orig commitID   -   creates a tarball of specified commit
# ./get_orig   - creates a tarball of the latest version
# Packages, that needs to be installed to use the script:
# atool, python-git, git-core


import os, sys, git

print ("Cloning the git-repo.")
os.system('git clone http://git.icms.temple.edu/lammps-ro.git git_temp_packaging')
repo = git.Repo("./git_temp_packaging/")
rev = ''
head = ''

if (len(sys.argv) > 1):
  rev = str(sys.argv[1])
  print ('Trying to clone the specified revision %s.' % (rev))
  os.system('cd ./git_temp_packaging/; git checkout -b temp %s' % (rev))
  head = repo.commits('temp')[0]
else:
  print ("Cloned the latest revision.")
  head = repo.commits()[0]

rev = str(head)[:7]
dateP = head.authored_date
versionN = "0~%04d%02d%02d.git%s" % (dateP.tm_year, dateP.tm_mon, dateP.tm_mday, rev)
folderName = 'lammps-%s' % (versionN)
print ('Packaged commit is %s' % (rev))
print ('Version number %s' % (versionN))

#renaming the folder
os.system('mv git_temp_packaging %s' % (folderName))
#removing  git-dir
os.system('rm -rf %s/.git' % (folderName))
#packing
print ("Creating a tarball.")
os.system('apack lammps_%s.orig.tar.xz %s' % (versionN, folderName))


print ("Removing temporary cloned git-repo.")
os.system('rm -rf folderName')
