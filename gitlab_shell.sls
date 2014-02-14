clone_gitlab_shell:
  cmd:
    - run
    - name: git clone https://gitlab.com/gitlab-org/gitlab-shell.git -b v1.8.0
    - unless: test -d /home/git/gitlab-shell
    - cwd: /home/git
    - user: git
    - require:
      - user: git

copy_config.yml:
  cmd:
    - run
    - name: cp config.yml.example config.yml
    - unless: test -f /home/git/gitlab-shell/config.yml
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - cmd: clone_gitlab_shell

setup_gitlab_shell:
  cmd:
    - run
    - name: ./bin/install
    - cwd: /home/git/gitlab-shell
    - unless: test -d /home/git/repositories # TODO: Can we do better?
    - user: git
    - require:
      - cmd: copy_config.yml
