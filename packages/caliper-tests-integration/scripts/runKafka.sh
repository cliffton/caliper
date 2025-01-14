#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Set ARCH
ARCH=`uname -m`

# Grab the parent (root) directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Switch into the integration tests directory to access required npm run commands
cd "${DIR}"

function cleanup {
    echo "cleaning up from ${DIR}"
    npm run stop_verdaccio
    rm -rf ./pm2
    rm -rf ./scripts/storage
    rm -rf ${HOME}/.config/verdaccio
    rm -rf ${HOME}/.npmrc
    echo "cleanup complete"
}

# Delete any existing configuration.
cleanup

# Barf if we don't recognize this test adaptor.
if [ "${BENCHMARK}" = "" ]; then
    echo You must set BENCHMARK to one of the desired test adaptors 'composer|fabric-ccp'
    echo For example:
    echo  export BENCHMARK=fabric-ccp
    exit 1
fi

# Verdaccio server requires a dummy user if publishing via npm
echo '//localhost:4873/:_authToken="foo"' > ${HOME}/.npmrc
echo fetch-retries=10 >> ${HOME}/.npmrc
export npm_config_registry=http://localhost:4873

# Start npm server and publish latest packages to it
npm run setup_verdaccio


# export CALIPER_FABRICCCP_SKIPCREATECHANNEL_MYCHANNEL=true

# Run benchmark adaptor
if [ "${BENCHMARK}" == "composer" ]; then
    caliper benchmark run -c benchmark/composer/config.yaml -n network/fabric-v1.3/2org1peercouchdb/composer.json -w ../caliper-samples/
    rc=$?
    cleanup
    exit $rc;
elif [ "${BENCHMARK}" == "fabric-ccp" ]; then
    # Run with channel creation using a createChannelTx in couchDB
    # caliper benchmark run -c benchmark/simple/config.yaml -n network/fabric-v1.4/2org1peercouchdb/fabric-ccp-node.yaml -w ../caliper-samples/
    caliper benchmark run -c benchmark/simple/config.yaml -n network/fabric-v1.4/kafka/fabric-ccp-node.yaml -w ../caliper-samples/
    rc=$?
    if [[ $rc != 0 ]]; then
        cleanup
        exit $rc;
    else
        # Run with channel creation using a tx file in LevelDB
        # caliper benchmark run -c benchmark/simple/config.yaml -n network/fabric-v1.4/2org1peergoleveldb/fabric-ccp-go.yaml -w ../caliper-samples/
        rc=$?
        cleanup
        exit $rc;
    fi
else
    echo "Unknown target benchmark ${BENCHMARK}"
    cleanup
    exit 1
fi
