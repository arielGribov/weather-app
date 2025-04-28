export AWS_REGION="us-east-1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export CLUSTER_NAME=$(aws eks list-clusters --region $AWS_REGION --query "clusters[0]" --output text)
export ECR_REGISTRY_BACKEND=$(aws ecr-public describe-repositories --region $AWS_REGION --query "repositories[0].repositoryUri" --output text)
export ECR_REGISTRY_FRONTEND=$(aws ecr-public describe-repositories --region $AWS_REGION --query "repositories[1].repositoryUri" --output text)

aws ecr-public get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME



docker build --platform linux/x86_64 --no-cache -t weather-repository/backend:latest ../backend
docker tag weather-repository/backend:latest $ECR_REGISTRY_BACKEND
docker push $ECR_REGISTRY_BACKEND

docker build --platform linux/x86_64 --no-cache -t weather-repository/frontend:latest ../frontend
docker tag weather-repository/frontend:latest $ECR_REGISTRY_FRONTEND
docker push $ECR_REGISTRY_FRONTEND

kubectl apply -f terraform/kubernetes/backend.yaml
kubectl apply -f terraform/kubernetes/frontend.yaml

kubectl apply -f kubernetes/backend.yaml
kubectl apply -f kubernetes/frontend.yaml

kubectl delete -f kubernetes/backend.yaml
kubectl delete -f kubernetes/frontend.yaml


