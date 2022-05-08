/**
 * @description A utility class to handle some of the mundane tasks of creating
 * Http requests and composing Http responses while handling errors
 * correctly.
 *
 * @author Masimba Chingwende
 */
public class RestClientUtils {
	
	private static final String BASE_PATH = '';
	private static final String PREFERRED_CONTENT_TYPE = 'application/json';
    private static final String PREFERRED_ACCEPT = 'application/json';
	
	/**
	 * @description creates an HttpRequest given parameters.
	 * @param method The method for this HttpRequest
	 * @param path The path for this HttpRequest.
	 * @param body The body to be attached to this http request.
	 * @param queryParams The query parameters to be added to the resolved path.
	 * @param form The form body if this is request of type application/x-www-form-urlencoded.
	 * @param pathParams The path parameters to be substituted into the base bath.
	 * @param headers the headers to be added to this request.
	 * @param accepts The Http Accepts headers to be added to this request.
	 * @param contentTypes The Http Content-Type headers to be added to this request.
	 * @return A fully formed HttpRequest that can used to invoke the endpoint.
	 */
	public static HttpRequest createRequest(String method, String path, Object body, Map<String, String> queryParams, Map<String, String> form, 
			Map<String, String> pathParams, Map<String, String> headers, List<String> accepts, List<String> contentTypes) {
		if (queryParams == null) {
			queryParams = new Map<String, String>();
		}
		if (pathParams == null) {
			pathParams = new Map<String, String>();
		}
		if (body == null) {
			body = '';
		}
		if (form == null) {
			form = new Map<String, String>();
		}
		if (headers == null) {
			headers = new Map<String, String>();
		}
		if (accepts == null) {
			accepts = new List<String>();
		}
		if (contentTypes == null) {
			contentTypes = new List<String>();
		}
		HttpRequest req = new HttpRequest();
		req.setMethod(method);
        req.setEndpoint(toEndpoint(path, pathParams, queryParams));			
        setHeaders(req, headers, accepts, contentTypes);
        String contentType = !contentTypes.isEmpty() ? contentTypes.get(0) : PREFERRED_CONTENT_TYPE;
        if (method != 'GET') { //no body for GET requests.
        	req.setBody(toBody(contentType, body, form));
        }
		return req;
	}
	
	/**
	 * @description Processes an HttpResponse to deserialise it into the return type.
	 * @param response The HttpResponse to be processed.
	 * @param returnType The Type to which the body of this response will be deserialised to.
	 * @return The object response or null if no return type is specified.
	 */
	public static Object processResponse(HttpResponse res, Type returnType) {
		Integer code = res.getStatusCode();
        Boolean isFailure = code / 100 != 2;
        if (isFailure) {
        	//log this attempt.
        	throw new ApiException(code, res.getStatus(), getHeaders(res), res.getBody());
        } else if (returnType != null) {
        	return toReturnValue(res, returnType, res.getHeader('Content-Type'));
        }
        return null;
	}
	
	private static String toEndPoint(String path, Map<String, String> pathParams, Map<String, String> queryParams) {
		String formatted = toPath(path, pathParams);
		String query = '?' + toQueryString(queryParams);
		return BASE_PATH + formatted + (query == '?' ? '' : query);
	}
	
	private static String toPath(String path, Map<String, String> params) {
		String formatted = path;
        for (String key : params.keySet()) {
        	formatted = formatted.replace('{' + key + '}', String.valueOf(params.get(key)));
        }
        return formatted;
	}
	
	private static String toQueryString(Map<String, String> params) {
		String query = '';
		for (String key : params.keySet()) {
			query += '&' + EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
		}
		return query.removeStart('&');
	}
	
	private static void setHeaders(HttpRequest req, Map<String, String> headers, List<String> accepts, List<String> contentTypes) {
		String acceptHeader = !accepts.isEmpty() ? accepts.get(0) : PREFERRED_ACCEPT;
		String contentTypeHeader = !contentTypes.isEmpty() ? contentTypes.get(0) : PREFERRED_CONTENT_TYPE;
		req.setHeader(StringConstants.CONTENT_TYPE_STRING, contentTypeHeader);
        req.setHeader(StringConstants.HTTP_ACCEPT_HEADER_STRING, acceptHeader);
        for (String key : headers.keySet()) {
        	req.setHeader(key, headers.get(key));
        }
	}
	
