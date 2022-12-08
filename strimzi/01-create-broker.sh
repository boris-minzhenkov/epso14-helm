
kubectl delete secret broker-oauth-secret
kubectl delete secret ca-truststore

export HISTCONTROL=ignorespace
export BROKER_SECRET=kafka-broker-secret
kubectl create secret generic broker-oauth-secret --from-literal=secret=$BROKER_SECRET
kubectl create secret generic ca-truststore --from-file=ca.crt
kubectl apply -f strimzi/kafka-persistent-single-oauth-authz-alt-2.8.0.yaml

sleep 20
kubectl wait --for=condition=Ready --timeout=360s pod/my-cluster-zookeeper-0

sleep 20
kubectl wait --for=condition=Ready --timeout=360s pod/my-cluster-kafka-0

sleep 20
kubectl wait --for=condition=Available  --timeout=360s deployment/my-cluster-entity-operator

