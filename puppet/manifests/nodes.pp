node basenode {

  exec { "yum_update":
    command => "/bin/yum -y update",
    timeout => '600'
  }
  

  # Ensure the above command runs before we attempt
  # to install any package in other manifests
  #Exec["yum_update"] -> Package<| |>

  $base_packages = [
                     "git",
                     "gcc",
                     "make",
                     "python-devel",
                     "openssl-devel",
                     "kernel-devel",
                     "graphviz",
                     "kernel-debug-devel",
                     "autoconf",
                     "automake",
                     "rpm-build",
                     "redhat-rpm-config",
                     "libtool",
                     "python-six",
                     "checkpolicy",
                     "selinux-policy-devel",
                     "wget",
                     "redhat-lsb-core",
                     "java-1.8.0-openjdk",
                     "tcpdump",
                     "traceroute",
                   ]

  package { $base_packages:
    ensure => installed,
  }

  file { '/rpmbuild/':
    ensure => 'directory',
  }

  file { '/rpmbuild/SOURCES':
    ensure => 'directory',
  }

  file { '/rpmbuild/RPMS':
    ensure => 'directory',
  }
  file { '/rpmbuild/BUILD':
    ensure => 'directory',
  }
  file { '/rpmbuild/BUILDROOT':
    ensure => 'directory',
  }
  file { '/rpmbuild/SPECS':
    ensure => 'directory',
  }
  file { '/rpmbuild/SRPMS':
    ensure => 'directory',
  }


  exec { "download_ovs":
    #command => "/usr/bin/wget https://github.com/openvswitch/ovs/archive/v2.3.tar.gz -O /root/ovs.tar.gz",
    #command => "/usr/bin/wget http://openvswitch.org/releases/openvswitch-2.3.3.tar.gz -O /root/ovs.tar.gz",
    #command => "/usr/bin/wget http://openvswitch.org/releases/openvswitch-2.5.0.tar.gz -O /root/ovs.tar.gz",
    #command => "/usr/bin/wget http://openvswitch.org/releases/openvswitch-2.4.0.tar.gz -O /root/ovs.tar.gz",
    command => "/usr/bin/wget http://openvswitch.org/releases/openvswitch-2.6.1.tar.gz -O /rpmbuild/SOURCES/openvswitch-2.6.1.tar.gz",
    cwd     => "/rpmbuild/SOURCES",
    creates => "/rpmbuild/SOURCES/openvswitch-2.6.1.tar.gz",
  }

  exec { "extract_ovs":
    command => "/bin/tar xvfz openvswitch-2.6.1.tar.gz",
    cwd     => "/rpmbuild/SOURCES",
    require => [
                  Exec["download_ovs"],
               ],
    creates => "/rpmbuild/SOURCES/openvswitch-2.6.1/rhel/openvswitch.spec",
  }

  file { "/rpmbuild/SPECS/openvswitch.spec":
    ensure => "present",
    source => "file:////rpmbuild/SOURCES/openvswitch-2.6.1/rhel/openvswitch.spec",
    require => [
                  Exec["extract_ovs"],
               ],
  }

  file { "/rpmbuild/SOURCES/openvswitch.spec":
    ensure => "present",
    source => "file:////rpmbuild/SOURCES/openvswitch-2.6.1/rhel/openvswitch.spec",
    require => [
                  Exec["extract_ovs"],
               ],
  }

  exec { "build_ovs":
    cwd     => "/rpmbuild/SOURCES",
    command => "/usr/bin/rpmbuild -bb --without check /rpmbuild/SPECS/openvswitch.spec",
    logoutput   => true,
    loglevel    => verbose,
    timeout     => 0,
    creates     => "/root/openvswitch-common_2.6.1-1_amd64.deb",
    #creates     => "/root/openvswitch-common_2.5.0-1_amd64.deb",
    require     => [
                     Package["rpm-build"],
                     Package["python-six"],
                     Package[$base_packages],
                     Exec["extract_ovs"],
                   ],
  }

  exec { "install_ovs":
    command     => "/usr/bin/rpm -ivh --nodeps /rpmbuild/RPMS/x86_64/openvswitch*.rpm",
    require => [
                  Exec["build_ovs"],
               ],
  }

  exec { "start_ovs":
    command     => "/usr/bin/sudo /etc/init.d/openvswitch start",
    require => [
                  Exec["install_ovs"],
               ],
  }


}

node devStack inherits basenode {

  #file { '/opt/devstack':
  #   ensure => 'directory',
  #   owner  => 'root'
  #}

  exec { "download_devstack":
    cwd     => "/opt/",
    creates => "/opt/devstack",
    #command => "/usr/bin/git clone https://git.openstack.org/openstack-dev/devstack -b stable/newton "
    command => "/usr/bin/git clone https://git.openstack.org/openstack-dev/devstack -b master "
  }
}


import 'nodes/*.pp'
