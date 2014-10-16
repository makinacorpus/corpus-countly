{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
{% set scfg = salt['mc_utils.json_dump'](cfg) %}

{% for i in data.configs %}
{{cfg.name}}-cfg-{{i}}:
  file.managed:
    - name: {{data.troot}}/{{i}}
    - source: salt://makina-projects/{{cfg.name}}/files/{{i}}
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: {{data.get('modes', {}).get(i, '750')}}
    - template: jinja
    - defaults:
        cfg: |
             {{scfg}}
{% endfor %}
