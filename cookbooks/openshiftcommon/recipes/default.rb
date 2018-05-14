packages = %w(
  yum-utils
  git
  net-tools
  bind-utils
  iptables-services
  bridge-utils
  bash-completion
  kexec-tools
  sos
  psacct
  epel-release
  ansible
  pyOpenSSL
  docker
)

execute 'updatesystem' do
  command 'yum -y update'
  not_if "yum check-update"
end

for pack in packages do
  package pack do
    action :install
  end  
end

execute 'disable-epel' do
  command 'yum-config-manager --disable epel'
  not_if "yum repolist disabled | grep 'epel/x86_64'"
end
