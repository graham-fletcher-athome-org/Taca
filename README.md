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

The configuration repository controlls the systems deployed by scaffold.  It may also contain other terraform that should be deployed by the same build mechanism.

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
      2.  Owner and folderAdmin IAM privilages for the service account on the main folder. These privilages de give this builder "Super user" status on the system. Suitable controls should there be placed on access to the service account and to the content of the configuration repository.

      `RISK:  Access to the configuration git hub repostory or to the assositaed service account on GCP would enable super user access to the system being deployed. This could be used for any action including, but not limited to, deployment of infrastrcuture and the extraction or modification of data.` 

