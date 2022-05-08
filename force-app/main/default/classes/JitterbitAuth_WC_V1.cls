/**
 * @description A service to authenticate credentials on the Jittebit API Manager.
 */
public class JitterbitAuth_WC_V1 {
	public static final String JITTERBIT_AUTH_PATH2 = 'Jitterbit2 Auth Path';
	public static final String WC_NAME_PREFIX = 'WC ';
    public static final String PROCESSDATA = 'WC ProcessData';
    public static final String ADJUSTEDPAYABLESPAYMENTPERIOD = 'WC AdjustedPayablesPaymentPeriod';
    public static final String ADJUSTEDAVERAGERECEIVABLECOLLECTIONPERIOD = 'WC AdjustedAverageReceivableCollectionPeriod';
    public static final String ADJUSTEDAVERAGEINVENTORYPROCESSSINGPERIOD = 'WC AdjustedAverageInventoryProcesssingPeriod';
    public static final String ADJUSTEDWORKINGCAPITALNEED = 'WC AdjustedWorkingCapitalNeed';
    public static final String WC_TEST_RESPONSE = '{"data":{"response":[]},"adjustedResponseDTO": {"adjAverageInventoryProcesssingPeriod": 0,"adjAverageReceivableCollectionPeriod": 0,"adjWorkingCapitalNeed": 0,"adjPayablesPaymentPeriod": 0},"errors": []}';
    public static final String WC_TEST_TOKEN = '1821929182';
	public static final String AUTH_REQUEST_BODY_FORMAT = 'grant_type=password&client_id={0}&username={1}&password={2}';
	
	public static final String ACCESS_TOKEN = 'access_token';
	public static final String WC_CACHE_ADDRESS = 'local.Customer1Cache.jitterbitAuthToken';
	
    /**
     * @description Get Auth
     * @return String
     */
	public static String getTokenAuthentication() {
		//retrieving Token From Cache
        String accessToken = (String) Cache.Org.get(WC_CACHE_ADDRESS);
		if(!String.isBlank(accessToken)) {
			System.debug('Token retrieved from Cache '+WC_CACHE_ADDRESS);
            return accessToken;
        }
        final Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), JITTERBIT_AUTH_PATH2);
        final Integration_Service__c service = api.Integration_Services__r.get(0);
        
		final String[] credentials = service.Username__c.split('@');        
        final String apiid = credentials[1];
        final String userName = credentials[0];
        final String password = service.Password__c;
        final String baseUrl = api.Base_URL__c;
		final String urlExtension = service.URL_Extension__c;
		final String contentType = service.Content_Type__c;
		final String method = service.Method__c;
		
		final String authRequestBody = String.format(AUTH_REQUEST_BODY_FORMAT, new List<Object>{apiid, userName, password});
		
		HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(baseUrl+urlExtension);
        req.setHeader(StringConstants.CONTENT_TYPE_STRING, contentType);
        req.setTimeout(120000);
        req.setBody(authRequestBody);
        
        Http http = new Http();
        
        if(Test.isRunningTest()) { 
            return WC_TEST_TOKEN; 
        }
        HTTPResponse response= http.send(req);
        String responseJSON = response.getBody();
        final Map<String ,Object> mapOfData = (Map<String,Object>)JSON.deserializeUntyped(responseJSON);
        accessToken = String.valueOf(mapOfData.get(ACCESS_TOKEN));
        //storing Token in Cache
		Cache.Org.put(WC_CACHE_ADDRESS, accessToken, 1500);
        
        return accessToken;
    }
    /*
	* Defining different methods to make the Rest API Callouts
    *
	*/
    /**
     * @description  Defining different methods to make the Rest API Callouts
     * @param apiPath
     * @param requestBody
     * @return String
     */
    public static String getResponseBody(String apiPath, String requestBody){
        final String token = getTokenAuthentication();
        System.debug('String token -> '+token);
        
		final Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), WC_NAME_PREFIX + apiPath);
        final Integration_Service__c service = api.Integration_Services__r.get(0);
        
		final String baseUrl = api.Base_URL__c;
		final String urlExtension = service.URL_Extension__c;
		final String contentType = service.Content_Type__c;
		final String method = service.Method__c;
		
		HttpRequest req = new HttpRequest();
        req.setHeader( 'Authorization', 'Bearer ' + token);
        req.setMethod(method);
        req.setEndpoint(baseUrl+urlExtension);
        req.setHeader(StringConstants.CONTENT_TYPE_STRING, contentType);
        req.setTimeout(120000);
        req.setBody(requestBody);
        
        Http http = new Http();
        if(Test.isRunningTest()) { 
            return WC_TEST_RESPONSE; 
        }
        HTTPResponse response= http.send(req);
        System.debug(response.getBody());
        return response.getBody();
    }
}