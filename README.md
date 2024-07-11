### Advantage
1. taking advantage to launch container by cli, while allowing to use iptables (in OS level) rather than kernel level (or otherwise use --privileged, which break its security).

### Docker
```bash
# create volume mapping
mkdir ~/qemu-data  

# build and run
sudo docker build -t developercyrus/docker-qemu-ubuntu .
sudo docker run --detach -p 2222:2222 -v ~/qemu-data:/data --name qemu-ubuntu developercyrus/docker-qemu-ubuntu

# troubleshooting
sudo docker logs -f qemu-ubuntu

# subsequent run
sudo docker stop qemu-ubuntu
sudo docker start qemu-ubuntu

# ssh
ssh -p 2222 -i id_rsa ubuntu@localhost


```
