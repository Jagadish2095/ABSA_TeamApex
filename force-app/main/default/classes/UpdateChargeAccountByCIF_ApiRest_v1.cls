/**
* @description RESTful API to update customer charge account using CIF
* @author Koketso Mpshane
* @date 27/08/2021
* @requestUri: /services/apexrest/UpdateChargeAccountByCIF/v01
* @httpMethods: POST
*/
@RestResource(urlMapping='/UpdateChargeAccountByCIF/v01/*')
global class UpdateChargeAccountByCIF_ApiRest_v1 {

    /**
	* @description request variables wrapper class
	*/
    global class TelebankingRequest{
        /**
	    * @description source system
	    */
        public String sourceSystem {get;set;}
        /**
	    * @description customer CIF
	    */
        public String cifCode {get; set;}
        /**
	    * @description customer account number
	    */
        public String telebankingChargeAccountNumber {get; set;}
    }

    /**
	* @description response variables wrapper class
	*/
    global class ResponseStatus{
        /**
	    * @description is request successful
	    */
        public Boolean isSuccess{ get;set; }
        /**
	    * @description response message
	    */
        public String message { get; set; }
    }

   /**
    * @description POST Method to update customer charge account
    * @return ResponseStatus
    */
    @HttpPost
    global static ResponseStatus updateChargeAccount() {

        ResponseStatus response = new ResponseStatus();

        RestRequest restRqst = RestContext.request;

        String requestBody = restRqst.requestBody.toString();

        TelebankingRequest telebankingRequestReq = (TelebankingRequest)JSON.deserialize(requestBody, TelebankingRequest.class);
        String sourceSystem = telebankingRequestReq.sourceSystem;
        String cifCode = telebankingRequestReq.cifCode;
        String chargeAccount = telebankingRequestReq.telebankingChargeAccountNumber;

        if (String.isBlank(cifCode)) {
            throw new UpdateCustomerException('Required parameter missing: cifCode');
        }

        if (String.isBlank(chargeAccount)) {
            throw new UpdateCustomerException('Required parameter missing: telebankingChargeAccountNumber');
        }

        //Create Request Log
        Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(
            JSON.serialize(RestContext.request.params, true),
            'UpdateCustomerByCIF_ApiRest_v1.updateChargeAccount',
            sourceSystem,
            StringConstants.SALESFORCE_STRING
        );

        try {
            Account customerAccount = [Select Id, Telebanking_Charge_Account_Number__c From Account Where CIF__c =:cifCode Limit 1];

            if (customerAccount != null) {
                customerAccount.Telebanking_Charge_Account_Number__c = chargeAccount;
                update customerAccount;
                response.isSuccess = true;
                response.message = 'Successful';
            } else {
                response.isSuccess = false;
                response.message = 'Client with CIF ' + cifCode +', does not exist on the system';
            }

        }catch(Exception ex){
            response.isSuccess = false;
            response.message = 'Error: ' + ex.getMessage() + ', StackTrace: ' + ex.getStackTraceString();
        }
        return response;
    }

    /**
	* @description Custom Exception
	*/
    public class UpdateCustomerException extends Exception {
    }

}