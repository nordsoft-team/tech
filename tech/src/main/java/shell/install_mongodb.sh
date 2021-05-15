#!/bin/bash

brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
brew services list

mongo -version