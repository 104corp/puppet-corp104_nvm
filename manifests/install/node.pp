class corp104_nvm::install::node inherits corp104_nvm {
  if $corp104_nvm::http_proxy {
    exec { 'install-node':
      provider    => 'shell',
      environment => ["https_proxy=${corp104_nvm::http_proxy}"],
      command     => ". ${corp104_nvm::nvm_dir}/nvm.sh \
                     && export http_proxy=${corp104_nvm::http_proxy} \
                     && nvm install ${corp104_nvm::node_version}",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless      => ". ${corp104_nvm::nvm_dir}/nvm.sh && nvm which ${corp104_nvm::node_version}",
      require     => Class['corp104_nvm::install'],
    }
  }
  else {
    exec { 'install-node':
      provider => 'shell',
      command  => ". ${corp104_nvm::nvm_dir}/nvm.sh \
                  && nvm install ${corp104_nvm::node_version}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => ". ${corp104_nvm::nvm_dir}/nvm.sh && nvm which ${corp104_nvm::node_version}",
      require  => Class['corp104_nvm::install'],
    }
  }

  if $corp104_nvm::set_default {
    exec { 'set-default-node':
      provider => 'shell',
      command  => ". ${corp104_nvm::nvm_dir}/nvm.sh; \
                  nvm alias default ${corp104_nvm::node_version}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => ". ${corp104_nvm::nvm_dir}/nvm.sh && nvm which default | grep v${corp104_nvm::node_version}",
      require  => Exec['install-node'],
    }
  }

  # set node and npm link to /usr/local/bin.
  file {
    default:
      ensure => link,
    ;
    '/usr/local/bin/node':
      target => "${corp104_nvm::nvm_dir}/versions/node/v${corp104_nvm::node_version}/bin/node",
    ;
    '/usr/local/bin/npm':
      target => "${corp104_nvm::nvm_dir}/versions/node/v${corp104_nvm::node_version}/bin/npm",
    ;
  }

  if $corp104_nvm::no_update_notifier {
    augeas { 'no-update-notifier-environment':
      lens    => 'Shellvars.lns',
      incl    => '/etc/environment',
      changes => 'set NO_UPDATE_NOTIFIER 1',
    }
  }
}
