# Notes on k3s

k3s kubectl delete ns kubernetes-dashboard
k3s kubectl delete clusterrolebinding kubernetes-dashboard
k3s kubectl delete clusterrole kubernetes-dashboard
k3s kubectl delete -f /root/kube_app_defs/dashboard.admin-user.yml -f /root/kube_app_defs/dashboard.admin-user-role.yml


k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
k3s kubectl create -f /root/kube_app_defs/dashboard.admin-user.yml -f /root/kube_app_defs/dashboard.admin-user-role.yml

kubectl port-forward deployment/mongo 28015:27017

kubectl port-forward deployment/kubernetes-dashboard 80:80 -n kubernetes-dashboard



# from web

kubectl get all -n kubernetes-dashboard

kubectl edit service/kubernetes-dashboard -n kubernetes-dashboard

```
# Updated the type to NodePort in the service.
 ports:
 port: 443 
 protocol: TCP
 targetPort: 8443
 selector:
 k8s-app: kubernetes-dashboard
 sessionAffinity: None
 type: NodePort 
```

Find the name of each pod that step two in the previous section created using the kubectl get pods command enumerating all pods across all namespaces with the --all-namespaces parameter.

You should see a pod that starts with kubernetes-dashboard.

kubectl get pods --all-namespaces

Whenever you modify the service type, you must delete the pod. Once deleted, Kubernetes will create a new one for you with the updated service type to access the entire network.

kubectl delete pod kubernetes-dashboard-78c79f97b4-gjr2l -n kubernetes-dashboard

Verify the kubernetes-dashboard service has the correct type by running the kubectl get svc --all-namespace command. You will now notice that the service type has changed to NodePort, and the service exposes the pod’s internal TCP port 30265 using the outside TCP port of 443.

Now, create a service account using kubectl create serviceaccount in the kubernetes-dashboard namespace. You’ll need this service account to authenticate any process or application inside a container that resides within the pod.

kubectl create serviceaccount dashboard -n kubernetes-dashboard



Open your favorite browser and navigate to https://kuberntes-master-node:NodePort/#/login to access the Kubernetes dashboard.

https://192.168.65.22:32401/#/login



https://kubernetes.github.io/ingress-nginx/deploy/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml

kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
ingress-nginx 


GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml



openssl req \
-x509 -newkey rsa:4096 -sha256 -nodes \
-keyout tls.key -out tls.crt \
-subj "/CN=ceres-b.localdomain" -days 365

kubectl create secret tls ceres-b-localdomain-tls \
--cert=tls.crt \
--key=tls.key

secret/ceres-b-localdomain-tls created



apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
      - ceres-b.localdomain
    secretName: ceres-b-localdomain-tls
  rules:
  - host: ceres-b.localdomain
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443
 





