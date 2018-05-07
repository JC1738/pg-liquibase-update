#!/bin/sh

echo "Setting up liquidbase"

cat <<CONF > /home/duser/liquibase.properties
  driver: org.postgresql.Driver
  classpath:/opt/jdbc_drivers/postgresql-42.1.4.jar
CONF

echo "Applying changelogs ..."
: ${CHANGELOG_FILE:="changelogs.xml"}

ERROR_EXIT_CODE=1
MAX_TRIES=${MAX_TRIES:-10}
COUNT=1
LIQUIBASE_URL=${URL}
while [ $COUNT -le $MAX_TRIES ]; do
   echo  "Attempting to apply changelogs: attempt $COUNT of $MAX_TRIES"
   liquibase --changeLogFile="/changelogs/$CHANGELOG_FILE" --url="$LIQUIBASE_URL" update
   if [ $? -eq 0 ];then
   	  echo "Changelogs successfully applied"
      exit 0
   fi
   echo "Failed to apply changelogs"
   sleep 1
   let COUNT=COUNT+1
done
echo "Too many non-successful tries"
exit $ERROR_EXIT_CODE
