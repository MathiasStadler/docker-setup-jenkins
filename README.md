# docker setup jenkins

## TL;DR

```bash
# we wont used bash
/bin/bash

# set var for work_folder
WORK_FOLDER="work_folder";

# remove work_folder if exists
if [ -e "${WORK_FOLDER}" ]; then rm -rf ${WORK_FOLDER}; fi;

# create work_folder is nor exists
if ! [ -e "${WORK_FOLDER}" ]; then mkdir ${WORK_FOLDER}; fi;

./readme2script.sh build-docker-images.sh README.md >${WORK_FOLDER}/build-docker-images.sh

chmod +x ${WORK_FOLDER}/build-docker-images.sh

./${WORK_FOLDER}/build-docker-images.sh


```

## create script from README.md

```bash
SCRIPT_NAME="readme2script.sh"
rm -rf ${SCRIPT_NAME}
cat << EOF |tee ${SCRIPT_NAME}
#!/bin/bash
if [ -z \${1+x} ]; then printf "set script name that you would extract \n "; exit 1;fi
if [ -z \${2+x} ]; then printf "set source markdown file\n" ;exit 1; fi
if grep -q "\$1" "\$2"; then printf "" ; else printf "NOT exists\n"; exit 1 ; fi ;
unset SCRIPT
unset SCRIPT_PATH
SCRIPT=\$1;
SCRIPT_PATH="work_folder/\${SCRIPT}"
# printf "SCRIPT => %s \n" "\${SCRIPT}"
expr="/^\\\`\\\`\\\`bash \${SCRIPT}/,/^\\\`\\\`\\\`/{ /^\\\`\\\`\\\`bash.*$/d; /^\\\`\\\`\\\`$/d; p; }"
# printf "Expression %s \n" "\${expr}"
sed -n "\${expr}" "\${2}"
EOF
chmod +x ${SCRIPT_NAME}
```

## build image

```bash build-docker-images.sh
#!/bin/bash

WORK_FOLDER="work_folder";

JENKINS_OFFICIAL="jenkins_official"

JENKINS_VERSION="2.176.1"

# add work_folder to .gitignore
if grep ${WORK_FOLDER} .gitignore; then echo ok;else echo  ${WORK_FOLDER}>>.gitignore;fi;

# git clone Docker official jenkins repo
git clone https://github.com/jenkinsci/docker.git "${WORK_FOLDER}"/"${JENKINS_OFFICIAL}"


# check docker is there
docker info
if [ $? -eq 0 ]; then
    printf "docker OK \n";
else
    printf "docker connect FAIL\n";
    exit 1;
fi

# build docker images
# TODO set JENKINS VERSION
# docker build --build-arg JENKINS_VERSION="${JENKINS_VERSION}" -t jenkins/${JENKINS_VERSION} -f "${WORK_FOLDER}"/"${JENKINS_OFFICIAL}"/Dockerfile  ./"${WORK_FOLDER}"/"${JENKINS_OFFICIAL}"

docker build -t jenkins/${JENKINS_VERSION} -f "${WORK_FOLDER}"/"${JENKINS_OFFICIAL}"/Dockerfile  ./"${WORK_FOLDER}"/"${JENKINS_OFFICIAL}"

```

```bash run-docker-images.sh

# from https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/


-Djenkins.install.runSetupWizard=false

docker container exec -it 360 cat /var/jenkins_home/secrets/initialAdminPassword

https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/

docker swarm init

echo "admin" | docker secret create jenkins-user -
echo "admin" | docker secret create jenkins-pass -

docker stack deploy -c jenkins.yml jenkins



docker stack rm jenkins

docker secret rm jenkins-user

docker secret rm jenkins-pass
docker swarm leave

```

## source

```txt
https://www.manifold.co/blog/arguments-and-variables-in-docker-94746642f64b
```

## docker housekeeping

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
```
