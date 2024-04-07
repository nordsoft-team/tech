# uninstall mysql by helm
helm uninstall test-mysql -n test

# delete pv and pvc in order to reuse it
kubectl delete pvc test-mysql-pvc -n test ; kubectl delete pv test-mysql-pv

# apply the pv and pvc definition
kubectl apply -f test-mysql-pv-pvc.yaml -n test

# install mysql by helm
helm install test-mysql bitnami/mysql -n test --set auth.rootPassword=test1234 --set volumePermissions.enabled=true --set primary.persistence.existingClaim=test-mysql-pvc

# check if the pod is ready
kubectl get pods -n test

# get mysql's password
kubectl get secret -n test test-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d

# check if mysql is OK
kubectl run test-mysql-client --rm --tty -i --restart='Never' --image=mysql:8.0 -n test -- mysql -h test-mysql -ptest1234