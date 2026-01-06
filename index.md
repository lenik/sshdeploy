# deployweb - Website Deployment Utility

## Overview

`deployweb` is a bash-based utility for automating website deployment to remote servers. It handles the complete deployment workflow from building the project to configuring Apache virtual hosts.

## Project Structure

```
deployweb/
├── deployweb                 # Main script
├── deployweb.1               # Man page
├── deployweb.bash-completion # Bash completion script
├── Makefile                  # Build and install
├── README.md                 # User documentation
├── index.md                  # This file (for Claude)
├── debian/                   # Debian packaging
│   ├── control
│   ├── changelog
│   ├── rules
│   └── compat
└── sample.sh                 # Example script (reference)
```

## Key Components

### Main Script (`deployweb`)

The main deployment script that:
- Parses command-line options using `shlib-import cliboot`
- Finds project root by searching for `package.json`
- Builds project using `pnpm build`
- Deploys files via rsync
- Configures Apache virtual hosts
- Supports multiple ports and HTTPS

### Configuration System

Profiles stored in `~/.config/deployweb/` with format:
```
server: <host[:port]>
wwwdir: <path>
user: <ssh username>
identity_file: <keyfile>
visual_host_key: yes/no
```

### Virtual Host Generation

The `mkvhost()` function generates Apache VirtualHost configurations:
- Supports custom ports (not just 80/443)
- Creates HTTP or HTTPS based on `--ssl` flag
- When ports are specified, creates only one VirtualHost per port
- Defaults to port 80 for HTTP, 443 for HTTPS

### SSH Integration

SSH commands are built using:
- `build_ssh_opts()` - Constructs SSH options from config
- `build_ssh_cmd()` - Builds complete SSH command with user/host
- Supports identity files, custom ports, and host key verification

## Build System

### Makefile Targets

- `make install` - Install to DESTDIR/PREFIX (respects DESTDIR and PREFIX)
- `make install-symlinks` - Create symlinks in /usr (hardcoded, requires sudo)
- `make clean` - Clean build artifacts

### Debian Packaging

The `debian/` directory contains:
- `control` - Package metadata and dependencies
- `changelog` - Version history
- `rules` - Build rules (overrides install to include man page and bash completion)
- `compat` - Debian compatibility level

## Installation Locations

- Binary: `$(PREFIX)/bin/deployweb` (default: `/usr/local/bin`)
- Man page: `$(PREFIX)/share/man/man1/deployweb.1`
- Bash completion: `/etc/bash_completion.d/deployweb`

## Dependencies

- bash
- pnpm (for building projects)
- rsync (for file syncing)
- openssh-client (for SSH connections)
- apache2 (on remote server)
- shlib-import (for option parsing)

## Command-Line Options

- `-c, --config PROFILE` - Profile name or config file path
- `-n, --name NAME` - Rename on server
- `-d, --domain DOMAIN` - Domain (supports `domain:PORT` format)
- `-p, --port PORT` - HTTP port(s), can be multiple
- `--ssl` - Enable HTTPS
- `-q, --quiet` - Reduce verbosity
- `-v, --verbose` - Increase verbosity
- `-h, --help` - Show help
- `--version` - Show version

## Key Functions

1. `find_project_root()` - Searches for package.json
2. `find_first_profile()` - Auto-detects first profile if none specified
3. `load_profile()` - Loads and parses config file
4. `build_project()` - Runs `pnpm build`
5. `deploy_files()` - Rsyncs files to server
6. `mkvhost()` - Generates Apache VirtualHost config
7. `configure_apache()` - Installs and enables Apache config

## Port Handling

- Ports can be specified via `-p/--port` (multiple times)
- Ports can be extracted from domain: `--domain example.com:8080`
- When ports are specified, only one VirtualHost per port (HTTP or HTTPS)
- Default: port 80 for HTTP, 443 for HTTPS with `--ssl`

## Development Notes

- Uses `shlib-import cliboot` for option parsing (similar to `sample.sh`)
- Global variables for SSH config (ssh_user, ssh_identity_file, etc.)
- Temporary files for VirtualHost generation (cleaned up with trap)
- Error handling via `quit` function from cliboot

## Testing

To test the script:
1. Create a test profile in `~/.config/deployweb/test`
2. Create a test project with `package.json` and `pnpm build`
3. Run: `deployweb -c test -d test.example.com /path/to/project`

## Future Enhancements

Potential improvements:
- Support for other build tools (npm, yarn)
- Support for other web servers (nginx)
- Dry-run mode
- Rollback functionality
- Multiple environment support

## Author

Lenik <sshdeploy@bodz.net>

Copyright (C) 2025 Lenik

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

