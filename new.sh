#/bin/bash

IMAGE_NAME="wacken/workshop:aspnet-${2}"

case "${1}" in
        --build | -b )  docker build --no-cache --rm -t ${IMAGE_NAME} .
        ;;
        --run | -r ) docker run -d -p 8080:80 -t ${IMAGE_NAME}
        ;;
        --push| -p ) docker push ${IMAGE_NAME}
        ;;
        --help | -h ) printf "usage: ${0} [arg]\n--build,-b\tBuild image\n--run,-r\tRun\n--push,-p\tPush image\n"
                ;;
        --deploy ) STG="${2}" TAG="${3}" kubernetes/kubeYAML.sh | rancher kubectl apply -f -
                ;;
        * ) printf "Print ${0} --help for help\n"
                ;;
esac