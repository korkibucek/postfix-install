# Mail Server Setup Script for Amazon Linux

This repository contains a Bash script for setting up a basic mail server using Postfix and Dovecot on Amazon Linux. The script installs the required packages, configures Postfix and Dovecot, and sets up a test user.

## Prerequisites

- Amazon Linux instance with root access
- Basic understanding of mail server components and Linux commands

## Features

- Installs Postfix, Dovecot, and mailx (Mail User Agent)
- Backs up original Postfix and Dovecot configurations
- Configures Postfix for basic mail sending and receiving
- Configures Dovecot for IMAP support
- Sets up a test user and Maildir mailbox

## Usage

1. **Clone the Repository**: Clone this repository to your Amazon Linux instance.

    ```bash
    git clone https://github.com/your-repo/mail-server-setup.git
    ```

2. **Navigate to the Directory**: Change to the directory containing the script.

    ```bash
    cd mail-server-setup
    ```

3. **Make the Script Executable**: Run the following command to make the script executable.

    ```bash
    chmod +x setup-mail-server.sh
    ```

4. **Run the Script**: Execute the script as root.

    ```bash
    sudo ./setup-mail-server.sh
    ```

5. **Follow the Prompts**: The script will guide you through the setup process.

## Configuration

Before running the script, you may want to edit the following variables in the script:

- `myhostname`: The hostname for your mail server (default is `mail.example.com`).
- `mydomain`: The domain for your mail server (default is `example.com`).
- `USERNAME`: The username for the test mailbox (default is `your_username_here`).

## Testing

After running the script, you can test the mail server by sending a test email:

```bash
echo "Test email body" | mail -s "Test email subject" your_username_here@example.com

If you encounter issues, check the following:

- Run `systemctl status postfix` and `systemctl status dovecot` to ensure both services are running.
- Check the logs using `journalctl -u postfix` and `journalctl -u dovecot`.
