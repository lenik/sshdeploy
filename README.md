# deployweb

Website deployment utility for deploying projects to remote servers with Apache configuration.

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
sudo dpkg -i ../deployweb_*.deb
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

## Requirements

- bash
- pnpm
- rsync
- openssh-client
- apache2 (on remote server)
- sudo access on remote server

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

Lenik <deployweb@bodz.net>

Copyright (C) 2025 Lenik

