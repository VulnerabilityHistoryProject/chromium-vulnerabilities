#!/bin/bash
echo "Hello!!"

set -ev # exit when something fails, and echo all commands

git clone git@github.com:andymeneely/vulnerability-history.git
cd vulnerability-history
bundle install
rails data:chromium
