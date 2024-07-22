#!/bin/bash

# Execute 'mvn clean install'
mvn clean install

# Check result
if [ $? -ne 0 ]; then
    echo "Errore durante l'esecuzione di 'mvn clean install'. Interrompendo lo script."
    exit 1
fi

# Execute 'java -jar ./target/mtd-manager.jar' to start the app
java -jar ./target/mtd-manager.jar
