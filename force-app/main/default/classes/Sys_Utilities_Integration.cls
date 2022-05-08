/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-15
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-07-14   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public class Sys_Utilities_Integration {
	/*
	 *
	 * Method that executes a Service Callout
	 * @param HTTP Request
	 * @return List<Opportunity> - returns a list of opportunities
	 *
	 * PJAIN: 20200523: Added class and method name to System.debug lines for easy identification
	 *
	 */

	public static final String JITTERBIT_AUTH_PATH = 'Jitterbit Auth Path';
	public static final String JITTERBIT2_AUTH_PATH = 'Jitterbit2 Auth Path';
	private static final String JITTERBIT2_BASE_PATH = 'absa330762.jitterbit.eu';
	/**
	 * @description serviceCallout description
	 *
	 * @param httpRequest
	 * @return HttpResponse
	 */
	public static HttpResponse serviceCallout(HttpRequest httpRequest) {
		Http http = new Http();
		HttpResponse httpResponse;

		Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(
			httpRequest.getBody(),
			StringConstants.METHOD_INTEGRATION_UTILITIES_SERVICE_CALLOUT,
			StringConstants.SALESFORCE_STRING,
			httpRequest.getEndpoint()
		);

		try {
			httpRequest.setTimeout(120000);
			httpResponse = http.send(httpRequest);
			//System.debug('Sys_Utilities_Integration.serviceCallout.httpRequest: ' + httpRequest + '. Body: ' + httpRequest.getBody());
			//System.debug('Sys_Utilities_Integration.serviceCallout.httpResponse: ' + httpResponse + '. Body: ' + httpResponse.getBody());
			log = SystemLogger.mapResponseFields(log, httpResponse.getStatusCode(), httpResponse.getStatus(), httpResponse.getBody());
		} catch (Exception e) {
			//Create a bad response for an exception
			httpResponse = new HttpResponse();
			httpResponse.setStatusCode(500);
			httpResponse.setStatus(StringConstants.STATUS_CODE_500);

			// PJAIN: 20200523: Below code ensures that the response body is in JSON structure
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. StackTrace: ' + e.getStackTraceString();
			log = SystemLogger.mapResponseFields(log, 500, StringConstants.STATUS_CODE_500, message);

			String jsonError = '{"message":' + JSON.serialize(message, true) + '}';
			httpResponse.setBody(jsonError);
		}

		SystemLogger.insertLog(log);
		return httpResponse;
	}
	/**
	 * @description serviceCalloutWithoutLogging description
	 *
	 * @param httpRequest
	 * @return HttpResponse
	 */
	public static HttpResponse serviceCalloutWithoutLogging(HttpRequest httpRequest) {
		try {
			String endpoint = httpRequest.getEndpoint();
			//	System.debug('Sys_Utilities_Integration.serviceCalloutWithoutLogging: Trying to intercept callout to endpoint: ' + httpRequest.getEndpoint());
			if (String.isEmpty(httpRequest.getHeader('Authorization')) && endpoint.toLowerCase().contains(JITTERBIT2_BASE_PATH.toLowerCase())) {
				//ignore auth endpoints
				//log this event
				//	System.debug('Sys_Utilities_Integration.serviceCalloutWithoutLogging: Intercepting callout to endpoint: ' + httpRequest.getEndpoint());
				if (!endpoint.containsIgnoreCase('/auth')) {
					//get auth token
					if (!Test.isRunningTest()) {
						JitterbitAuthResponse jitterbitAuthResponse = JitterbitAuth_IH_V1.authenticate2();
						if (jitterbitAuthResponse != null && String.isNotBlank(jitterbitAuthResponse.token)) {
							httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitAuthResponse.token);
						}
					}
				}
			}
		} catch (Exception e) {
			e.getMessage();
		}

		Http http = new Http();
		HttpResponse httpResponse;

		try {
			httpRequest.setTimeout(120000);
			httpResponse = http.send(httpRequest);
			System.debug('Sys_Utilities_Integration.serviceCalloutWithoutLogging.httpRequest: ' + httpRequest + '. Body: ' + httpRequest.getBody());
			System.debug('Sys_Utilities_Integration.serviceCalloutWithoutLogging.httpResponse: ' + httpResponse + '. Body: ' + httpResponse.getBody());
		} catch (Exception e) {
			//Create a bad response for an exception
			httpResponse = new HttpResponse();
			httpResponse.setStatusCode(500);
			httpResponse.setStatus(StringConstants.STATUS_CODE_500);

			// PJAIN: 20200523: Below code ensures that the response body is in JSON structure
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. StackTrace: ' + e.getStackTraceString();

			String jsonError = '{"message":' + JSON.serialize(message, true) + '}';
			httpResponse.setBody(jsonError);
		}
		return httpResponse;
	}

	// Method that translates an internal value to an external value
	/**
	 * @description serviceCalloutWithoutLogging description
	 *@param systemNameP
	 *@param valueTypeP
	 *@param internalValueP
	 * @param directionP
	 * @return String
	 */
	public static String getIntegrationTranslationExternalValue(String systemNameP, String valueTypeP, String internalValueP, String directionP) {
		return ExternalValueToIntegrationTranslationsMap.get(systemNameP + valueTypeP + internalValueP + directionP);
	}

	/**
	 * @description ExternalValueToIntegrationTranslationsMap description
	 * @return map<String, String>
	 */
	public static map<String, String> ExternalValueToIntegrationTranslationsMap {
		get {
			if (ExternalValueToIntegrationTranslationsMap == null) {
				ExternalValueToIntegrationTranslationsMap = new Map<String, String>();
				for (Integration_Translation__c translation : [
					SELECT External_Value__c, System_Name__c, Value_Type__c, Internal_Value__c, Direction__c
					FROM Integration_Translation__c
				]) {
					ExternalValueToIntegrationTranslationsMap.put(
						translation.System_Name__c +
						translation.Value_Type__c +
						translation.Internal_Value__c +
						translation.Direction__c,
						translation.External_Value__c
					);
				}
			}
			return ExternalValueToIntegrationTranslationsMap;
		}
		set;
	}
	/**
	 * @description getIntegrationTranslationInternalValue description
	 *@param systemNameP
	 *@param valueTypeP
	 * @param externalValueP
	 * @param directionP
	 * @return String
	 */
	public static String getIntegrationTranslationInternalValue(String systemNameP, String valueTypeP, String externalValueP, String directionP) {
		return InternalValueToIntegrationTranslationsMap.get(systemNameP + valueTypeP + externalValueP + directionP);
	}

	// Returns a map of Integration Translation External values to a unique key created in the getter method
	/**
	 * @description getIntegrationTranslationInternalValue description
	 *@param systemNameP
	 *@param valueTypeP
	 * @param internalValueP
	 * @param directionP
	 * @return String
	 */
	public static map<String, String> InternalValueToIntegrationTranslationsMap {
		get {
			if (InternalValueToIntegrationTranslationsMap == null) {
				InternalValueToIntegrationTranslationsMap = new Map<String, String>();
				for (Integration_Translation__c translation : [
					SELECT External_Value__c, System_Name__c, Value_Type__c, Internal_Value__c, Direction__c
					FROM Integration_Translation__c
				]) {
					InternalValueToIntegrationTranslationsMap.put(
						translation.System_Name__c +
						translation.Value_Type__c +
						translation.External_Value__c +
						translation.Direction__c,
						translation.Internal_Value__c
					);
				}
			}
			return InternalValueToIntegrationTranslationsMap;
		}
		set;
	}
	/**
	 * @description getIntegrationTranslationInternalValue description
	 *@param integrationApiP
	 *@param integrationServiceP
	 * @param jsonStringP
	 
	 * @return HttpRequest
	 */
	public static HttpRequest mapHttpRequest(Integration_API__c integrationApiP, Integration_Service__c integrationServiceP, String jsonStringP) {
		//Create Request from Custom Object Record
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setEndpoint(integrationApiP.Base_URL__c + integrationServiceP.URL_Extension__c);
		httpRequest.setMethod(integrationServiceP.Method__c.toUpperCase());
		httpRequest.setHeader(StringConstants.CONTENT_TYPE_STRING, integrationServiceP.Content_Type__c);
		// httpRequest.setHeader(StringConstants.X_IBM_CLIENT_ID_STRING, integrationApiP.Client_ID__c);
		// httpRequest.setHeader(StringConstants.X_IBM_CLIENT_SECRET_STRING, integrationApiP.Client_Secret__c);
		// MNEKHUBVI: 20200303: Change Start: Added null check before setting the headers
		if (String.isNotBlank(integrationApiP.Client_ID__c)) {
			httpRequest.setHeader(StringConstants.X_IBM_CLIENT_ID_STRING, integrationApiP.Client_ID__c);
		}
		if (String.isNotBlank(integrationApiP.Client_Secret__c)) {
			httpRequest.setHeader(StringConstants.X_IBM_CLIENT_SECRET_STRING, integrationApiP.Client_Secret__c);
		}
		// MNEKHUBVI: 20200303: Change End
		if (String.isNotBlank(jsonStringP) && jsonStringP != null) {
			httpRequest.setBody(jsonStringP);
		}
		//	System.debug('Sys_Utilities_Integration.mapHttpRequest.httpRequest: ' + httpRequest + '. Body: ' + httpRequest.getBody());
		return httpRequest;
	}

	// PJAIN: 20200708: new method to create http request using integrationServiceP without integrationApiP
	/**
	 * @description getIntegrationTranslationInternalValue description
	 *@param integrationServiceP
	 * @param jsonStringP
	 * @return HttpRequest
	 */
	public static HttpRequest mapHttpRequest(Integration_Service__c integrationServiceP, String jsonStringP) {
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setEndpoint(integrationServiceP.Integration_API_ID__r.Base_URL__c + integrationServiceP.URL_Extension__c);
		httpRequest.setMethod(integrationServiceP.Method__c.toUpperCase());
		httpRequest.setHeader(StringConstants.CONTENT_TYPE_STRING, integrationServiceP.Content_Type__c);
		if (String.isNotBlank(integrationServiceP.Integration_API_ID__r.Client_ID__c)) {
			httpRequest.setHeader(StringConstants.X_IBM_CLIENT_ID_STRING, integrationServiceP.Integration_API_ID__r.Client_ID__c);
		}
		if (String.isNotBlank(integrationServiceP.Integration_API_ID__r.Client_Secret__c)) {
			httpRequest.setHeader(StringConstants.X_IBM_CLIENT_SECRET_STRING, integrationServiceP.Integration_API_ID__r.Client_Secret__c);
		}
		if (String.isNotBlank(jsonStringP) && jsonStringP != null) {
			httpRequest.setBody(jsonStringP);
		}
		System.debug('Sys_Utilities_Integration.mapHttpRequest.httpRequest: ' + httpRequest + '. Body: ' + jsonStringP);
		return httpRequest;
	}
	/**
	 * @description getIntegrationTranslationInternalValue description
	 *@param integrationApiP
	 *@param integrationServiceP
	 * @param jsonStringP
	 * @return HttpRequest
	 */
	public static HttpRequest mapHttpRequestJitterbit(Integration_API__c integrationApiP, Integration_Service__c integrationServiceP, String jsonStringP) {
		Integration_API__c api = getMultipleIntegrationSettings(StringConstants.JITTERBIT, Sys_Utilities_General.getEnvironment(), JITTERBIT_AUTH_PATH);
		Integration_Service__c authService = api.Integration_Services__r.get(0);
		String[] credentials = authService.Username__c.split('@');
		String[] jitterbitAuthUser = credentials[0].split('/');

		//Create Request from Custom Object Record
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setEndpoint(integrationApiP.Base_URL__c + integrationServiceP.URL_Extension__c);
		httpRequest.setMethod(integrationServiceP.Method__c.toUpperCase());
		httpRequest.setHeader(StringConstants.CONTENT_TYPE_STRING, integrationServiceP.Content_Type__c);
		JitterbitAuthResponse jitterbitAuthResp = JitterbitAuth_IH_V1.authenticate();
		String auth_token;

		if (!test.isRunningTest())
			auth_token = jitterbitAuthResp.token;
		else
			auth_token = '1821929182';

		String authorizationHeader = 'Bearer ' + auth_token;
		httpRequest.setHeader('Authorization', authorizationHeader);
		//to get jitterbit service user (SVC-DIST_SF_DEV')
		httpRequest.setHeader('User', jitterbitAuthUser[1]);

		if (String.isNotBlank(jsonStringP) && jsonStringP != null) {
			httpRequest.setBody(jsonStringP);
		}
		//	System.debug('Sys_Utilities_Integration.mapHttpRequestJitterbit.httpRequest: ' + httpRequest + '. Body: ' + httpRequest.getBody());
		return httpRequest;
	}

	// PJAIN: 20200708: New method to query integration services
	/**
	 * @description getIntegrationServices description
	 *@param serviceNameP
	 * @return List<Integration_Service__c>
	 */
	public static List<Integration_Service__c> getIntegrationServices(String serviceNameP) {
		return new IntegrationServicesSelector().selectByNameAndEnvironment(serviceNameP, Sys_Utilities_General.getEnvironment());
	}

	/**
	 * @description getIntegrationTranslationInternalValue description
	 *@param apiNameP
	 *@param environmentP
	 * @param serviceNameP
	 * @return Integration_API__c
	 */
	public static Integration_API__c getIntegrationSettings(String apiNameP, String environmentP, String serviceNameP) {
		//Create Query for Integration_Services__c
		String subQuery = 'SELECT ';
		String field_name_child = null;
		Map<String, Schema.SObjectField> field_object_map_child = Schema.getGlobalDescribe().get('Integration_Service__c').getDescribe().Fields.getMap();
		List<Schema.SObjectField> field_object_values_map_child = field_object_map_child.values();
		for (Schema.SObjectField s : field_object_values_map_child) {
			field_name_child = s.getDescribe().getName();
			subQuery += field_name_child + ', ';
		}
		subQuery = subQuery.subStringBeforeLast(',');
		subQuery += ' FROM Integration_Services__r WHERE Name = \'' + serviceNameP + '\')';
		subQuery = '(' + subQuery;

		//Create Query for Integration_API__c + Integration_Services__c

		String query = ' SELECT ';
		String field_name_parent = null;
		Map<String, Schema.SObjectField> field_object_map_parent = Schema.getGlobalDescribe().get('Integration_API__c').getDescribe().Fields.getMap();
		List<Schema.SObjectField> field_object_values_map_parent = field_object_map_parent.values();
		for (Schema.SObjectField s : field_object_values_map_parent) {
			field_name_parent = s.getDescribe().getName();
			query += field_name_parent + ', ';
		}
		query = query.subStringBeforeLast(',');
		query += ',' + subQuery + ' FROM Integration_API__c WHERE Environment__c = \'' + environmentP + '\' AND Name = \'' + apiNameP + '\'';

		//  List<Integration_API__c> queryResultList = Database.query(query);
		List<Integration_API__c> queryResultList = [
			SELECT
				Id,
				OwnerId,
				IsDeleted,
				Name,
				CurrencyIsoCode,
				CreatedDate,
				CreatedById,
				LastModifiedDate,
				LastModifiedById,
				SystemModstamp,
				LastViewedDate,
				LastReferencedDate,
				Base_URL__c,
				Client_ID__c,
				Client_Secret__c,
				Environment__c,
				(
					SELECT
						Id,
						OwnerId,
						IsDeleted,
						Name,
						CurrencyIsoCode,
						CreatedDate,
						CreatedById,
						LastModifiedDate,
						LastModifiedById,
						SystemModstamp,
						LastViewedDate,
						LastReferencedDate,
						Content_Type__c,
						Integration_API_ID__c,
						Method__c,
						Password__c,
						URL_Extension__c,
						Username__c,
						Service_Description__c
					FROM Integration_Services__r
					WHERE Name = :serviceNameP
				)
			FROM Integration_API__c
			WHERE Environment__c = :environmentP AND Name = :apiNameP
		];

		if (queryResultList != null && queryResultList.size() == 1) {
			if (queryResultList[0].Integration_Services__r != null && queryResultList[0].Integration_Services__r.size() == 1) {
				return queryResultList[0];
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	/**
	 *@description getMultipleIntegrationSettings description
	 *@param apiNameP
	 *@param environmentP
	 *@param servicesNameP
	 *@return Integration_API__c
	 */
	public static Integration_API__c getMultipleIntegrationSettings(String apiNameP, String environmentP, String servicesNameP) {
		//Create Query for Integration_Services__c
		String subQuery = 'SELECT ';
		String field_name_child = null;
		Map<String, Schema.SObjectField> field_object_map_child = Schema.getGlobalDescribe().get('Integration_Service__c').getDescribe().Fields.getMap();
		List<Schema.SObjectField> field_object_values_map_child = field_object_map_child.values();
		for (Schema.SObjectField s : field_object_values_map_child) {
			field_name_child = s.getDescribe().getName();
			subQuery += field_name_child + ', ';
		}
		subQuery = subQuery.subStringBeforeLast(',');
		subQuery += ' FROM Integration_Services__r WHERE Name Like \'%' + servicesNameP + '%\')';
		subQuery = '(' + subQuery;

		//Create Query for Integration_API__c + Integration_Services__c

		String query = ' SELECT ';
		String field_name_parent = null;
		Map<String, Schema.SObjectField> field_object_map_parent = Schema.getGlobalDescribe().get('Integration_API__c').getDescribe().Fields.getMap();
		List<Schema.SObjectField> field_object_values_map_parent = field_object_map_parent.values();
		for (Schema.SObjectField s : field_object_values_map_parent) {
			field_name_parent = s.getDescribe().getName();
			query += field_name_parent + ', ';
		}
		query = query.subStringBeforeLast(',');
		query += ',' + subQuery + ' FROM Integration_API__c WHERE Environment__c = \'' + environmentP + '\' AND Name = \'' + apiNameP + '\'';

		//  List<Integration_API__c> queryResultList = Database.query(query);
		string tempInput = '%' + servicesNameP + '%';
		List<Integration_API__c> queryResultList = [
			SELECT
				Id,
				OwnerId,
				IsDeleted,
				Name,
				CurrencyIsoCode,
				CreatedDate,
				CreatedById,
				LastModifiedDate,
				LastModifiedById,
				SystemModstamp,
				LastViewedDate,
				LastReferencedDate,
				Base_URL__c,
				Client_ID__c,
				Client_Secret__c,
				Environment__c,
				(
					SELECT
						Id,
						OwnerId,
						IsDeleted,
						Name,
						CurrencyIsoCode,
						CreatedDate,
						CreatedById,
						LastModifiedDate,
						LastModifiedById,
						SystemModstamp,
						LastViewedDate,
						LastReferencedDate,
						Content_Type__c,
						Integration_API_ID__c,
						Method__c,
						Password__c,
						URL_Extension__c,
						Username__c,
						Service_Description__c
					FROM Integration_Services__r
					WHERE Name LIKE :tempInput
				)
			FROM Integration_API__c
			WHERE Environment__c = :environmentP AND Name = :apiNameP
		];

		if (queryResultList.size() == 1) {
			return queryResultList[0];
		} else {
			return null;
		}
	}
	// Added a Method to get all Integration_Translation__c Values based SystemName
	/**
	 * @description getIntegrationTranslationBySystemName description
	 *@param systemNameP
	 *@param directionP
	 * @return Map<string, string>
	 */
	public static Map<string, string> getIntegrationTranslationBySystemName(String systemNameP, String directionP) {
		Map<String, String> valuesToIntegrationTranslationsMap = new Map<String, String>();
		List<Integration_Translation__c> translationValue = [
			SELECT External_Value__c, System_Name__c, Value_Type__c, Internal_Value__c, Direction__c
			FROM Integration_Translation__c
			WHERE System_Name__c = :systemNameP
		];
		for (Integration_Translation__c translation : translationValue) {
			if (translation != null) {
				valuesToIntegrationTranslationsMap.put(translation.Internal_Value__c, translation.External_Value__c);
			}
		}
		return valuesToIntegrationTranslationsMap;
	}

	// PJAIN: 20200523
	// Creates a bean from the response
	/**
	 * @description getMultipleIntegrationSettings description
	 *@param httpResponseP
	 *@param apexTypeP
	 * @return Object
	 */
	public static Object mapResponseFields(HttpResponse httpResponseP, System.Type apexTypeP) {
		Object responseBeanContent;
		Base_IB responseBean = (Base_IB) apexTypeP.newInstance();
		if (apexTypeP != Sys_Utilities_Integration_StringBody_IB.class) {
			responseBeanContent = responseBean.deserialize(httpResponseP.getBody().trim(), apexTypeP);
		} else {
			// PJDURANDT: 20201211 : If apexTypeP equals to Sys_Utilities_Integration_StringBody_IB.class,
			// the response body will not be deserialized but will be set to the body variable on the
			// Sys_Utilities_Integration_StringBody_IB object.
			responseBeanContent = Base_IB.putValue(responseBean, 'body', httpResponseP.getBody());
		}
		responseBeanContent = Base_IB.putValue(responseBeanContent, 'status', httpResponseP.getStatus());
		responseBeanContent = Base_IB.putValue(responseBeanContent, 'statusCode', httpResponseP.getStatusCode());
		// Base_IB.putValue returns a Map of <String, Object>.
		// The below line converts to a response bean object.
		responseBeanContent = JSON.deserialize(JSON.serialize(responseBeanContent, true), apexTypeP);
		return responseBeanContent;
	}

	// PJAIN: 20200523
	// Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)

	/**
	 * @description getIntegrationTranslationBySystemName description
	 *@param statusCodeP
	 *@param statusP
	 *@param messageP
	 *@param apexTypeP
	 * @return Object
	 */
	public static Object mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP, System.Type apexTypeP) {
		Object responseBeanContent = apexTypeP.newInstance();

		responseBeanContent = Base_IB.putValue(responseBeanContent, 'status', statusP);
		responseBeanContent = Base_IB.putValue(responseBeanContent, 'statusCode', statusCodeP);
		responseBeanContent = Base_IB.putValue(responseBeanContent, 'message', messageP);

		// Base_IB.putValue returns a Map of <String, Object>. The below
		// line converts to a response bean object
		responseBeanContent = JSON.deserialize(JSON.serialize(responseBeanContent, true), apexTypeP);

		return responseBeanContent;
	}

	// PJAIN: 20201105 : Added an overloaded method without endpointSuffix

	/**
	 * @description getIntegrationTranslationBySystemName description
	 *@param requestBean
	 *@param integrationServiceName
	 *@param apexTypeP
	 * @return Base_IB
	 */
	public static Base_IB integrationServiceCall(Base_IB requestBean, String integrationServiceName, System.Type apexTypeP) {
		return integrationServiceCall(requestBean, null, null, integrationServiceName, apexTypeP);
	}

	// PJAIN: 20200523
	// This method queries integration settings, creates http request, creates logs,
	// calls integration service, does error handling and returns response bean.
	// This method inserts the log using SystemLogger.insertLog method which uses RESP API.
	// @param: requestBean
	// @param: integrationServiceName
	// @param: apexTypeP
	// @return: response bean object
	//
	// PJAIN: 20200612: Removed serviceName as an input to the method. It is replaced by destinationSystem.
	// PJAIN: 20200708: Removed integrationApiName & methodName as an inputs to the method. methodName is replaced by integrationServiceName.
	/**
	 * @description getIntegrationTranslationBySystemName description
	 *@param requestBean
	 *@param endpointSuffix
	 *@param integrationServiceName
	 *@param apexTypeP
	 * @return Base_IB
	 */
	public static Base_IB integrationServiceCall(Base_IB requestBean, String endpointSuffix, String integrationServiceName, System.Type apexTypeP) {
		return integrationServiceCall(requestBean, endpointSuffix, null, integrationServiceName, apexTypeP);
	}

	// PJDURANDT: 20201028 : Added an overloaded method for customHeaders
	/**
	 * @description getIntegrationTranslationBySystemName description
	 *@param requestBean
	 *@param endpointSuffix
	 *@param customHeaders
	 *@param integrationServiceName
	 * @param apexTypeP
	 * @return Base_IB
	 */
	public static Base_IB integrationServiceCall(
		Base_IB requestBean,
		String endpointSuffix,
		Map<String, String> customHeaders,
		String integrationServiceName,
		System.Type apexTypeP
	) {
		Base_IB responseBean;
		Sys_Log_Integration__c log;
		HttpRequest httpRequest;
		HttpResponse httpResponse;
		String methodName = integrationServiceName;

		try {
			List<Integration_Service__c> integrationServices = getIntegrationServices(integrationServiceName);

			if (integrationServices != null && integrationServices.size() == 1) {
				String jsonString;
				if (requestBean != null) {
					// PJDURANDT: 20201211: If the requestBean is of type Sys_Utilities_Integration_StringBody_IB
					// the JSON string will be set to the body variable of Sys_Utilities_Integration_StringBody_IB
					// else the Bean will be serialized.

					if (requestBean instanceof Sys_Utilities_Integration_StringBody_IB) {
						jsonString = ((Sys_Utilities_Integration_StringBody_IB) requestBean).body;
					} else {
						jsonString = requestBean.serialize(requestBean);
					}
				}

				httpRequest = mapHttpRequest(integrationServices[0], jsonString);

				if (String.isNotBlank(endpointSuffix)) {
					// If endpointSuffix is not blank, append it to the endpoint
					httpRequest.setEndpoint(httpRequest.getEndpoint() + endpointSuffix);
				}

				if (customHeaders?.size() > 0) {
					for (String key : customHeaders.keySet()) {
						// If customHeaders is not null or empty, add the headers to the request
						httpRequest.setHeader(key, customHeaders.get(key));
					}
				}

				log = SystemLogger.createRequestIntegrationLog(httpRequest.getBody(), methodName, StringConstants.SALESFORCE_STRING, httpRequest.getEndpoint());
				// Validate that all the required fields are populated
				String requestBeanValidationMessage = requestBean != null ? requestBean.validate() : null;
				if (String.isBlank(requestBeanValidationMessage)) {
					//Send Request
					httpResponse = serviceCalloutWithoutLogging(httpRequest);
					log = SystemLogger.mapResponseFields(log, httpResponse.getStatusCode(), httpResponse.getStatus(), httpResponse.getBody());
					responseBean = (Base_IB) mapResponseFields(httpResponse, apexTypeP);
				} else {
					String message = requestBeanValidationMessage;
					responseBean = (Base_IB) mapFailedResponseFields(400, StringConstants.STATUS_CODE_400, message, apexTypeP);
					log = SystemLogger.mapResponseFields(log, 400, StringConstants.STATUS_CODE_400, message);
					//System.debug('Sys_Utilities_Integration.integrationServiceCall.else of requestBeanValidationMessage: ' + message);
				}
			} else {
				String message;
				if (integrationServices == null || integrationServices.size() == 0) {
					message =
						'No Integration Service record found with Name: ' +
						integrationServiceName +
						' for Environment: ' +
						Sys_Utilities_General.getEnvironment();
				} else {
					message =
						'More than 1 Integration Service records found (Count: ' +
						integrationServices.size() +
						') with Name: ' +
						integrationServiceName +
						' for Environment: ' +
						Sys_Utilities_General.getEnvironment() +
						'. Only 1 record should exist with this name. Delete the extra Integration Service records.';
				}
				responseBean = (Base_IB) mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message, apexTypeP);
				String destinationSystem = integrationServiceName; // PJAIN: 20200612: Added destinationSystem to replace serviceName.
				log = SystemLogger.createInternalIntegrationLog(methodName, destinationSystem, 500, StringConstants.STATUS_CODE_500, message);
				//	System.debug('Sys_Utilities_Integration.integrationServiceCall.else of integrationServices: ' + message);
			}
		} catch (Exception e) {
			//Create a bad response for an exception
			String message;
			if (httpResponse != null) {
				message = 'Exception: ' + e.getMessage() + '. StackTrace: ' + e.getStackTraceString() + '. Response body: ' + httpResponse.getBody();
			} else {
				message = 'Exception: ' + e.getMessage() + '. StackTrace: ' + e.getStackTraceString();
			}
			responseBean = (Base_IB) mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message, apexTypeP);
			if (log != null) {
				log = SystemLogger.mapResponseFields(log, 500, StringConstants.STATUS_CODE_500, message);
			} else {
				String destinationSystem = httpRequest != null ? httpRequest.getEndpoint() : integrationServiceName; // PJAIN: 20200612: Added destinationSystem to replace serviceName.
				log = SystemLogger.createInternalIntegrationLog(methodName, destinationSystem, 500, StringConstants.STATUS_CODE_500, message);
			}
			//	System.debug('Sys_Utilities_Integration.integrationServiceCall.exception message: ' + message);
		}

		if (log != null) {
			SystemLogger.insertLog(log);
		}

		return responseBean;
	}
}