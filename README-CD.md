# Continous Deployment

## Generating Tags
- To see tags in a git repository you can run `git tag` which will list all tags in the repo.
- To generate a tag in a git repository run `git tag -a v1.0.0` and replace `1.0.0` with whatever version you want and if you want to a message run `git tag -a v1.0.0 -m "Stranger Things Season 5 is coming out."`
- To push a tag run `git push origin v1.0.0` and replace `1.0.0` with whatever version you want. If you have multiple tags created run `git push --tags` which will push all tags.

## Semantic Versioning Container Images with GitHub Actions
- The workflow triggers only when a git tag is pushed with the follow tag of '*.*.*`
- The workflow steps go as follows
  - Pulls all content from web-content
  - Logs in to DockerHub using GitHub secrets
  - Creates tags based on the git tag that goes as follows with the input (v3.8.1)
    - latest
    - major (3)
    - major.minor (3.8)
    - If you wanted you could add a patch section which would be (3.8.1) 
  - After this it builds and pushes the image and tags to DockerHub.
- The following things will need to be updated when used in a different repo.
  - Docker id such as mine is `weldyy/weldyproject4` and you would replace as follows `dockerhubusername/dockerhubrepo` as not all people have the same username and repo name.
  - Pathway to dockerfile to ensure that you are correctly using the right path as not all people have their Dockerfile in the same location.
  - Context of the project root because this can change based off different repos
  - DockerHub credentials such as `DOCKER_USERNAME` and `DOCKER_TOKEN` because not every shares the same username and PAT.
- [YML file](.github/workflows/weldy-docker.yml)

## Testing & Validating
- Push a tag such as `v1.1.0`
  - Visit GitHub Actions and you should see a running workflow.
  - Ensure that it passed and then visit DockerHub to verify that the image is there.
  - You should see 3 different tages which include:
    - latest
    - major
    - major.minor 
  - To test that the image works you will want to run for example `docker pull weldyy/weldyproject4:latest` and then `docker run -p 8080:80 weldyy/weldyproject4:latest`.
  - Visit `http://localhost:8080` and you should be able to see web app running.
  - [DockerHub Repo](https://hub.docker.com/repository/docker/weldyy/weldyproject4/general)
