# SCAFFOLD

Scaffold is a minimal set of terraform required to deploy the following objets into a GCP org or folder:
1. An optional folder to contain everything else
2. A project with cloud build enabled
3. A link to github
4. Any number of folders
5. Any number of "builders" where a builder is:
    1. A service account
    2. IAM that allows the service account to do things in the folders
    3. A cloud build trigger that activates when a commit is made to a 
       specified branch on a github repository. Where the resulting invocation
       uses the builders service account.

Scaffold was origonally envisioned as a basis for deploying GCP foundations, the layer that provides the secruity framework.  It is by design, very simple and low complexity. However, this allows a large range of different foundations, or other services to be built on top of scaffold. 

The following sections give:
1. Instructions for a simple deployment of scaffold.
2. A full set of documentation for all of the options availible within scaffold.
3. A set of sample use-cases and matching configurations.

The final section of this document details how we use scaffold to deliver a highly secure foundation to secure GCP to the very highest standards.

## Getting Started - A simple configuration
This section oulines what a simple configuration delivers, and the infrastructure that will be deployed. It then provdes instructions on how to deliver the simple configuration. The simple configuration should always be considered a fist step that will be modified to produce more complex solutions.  Delivering the simple configuration will prove the github integration which is key to more complex deployments.

### Getting Started - The High level architecture of a simple configuration
The simplist scaffold configuraion results in the following deployment.

![](./diagrams/HLA.svg)

The following are pre-requisites that should exist within a Github organisation or user account.
1. GCP-GitHUB Plugin

This is required to process access to GitHUB from gcp and to enable branch merge on GitHUB to trigger cloud build.  

2. GitHUB user account

A Git hub user account is required to process automation actions. This should not generally be a user account, but should be an dedicated account.

3. Scaffold Repository

The system should have access to this repository. This can either be access to the public repository or to a private clone.

4. Configuration repository.

The configuration repository controlls the systems deployed by scaffold.  It may also contain other terraform that should be deployed by the same build mechanism. The sample cofiguration repository should contain a file, main.tf that holds the scaffold configutaion. Also required is the cloud build configuration in a file, Cloudbuild.yaml. Simple versions of the two viles are shown below. A more complete sample can be copied from the samples/simple directory in this repository.

```
main.tf

module "secure" {
  source = "https://github.com/<LOCATION OF SCAFFOLD REPO>.rep"
  github_app_intigration_id = null
  billing = "<YOUR BILLING ACCOUNT ID>"
  root_location = "organizations/<WHERE THE SYSTEM SHOULD BE SHOULD BE SEPLOYED>"
  root_name = "BIP" 
  bootstrap_repo = "https://github.com/graham-fletcher-athome-org/<LOCATION OF THE CONFIGURATION REPO>" 
  content_folder_names = []
  builders = [] 
}
```


```
Cloudbuild.yaml

steps:

# Step 2: Initialize Terraform
- name: "hashicorp/terraform:latest"
  entrypoint: "terraform"
  args: ["init"]

# Step 3: Validate Terraform configuration
- name: "hashicorp/terraform:latest"
  entrypoint: "terraform"
  args: ["validate"]

# Step 4: Plan Terraform changes
- name: "hashicorp/terraform:latest"
  entrypoint: "terraform"
  args: ["plan", "-out=tfplan"]

# Step 5: Apply Terraform changes
- name: "hashicorp/terraform:latest"
  entrypoint: "terraform"
  args: ["apply", "-auto-approve", "tfplan"]
 
```



Scaffold will then create:

1. Main folder 

   The main folder to house all componenets. This also acts as a wrapper to apply IAM and organisational policy to the whole system.

2. GCP Project - Builder

   The builder project contains the necessary systems and infrastructure to integrate with GitHUB and run cloud build piplines when trigged by pushes to the attached GitHUB branches.

   1. Secret manager
    
      Secret Manager is used to hold a GitHUB user PAC code. PAC codes are issed by GIT hub and allow the GCP service accounts to authenticate as the automation user account from GitHUB.

   2. Cloud build.

      Could build is enabled to react to changes within the GitHUB configuration repository. Cloud build could be  configured with  many "Builders". In this example a sinlge builder is defined aand configured to process changes in the configuration repository.

      1.  A GCP service account that will be used as the identity when deploying the system.
      2.  Owner and folderAdmin IAM privilages for the service account on the main folder. These privilages de   give this builder "Super user" status on the system. Suitable controls should there be placed on access to the service account and to the content of the configuration repository.

          | RISK:  Access to the configuration git hub repostory or to the assositaed service account on GCP would enable super user access to the system being deployed. This could be used for any action including, but not limited to, deployment of infrastrcuture and the extraction or modification of data. |
          |-|

