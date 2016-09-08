#!/bin/bash

rails_vars() {
    export SECRET_KEY_BASE=$(echo "${1}" | sha256sum | cut -f 1 -d '-' | awk '{gsub(/^ +| +$/,"")} {print $0}')
    export RAILS_ENV='production'
}

setup_env() {
    source $HOME/.rvm/scripts/rvm
    rvm use default
    cd $HOME/engine
    bundle exec ruby config/container_init.rb
    rails_vars
    bin/rake assets:precompile
}

run_rails() {
    setup_env
    bundle exec rails s Puma -b 0.0.0.0
}

! [ $# -eq 0 ] && exec $@ || run_rails
