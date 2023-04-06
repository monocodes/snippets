---
title: ansible
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# ansible

- [ansible](#ansible)
  - [Ansible install](#ansible-install)
    - [ubuntu](#ubuntu)
  - [Ansible paths](#ansible-paths)
  - [Ansible configuration](#ansible-configuration)
  - [Ansible commands](#ansible-commands)
    - [`ansible-doc` = `--help`](#ansible-doc----help)
    - [ansible-playbook](#ansible-playbook)
    - [rpm-based](#rpm-based)
  - [Python-JSON-YAML](#python-json-yaml)

## Ansible install

### ubuntu

via apt

```bash
sudo apt update && \
	sudo apt install software-properties-common -y && \
	sudo add-apt-repository --yes --update ppa:ansible/ansible && \
	sudo apt install ansible -y
```

```bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

---

## Ansible paths

ansible config

```bash
/etc/ansible/ansible.cfg
```

default global inventory file

> best practice is to create new inventory file in the project dir

```bash
/etc/ansible/hosts
```

---

## Ansible configuration

disable host key checking (need to do that)

```bash
sudo vim /etc/ansible/ansible.cfg

host_key_checking = False
```

---

## Ansible commands

> `--become` = `sudo`, become root

check ansible version and its configuration

```bash
ansible --version
```

execute ansible module command

```bash
ansible -i /path/to/inventory-file -m module-name target-name
```

ping servers

```bash
# examples ping
ansible -i inventory -m ping web01
ansible -i inventory -m ping all
ansible -i inventory -m ping '*' # same as all
ansible -i inventory -m ping websrvgrp
```

copy file to remote host

```bash
ansible -i inventory -m copy -a "src=index.html dest=/var/www/html/index.html" web01 --become
```

---

### `ansible-doc` = `--help`

show all available modules

```bash
ansible-doc -l
```

show help for module

```bash
ansible-doc module-name

# example
ansible-doc yum
```

---

### ansible-playbook

check playbook syntax before executing

```bash
ansible-playbook -i /path/to.inventory-file playbook-name.yaml --syntax-check

# example
ansible-playbook -i inventory web_db.yaml --syntax-check
```

execute playbook

```bash
ansible-playbook -i inventory web_db.yaml
```

---

### rpm-based

install package with `yum`

```bash
ansible -i /path/to/inventory-file -m yum -a "name=package-name state=operation-name" --become remote-hostname
# --become = sudo, become root

# example
ansible -i inventory -m yum -a "name=httpd state=present" web01 --become
```

start and enable service

```bash
ansible -i inventory -m service -a "name=httpd state=started enabled=yes" web01 --become
```

uninstall package with `yum`

```bash
ansible -i inventory -m yum -a "name=httpd state=absent" --become web01
```

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
