include:
  - postfix

/etc/postfix:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/files/main.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
    - template: jinja
{% if salt['pillar.get']('postfix:manage_master_config', True) %}
/etc/postfix/master.cf:
  file.managed:
    - source: salt://postfix/files/master.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
    - template: jinja
{% endif %}

{%- for domain in salt['pillar.get']('postfix:certificates', {}).keys() %}
postfix_{{ domain }}_ssl_certificate:
  file.managed:
    - name: /etc/postfix/ssl/{{ domain }}.crt
    - makedirs: True
    - contents_pillar: postfix:certificates:{{ domain }}:public_cert
    - watch_in:
       - service: postfix

postfix_{{ domain }}_ssl_key:
  file.managed:
    - name: /etc/postfix/ssl/{{ domain }}.key
    - mode: 600
    - makedirs: True
    - contents_pillar: postfix:certificates:{{ domain }}:private_key
    - watch_in:
       - service: postfix
{% endfor %}

{% if salt['pillar.get']('postfix:config:virtual_uid_maps', '') %}
/etc/postfix/virtual_uid_maps.cf:
  file.managed:
    - source: salt://postfix/files/virtual_uid_maps.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
{% endif %}

{% if salt['pillar.get']('postfix:config:virtual_gid_maps', '') %}
/etc/postfix/virtual_gid_maps.cf:
  file.managed:
    - source: salt://postfix/files/virtual_gid_maps.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
{% endif %}

{% if salt['pillar.get']('postfix:config:virtual_mailbox_domains', '') %}
/etc/postfix/virtual_domain_maps.cf:
  file.managed:
    - source: salt://postfix/files/virtual_domain_maps.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
{% endif %}

{% if salt['pillar.get']('postfix:config:virtual_mailbox_maps', '') %}
/etc/postfix/virtual_mailbox_maps.cf:
  file.managed:
    - source: salt://postfix/files/virtual_mailbox_maps.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
{% endif %}

{% if salt['pillar.get']('postfix:config:virtual_alias_maps', '') %}
/etc/postfix/virtual_alias_maps.cf:
  file.managed:
    - source: salt://postfix/files/virtual_alias_maps.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix
{% endif %}