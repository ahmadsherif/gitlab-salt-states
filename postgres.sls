postgres_packages:
  pkg:
    - installed
    - pkgs:
      - postgresql-9.1
      - postgresql-client
      - libpq-dev

gitlab_postgres_user:
  postgres_user:
    - present
    - name: git
    - require:
      - pkg: postgres_packages

gitlab_production_postgres_database:
  postgres_database:
    - present
    - name: gitlabhq_production
    - owner: git
    - require:
      - postgres_user: gitlab_postgres_user
