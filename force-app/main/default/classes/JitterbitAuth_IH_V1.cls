/**
 * @description A service to authenticate credentials on the Jittebit API Manager.
 */
public class JitterbitAuth_IH_V1 {
  
  public static final String JITTERBIT_AUTH_PATH = 'Jitterbit Auth Path';
  public static final String JITTERBIT_AUTH_PATH2 = 'Jitterbit2 Auth Path';

  public static JitterbitAuthResponse authenticate(JitterbitAuthRequest request) {    
    Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT, Sys_Utilities_General.getEnvironment(), JITTERBIT_AUTH_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        RestClientUtils.RequestBuilder builder = RestClientUtils.builder();
        builder.method(StringConstants.HTTP_POST_STRING)//
          .path(api.Base_URL__c + service.URL_Extension__c)//
          .body(request)//
          .returnType(JitterbitAuthResponse.class)//
          .log(false);
        return  (JitterbitAuthResponse) builder.invoke();
  }
  
  public static JitterbitAuthResponse authenticate(String userName, String password, String apiid) {
    JitterbitAuthRequest request = new JitterbitAuthRequest();
    request.userName = userName;
    request.password = password;
    request.apiid = apiid;
    return authenticate(request);
  }
  
  /**
   * @description Uses default username, password, apiid configured for this service to authenticate.
   */
  public static JitterbitAuthResponse authenticate() {
    Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT, Sys_Utilities_General.getEnvironment(), JITTERBIT_AUTH_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        String[] credentials = service.Username__c.split('@');        
    JitterbitAuthRequest request = new JitterbitAuthRequest();
    request.userName = credentials[0];
    request.password = service.Password__c;
    request.apiid = credentials[1];
    return authenticate(request);
  }

  //Authentication to the second jitterbit instance for RB 
  //
  public static JitterbitAuthResponse authenticate2(String userName, String password, String apiid) {
    JitterbitAuthRequest request = new JitterbitAuthRequest();
    request.userName = userName;
    request.password = password;
    request.apiid = apiid;
    return authenticate2(request);
  }

  public static JitterbitAuthResponse authenticate2(JitterbitAuthRequest request) {  
        String req = 'grant_type=password&' + 'username=' + request.userName + '&password=' + request.password + '&client_id=' + request.apiid;
    Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), JITTERBIT_AUTH_PATH2);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        RestClientUtils.RequestBuilder builder = RestClientUtils.builder();
        builder.method(StringConstants.HTTP_POST_STRING)//
          .path(api.Base_URL__c + service.URL_Extension__c)//
          .body(req)//
          .returnType(JitterbitAuthResponse.class)//
          .log(false);
        return  (JitterbitAuthResponse) builder.invoke();
  }

  public static JitterbitAuthResponse authenticate2() {
    Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), JITTERBIT_AUTH_PATH2);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        String[] credentials = service.Username__c.split('@');        
    JitterbitAuthRequest request = new JitterbitAuthRequest();
    request.userName = credentials[0];
    request.password = service.Password__c;
    request.apiid = credentials[1];
    return authenticate2(request);
  }
}