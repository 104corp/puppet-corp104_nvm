# Class: corp104_nvm
# ===========================
#
# Full description of class corp104_nvm here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'corp104_nvm':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class corp104_nvm (
  String $nvm_version,
  String $nvm_dir,
  String $profile,
  String $nvm_install_tmp,
  String $node_version,
  Boolean $set_default,
  Boolean $no_update_notifier,
  Optional[String] $http_proxy,
){
  contain corp104_nvm::install
  contain corp104_nvm::install::node

  Class['::corp104_nvm::install']
  -> Class['::corp104_nvm::install::node']
}
