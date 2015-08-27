# Copyright (C) NuoDB, Inc. 2012-2014  All Rights Reserved.
#
# The default agent properties. To use a different source of properties set
# the system property "propertiesUrl" to the URL of a properties file:
#
#   java -DpropertiesUrl=URL nuoagent.jar ...
#
# The default values for each property are shown in this file. All addresses
# can optionally include a port number using the syntax host:port.
#
# Note that all of these properties are optional, except for the domain
# password. A default value is assigned to this. Domain administrators should
# pick a new password to secure their domains.
#
# 2.0 History:
#
# 2.0.1
#   "metricsPurgeAge", "eventsPurgeAge" added
# 2.0.2
#   "automationTemplate" added
# 2.0.3
#   "automationTemplate": Once the admin db has been created during bootstrap,
#       use Auto Console UI to edit the admin db's template. The bootstrap
#       process will no longer upgrade the template as it did in 2.0.2
#   "peer" supports comma-separated list of peers
# 2.0.4
#   "agentPeerTimeout", "hostTags" added (optional)
#   "singleHostDbRestart" added, default TRUE
# 2.0.5
#    added support for policy "balancer=AffinityBalancer"
# 2.1
#   removed default "domainPassword"
#   added "removeSelfOnShutdown"
#   revised "heartbeatPeerTimeout"
#   Automation, managed databases:
#   * added "enableSystemDatabase"
#   * added "schEnforcerPeriodSec, schEnforcerInitDelaySec, runEnforcerOnEveryEvent"
#   * revised/deprecated "enableAutomation"
#   * removed "enableAutomationBootstrap", "enableHostStats", "eventsPurgeAge"
#
#   The "peer" property has been changed for brokers:
#   * A broker no longer supports a comma-separated list of peers
#   * A broker now supports its own address as peer attribute (peer to self)
#
#   added "RaftHeartbeatTimeout", "RaftMinElectionTimeout", "RaftMaxElectionTimeout"
#
# 2.1.1
#   added "RaftLogCompactionThreshold"

# A flag specifying whether this agent should be run as a connection broker
broker = ${BROKER}

# The name used to identify the domain that this agent is a part of 
domain = ${DOMAIN_USER}

# The default administrative password, and the secret used by agents to
# setup and maintain the domain securely
domainPassword = ${DOMAIN_PASSWORD}

# The port that this agent listens on for all incoming connections
port = 48004

# An existing peer (agent or broker) already running in the domain that this
# agent should connect to on startup to extend the running domain.
# 2.0.3 or later support a comma-separated list of peers
#peer = 

# An alternate address to use in identifying this host, which is not actually
# advertised unless the advertiseAlt property is set.
altAddr = ${BROKER_ALT_ADDR}

# A flag specifying whether the alternate address should be advertised instead
# of the locally observed network addresses. This is only meaningful for
# brokers, because only brokers advertise addresses to clients and admins.
advertiseAlt = true

# The region for this host. The region of a host should not be changed after it
# has been set.
#region = 
    
# The log level for the agent log output. Valid levels are, from most to least 
# verbose: ALL, FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE, OFF
log = ${LOG_LEVEL}

# The location of the directory with the 'nuodb' executable, which is typically
# the same as the directory where the nuoagent.jar file is found
#binDir = .

# A range of port numbers that nuodb instances should be confined to. This is
# of the form start[,end].  Note: Specifying a start without an end indicates
# that process TCP/IP ports are assigned incrementally from the start without
# limit
# 
# Each new process (transaction engine or storage manager) that is started on a
# machine is communicated with via an assigned TCP/IP port that is specified
# via this property.  Ensure firewall rules allow access from other machines.
portRange = ${NEW_PROCESS_PORT_RANGE}

# A flag specifying whether this host has automation enabled and should attempt
# to access the NuoDB "nuodb_system" admin database
enableAutomation = ${AUTOMATION}

# A flag indicating that a Broker should auto-start the NuoDB "nuodb_system"
# admin database / TE
enableAutomationBootstrap = ${AUTOMATION_BOOTSTRAP}

# A flag specifying whether host level statistics should be collected using
# sigar. The default is inferred from the property "enableAutomation"
enableHostStats = true

# The interval (in seconds) that brokers should wait between sending out UDP
# broadcast messages for local discovery, and that agents should wait to hear
# those messages on startup. By default broadcast is turned off so peering
# is done using the 'peer' property.
#broadcast = 0

# A flag specifying whether nuodb instances can only be started through this
# agent (as opposed to directly starting a nuodb process on the system). If this
# flag is true then a "connection key" is required of all nuodb instances. A
# connection key is only available if the process was started through a request
# on the agent. This is a good best-practice flag for locking down a system.
#requireConnectKey = false

# A flag specifying the SQL connection load balancer that this broker should
# use. The balancer determines how the broker chooses to which TE a SQL
# connection is routed. This property has no effect on an agent.
#
# Set this property to "RegionBalancer" to enable a policy where SQL clients
# are connected to TEs in this broker's region in a round-robin pattern. If
# no TEs are present in this broker's region then connections will be routed
# to TEs in any region in a round-robin pattern.
#
# Set this property to "AffinityBalancer" to enable a balancer that provides
# three simple options. First, if the connection request contains the property
# key "LBTag" then this balancer will look for an existing host with the same
# tag and matching values. Second, if there is a TE local to the host where
# the connection request was made then that TE is preferred. Finally, failing
# either test, simple round-robin balancing is used. The default key "LBTag"
# can be overwritten by setting the "affinityBalancerTag" property.
#balancer =

