#
# one machine setup with weblogic 12.2.1
# needs jdk7, orawls, orautils, fiddyspence-sysctl, erwbgy-limits puppet modules
#
Package{allow_virtual => false,}

node 'jdk.example.com' {

  include os
  include java
}

# operating settings for Middleware
class os {

  $default_params = {}
  $host_instances = hiera('hosts', {})
  create_resources('host',$host_instances, $default_params)

  service { iptables:
        enable    => false,
        ensure    => false,
        hasstatus => true,
  }

  $install = [ 'binutils.x86_64','unzip.x86_64']


  class { 'limits':
    config => {
               '*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
               'oracle'  => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
                               'nproc'   => { soft => '2048'   , hard => '16384',   },
                               'memlock' => { soft => '1048576', hard => '1048576',},
                               'stack'   => { soft => '10240'  ,},},
               },
    use_hiera => false,
  }
}


class java {
  require os

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  # package { $remove:
  #   ensure  => absent,
  # }

  include jdk7

  jdk7::install7{ 'jdk-8u72-linux-x64':
      version                     => "8u72" ,
      full_version                => "jdk1.8.0_72",
      alternatives_priority       => 18001,
      x64                         => true,
      download_dir                => "/var/tmp/install",
      urandom_java_fix            => true,
      rsa_key_size_fix            => true,
      cryptography_extension_file => "jce_policy-8.zip",
      source_path                 => "/software",
  }

}
