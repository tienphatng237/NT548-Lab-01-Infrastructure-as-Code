[bastion]
bastion-node ansible_host=${bastion_public_ip} ansible_user=ubuntu

[jenkins_master]
jenkins-master ansible_host=${jenkins_master_private_ip} ansible_user=ubuntu

[jenkins_worker]
jenkins-worker ansible_host=${jenkins_worker_private_ip} ansible_user=ubuntu

[jenkins_nodes:children]
jenkins_master
jenkins_worker

[bastion:vars]
ansible_ssh_private_key_file=${ssh_key_path}

[jenkins_nodes:vars]
ansible_ssh_private_key_file=${ssh_key_path}
ansible_ssh_common_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ${ssh_key_path} -W %h:%p ubuntu@${bastion_public_ip}"
