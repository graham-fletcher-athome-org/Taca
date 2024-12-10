

resource "github_repository" "repo" {
  count = var.uri == null  && var.managed_environment.git_hub_enabled == true ? 1 : 0
  name        = format("%s-%s",var.name,var.managed_environment.foundation_code)
  visibility = "private"
  
}

locals{
    git_uri = var.uri == null ? format("%s.git",github_repository.repo[0].html_url) : var.uri
}

