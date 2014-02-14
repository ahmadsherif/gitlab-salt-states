clone_gitlab_repo:
  git:
    - latest
    - name: https://gitlab.com/gitlab-org/gitlab-ce.git
    - rev: 6-5-stable
    - target: /home/git/gitlab
    - user: git

{% for config_file in ['config/gitlab.yml', 'config/unicorn.rb', 'config/initializers/rack_attack.rb'] %}
/home/git/gitlab/{{ config_file }}.example:
  file:
    - copy
    - source: /home/git/gitlab/{{ config_file }}
    - user: git
    - require:
      - git: clone_gitlab_repo
{% endfor %}

{% for directory in ['log/', 'tmp/', 'tmp/pids/', 'tmp/sockets/', 'public/uploads'] %}
/home/git/gitlab/{{ directory }}:
  file:
    - directory
    - user: git
    - mode: 700
    - makedirs: True
    - recurse:
        - user
        - mode
    - require:
      - git: clone_gitlab_repo
{% endfor %}

mkdir gitlab-satellites:
  cmd:
    - run
    - cwd: /home/git/gitlab
    - user: git
    - unless: test -d gitlab-satellites
    - require:
      - git: clone_gitlab_repo

/home/git/gitlab/config/database.yml:
  file:
    - copy
    - source: /home/git/gitlab/config/database.yml.postgresql
    - user: git
    - mode: 600
    - require:
      - git: clone_gitlab_repo

install_gems:
  cmd:
    - run
    - name: bundle install --deployment --without development test mysql aws
    - cwd: /home/git/gitlab
    - user: git
    - require:
      - git: clone_gitlab_repo

bundle exec rake gitlab:setup RAILS_ENV=production force=yes:
  cmd:
    - run
    - cwd: /home/git/gitlab
    - user: git
    - require:
      - cmd: install_gems

/etc/init.d/gitlab:
  file:
    - copy
    - source: /home/git/gitlab/lib/support/init.d/gitlab
    - require:
      - git: clone_gitlab_repo

enable_gitlab_service:
  service:
    - running
    - name: gitlab
    - enable: True
    - require:
      - file: /etc/init.d/gitlab

/etc/logrotate.d/gitlab:
  file:
    - copy
    - source: /home/git/gitlab/lib/support/logrotate/gitlab
    - require:
      - git: clone_gitlab_repo

bundle exec rake assets:precompile RAILS_ENV=production:
  cmd:
    - run
    - cwd: /home/git/gitlab
    - user: git
    - require:
      - cmd: install_gems
