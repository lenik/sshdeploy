# deployweb and remote sudo password

This document only covers `deployweb`.

`deployweb` executes commands on the remote server over SSH (for example,
Apache configuration and reload actions). Those remote commands may use
`sudo`, which can require the remote user's sudo password.

`sudo_pw` in local profile config can provide that remote sudo password, but
the remote server must be configured to allow non-interactive sudo via
`SUDO_ASKPASS`.

The package also installs `echo-LC_SUDO_PW` to `/usr/bin/echo-LC_SUDO_PW`.

Scope clarification:

- Local machine: stores `sudo_pw` in `~/.config/deployweb/<profile>`.
- Remote server: must be configured in `/etc/sudo.conf` and sudoers for the
  SSH user.

## How `deployweb` uses `sudo_pw`

When `sudo_pw` is set in a profile:

- `deployweb` creates a temporary askpass script on the remote host
- runs sudo as `sudo -A` with:
  - `SUDO_ASKPASS=<remote-temp-script>`
  - `LC_SUDO_PW=<value-from-sudo_pw>`
- removes the temporary askpass script after execution

Auth timing (important):

- Askpass is used during sudo authentication (before sudo succeeds).
- `sudo.conf` `Path askpass ...` is consulted at auth time to locate askpass.
- `env_keep` is about environment preservation after sudo policy processing,
  and is not the primary mechanism for this askpass login flow.

Profile example:

```text
server: your.server.com
wwwdir: /var/www
user: deploy
sudo_pw: yourRemoteSudoPassword
```

Run:

```bash
deployweb -v -c production /path/to/project
```

## Required remote server setup

`sudo -A` still depends on sudo policy. Configure sudoers for the remote
deployment user.

1) On the remote server, open sudoers safely:

```bash
sudo visudo
```

2) On the remote server, configure sudo askpass path in `/etc/sudo.conf`:

```conf
Path askpass /usr/bin/echo-LC_SUDO_PW
```

Debian package note:

- The package `postinst` tries to append this line automatically if no
  `Path askpass ...` line exists.
- If your server already has a custom askpass path, package install keeps the
  existing setting unchanged.

3) Optional compatibility fallback: add sudo rules for your deployment user (example user: `deploy`):

```sudoers
deploy ALL=(ALL) NOPASSWD: /usr/sbin/a2enmod, /usr/sbin/a2ensite, /usr/bin/tee, /usr/bin/systemctl
```

Notes:

- `NOPASSWD` is a compatibility fallback, mainly for environments where
  askpass-based sudo is blocked or unreliable.
- Restrict allowed commands to exactly what deployment needs.

## If you do NOT use NOPASSWD (default)

`sudo_pw` can still work with `sudo -A`, but only if sudo policy accepts
askpass mode for your user and command set. If policy blocks it, deployment
fails with sudo authentication errors.

## Security recommendations

- Prefer narrowly scoped `NOPASSWD` sudoers rules over storing a password.
- If `sudo_pw` is used, keep profile files readable only by your user:

```bash
chmod 600 ~/.config/deployweb/*
```

- Prefer SSH keys for server login.
