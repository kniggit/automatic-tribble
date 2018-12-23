# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
ssh-add ~/keys/kniggit.pem
ssh-add ~/keys/us-east-1.pem

# ssh through the defined bastion host
# to an instance using the given EC2 Key
sshp() {
    BASTION_IP=$2
    EC2_KEY=/home/kniggit/keys/us-east-1.pem
    ssh -X -i $EC2_KEY  ec2-user@$1 -o "proxycommand ssh -W %h:%p -i $EC2_KEY ec2-user@$BASTION_IP"
}

# scp a local file to a remote instance that is behind
# a bastion host
scpp() {
    BASTION_IP=$4
    EC2_KEY=/home/kniggit/keys/us-east-1.pem
    scp -i $EC2_KEY -o ProxyCommand="ssh -W %h:%p -i $EC2_KEY ec2-user@$BASTION_IP" $2 ec2-user@$1:$3
}

# Tunnel through a bastion host to port 3000 on the remote
# instance and forward it back locally to port 11001. Great
# for troubleshooting/testing a remote web server
rwebserver() {
    EC2_KEY=/home/kniggit/keys/us-east-1.pem
    BASTION_IP=$2
    REMOTE_SERVER=$1
    ssh -i $EC2_KEY -L 11001:$REMOTE_SERVER:3000 ec2-user@$BASTION_IP
}

