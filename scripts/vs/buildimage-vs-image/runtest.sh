#!/bin/bash -xe

cd $HOME
mkdir -p .ssh
cp /data/pkey.txt .ssh/id_rsa
chmod 600 .ssh/id_rsa
cd /data/sonic-mgmt/ansible
./testbed-cli.sh -m veos.vtb -t vtestbed.csv refresh-dut vms-kvm-t0 lab password.txt || true
sleep 3
./testbed-cli.sh -m veos.vtb -t vtestbed.csv deploy-mg vms-kvm-t0 lab password.txt
sleep 30
export ANSIBLE_LIBRARY=/data/sonic-mgmt/ansible/library/
cd /data/sonic-mgmt/tests
py.test --inventory veos.vtb --host-pattern all --user admin -vvv --show-capture stdout --testbed vms-kvm-t0 --testbed_file vtestbed.csv test_bgp_fact.py
