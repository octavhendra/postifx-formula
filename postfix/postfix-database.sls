{% from "postfix/map.jinja" import postfix with context %}

postfix_database:
  pkg.installed:
    - name: {{ postfix.postfix_database }}
