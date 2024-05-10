#!/bin/bash

#Iptables for server ubuntu 22.04

#Eliminar reglas en las tablas filter y nat:
iptables -t filter -F
iptables -t nat -F

#Reinicia contenedores
iptables -t filter -Z
iptables -t nat -Z

#Politica mas restrictiva, denegando  todo
iptables -P INPUT DROP
iptables -P OUTPU DROP
iptables -P FORWARD DROP

#Peticiones al ping
iptables -A OUTPUT -o interfaz -p icmp -j ACCEPT
iptables -A INPUT -i interfaz -p icmp -j ACCEPT

#Consultas y respuestas DNS
iptables -A OUTPUT -o interfaz -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i interfaz -p udp --sport 53 -j ACCEPT

iptables -A OUTPUT -o interfaz -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -i interfaz -p tcp --sport 53 -j ACCEPT

#Habilitar interfaz loopback
iptables -I INPUT 1 -i lo -j ACCEPT
iptables -I OUTPUT 1 -o lo -j ACCEPT

#Allowing all incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Alowing SSH from specific ip
sudo iptables -A INPUT -p tcp -s 203.0.113.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allowing Outgoing SSH
sudo iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allowing Incoming Rsync from Specific IP Address or Subnet
sudo iptables -A INPUT -p tcp -s 203.0.113.0/24 --dport 873 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 873 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allowing All Incoming HTTP
sudo iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allowing All Incoming HTTPS
sudo iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allowing Established and Related Incoming Connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#Allowing MySQL from Specific IP Address or Subnet
sudo iptables -A INPUT -p tcp -s 203.0.113.0/24 --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allowing MySQL to Specific Network Interface
sudo iptables -A INPUT -i eth1 -p tcp --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o eth1 -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Port 6002 should only be accessible from IP 192.168.10.80
iptables -A INPUT -i eth0 -p tcp --dport 6000 -s 192.168.1.112 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 6000 -j DROP
