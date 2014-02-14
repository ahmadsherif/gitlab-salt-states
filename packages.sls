required_pkgs:
  pkg:
    - installed
    - pkgs:
      - git-core
      - build-essential
      - zlib1g-dev
      - libyaml-dev
      - libssl-dev
      - libgdbm-dev
      - libreadline-dev
      - libncurses5-dev
      - libffi-dev
      - curl
      - openssh-server
      - redis-server
      - checkinstall
      - libxml2-dev
      - libxslt1-dev
      - libcurl4-openssl-dev
      - libicu-dev
      - logrotate
    - refresh: True

redis-server:
  service:
    - running
    - enable: True
