kubectl create secret tls tls-keys --cert=keycloak.crt --key=keycloak.key -n epso14

kubectl create -f keycloak/keycloak.yaml

kubectl wait --for=condition=Available --timeout=600s deployment.apps/keycloak
