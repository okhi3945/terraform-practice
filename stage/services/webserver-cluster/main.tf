provider "aws" {
  region = "ap-northeast-2"
}
module "webserver_cluster" {
 source = "../../../modules/services/webserver-cluster"
 cluster_name = "webservers-stage"
 db_remote_state_bucket = "(YOUR_BUCKET_NAME)"
 db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
}
