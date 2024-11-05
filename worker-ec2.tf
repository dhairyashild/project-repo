resource "aws_instance" "worker-ec2" {
  ami           = data.aws_ami.example.id
  instance_type = var.instance_type_worker
  key_name      = "killi"

  vpc_security_group_ids = [aws_security_group.worker_sg.id]
  subnet_id              = module.vpc.public_subnets[0]

  user_data = <<-EOF
#!/bin/bash

# Update package lists
sudo apt-get update -y
#Create any server with at least minimum of 2 GB of RAM
#Install Java
# Create the SonarQube directory if it doesn't exist
sudo mkdir -p /opt/sonarqube

# Install Java
sudo apt-get install openjdk-17-jdk -y

# Download SonarQube zip file
cd /opt/sonarqube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.4.87374.zip

# Install unzip utility
sudo apt-get install unzip -y

# Unzip SonarQube zip file
sudo unzip sonarqube-9.9.4.87374.zip
# Remove the zip file after extraction
rm sonarqube-9.9.4.87374.zip

# Now remember, SonarQube cannot be started with the root user. Let's create the SONARADMIN user to run SonarQube.
# Create the sonaradmin user
sudo useradd -s /bin/bash sonaradmin
sudo adduser sonaradmin sonaradmin

# Change ownership of the SonarQube directory and its contents to the sonaradmin user
sudo chown -R sonaradmin:sonaradmin /opt/sonarqube

# Start SonarQube
sudo -u sonaradmin /opt/sonarqube/sonarqube-9.9.4.87374/bin/linux-x86-64/sonar.sh start

# Open port 9000 for SonarQube
# IP:9000

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
aws configure

#Install Docker
sudo apt-get update
sudo apt install docker.io -y
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

# Install kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

#terraform install
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt-get install terraform -y
EOF
}