### Getting Started - Installing the simple deployment

1.  Deploy the [GCP GitHUB app](https://github.com/apps/google-cloud-build) into the GCP organisation or user account. 

2.  If using a GitHUB organisation, Create a GITHub user for use by automations.  Alteranativy, a personal account may be used in PoC type deployments.

3.  Create a [PAC code](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for the integration GitHUB account. 

4.  Create a configuration repository. Copy the content of samples/simple sub directory into the new repository

5.  Authenticate with GCP.  Open the console command line.

6.  Clone your new configuration repository.

7.  Update the configuration with details or your billing account, repo locations and the gcp location in which the system should be deployed. Push all changes back to your configuration repository.

8.  Init, plan and apply the terraform in the configuration.

9.  Terraform will deploy an initial folder, and build project. In the build project, locate secret manager.  Secret manager will contain a single secret. Add a new version of this secret that contains the PAC code from step 3.

10.  Update the configuration to include the  app integration id for the app installed into GITHub in step 1 and the location of the configuration repository in GITHub.

11.  Re-init, plan and apply the terraform.  The system should create the "Builder" fro the configuration repostory.

12.  Re-init the terrafrom to copy the terraform state from your terminal to a storage location in the build project.

13.  Terrafrom will have created a new file, backend.tf.  Push this file along with changes to main.tf back to the remote confiuration repository.  Do not push and other terraform files such as the state files.

14. Delete the local version of the repository.  Further changes should be made via an IDE and pushed to the remote repository.  Changes will be deployed via cloud build. Cloud build should show a successfull run that resulted in no changes from the push in step 13. Confirm this build and test a change.  Changing  content_folder_names = ["test"] in main.tf will cause a sub-folder to be deployed. Removing it should revert the deployment to no folders.

Additional terraform can be added to the configuration repository and will be actioned with updates to the system.  Infrastruture applied here will be deployed using a super user level permissions.  Development and deployemnt should be restriced to systems that require this level of access and be completed by suitibly tained and trusted staff.

Refer to later sections in this document for design approaches and instructions for creating additional builders with lower privilage levels for application and service deploymet.

### Getting Started - Deleting the simple deployment

1.  Remove any additional infrastrcutre that has been deployed, either by the addition of other builders or by adding terrafrom to the configuration repository.

2. Authenticate with GCP.  Open the console command line.

3.  Clone the configuration repository.

4. Init the terraform

5. Delete the file backend.tf

6. Re-init the terrafrom.  This will move the terraform statefiles out of gcp and onto your teramal.

7. Destory the terraform

## Architecting scaffold deployments

Scaffold creates very simple logical architectures.  The simple example, delivers a logical architecture as shown below. The configuration repo can be considered to be controlling the "main folder". Its changes are delivered using the owner and folderAdmin privilages. This means is has effective "super admin" rights over that folder and can make almost any changes. This provides a simple environment for very small PoC type exercises, but is unsuitable for more comple deployemnts.

![](./diagrams/LA_Simple.svg)

### Seperating concerns via multiple builders.

Scaffold is capable of connecting many repositories to the system and allocating them different IAM permissions. This is a very common use case. Each repository contains configuration that controlls different aspects fo the system.  In the example below,  the configuration repository controlls the base setup, incluing controlling the rights of the other repositories.  Seperate repositories have been defined that control IAM, Project Creation and Applicaion Infrastrcuture.

![](./diagrams/LA_4.svg)

Each repository can now be managed sepreatly. This could involve different team, with different process and approvals cycles.  While each team has freedom to work in any way they wish, thir ability to inflence the system is defined by the IAM that has been alloced to thier repository.

### Seperating concerns via multiple scopes.

### Seperating concerns via secondary repositories.

### Seperating concerns via multiple systems

### Seperating concerns via secondary repositories.

## Plugins

### The IAM plugin

### The policy plugin

### The logging plugin

### The sharedVPC plugin

### The VPCSC plugin

### The Private Service plugin 


