{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}
include:
  - makina-states.services.http.nginx
  - makina-states.services.monitoring.circus

{% import "makina-states/services/monitoring/circus/macros.jinja" as circus  with context %}
{% import "makina-states/services/http/nginx/init.sls" as nginx %}
{% set circus_data = {
  'cmd': '{0} frontend/express/app.js'.format(data.node),
  'uid': cfg.user,
  'gid': cfg.group,
  'copy_env': True,
  'working_dir': data.troot,
  'warmup_delay': "10",
  'max_age': 24*60*60} %}
{{ circus.circusAddWatcher("{0}-front".format(cfg.name), 
                           **circus_data) }}
{% set circus_data = {
  'cmd': '{0} api/api.js'.format(data.node),
  'uid': cfg.user,
  'gid': cfg.group,
  'copy_env': True,
  'working_dir': data.troot,
  'warmup_delay': "10",
      'max_age': 24*60*60} %}
{{ circus.circusAddWatcher("{0}-api".format(cfg.name),
                           **circus_data) }}
{{ nginx.virtualhost(domain=data.domain,
                     active=True,
                     doc_root=data.docroot,
                     cfg=cfg,
                     vh_top_source=data.nginx_top,
                     vh_content_source=data.nginx_vhost) }}
echo restart:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-restart-hook
      - mc_proxy: circus-pre-restart
