/**
 * Generated On: 2015-7-17
 * Class: Request
 */

function Request(request, proc) {

    proc = proc || {};

    var that = {};

    proc.request = request || null;


    /**
     */
    var getSourceIP = function () {

        //TODO: Implement Me

    };


    /**
     */
    var getSourceMAC = function () {
        //TODO: Implement Me 

    };


    /**
     */
    var getQuery = function () {
        //TODO: Implement Me 

    };


    /**
     */
    var getParams = function () {
        //TODO: Implement Me 

    };

    /**
     * Returns the request's body object.
     *
     * @returns { Object }
     */
    var getBody  = function () {

        return proc.request.body;

    };

    that.getSourceIP  = getSourceIP;
    that.getSourceMAC = getSourceMAC;
    that.getQuery     = getQuery;
    that.getParams    = getParams;
    that.getBody = getBody;

    return that;

}


module.exports = {Request: Request};