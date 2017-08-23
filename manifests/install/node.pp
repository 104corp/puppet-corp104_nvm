class corp104_nvm::install::node inherits corp104_nvm {
  if $corp104_nvm::http_proxy {
    exec { 'install-node':
      provider => 'shell',
      command  => ". ${corp104_nvm::nvm_dir}/nvm.sh; \
                  export ${corp104_nvm::http_proxy}; \
                  nvm install ${corp104_nvm::node_version}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => ". ${corp104_nvm::nvm_dir}/nvm.sh && nvm which ${corp104_nvm::node_version}",
      require  => Class['corp104_nvm::install'],
    }
  }
  else {
    exec { 'install-node':
      provider => 'shell',
      command  => ". ${corp104_nvm::nvm_dir}/nvm.sh; \
                  nvm install ${corp104_nvm::node_version}",
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
      unless   => ". ${corp104_nvm::nvm_dir}/nvm.sh && nvm which default | grep ${corp104_nvm::node_version}",
      require  => Exec['install-node'],
    }
  }
}