/**
 * A REST client wrapper for integration services.
 */
public class Impressions_IH_v1 {
	
	private static final String QUERY_PATH = '';
	//private static final String X_API_KEY = '1EgqMh1oubJBCDuTS6en3ZDhnVB3plz7ckJsY7rh';
	//private static final String X_API_KEY = 'mC0vSWFjOm9rRXVIaPZYLaH4ELStWvyV5Eeuc45f';
	// parameterised in custom settings as per Masimba recommendations - Tinashe M Shoko 30-05-2020
	private static final String X_API_KEY = [Select Token__c from ImpressionToken__c LIMIT 1].Token__c;

  /**
   * Triggers an authentication intent for a given signature request
   */
  public Impressions_Model.AuthenticationStatusOutput createAuthenticationIntent (String signatureRequestId) {
  		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.AuthenticationStatusOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_POST_STRING)//
    			.body(null)//
    			.header('x-api-key', X_API_KEY)//
    			.pathParam('signaturerequestid', signatureRequestId)//
    			.returnType(Impressions_Model.AuthenticationStatusOutput.class)//
    			.log(true)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions Create AuthenticationIntent')//
    			.invoke();
  }
  
  /**
   * Checks the status of an authentication intent for a given signature request
   */ /**
  public Impressions_Model.AuthenticationIntentOutput getAuthenticationIntent (String signatureRequestId) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.AuthenticationIntentOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_GET_STRING)//
    			.body(null)//
    			.header(StringConstants.X_IBM_CLIENT_ID_STRING,  api.Client_ID__c)//
    			.header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.AuthenticationIntentOutput.class)//
    			.log(true)//
    			.api(StringConstants.API_MANAGER)//
    			.service('/AuthenticationIntent/{signaturerequestid}')//
    			.invoke();
  }
  **/
  /**
   * Sends an sms notification of a pending authentication intent for a given signature request
   */ /**
  public Impressions_Model.SMSNotifyAuthenticationIntentOutput smsNotify (String signatureRequestId, Impressions_Model.SMSNotifyAuthenticationIntentInput body) {
  		//AuthenticationIntent/{signaturerequestid}/SMSNotify
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.SMSNotifyAuthenticationIntentOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_POST_STRING)//
    			.body(body)//
    			.header(StringConstants.X_IBM_CLIENT_ID_STRING,  api.Client_ID__c)//
    			.header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.SMSNotifyAuthenticationIntentOutput.class)//
    			.log(true)//
    			.api(StringConstants.API_MANAGER)//
    			.service('AuthenticationIntent/{signaturerequestid}/SMSNotify')//
    			.invoke();
  }
  **/
  /**
   * Sends email notifications for existing signature requests
   */ /**
  public void notify (String signatureRequestId) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		RestClientUtils.builder()//
    			.method(StringConstants.HTTP_GET_STRING)//
    			.body(null)//
    			.header(StringConstants.X_IBM_CLIENT_ID_STRING,  api.Client_ID__c)//
    			.header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(null)//
    			.log(true)//
    			.api(StringConstants.API_MANAGER)//
    			.service('/Notification/{signaturerequestid}')//
    			.invoke();
  }
  **/
  /**
   * Retrieves the audit trail for workflow requests based on the workflowID
   */
  public Impressions_Model.WorkflowAuditOutput getSignatureAuditTrailByWorkflowId (String workflowId) {
      system.debug('workflowId as th ' + workflowId);
    	Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.WorkflowAuditOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_GET_STRING)//
    			.body(null)//
    			.header('x-api-key', X_API_KEY)//
    			.pathParam('workflowid', workflowId)//
    			.returnType(Impressions_Model.WorkflowAuditOutput.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions SignatureAuditTrail Workflow')//
    			.invoke();
  }
  
  /**
   * Retrieves the audit trail for signature request events based on the requestID
   */
  public Impressions_Model.SignatureAuditOutput getSignatureAuditTrailByRequestId (String requestId) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.SignatureAuditOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_GET_STRING)//
    			.body(null)//
    			.header('x-api-key', X_API_KEY)//
    			.pathParam('requestId', requestId)//
    			.returnType(Impressions_Model.SignatureAuditOutput.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions SignatureAuditTrail RequestId')//
    			.invoke();
  }
  
  /**
   * Retrieves the audit trail for signature request events based on the requestID as well as the document if signing was successful
   */
  public Impressions_Model.SignatureAuditDocOutput getSignatureAuditTrailAndDocumentByRequestId (String requestId) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.SignatureAuditDocOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_GET_STRING)//
    			.body(null)//
    			.header('x-api-key', X_API_KEY)//
    			.pathParam('requestId', requestId)//
    			.returnType(Impressions_Model.SignatureAuditDocOutput.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions SignatureAuditTrailAndDocumentByRequestId')//
    			.invoke();
  }
  
  /**
   * Creates a new PDF signature request event
   */
  public Impressions_Model.CreatePDFSignatureRequestEventOutput createPDFSignatureRequestEvent (Impressions_Model.CreatePDFSignatureRequestEventInput body) {
		return  (Impressions_Model.CreatePDFSignatureRequestEventOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_PUT_STRING)//
    			.body(body)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.CreatePDFSignatureRequestEventOutput.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions CreatePDFSignatureRequestEvent')//
    			.invoke();
  }
  
  /**
   * Removes the document associated with a signature request event
   */
  public Impressions_Model.RemoveDocOutput removePDFSignatureRequestEvent (String signaturerequestid) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.RemoveDocOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_POST_STRING)//
    			.body(null)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.RemoveDocOutput.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('AuthenticationIntent/{signaturerequestid}/SMSNotify')//
    			.invoke();
  }
  
  /**
   * Creates a new signature workflow request from deferred signature requests
   */
  public Impressions_Model.CreateSignatureWorkflowOutput createSignatureWorkflow (Impressions_Model.CreateSignatureWorkflowInput body) {
		return  (Impressions_Model.CreateSignatureWorkflowOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_PUT_STRING)//
    			.body(body)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.CreateSignatureWorkflowOutput.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions CreateSignatureWorkflow')//
    			.invoke();
  }
  
  /**
   * Removes a signature workflow request from deferred signature requests
   */
    /* where is it being used
  public Impressions_Model.RemoveDocOutput removeSignatureWorkflow (String signatureWorkflowId) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.RemoveDocOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_POST_STRING)//
    			.body(null)//
    			.header(StringConstants.X_IBM_CLIENT_ID_STRING,  api.Client_ID__c)//
    			.header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.RemoveDocOutput.class)//
    			.log(true)//
    			.api(StringConstants.API_MANAGER)//
    			.service('AuthenticationIntent/{signaturerequestid}/SMSNotify')//
    			.invoke();
  }
  **/
  /**
   * Create new PDF signature request(s) that will be sent as a workflow
   */
  public Impressions_Model.CreateInlinePDFSignatureRequestEventOutput createInlineSignatureWorkflow (Impressions_Model.CreateInlinePDFSignatureRequestEventInput body) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		return  (Impressions_Model.CreateInlinePDFSignatureRequestEventOutput) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_PUT_STRING)//
    			.body(body)//
    			.header(StringConstants.X_IBM_CLIENT_ID_STRING,  api.Client_ID__c)//
    			.header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.CreateInlinePDFSignatureRequestEventOutput.class)//
    			.log(false)//
    			.api('Impressions')//
    			.service('Impressions CreateInlineSignatureWorkflow')//
    			.invoke();
  }
  
   /**
   * Gets the view link for a given signature request
   */
  public String getViewLink (String requestId) {
		Integration_API__c api = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), QUERY_PATH);
		Impressions_Model.AnonymousTokenResponse response =  (Impressions_Model.AnonymousTokenResponse) RestClientUtils.builder()//
    			.method(StringConstants.HTTP_GET_STRING)//
    			.body(null)//
    			.pathParam('signaturerequestid', requestId)//
    			.header(StringConstants.X_IBM_CLIENT_ID_STRING,  api.Client_ID__c)//
    			.header(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c)//
    			.header('x-api-key', X_API_KEY)//
    			.returnType(Impressions_Model.AnonymousTokenResponse.class)//
    			.log(false)//
    			.api(StringConstants.API_MANAGER)//
    			.service('Impressions GetViewLink')//
    			.invoke();
      if (response != null){
    	return response.viewerpath + response.token;
      } else return null;
  }


}