FROM jenkins/jenkins:2.277.2-lts-centos7

# Skip install wizard - don't forget to setup the root URL
# and configure authentication and authorization
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JENKINS_CASC_CONFIG /usr/share/jenkins/casc/casc.yaml

# Add admin user after startup, setup authentication
COPY admin-user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY jenkins.sh /usr/local/bin/jenkins-custom.sh
COPY jenkins.security.QueueItemAuthenticatorConfiguration.xml /var/jenkins_home/

USER root
RUN mkdir -p /usr/share/jenkins/casc
USER jenkins

# Install plugins
RUN /bin/jenkins-plugin-cli -p configuration-as-code:1.47 matrix-auth:2.6.6 authorize-project:1.4.0

VOLUME /var/jenkins_home

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins-custom.sh"]
