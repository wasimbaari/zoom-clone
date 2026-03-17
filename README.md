🎥 Yoom (Zoom Clone) - Enterprise DevSecOps & Cloud Deployment

![image alt](https://github.com/wasimbaari/zoom-clone/blob/191085f83216093c10b09c5df2d7086b1caa57be/Screenshot%202026-03-17%20203058.png)

📋 Project Overview & Attribution
This project is a fully functional, real-time video conferencing application (Zoom Clone) deployed on a highly available, enterprise-grade cloud infrastructure with a heavy emphasis on security ("Shift-Left" methodology).

This repository represents a collaborative split between Software Development and DevSecOps Engineering:

👨‍💻 Software Development: The core application code, UI/UX, and frontend logic were developed by Adrian Hajdin.

☁️ Cloud & DevSecOps Engineering: The DevSecOps CI/CD pipeline, security scanning integration, cloud infrastructure provisioning, containerization, and GitOps deployment architectures were designed and implemented by Wasim.

⚙️ Tech Stack
Cloud & DevSecOps (Implemented by Me)
Cloud Provider: AWS (Amazon Web Services)

Container Orchestration: Kubernetes (AWS EKS)

Continuous Deployment (GitOps): ArgoCD

Continuous Integration: GitHub Actions

Security Scanning (SCA/SAST): Snyk, SonarCloud, Trivy

Container Registry: Amazon ECR (Elastic Container Registry)

Storage: AWS EBS (Elastic Block Store), StorageClasses

Networking & Ingress: AWS ELB (Elastic Load Balancing)

Security & Auth: AWS IAM

Application & Frontend (Original Developer)
Framework: Next.js, TypeScript

Authentication: Clerk

Video/Audio API: GetStream

Styling: Tailwind CSS, shadcn/ui

![image alt](https://github.com/wasimbaari/zoom-clone/blob/191085f83216093c10b09c5df2d7086b1caa57be/Screenshot%202026-03-17%20133600.png)

🛡️ DevSecOps Pipeline (CI/CD)
The core of this deployment relies on a robust, automated GitHub Actions pipeline that enforces security checks before any code is allowed to reach the infrastructure.

Stage 1: Continuous Integration & Security (The security-and-build Job)
Triggered on every push or Pull Request to the main branch, this job ensures the code is safe to build:

Software Composition Analysis (SCA): Uses Snyk to scan package.json and package-lock.json for known vulnerabilities in open-source dependencies (failing on critical severity).

Static Application Security Testing (SAST): Uses SonarCloud to scan the application source code for bugs, code smells, and security vulnerabilities before compilation.

Docker Build: Authenticates with AWS, dynamically injects required build arguments (Clerk/Stream API keys), and builds the Docker image, tagging it with the unique Git SHA.

Container Vulnerability Scanning: Uses Trivy to scan the compiled Docker image for OS-level and library vulnerabilities (failing the pipeline if 'CRITICAL' vulnerabilities are found).

Artifact Push: Only if all prior security scans pass, the hardened image is pushed to Amazon ECR.

Stage 2: GitOps Manifest Updates (The deploy-gitops Job)
Following the GitOps philosophy, the infrastructure is not updated via direct API calls. Instead, the repository acts as the source of truth.

Manifest Mutation: A shell script uses sed to find and replace the image tag in the Kubernetes deployment manifest (k8s/k8s/deployment.yaml) with the newly built Git SHA.

Automated Commit: A GitHub Actions bot automatically commits the updated manifest back to the repository (using a [skip ci] flag to prevent an infinite loop).

🚀 Infrastructure Deployment (CD)
Once the deployment.yaml is updated in the repository by the CI pipeline, the infrastructure takes over:

AWS EKS Provisioning & Storage
Cluster: The application runs on a managed Amazon Elastic Kubernetes Service (EKS) cluster in the ap-south-2 region.

Persistent Storage: Configured the AWS EBS Container Storage Interface (CSI) driver. Custom gp3 StorageClasses ensure that stateful pods automatically provision the hard drives they need.

ArgoCD (Continuous Deployment)
The Pull Method: ArgoCD is deployed inside the EKS cluster. It continuously polls the Git repository.

Automated Sync: When ArgoCD detects the new image tag committed by the GitHub Actions bot, it flags the cluster as "Out of Sync." It automatically applies the changes to the EKS cluster, pulling the new image from ECR and performing a rolling update with zero downtime.

![image alt](https://github.com/wasimbaari/zoom-clone/blob/191085f83216093c10b09c5df2d7086b1caa57be/Screenshot%202026-03-17%20151711.png)

Networking
Load Balancing: The Kubernetes Service is exposed to the internet via an AWS Application Load Balancer (ELB), securely routing traffic directly to the Next.js pods.

🔋 Application Features
Secure Authentication: User login and registration powered by Clerk.

Real-Time Video/Audio: High-fidelity meeting rooms, screen sharing, and recording powered by Stream.

Meeting Management: Schedule future meetings, view past meeting logs, and manage individual participant permissions (mute, pin, block).

Personal Rooms: Unique meeting links for instant, ad-hoc conferencing.

![image alt](https://github.com/wasimbaari/zoom-clone/blob/191085f83216093c10b09c5df2d7086b1caa57be/Screenshot%202026-03-17%20155529.png)

🤸 Local Development Setup
If you wish to run the application locally for development purposes:

1. Clone the repository

Bash
git clone https://github.com/adrianhajdin/zoom-clone.git
cd zoom-clone
2. Install dependencies

Bash
npm install
3. Set Up Environment Variables
Create a .env.local file in the root directory and add your Clerk and GetStream API keys:

Code snippet
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up

NEXT_PUBLIC_STREAM_API_KEY=
STREAM_SECRET_KEY=
4. Run the development server

Bash
npm run dev
Open http://localhost:3000 in your browser.

![image alt](https://github.com/wasimbaari/zoom-clone/blob/191085f83216093c10b09c5df2d7086b1caa57be/Screenshot%202026-03-17%20203058.png)
