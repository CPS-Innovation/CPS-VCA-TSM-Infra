module "tags" {
  source        = "git::https://github.com/CPS-Innovation/CPS-TF-Module-Common-Tags.git?ref=main"
  pipeline_name = var.pipeline_name
  repo_name     = var.repo_name
  branch_name   = var.branch_name
  repo_uri      = var.repo_uri
  date          = var.date
  environment   = var.environment
}