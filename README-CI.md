# Project 4 - Continuous Integration

## Project Overview

- The goal of this project is to automate the process of building images as well as keep a record of docker images rather than constantly overriding them with the latest tag.
- Another goal of this project is to ensure that we can build a web app with any version of a container image.

## Tools Used in This Project

- GitHub Actions - Automates CI to build and push docker images
- Docker - Used to build container images.
- DockerHub - Used to store container images.
- Semantic Versioning - Used to define different version of a docker image.
- Repository Secrets - Securely passes the DockerHub credentials such as Docker username and PAT code to GitHub Actions.

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

    I --> J[Docker Build-Push Action<br/>Builds Image Using Dockerfile<br/>web-content/Dockerfile]

    J --> K[Push Image to DockerHub<br/>Repository: weldyy/weldyproject4]

    K --> L[Versioned Images Available<br/>Pullable by Any Deployment System]


## Part 1 - Create a Docker container image




