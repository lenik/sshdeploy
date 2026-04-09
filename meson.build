project(
  'sshdeploy',
  version: run_command(
    'sh', '-c', 'v=$(git describe --tags --always --dirty 2>/dev/null || true); v=${v#v}; [ -n "$v" ] && printf "%s" "$v" || printf "0.0.0"',
    check: false
  ).stdout().strip(),
  meson_version: '>=0.56.0',
)

message('sshdeploy version: ' + meson.project_version())

bindir = get_option('bindir')
man1dir = join_paths(get_option('mandir'), 'man1')
bash_completion_dir = join_paths(
  get_option('datadir'),
  'bash-completion',
  'completions'
)

config = configuration_data()
config.set('VERSION', meson.project_version())
config.set(
  'VER_DT',
  meson.project_version() + ' ' + run_command('date', '-u', '+%Y-%m-%d %H:%M:%S UTC', check: true).stdout().strip()
)
config.set(
  'MAN_DATE',
  run_command('date', '-u', '+%Y-%m-%d', check: true).stdout().strip()
)

configured_scripts = []
foreach script_name : ['cdrun', 'deployweb', 'push-to', 'runon']
  configured_scripts += configure_file(
    input: script_name,
    output: script_name,
    configuration: config,
  )
endforeach

install_data(
  configured_scripts,
  install_dir: bindir,
  install_mode: 'rwxr-xr-x',
)

install_data(
  ['echo-LC_SUDO_PW'],
  install_dir: bindir,
  install_mode: 'rwxr-xr-x',
)

configured_manpages = []
foreach man_name : ['cdrun.1', 'deployweb.1', 'push-to.1', 'runon.1']
  configured_manpages += configure_file(
    input: man_name,
    output: man_name,
    configuration: config,
  )
endforeach

install_data(
  configured_manpages,
  install_dir: man1dir,
  install_mode: 'rw-r--r--',
)

install_data(
  [
    'cdrun.bash-completion',
    'deployweb.bash-completion',
    'push-to.bash-completion',
    'runon.bash-completion',
  ],
  install_dir: bash_completion_dir,
  rename: [
    'cdrun',
    'deployweb',
    'push-to',
    'runon',
  ],
  install_mode: 'rw-r--r--',
)

source_root = meson.project_source_root()

run_target(
  'install-symlinks',
  command: [
    'sh', '-c',
    'set -eu; '
    + 'sudo ln -vsnf "' + source_root + '/cdrun" /usr/bin/cdrun; '
    + 'sudo ln -vsnf "' + source_root + '/cdrun.1" /usr/share/man/man1/cdrun.1; '
    + 'sudo ln -vsnf "' + source_root + '/cdrun.bash-completion" /usr/share/bash-completion/completions/cdrun; '
    + 'sudo ln -vsnf "' + source_root + '/deployweb" /usr/bin/deployweb; '
    + 'sudo ln -vsnf "' + source_root + '/deployweb.1" /usr/share/man/man1/deployweb.1; '
    + 'sudo ln -vsnf "' + source_root + '/deployweb.bash-completion" /usr/share/bash-completion/completions/deployweb; '
    + 'sudo ln -vsnf "' + source_root + '/push-to" /usr/bin/push-to; '
    + 'sudo ln -vsnf "' + source_root + '/push-to.1" /usr/share/man/man1/push-to.1; '
    + 'sudo ln -vsnf "' + source_root + '/push-to.bash-completion" /usr/share/bash-completion/completions/push-to; '
    + 'sudo ln -vsnf "' + source_root + '/runon" /usr/bin/runon; '
    + 'sudo ln -vsnf "' + source_root + '/runon.1" /usr/share/man/man1/runon.1; '
    + 'sudo ln -vsnf "' + source_root + '/runon.bash-completion" /usr/share/bash-completion/completions/runon; '
    + 'sudo ln -vsnf "' + source_root + '/echo-LC_SUDO_PW" /usr/bin/echo-LC_SUDO_PW'
  ]
)

run_target(
  'uninstall-symlinks',
  command: [
    'sh', '-c',
    'set -eu; '
    + 'sudo rm -vf /usr/bin/cdrun; '
    + 'sudo rm -vf /usr/share/man/man1/cdrun.1; '
    + 'sudo rm -vf /usr/share/bash-completion/completions/cdrun; '
    + 'sudo rm -vf /usr/bin/deployweb; '
    + 'sudo rm -vf /usr/share/man/man1/deployweb.1; '
    + 'sudo rm -vf /usr/share/bash-completion/completions/deployweb; '
    + 'sudo rm -vf /usr/bin/push-to; '
    + 'sudo rm -vf /usr/share/man/man1/push-to.1; '
    + 'sudo rm -vf /usr/share/bash-completion/completions/push-to; '
    + 'sudo rm -vf /usr/bin/runon; '
    + 'sudo rm -vf /usr/share/man/man1/runon.1; '
    + 'sudo rm -vf /usr/share/bash-completion/completions/runon; '
    + 'sudo rm -vf /usr/bin/echo-LC_SUDO_PW'
  ]
)
