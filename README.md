# sshdeploy

A collection of utilities for deploying websites and executing commands on remote servers.

## Utilities

This package includes several utilities:

- **deployweb**: Website deployment utility for deploying projects to remote servers with Apache configuration
- **runon**: Push files and run commands on remote servers via SSH
- **cdrun**: Change directory and run commands, with support for finding directories by searching for files
- **push-to**: File synchronization utility used by deployweb and runon

## Features

- Automatically finds project root (package.json)
- Builds projects using `pnpm build`
- Syncs files via rsync
- Configures Apache virtual hosts
- Supports multiple ports and HTTPS
- SSH configuration via profiles

## Installation

### From source

```bash
make install
# or with custom prefix
make install PREFIX=/usr
```

### Install symlinks (development)

```bash
make install-symlinks
```

This creates symlinks in `/usr` pointing to files in the project directory. Requires sudo.

### Debian package

```bash
dpkg-buildpackage -b
sudo dpkg -i ../sshdeploy_*.deb
```

## Usage

```bash
deployweb [OPTIONS] PROJECT-DIR
```

### Options

- `-c, --config PROFILE` - Select server profile or config file path
- `-n, --name NAME` - Rename deployment on server
- `-d, --domain DOMAIN` - Set domain (can include port: `domain:PORT`)
- `-p, --port PORT` - Specify HTTP port(s), can be used multiple times
- `--ssl` - Enable HTTPS (automatically enables Apache SSL module)
- `-q, --quiet` - Reduce verbosity
- `-v, --verbose` - Increase verbosity
- `-h, --help` - Show help
- `--version` - Show version

### Examples

Deploy to default profile:
```bash
deployweb /path/to/project
```

Deploy with specific profile and domain:
```bash
deployweb -c production -d example.com /path/to/project
```

Deploy with HTTPS on custom port:
```bash
deployweb -d example.com:8443 --ssl /path/to/project
```

Deploy with multiple HTTP ports:
```bash
deployweb -p 80 -p 8080 -d example.com /path/to/project
```

## Configuration

Profile configuration files are stored in `~/.config/deployweb/`. Each profile is a text file:

```
server: <host[:port]>
wwwdir: <path>
user: <ssh username>
identity_file: <keyfile>
visual_host_key: yes/no
sudo_pw: <password>
options: <apache directory options>
```

### Configuration Options

- `server` - Server hostname/IP, optionally with port
- `wwwdir` - Base directory for website deployments
- `user` - SSH username (optional)
- `identity_file` - SSH private key path (optional)
- `visual_host_key` - SSH host key verification: yes/no (optional)
- `sudo_pw` - Sudo password for remote commands (optional, uses `sudo -A`)
- `options` - Apache Directory options (optional, defaults to `-Indexes +FollowSymLinks`)

### Example Profile

Create `~/.config/deployweb/production`:

```
server: myserver.com:22
wwwdir: /var/www
user: deploy
identity_file: ~/.ssh/deploy_key
visual_host_key: yes
```

## Workflow

1. Finds project root by searching for `package.json`
2. Builds project using `pnpm build`
3. Rsyncs `dist/` directory to server
4. Enables Apache SSL module (if `--ssl` is specified)
5. Generates Apache virtual host configuration
6. Enables site and reloads Apache

## runon

Remote command execution utility that pushes files and runs commands on remote servers.

### Usage

```bash
runon [OPTIONS] [COMMAND...]
```

### Options

- `-h, --host HOST` - Remote host
- `-p, --port PORT` - SSH port (default: 22)
- `-u, --user USER` - Remote user
- `-P, --password PASS` - SSH password
- `-i, --identity FILE` - SSH identity file
- `-d, --dir DIR` - Remote directory
- `-X, --no-x11` - Disable X11 forwarding
- `-q, --quiet` - Reduce verbosity
- `-v, --verbose` - Increase verbosity
- `-h, --help` - Show help
- `--version` - Show version

### Examples

```bash
runon -h myserver.com -u deploy ls -la
runon -h myserver.com -P mypassword "systemctl status nginx"
```

## cdrun

Change directory and run command utility with smart directory finding.

### Usage

```bash
cdrun [OPTIONS] [DIR] COMMAND [ARGS...]
```

### Options

- `-C, --chdir DIR` - Change to specified directory
- `-a, --ancestor FILE` - Find ancestor directory containing FILE
- `-d, --descendant FILE` - Find descendant directory containing FILE
- `--sudo` - Execute with sudo
- `-P, --password PASS` - Sudo password
- `-v, --verbose` - Verbose output
- `-q, --quiet` - Quiet output
- `-h, --help` - Show help
- `--version` - Show version

### Examples

```bash
cdrun /var/www ls -la
cdrun -a package.json npm install
cdrun -d Makefile make
cdrun --sudo /etc systemctl status nginx
```

## push-to

File synchronization utility used internally by deployweb and runon. Syncs local files to remote servers via rsync over SSH.

## Requirements

- bash
- pnpm (for deployweb)
- rsync
- openssh-client
- apache2 (on remote server for deployweb)
- sudo access (on remote server for deployweb)

## Bash Completion

Bash completion is automatically installed with the package. To enable manually:

```bash
source /etc/bash_completion.d/deployweb
```

Or add to `~/.bashrc`:

```bash
source /etc/bash_completion.d/deployweb
```

## License

GPL - GNU General Public License

## Author

Lenik <sshdeploy@bodz.net>

Copyright (C) 2025 Lenik

