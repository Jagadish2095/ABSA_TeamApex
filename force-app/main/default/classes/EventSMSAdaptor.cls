/**
* Generic class that is used by process builder to send SMS-es and create related SMS Tasks to the specified whatId
* @author Vladimir Panajic
* @created 2019-05-06
* @description
*/

global class EventSMSAdaptor {
	/**
     * Method invoked by a process which sends an SMS
     *
     * @param requests requests
     * @description
     */
    
    @InvocableMethod
    public static void sendSMS(List<SendSMSRequest> requests) {
    	 //ADDED FOR FACE2FACE
        for(SendSMSRequest SSR : requests){
            	//system.debug(SSR.whoId+' '+SSR.whatId);
            	if(SSR.phoneNumberOverride != null && SSR.phoneNumberOverride != '')
                    dispatchSMS(SSR.whoId, SSR.whatId, SSR.phoneNumberOverride, '', SSR.quickTextName,SSR.integrationService, true);
            	else
                	dispatchSMS(SSR.whoId, SSR.whatId, '', '', SSR.quickTextName,SSR.integrationService, true);

        }
    	//dispatchSMS(requests.get(0).whoId, requests.get(0).whatId, '', '', requests.get(0).quickTextName, requests.get(0).integrationService, true);
    }
    /**
    * @description 
    */
    global class SendSMSRequest {
        @InvocableVariable
        global Id whatId;

        @InvocableVariable
        global Id whoId;
        
        @InvocableVariable
        global String quickTextName;
        
        @InvocableVariable
        global String integrationService;
        
        @InvocableVariable
        global String phoneNumberOverride;
    }
    
    @Future(callout=true)
    @TestVisible private static void dispatchSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
    	SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
    }
}