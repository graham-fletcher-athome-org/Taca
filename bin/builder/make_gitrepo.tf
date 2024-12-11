# 1 "./builder/make_gitrepo.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./builder/make_gitrepo.tf" 2


resource "github_repository" "repo" {
  count      = var.uri == null && var.managed_environment.git_hub_enabled == true ? 1 : 0
  name       = format("%s-%s", var.name, var.managed_environment.foundation_code)
  visibility = "private"

}

locals {
  git_uri = var.uri == null ? format("%s.git", github_repository.repo[0].html_url) : var.uri
}
