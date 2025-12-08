#!/bin/bash
docker stop weldyapp || true
docker rm weldyapp || true
docker pull weldyy/weldyproject4:latest
docker run -d --restart unless-stopped --name weldyapp -p 80:80 weldyy/weldyproject4:latest
