# Documentation

## Example

```
account_groups:
  - name: 'sudo'
    system: yes
  - name: 'admin'
    system: yes
    sudoer: yes
  - name: 'www-data'
    system: yes
  - name: 'vagrant'
account_users:
  - name: 'vagrant'
    createhome: yes
    sudoer: yes
    group: 'vagrant'
    groups:
      - 'sudo'
      - 'www-data'
    authorized_keys:
      - key: 'https://github.com/username.keys'
    known_hosts:
      - key: 'someone.com {{ lookup("file", "account/someone/id_rsa.pub") }}'
    files:
      - path: '.ssh'
        mode: '0700'
        state: 'directory'
  - name: 'johndoe'
    remove: yes
    state: 'absent'
```

## Role Variables

Available variables are listed below, along with default values (see [defaults/main.yml](/defaults/main.yml)):

```
account_groups: []
```

The account groups you would like to manage. Each group supports all parameters from the
[group](http://docs.ansible.com/ansible/group_module.html) module. An additional parameter `sudoer` can be
specified, valid values are `yes` or `no`. When defined and the value is `yes` the group will be added to
the `/etc/sudoers` file, users belonging to that group will not need to provide a password when privileges need
to be elevated. If defined and the value is `no` the group will be removed from the `/etc/sudoers` file.

```
account_users: []
```

The account users you would like to manage. Each user supports all parameters from the
[user](http://docs.ansible.com/ansible/user_module.html) module. An additional parameter `sudoer` can be
specified, valid values are `yes` or `no`. When defined and the value is `yes` the user will be added to
the `/etc/sudoers` file, the user will not need to provide a password when privileges need to be elevated. If 
defined and the value is `no` the user will be removed from the `/etc/sudoers` file.

There's also additional parameters which are basically wrappers around other modules. The only
difference being that the `path` and `dest` properties are restricted to the users home directory. When
specifying either the `path` or `dest` properties, they should be relative. Also note that in most cases
you won't need to specify `group` or `owner` properties as these are inherited from the `user`.

* `authorized_keys` supports all parameters from the [authorized_key](http://docs.ansible.com/ansible/authorized_key_module.html) module.
* `known_hosts` supports all parameters from the [known_hosts](http://docs.ansible.com/ansible/known_hosts_module.html) module.
* `files` supports all parameters from the [file](http://docs.ansible.com/ansible/file_module.html) module.
* `copies` supports all parameters from the [copy](http://docs.ansible.com/ansible/copy_module.html) module.
* `repositories` supports all parameters from the [git](http://docs.ansible.com/ansible/git_module.html) module.
* `composers` supports all parameters from the [composer](http://docs.ansible.com/ansible/composer_module.html) module.

The purpose of these wrappers is to carry out general tasks such as making sure a directory or file
exists, immediately after creating an account.