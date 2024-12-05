provider "github" {
  token = var.managed_environment.pac
  owner = var.github_org
}

resource "github_repository" "repo" {
  count = var.uri == null ? 1 : 0
  name        = var.name
  visibility = "private"
}

locals{
    git_uri = var.uri == null ? format("%s.git",github_repository.repo[0].html_url) : var.uri
}

