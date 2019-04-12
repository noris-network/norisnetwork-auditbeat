#! /bin/bash -xe
#
# Initialize and run puppet-rspec in ruby docker container. Expect to have to
# current directory mounted on /t and PUPPET_GEM_VERSION variable.
#
# Example :
#
# docker run --rm -v $(pwd):/t -e PUPPET_GEM_VERSION=' ~> 6.0' ruby:2.5  /t/run_tests.sh
#

cd ${TARGET-.}
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "Prepare the environment"

bundle -v
rm -vf Gemfile.lock || true
gem update --system
gem update bundler
gem --version
bundle -v
bundle install --without system_tests

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "Testing with PUPPET_GEM_VERSION=${PUPPET_GEM_VERSION}"
bundle exec rake rubocop
bundle exec rake syntax lint
bundle exec rake metadata_lint
rm -rf spec/fixtures/modules/*
bundle update
bundle exec rake spec
