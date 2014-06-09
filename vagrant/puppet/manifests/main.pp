class apt_update {
    exec { "aptGetUpdate":
        command => "sudo apt-get update",
        path => ["/bin", "/usr/bin"]
    }
}

class othertools {
    package { "git":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "vim-common":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "curl":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "htop":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }

    package { "g++":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }
}

class nodejs {
  include apt
  apt::ppa {
    'ppa:chris-lea/node.js': notify => Package["nodejs"]
  }

  package { "nodejs" :
      ensure => latest,
      require => [Exec["aptGetUpdate"],Class["apt"]]
  }

  exec { "npm-update" :
      cwd => "/vagrant",
      command => "npm -g update",
      onlyif => ["test -d /vagrant/node_modules"],
      path => ["/bin", "/usr/bin"],
      require => Package['nodejs']
  }
}

class the-nginx {
  class { 'nginx': }
  nginx::resource::upstream { 'www-node-1':
    ensure  => present,
    members => [
      'localhost:8000'
    ]
  }

  nginx::resource::vhost { 'proxy-node':
    ensure      => present,
    listen_port => 8080,
    proxy       => 'http://www-node-1'
  }
}


include apt_update
include othertools
include nodejs
include the-nginx

