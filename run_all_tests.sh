#! /bin/bash -xe
#
# Run the test with Puppet 4, 5 and 6
#

docker run --rm -v $(pwd):/t -e PUPPET_GEM_VERSION=' ~> 4.0' -e TARGET='/t' ruby:2.3  stdbuf -oL -eL /t/run_tests.sh
docker run --rm -v $(pwd):/t -e PUPPET_GEM_VERSION=' ~> 5.0' -e TARGET='/t' ruby:2.4  stdbuf -oL -eL /t/run_tests.sh
docker run --rm -v $(pwd):/t -e PUPPET_GEM_VERSION=' ~> 6.0' -e TARGET='/t' ruby:2.5  stdbuf -oL -eL /t/run_tests.sh
