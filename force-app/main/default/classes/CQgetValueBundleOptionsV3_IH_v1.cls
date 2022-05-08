public  class CQgetValueBundleOptionsV3_IH_v1 {
    
    public static final String CQ_GET_VALUE_BUNDLE_OPTIONS_V3 = 'CQgetValueBundleOptionsV3';
    //Techmagic - Igor
    public static CQgetValueBundleOptionsV3_Resp_IB_v1 callToCQgetValueBundleOptionsV3(String clientKey) {

        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = new CQgetValueBundleOptionsV3_Resp_IB_v1();

        Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, 
                                                                                                        Sys_Utilities_General.getEnvironment(), 
                                                                                                        CQ_GET_VALUE_BUNDLE_OPTIONS_V3
                                                                                                        );

        //QgetChargesDetailsMaintV9_Req_IB_v1
        CQgetValueBundleOptionsV3_Req_IB_v1 requestBean = CQgetValueBundleOptionsV3_IU_v1.mapRequestFields(clientKey);

        String jsonString = JSON.serialize(requestBean, true);

        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

        HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
        //system.debug('igor response callToCQgetValueBundleOptionsV3---------> ' + response.getBody());

        responseBean = (CQgetValueBundleOptionsV3_Resp_IB_v1) JSON.deserialize(response.getBody(), CQgetValueBundleOptionsV3_Resp_IB_v1.class);
        //System.debug('igor responseBean------> ' + JSON.serialize(responseBean));

        return responseBean;
    }
}