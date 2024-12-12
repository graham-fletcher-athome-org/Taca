module "iam_mgr" {
    source = "github.com/graham-fletcher-athome-org/Taca//bin/plugins/iam_manager?ref=iam_mgr"
    managed_environment = module.testing
    iam_configs = ["./iam_config.json"]
}

output "bob" {
    value = module.iam_mgr
}