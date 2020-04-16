# Zabbix Templates for Fortinet FortiGate devices

## Overview

This template goal is to contain all available SNMP information provided
by a Fortinet FortiGate device.

### Template Version
- v1.2

### Validated Versions
- Zabbix 4.4
- FortiOS 6.2 / 6.4

### Setup
- Download the template
- Import the template and associated them to your devices
- Change the Device Inventory from Disabled (Zabbix default) to Automatic
- There's no need to import the Fortinet MIBs on Zabbix Server, the template is using numeric OIDs

## Template Details

### Zabbix Configuration
You can tune the following macros, which are used by some triggers:
- {$CPU.UTIL.CRIT} = 80
- {$MEMORY.UTIL.MAX} = 80

### Template Links
- Template Module EtherLike-MIB SNMPv2
- Template Module Generic SNMPv2
- Template Module Interfaces SNMPv2

### Discovery Rules
- CPU Cores
- Interfaces
- SD-WAN Performance SLA
- SOC3 Processor
- High Availability

### Items Collected
- CPU
    - CPU usage
    - CPU usage per core (1m and 5s)
    - CPU usage per process type over 1m (System and User)

- Memory
    - Memory usage

- Storage
    - Hard Disk Capacity
    - Hard Disk Usage
    - Hard Disk Usage Rate

- Inventory
    - Serial Number
    - Model Description
    - Operating System
    - Firmware Version

- Session
    - IPv4 Active sessions

- ICMP
    - Loss
    - Response Time

- VPN
    - Active IPsec VPN tunnels
    - Active SSL VPN users
    - SSL VPN state

- SD-WAN
    - Health Check Name
    - Health Check State
    - Health Check Latency, Jitter, Packet Loss
    - Health Packets Sent and Received
    - Health Check VDOM
    - Available Bandwidth Incoming / Outgoing

- High Availability
    - HA Mode, Group ID, Cluster Name, Member Priority
    - Master Override, Master SN, Config Sync, Config Checksum
    - CPU, Memory, Network Usage per member
    - Session Count, Packet and Bytes Processed per member
    - AV and IPS event rate per member
    - Hostname, Sync Status, Sync Time (Success and Failure)


### Triggers
- CPU
    - High CPU usage

- Memory
    - High memory usage

- ICMP
    - High ICMP ping response time
    - High ICMP ping loss

### Graphs
- CPU
    - CPU usage

- Memory
    - Memory usage

- Hard Disk
    - Hard Disk Usage

- VPN
    - Active VPN tunnels (IPsec and SSL)

- SD-WAN
    - Health Check Latency, Jitter, Packet Loss per member
    - Health Packets Sent and Received

- Session
    - IPv4 Concurrent Connections

- High Availability
    - Concurrent Connections
    - CPU Usage
    - Memory Usage
    - Network Bandwidth Usage
    - Security Events Rate

### Host Screens
- System Performance
    - CPU
    - Memory
    - Hard Disk
    - ICMP Response Time

- SD-WAN Performance SLA
    - Performance SLA metrics per Health Check per SD-WAN member

- High Availability
    - All graph prototypes available


### Host Inventory
This template will automatically populate the following host inventory fields:
- Name
- OS
- OS (Short)
- Serial Number A
- Hardware (Full details)
- Software (Full details)
- Contact
- Location


## Feedback
Please send your comments, requests for additional items and bug reports at [Issues](https://github.com/barbosm/fortinet-zabbix/issues).

## Demo
Each items will almost always generate some automatic graphs, here's some samples:

- Active VPN Tunnels Graph
![Active VPN Tunnels](/static/active_vpn_tunnels.png)

- High Availability Screen
![High Availability 01](/static/ha_screen_01.png)
![High Availability 02](/static/ha_screen_02.png)


## Known Issues
No support for VDOMs at this time

## References
- [Zabbix template guidelines](https://www.zabbix.com/documentation/guidelines/thosts)
- [FortiGate 6.2 SNMP Cookbook](https://docs.fortinet.com/document/fortigate/6.2.0/cookbook/62595/snmp)