# ADDED in 2.0.1 #

# When "enableAutomation" is set, prune metrics by age. Default is 12 hours: 12h
# Supported Units are d=day, h=hour, m=minute.
#metricsPurgeAge =

# ADDED in 2.0.2 #

# If enableAutomationBootstrap is enabled, then use this template to enforce
# the NuoDB "nuodb_system" admin database.
# REVISED in 2.0.3:
# Once admin db is created during bootstrap, use Auto Console UI to edit
# the admin db's template.
#automationTemplate = Single Host

# ADDED in 2.0.4 #

# By default, an Agent will shutdown when the peer attempt failed. By setting
# this property, the Agent will continue to try to entry peer, until the timeout
# in milliseconds has been reached. To preserve backward compatibility, the default
# is to not retry. Note that this option is not related to Agent reconnect when
# its peer Broker disconnects; this option is only for the initial entry into the
# domain.
#agentPeerTimeout = -1

# This property enables auto-restart of single host databases. The Broker
# writes a marker file into the varDir (e.g. /var/opt/nuodb1/demo-archives/)
# when a database starts up. On machine / Broker restart, the broker starts
# any database for which a marker exists. A database shutdown command will
# remove the marker. Only applicable for "un-managed" databases not governed
# by Automation.
# Code default is false, to preserve backward compatibilty
# singleHostDbRestart = false
singleHostDbRestart = true

# Set this property to inject additional Host Tags into the Agent's TagService.
# Well-defined host tags that are injected by default such as "osversion", "region"
# can not be overwritten and will be ignored. The format is a comma-separated list
# of key=value pairs, with each string token being trimmed.
# Example: hostTags = tag1 = val, tag2=v2  
#hostTags =

# ADDED in 2.1 #

# Set this property to false if a broker JVM termination (kill -TERM, including
# service restart) should not remove itself from the durable domain
# configuration.
#removeSelfOnShutdown = true

# If this property is set to true, the broker(s) will provision the optional
# database "nuodb_system" in the domain. Among other things, it stores
# persistent metrics on hosts and database processes which are available both in
# the Automation Console UI as well as the Rest API. This database is managed,
# and will be automated using the template per the above "automationTemplate"
# property. If it's not provisioned automatically here during broker startup,
# it can always be created later using managed database creation.
#enableSystemDatabase = false

# There are three timeout value properties that can be adjusted if Raft
# leadership is not stable. As a general set of rules:
# 1. RaftHeartbeatTimeout should be significantly higher than the latency
# 2. RaftMinElectionTimeout should be significantly higher than the
#    RaftHeartbeatTimeout
# 3. RaftMaxElectionTimeout should be higher than RaftMinElectionTimeout
# If elections are being triggered too often the RaftHeartbeatTimeout and/or
#  the RaftMinElectionTimeout should be increased (maintaining the above rules).
# If elections take too many rounds to be resolved (lots of "Converting to
#  Candidate" with no "Converting to Leader") the difference between
#  RaftMinElectionTimeout and RaftMaxElectionTimeout should be increased
#  (likely by increasing RaftMaxElectionTimeout).
# timeouts are in ms
#RaftHeartbeatTimeout = 500
#RaftMinElectionTimeout = 4100
#RaftMaxElectionTimeout = 8300

# REVISED undocumented property initially added in 2.0.3
#
# Agent/Broker ping their connected peer(s) periodically. A warning is printed
# if we don't hear a ping-ack after 10 seconds, and then continuously after that
# until the timeout.
# If the peer ping ack has not been received after 'heartbeatPeerTimeout'
# seconds, then the Agent/Broker will not close the session with the connected
# Agent/Broker.
# Use value > 0 for timeout to go into effect; 0 means wait forever, don't timeout.
# Choose a value higher than "RaftMaxElectionTimeout". The default is 10min; note
# that the 2.0.x default was 0.
#heartbeatPeerTimeout = 600

# Enforcer schedule properties: the Enforcer runs periodically in the Broker
# that is the current Leader, by default every 10 seconds, with an initial delay
# of 15 seconds after the Broker starts up. Each Enforcer run performs at most
# one process start per database.
# By default, most domain events (Agent joins/leaves, database engine process
# joins/leaves, update to a database template etc) call the Enforcer directly
# regardless of the schedule. This is useful in development/demo mode but should
# be disabled in production.
#schEnforcerPeriodSec = 10
#schEnforcerInitDelaySec = 15
#runEnforcerOnEveryEvent = true

# Every update to the Broker's durable domain state causes a "log entry". This
# property allows you to set a max number of entries to be stored in the
# log. When the Broker starts, it reads all log entries to compute the current
# set of state-machines. This can get expensive if you have a large number of
# entries, which are also held in memory. The default behavior is to leave the
# threshold high to provide backward compatibility; otherwise rolling upgrade
# might break if a new Broker sends information to an older Broker. It is
# recommended that a customer should set this property to a lower number.
#RaftLogCompactionThreshold = 2147483647