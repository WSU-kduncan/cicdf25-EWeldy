## Projects 4 & 5 for CEG3120

# Repository Summary
- [.github/workflows folder](.github/workflows)
  - This folder contains the github actions yml file that builds and pushes docker images.
- [Deployment folder](deployment)
  - This folder contains the following files for deployment
    - `hooks.json` - This is the config file `adnanh's webhook' which defines which actions should trigger when a payload in recieved.
    - `refresh.sh` - This bash script automates refreshing for the Docker container when a new Docker image is recieved.
    - `weldy-webhook.service` - This service file manages the webhook listener.  
- [web-content folder](web-content)
  - This folder contains the following files:
    - `index.html` - This html file contains code to serve as a basic index page.
    - `about.html` - This html file contains code that gives a basic idea of what the page is about.
    - `styles.css` - This css file contains code that is used to style the index and about pages.  
- [Dockerfile](Dockerfile)
  - This is a code that is used to build Docker images
- [README-CI.md](REAMDE-CI.md)
- [README-CD.md](README-CD.md)
