readonly KUBE_NS=intruder

echo "Checking cluster status"
sudo minikube status
[ $? -ne 0 ] && sudo minikube start --vm-driver=none


kubectl create -f registry.yml

echo "Waiting for registry be running"
exit_code=1
while [ $exit_code -ne 0 ]; do
 kubectl get po --all-namespaces | grep registry | grep Running
 exit_code=$?
 sleep 2s;
done


kubectl get po -n kube-system

docker tag intruder/kube_app_v2:0.0.1 127.0.0.1:5000/intruder/kube_app_v2:0.0.1
docker tag intruder/kube_app_v2:0.0.1 127.0.0.1:5000/intruder/kube_app_v2:0.0.1

docker push 127.0.0.1:5000/intruder/kube_app_v1:0.0.1
docker push 127.0.0.1:5000/intruder/kube_app_v2:0.0.1


kubectl create -f all.yml && sleep 10s

kubectl config set-context $(kubectl config current-context) --namespace=$KUBE_NS

echo "============================================="
kubectl get po,ep,svc --all-namespaces

#sudo minikube service app-v1 -n intruder --url
echo
echo "Node js api running at $(sudo minikube service app-v1 -n intruder --url)"
echo "Node js api running at 127.0.0.1:8001/api/v1/namespaces/intruder/services/app-v1:80/proxy/"