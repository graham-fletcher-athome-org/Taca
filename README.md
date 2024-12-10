# Taca

Taca is a minimal set of terraform required to deploy a "managed environemnt" into a GCP org or folder:
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

Taca was origonally envisioned as a basis for deploying GCP foundations, the layer that provides the secruity framework.  It is by design, very simple and low complexity. However, this allows a large range of different foundations, or other services to be built on top of Taca. A managed environemnt can be considered an abstract class. It can be built on to deliver a small foundation, a large secure foundation or a build pipline for a single project.  A managed environment is the underlaying frammework on which we build any of these management layers.

The following sections give:
1. Instructions for a simple deployment of Taca.
2. A full set of documentation for all of the options availible within Taca.
3. A set of sample use-cases and matching configurations.

The final section of this document details how we use Taca to deliver a highly secure foundation to secure GCP to the very highest standards.

## Getting Started - A simple configuration
This section oulines what a simple configuration delivers, and the infrastructure that will be deployed. It then provdes instructions on how to deliver the simple configuration. The simple configuration should always be considered a fist step that will be modified to produce more complex solutions.  Delivering the simple configuration will prove the github integration which is key to more complex deployments.

### Getting Started - The High level architecture of a simple configuration
The simplist Taca configuraion results in the following managed enviornment.

![](./diagrams/HLA.svg)

The following are pre-requisites that should exist within a Github organisation or user account.
1. GCP-GitHUB Plugin

This is required to process access to GitHUB from gcp and to enable branch merge on GitHUB to trigger cloud build.  

2. GitHUB user account

A Git hub user account is required to process automation actions. This should not generally be a user account, but should be an dedicated account. Log onto GitHUB and generate a Peronal Access Token (PAT).  A PAT can be used to access github and authenticate as the assosiated user ID. The PAT should be carefully protected.  Within GCP the PAT is stored in secret manager and is not stored as part of any terrafrom statefile.

3. Taca Repository

The system should have access to this repository. This can either be access to the public repository or to a private clone.

The configuration for this example can be found in the /samples/simple/ directory of the Taca repository.


```
main.tf

/*Create the simple managed environment*/
module "demo_managed_environment" {
  source                    = "github.com/graham-fletcher-athome-org/Taca//managed_environment/?ref=v2"

  /*Root location is the place on gcp where the managed environment should be created. It 
  should be either organizations/xxxxxx  or folders/xxxxx depending on weither the managed 
  environment is being created in the root of an organisation or within a pre existing folder.*/
  root_location             = "<root location>" 

  /*Root name is the name of a bounding folder that will be created to hold all the content 
  of a managed environment.  If no root_name is provided (or it is null) then no bounding 
  folder will be created and the content will be made dir3ctly in the root location*/
  root_name                 = "v2test"

  /*The billing account id that should be used*/
  billing                   = "<billing account id>"

  /*The names of sub folders that should be made within the managed environment*/
  content_folder_names      = []

  /*The integration details for github. The git_identity_token_secret is passed from this 
  inputs in this sample. It only needs to be provided once as it stored in secret manager. 
  Future invocations need not provide this value, it will be retreived from sectret manager.*/
  github_app_intigration_id = <github integration id>
  git_identity_token_secret = var.git_identity_token
}
 
/*Create a builder with a new repository called bootstrap. This will be used to self-host 
the managed environments own configuration*/
module "boot_strap" {
  source              = "github.com/graham-fletcher-athome-org/Taca//builder/?ref=v2"
  managed_environment = module.testing
  name                = "bootstrap"
  depends_on          = [module.testing]
  create_backend      = var.create_backend
}

/*Allocate the bootstrap builder privilages nescessary to self-build*/
module "iam" {
  source = "github.com/graham-fletcher-athome-org/Taca//iam/?ref=v2"

  /*Iam can be applied to "Parent" which is the "root_name" bounding folder or the 
  "root_location" if no bounding folder was requested. Iam can also be applied to any 
  of the content folders by specifying a target with their name.
  target = module.testing.places.parent

  /*An Iam policy is defined as a list of builders and a list of roles.  
  Each builder will be allocated each role.  the iam input is a list of Iam polies.  Iam 
  is always applied as an addadtive function*/
  iam = [{
    builders : [module.boot_strap]
    roles : ["roles/resourcemanager.folderAdmin", "roles/owner"]
  }]
  depends_on = [module.testing, module.boot_strap]
}

/*Terraform does not allow modules to define providers. Therefore the github provider needs to be configured 
at this level with details or the PAT token and organisation to manage. The PAT token can be obtained from 
secret manager, the organisation to manage must be provided*/
data "google_secret_manager_secret_version" "latest_pac" {
  secret     = module.testing.github_identity_token_secret
  project    = module.testing.builder_project
  depends_on = [module.testing]
}

provider "github" {
  token = module.testing.git_hub_enabled ? data.google_secret_manager_secret_version.latest_pac.secret_data : null
  owner = "www.github.com/your_githuborg/"
}
```


