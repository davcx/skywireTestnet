#!/bin/sh

echo "GO installation and configuration"

GOVERSION=go1.14.2.linux-arm64.tar.gz
cd ~
if [ -e $GOVERSION ] ; then
  echo "latest GO already installed"
else
  curl -L https://dl.google.com/go/$GOVERSION -o $GOVERSION

  cd /usr/local/
  if [ -e go ] ; then
    mv go go.old
    echo "old golang moved"
  fi

  tar xzf /root/$GOVERSION

  cd /usr/local/bin
  if [ -e go ] ; then
    rm -f go godoc gofmt

    ln -s /usr/local/go/bin/go /usr/local/bin/go
    ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
    echo "old golink removed"
  fi

  cd ~
  echo 'export GOPATH=/usr/local/skywire/go' >> ~/.bashrc
  source ~/.bashrc

  echo "GO succesfully installed!"
fi

echo "Skywire installation"

add-apt-repository 'deb http://skyfleet.github.io/sky-update stretch main'
curl -L http://skyfleet.github.io/sky-update/KEY.asc | apt-key add -

apt update
apt install skywire

if [ -e /etc/skywire ] ; then
  echo "create visor config file"
  cd /etc/skywire
  skywire-cli visor gen-config
  
  read -p "insert Hypervisor's PubKey", no spaces]?" PubKeyHyp
  read -p "insert Hypervisor's PubKey", no spaces]?" PubKeyIP
  
  #sed -i 's+"enable_auth": false+"enable_auth": true+g' /etc/skywire/skywire-hypervisor.json
  #sed -i 's+"hypervisors": [],+"hypervisors": [{"$PubKeyHyp","$PubKeyIP"}],+g' /etc/skywire/skywire-hypervisor.json2

  systemctl daemon-reload
  systemctl enable skywire-visor.service
  else
      echo "****path config file does not exist***"
      echo "****please check correct pkg installation***"
      
fi








if [ -e $GOPATH/src/github.com/SkycoinProject/skywire ] ; then
  echo "remove old SRC"
  git pull
else

  mkdir -p $GOPATH/src/github.com/SkycoinProject
  cd $GOPATH/src/github.com/SkycoinProject
  git clone https://github.com/SkycoinProject/skywire.git
fi
cd $GOPATH/src/github.com/SkycoinProject/skywire/cmd

go install ./...

echo "Skywire succesfully installed!"

echo "Installing services"

#sh  ~/skywire-installer/servicesUpdate.sh

#cancellare se presente /etc/default/skywire.default
#modificare puntamento a manager
#spostare o verificare path contenente le chiavi $HOME/.skywire 
#SE manager Installare & start of manager unit file on systemd

#cp ${GOPATH}/src/github.com/SkycoinProject/skywire/static/script/upgrade/data/skywire-manager.service /etc/systemd/system/
#systemctl enable skywire-manager
#systemctl start skywire-manager

#Installare   & start of nodes unit file on systemd

#cp ${GOPATH}/src/github.com/SkycoinProject/skywire/static/script/upgrade/data/skywire-node.service /etc/systemd/system/
#systemctl enable skywire-node
#systemctl start skywire-node


