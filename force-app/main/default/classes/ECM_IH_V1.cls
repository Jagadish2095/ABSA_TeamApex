/**
 * Integration handler for ECM services.
 *
 * @author Masimba Chingwende
 *
 * @Modified by Tinashe M Shoko 20-Apr-2021
 */
public class ECM_IH_V1 {
	
	private static final String AUTHENTICATION_PATH = 'ECM Authenication Path';
	private static final String LOGOUT_PATH = 'ECM Logout Path';
	private static final String GET_ITEM_TYPES_PATH = 'ECM GetItemTypes Path';
	private static final String GET_ITEM_TYPE_PATH = 'ECM GetItemType Path';
	private static final String GET_PATH = 'ECM Get Path';
	private static final String ADD_PATH = 'ECM Add Path';
	private static final String QUERY_PATH = 'ECM Query Path';
	
	/**
	 * Logs into the ECM system to obtain a session token.
	 *
	 */
	public static ECM_LoginResult_IB_V1 login(String dataStore, String username, String password) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), AUTHENTICATION_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
		ECM_LoginRequest_IB_V1 request = new ECM_LoginRequest_IB_V1();
		ECM_LoginRequest_IB_V1.LoginRequest loginRequest = new ECM_LoginRequest_IB_V1.LoginRequest();
		loginRequest.Datastore = dataStore;
		loginRequest.UserName = username;
		loginRequest.Password = password;
		request.LoginRequest = loginRequest;
        ECM_LoginResult_IB_V1 response = (ECM_LoginResult_IB_V1) RestClientUtils.invoke(StringConstants.HTTP_PUT_STRING, api.Base_URL__c + service.URL_Extension__c,
        								request, null, null, null, headers, null, null, ECM_LoginResult_IB_V1.class, new ResponseHandler(ECM_LoginResult_IB_V1.class), false);
        return response;
	}

	/**
	 * Logs out an ECM token.
	 * @param token
	 */
	public static ECM_LogoutResult_IB_V1 logout(String token) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), LOGOUT_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
		ECM_LogoutRequest_IB_V1.LogoutRequest logoutRequest = new ECM_LogoutRequest_IB_V1.LogoutRequest();
		logoutRequest.Token = token;
		ECM_logoutRequest_IB_V1 request = new ECM_logoutRequest_IB_V1();
		request.LogoutRequest = logoutRequest;
        ECM_LogoutResult_IB_V1 response = (ECM_LogoutResult_IB_V1) RestClientUtils.invoke(StringConstants.HTTP_PUT_STRING, api.Base_URL__c + service.URL_Extension__c,
        									request, null, null, null, headers, null, null, ECM_LogoutResult_IB_V1.class,  new ResponseHandler(ECM_LogoutResult_IB_V1.class), false);
		return response;
	}

	/**
	 * Fetches ECM ItemTypes that this session is elligible for.
	 * @param token A valid token
	 */
	public static ECM_GetItemTypesResult_IB_V1 getItemTypes(String token) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_ITEM_TYPES_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
		ECM_GetItemTypesRequest_IB_V1.GetItemTypesRequest getItemTypesRequest = new ECM_GetItemTypesRequest_IB_V1.GetItemTypesRequest();
		getItemTypesRequest.token = token;
		ECM_GetItemTypesRequest_IB_V1 request = new ECM_GetItemTypesRequest_IB_V1();
		request.getItemTypesRequest = getItemTypesRequest;
        ECM_GetItemTypesResult_IB_V1 response = (ECM_GetItemTypesResult_IB_V1) RestClientUtils.invoke(StringConstants.HTTP_PUT_STRING, api.Base_URL__c + service.URL_Extension__c,
        							request, null, null, null, headers, null, null, ECM_GetItemTypesResult_IB_V1.class,  new ResponseHandler(ECM_GetItemTypesResult_IB_V1.class), false);
        return response;
	}

	/**
	 * Fetches the details of specific ItemType from the ECM system.
	 * @param token
	 * @param name
	 */
	public static ECM_GetItemTypeResult_IB_V1 getItemType(String token, String name) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_ITEM_TYPE_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
		ECM_GetItemTypeRequest_IB_V1.GetItemTypeRequest getItemTypeRequest = new ECM_GetItemTypeRequest_IB_V1.GetItemTypeRequest();
		getItemTypeRequest.Token = token;
		getItemTypeRequest.ItemType = name;
		ECM_GetItemTypeRequest_IB_V1 request = new ECM_GetItemTypeRequest_IB_V1();
		request.getItemTypeRequest = getItemTypeRequest;
        ECM_GetItemTypeResult_IB_V1 response = (ECM_GetItemTypeResult_IB_V1) RestClientUtils.invoke(StringConstants.HTTP_PUT_STRING, api.Base_URL__c + service.URL_Extension__c,
        										request, null, null, null, headers, null, null, ECM_GetItemTypeResult_IB_V1.class, new ResponseHandler(ECM_GetItemTypeResult_IB_V1.class), false);
		return response;
	}

	/**
	 * Fetches the details of specific document from the ECM system.
	 * @param token
	 * @param name
	 */
	public static ECM_GetResult_IB_V1 getDocument(String token, String pid) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
		ECM_GetRequest_IB_V1.GetRequest getRequest = new ECM_GetRequest_IB_V1.GetRequest();
		getRequest.Token = token;
		getRequest.PID = pid;
		ECM_GetRequest_IB_V1 request = new ECM_GetRequest_IB_V1();
		request.GetRequest = getRequest;
        ECM_GetResult_IB_V1 response = (ECM_GetResult_IB_V1) RestClientUtils.invoke(StringConstants.HTTP_PUT_STRING, api.Base_URL__c + service.URL_Extension__c,
        								request, null, null, null, headers, null, null, ECM_GetResult_IB_V1.class, new ResponseHandler(ECM_GetResult_IB_V1.class), false);
		return response;
	}

    public static ECM_AddResult_IB_V1 addDocument(ECM_AddRequest_IB_V1 request) {
    	Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), ADD_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
        ECM_AddResult_IB_V1 response = (ECM_AddResult_IB_V1) RestClientUtils.invoke(StringConstants.HTTP_POST_STRING, api.Base_URL__c + service.URL_Extension__c,
        								request, null, null, null, headers, null, null, ECM_AddResult_IB_V1.class, new ResponseHandler(ECM_AddResult_IB_V1.class), false);
		return response;
    }

    public static ECM_QueryResult query(ECM_QueryRequest request) {
    	Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = getDefaultAuthHeaders(api);
        ECM_QueryResult response = (ECM_QueryResult) RestClientUtils.invoke(StringConstants.HTTP_PUT_STRING, api.Base_URL__c + service.URL_Extension__c,
        							request, null, null, null, headers, null, null, ECM_QueryResult.class, new ResponseHandler(null, new ECM_QueryResultParser()), false);
		return response;
    }

    public static Map<String, String> getDefaultAuthHeaders(Integration_API__c api) {
		Map<String, String> headers = new Map<String, String>();
		headers.put(StringConstants.X_IBM_CLIENT_ID_STRING, api.Client_ID__c);
        headers.put(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c);
		return headers;
	}

	public static Map<String, String> getCredentials() {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), AUTHENTICATION_PATH);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> credentials = new Map<String, String>();
        String[] usernameStore = service.Username__c.split('@');
        credentials.put('username', usernameStore[0]);
        credentials.put('password', service.Password__c);
        credentials.put('store', usernameStore[1]); //'DGOLSDB');
        return credentials;
	}

	public class ResponseHandler implements RestClientUtils.ResultParser {

		public Type t { get; set; }
		public RestClientUtils.ResultParser delegate { get; set; }

		public ResponseHandler(Type t) {
			this(t, null);
		}

		public ResponseHandler(Type t, RestClientUtils.ResultParser delegate) {
			this.t = t;
			this.delegate = delegate;
		}

		public Object parse(String content) {
			//if (content.toLowerCase().contains('error')) {
			if (content.contains('"Status":"ERROR"')) { // changed from above because some base64s were having the word ErROr in them resulting erroneous below exception
				throw new RestClientUtils.ApiException(500, '500', null, 'Error in ECM response');
			}
			return delegate == null ? JSON.deserialize(content, t) : delegate.parse(content);
		}
	}
}