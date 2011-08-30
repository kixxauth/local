# Connect
#  Get the domain name from the control panel.
ssh -i .ssh/kixxauth.pem ec2-user@ec2-50-19-176-253.compute-1.amazonaws.com

# Connect to ubuntu machine
ssh -i .ssh/kixxauth.pem ubuntu@ec2-50-19-176-253.compute-1.amazonaws.com

# Ubuntu install
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get autoremove --fix-missing --assume-yes
sudo apt-get install build-essential
sudo apt-get install libssl-dev

# Nave (not used anymore)
# wget https://raw.github.com/isaacs/nave/master/nave.sh
# Reboot from the admin panel then install node with nave

wget 'http://nodejs.org/dist/node-v0.4.11.tar.gz'
tar -xzvf node-v0.4.11.tar.gz
cd node-v0.4.11/
sudo make
sudo make install

# Starting the server
sudo nohup "<command>" "<args>" > out.log 2> err.log &
