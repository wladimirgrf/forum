# forum api

<p float="left">
  <img alt="terraform" src=".github/assets/terraform.svg" height="50"/> &nbsp;
  <img alt="aws" src=".github/assets/aws.svg" height="50" /> &nbsp;
  <img alt="nestjs" src=".github/assets/nestjs.svg" height="50"/> &nbsp;
  <img alt="typescript" src=".github/assets/typescript.svg" height="50"/> &nbsp;
  <img alt="vitest" src=".github/assets/vitest.svg" height="50"/> &nbsp;
  <img alt="prisma" src=".github/assets/prisma.svg" height="50"/> &nbsp;
  <img alt="docker" src=".github/assets/docker.svg" height="50"/> &nbsp;
  <img alt="swagger" src=".github/assets/swagger.svg" height="50"/> 
</p>

## 📃 Overview
This project is a RESTful API designed for forum management. The use cases are centered around the fundamental elements of __questions__, __answers__, and __comments__. The entire application is built following SOLID principles, clean architecture, and domain event patterns.


## ⚙️ Services
![](.github/assets/api-docs.png)

## 🧱 ERM
![](.github/assets/diagram.png)

## ▶️ Getting started

### ✅ Requirements

#### ☁️ AWS cli
The resources for this project are deployed on AWS, so installing the CLI is crucial for the initial setup (_key resources and Terraform state synchronization_): 

[Install or update to the latest version of the AWS CLI - AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

#### 🔰 Node.js
To compile or run the application, it is essential to have Node.js installed: 

[Node.js — Download Node.js®](https://nodejs.org/en/download)

#### 🐳 Docker
I use Docker Compose to launch the required instances for local and testing environments: 

[Install Docker Engine | Docker Docs](https://docs.docker.com/engine/install)


#### 🌏 Terraform
In this project, I used the Infrastructure as Code (_IaC_) approach. The framework chosen to handle everything is Terraform: 

[Install Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

#### 🛠️ Setup

##### Clone the project
```bash
$ git clone https://github.com/wladimirgrf/forum.git && cd forum
```

##### Install the Project dependencies
```bash
$ npm install
```

##### Environment Variables
```bash
$ cp .env.example .env
```

### 🖥️ Local Environment

**Run the containers**
```bash
$ docker-compose up -d
```

**Migrations**
```bash
$ npm run db:migrate
```

**Launch the Application**
```bash
$ npm run start:dev
```
>[!NOTE]
>The API will be launched at `http://localhost:3333/` <br>
>Documentation available at `http://localhost:3333/docs`

### 🚀 Deployment


Next, we need to set up the resources for Terraform state synchronization.

**Create the Bucket**
```bash
aws s3api create-bucket --bucket forum-tf-state --region us-east-1
```