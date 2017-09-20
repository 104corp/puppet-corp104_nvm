class corp104_nvm::install inherits corp104_nvm {

  $nvm_script_url = "https://raw.githubusercontent.com/creationix/nvm/${corp104_nvm::nvm_version}/install.sh"

  if $corp104_nvm::http_proxy {
    exec { 'download-install-sh':
      provider => 'shell',
      command  => "curl -x ${corp104_nvm::http_proxy} -o ${corp104_nvm::nvm_install_tmp} -O ${nvm_script_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => ". ${corp104_nvm::nvm_dir}/nvm.sh; nvm --version",
    }
    exec { 'install-nvm':
      provider    => 'shell',
      environment => [
        "https_proxy=${corp104_nvm::http_proxy}",
        'HOME=/tmp',
        "NVM_DIR=${corp104_nvm::nvm_dir}",
        "PROFILE=${corp104_nvm::profile}"
      ],
      command     => "bash ${corp104_nvm::nvm_install_tmp}",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless      => ". ${corp104_nvm::nvm_dir}/nvm.sh; nvm --version",
    }
  }
  else {
    exec { 'install-nvm':
      provider => 'shell',
      command  => "curl -o- ${nvm_script_url} | HOME=/tmp NVM_DIR=${corp104_nvm::nvm_dir} PROFILE=${corp104_nvm::profile} bash",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => ". ${corp104_nvm::nvm_dir}/nvm.sh; nvm --version",
      notify   => Class['corp104_nvm::install::node'],
    }
  }
}