Taca will then create:

1. Main folder 

   The main folder to house all componenets. This also acts as a wrapper to apply IAM and organisational policy to the whole system.

2. GCP Project - Builder

   The builder project contains the necessary systems and infrastructure to integrate with GitHUB and run cloud build piplines when trigged by pushes to the attached GitHUB branches.

   1. Secret manager
    
      Secret Manager is used to hold a GitHUB user PAT code. PAT codes are issed by GIT hub and allow the GCP service accounts to authenticate as the automation user account from GitHUB.

   2. Cloud build.

      Could build is enabled to react to changes within the GitHUB configuration repository. Cloud build could be  configured with  many "Builders". In this example a sinlge builder is defined aand configured to process changes in the configuration repository.

      1.  A GCP service account that will be used as the identity when deploying the system.
      2.  A new empty github repositry that will be used to house the "Self configuration"
      3.  A cloud build trigger that runs for pushes to any branch of the new github repository.
      2.  Owner and folderAdmin IAM privilages for the service account on the main folder. These privilages give this builder "Super user" status on the system. Suitable controls should there be placed on access to the service account and to the content of the configuration repository.

          | RISK:  Access to the configuration git hub repostory or to the assositaed service account on GCP would enable super user access to the system being deployed. This could be used for any action including, but not limited to, deployment of infrastrcuture and the extraction or modification of data. |
          |-|

### Getting Started - Installing the simple deployment

1.  Deploy the [GCP GitHUB app](https://github.com/apps/google-cloud-build) into the GCP organisation or user account. 

2.  If using a GitHUB organisation, Create a GITHub user for use by automations.  Alteranativy, a personal account may be used in PoC type deployments.

3.  Create a [PAT code](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for the integration GitHUB account. 

4.  Create a new enty folder on a local machine. Alternativly cloud shell can be used.

5.  Authenticate with GCP.  

6.  Copy the content of the /samples/simple folder to the new folder.

7.  Update the configuration with details or your billing account, gcp location and git hub integration id. 

8.  Init, plan and apply the terraform in the configuration.
``` 
terraform init --upgrade
terraform plan -var git_identity_token=<GitHUB PAT> -var create_backend=true
terraform apply -var git_identity_token=<GitHUB PAT> -var create_backend=true
```
9.  Terraform will deploy all required infrastructure. Re-initialse terraform to move the statefiles from your local machine to the storace on gcp.
```
terraform init
```

10. Terrafrom will have also created a new repository. This should be linked to your current directory.
```
git init
git remote add "origin" http://github.com<new repo>.git
git add --all
git commit -m "new"
git push origin master
```

11. Further changes should be made via an IDE and pushed to the remote repository.  Changes will be deployed via cloud build. Cloud build should show a successfull run that resulted in no changes from the push in step 10. Confirm this build and test a change.  Changing  content_folder_names = ["test"] in main.tf will cause a sub-folder to be deployed. Removing it should revert the deployment to no folders.

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

## Architecting Taca deployments

Taca creates very simple logical architectures.  The simple example, delivers a logical architecture as shown below. The configuration repo can be considered to be controlling the "main folder". Its changes are delivered using the owner and folderAdmin privilages. This means is has effective "super admin" rights over that folder and can make almost any changes. This provides a simple environment for very small PoC type exercises, but is unsuitable for more comple deployemnts.

![](./diagrams/LA_Simple.svg)

### Seperating concerns via multiple builders.

Taca is capable of connecting many repositories to the system and allocating them different IAM permissions. This is a very common use case. Each repository contains configuration that controlls different aspects fo the system.  In the example below,  the configuration repository controlls the base setup, incluing controlling the rights of the other repositories.  Seperate repositories have been defined that control IAM, Project Creation and Applicaion Infrastrcuture.

![](./diagrams/LA_4.svg)

Each repository can now be managed sepreatly. This could involve different team, with different process and approvals cycles.  While each team has freedom to work in any way they wish, thir ability to inflence the system is defined by the IAM that has been alloced to thier repository.

### Seperating concerns via multiple scopes.

![](./diagrams/LA_4scopes.svg)

![](./diagrams/LA_5scopes.svg)

### Seperating concerns via secondary repositories.

### Seperating concerns via multiple systems

### Seperating concerns via secondary repositories.

## Managing configuration outside the scope of the Main Folder (Org level)

## Plugins

### The IAM plugin

### The policy plugin

### The logging plugin

### The sharedVPC plugin

### The VPCSC plugin

### The Private Service plugin 

## Architectural Patterns

### PoC 
#### Actors
#### Indicators and Contra-indicators
#### Logical Architecture
#### System Configuration
#### Resulting GCP and GITHub Configuation

