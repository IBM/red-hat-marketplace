# Red Hat Marketplace Jumpstart Workshop

 Red Hat Marketplace is a one-stop-shop to find, try, buy, deploy, and manage enterprise applications across an organization’s hybrid IT infrastructure, including on-premises and multicloud environments. Red Hat Marketplace gives developers a streamlined view of software that is certified to work in Kubernetes container environments and minimizes red tape for developer managers.

The goals of this workshop are:

* Familiarize with the best-of-breed toolset to simplify Cloud Native application development on OpenShift.
* Use Red Hat Marketplace to streamline the consumption and usage of containerized software in a hybrid cloud infrastructure.

Enterprises who have started their cloud journey and looking at ways to optimize their developer and operational experience will greatly benefit from this workshop.

## Prerequisites
Required: 
- Working knowledge of containers and container orchestration with Kubernetes.
- Workstation or laptop with latest version Chrome or Firefox.

Desired: 
- Knowledge of Kubernetes extensions and operators.
- Experience with software trials and purchases.

## Agenda
|  |  |
| :--- | :--- |
| [Lecture 1: Introduction](modules/marketplace/rhm-introduction.md) (20 minutes) | What is Red Hat Marketplace? |
| [&nbsp;&nbsp;&nbsp;&nbsp; Demo](modules/marketplace/rhm-introduction.md) (40 minutes) | Explore the features and value of using Marketplace  |
| Break (10 minutes)|  |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: Onboarding account](modules/marketplace/rhm-account-setup.md) (20 minutes)| Account setup |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: Cluster setup](modules/marketplace/rhm-cluster-setup.md) (20 minutes)| Cluster setup |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: Software trials](modules/marketplace/rhm-software-trial.md)(30 minutes)| Consuming certified software. |
| [Lecture 2: Cloud Development Toolset]() (20 minutes)| Cloud native development toolset for OpenShift. |
| Lunch Break (60 minutes)|  |
| [Lecture 3: CodeReady Workspaces]() (20 minutes) | Developer experience with CodeReady Workspaces (CRW) |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: Exploring CodeReady Workspaces](modules/toolset/crw/lab-1/explore-crw.md) (30 minutes) | Development with Codeready workspaces. |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: CRW with Devfiles](modules/toolset/crw/lab-2/crw-defiles.md) (30 minutes) | Customizing Codeready workspaces. |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: Sharing Workspaces](modules/toolset/crw/lab-3/publish-workspaces.md) (20 minutes) | Reuse workspaces across projects. |
| Break (10 minutes)|  |
| [Lecture 4: Runtimes & Stacks]() (20 minutes) | OpenShift Runtimes and Application Stacks |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: S2I & Templates](modules/runtimes/deployment/lab-1/s2i-templates.md) (30 minutes) | 
| [Lecture 5: CI/CD with OpenShift Pipelines]()(20 minutes) | OpenShift Runtimes and Application Stacks |
| [&nbsp;&nbsp;&nbsp;&nbsp; Exercise: Deploy with pipelines](modules/runtimes/exercise-deploy-with-pipelines.md) (30 minutes)| Deploying application with customized stack and pipelines |
| Break (10 minutes)|  |
| [Demo: Distributed tracing](modules/consumption/demo-deploy-elk.md) (20 minutes) | Deploy ELK stack for centralized logging from Marketplace catalog |

## Compatability

This workshop has been tested on the following platforms:
* OpenShift 4.4 on IBM Cloud, OpenShift 4.5 on AWS
* **macOS**: Mojave \(10.14\), Catalina \(10.15\), latest version Chrome & Firefox.

## Credits

* [Oliver Rodriguez](https://github.com/odrodrig)
* [Amy Smathers](https://www.linkedin.com/in/amysmathers/)
