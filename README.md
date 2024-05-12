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

**Requirements**
- [Node.js - Official Node.js® download page](https://nodejs.org/en/download)
- [Docker Engine - Official Docker installation guide](https://docs.docker.com/engine/install)
- [AWS CLI - Official AWS CLI installation page](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform - Official Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

**Clone the project**
```bash
$ git clone https://github.com/wladimirgrf/forum.git && cd forum
```

**Install the Project dependencies**
```bash
$ npm install
```

**Environment Variables**
```bash
$ cp .env.example .env
```

**Set access credentials**
```bash
aws configure
```

## 🖥️ Local Environment

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

## 🚀 Deployment
We need to set up the resources for Terraform state synchronization.

**Create the Bucket**
```bash
aws s3api create-bucket --bucket forum-tf-state --region us-east-1
```

>[!CAUTION]
>S3 requires unique names for buckets.

**Create the DynamoDB table for state lock**
```bash
aws dynamodb create-table \
    --table-name forum-tf-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --region us-east-1
```

**Providers Initialization**
```bash
npm run infra:prep
```

**(OPTIONAL) Check the Execution Plan**
```bash
npm run infra:plan
```

**Deploy the entire Infrastructure**
```bash
npm run infra:up
```

>[!NOTE]
>During the planning or deployment process, Terraform will request two important variables for setting up the resources: the username and password for the database access. These details will be used to securely connect the application to the database. The entire deployment process takes about 10 minutes.

## 🤝 Contributing

**Fork the repository and clone your fork**

```bash
$ git clone fork-url && cd rentx
```

**Create a branch for your edits**
```bash
$ git checkout -b new-feature
```

**Make the commit with your changes**
```bash
$ git commit -m 'feat: New feature'
```

**Send the code to your remote branch**
```bash
$ git push origin new-feature
```

Create a pull request with your version. <br>
After your pull request is merged, you can delete your branch.


## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.