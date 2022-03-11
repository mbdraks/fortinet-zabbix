# Zabbix Templates for Fortinet FortiGate devices

## Overview

This template goal is to contain all available SNMP information provided
by a Fortinet FortiGate device.

### Template Version
- v2.1.0

### Validated Versions
- Zabbix 5.2 / 5.4 / 6.0
- FortiOS 6.2 / 6.4 / 7.0

### Setup
- Download the template
- Import the template and associate them to your devices
- Change the Device Inventory from Disabled (Zabbix default) to Automatic
- There's no need to import the Fortinet MIBs on Zabbix Server, the template is using numeric OIDs

## Template Details

### Zabbix Configuration
You can tune the following macros, which are used by some triggers:
- {$CPU.UTIL.CRIT} = 80
- {$MEMORY.UTIL.MAX} = 80
- {$IF_ID1} = 1; IF ID where Egress Shaping is configured
- {$IF_IN_ID1} = 2; IF ID where Ingress Shaping is configured

### Templates Included
The following templates were included into this one (instead of linked)
due to several users having issues during import process when the default
templates are not present on their Zabbix install. All data and discovery
was simply copied from them into this template.

- Template Module EtherLike-MIB
- Template Module Generic
- Template Module Interfaces

### Discovery Rules
- CPU Cores
- Network Interfaces (standard and FOS specific metrics)
- SD-WAN Performance SLA
- SOC3 Processor
- High Availability
- Interface-based Shaping (Ingress and Egress)
- Wireless (FortiAP)
- Virtual Domain

### Items Collected
- General
    - System contact details, System description
    - System location, System name, System object ID

- Network Interfaces
    - Bits received/sent, discards, errors
    - Type, operational status, speed
    - Estimated bandwidth (upstream and downstream)

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

- Status
    - ICMP Loss
    - ICMP Response Time
    - Uptime
    - SNMP data collection availability

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

- Hardware Sensor
    - Hardware Sensor Alarm Count
    - Hardware Sensor Alarm Name and State

- IPS (Intrusion Prevention System)
    - Intrusions detected and blocked
        - Detected by severity level
        - Detected by signature or anomaly

- Interface-based Shaping (Ingress and Egress)
    - Allocated, Guaranteed, Maximum and Current Bandwidth
    - Byte rate and Packet drops

- Wireless
    - Controller Location, Name
    - Station Capacity/Count
    - WTP (Wireless Termination Point/FortiAP) Capacity, Managed and Sessions
    - FAP Serial Number (ID), Status, Admin Status, Base MAC Address, 
    - Connected Clients, CPU/Memory Usage, Version (Bootloader, SW and HW)
    - IP Address, IP Address Type, Local IP Address, Local IP Address Type
    - Model Number, FAP Name, Profile Name, Uptime (Device, Daemon and Session)
    - Capabilities Enabled (Background Scan, Automatic Power Control and Limits)
    - Byte Count Rate (Tx/Rx)

- Virtual Domain
    - VDOM Name
    - VDOM Count, VDOM Max Count
    - VDOM Operation Mode
    - CPU usage per VDOM
    - Memory usage per VDOM
    - HA Member state per VDOM
    - Active Sessions per VDOM
    - Session Rate per VDOM



### Triggers
- CPU
    - High CPU usage

- Memory
    - High memory usage

- ICMP
    - High ICMP ping response time
    - High ICMP ping loss

- SD-WAN
    - Health Check State Down

- Wireless
    - FortiAP is down / restarted
    - Firmware updates
    - High CPU/Memory Usage

### Graphs
- Network Interfaces
    - Network traffic
    - Estimated bandwidth

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

- IPS
    - All IPS metrics

- Interface-based Shaping (Ingress and Egress)
    - All metrics

- Wireless
    - Health (CPU / Memory)
    - Clients
    - Byte Count Rate (Tx/Rx)

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
Please send your comments, requests for additional items and bug reports at [Issues](https://github.com/mbdraks/fortinet-zabbix/issues).

## Additional Info
Detailed OID coverage report is available at [Coverage](COVERAGE.md)

## Demo
Each items will almost always generate some automatic graphs, here's some samples:

- Active VPN Tunnels Graph
![Active VPN Tunnels](/static/active_vpn_tunnels.png)

- High Availability Screen
![High Availability 01](/static/ha_screen_01.png)
![High Availability 02](/static/ha_screen_02.png)

## Known Issues
No support for VDOMs at this time

## Compatibility
- Zabbix 5.2 - Template v2.0+
- [Zabbix 4.4 - Template v1.5](https://github.com/mbdraks/fortinet-zabbix/releases/tag/v1.5.0)

## References
- [Zabbix template guidelines](https://www.zabbix.com/documentation/guidelines/thosts)
- [FortiGate 6.2 SNMP Cookbook](https://docs.fortinet.com/document/fortigate/6.2.0/cookbook/62595/snmp)
