# 📘 Terraform Ansible Multi-Tier Student Management System

```{=html}
<p align="center">
```
`<img src="docs/architecture.png" alt="Project Architecture Banner" width="800"/>`{=html}
```{=html}
</p>
```

------------------------------------------------------------------------

## 🚀 Elevator Pitch

A production-style 3-tier highly available cloud architecture deployed
using Terraform (Infrastructure as Code) and Ansible (Configuration
Management) to host a full-stack React + Spring Boot + MySQL Student
Management System on AWS.

------------------------------------------------------------------------

## 🧠 About The Project

This project demonstrates how a real-world enterprise application is
deployed in the cloud using:

-   Infrastructure as Code\
-   Auto Scaling\
-   High Availability across 2 Availability Zones\
-   Internal & Public Load Balancers\
-   Secure network segmentation\
-   CI-ready configuration automation

Instead of manually launching servers, everything is provisioned and
configured automatically.

------------------------------------------------------------------------

## 🎯 Problem It Solves

Most beginner projects deploy apps on a single EC2 instance.

This project demonstrates:

-   Proper 3-Tier Architecture\
-   Separation of Web, App, and Database layers\
-   Secure communication between tiers\
-   Auto scaling & fault tolerance\
-   Production-like networking (NAT, private subnets)

------------------------------------------------------------------------

## ⭐ Core Features

-   ✅ 3-Tier Architecture (Web → App → DB)\
-   ✅ Multi-AZ Deployment\
-   ✅ Auto Scaling Groups (Web & App)\
-   ✅ Public + Internal Application Load Balancers\
-   ✅ Private RDS (Multi-AZ MySQL)\
-   ✅ NAT Gateway for Private Internet Access\
-   ✅ Infrastructure as Code (Terraform)\
-   ✅ Configuration Automation (Ansible)

------------------------------------------------------------------------

## 🛠 Tech Stack

### 🌐 Frontend

-   React\
-   Axios\
-   Vite\
-   Nginx (Reverse Proxy)

### ⚙ Backend

-   Spring Boot\
-   Maven\
-   Java 17\
-   REST APIs

### 🗄 Database

-   Amazon RDS (MySQL Multi-AZ)

### ☁ Infrastructure

-   AWS VPC\
-   Public & Private Subnets\
-   Internet Gateway\
-   NAT Gateway\
-   Application Load Balancers\
-   Auto Scaling Groups\
-   EC2 (Amazon Linux 2023)\
-   S3 (Terraform Remote Backend)\
-   DynamoDB (State Locking)

### 🧰 DevOps Tools

-   Terraform\
-   Ansible\
-   Cloud-Init (User Data)

------------------------------------------------------------------------

## 🏗 Architecture Overview

``` mermaid
flowchart LR

User --> PublicALB

PublicALB --> WebASG1
PublicALB --> WebASG2

WebASG1 --> InternalALB
WebASG2 --> InternalALB

InternalALB --> AppASG1
InternalALB --> AppASG2

AppASG1 --> RDS
AppASG2 --> RDS

subgraph Public Subnets (AZ-a & AZ-b)
PublicALB
WebASG1
WebASG2
end

subgraph Private Subnets (AZ-a & AZ-b)
InternalALB
AppASG1
AppASG2
RDS
end
```

------------------------------------------------------------------------

## 🔄 Application Flow

1.  User accesses Public ALB\
2.  Request forwarded to Web Tier (Nginx + React)\
3.  React calls `/api/*`\
4.  Nginx proxies request to Internal ALB\
5.  Internal ALB routes request to App Tier (Spring Boot)\
6.  App connects to RDS (MySQL)\
7.  Response travels back to User

------------------------------------------------------------------------

## ⚙ Getting Started

### 1️⃣ Clone Repository

``` bash
git clone https://github.com/pranitpotsure/terraform-ansible-multitier.git
cd terraform-ansible-multitier
```

### 2️⃣ Setup Terraform Backend (First Time Only)

``` bash
cd terraform-backend
terraform init
terraform apply
```

Creates: - S3 bucket for state\
- DynamoDB table for locking

### 3️⃣ Deploy Infrastructure

``` bash
cd ../terraform-infra
terraform init
terraform apply
```

Terraform provisions: - VPC\
- Subnets\
- NAT Gateway\
- ALBs\
- Auto Scaling Groups\
- RDS\
- Security Groups

------------------------------------------------------------------------

## ▶ Usage

After deployment:

``` bash
terraform output public_alb_dns
```

Open in browser:

    http://<public_alb_dns>

You can: - Add Students\
- Add Departments\
- Update/Delete records\
- Data persists in RDS

------------------------------------------------------------------------

## 🔐 Security Design

-   RDS in Private Subnet\
-   App Tier in Private Subnet\
-   Internal ALB not exposed to internet\
-   Web Tier exposed via Public ALB only\
-   Database accessible only from App SG\
-   State encrypted in S3\
-   DynamoDB state locking enabled

------------------------------------------------------------------------

## 📂 Project Structure

    terraform-ansible-multitier/
    │
    ├── terraform-backend/
    │   ├── s3.tf
    │   ├── dynamodb.tf
    │
    ├── terraform-infra/
    │   ├── vpc.tf
    │   ├── alb.tf
    │   ├── asg.tf
    │   ├── rds.tf
    │   ├── nat.tf
    │   ├── security-groups.tf
    │
    ├── ansible/
    │   ├── web/
    │   └── app/
    │
    └── project-app/
        ├── ems-frontend/
        └── ems-backend/

------------------------------------------------------------------------

## 🛣 Roadmap

-   [ ] Add HTTPS (ACM + HTTPS Listener)\
-   [ ] Add WAF\
-   [ ] Add CI/CD (GitHub Actions)\
-   [ ] Add CloudWatch Monitoring\
-   [ ] Add Auto Scaling based on Request Count\
-   [ ] Add Terraform modules\
-   [ ] Add Dockerization\
-   [ ] Deploy via EKS

------------------------------------------------------------------------

## 🤝 Contributing

Contributions are welcome!

1.  Fork the repo\
2.  Create a feature branch\
3.  Commit changes\
4.  Open Pull Request

------------------------------------------------------------------------

## 📜 License

This project is licensed under the MIT License.

------------------------------------------------------------------------

## 💡 What This Project Demonstrates

-   Real-world DevOps flow\
-   Cloud-native architecture\
-   Infrastructure as Code best practices\
-   Multi-AZ high availability\
-   Production-ready security model

------------------------------------------------------------------------

## 👤 Author

**Pranit Potsure**

LinkedIn: https://linkedin.com/in/pranit-potsure\
GitHub: https://github.com/pranitpotsure

------------------------------------------------------------------------

⭐ If you like this project, give it a star on GitHub!
