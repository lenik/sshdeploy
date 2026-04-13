# sshdeploy

A collection of utilities for deploying websites and executing commands on remote servers.

## Utilities

This package includes several utilities:

- **deployweb**: Website deployment utility for deploying projects to remote servers with Apache configuration
- **runon**: Push files and run commands on remote servers via SSH
- **cdrun**: Change directory and run commands, with support for finding directories by searching for files
- **push-to**: File synchronization utility used by deployweb and runon

## Features

- Automatically finds project root (`package.json`)
- Builds projects using `pnpm build` when `dist/` is missing (or always with `--always`)
- Syncs files via `rsync`
- Configures Apache virtual hosts from one or more `--server` bindings
- Supports mixed HTTP/HTTPS vhosts and per-binding ports
- SSH + deployment configuration via profile files

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

- `-c, --config NAME` - Select profile name or config file path
- `-h, --ssh-host HOST` - SSH host (accepts `host` or `host:port`)
- `-p, --ssh-port PORT` - SSH port
- `-u, --ssh-user USER` - SSH user
- `-i, --ssh-identity FILE` - SSH identity file
- `-V, --ssh-visual-host-key` - Enable SSH visual host key display
- `-P, --ssh-sudo-pw PW` - Sudo password for remote `sudo -A`
- `-n, --server [protocol://]HOST[:PORT]` - Add vhost binding (repeatable)
- `-r, --www-root DIR` - Remote web root (default: `/var/www`)
- `-d, --www-dir DIR` - Deploy subdirectory under `www-root` (default: project name)
- `-C, --conf-name NAME` - Apache site config name (default: basename of `www-dir`)
- `-y, --priority NUM` - Reserved priority option
- `-O, --apache-options OPTS` - Apache `<Directory>` options
- `-B, --always` - Always run build
- `-s, --sync-only` - Sync files only, skip Apache config
- `--dryrun` - Print planned actions without changing remote state
- `-q, --quiet` - Reduce verbosity
- `-v, --verbose` - Increase verbosity
- `--help` - Show help
- `--version` - Show version

### Examples

Deploy to default profile:
```bash
deployweb /path/to/project
```

Deploy with specific profile and server binding:
```bash
deployweb -c production -n example.com /path/to/project
```

Deploy with mixed HTTP/HTTPS bindings:
```bash
deployweb -n example.com -n https://example.com:443 /path/to/project
```

Deploy to custom remote directory, sync only:
```bash
deployweb -r /srv/www -d myapp/current -s /path/to/project
```

## Configuration

Configuration files are stored in `~/.config/deployweb/`. Each profile is a text file:

```
ssh-host: <host>
ssh-port: <port>
user: <ssh username>
identity-file: <keyfile>
visual-host-key: yes/no
sudo-pw: <password>
server: [protocol://]host[:port]   # repeatable
www-root: <path>
www-dir: <path>
conf-name: <apache site name>
apache-options: <apache directory options>
```

### Configuration Options

- `ssh-host` - SSH target host used for rsync/remote commands
- `ssh-port` - SSH port (default: `22`)
- `user` - SSH username (optional)
- `identity-file` - SSH private key path (optional)
- `visual-host-key` - Visual host key setting passed to SSH (optional)
- `sudo-pw` - Sudo password for remote commands (optional, uses `sudo -A`)
- `server` - Vhost binding for Apache (`http://`/`https://` optional, defaults to HTTP)
- `www-root` - Remote base directory (default: `/var/www`)
- `www-dir` - Directory under `www-root` to deploy (default: project name)
- `conf-name` - Apache site config name (default: basename of `www-dir`)
- `apache-options` - Apache `<Directory>` options (optional)

### Example Profile

Create `~/.config/deployweb/production`:

```
ssh-host: myserver.com
ssh-port: 22
user: deploy
identity-file: ~/.ssh/deploy_key
visual-host-key: yes
server: example.com
server: https://www.example.com:443
www-root: /var/www
www-dir: example
conf-name: example
```

## Workflow

1. Finds project root by searching for `package.json`
2. Loads selected profile (or auto-selects one by project name)
3. Builds with `pnpm build` when needed
4. Rsyncs `dist/` to `<www-root>/<www-dir>`
5. Generates Apache virtual host configuration from `--server` bindings
6. Enables required modules/sites and reloads Apache

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

