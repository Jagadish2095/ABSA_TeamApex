/**
 * @description Integration Handler Bean for CAstpLostStolenCard Service
 * @author Madhava Palla
 * @since 2019-09-17
 * updated by Simangaliso Mathenjwa 1 July 2021
 */
public class CAstpLostStolenCardV2_IH_v5 {
    public static final String INTEGRATION_SERVICE_NAME = 'CAstpLostStolenCardV2';

    /**
     * Added by SMath 26 June 2021
	 * @description method to call CAstpLostStolenCardV2 to Stop/Replace Credit Card for EB.
	 * @param cardDetailsMap
	 * @return CAstpLostStolenCardV2_Resp_IB_v5
	 */
    public static CAstpLostStolenCardV2_Resp_IB_v5 callCAstpLostStolenCard(Map<String, String> cardDetailsMap){

        CAstpLostStolenCardV2_Req_IB_v5 requestBean = CAstpLostStolenCardV2_IU_v5.mapRequest(cardDetailsMap);
        CAstpLostStolenCardV2_Resp_IB_v5 responseBean = (CAstpLostStolenCardV2_Resp_IB_v5) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CAstpLostStolenCardV2_Resp_IB_v5.class);

        return responseBean;
    }

    /**
     * Added by SMath 26 June 2021
	 * @description method to call CAstpLostStolenCardV2 to Stop/Replace Credit Card for EB.
	 * @param jsonStr
	 * @return Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>>
	 */
	public static Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> CAstpLostStolenCardResponseDetails(String jsonStr){
        CAstpLostStolenCardV2_Resp_IB_v5 CAstpLostStolenCardResponse;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> responseMap = new Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>>();
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CA_STP_LOSTSTOLENCARD_V2);
			
            if(integrationSettings != null){
                //Map Request Fields
                StopAndReplaceCardsServiceWrapper serviceWrapper = new StopAndReplaceCardsServiceWrapper();
                
                if(jsonStr != null){
                    serviceWrapper = (StopAndReplaceCardsServiceWrapper)System.JSON.deserialize(jsonStr,StopAndReplaceCardsServiceWrapper.class);
                }
                
                CAstpLostStolenCardV2_Req_IB_v5 CAstpLostStolenCardRequest = CAstpLostStolenCardV2_IU_v5.mapRequestFields(serviceWrapper);//plasticNbr, lsRptRsnCd, lsDt, lsTmOfLoss, lsDtLstUsed, lsPlLstUsed, phnNbrPer, phnNbrBus, distSiteCd, distReasCd, crdIsSgndInd, pinIsSafeInd, advcNoUseInd, circCd, whereLs, howLostLn1, sof1, crdRep, siteCd
                
                String jsonString = CAstpLostStolenCardRequest.serialize( CAstpLostStolenCardRequest );
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
                
                ///Map Response Fields
                CAstpLostStolenCardResponse = CAstpLostStolenCardV2_IU_v5.mapResponseFields(response,serviceWrapper);
                
            }else{
                system.debug('No Integration Settings Found****'+integrationSettings);
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CA_STP_LOSTSTOLENCARD_V2  + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CA_STP_LOSTSTOLENCARD_V2 , StringConstants.CASTPLOSTSTOLENCARDV2_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                CAstpLostStolenCardResponse = CAstpLostStolenCardV2_IU_v5.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            	
            }
        }catch(Exception e){
            //Map bad response and create a log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CA_STP_LOSTSTOLENCARD_V2 , StringConstants.CASTPLOSTSTOLENCARDV2_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            CAstpLostStolenCardResponse = CAstpLostStolenCardV2_IU_v5.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
        }
        if (log != null) {
            logList.add(log);
        }
        responseMap.put(CAstpLostStolenCardResponse, logList);
        return responseMap;
    }

}