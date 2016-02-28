# Ansible Playbook Container

Use this container to run ansbile playbooks or other related commands. You
should have a running `ssh-agent` to connect to your hosts. Give this
container the name of the ansible subcommand (`playbook`, `vault`, ...). If
there is no such subcommand the container will call the plain `ansible` command
with the given parameters.

Put this in your `.bashrc`:
```bash
_ansible() {
  subc=$1
  shift
  docker run -it --rm -v $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent -v `pwd`:/work ulrichschreiner/ansible $subc "$@"
}
_ansible_playbook() {
  _ansible playbook "$@"
}
_ansible_vault() {
  _ansible vault "$@"
}
_ansible_doc() {
  _ansible doc "$@"
}
_ansible_pull() {
  _ansible pull "$@"
}
_ansible_galaxy() {
  _ansible galaxy "$@"
}
alias ansible-playbook=_ansible_playbook
alias ansible-vault=_ansible_vault
alias ansible-doc=_ansible_doc
alias ansible-pull=_ansible_pull
alias ansible-galaxy=_ansible_galaxy
alias ansible=_ansible

```

Now create an inventory:
```
[myhosts]
1.2.3.4 ansible_user=myuserid
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
