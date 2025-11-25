# Project 4

## Part 1 - Create a Docker container image

> [!WARNING] 
> If you already did this for project 3, focus on copying your site files and Dockerfile into this new repository and adding the required documentation to your `README-CI.md`.  If you did not complete this part of Project 3, you'll need to complete all the following tasks.

### Tasks

1. In your repository, create a folder named `web-content`.  The files that follow must exist in this folder.

2. Bring **or** create a website with:
   - a minimum of **two** html files (`index` and one other)
   - a minimum of **one** css file

You may use generative AI to create you a site per a theme, but you must **cite** which generative AI system you used and the prompt you fed to it.

3. Create a `Dockerfile` with the following two instructions:
   - Build from `httpd:2.4`
   - Copy all content in `web-content` into the container filesystem in the default web content directory for `httpd` 

4. Build and tag a container image using your `Dockerfile` as the build instructions

5. Login to DockerHub on the command line.  Use a Personal Access Token (PAT) instead of a password.

6. Push your container image to a **public** DockerHub repository in your account.

Recommended: pull your container image and run it to test that it serves your web content.

**Do not forget to add citations of resources used.**

### Documentation

Create `README-CI.md` in root folder of your GitHub repository that details the following:

1. `Dockerfile` & Building Images
    - Explanation and links to web site content
    - Explanation of and link to `Dockerfile`
    - How to build an image from the repository `Dockerfile`
      - Include tagging requirements when planning to use DockerHub for a container image repository
    - How to run a container that will serve the web application from the image built by the `Dockerfile`

## Part 2 - GitHub Actions and DockerHub

### Tasks

1. Create an appropriately scoped Personal Access Token for GitHub Actions to use to access your DockerHub repository

2. In your GitHub repository, configure GitHub Action Secrets named `DOCKER_USERNAME` and `DOCKER_TOKEN` containing your DockerHub username & DockerHub access token, respectively.

3. Set up a GitHub Actions workflow to build and push container images to your DockerHub repository
    - workflow shall trigger when a commit is pushed to the `main` branch (and only the `main` branch)
    - workflow shall utilize **repository secrets for authentication**
    - workflow shall utilize `actions` as opposed to run commands
      - `actions` used should verified by GitHub as an official partner organization *and* should utilize the most up to date action version

### Documentation

In `README-CI.md`, include the following details:

1. Configuring GitHub Repository Secrets:
    - How to create a PAT for authentication (**and** recommended PAT scope for this project)
    - How to set repository Secrets for use by GitHub Actions
    - Describe the Secrets set for this project
2. CI with GitHub Actions
    - Explanation of workflow trigger
    - Explanation of workflow steps
    - Explanation / highlight of values that need updated if used in a different repository
      - changes in workflow
      - changes in repository
    - **Link** to workflow file in your GitHub repository
3. Testing & Validating
    - How to test that your workflow did its tasking
    - How to verify that the image in DockerHub works when a container is run using the image
    - **Link** to your DockerHub repository 

### Resources

- [Docker Docs - CICD with GitHub Actions](https://docs.docker.com/ci-cd/github-actions/)
- [GitHub Actions - build-push-action documentation](https://github.com/marketplace/actions/build-and-push-docker-images)
- [GitHub - publishing images to DockerHub](https://docs.github.com/en/actions/guides/publishing-docker-images#publishing-images-to-docker-hub)

## Part 3 - Semantic Versioning

Up to this point, when you build a new container image, the image is tagged with `latest` - this is a default if no other tag is specified.  This means prior builds are not kept - latest is continuously overwritten and you cannot roll back to an older build.  

To this end, you will start generating `tag`s with `git` based on a `commit`.  To generate a tag for the most recent commit, you can run:
- `git tag -a v*.*.*` (ex. `git tag -a v3.8.1`)

When a new tag is pushed to GitHub, it will trigger your GitHub Action Workflow to collect metadata about the tag version, build the container image, then push the image to DockerHub with 3 tags:
- `latest` (ex. `wsukduncan/s25cats:latest`)
- `major` (ex. `wsukduncan/s25cats:3`)
- `major`.`minor` (ex. `wsukduncan/s25cats:3.8`)

### Tasks

1. Create `git` `tag`s for your `commit`s using [semantic versioning best practices](https://semver.org/)
2. Modify the GitHub Action workflow in your GitHub repository to:
    - trigger when a `tag` is `push` to the repository - no other triggers should be in your final version
    - use the `docker/metadata-action` to generate a set of tags from your repository
    - utilize repository secrets for login authentication to DockerHub
    - build and push container images to DockerHub with image tags based on your `tag` version AND `latest`

DockerHub shall receive the following tags to the container image repository:
  - `latest` (ex. `wsukduncan/s25cats:latest`)
  - `major` (ex. `wsukduncan/s25cats:3`)
  - `major`.`minor` (ex. `wsukduncan/s25cats:3.8`)

### Documentation

Create `README-CD.md` in root folder of your GitHub repository that details the following:

1. Generating `tag`s 
    - How to see tags in a `git` repository
    - How to generate a `tag` in a `git` repository
    - How to push a tag in a `git` repository to GitHub
2. Semantic Versioning Container Images with GitHub Actions
    - Explanation of workflow trigger
    - Explanation of workflow steps
    - Explanation / highlight of values that need updated if used in a different repository
      - changes in workflow
      - changes in repository
    - **Link** to workflow file in your GitHub repository
3. Testing & Validating
    - How to test that your workflow did its tasking
    - How to verify that the image in DockerHub works when a container is run using the image
    - **Link** to your DockerHub repository with evidence of the tag set

### Resources

- [GitHub - docker/metadata-action](https://github.com/docker/metadata-action?tab=readme-ov-file#semver)
- [Docker - Manage Tag Labels](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)

## Part 4 - Project Description & Diagram

Create a diagram (or diagrams) of the continuous integration process configured in this project.  It should (at minimum) address how the developer changing code results in a new image available in a DockerHub container image repository - again, according to the workflow that this project enables.

### Documentation

In `README-CI.md`, **add to the top of the document** the following details:

1. Continuous Integration Project Overview
    - What is the goal of this project
    - What tools are used in this project and what are their roles
    - Diagram of project
    - [If applicable] What is **not working** in this project
2. Resources Section
    - Note: this can be at document top, scattered within document as resources were used, or placed at bottom
    - Add resources used in the project by linking them and making a statement of how it was used.  If generative AI was used, state which platform and what prompts were given and again, a statement of how it was used.

### Resources


## Rubric

[Project Rubric](Rubric.md)
