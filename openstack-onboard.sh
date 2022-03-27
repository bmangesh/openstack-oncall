#!  /bin/bash

 openstack network list
 openstack subnet list
 
 openstack router list
 
 openstack network create k8s-workload
 openstack subnet create --network k8s-workload  --dns-nameserver 8.8.8.8 --gateway 192.168.1.1 --subnet-range 192.168.1.0/24 k8s-workload
 
 openstack network create database-workload
 openstack subnet create --network database-workload  --dns-nameserver 8.8.8.8 --gateway 192.168.2.1 --subnet-range 192.168.2.0/24 database-workload-subnet
 
 openstack network create webapp-workload
 openstack subnet create --network webapp-workload  --dns-nameserver 8.8.8.8 --gateway 192.168.3.1 --subnet-range 192.168.3.0/24 webapp-workload-subnet
 
 openstack router create cloud-native-router
 openstack router add subnet  cloud-native-router k8s-workload
 openstack router add subnet  cloud-native-router database-workload-subnet
 openstack router add subnet  cloud-native-router webapp-workload-subnet
 
 openstack port list --router cloud-native-router
 
 openstack security group rule create --proto icmp default
 openstack security group rule create --proto tcp --dst-port 22 default
 
 openstack server create --flavor 1C1R4D --image CirrOS --nic net-id=database-workload-subnet --security-group default cloud-native-instance
  
  openstack volume create --size 1 cloud-native-volume --type tier1
  openstack volume create --size 1 webapp-volume --type tier2
  openstack server add volume $INSTANCE_ID $VOLUME_ID --device /dev/sdd 
