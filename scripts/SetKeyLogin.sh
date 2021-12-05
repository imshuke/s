mkdir ~/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5V6X64Hp4xhfwdLJPaSkuDqydDiydc/lf9HTz6tb6q3CpAShN4+ysbvrPJLF1HrihW2mK34p/OhcC5mt1gCC11Vs4nIT9ODXvmRv9MQE99YZjEPVvSYEKMA/Ho0Gvkb4zQSw6YHj089u2G9BZUPGZCF/rNGHY0XH/WKMxcL22QaKfA5mUxO/SpuHlaXQJqv5whD7g8c2dYQonLVmxrXFrTnf5FA9+LMRnLzoNFoCT+xn5jqgPV5f9s+SctXdvjDsp+yhrPm5DylZJMVoskPOJ6cTYkpnL/vC6OHG87cS0ynN18CxuU4S9ZMlKXmnTy/T2JujJ3OYz5yr49LSeGeVYQ==" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

sed -i "s/^#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/^#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config
sed -i "s/^PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config

service sshd restart
echo "设置完毕!"
