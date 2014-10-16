{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

{% import "makina-states/localsettings/nodejs/prefix/prerequisites.sls" as node with context %}
include:
  - makina-states.localsettings.nodejs

prepreqs-{{cfg.name}}:
  pkg.installed:
    - names:
      - sqlite3
      - libsqlite3-dev
      - build-essential
      - imagemagick
      - apache2-utils

{{cfg.name}}-pull:
  mc_git.latest:
    - user: {{cfg.user}}
    - name: {{data.turl}}
    - target: {{data.troot}}
    - rev: {{data.rev}}
    - watch:
      - pkg: prepreqs-{{cfg.name}}

{{cfg.name}}-dirs:
  file.directory:
    - pkg: prepreqs-{{cfg.name}}
    - watch:
      - mc_git: {{cfg.name}}-pull
    - names:
      - {{data.docroot}}
    - user: {{cfg.user}}
    - group: {{cfg.group}}

{{ node.install(data.node_ver, hash=data.node_hash) }}
npminstall-{{cfg.name}}:
  cmd.run:
    - name: {{data.node}} {{data.npm}} install time
    - cwd: {{data.troot}}
    - use_vt: true
    - user: {{cfg.user}}
    - watch:
      - file: {{cfg.name}}-dirs
