# Ansible Container

Use this container to run ansbile playbooks or other related commands. You
should have a running `ssh-agent` to connect to your hosts. Give this
container the name of the ansible subcommand (`playbook`, `vault`, ...). If
there is no such subcommand the container will call the plain `ansible` command
with the given parameters.

Download the file `ansible` to you `~/bin` and create symlinks:
```bash
cd bin
curl -sSL https://raw.githubusercontent.com/ulrichSchreiner/ansible-docker/master/ansible >ansible && chmod 755 ansible
ln -s ansible ansible-playbook
ln -s ansible ansible-vault
ln -s ansible ansible-doc
ln -s ansible ansible-pull
ln -s ansible ansible-galaxy
```

Be sure to have `~/bin` in your path.

Now create an inventory:
```
[myhosts]
1.2.3.4
```

and create a playbook:
```yaml
---
 - hosts: myhosts
   become: yes
   gather_facts: no
   pre_tasks:
    - name: 'install python2'
      raw: apt-get -y install python-simplejson
   tasks:
    - shell: echo "Hello "
```

Note: in this example i install a python2 in a `pre_tasks` with `gather_facts: no`. This is only an example, but for current linux
distros you often need this, because ansible requires a python2 installation on the target system.

Now run your playbook. You must start the image in the same directory with your configuration files. As they are mounted into the
container, you cannot reference files on your hosts system:
```bash
ansible-playbook --ask-become-pass -i inventory site.yaml
SUDO password:

PLAY ***************************************************************************

TASK [install python2] *********************************************************
ok: [myhosts]

TASK [command] *****************************************************************
changed: [myhosts]

PLAY RECAP *********************************************************************
myhosts     : ok=2    changed=1    unreachable=0    failed=0   

```

## Ansible Configuration

When using the `ansible` script you can create an environment variable `ANSIBLE_CONFIG_DIR` which should
point to a directory with your global ansible configurations. This directory will be mounted in the 
container at path `/etc/ansible` so you can use it for lookups or other configurations.

To be flexible you can set 
```
export ANSIBLE_CONFIG_DIR=$HOME/Dropbox/ansible
```

and now you can run your playbooks on every computer where you have your dropbox connected.
