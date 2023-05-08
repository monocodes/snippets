---
title: ansible
categories:
  - software
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [Ansible install](#ansible-install)
  - [ubuntu](#ubuntu)
- [Ansible paths](#ansible-paths)
- [Ansible configuration](#ansible-configuration)
  - [Order of Ansible Config](#order-of-ansible-config)
  - [config hints](#config-hints)
- [Ansible commands](#ansible-commands)
  - [`ansible-doc` = `--help`](#ansible-doc----help)
  - [ansible-playbook](#ansible-playbook)
  - [ansible-galaxy](#ansible-galaxy)
  - [rpm-based](#rpm-based)
- [Ansible playbook hints](#ansible-playbook-hints)
- [Ansible modules](#ansible-modules)
  - [**MySQL** and **MariaDB** modules example](#mysql-and-mariadb-modules-example)
- [Ansible variables](#ansible-variables)
  - [Understanding variable precedence](#understanding-variable-precedence)
- [Python-JSON-YAML](#python-json-yaml)

## Ansible install

### ubuntu

via apt

```sh
sudo apt update && \
	sudo apt install software-properties-common -y && \
	sudo add-apt-repository --yes --update ppa:ansible/ansible && \
	sudo apt install ansible -y
```

```sh
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

---

## Ansible paths

ansible config - [Ansible Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings)

```sh
/etc/ansible/ansible.cfg
```

default global inventory file

> best practice is to create new inventory file in the project dir

```sh
/etc/ansible/hosts
```

---

## Ansible configuration

### Order of Ansible Config

1. `ANSIBLE_CONFIG` (environment variable if set)
2. `ansible.cfg` (file in the current working dir)
3. `~/.ansible.cfg` (file in the home dir)
4. `/etc/ansible/ansible.cfg` - main global config

---

### config hints

disable host key checking (need to do that)

```sh
sudo vim /etc/ansible/ansible.cfg

host_key_checking = False
```

---

## Ansible commands

> `--become` = `sudo`, become root

check ansible version and its configuration

```sh
ansible --version
```

execute ansible module command

```sh
ansible -i /path/to/inventory-file -m module-name target-name
```

ping servers

```sh
# examples ping
ansible -i inventory -m ping web01
ansible -i inventory -m ping all
ansible -i inventory -m ping '*' # same as all
ansible -i inventory -m ping websrvgrp
```

copy file to remote host

```sh
ansible -i inventory -m copy -a "src=index.html dest=/var/www/html/index.html" web01 --become
```

gather facts about remote machine, run **OHAI** tool  
show all **Facts Variables**

```sh
ansible -m setup hostname
```

---

### `ansible-doc` = `--help`

show all available modules

```sh
ansible-doc -l
```

show help for module

```sh
ansible-doc module-name

# example
ansible-doc yum
```

---

### ansible-playbook

check playbook syntax before executing

```sh
ansible-playbook -i /path/to.inventory-file playbook-name.yaml --syntax-check

# example
ansible-playbook -i inventory web_db.yaml --syntax-check
```

execute playbook

```sh
ansible-playbook -i inventory web_db.yaml
```

test playbook with `-C`, check only, dry-run

```sh
ansible-playbook -i inventory web_db.yaml -C
```

**debug**, increase log level

```sh
ansible-playbook db.yaml -vv

# -vv - second log level, maximum is -vvvv
```

---

### ansible-galaxy

initialize role-based approach and create needed dirs

```sh
ansible-galaxy init role-name


# example
ansible-galaxy init post-install

# output
- Role post-install was created successfully

tree

# output
post-install/
├── README.md
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

---

### rpm-based

install package with `yum`

```sh
ansible -i /path/to/inventory-file -m yum -a "name=package-name state=operation-name" --become remote-hostname
# --become = sudo, become root

# example
ansible -i inventory -m yum -a "name=httpd state=present" web01 --become
```

start and enable service

```sh
ansible -i inventory -m service -a "name=httpd state=started enabled=yes" web01 --become
```

uninstall package with `yum`

```sh
ansible -i inventory -m yum -a "name=httpd state=absent" --become web01
```

---

## Ansible playbook hints

**YAML literal block string syntax** for long complex commands with `""` and other symbols that needed to be escaped

`print_facts.yaml`

```yaml
---
- name: Learning fact variables
  hosts: all
  tasks:
    - name: Print OS names
      debug:
        var: ansible_distribution

    - name: Print memory details
      debug:
        var: ansible_memory_mb

    - name: Print real memory details
      debug:
        var: ansible_memory_mb.nocache.free

    - name: Print processor name
      debug:
        var: ansible_processor[2]

    - name: Get running processes list from remote host, sort by memory usage
      become: yes
      shell:
        # YAML literal block string syntax
        cmd: |
          ps -eo size,pid,user,command --sort -size | \
            awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | \
            cut -d "" -f2 | cut -d "-" -f1
      register: running_processes

    - debug:
        var: running_processes.stdout_lines
```

---

## Ansible modules

Every module has its own dependencies, read carefully in [Ansible Docs](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html)  
Some modules needs dependencies installed on host machine, because execution is local, another needs dependencies installed on remote hosts, can be achieved with **Ansible Playbooks**

### **MySQL** and **MariaDB** modules example

1. Create database with [mysql_db – Add or remove MySQL databases from a remote host](https://docs.ansible.com/ansible/2.9/modules/mysql_db_module.html#mysql-db-module)

    - Need to install dependency on remote host

    - Connect to remote host and search with `yum` or `pip` for dependency

        - ```sh
            yum search python | grep -i mysql
            
            # output
            mysql-connector-python.noarch : MySQL Connector for Python 2
            python2-PyMySQL.noarch : Pure-Python MySQL client library
            python36-PyMySQL.noarch : Pure-Python MySQL client library
            python36-mysql-debug.x86_64 : An interface to MySQL, built for the CPython debug
            MySQL-python.x86_64 : An interface to MySQL
            python36-mysql.x86_64 : An interface to MySQL
            ```

        - Actually here we can use `MySQL-python` or `python2-PyMySQL`

        - Add dependency install in ansible playbook

2. Create user with [mysql_user – Adds or removes a user from a MySQL database](https://docs.ansible.com/ansible/2.9/modules/mysql_user_module.html#mysql-user-module)

    - dependancy satisfied

3. Playbook `db.yaml`

```yaml
---
- name: Setup DBserver
  hosts: dbsrvgrp
  become: yes
  tasks:
    - name: Install MySQL server
      yum:
         name: mariadb-server
         state: present
    - name: Install Python MySQL
      yum:
         name: MySQL-python
         state: present

    - name: Start & Enable mariadb service
      service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database with name 'accounts'
      mysql_db:
        name: accounts
        state: present

    - name: Create database user with name 'admin'
      mysql_user:
        name: admin
        password: 12345
        priv: '*.*:ALL'
        state: present
```

---

## Ansible variables

### [Understanding variable precedence](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence)

Ansible does apply variable precedence, and you might have a use for it. Here is the order of precedence from least to greatest (the last listed variables override all other variables):

1. command line values (for example, `-u my_user`, these are not variables)
2. role defaults (defined in role/defaults/main.yml) [1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id14)
3. inventory file or script group vars [2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id15)
4. inventory group_vars/all [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
5. playbook group_vars/all [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
6. inventory group_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
7. playbook group_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
8. inventory file or script host vars [2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id15)
9. inventory host_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
10. playbook host_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
11. host facts / cached set_facts [4](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id17)
12. play vars
13. play vars_prompt
14. play vars_files
15. role vars (defined in role/vars/main.yml)
16. block vars (only for tasks in block)
17. task vars (only for the task)
18. include_vars
19. set_facts / registered vars
20. role (and include_role) params
21. include params
22. extra vars (for example, `-e "user=my_user"`)(always win precedence)

In general, Ansible gives precedence to variables that were defined more recently, more actively, and with more explicit scope. Variables in the defaults folder inside a role are easily overridden. Anything in the vars directory of the role overrides previous versions of that variable in the namespace. Host and/or inventory variables override role defaults, but explicit includes such as the vars directory or an `include_vars` task override inventory variables.

Ansible merges different variables set in inventory so that more specific settings override more generic settings. For example, `ansible_ssh_user` specified as a group_var is overridden by `ansible_user` specified as a host_var. For details about the precedence of variables set in inventory, see [How variables are merged](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-we-merge).

Footnotes

- [1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id4)

    Tasks in each role see their own role’s defaults. Tasks defined outside of a role see the last role’s defaults.

- 2*([1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id5),[2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id10))*

    Variables defined in inventory file or provided by dynamic inventory.

- 3*([1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id6),[2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id7),[3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id8),[4](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id9),[5](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id11),[6](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id12))*

    Includes vars added by ‘vars plugins’ as well as host_vars and group_vars which are added by the default vars plugin shipped with Ansible.

- [4](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id13)

    When created with set_facts’s cacheable option, variables have the high precedence in the play, but are the same as a host facts precedence when they come from the cache.

> Within any section, redefining a var overrides the previous instance. If multiple groups have the same variable, the last one loaded wins. If you define a variable twice in a play’s `vars:` section, the second one wins.

> The previous describes the default config `hash_behaviour=replace`, switch to `merge` to only partially overwrite.

---

## Python-JSON-YAML

Python

```python
# DevOps - list
# Development - list
# ansible_facts - dict
{
  "DevOps": ["AWS", "Jenkins", "Python", "Ansible"],
  "Development": ["Java", "NodeJS", ".net"],
  "ansible_facts": {
    "python": "/usr/bin/python"
  }
}
```

JSON

```json
{
  "DevOps":
  [
    "AWS",
    "Jenkins",
    "Python",
    "Ansible"
  ],
  "Development":
  ["Java",
   "NodeJS",
   ".net"
  ],
  "ansible_facts":
  {
    "python": "/usr/bin/python"
  }
}
```

YAML

```yaml
DevOps:
  - AWS
  - Jenkins
  - Python
  - Ansible

Development:
  - Java
  - NodeJS
  - .net

ansible_facts:
  python: /usr/bin/python
  version: 2.7
```

---
