
curl -L https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.26.0/strimzi-cluster-operator-0.26.0.yaml \
  | sed 's/namespace: .*/namespace: epso14/' \
  | kubectl apply -f - 

kubectl wait --for=condition=Available  --timeout=360s deployment.apps/strimzi-cluster-operator