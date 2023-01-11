<h2 align="center">
<b>Terraform-EKS-Prometheous</b></
</div>

## About ℹ️ 

This repo contains the Terraform project to automate VPC + Elatic Kubernetes Cluster (EKS) deployment on AWS and setting up monitoring via Prometheus and Grafana stack using Helm Charts. 

## Key Componets 🧑‍💻


- **vpc.tf** : For creating Virtual Private Cloud in AWS
- **eks.tf** : For creating EKS Cluster
- **terraform.tfvars** : Terraform variables for VPC (use your own)
- **k8s-config.yaml** : Deployment for our Node App, Internal Service and ServiceMonitor that expose /metrics endpoint to Prometheus 
- **prometheus-node** app : source code for our node application along with Dockerfile to build the image

## Tech Used 💻

- Terraform
- Helm Charts
- Docker
- Kubernetes
- Prometheus
- Grafana
  

## Part 1: Setting up VPC & EKS Custer in AWS ⚒️

Make sure you have [Terraform](https://developer.hashicorp.com/terraform/downloads) installed on your machine and AWS CLI and [Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) configured. Navigate to the project root directory and follow the steps below"
#### Initialize Terraform 
    terraform init

#### Preview Terraform Actions

    terraform plan

#### Apply configuration with variables

    terraform apply -var-file terraform.tfvars

#### Destroy a Single Resource

    terraform destroy -target aws_vpc.myapp-vpc

#### Destroy everything from tf files (clear up AWS resources)

    terraform destroy

#### Show resources and components from current state

    terraform state list

#### Show current state of a specific resource/data

    terraform state show aws_vpc.myapp-vpc    

#### Set avail_zone as custom tf environment variable - before apply

    export TF_VAR_avail_zone="ap-south-1"

#### For debugging:
    
    export TF_LOG=TRACE    

-----

## Part 2: Setting up Promethous + Grafana Monitoring Stack

The folder **prometheus-node** contains a Node.js that utilizes  package to expose metrics on /metrics endpoint and supports histogram, summaries, gauges and counters for the application stats.

Note: A public image for this node app is already created and available as 977977/node-prometheus. If you want to build and push it yourself, navigate to prometheus-node and run the following command:

    docker build -t repo-name/image-name:image-tag .

    docker push repo-name/image-name:image-tag


### Deploy Prometheus Operator Stack

Make sure you have [Helm]() installed on your machine. 

#### Add Helm Chart Repo
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```   
```
helm repo update
```
#### Export EKS Kubeconfig to your environment
```
aws eks update-kubeconfig --name ava-eks-cluster --region ap-south-1
```

#### Create Namespace and install prometheus-grafana stack
```
kubectl create namespace monitoring-prom
```
```
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring-prom

```
```
helm ls -n monitoring-prom
```

#### Check Prometheus stack pods
    kubectl get all -n monitoring-prom

#### Deploy Prometheous-Node Application and let ServiceMonnitor find it to scrap metrics

    kubectl apply -f nginx-deployment-config.yaml


#### Access Prometheus UI
    kubectl port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090 -n monitoring-prom &

### Access Grafana
    kubectl port-forward svc/monitoring-grafana 8080:80 -n monitoring &
    user: admin
    pwd: prom-operator

### Access the application
Go to EC2->LoadBalanancers->DNS. Click the endpoint to access Nginx server

or use:

    kubectl port-forward svc/nodeappp 3000:3000


## Contributions

Contributions are highly welcomed. Please send a Pull Request with suggested changes or open an Issue to get things started! Feel free to tag @sagar-uprety in the issues :)
