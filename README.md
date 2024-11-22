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
```js
function myFunction () {
   return true;
}
```

```mermaid
graph TD
    A@{ img: "https://raw.githubusercontent.com/graham-fletcher-athome/icons/refs/heads/main/bigquery.svg",label: "Image Label", width: 40, height: 40, constraint: "on"};

    B@{ img: "https://raw.githubusercontent.com/graham-fletcher-athome/icons/refs/heads/main/bigquery.svg",label: "Image Label", w: 48, h: 48 };

    A-->B;
```


