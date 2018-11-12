#!/bin/sh
source ./config.conf;

#colors
NC='\033[0m';
GREEN='\033[0;32m';

#variables
RENAME=import_$(date +%F).csv;
CF=0;
DO=0;
RF=0;

#function send email reports
function email() {
  echo $MESSAGE | mail -s "Magento Report" $To;
  echo "Report email sent...";
};

#function for copy new file at server folder 
function copy_file() {
  echo " Copying new file in the server..."
  cp $route/$from/$file $route/$to/
  if [ $? -eq 0 ]; then
    echo "$GREEN  ===> Copy new file in server Successful$NC";
    CF=1;
  else
    echo " x Copy file in server Unuccessful";
  fi
};

#function for delete old file in server www
function delete_oldFile() {
  echo " Removing old file from server..."
  rm $route/$to/$file
  if [ $? -eq 0 ]; then
    echo "$GREEN  ===> Remove file Successful$NC";
    DO=1;
  else
    echo " x Remove file Unuccessful";
  fi
};

#rename old file in the In folder
function rename_file() {
  echo " Change name of file..."
  mv $route/$from/$file $route/$to/$RENAME
  if [ $? -eq 0 ]; then 
    echo "$GREEN  ===> Rename file Successful$NC";
    RF=1;
  else
    echo " x Rename file Unuccessful";
  fi
};

function call_php() {
  echo " ejecutando php scripts";
}

echo " Comprobando archivo en carpeta de origen..."
#find file in the In folder
if [ ! -f $route/$from/$file ]; then
  MESSAGE=" File $file not found";
  echo $MESSAGE
  email $MESSAGE
  exit;
else
  if [ -f $route/$to/$file ]; then
    delete_oldFile
  fi
  copy_file
fi

rename_file

if [[ $CF = 1 && $DO = 1 && $RF = 1 ]]; then
  echo " Executing php script";
  php $script
else
  MESSAGE="it is not possible to execute the php script";
  echo $MESSAGE
  email
  exit;
fi
