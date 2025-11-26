# Project 4 - Continuous Integration

## Resources Used
- [Basic HTML page creation](https://www.w3schools.com/html/html_basic.asp)
  - Used bits and pieces of some sections such as the elements, headings, and how to include a css file. I am also doing CEG4110 so I have a really good understanding in how to code websites.
- [Basic CSS Styling](https://www.w3schools.com/css/css_intro.asp)
  - Used bits and pieces of some sections to create a basic styling file for the websites such as margins, colors, padding, font sizes, and text alignment.
- [YML file](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)
  - Used the one they provided and then just modified it so that it met the brief for the project. 
- [Mermaid Diagram](https://docs.mermaidchart.com/mermaid-oss/syntax/flowchart.html#a-node-with-text)
  - Used this file to create my diagram specifically the TD part as my diagram goes Top Down.
    
## Project Overview

- The goal of this project is to automate the process of building images as well as keep a record of docker images rather than constantly overriding them with the latest tag.
- Another goal of this project is to ensure that we can build a web app with any version of a container image.

## Tools Used in This Project

- GitHub Actions - Automates CI to build and push docker images
- Docker - Used to build container images.
- DockerHub - Used to store container images.
- Semantic Versioning - Used to define different version of a docker image.
- Repository Secrets - Securely passes the DockerHub credentials such as Docker username and PAT code to GitHub Actions.

## Part 1 - Create a Docker container image
- The website contents are index.html, about.html, and styles.css
      - index.html can be seen at `http://174.129.6.239/` and code can be found in [Index Page](web-content/index.html)
      - about.html can be seen at `http://174.129.6.239/about.html` and code can be found in [About Page](web-content/about.html)
      - styless.css can be found in [Styling](web-content/styles.css)
   - The Dockerfile uses official Apache server image, built on `httpd:2.4`, copies all content from web-content foloder into the Apache document root.
      - The Dockerfile can be found at [Dockerfile](web-content/Dockerfile) 
   - Instructions to build and push container image to your DockerHub repository
      - First you will want to build an image by running `docker build -t weldyy/project3-site`
      - After this we will push the image by first logging in by running `docker login` and enter your information such as username and Personal Access token (PAT)
      - Now we can push the image by running `docker push weldyy/project3-site`
    
## Part 2 - GitHub Actions and DockerHub
- Creating a Personal Access Token(PAT)
  - First you will want to login to DockerHub
  - Second you will want to navigate as follows Account Settings > Settings > Personal Access Tokens.
  - Third you will want to click Generate new token.
  - Name it whatever you want and give it the permissions that you want it to have.
  - Copy the token so that you have it as you won't be able to access it again.
- Setting up GitHub secrets
  - First you will want to go to settings for the repo that want secrets added to.
  - Second go to the following Secrets and variables > Actions.
  - Click on New repository secret.
  - Create the following secrets.
    - `DOCKER_USERNAME` and give it a value of whatever your DockerHub username is.
    - `DOCKER_TOKEN` and give it the value of the PAT you created from before on DockerHub.  
- CI with GitHub Actions
  - The workflow trigger works when a commit is made to the main branch and only to the main branch.
  - Explanation of workflow steps
    - Downloads the the content
    - Log in to DockerHub using the GitHub secrets
    - Generate a docker image with a tag, most common is latest showing that this is the most up to date image.
    - Builds and pushes the image to DockerHub using the [Dockerfile](web-content/Dockerfile)
  - Values That Must Be Updated for Use in a Different Repository
    - Dockerfile pathway because some might have their Dockefile in a different location then what mine is.
    - Repository secrets because people don't share the same `DOCKER_USERNAME` and `DOCKER_TOKEN`
    - Image id such as mine is `weldyy/weldyproject4` and should be changed to meet the following `dockerusername/dockerrepo`
  - [Workflow file](.github/workflows/weldy-docker.yml)
        - Note - I had to delete and recreate the workflow because I had everything within a Project 4 folder and it was causing issues so I had to delete and move everything around to make things work so there isn't a good history of commits.  
- Testing & Validating
  - Push a tag such as `latest`
  - Visit GitHub Actions and you should see a running workflow.
  - Ensure that it passed and then visit DockerHub to verify that the image is there.
  - To test that the image works you will want to run for example `docker pull weldyy/weldyproject4:latest` and then `docker run -p 8080:80 weldyy/weldyproject4:latest`.
  - Visit `http://localhost:8080` and you should be able to see web app running.
  
## Project Diagram 

```mermaid
flowchart TD

    A[Developer Edits Code<br/>Updates HTML/CSS/Files] --> B[Commit Changes Locally]
    B --> C[Push Commit to GitHub]

    C --> D[Developer Creates Git Tag<br/>ex: v1.0.0]
    D --> E[Tag is Pushed to GitHub]

    E --> F[GitHub Actions Workflow Triggered<br/>on tag push]

    F --> G[Checkout Repository]
    G --> H[Authenticate to DockerHub<br/>Using Secrets]

    H --> I[Docker Metadata Action Generates Tags<br/>latest, major, major.minor]

    I --> J[Docker Build-Push Action<br/>Builds Image Using Dockerfile<br/>Project4/web-content/Dockerfile]

    J --> K[Push Image to DockerHub<br/>Repository: weldyy/weldyproject4]

    K --> L[Versioned Images Available<br/>Pullable by Any Deployment System]

      
      

