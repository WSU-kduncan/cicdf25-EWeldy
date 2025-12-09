# Continous Deployment

## Part 1 - Script a Refresh

1. EC2 Instance Details
    - AMI information
      - This project uses Ubuntu 
    - Instance type
      - t2.medium 
    - Recommended volume size
      - 30 GB volume
    - Security Group configuration
      - SSH on port 22 for specific ips which are my home ip and wsu ip.
      - Port 80 open to everyone for web traffic http
      - Port 9000 for the webhook listener
2. Docker Setup on OS on the EC2 instance
    - How to install Docker for OS on the EC2 instance
      - First run `sudo apt update`
      - Then run `sudo apt install -y docker.io`
      - After docker is installed run `sudo systemctl enable docker` and then `sudo systemctl start docker`
      - After this you might want to add the user to docker by running `sudo usermod -aG docker $USER`
    - To confirom that docker is installed you can run `docker --version`
3. Testing on EC2 Instance
    - How to pull container image from DockerHub repository
      - To pull a container image from DockerHub repo run `docker pull <your-dockerhub-username>/<repository>:<tag>` where you replace the <your-dockerhub-username> with your username, <repoisitory> with the name of your dockerhub repository, and then <tag> with the tag you want to pull.
    - How to run container from image 
      - To run the image run `docker run -it <image>` for the it tag
        - The `-it` tag makes the image interactive meaning you can type command within the container 
      - Run with the -d tag run `docker run -d --restart unless-stopped -p 80:80 <image>`
        - The `-d` tag means that the image container is detached meaning that it runs independently from the terminal. 
    - To verify that the container is serving the web application run `docker ps` and then `curl http://localhost`. You should see that an image is created and should be able to visit the website on the localhost.
4. Scripting Container Application Refresh
    - Description of the bash script
      - The refresh.sh file stops and removes old containers, pulls the latest image from DockerHub, runs the new image in detached mode. 
    - To verify that the script worked run `bash deployment/refresh.sh` and then `docker ps`. You should see a new image.
    - [refresh.sh](deployment/refresh.sh)
