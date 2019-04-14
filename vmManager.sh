#!/bin/bash

privateKeyLocation=$HOME'/aws-key.pem'

## Functions ##
function welcome() {
  printf '\n************************************\n'
  printf "** Butcher\'s Encrypted VM Manager **\n"
  printf '*************** v0.1 ***************\n'
}

function init() {
  if [[ ! -f $privateKeyLocation ]]; then
    printf '\nRead failed for default key ['$privateKeyLocation']. Where is your key? '
    read privateKeyLocation
    if [[ ! -f $privateKeyLocation ]]; then
      finishWithError 'Read failed again for custom key location ['$privateKeyLocation']. Please verify.'
    fi
    printf '\n'
  fi

  printf '\e[32m\xE2\x9C\x94 Using AWS private key located at ['$privateKeyLocation']\e[m\n'

  if type 'doctl' &> /dev/null; then
    printf '\e[32m\xE2\x9C\x94 Verified doctl CLI is installed\e[m\n'
  else
    printf '\e[31m\xE2\x9D\x8C DigitalOcean doctl CLI not found on system, please install.\e[m\n'
    finishWithError 'Unmet dependencies'
  fi

  if type 'aws' &> /dev/null; then
    printf '\e[32m\xE2\x9C\x94 Verified AWS CLI is installed\e[m\n'
  else
    printf '\e[31m\xE2\x9D\x8C AWS CLI not found on system, please install.\e[m\n'
    finishWithError 'Unmet dependencies'
  fi
}

function obtain_admin_password() {
  printf '\nObtaining instance administrator password..'

  readonly awsResp=$(aws ec2 get-password-data --instance-id  i-0c1c7ffef02a26dc8 --priv-launch-key $privateKeyLocation)
  readonly b64=$(echo -n $awsResp | base64)
  readonly password=$(node parse-json.js $b64 'PasswordData')
  printf ' obtained and decoded.\n\n'

  printf 'You can now log into your Windows VM using:\n   - Username: Administrator\n   - Password: '$password'\n\n'

  if [[ $OSTYPE == *'darwin'* ]]; then
    echo $password | pbcopy
    printf '\e[32mPassword has been copied to your clipboard.\e[m\n'
  fi
}

function finishWithError() {
  printf '\n\e[31mManager Finished. Exiting abnormally.\n'
  printf "Error: $1.\e[m\n"
  exit 1
}

function finish() {
  printf '\n\e[32mManager Finished. Exiting normally..\e[m\n'
  exit 0
}

## Main ##
welcome
init
obtain_admin_password

#...

finish
