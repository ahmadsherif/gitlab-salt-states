nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: nginx
      - file: /etc/nginx/sites-enabled/default
    - watch:
      - file: /etc/nginx/sites-available/gitlab
      - file: /etc/nginx/nginx.conf

/etc/nginx/sites-enabled/default:
  file:
    - absent
    - require:
      - pkg: nginx

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://templates/nginx.conf
    - require:
      - pkg: nginx

/etc/nginx/sites-available/gitlab:
  file:
    - managed
    - source: salt://templates/gitlab_nginx_conf
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/gitlab:
  file:
    - symlink
    - target: /etc/nginx/sites-available/gitlab
    - require:
      - file: /etc/nginx/sites-available/gitlab
