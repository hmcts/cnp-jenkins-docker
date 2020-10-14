#!/usr/bin/env bash

echo "Updating plugins"

# stty command is needed due to https://github.com/moby/moby/issues/37366#issuecomment-401157643
docker-compose run jenkins bash -c "stty -onlcr && jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --available-updates --output txt" > jenkins/plugins2.txt

mv jenkins/plugins2.txt jenkins/plugins.txt

git diff jenkins/plugins.txt

echo "Updating plugins complete"
