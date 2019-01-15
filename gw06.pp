class { 'ffnord::params':
  router_id => "10.115.10.1",	  # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as => "65115",            # The as of the providing community
  wan_devices => ['eth0'],        # An array of devices which should be in the wan zone

  wmem_default => 87380,          # Define the default socket send buffer
  wmem_max     => 12582912,       # Define the maximum socket send buffer
  rmem_default => 87380,          # Define the default socket recv buffer
  rmem_max     => 12582912,       # Define the maximum socket recv buffer
  
  gw_control_ips => "217.70.197.1 89.27.152.1 138.201.16.163 8.8.8.8", # Define target to ping against for function check

  max_backlog  => 5000,           # Define the maximum packages in buffer
  include_bird4 => false,
  maintenance => 0,

  batman_version => 15,            # B.A.T.M.A.N. adv version
}
# aus https://github.com/ffnord/site-nord/blob/master/site.conf
# und https://github.com/freifunk/icvpn-meta/blob/master/nord
ffnord::mesh { 'mesh_ffcux':
    mesh_name => "Freifunk Cuxhaven"
  , mesh_code => "ffcux"
  , mesh_as => "65115"
  , mesh_mac  => "16:ca:ff:ee:ba:be"
  , vpn_mac  => "16:ca:ff:ee:ba:be"
  , mesh_ipv6 => "fdec:c0f1:afda::/64"
  , mesh_ipv4  => "10.115.0.1/19"	# ipv4 address of mesh device in cidr notation, e.g. 10.35.0.1/19
  , range_ipv4 => "10.115.0.0/18"	# ipv4 range allocated to community, this might be different to
					# the one used in the mesh in cidr notation, e.g. 10.35.0.1/18
  , mesh_mtu     => "1374"
  , mesh_peerings    => "/root/mesh_peerings.yaml"	# path to the local peerings description yaml file

  , fastd_secret => "/root/gw06-fastd-secret.key"	
  , fastd_port   => 10050
  , fastd_peers_git => 'https://github.com/Freifunk-Cuxhaven/ffcux-gw-peers.git'	# this will be pulled automatically during puppet apply

  , dhcp_ranges => ['10.115.10.2 10.115.11.254'] 	# the whole net is 10.71.0.0 - 10.71.63.255 
						# so take one 32rd of this range but don't give out the ip of the gw itself
  , dns_servers => ['10.115.10.1']   		# should be the same as $router_id
}

ffnord::named::zone {
  "ffcux": zone_git => "https://github.com/Freifunk-Cuxhaven/dns_ffcux.git", exclude_meta => 'cuxhaven';
}

class {
  ['ffnord::etckeeper','ffnord::rsyslog']:
}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig']:
     ensure => installed;
}
