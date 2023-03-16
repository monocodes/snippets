---
title: maven
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# maven

## maven install ubuntu

1. first, you need to install `jdk`

2. search for proper `jdk` package needed for your project  

    ```bash
    sudo apt search jdk
    sudo apt install openjdk-8-jdk -y
    
    java -version # check installed version
    openjdk version "1.8.0_362"
    OpenJDK Runtime Environment (build 1.8.0_362-8u362-ga-0ubuntu1~22.04-b09)
    OpenJDK 64-Bit Server VM (build 25.362-b09, mixed mode)
    ```

3. install `maven`  

    ```bash
    sudo apt install maven -y
    mvn -version # check installed version of mvn and used version of Java
    Apache Maven 3.6.3
    Maven home: /usr/share/maven
    Java version: 1.8.0_362, vendor: Private Build, runtime: /usr/lib/jvm/java-8-openjdk-amd64/jre
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "5.15.0-67-generic", arch: "amd64", family: "unix"
    ```

---

### maven install different version

1.  search for needed version in **maven archive** - <https://archive.apache.org/dist/maven/>

2.  choose version and go to `binaries\` dir  

    >   for example <https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/>

3.   download **tarball**

    ```bash
    wget https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
    ```

4.  extract archive  

    ```bash
    tar xzvf apache-maven-3.3.9-bin.tar.gz
    ```

5.  move to the `/opt/` dir for example  

    ```bash
    sudo mv apache-maven-3.3.9 /opt/
    ```

6.  check maven binary version  

    ```bash
    /opt/apache-maven-3.3.9/bin/mvn -version
    
    Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-10T16:41:47+00:00)
    Maven home: /opt/apache-maven-3.3.9
    Java version: 1.8.0_362, vendor: Private Build
    Java home: /usr/lib/jvm/java-8-openjdk-amd64/jre
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "5.15.0-67-generic", arch: "amd64", family: "unix"
    ```

7.  go to the project dir and try to use this version of maven with it  

    >   example with vprofile-project

    ```bash
    cd ~/vprofile-project
    /opt/apache-maven-3.3.9/bin/mvn clean install
    ```

    

---

## maven phases

<https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html>

| `validate`                | validate the project is correct and all necessary information is available. |
| ------------------------- | ------------------------------------------------------------ |
| `initialize`              | initialize build state, e.g. set properties or create directories. |
| `generate-sources`        | generate any source code for inclusion in compilation.       |
| `process-sources`         | process the source code, for example to filter any values.   |
| `generate-resources`      | generate resources for inclusion in the package.             |
| `process-resources`       | copy and process the resources into the destination directory, ready for packaging. |
| `compile`                 | compile the source code of the project.                      |
| `process-classes`         | post-process the generated files from compilation, for example to do bytecode enhancement on Java classes. |
| `generate-test-sources`   | generate any test source code for inclusion in compilation.  |
| `process-test-sources`    | process the test source code, for example to filter any values. |
| `generate-test-resources` | create resources for testing.                                |
| `process-test-resources`  | copy and process the resources into the test destination directory. |
| `test-compile`            | compile the test source code into the test destination directory |
| `process-test-classes`    | post-process the generated files from test compilation, for example to do bytecode enhancement on Java classes. |
| `test`                    | run tests using a suitable unit testing framework. These tests should not require the code be packaged or deployed. |
| `prepare-package`         | perform any operations necessary to prepare a package before the actual packaging. This often results in an unpacked, processed version of the package. |
| `package`                 | take the compiled code and package it in its distributable format, such as a JAR. |
| `pre-integration-test`    | perform actions required before integration tests are executed. This may involve things such as setting up the required environment. |
| `integration-test`        | process and deploy the package if necessary into an environment where integration tests can be run. |
| `post-integration-test`   | perform actions required after integration tests have been executed. This may including cleaning up the environment. |
| `verify`                  | run any checks to verify the package is valid and meets quality criteria. |
| `install`                 | install the package into the local repository, for use as a dependency in other projects locally. |
| `deploy`                  | done in an integration or release environment, copies the final package to the remote repository for sharing with other developers and projects. |

---

## maven commands

### mvn phase commands

>   run these commands inside the dir of the project  
>   every phase will overwrite `target/` dir in project dir but not `clean` it  
>   so, it's good to run `mvn clean install` instead of `mvn install`

**test phase**  
results of tests would be in `target/` dir  
all downloaded dependencies will be in a user home dir `/home/username/.m2/repository`

```bash
mvn test
```

**install phase**  
artefact would be in `target/` dir  
all downloaded dependencies will be in a user home dir `/home/username/.m2/repository`  
it's good to run `mvn clean install` instead of `mvn install`

```bash
mvn install
```

**clean `target/` dir**

```bash
mvn clean
```

---

