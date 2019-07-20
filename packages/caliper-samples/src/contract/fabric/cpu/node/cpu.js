/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';
const shim = require('fabric-shim');
const util = require('util');

const ERROR_SYSTEM = '{"code":300, "location": "%s", "reason": "system error: %s"}';
const ERROR_WRONG_FORMAT = '{"code":301, "location": "%s", "reason": "command format is wrong"}';

/**
 * Generates an {@link ErrorResponse} from the given arguments.
 * @param {String} location Specifies the location of the error.
 * @param {String} formatString The format string of the error.
 * @param {Object[]} params Arbitrary values to pass to the format string.
 * @return {ErrorResponse} The constructed error response.
 */
function getErrorResponse(location, formatString, ...params) {
    return shim.error(Buffer.from(util.format(formatString, location, ...params)));
}

/**
 * Simple money transfer chaincode written in node.js, implementing {@link ChaincodeInterface}.
 * @type {SimpleChaincode}
 * @extends {ChaincodeInterface}
 */
let CpuChaincode = class {
    /**
     * Called during chaincode instantiate and upgrade. This method can be used
     * to initialize asset states.
     * @async
     * @param {ChaincodeStub} stub The chaincode stub is implemented by the fabric-shim
     * library and passed to the {@link ChaincodeInterface} calls by the Hyperledger Fabric platform. The stub
     * encapsulates the APIs between the chaincode implementation and the Fabric peer.
     * @return {Promise<SuccessResponse>} Returns a promise of a response indicating the result of the invocation.
     */
    async Init(stub) {
        return shim.success();
    }

    /**
     * Called throughout the life time of the chaincode to carry out business
     * transaction logic and effect the asset states.
     * The provided functions are the following: open, delete, query, transfer.
     * @async
     * @param {ChaincodeStub} stub The chaincode stub is implemented by the fabric-shim
     * library and passed to the {@link ChaincodeInterface} calls by the Hyperledger Fabric platform. The stub
     * encapsulates the APIs between the chaincode implementation and the Fabric peer.
     * @return {Promise<SuccessResponse | ErrorResponse>} Returns a promise of a response indicating the result of the invocation.
     */
    async Invoke(stub) {
        let funcAndParams = stub.getFunctionAndParameters();

        let method = this[funcAndParams.fcn];
        if (!method) {
            return getErrorResponse('Invoke', ERROR_WRONG_FORMAT);
        }

        try {
            return await method(stub, funcAndParams.params);
        } catch (err) {
            return getErrorResponse('Invoke', ERROR_SYSTEM, err);
        }
    }


    /**
     * Finds prime factors of a given number.
     * @async
     * @param {ChaincodeStub} stub The chaincode stub object.
     * @param {String[]} params The parameter for account deletion. Index 0: account name.
     * @return {Promise<SuccessResponse | ErrorResponse>} Returns a promise of a response indicating the result of the invocation.
     */
    async prime(stub, params) {
        if (params.length !== 1) {
            return getErrorResponse('prime', ERROR_WRONG_FORMAT);
        }

        try {
            let num = parseInt(params[0]);

            for(var x = 0; x <= 100; x++){
                var primeFactors = [];
                while (num % 2 === 0) {
                    primeFactors.push(2);
                    num = num / 2;
                }
                
                var sqrtNum = Math.sqrt(num);
                for (var i = 3; i <= sqrtNum; i++) {
                    while (num % i === 0) {
                        primeFactors.push(i);
                        num = num / i;
                    }
                }

                if (num > 2) {
                    primeFactors.push(num);
                }
            }

            // await stub.putState(params[0], Buffer.from("done"));

        } catch (err) {
            return getErrorResponse('prime', ERROR_SYSTEM, err);
        }

        return shim.success();
    }

    

};

try {
    shim.start(new CpuChaincode());
} catch (err) {
    // eslint-disable-next-line no-console
    console.error(err);
}