	private static String toBody(String contentType, Object body, Map<String, String> form) {
		if (contentType.contains('application/x-www-form-urlencoded')) {
        	return toQueryString(form);
        } else if (contentType.contains('application/json') && !(body instanceof String)) {
        	String serialized = Json.serialize(body, true);
        	return insertMappedProperties(serialized, body);
        }
        return String.valueOf(body);
	}
	
	private static Object toReturnValue(HttpResponse response, Type returnType, String contentType) {
		if (String.class.equals(returnType)) {
			return response.getBody();
		} else if (Blob.class.equals(returnType)) {			
			return response.getBodyAsBlob();
        } else  { //if (contentType == 'application/json' || String.isBlank(contentType)) {
	        String body = replaceMappedProperties(response.getBody(), returnType);
	        JsonParser parser = Json.createParser(body);
	        parser.nextToken();
	        return parser.readValueAs(returnType);
	    }
		//return response.getBody();
	}
	
	/**
	 * @description Replaces mapped properties in a response body so that it can be deserialized
	 * to an Apex object.
	 * @param body 
	 * @param theType
	 * @return a resolved body string.
	 */
	private static String replaceMappedProperties(String body, Type theType) {
		Object o = theType.newInstance();
	    if (o instanceof MappedProperties) {
	    	Map<String, String> propertyMappings = ((MappedProperties) o).getPropertyMappings();
	    	for (String baseName : propertyMappings.keySet()) {
	    		body = body.replaceAll('"' + baseName + '"\\s*:', '"' + propertyMappings.get(baseName) + '":');
	    	}
	    }
	    return body;
	}
	
	private static String insertMappedProperties(String body, Object o) {
	    if (o instanceof MappedProperties) {
	    	Map<String, String> propertyMappings = ((MappedProperties) o).getPropertyMappings();
	    	for (String baseName : propertyMappings.keySet()) {
	    		body = body.replaceAll('"' + propertyMappings.get(baseName) + '"\\s*:', '"' + baseName + '":');
	    	}
	    }
	    return body;
	}
	
	private static Map<String, String> getHeaders(HttpResponse res) {
		Map<String, String> headers = new Map<String, String>();
        List<String> headerKeys = res.getHeaderKeys();
        for (String headerKey : headerKeys) {
        	headers.put(headerKey, res.getHeader(headerKey));
        }
        return headers;
	}
	
	public interface MappedProperties {
		Map<String, String> getPropertyMappings();
	}
	
	public class ApiException extends Exception {
        private final Integer code;
        private final String status;
        private final Map<String, String> headers;
        private final String body;

        public ApiException(Integer code, String status, Map<String, String> headers, String body) {
            this('API returned HTTP ' + code + ': ' + status);
            this.code = code;
            this.status = status;
            this.headers = headers;
            this.body = body;
        }

        public Integer getStatusCode() {
            return code;
        }

        public String getStatus() {
            return status;
        }

        public Map<String, String> getHeaders() {
            return headers;
        }

        public String getBody() {
            return body;
        }
    }	
    
