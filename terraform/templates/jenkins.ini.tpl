[bastion]
bastion ansible_host=${bastion_public_ip} ansible_user=ubuntu

[jenkins_master]
jenkins-master ansible_host=${jenkins_master_private_ip} ansible_user=ubuntu

[jenkins_worker]
jenkins-worker ansible_host=${jenkins_worker_private_ip} ansible_user=ubuntu

# Managed nodes (KHÔNG gồm bastion)
[jenkins_nodes:children]
jenkins_master
jenkins_worker

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${ssh_key_path}
ansible_ssh_common_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ${ssh_key_path} -W %h:%p ubuntu@${bastion_public_ip}"
