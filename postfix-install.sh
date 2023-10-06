#!/bin/bash

# Update the system
yum update -y

# Install Postfix, Dovecot, and mailx (Mail User Agent)
yum install -y postfix dovecot mailx

# Backup original Postfix and Dovecot configurations
cp /etc/postfix/main.cf /etc/postfix/main.cf.bak
cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.bak

# Configure Postfix
cat <<EOL > /etc/postfix/main.cf
myhostname = mail.example.com
mydomain = example.com
myorigin = \$mydomain
inet_interfaces = all
inet_protocols = ipv4
mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain
mynetworks = 127.0.0.0/8, 10.0.0.0/24
home_mailbox = Maildir/
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = \$myhostname
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
EOL

# Enable and start Postfix
systemctl enable postfix
systemctl start postfix || { echo "Postfix failed to start"; exit 1; }

# Configure Dovecot
cat <<EOL > /etc/dovecot/dovecot.conf
protocols = imap
mail_location = maildir:~/Maildir
auth_mechanisms = plain login
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
EOL

# Enable and start Dovecot
systemctl enable dovecot
systemctl start dovecot || { echo "Dovecot failed to start"; exit 1; }

# Check if user exists, if not create it
USERNAME="your_username_here"
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
else
    useradd "$USERNAME"
    echo "$USERNAME:YourPasswordHere" | chpasswd
fi

# Create Maildir for the user
su - "$USERNAME" -c "mkdir -p ~/Maildir"

# Test the setup
echo "Test email body" | mail -s "Test email subject" "$USERNAME@example.com"

# Output completion message
echo "Postfix and Dovecot have been installed and configured."
