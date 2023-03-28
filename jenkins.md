---
title: jenkins
categories:
  - software
  - CI/CD
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# jenkins

- [jenkins](#jenkins)
  - [install](#install)
    - [ubuntu](#ubuntu)
    - [java, jdk](#java-jdk)
    - [github webhooks](#github-webhooks)
  - [paths](#paths)
  - [jenkins build steps examples](#jenkins-build-steps-examples)
    - [Post-build Actions](#post-build-actions)
    - [Build step](#build-step)
    - [This project is parameterized](#this-project-is-parameterized)
  - [troubleshooting](#troubleshooting)
    - [Host Key verification failed](#host-key-verification-failed)
  - [Jenkinsfile pipeline examples](#jenkinsfile-pipeline-examples)
    - [devops-project-ud-01](#devops-project-ud-01)
      - [Section 15 - Continuous Integration with Jenkins](#section-15---continuous-integration-with-jenkins)
  - [jenkins `ENV` environmental variables](#jenkins-env-environmental-variables)

## install

### ubuntu

`jenkins-install-ubuntu.sh`

```bash
#!/bin/bash

# optional install of jdk, comment if not needed
sudo apt-get update
sudo apt-get install openjdk-11-jdk -y

# jenkins install
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
```

---

### java, jdk

> Java install from UI of **Jenkins** from **Oracle** account may not work, install *manually*

Install needed `jdk` in **Jenkins**  manually

```bash
sudo apt install openjdk-8-jdk -y
```

> Installation of different versions of `java` here [maven.md](maven.md)

check current main version

```bash
java -version
```

check installed jdk versions

```bash
ls /usr/lib/jvm
```

> example  
> here installed openjdk-8-jdk `java-1.8.0-openjdk-amd64` and openjdk-11-jdk `java-1.11.0-openjdk-amd64`

```bash
ls /usr/lib/jvm
java-1.11.0-openjdk-amd64  java-11-openjdk-amd64  openjdk-11
java-1.8.0-openjdk-amd64   java-8-openjdk-amd64
```

use this paths to specify `java` installation in `Jenkins`

```text
/usr/lib/jvm/java-1.8.0-openjdk-amd64
```

---

### github webhooks

1. Create new **Pipeline** project in **Jenkins** -> choose *Pipeline script from SCM*
2. Branch Specifier -> `/main` or any other branch
3. Setup *ssh key* in **Jenkins** credentials
4. Turn off [Host Key verification](#host-key-verification-failed)in **Jenkins**
5. In **GitHub** go to repo Settings -> Webhooks -> Add webhook:
6. Add **Payload URL**. It's **Jenkins** URL like <http://54.88.141.76:8080/github-webhook/>
7. **Content type** - `application/json`
8. Choose *Which events would you like to trigger this webhook?*
9. **Add webhook**
10. For example - Jenkins -> Job -> Configure -> *GitHub hook trigger for GITScm polling*

**Popular triggers**

- Git Webhook
- Poll SCM
- Scheduled jobs
- Remote triggers - it's hardest one to setup, but gives an opportunity to trigger from almost anywhere
- Build after other projects are built

---

## paths

home dir

```bash
/var/lib/jenkins/
```

restart jenkins

```http
http://ip:8080/restart
```

---

## jenkins build steps examples

### Post-build Actions

**Archive the artifacts**

Search any directory (`**`) any file with `.war` extension (`*.war`)

Files to archive

```bash
**/*.war
```

---

### Build step

**Execute Shell**

Simple versioning build step with `$BUILD_ID` Jenkins `ENV`

```bash
mkdir -p versions
cp target/vprofile-v2.war versions/vprofile-v$BUILD_ID.war
```

**Execute Shell + Timestamp Plugin**

Simple versioning with `BUILD_TIMESTAMP` plugin **[Zentimestamp plugin](https://plugins.jenkins.io/zentimestamp)**

Change date pattern for the BUILD_TIMESTAMP (build timestamp) variable

```text
yy-MM-dd_HHmm
```

Execute Shell buildstep

```bash
mkdir -p versions
cp target/vprofile-v2.war versions/vprofile-v$BUILD_ID-$BUILD_TIMESTAMP.war
```

---

### This project is parameterized

Simple versioning with parameters

> Makes job interactive, **so it's not the best way. Use it if you really need.**

**String parameter**

Name - VERSION

**Execute Shell**

```bash
mkdir -p versions
cp target/vprofile-v2.war versions/vprofile-v$VERSION.war
```

---

## troubleshooting

### Host Key verification failed

`Dashboard` -> `Manage Jenkins` -> `Configure Global Security` -> `Git Host Key Verification Configuration` -> `Accept first Conection` -> `Save`

After that **Jenkins** will not verify host key and could freely connect to **Github** repo for example.

---

## Jenkinsfile pipeline examples

### devops-project-ud-01

#### Section 15 - Continuous Integration with Jenkins

sample-paac.Jenkinsfile

```groovy
pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    
    stages {
        stage('Fetch code') {
            steps {
                git branch: 'vp-rem', url: 'https://github.com/devopshydclub/vprofile-project.git'
            }
        }

        stage('Build'){
            steps{
                sh 'mvn install -DskipTests'
            }

            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('UNIT TEST') {
            steps{
                sh 'mvn test'
            }
        }
    }
}
```

PAAC-Analysis.Jenkinsfile

```groovy
def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]
pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    
    stages {
        stage('Fetch code') {
            steps {
                git branch: 'vp-rem', url: 'https://github.com/devopshydclub/vprofile-project.git'
            }
        }

        stage('Build'){
            steps{
                sh 'mvn install -DskipTests'
            }

            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('Test') {
            steps{
                sh 'mvn test'
            }
        }

        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
            }
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true

                }
            }
        }

        stage("UploadArtifact") {
            steps {
                nexusArtifactUploader(
                nexusVersion: 'nexus3',
                protocol: 'http',
                nexusUrl: '172.31.29.69:8081',
                groupId: 'QA',
                version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                repository: 'vprofile-repo',
                credentialsId: 'nexuslogin',
                artifacts: [
                    [artifactId: 'vproapp',
                    classifier: '',
                    file: 'target/vprofile-v2.war',
                    type: 'war']
                ]
                )
            }
        }
    }
    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#jenkinscicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}
```

PAAC-Analysis-error.Jenkinsfile

```groovy
def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]
pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    
    stages {
        stage('Print error') {
            steps {
                sh 'fake comment'
            }
        }
        stage('Fetch code') {
            steps {
                git branch: 'vp-rem', url: 'https://github.com/devopshydclub/vprofile-project.git'
            }
        }

        stage('Build'){
            steps{
                sh 'mvn install -DskipTests'
            }

            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('Test') {
            steps{
                sh 'mvn test'
            }
        }

        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
            }
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true

                }
            }
        }

        stage("UploadArtifact") {
            steps {
                nexusArtifactUploader(
                nexusVersion: 'nexus3',
                protocol: 'http',
                nexusUrl: '172.31.29.69:8081',
                groupId: 'QA',
                version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                repository: 'vprofile-repo',
                credentialsId: 'nexuslogin',
                artifacts: [
                    [artifactId: 'vproapp',
                    classifier: '',
                    file: 'target/vprofile-v2.war',
                    type: 'war']
                ]
                )
            }
        }
    }
    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#jenkinscicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}
```

PAAC_CI_Docker_ECR.Jenkinsfile

```groovy
pipeline {
    agent any
    tools {
	    maven "MAVEN3"
	    jdk "OracleJDK8"
	}

    environment {
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = "198936756318.dkr.ecr.us-east-1.amazonaws.com/vprofileappimg"
        vprofileRegistry = "https://198936756318.dkr.ecr.us-east-1.amazonaws.com"
    }
  stages {
    stage('Fetch code'){
      steps {
        git branch: 'docker', url: 'https://github.com/devopshydclub/vprofile-project.git'
      }
    }


    stage('Test'){
      steps {
        sh 'mvn test'
      }
    }

    stage ('CODE ANALYSIS WITH CHECKSTYLE'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Analysis Result'
                }
            }
        }

        stage('build && SonarQube analysis') {
            environment {
             scannerHome = tool 'sonar4.7'
          }
            steps {
                withSonarQubeEnv('sonar') {
                 sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }

    stage('Build App Image') {
       steps {
       
         script {
                dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "./Docker-files/app/multistage/")
             }

     }
    
    }

    stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( vprofileRegistry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
     }

  }
}
```

PAAC_CICD_Docker_ECR_ECS+.Jenkinsfile

```groovy
pipeline {
    agent any
    tools {
	    maven "MAVEN3"
	    jdk "OracleJDK8"
	}

    environment {
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = "198936756318.dkr.ecr.us-east-1.amazonaws.com/vprofileappimg"
        vprofileRegistry = "https://198936756318.dkr.ecr.us-east-1.amazonaws.com"
        cluster = "vprofile"
        service = "vprofileappsvc"
    }
  stages {
    stage('Fetch code'){
      steps {
        git branch: 'docker', url: 'https://github.com/devopshydclub/vprofile-project.git'
      }
    }


    stage('Test'){
      steps {
        sh 'mvn test'
      }
    }

    stage ('CODE ANALYSIS WITH CHECKSTYLE'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Analysis Result'
                }
            }
        }

        stage('build && SonarQube analysis') {
            environment {
             scannerHome = tool 'sonar4.7'
          }
            steps {
                withSonarQubeEnv('sonar') {
                 sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }

    stage('Build App Image') {
       steps {
       
         script {
                dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "./Docker-files/app/multistage/")
             }

     }
    
    }

    stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( vprofileRegistry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
      }
     stage('Deploy to ecs') {
          steps {
        withAWS(credentials: 'awscreds', region: 'us-east-1') {
          sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
        }
      }
    }
  }
}
```

jenkins-remote-trigger.txt

```text
http://3.82.20.58:8080/job/Build/build?token=mybuildtoken

Token
admin:1187b3df18e3806824f91771c5ece65b82

Crumb
wget -q --auth-no-challenge --user JENKINS_USER --password JENKINS_PASSWORD --output-document - 'http://3.82.20.58:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'

Jenkins-Crumb:e6434fc7e89a12dfe23e2657ee74addb054b843ad2419d856857f73e925e31dc%

curl -I -X POST 'http://JENKINS_USER:1187b3df18e3806824f91771c5ece65b82@3.82.20.58:8080/job/Build/build?token=mybuildtoken' -H "Jenkins-Crumb:e6434fc7e89a12dfe23e2657ee74addb054b843ad2419d856857f73e925e31dc%"
```

---

## jenkins `ENV` environmental variables

> [Jenkins 2.387.1](https://www.jenkins.io/)

The following variables are available to shell and batch build steps:

- BRANCH_NAME

    For a multibranch project, this will be set to the name of the branch being built, for example in case you wish to deploy to production from `master` but not from feature branches; if corresponding to some kind of change request, the name is generally arbitrary (refer to `CHANGE_ID` and `CHANGE_TARGET`).

- BRANCH_IS_PRIMARY

    For a multibranch project, if the SCM source reports that the branch being built is a primary branch, this will be set to `"true"`; else unset. Some SCM sources may report more than one branch as a primary branch while others may not supply this information.

- CHANGE_ID

    For a multibranch project corresponding to some kind of change request, this will be set to the change ID, such as a pull request number, if supported; else unset.

- CHANGE_URL

    For a multibranch project corresponding to some kind of change request, this will be set to the change URL, if supported; else unset.

- CHANGE_TITLE

    For a multibranch project corresponding to some kind of change request, this will be set to the title of the change, if supported; else unset.

- CHANGE_AUTHOR

    For a multibranch project corresponding to some kind of change request, this will be set to the username of the author of the proposed change, if supported; else unset.

- CHANGE_AUTHOR_DISPLAY_NAME

    For a multibranch project corresponding to some kind of change request, this will be set to the human name of the author, if supported; else unset.

- CHANGE_AUTHOR_EMAIL

    For a multibranch project corresponding to some kind of change request, this will be set to the email address of the author, if supported; else unset.

- CHANGE_TARGET

    For a multibranch project corresponding to some kind of change request, this will be set to the target or base branch to which the change could be merged, if supported; else unset.

- CHANGE_BRANCH

    For a multibranch project corresponding to some kind of change request, this will be set to the name of the actual head on the source control system which may or may not be different from `BRANCH_NAME`. For example in GitHub or Bitbucket this would have the name of the origin branch whereas `BRANCH_NAME` would be something like `PR-24`.

- CHANGE_FORK

    For a multibranch project corresponding to some kind of change request, this will be set to the name of the forked repo if the change originates from one; else unset.

- TAG_NAME

    For a multibranch project corresponding to some kind of tag, this will be set to the name of the tag being built, if supported; else unset.

- TAG_TIMESTAMP

    For a multibranch project corresponding to some kind of tag, this will be set to a timestamp of the tag in milliseconds since Unix epoch, if supported; else unset.

- TAG_UNIXTIME

    For a multibranch project corresponding to some kind of tag, this will be set to a timestamp of the tag in seconds since Unix epoch, if supported; else unset.

- TAG_DATE

    For a multibranch project corresponding to some kind of tag, this will be set to a timestamp in the format as defined by [java.util.Date#toString()](https://docs.oracle.com/javase/7/docs/api/java/util/Date.html#toString()) (e.g., Wed Jan 1 00:00:00 UTC 2020), if supported; else unset.

- JOB_DISPLAY_URL

    URL that will redirect to a Job in a preferred user interface

- RUN_DISPLAY_URL

    URL that will redirect to a Build in a preferred user interface

- RUN_ARTIFACTS_DISPLAY_URL

    URL that will redirect to Artifacts of a Build in a preferred user interface

- RUN_CHANGES_DISPLAY_URL

    URL that will redirect to Changelog of a Build in a preferred user interface

- RUN_TESTS_DISPLAY_URL

    URL that will redirect to Test Results of a Build in a preferred user interface

- CI

    Statically set to the string "true" to indicate a "continuous integration" execution environment.

- BUILD_NUMBER

    The current build number, such as "153".

- BUILD_ID

    The current build ID, identical to BUILD_NUMBER for builds created in 1.597+, but a YYYY-MM-DD_hh-mm-ss timestamp for older builds.

- BUILD_DISPLAY_NAME

    The display name of the current build, which is something like "#153" by default.

- JOB_NAME

    Name of the project of this build, such as "foo" or "foo/bar".

- JOB_BASE_NAME

    Short Name of the project of this build stripping off folder paths, such as "foo" for "bar/foo".

- BUILD_TAG

    String of "jenkins-*${JOB_NAME}*-*${BUILD_NUMBER}*". All forward slashes ("/") in the JOB_NAME are replaced with dashes ("-"). Convenient to put into a resource file, a jar file, etc for easier identification.

- EXECUTOR_NUMBER

    The unique number that identifies the current executor (among executors of the same machine) that’s carrying out this build. This is the number you see in the "build executor status", except that the number starts from 0, not 1.

- NODE_NAME

    Name of the agent if the build is on an agent, or "built-in" if run on the built-in node (or "master" until Jenkins 2.306).

- NODE_LABELS

    Whitespace-separated list of labels that the node is assigned.

- WORKSPACE

    The absolute path of the directory assigned to the build as a workspace.

- WORKSPACE_TMP

    A temporary directory near the workspace that will not be browsable and will not interfere with SCM checkouts. May not initially exist, so be sure to create the directory as needed (e.g., `mkdir -p` on Linux). Not defined when the regular workspace is a drive root.

- JENKINS_HOME

    The absolute path of the directory assigned on the controller file system for Jenkins to store data.

- JENKINS_URL

    Full URL of Jenkins, like `http://server:port/jenkins/` (note: only available if *Jenkins URL* set in system configuration).

- BUILD_URL

    Full URL of this build, like `http://server:port/jenkins/job/foo/15/` (*Jenkins URL* must be set).

- JOB_URL

    Full URL of this job, like `http://server:port/jenkins/job/foo/` (*Jenkins URL* must be set).

- GIT_COMMIT

    The commit hash being checked out.

- GIT_PREVIOUS_COMMIT

    The hash of the commit last built on this branch, if any.

- GIT_PREVIOUS_SUCCESSFUL_COMMIT

    The hash of the commit last successfully built on this branch, if any.

- GIT_BRANCH

    The remote branch name, if any.

- GIT_LOCAL_BRANCH

    The local branch name being checked out, if applicable.

- GIT_CHECKOUT_DIR

    The directory that the repository will be checked out to. This contains the value set in Checkout to a sub-directory, if used.

- GIT_URL

    The remote URL. If there are multiple, will be `GIT_URL_1`, `GIT_URL_2`, etc.

- GIT_COMMITTER_NAME

    The configured Git committer name, if any, that will be used for FUTURE commits from the current workspace. It is read from the **Global Config user.name Value** field of the Jenkins **Configure System** page.

- GIT_AUTHOR_NAME

    The configured Git author name, if any, that will be used for FUTURE commits from the current workspace. It is read from the **Global Config user.name Value** field of the Jenkins **Configure System** page.

- GIT_COMMITTER_EMAIL

    The configured Git committer email, if any, that will be used for FUTURE commits from the current workspace. It is read from the **Global Config user.email Value** field of the Jenkins **Configure System** page.

- GIT_AUTHOR_EMAIL

    The configured Git author email, if any, that will be used for FUTURE commits from the current workspace. It is read from the **Global Config user.email Value** field of the Jenkins **Configure System** page.