    /**
     * A utility method to invoke an endpoint resolving the appropriate return type.
     * 
     * @param method The method for this HttpRequest
	 * @param path The path for this HttpRequest.
	 * @param body The body to be attached to this http request.
	 * @param queryParams The query parameters to be added to the resolved path.
	 * @param form The form body if this is request of type application/x-www-form-urlencoded.
	 * @param pathParams The path parameters to be substituted into the base bath.
	 * @param headers the headers to be added to this request.
	 * @param accepts The Http Accepts headers to be added to this request.
	 * @param contentTypes The Http Content-Type headers to be added to this request.
	 * @param returnType The type of object to be returned from this invocation.
	 * @param responseHandler A custom handler for special responses.
	 * @param log A flag to signal if all request/responses should be logged. If switched off
	 * 		  only errors will be logged.
	 * @return A fully formed HttpRequest that can used to invoke the endpoint.
	 * @throws ApiException when an error code is returned.
	 */
    public static Object invoke(String method, String path, Object body, Map<String, String> queryParams, Map<String, String> form, 
			Map<String, String> pathParams, Map<String, String> headers, List<String> accepts, List<String> contentTypes, Type returnType, ResultParser responseHandler, Boolean log) {
		Object result = null;
    	HttpRequest request = createRequest(method, path, body, queryParams, form, pathParams, headers, accepts, contentTypes);
    	HttpResponse response = null;
    	String message = StringConstants.INTEGRATION_STATUS_SUCCESS; 
    	Exception error = null;
    	try {
            System.debug('URL : ' + request.getEndpoint());
    		response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
    		result = processResponse(response, returnType, responseHandler);
    	} catch (ApiException ex) {
    		message = StringConstants.INTEGRATION_STATUS_FAILED;
    		log = true;
    		error = ex;
    	} catch (Exception ex) {
    		message = StringConstants.INTEGRATION_STATUS_FAILED;
    		log = true;
    		error = ex;
    	} finally {
    		//log here
    		if (log) {    
    			Sys_Log_Integration__c o = SystemLogger.createRequestIntegrationLog(request.getBody(), request.getMethod(), StringConstants.SALESFORCE_STRING, request.getEndpoint());			
    			o = SystemLogger.mapResponseFields(o, response.getStatusCode(), message, response.getBody());  			
    			log(JSON.serialize(o));
    		}
    		if (error != null) {
    			//result = null; //need to fix this. This may cause unexpected behavior in the application
    			result = handleError(returnType, response);
    		}
    	}
    	return result;
    }
    
    /**
     * @description A convinience method to handle errors from API callouts. This implementation
     * will be depricated in the future as it knows about concrete implementations of Integration
     * handler classes.
     */
    private static Object handleError(Type returnType, HttpResponse response) {
    	Object result = null;
    	Object o = returnType.newInstance();
    	if (o instanceof CreateTracker_Resp_IB_v1) {
    		((CreateTracker_Resp_IB_v1) o).statusCode = response.getStatusCode();
    		result = o;
    	} else if (o instanceof GetWillDetails_Resp_IB_v1) {
    		((GetWillDetails_Resp_IB_v1) o).statusCode = response.getStatusCode();
    		result = o;
    	} else if (o instanceof Base_IB) {
    		result = o;
    	}
    	return result;
    }
    
    /**
     * Asynchronously logs to integration table.
     */
    public static void log(String serialized) {
    	if (LoggingContext.log) {
        	LoggingContext.stash((Sys_Log_Integration__c) JSON.deserialize(serialized, Sys_Log_Integration__c.class));
        } else {
			// PJAIN: 20200523
			// Commented out LoggingQueueable job & replaced it with SystemLogger.insertLog
			// method. This is to prevent 'You have uncommitted work pending' exception.

            //LoggingQueueable job = new LoggingQueueable(serialized);
			//System.enqueueJob(job);

    		Sys_Log_Integration__c o = (Sys_Log_Integration__c) JSON.deserialize(serialized, Sys_Log_Integration__c.class);
    		SystemLogger.insertLog(o);
        }
    }
    
    private static Object processResponse(HttpResponse res, Type returnType, ResultParser responseHandler) {
        return responseHandler == null ? processResponse(res, returnType) : responseHandler.parse(res.getBody());
	}
	
	/**
	 * A response parser interface to allow to custom parsing of responses.
	 *
	 * The ResultParser is responsible for handling errors in a context dependent manner. If
	 * there are any errors this parser should throw an ApiException with clear message and response
	 * code. These will be logged on a best effort basis.
	 */
	public interface ResultParser {
		Object parse(String content);
	}
	
	public static RequestBuilder builder() {
		return new RequestBuilder();
	}
	
