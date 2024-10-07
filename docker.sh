# Function to install Docker and Docker Compose on Ubuntu/Debian
install_docker_ubuntu() {
    if lspci | grep -q NVIDIA; then
        if ! nvidia-smi &>/dev/null; then
            echo "NVIDIA GPU detected, but drivers are not installed. Installing drivers !!!"
            sudo apt update
            sudo apt install -y alsa-utils
            sudo ubuntu-drivers autoinstall
            echo "NVIDIA Driver Installed, rebooting the system"
            echo "Please rerun the script after reboot"
            reboot now
        fi
        echo "NVIDIA GPU detected. Installing NVIDIA Docker"
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

        sudo apt-get update
        sudo apt-get install -y nvidia-docker2
        sudo systemctl restart docker
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
        echo "Nvidia Docker and Docker Compose for Ubuntu/Debian have been installed. You may need to log out and back in for group changes to take effect."
    else 
        echo "Installing Docker for Ubuntu/Debian..."
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        sudo apt-get install -y docker-compose
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
        echo "Docker and Docker Compose for Ubuntu/Debian have been installed. You may need to log out and back in for group changes to take effect."