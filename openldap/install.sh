kubectl create ns epso14
kubens epso14

helm repo add helm-openldap https://jp-gouin.github.io/helm-openldap
helm install --set replicaCount=1,global.adminPassword=admin,global.configPassword=admin openldap-server helm-openldap/openldap-stack-ha 

kubectl wait --for=condition=Ready  --timeout=360s pod/openldap-server-0

sleep 20

#PENLAP_POD=$(kubectl get po -l app=openldap-server-openldap-stack-ha -o custom-columns=:metadata.name)
#OPENLAP_POD=`echo $OPENLAP_POD | xargs`
OPENLAP_POD=openldap-server-0

echo podname=$OPENLAP_POD

# copy files to openldap pod
kubectl cp openldap/00-ou.ldif $OPENLAP_POD:/root
kubectl cp openldap/01-groups.ldif $OPENLAP_POD:/root
kubectl cp openldap/02-users.ldif $OPENLAP_POD:/root
kubectl cp openldap/add-pepe-to-read.ldif $OPENLAP_POD:/root
kubectl cp openldap/remove-pepe-from-read.ldif $OPENLAP_POD:/root

# import ldif entries
kubectl exec -it $OPENLAP_POD -- /bin/bash -c 'ldapadd -x -H ldap://localhost:389 -D "cn=admin,dc=example,dc=org" -w admin -f ~/00-ou.ldif'
kubectl exec -it $OPENLAP_POD -- /bin/bash -c 'ldapadd -x -H ldap://localhost:389 -D "cn=admin,dc=example,dc=org" -w admin -f ~/01-groups.ldif'
kubectl exec -it $OPENLAP_POD -- /bin/bash -c 'ldapadd -x -H ldap://localhost:389 -D "cn=admin,dc=example,dc=org" -w admin -f ~/02-users.ldif'
kubectl exec -it $OPENLAP_POD -- /bin/bash -c 'ldapsearch -x -H ldap://localhost:389 -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin'

