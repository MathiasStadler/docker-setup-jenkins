# docker setup jenkins

## create script from README.md

```bash
SCRIPT_NAME="readme2script.sh"
rm -rf ${SCRIPT_NAME}
cat << EOF |tee ${SCRIPT_NAME}
#!/bin/bash
if [ -z \${1+x} ]; then printf "set script name that you would extract \n "; exit 1;fi
if [ -z \${2+x} ]; then printf "set source markdown file\n" ;exit 1; fi
if grep -q "\$1" "\$2"; then printf " \$1 exists\n" ; else printf "NOT exists\n"; exit 1 ; fi ;
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
# add work_folder to .gitignore
if grep ${WORK_FOLDER} .gitignore; then echo ok;else echo  ${WORK_FOLDER}>>.gitignore;fi;

# create work_folder if not exits
mkdir -p ${WORK_FOLDER}

# into work_folder
pushd ${WORK_FOLDER}

# git clone Docker official jenkins repo
git clone https://github.com/jenkinsci/docker.git docker_official



```
