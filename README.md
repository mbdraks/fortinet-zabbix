# Zabbix Templates for Fortinet devices

## Validated Versions
- Zabbix 4.4
- FortiOS 6.2

## Usage
- Import the templates and associated them to your devices
- There's no need to import the Fortinet MIBs on Zabbix Server, the template is using numeric OIDs

## Graphs

- Each template will almost always generate some automatic graphs, here's some samples:

![Active VPN Tunnels][active_vpn_tunnels]

[active_vpn_tunnels]: /static/active_vpn_tunnels.png "Active VPN Tunnels"
