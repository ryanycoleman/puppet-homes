# == Define Resource Type: homes::ssh::public
#
# This private definition will manage the public key for a given user
#
# === Parameters
#
# [*username*]
# String, required parameter. The name of the user that will be managed.
#
# [*ssh_key*]
# String, default empty. If given, this will be used to populate the authorized_keys
# file for the given user.
#
# === Examples
#
# Manage the authorized_key for a given user:
#
# homes::ssh::public { 'id_rsa.pub for testuser'
#  username => 'testuser',
#  ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4U/G9Idqy1VvYEDCKg3noVChCbIrJAi0D/qMFoG=='
# }
#
define homes::ssh::public(
  $username,
  $ssh_key
) {

    file { "/home/${username}/.ssh":
      ensure  => directory,
      owner   => $username,
      mode    => '0600',
      require => File["/home/${username}"]
    }

    ssh_authorized_key { $username:
      ensure  => present,
      key     => $ssh_key,
      target  => "/home/${username}/.ssh/authorized_keys",
      type    => 'ssh-rsa',
      user    => $username,
      require => User[$username]
    }

    file { "/home/${username}/.ssh/authorized_keys":
      ensure  => present,
      owner   => $username,
      mode    => '0644'
    }
}