/**
* RESTful API to enable an ASP Device Callback which executes a Device Response Platform Event
* @author  Celliers Inggs
* @created 2020-09-25
*/
@RestResource(urlMapping='/aspDeviceCallback/v01/*')
global Without Sharing class ASPDeviceCallback_ApiRest_v1 {
    /**
    * REST API method that executes a Device Response Platform Event based in the data provided
    *
    * @return String - in JSON format with status code
    */
    @HttpPost
    global static String processDeviceCallback(ASPCallbackInput wrpVals){
        
        return ASPDeviceRequestHelper.UpdateRequest(wrpVals.Object_ID, wrpVals.Metadata, 'COMPLETED');

        /*
        Device_Response__e deviceResponse = new Device_Response__e();
        deviceResponse.Customer_ID__c = wrpVals.Customer_ID;
        deviceResponse.Device_Function__c = wrpVals.Device_Function;
        deviceResponse.Metadata__c = wrpVals.Metadata;
        deviceResponse.Object_ID__c = wrpVals.Object_ID;
        deviceResponse.Username__c = wrpVals.Username;
        
        try{
            Database.SaveResult sr = EventBus.publish(deviceResponse);
            if (sr.isSuccess()) {
    			return 'Success';
            } 
            else {
                string errorResponse = 'Failure: ';
                for(Database.Error err : sr.getErrors()) {
                    errorResponse = errorResponse + err.getStatusCode() + ' - ' + err.getMessage() + '; ';
                }
                return errorResponse;
            }
        }
        catch(DMLException ex){
            throw ex;
        }
        */
    }
}