	public class RequestBuilder {
		String method;
		String path;
		Object body;
		Map<String, String> queryParams;
		Map<String, String> form; 
		Map<String, String> pathParams;
		Map<String, String> headers;
		List<String> accepts;
		List<String> contentTypes;
		Type returnType;
		ResultParser responseHandler;
		Boolean log;
		String api;
		String service;
		
		public RequestBuilder method(String method) {
			this.method = method;
			return this;
		}
		
		public RequestBuilder path(String path) {
			this.path = path;
			return this;
		}
		
		public RequestBuilder body(Object body) {
			this.body = body;
			return this;
		}
		
		public RequestBuilder queryParams(Map<String, String> queryParams) {
			this.queryParams = queryParams;
			return this;
		}
		
		public RequestBuilder form(Map<String, String> form) {
			this.form = form;
			return this;
		}
		
		public RequestBuilder pathParams(Map<String, String> pathParams) {
			this.pathParams = pathParams;
			return this;
		}
		
		public RequestBuilder headers(Map<String, String> headers) {
			this.headers = headers;
			return this;
		}
		
		public RequestBuilder accepts(List<String> accepts) {
			this.accepts = accepts;
			return this;
		}
		
		public RequestBuilder contentTypes(List<String> contentTypes) {
			this.contentTypes = contentTypes;
			return this;
		}
		
		public RequestBuilder returnType(Type returnType) {
			this.returnType = returnType;
			return this;
		}
		
		public RequestBuilder responseHandler(ResultParser responseHandler) {
			this.responseHandler = responseHandler;
			return this;
		}
		
		public RequestBuilder log(Boolean log) {
			this.log = log;
			return this;
		}
		
		public RequestBuilder api(String api) {
			this.api = api;
			return this;
		}
		
		public RequestBuilder service(String service) {
			this.service = service;
			return this;
		}
		
		public RequestBuilder header(String header, String value) {
			if (this.headers == null) {
				this.headers = new Map<String, String>();
			}
			this.headers.put(header, value);
			return this;
		}
		
		public RequestBuilder pathParam(String pathParam, String value) {
			if (this.pathParams == null) {
				this.pathParams = new Map<String, String>();
			}
			this.pathParams.put(pathParam, value);
			return this;
		}
		
		public Object invoke() {
			if (api != null && service != null) {
			  try {
			  	Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(api, Sys_Utilities_General.getEnvironment(), service);
              	Integration_Service__c service = api.Integration_Services__r.get(0);
              	path = api.Base_URL__c + service.URL_Extension__c;     
              	if (StringConstants.API_MANAGER.equals(api.Name)) {
              		header(StringConstants.X_IBM_CLIENT_ID_STRING, api.Client_ID__c);
        			header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c);
              	}
			  } catch (Exception ex) {
                  if (!test.isRunningTest()) {
                      throw new ApiException('No configurations found for api : ' + api + ' and service: ' + service);
                  } else return null;
			  }                   
			}
			return RestClientUtils.invoke(method, path, body, queryParams, form, pathParams, headers, accepts, contentTypes, returnType, responseHandler, log);
		}
	}
	
	public class QueueHttpMock implements HttpCalloutMock {
        
        HttpResponse[] responses = new HttpResponse[0];
        
        public void addResponse(HttpResponse response) {
            responses.add(response);
        }
        
        public void addResponse(String response) {
            addResponse(response, 200, 'application/json');
        }
        
        public void addResponse(String response, Integer code, String contentType) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(code);
            res.setHeader('Content-Type', contentType);
            responses.add(res);
        }
        
        public HttpResponse respond(HttpRequest request) {
            return responses.remove(0);
        }
	}
	
	public class LoggingQueueable implements Queueable {
		
		public String log { get; set; }
		
		public LoggingQueueable() {}
		
		public LoggingQueueable(String log) {
			this.log = log;
		}
		
    	public void execute(QueueableContext context) {
            if (test.isRunningTest()) return;
    		Sys_Log_Integration__c o = (Sys_Log_Integration__c) JSON.deserialize(this.log, Sys_Log_Integration__c.class);
    		insert o;
    	}
    }
    
}