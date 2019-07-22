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

module.exports.info  = 'prime factorization';


let bc, contx;
let account_array;
let num;
let count;

module.exports.init = function(blockchain, context, args) {
    // const open = require('./open.js');
    bc       = blockchain;
    contx    = context;
    if (!args.hasOwnProperty('num')) {
        return Promise.reject(new Error('prime - \'num\' is missed in the arguments'));
    }

    if (!args.hasOwnProperty('count')) {
        return Promise.reject(new Error('prime - \'count\' is missed in the arguments'));
    }
    num = args.num
    count = args.count 
    // account_array = open.account_array;

    return Promise.resolve();
};

module.exports.run = function() {
    // const acc  = account_array[Math.floor(Math.random()*(account_array.length))];

    if (bc.bcType === 'fabric-ccp') {
        let args = {
            chaincodeFunction: 'prime',
            chaincodeArguments: [num.toString(), count.toString()],
        };

        // console.log("sending " + args.toString());

        return bc.invokeSmartContract(contx, 'cpu', 'v0', args, 10);
    } else {
        // NOTE: the query API is not consistent with the invoke API
        return bc.queryState(contx, 'cpu', 'v0', acc);
    }
};

module.exports.end = function() {
    // do nothing
    return Promise.resolve();
};
