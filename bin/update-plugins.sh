#!/usr/bin/env bash

echo "Updating plugins"

docker-compose run jenkins bash -c "stty -onlcr && java -jar /usr/local/lib/jenkins-plugin-manager.jar -f /usr/share/jenkins/ref/plugins.txt --available-updates --output txt" > jenkins/plugins2.txt

mv jenkins/plugins2.txt jenkins/plugins.txt

git diff jenkins/plugins.txt

echo "Updating plugins complete"
