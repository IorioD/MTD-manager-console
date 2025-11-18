#!/bin/bash

# Execute 'mvn clean install'
mvn clean install

# Check result
if [ $? -ne 0 ]; then
    echo "Error during 'mvn clean install'. Aborting execution..."
    exit 1
fi

# Execute 'java -jar ./target/mtd-manager.jar' to start the app
java -jar ./target/mtd-manager.jar
