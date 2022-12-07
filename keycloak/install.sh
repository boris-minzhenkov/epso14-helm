kubectl create ns epso14
kubens epso14

sh keycloak/00-create-certs.sh
sh keycloak/01-install-keycloak.sh
sh keycloak/02-add-authz-realm.sh