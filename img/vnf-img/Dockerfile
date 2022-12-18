FROM ubuntu:20.04
# variables to automatically install tzdata 
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
# install required packages
RUN apt-get clean
RUN apt-get update \
    && apt-get install -y \
    net-tools \
    traceroute \
    curl \
    iptables \
    inetutils-ping \
    nano \
    build-essential \
    bridge-utils \
    isc-dhcp-server \
    tcpdump \
    openvswitch-switch \
    openvswitch-common \
    iperf3 \
    iproute2 \
    vim \
    ryu-bin \
    arpwatch

COPY vnx_config_nat /usr/bin/
COPY isc-dhcp-server /etc/default/isc-dhcp-server
COPY dhcpd.conf /etc/dhcp/dhcpd.conf 
COPY README.txt /home/README.txt
# COPY qos_simple_switch_13.py /home/qos_simple_switch_13.py

# Ryu
RUN sed '/OFPFlowMod(/,/)/s/)/, table_id=1)/' usr/lib/python3/dist-packages/ryu/app/simple_switch_13.py > /home/qos_simple_switch_13.py
# Arpwatch
RUN echo $' \nARGS="-N -p"\nRUNAS="arpwatch"\nINTERFACES="brint net1"' > /etc/default/arpwatch
