#!/bin/sh

# Update the host name in the topology.xml file
# (otherwise, JMX connections will not work from the outside).
HOST=`hostname -i`
sed -i "s/<tns:host>.*<\/tns:host>/<tns:host>${HOST}<\/tns:host>/ig" /opt/petals-esb/conf/topology.xml

# Launch Petals
/opt/petals-esb/bin/petals-esb.sh
