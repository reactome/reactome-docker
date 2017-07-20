#!/bin/bash
read -p "Build webapps? Press y/n" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "==========================================================================="
  echo "                   Building webapps using reactome-app-builder"
  echo "==========================================================================="
  cd ./java-application-builder
  bash ./build_webapps.sh |& tee ../logs/build_webapps.log
  cd ..
  echo "Reactome-app-builder exits here."
fi

echo -e "\n\n"
echo "==========================================================================="
echo "Copying war files from java-application-builder/webapps to tomcat/webapps/"
echo "==========================================================================="
echo "Files to be copied:"
ls ./java-application-builder/webapps/
cp --verbose -u ./java-application-builder/webapps/*.war ./tomcat/webapps/
# Don't forget: also need the analysis.bin file for AnalysisService!
cp --verbose -u ./java-application-builder/webapps/analysis.bin ./tomcat/webapps/
cp ./java-application-builder/downloads/interactors.db ./tomcat/webapps/

echo -e "\n\n"
echo "==========================================================================="
echo "                        Starting docker containers"
echo "==========================================================================="
docker-compose up
docker-compose down
