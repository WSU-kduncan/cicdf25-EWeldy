# Continous Deployment

## Project Overview
- The goal of this project is to create a Continous Deployment pipeline that updates docker images and then serves them on an AWS EC2 instance automatically using a bash script, webhook, and webhook service.
- The tools used to create this project are:
    - GitHub Actions
        - This is used to build and push docker images. 
    - DockerHub
        - Used to store docker images. 
    - GitHub Webhooks
        - Used to send a signed payload to the EC2 instance after a successful Action. 
    - adnanh/webhook
        - Listens to the EC2 instance for incoming payloads.
    - systemd (webhook.service)
        - Used to run the webhook as a service. 
    - AWS EC2 Instance
        - Host the running docker container and executes the refresh.sh bash script.
    - refresh.sh
        - A bash script used to pull the latest image from the DockerHub repo, stop and removes the old container, and then creates a new container for the latest image.

## Resources
-

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

## Part 2 - Listen
1. Configuring a `webhook` Listener on EC2 Instance
    - How to install [adnanh's `webhook`](https://github.com/adnanh/webhook) to the EC2 instance
        - First run `sudo apt update` and then run `sudo apt install -y webhook` 
    - To verify that the webhook is installed run `webhook -version`
    - Summary of the `webhook` definition file
        - The file has an `id` of `weldy-refresh` for the webhook endpoint.
        - `execute-command` runs the `refresh.sh` file.
        - The working directory is the deployment folder.
        - When the webhook is successful the output message is `Weldy refresh triggered`
        - The webhook will only work when the secret entered is the webhook secret that was created on github which for this specifically is `Weldy`
        - Uses the validation of `X-Hub-Signature-256`
    - How to verify definition file was loaded by `webhook`
        - To verify the file was loaded by `webhook`, you can run `webhook -hooks /home/ubuntu/deployment/hooks.json -port 9000 -verbose` which will return a message similar to `loaded 1 hook(s) from /home/ubuntu/deployment/hooks.json`
    - To verify that the `webhook` is receiving to trigger it you should see lines of text such as `incoming HTTP request from GitHub` `rule matched` `executing /home/ubuntu/deployment/refresh.sh`, This verifying that the webhook got a payload from GitHub.
      - To monitor logs from running `webhook' run `sudo journalctl -u webhook -f`
      - what to look for in `docker` process views
          - `docker ps` and `docker images` in which you should see a new running container after completing the bash script.
    - [hooks.json](deployment/hooks.json)
2. Configure a `webhook` Service on EC2 Instance
    - The purpose of this file is automatic execution of the webhook. 
    - Summary of `webhook` service file contents
        - Loads the `hooks.json` file that is located in the deployment directory.
        - the service file listens to port 9000.
        - Uses verbose mode so logs show activity.
        - The user is `ubuntu` to avoid execution problems.
        - The working directory is the deployment directory.
    - How to `enable` and `start` the `webhook` service
        - First run `sudo systemctl daemon-reload`
        - After this to `enable` the `webhook` service run `sudo systemctl enable webhook`
        - To `start` the `webhook` service run `sudo systemctl start webhook`  
    - To verify that the `webook` service is capturing payloads and triggering bash script run `sudo systemctl status webhook` and look for something similar to `Active: active (running)`
    - [weldy-webhook.service](deployment/weldy-webhook.service)

## Part 3 - Send a Payload
1. Configuring a Payload Sender
    - I am using GitHub as my Payload Sender because the `webhook` will only trigger when GitHub Actions is successful, Has built in signature verification, and the main thing is that it was easier to understand with the `webhook` section where I just enter my payload URL and then the secret.
    - How to enable `webook` on GitHub
        -  First you will want to go to your desired repo and then go as follows `Settings > Webhooks > Add Webhook`
        -  After finding this you will enter a `Payload URL` for example `http://YOUR-EC2-PUBLIC-IP:9000/hooks/<hooks.json-id>
        -  Then select a content type more than likely `application.json`
        -  Enter your desired Secret
        -  Select was events you want the `webhook to send you`
    - Triggers that will send a payload
        - A GitHub Actions completion
        - A push to the repo
        - A tag push
    - To verify a successful payload delivery you will want to go to your repo and then `GitHub → Webhooks → Recent Deliveries`, you should see checkmarks and workflows complete.
    - To validate that the webhook only triggers when request comes from GitHub you see something similar to `rule match: false – rejecting request` because the listener checks for the Header of `X-Hub-Signature-256` and then the Secret which for my case is `Weldy`, if these do not match then it is rejected.

## Diagram 
```mermaid
flowchart LR
    A[GitHub Repository<br/>Code + Dockerfile] --> B[GitHub Actions<br/>Build & Push Image]
    B --> C[DockerHub Repository<br/>Tagged Images]

    C --> D[GitHub Webhook<br/>Triggered on Push/Tag]
    D --> E[EC2 Instance<br/>Webhook Listener Service]

    E --> F[Bash Refresh Script<br/>Stops Old Container<br/>Pulls New Image<br/>Runs New Container]

    F --> G[Running Application<br/>Updated Container]

    %% Optional: What’s Not Working
    subgraph Issues[If Applicable: Problems]
        H[Webhook Not Triggering<br/>Port Closed / Wrong URL]
        I[EC2 Service Not Starting<br/>systemd Misconfiguration]
        J[DockerHub Pull Fails<br/>Bad Credentials or Tag]
    end

    D -.-> H
    E -.-> I
    C -.-> J
