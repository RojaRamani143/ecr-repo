# ECR-ECS Simple Web App

A beginner-friendly static website for practicing Docker, Amazon ECR, and Amazon ECS.

## Project files

```text
ecr-ecs-simple-web/
├── index.html
├── Dockerfile
├── .dockerignore
└── README.md
```

## 1. Run locally with Docker

Build the image:

```bash
docker build -t ecr-ecs-web .
```

Run the container:

```bash
docker run -d --name ecr-ecs-web -p 8080:80 ecr-ecs-web
```

Open `http://localhost:8080` in your browser.

Check the container and logs:

```bash
docker ps
docker logs ecr-ecs-web
```

Stop and remove it:

```bash
docker rm -f ecr-ecs-web
```

## 2. Push the project to GitHub

Create an empty GitHub repository, then run these commands from this project directory:

```bash
git init
git add .
git commit -m "Add simple ECR ECS practice web app"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Replace the remote URL with your own GitHub repository URL.

## 3. Clone it on your EC2 / practice machine

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY
docker build -t ecr-ecs-web .
```

## 4. Push the image to Amazon ECR

Prerequisites: AWS CLI configured with an IAM identity that can create/use ECR repositories and push images. Replace the placeholders below.

```bash
aws sts get-caller-identity
aws ecr create-repository --repository-name ecr-ecs-web --region YOUR_AWS_REGION
```

Log Docker in to ECR:

```bash
aws ecr get-login-password --region YOUR_AWS_REGION | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.YOUR_AWS_REGION.amazonaws.com
```

Tag and push:

```bash
docker tag ecr-ecs-web:latest YOUR_ACCOUNT_ID.dkr.ecr.YOUR_AWS_REGION.amazonaws.com/ecr-ecs-web:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.YOUR_AWS_REGION.amazonaws.com/ecr-ecs-web:latest
```

Confirm the image is in ECR:

```bash
aws ecr list-images --repository-name ecr-ecs-web --region YOUR_AWS_REGION
```

## 5. Deploy with Amazon ECS

In the AWS Console:

1. Open **Amazon ECS** and create a **cluster**. For a beginner lab, choose the AWS Fargate option if available in your region.
2. Create a **task definition** using the Fargate launch type / `awsvpc` network mode.
3. Add a container using your ECR image URI:
   `YOUR_ACCOUNT_ID.dkr.ecr.YOUR_AWS_REGION.amazonaws.com/ecr-ecs-web:latest`
4. Set the container port to **80**.
5. Create a **service** from the task definition.
6. Choose a VPC and subnets. For a public test, use a public subnet and enable a public IP, then configure the task security group to allow inbound TCP **80** from your IP address.
7. Wait for the task to become **RUNNING**. Open the task's public IP in a browser.

For a production setup, use an Application Load Balancer, private subnets, least-privilege IAM roles, and appropriate network controls rather than exposing tasks directly.

## Important notes

- Port **80** is the container port. The local Docker test maps host port `8080` to container port `80`.
- ECS task execution role permissions are needed so ECS can pull the private ECR image and write logs.
- Remember to delete the ECS service, cluster, and ECR repository when finished if you no longer need them, to avoid ongoing AWS charges.
