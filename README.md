docker-nuodb
============

docker container for nuodb database

- [2.0, 2.0.4 (2.0/Dockerfile)](https://github.com/kakawait/docker-nuodb/blob/master/2.0/Dockerfile)
- [2.1, 2.1.1 (2.1/Dockerfile)](https://github.com/kakawait/docker-nuodb/blob/master/2.1/Dockerfile)
- [2.2, 2.2.0 (2.2/Dockerfile)](https://github.com/kakawait/docker-nuodb/blob/master/2.2/Dockerfile)

ATTENTION READ this if you plan to use >= 2.1
---------------------------------------------

Since >= 2.1 Nuodb forces Linux kernel with Transparent Huge Pages to be **disabled** else service won't be launch.

So we have to tune 

```
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
```

But in order to edit kernel file container should be run with `--privileged=true` or you should set this value on the HOST.

Ports
-----

Nuodb needs some open ports (can be tuned by using `NEW_PROCESS_PORT_RANGE`):

- `48004`: broker
- `48005`: SM for your database
- `48006`: TE for your database

If you set AUTOMATION=true

- `48007`: SM for `nuodb_system` database
- `48008`: TE for `nuodb_system` database

### Optional

- `8888`: Nuodb REST
- `8889`: Nuodb Admin
- `9001`: Nuodb legacy console & SQL explorer (since 2.1)

Usage
-----

To create the image kakawait/nuodb, execute the following command:

    docker build -t kakawait/nuodb .

To run the image and bind to port 48004:

    docker run -d --privileged=true -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 kakawait/nuodb

ATTENTION if you are using boot2docker please use the following command (see section Configuration -> BROKER_ALT_ADDR for more information):

    docker run -d --privileged=true -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 -e BROKER_ALT_ADDR=<boot2docker ip> kakawait/nuodb

Where <boot2docker ip> can be retrieve using `boot2docker ip` command. On MacOsX you can run like following:

    docker run -d --privileged=true -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 -e BROKER_ALT_ADDR=$(boot2docker ip 2>/dev/null) kakawait/nuodb

The first time that you run your container, check the logs of the container by running:

    docker logs -f <CONTAINER_ID>

You will see an output like the following:

    ========================================================================================
    You can now connect to this Nuodb Server:

        domain:
        [user] domain
        [password] bird

        database [testdb]:
        [user] dba
        [password] bird
        
        Hosts:
        [broker] localhost/127.0.0.1:48004 (DEFAULT_REGION)
        
        Database: testdb
        [SM] 87ff08502c9e/192.168.59.103:48005 (DEFAULT_REGION) [ pid = 290 ] RUNNING
        [TE] 87ff08502c9e/192.168.59.103:48006 (DEFAULT_REGION) [ pid = 352 ] RUNNING
       
        ecosystem:
        [autoconsole] localhost:8888
        [autoconsole-admin] localhost:8889
        [web console] localhost:9001
    ==========================================================================================

Done!

Configuration
-------------

### Environment variables

- `BROKER` (default: `true`): Should this host be a broker?
- `BROKER_ALT_ADDR` (default: `<HOST IP>`): Specify this if you want other nodes to connect to this server at an address that is not local to the host.
- `NEW_PROCESS_PORT_RANGE`: (default: `48005`): Specify port range for new nuodb process (sm, te, ...). 
- `DOMAIN_USER` (default: `domain`): The administrative user for your domain. All nodes should have the same user.
- `DOMAIN_PASSWORD` (default: `bird`): The administrative password for your domain. All nodes should have the same password. If you set value `**Random**` a random password will be generated.
- `DBA_USER` (default: `dba`): The administrative user for you database (see `DATABASE_NAME`).
- `DBA_PASSWORD` (default: `bird`): The administrative password for you database (see `DATABASE_NAME`). If you set value `**Random**` a random password will be generated.
- `DATABASE_NAME` (default: `testdb`): The database name of new database created when launching the container.
- `AUTOMATION` (default: `false`): Whether to enable automation on the system database. [NuoDB manual](http://dev.nuodb.com).
- `AUTOMATION_BOOTSTRAP` (default: `false`): Should this node bootstrap the system database? See [NuoDB manual](http://dev.nuodb.com).
- `LOG_LEVEL` (default: `INFO`): Valid levels are, from most to least verbose: ALL, FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE, OFF.
- `LICENSE`: Nuodb license to be installed.
- `NUOAGENT` (default: `true`): Specify if container should launch nuoagent service (main process).
- `NUOWEBCONSOLE` (default: `true`): Specify if container should launch nuowebconsole service (optional).
- `NUORESTSVC` (default: `true`): Specify if container should launch nuorestsvc service (optional).

### Override configuration

You could override nuodb `default.properties` by using mounting volume:

    docker run -d -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 -v <override-dir>:/nuodb-override kakawait/nuodb

where <override-dir> is an absolute path of a directory that could contain:

- `default.properties`: custom config file

Placeholder environment variable could be used inside your overrided `default.properties` like following:

    domainPassword = ${DOMAIN_PASSWORD}

Thus `domainPassword` will be equals to value of environment variable `$DOMAIN_PASSWORD`

### BROKER_ALT_ADDR

If you plan to used nuodb container as remote database, for example using `jdbcUrl` like following:

    jdbc:com.nuodb://<DOCKER_HOST_WITH_NUODBCONTAINER>/testdb

Where <DOCKER_HOST_WITH_NUODBCONTAINER> is not local address (`localhost`, `127.0.0.1`) **you must define `BROKER_ALT_ADDR` environment variable to be equals to <DOCKER_HOST_WITH_NUODBCONTAINER>**.

Thus run container for above `jdbcUrl` like following:

    docker run -d -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 -e BROKER_ALT_ADDR=<DOCKER_HOST_WITH_NUODBCONTAINER> kakawait/nuodb

If you are using `boot2docker`, you should use private network adapter to communicate with your container so please use:

    docker run -d -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 -e BROKER_ALT_ADDR=$(boot2docker ip 2>/dev/null) kakawait/nuodb

### Mounting the database file volume

In order to persist the database data, you can mount a local folder from the host on the container to store the database files. To do so:

    docker run -d -p 48004:48004 -p 48005:48005 -p 48006:48006 -p 9001:9001 -p 8888:8888 -v /path/in/host:/opt/nuodb/data kakawait/nuodb