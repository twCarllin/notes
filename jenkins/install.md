
# Install jenkin on Ubuntu 16.04
 - sudo apt install openjdk-8-jre-headless
 - wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
 - echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
 - sudo apt-get update
 - sudo apt-get install jenkins

# Check jenkins status
 - sudo systemctl status jenkins

