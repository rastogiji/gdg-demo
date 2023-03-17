#! /bin/bash
gcloud beta container --project "searce-cloud-consultants" clusters create "demo-cluster" \
--no-enable-basic-auth --cluster-version "1.24.9-gke.3200" --zone "us-central1-c" --release-channel "regular" --machine-type "e2-medium" \
--image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "50" --metadata disable-legacy-endpoints=true \
--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write",\
"https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol",\
"https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
--spot --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias \
--network "projects/searce-cloud-consultants/global/networks/default" \
--subnetwork "projects/searce-cloud-consultants/regions/us-central1/subnetworks/default" \
--no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-network-policy \
--no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
--enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
--workload-pool "searce-cloud-consultants.svc.id.goog" --enable-shielded-nodes --enable-image-streaming \
--node-locations "us-central1-c"

gcloud container clusters get-credentials demo-cluster --zone us-central1-c --project searce-cloud-consultants

istioctl install --set profile=demo -y

helm repo add kiali https://kiali.org/helm-charts

helm install kiali-server kiali/kiali-server --namespace istio-system

kubectl apply -f prometheus.yaml

kubectl label namespace default istio-injection=enabled

kubectl apply -n argocd -f argocd.yaml

kubectl apply -n argo -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
# kubectl apply -f istio-fleetman/_course_files/x86_amd64/1-Telemetry/1-istio-init.yaml

# kubectl apply -f istio-fleetman/_course_files/x86_amd64/1-Telemetry/2-istio-minikube.yaml

# kubectl apply -f istio-fleetman/_course_files/x86_amd64/1-Telemetry/3-kiali-secret.yaml 

# kubectl apply -f istio-fleetman/_course_files/x86_amd64/1-Telemetry/4-label-default-namespace.yaml

# kubectl apply -f istio-fleetman/_course_files/x86_amd64/1-Telemetry/5-application-no-istio.yaml






