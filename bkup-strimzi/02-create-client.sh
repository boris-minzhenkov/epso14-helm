
rm kafka-client-truststore.p12 

kubectl get secret my-cluster-cluster-ca-cert -o yaml \
  | grep ca.crt | awk '{print $2}' | base64 --decode > kafka.crt

export PASSWORD=truststorepassword

keytool -keystore kafka-client-truststore.p12 -storetype PKCS12 -alias ca \
  -storepass $PASSWORD -keypass $PASSWORD -import -file ca.crt -noprompt

keytool -keystore kafka-client-truststore.p12 -storetype PKCS12 -alias kafka \
  -storepass $PASSWORD -keypass $PASSWORD -import -file kafka.crt -noprompt

kubectl create secret generic kafka-client-truststore \
  --from-file=kafka-client-truststore.p12

kubectl apply -f strimzi/kafka-client-authz-alt-2.8.0.yaml

sleep 20
kubectl wait --for=condition=Ready --timeout=360s pod/kafka-client-shell

kubectl exec -it kafka-client-shell -- /bin/bash -c "mkdir -p /home/kafka/bin"
kubectl cp strimzi/oauth.sh kafka-client-shell:/home/kafka/bin
kubectl cp strimzi/jwt.sh kafka-client-shell:/home/kafka/bin