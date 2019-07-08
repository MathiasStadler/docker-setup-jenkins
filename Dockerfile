FROM jenkins/jenkins:lts

USER jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY jenkins-config/plugins.txt /usr/share/jenkins/ref/

COPY jenkins-config/security.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY jenkins-config/local.groovy /usr/share/jenkins/ref/init.groovy.d/

ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/casc_configs
COPY jenkins-config/*.yaml /usr/share/jenkins/casc_configs/

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
