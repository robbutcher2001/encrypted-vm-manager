#!/bin/bash

## Functions ##
function init() {
  printf '\n************************************\n'
  printf "** Butcher\'s Encrypted VM Manager **\n"
  printf '*************** v0.1 ***************\n\n'
  echo $1
}

function obtain_admin_password() {
  printf 'Obtaining instance administrator password..'

  readonly awsResp=$(aws ec2 get-password-data --instance-id  i-0c1c7ffef02a26dc8 --priv-launch-key ~/robs-mpb-aws.pem)
  readonly b64=$(echo -n $awsResp | base64)
  readonly password=$(node parse-json.js $b64 'PasswordData')
  printf 'obtained and decoded.\n\n'

  printf 'You can now log into your Windows VM using:\n   - Username: Administrator\n   - Password: '$password'\n\n'

  if [[ $OSTYPE == *'darwin'* ]]; then
    echo $password | pbcopy
    printf "\e[32mPassword has been copied to your clipboard.\e[m\n"
  fi
}

## Main ##
init 'hello world'

printf 'Hit enter to close.'
read done
exit 0
