#!/bin/bash -eu

### This script is run directly from make when building the project
### Add local scripts to be run during build process

ln -fs ./blog/index.html out/personal-site/index.html
