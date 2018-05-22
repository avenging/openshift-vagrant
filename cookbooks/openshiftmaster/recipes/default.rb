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

execute 'name' do
  command 'command'
  action :run
end

execute 'chcon-storage' do
  command 'semanage fcontext -a -t container_file_t "/opt/storage(/.*)?"'
  action :run
  not_if 'semanage fcontext -l | grep "/opt/storage(/.*)?"'
end

directory '/opt/storage' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

directory '/opt/storage/pv0001' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

directory '/opt/storage/pv0002' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

template '/etc/ansible/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'bash[openshift-prereq]', :immediately
end

bash 'openshift-prereq' do
  cwd '/opt/openshift-ansible'
  code <<-EOH
    ansible-playbook playbooks/prerequisites.yml 
  EOH
  action :nothing
  notifies :run, 'bash[deploy-openshift]', :immediately
end

bash 'deploy-openshift' do
  cwd '/opt/openshift-ansible'
  code <<-EOH
    ansible-playbook playbooks/deploy_cluster.yml
  EOH
  action :nothing
end

# Can't do this as a hook during install unfortunately
cookbook_file "#{Chef::Config['file_cache_path']}/hostpath.yml" do
  source 'hostpath.yml'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[create-pvs]', :immediately
end

execute 'create-pvs' do
  command "/bin/oc create -f #{Chef::Config['file_cache_path']}/hostpath.yml"
  action :nothing
end

execute 'add-admin' do
  command 'oc adm policy add-cluster-role-to-user cluster-admin admin --config=/etc/origin/master/admin.kubeconfig'
  action :run
end