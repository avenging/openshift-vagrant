Sometimes part way through deployment these services need re-starting. Typically after updates to NetworkManager, dnsmasq and the re-start of journald

systemctl restart dbus
systemctl restart NetworkManager
systemctl restart systemd-logind
systemctl restart dnsmasq

Add the admin user to cluster admins:
oadm policy add-cluster-role-to-user cluster-admin admin --config=/etc/origin/master/admin.kubeconfig

A directory needs creating on the host for hostpath storage
mkdir /opt/pv0001
chcon -R unconfined_u:object_r:svirt_sandbox_file_t:s0 /opt/pv0001
oc create -f /root/hostpath.yml