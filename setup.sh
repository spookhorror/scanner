#!/bin/bash
#nothing

apt install golang-go
apt-get update
apt-get install sublist3r
apt-get install subfinder
wget https://github.com/Findomain/Findomain/releases/download/8.1.1/findomain-linux.zip
mkdir findomain
mv finddomain-linux.zip findomain/
unzip finddomain/finddomain-linux.zip
mv finddomain/finddomain /usr/bin/
rm -rf findomain
wget "https://github.com/projectdiscovery/notify/releases/download/v1.0.1/notify_1.0.1_linux_amd64.zip"
unzip "notify_1.0.1_linux_amd64.zip"
mv notify /usr/bin/
wget "https://github.com/projectdiscovery/httpx/releases/download/v1.2.0/httpx_1.2.0_linux_amd64.zip"
unzip "httpx_1.2.0_linux_amd64.zip"
mv httpx /usr/bin/
git clone "https://github.com/tomnomnom/waybackurls.git"
cd waybackurls
go install github.com/tomnomnom/waybackurls@latest
go mod init github.com/tomnomnom/waybackurls
go mod tidy
go build
mv waybackurls /usr/bin/waybackurl
git clone "https://github.com/tomnomnom/gf.git"
git clone "https://github.com/1ndianl33t/Gf-Patterns.git"
cd gf
go install github.com/tomnomnom/gf@latest
go mod init github.com/tomnomnom/gf
go mod tidy
go build
mv gf /usr/bin/
cd examples/
mkdir ~/.gf/
mv * ~/.gf/
cd ../../
cd Gf-Patterns 
mv * ~/.gf/
cd ../
git clone "https://github.com/LukaSikic/subzy.git"
cd subzy
go mod init github.com/lukasikic/subzy
go mod tidy
go build
mv subzy /usr/bin/
