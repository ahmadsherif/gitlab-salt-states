old_rubies:
  pkg:
    - removed
    - pkgs:
      - ruby1.8
      - ruby

salt://scripts/install_ruby:
  cmd:
    - script
    - unless: /usr/local/bin/ruby -v | grep 2\.0\.0p353
    - require_in:
      - gem: bundler

bundler:
  gem.installed
