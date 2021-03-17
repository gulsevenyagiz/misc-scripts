#!/usr/bin/env bash

#
# deloy.sh
# version 1.0 - Yagiz Gulseven
# This script is mostly ShellCheck compliant.
#  
#
#
#
# shellcheck source=/dev/null

#
# Location of folders
#
export readonly DEPLOYMENT_LOCATION=
export readonly WEB_PATH=
readonly SCRIPT_LOCATION=


# Set up logging
function log {
    case "${2}" in
        g)
        COLOR='\033[0;32m'
        ;;
        w)
        COLOR='\033[0;33m'
        ;;
        r)
        COLOR='\033[0;31m'
        ;;
        *)
        COLOR='\033[0m'
        ;;
    esac

    echo -e "${COLOR}" "${1}"
    logger -t "${0}" "${1}"
    printf "\e[0m"
}

## Stop apache
systemctl stop httpd

if [[ $?  -ne 0 ]]
    then
    log "[!!!] Could not stop to be not apache. This state is not supported. Exiting ... " 'r'
fi

# Check if there is already a version deployed. Remove if there is a deployment.

if [[ -d "${WEB_PATH}" ]]
    then
    log "[i] I have found a exsisting deployment, removing the current version." 'y'
    rm -rf "${WEB_PATH}"
    else
    log "[i] There does not seem to be an exsisting deployment." 'g'
fi

log "[i] Moving the deployment to the ${WEB_PATH}" 'g'
mv "${DEPLOYMENT_LOCATION}" "${WEB_PATH}" 
log "[i] Giving the files appropriate permissions" 'g'
chown -R apache:apache "${WEB_PATH}"
chmod 700 "${WEB_PATH}"
log "[i] Starting Apache" 'g'
systemctl start httpd


