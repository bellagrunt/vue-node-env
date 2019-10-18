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

function install_node_env {
  echo "Checking NodeJS Environment"

  if ! hash node; then
    return
  fi

  echo "Installing Node"

  # Node env
  read

  curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
  sudo apt install nodejs

  if hash node; then
    echo "Done Node."
  else
    echo "ERROR: Command line tools not found."
  fi
}

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
### EXAMPLE PROJECT
#####################

# function create_test {
#   projects_directory=~/projects
#   if [ ! -d "$projects_directory" ]; then
#   mkdir "projects_directory"
#   echo "${projects_directory} created successfully"
#   fi
# }

function create_project {
  echo "Creating example project"
  # Ensure project exists
  if ! hash project &> /dev/null; then
  echo "Building project"
  mkdir project
  cd project
  fi

  git init
  echo "Git init"

  touch .gitignore
  echo "node_modules" >> .gitignore

  echo "Downloading dependencies"
  npm init
  # npm install express 
  # npm install bcryptjs 
  # npm install cookie-parser 
  # npm install cors 
  # npm install jsonwebtoken 
  # npm install mongoose 
  cd ..
  # Checks the version
  echo "Project Version: 0.0.1"
}

function create_backend_structure {
  echo "Configuring backend structure"

  cd project
  mkdir Backend
  echo "Created backend"
  cd Backend
  mkdir models
  mkdir controllers
  mkdir routes
  touch index.js
}

function create_index_file {
  echo "Configuring index file"
  echo "const express = require('express');
const app = express();
const cors = require('cors');
const path = require('path');
const cookieParser = require('cookie-parser');
// require("dotenv").config();
require('dotenv').config({
  path: './.env',
});

// cookie parser for auth token
app.use(cookieParser())
// routes
app.use(cors());
const { apiRoutes } = require('./routes/index');

const mongoose = require('mongoose');
const {
  PORT,
  NODE_ENV,
  MONGO_DB_URI,
  DB_NAME,
  DB_NAME_TEST,
} = process.env;

const dbName = NODE_ENV === 'test' ? DB_NAME_TEST : DB_NAME;
mongoose
  .connect(`${MONGO_DB_URI}/${dbName}`, {
    useNewUrlParser: true,
    useCreateIndex: true,
  })
  .then(() => console.log('Connection Successful'))
  .catch(err => console.log(err));

const bodyParser = require('body-parser');
app.use(bodyParser.json());

app.use('/api', apiRoutes);

const staticFileMiddleware = express.static(path.join(__dirname));

app.use(staticFileMiddleware);

app.get('/', function(req, res) {
  res.render(path.join(__dirname + '/index.html'));
});

app.use(
  '/public',
  express.static(path.join(__dirname, '..', 'public')),
);
if (NODE_ENV === 'production') {
  app.use('/', express.static(path.join(__dirname, '..', 'dist')));
}

if (NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`Listening on port ${PORT}`);
  });
}

module.exports = app;

  " >> index.js

}


#####################
### MAIN FUNCTION
#####################
function main {
  HELP
  # VERSION
  # install_node_env
  # install_node
  # create_test
  create_project
  create_backend_structure
  create_index_file
  # install_vue
  # install_yarn
  # install_mongodb

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