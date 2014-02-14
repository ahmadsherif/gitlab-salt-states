GitLab Salt States
==================

An adaptation (almost) of GitLab [installation instructions](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md) in [Salt](http://saltstack.com/).

Running with Vagrant
--------------------
```shell
mkdir gitlab && cd gitlab
vagrant box add saucy64 https://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box
vim Vagrantfile # contents below
mkdir salt && cd salt
touch minion
git clone git@github.com:ahmadsherif/gitlab-salt-states.git roots
cd ..
vagrant up && vagrant provision
```

Use the following content as `Vagrantfile` content:

```ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'saucy64'
  config.vm.host_name = 'gitlab'

  config.vm.synced_folder 'salt/roots/', '/srv/salt'
  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end

  config.vm.provision :salt do |salt|
    salt.minion_config = 'salt/minion'
    salt.run_highstate = true
  end
end
```

TODO
----
* Use pillars instead of hard-coded values
