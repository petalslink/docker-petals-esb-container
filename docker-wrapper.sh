#!/bin/sh

# Update the host name in the topology.xml file
# (otherwise, JMX connections will not work from the outside).
HOST=`hostname -i`
sed -i "s/<tns:host>.*<\/tns:host>/<tns:host>${HOST}<\/tns:host>/ig" /opt/petals-esb/conf/topology.xml

# We also need to force a specific port for RMI.
# See http://ptmccarthy.github.io/2014/07/24/remote-jmx-with-docker/
# And https://stackoverflow.com/questions/20884353/why-java-opens-3-ports-when-jmx-is-configured
# We use the same port as the one already set in the topology.xml file.
#
# To prevent this thing to happen on every start, we create a mark file.
# Otherwise, every time a container is stopped and restarted, the env.sh file will be updated.
if [ ! -f docker-mark.txt ]; then
	# FIXME: JMX is not reachable from the outside, despite the port being exposed
	#echo "" >> /opt/petals-esb/conf/env.sh
	#echo "# Configure JMX to not randomly select a port for RMI" >> /opt/petals-esb/conf/env.sh
	#echo "JAVA_OPTS=\"\$JAVA_OPTS -Dcom.sun.management.jmxremote.rmi.port=7700 -Djava.rmi.server.hostname=0.0.0.0 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false\"" >> /opt/petals-esb/conf/env.sh
	echo "Indicate the Petals configuration was already updated for this container." > docker-mark.txt
fi

# Launch Petals
/opt/petals-esb/bin/petals-esb.sh
