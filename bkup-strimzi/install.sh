kubectl create ns epso14
kubens epso14

sh strimzi/00-install-strimzi.sh
sh strimzi/01-create-broker.sh
sh strimzi/02-create-client.sh

