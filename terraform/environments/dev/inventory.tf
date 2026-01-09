################################
# Generate Ansible Inventory
################################
resource "local_file" "jenkins_inventory" {
  filename = "${path.root}/../../../ansible/inventories/jenkins.ini"

  content = templatefile(
    "${path.root}/../../templates/jenkins.ini.tpl",
    {
      bastion_public_ip         = module.bastion.public_ip
      jenkins_master_private_ip = module.jenkins_master.private_ip
      jenkins_worker_private_ip = module.jenkins_worker.private_ip
      ssh_key_path              = abspath("${path.root}/../../../key_pair/lab-key")
    }
  )
}
