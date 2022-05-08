/**
 * @description An integration REST client for the content services.
 * This service integrates with Customer Correspondence services for document generation.
 * This service is currently backed by DocFusion
 *
 * @author Masimba Chingwende
 */
public class CC_ContentService_IH_v1 {
    public static final String GENERATE_CONTENT_PATH = 'CC Generate Content';

    public static CC_GenerateContentResponse generateContent(CC_GenerateContentRequest request) {
        return generateContent(request, true);
    }

    public static CC_GenerateContentResponse generateContent(CC_GenerateContentRequest request, Boolean log) {
        Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), GENERATE_CONTENT_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        String ue = service.URL_Extension__c;
        Map<String, String> headers = new Map<String, String>();

        headers.put('User', UserInfo.getName());
        return (CC_GenerateContentResponse) RestClientUtils.builder() //
            .method(StringConstants.HTTP_POST_STRING) //
            .path(api.Base_URL__c + service.URL_Extension__c) //
            .body(request) //
            .headers(headers) //
            .returnType(CC_GenerateContentResponse.class) //
            .log(log) //
            .invoke();
    }
}