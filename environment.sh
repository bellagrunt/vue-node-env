#! /bin/bash

###########################
### USAGE AND VERSION INFO
###########################
function HELP {
  echo '
USAGE
1. Run the script
2. Restart your shell
3. ???
4. Profit
Sets up a complete development environment using bash.
'
}

# function VERSION {
#   echo "$(cat .env)"
# }


###########################
### INSTALLATION FUNCTIONS
###########################

# function install_node_env {
#   echo "Checking NodeJS Environment"

#   if ! hash node; then
#     return
#   fi

#   echo "Installing Node"

#   # Node env
#   read

#   curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
#   sudo apt install nodejs

#   if hash node; then
#     echo "Done Node."
#   else
#     echo "ERROR: Command line tools not found."
#   fi
# }

function install_mongodb {
  echo "Checking for mongod"

  # Ensure mongodb is installed
  if ! hash mongod &> /dev/null; then
    echo "Installing mongodb"
    sudo apt install software-properties-common dirmngr &> /dev/null
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    sudo add-apt-repository 'deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main'
    sudo apt update
    sudo apt install mongodb-org
  fi

  # Start Mongodb
  sudo systemctl start mongod

  # Enable Mongodb
  sudo systemctl enable mongod

  echo "Mongod Version: "
  mongod --version
}

function install_vue {
  echo "Checking for vue"
  # Ensure vue is installed
  if ! hash vue &> /dev/null; then
    echo "Installing vue"
    sudo npm install -g @vue/cli &> /dev/null
  fi

  echo "Vue Version: "
  vue --version
}

function install_yarn {
  echo "Checking for yarn"
  # Ensure yarn is installed
  if ! hash yarn &> /dev/null; then
  echo "Installing yarn"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update
  sudo apt install yarn
  sudo apt install --no-install-recommends yarn
  fi

  # Checks the version
  echo "Yarn Version: "
  yarn --version
}

#####################
### MAIN FUNCTION
#####################
function main {
  HELP
  # VERSION
  # install_node_env
  # install_node
  install_vue
  install_yarn
  install_mongodb

  echo 'Environment Complete!'
  echo 'Make sure you restart your shell. Now!\n'
}

################
### Parse Opts
################
while getopts ":hv" opt
do
  case $opt in
    h)
      echo -e "\nDevStack Bootstrap Script v$(VERSION)
      $(HELP)
      "
      exit 0
      ;;
    v)
      echo "$(VERSION)"
      exit 0
      ;;
    \?)
      echo ""
      echo "Invalid option: -${OPTARG}" >&2
      HELP
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
   esac
done

main