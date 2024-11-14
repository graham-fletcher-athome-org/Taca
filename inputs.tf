variable "root_location" {
  type    = string
  default = "folders/514409708910"
}

variable "root_name" {
  type    = string
  default = "testfoundation"
  nullable = true
}

variable "billing" {
    type = string
    default = "0119B9-36A410-C6B39B"
}

variable "content_folder_names" {
    type = list(string)
    default = ["content","Artefact_repo"]
}

variable "builders" {
    type = list(object({
        name:string
        sa_name :string
        repo :string
        branch :string
        filename :string
        folder_ids : map(any)
        iam : list(object({
            content_folder_name : string,
            roles : list(string)
            }))
    }))

    default = [
        {
            name: "default1"
            sa_name = "builderbob"
            repo = "https://github.com/graham-fletcher-athome-org/demoapp.git"
            branch = "main"
            filename = "cloudbuild.yaml"
            folder_ids = {
                content = "content"
            }
            iam = [
                {
                    content_folder_name="content",
                    roles=["roles/owner"]
                }
            ]
        },

        {
            name: "artefact-repo"
            sa_name = "builderar"
            repo = "https://github.com/graham-fletcher-athome-org/artefact_repo.git"
            branch = "infra"
            filename = "infra/cloudbuild.yaml"
            folder_ids = {
                tl_folder = "Artefact_repo"
            }
            iam = [
                {
                    content_folder_name="Artefact_repo",
                    roles=["roles/owner"]
                }
            ]
        },

        {
            name: "artefact-repo-application"
            sa_name = "builderar"
            repo = "https://github.com/graham-fletcher-athome-org/artefact_repo.git"
            branch = "main"
            filename = "application/cloudbuild.yaml"
            folder_ids = {
                tl_folder = "Artefact_repo"
            }
            iam = [
                {
                    content_folder_name="Artefact_repo",
                    roles=["roles/editor"]
                }
            ]
        }

        
        
    ] 
    
}

variable "github_connection_id"{
    type = string
    default = null
    nullable = true
}

variable "github_app_intilation_id"{
    type = number
    default=null
    nullable = true
}

variable "default_location"{
    type = string
    default = "europe-west2"
}

variable "location_log_buckets"{
    type = string
    default = null
}

variable "location_ba_buckets"{
    type = string
    default = null
}

variable "location_build_triggers"{
    type = string
    default = null
}

