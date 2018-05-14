package 'httpd-tools' do
  action :install
end

git '/opt/openshift-ansible' do
  action :checkout
  repository 'https://github.com/openshift/openshift-ansible'
  revision 'release-3.9'
  user 'root'
  group 'root'
end

template '/etc/ansible/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

bash 'prereq' do
  cwd '/opt/openshift-ansible'
  code <<-EOH
    echo #{node[:ipaddress]} `hostname` >> /etc/hosts
    ansible-playbook playbooks/prerequisites.yml 
  EOH
end

bash 'deply' do
  cwd '/opt/openshift-ansible'
  code <<-EOH
    ansible-playbook playbooks/deploy_cluster.yml
  EOH
end
