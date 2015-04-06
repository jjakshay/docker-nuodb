[supervisord]
nodaemon=true

[program:nuoagent]
environment=SHELL="/bin/bash"
environment=NUODB_USER=nuodb
command=java -jar /opt/nuodb/jar/nuoagent.jar
user=nuodb
autostart=${NUOAGENT}

[program:nuodbwebconsole]
environment=SHELL="/bin/bash"
environment=NUODB_USER=nuodb
command=java -jar /opt/nuodb/jar/nuodbwebconsole.jar
user=nuodb
autostart=${NUOWEBCONSOLE}

[program:nuodbautoconsole]
environment=SHELL="/bin/bash"
environment=NUODB_USER=nuodb
command=java -jar /opt/nuodb/jar/nuodb-rest-api.jar server /opt/nuodb/etc/nuodb-rest-api.yml
user=nuodb
autostart=${NUORESTSVC}
