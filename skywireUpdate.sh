#!/bin/sh

echo "GO installation and configuration"

GOVERSION=go1.13.7.linux-arm64.tar.gz
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
    rm go godoc gofmt

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



