/**
 * @description       : Handler class for ECM Triggers-Rbbmi Service
 * @author            : Rajesh
 * @last modified on  : 2021-07-14
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2020-09-23   Rajesh                 Initial Version
 **/

public class Rbbmi_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'rbbmi';

	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @return List<Rbbmi_Resp_IB_v1>
	 **/
	public static List<Rbbmi_Resp_IB_v1> callRbbmiService() {
		String responseBean = integrationServiceCall(null, null, INTEGRATION_SERVICE_NAME, Rbbmi_Resp_IB_v1.class);
		if (responseBean != null && responseBean != '') {
			List<Rbbmi_Resp_IB_v1> parseData = (List<Rbbmi_Resp_IB_v1>) System.JSON.deserialize(responseBean, List<Rbbmi_Resp_IB_v1>.class);
			return parseData;
		}
		return null;
	}

	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @param requestBean
	 * @param endpointSuffix
	 * @param integrationServiceName
	 * @param apexTypeP
	 * @return String
	 **/
	public static String integrationServiceCall(Base_IB requestBean, String endpointSuffix, String integrationServiceName, System.Type apexTypeP) {
		String responseBean = '';
		Sys_Log_Integration__c log;
		HttpRequest httpRequest;
		String methodName = integrationServiceName;
			List<Integration_Service__c> integrationServices = Sys_Utilities_Integration.getIntegrationServices(integrationServiceName);
			if (integrationServices != null && integrationServices.size() == 1) {
				httpRequest = Sys_Utilities_Integration.mapHttpRequest(integrationServices[0], '');
                httpRequest.setEndpoint(httpRequest.getEndpoint() + endpointSuffix);

				log = SystemLogger.createRequestIntegrationLog(httpRequest.getBody(), methodName, StringConstants.SALESFORCE_STRING, httpRequest.getEndpoint());
				String requestBeanValidationMessage = null;
					HttpResponse httpResponse = Sys_Utilities_Integration.serviceCalloutWithoutLogging(httpRequest);
					log = SystemLogger.mapResponseFields(log, httpResponse.getStatusCode(), httpResponse.getStatus(), httpResponse.getBody());
					if (httpResponse.getStatusCode() == 200) {
                        log = SystemLogger.mapResponseFields(log, httpResponse.getStatusCode(), httpResponse.getStatus(), httpResponse.getBody());
						responseBean = httpResponse.getBody();
					}
                    if (httpResponse.getStatusCode() == 400) {
					    String message = requestBeanValidationMessage;
					    log = SystemLogger.mapResponseFields(log, 400, StringConstants.STATUS_CODE_400, message);
                    }
                    if (httpResponse.getStatusCode() == 500) {
                        String message = requestBeanValidationMessage;
                        log = log = SystemLogger.mapResponseFields(log, 500, StringConstants.STATUS_CODE_500, message);
                    }
			} else {
				String message =
					'Error querying Integration Service. Expected to find exactly 1 record. Found ' +
					integrationServices.size() +
					' record(s). Service: ' +
					integrationServiceName +
					'. Environment: ' +
					Sys_Utilities_General.getEnvironment();
				String destinationSystem = integrationServiceName;
				log = SystemLogger.createInternalIntegrationLog(methodName, destinationSystem, 500, StringConstants.STATUS_CODE_500, message);
			}
		if (log != null) {
			SystemLogger.insertLog(log);
		}
		return responseBean;
	}

	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @param lineItemList
	 * @param accNumVSnotActivatedDayMap
	 **/
	public static void compareAndUpdateApplication(List<OpportunityLineItem> lineItemList, Map<String, Rbbmi_Resp_IB_v1> accNumVSnotActivatedDayMap) {
		Map<String, Rbbmi_Resp_IB_v1> applicationIdVSDaysMap = new Map<String, Rbbmi_Resp_IB_v1>();
		for (OpportunityLineItem lienItem : lineItemList) {
			if (accNumVSnotActivatedDayMap.containsKey(lienItem.Policy_Number__c)) {
				applicationIdVSDaysMap.put(lienItem.Application__c, accNumVSnotActivatedDayMap.get(lienItem.Policy_Number__c));
			}
		}
		List<Application__c> applicationListToUpdate = new List<Application__c>();
		for (Application__c app : [
			SELECT Id, Name, Account_Number__c, Number_of_days_account_has_not_activated__c, Number_of_days_with_no_transaction__c
			FROM Application__c
			WHERE Id IN :applicationIdVSDaysMap.keySet()
		]) {
			app.Number_of_days_account_has_not_activated__c = Decimal.valueOf(applicationIdVSDaysMap.get(app.Id).NumDaysAccountnotactivated);
			app.Number_of_days_account_has_not_activated__c = Decimal.valueOf(applicationIdVSDaysMap.get(app.Id).NumberOfdayswithNoTransaction);
			app.Product_Name__c = applicationIdVSDaysMap.get(app.Id).Product_Descr_New;
			app.Account_Number__c = applicationIdVSDaysMap.get(app.Id).Account_Number;
			app.Client_Name__c = applicationIdVSDaysMap.get(app.Id).ClientName;
			app.Client_Number__c = applicationIdVSDaysMap.get(app.Id).ClientNumber;
			app.Client_Email__c = applicationIdVSDaysMap.get(app.Id).ClientEmail;
			app.sd_Response_Email_Address__c = System.label.bbinstantaccount;
			Set<String> commPlanNames = new Set<String>();
			commPlanNames.add('Business Banking ECM Triggers on Application');
			List<sd_Communication_Plan__c> commPlan = new List<sd_Communication_Plan__c>();
			commPlan = new CommunicationPlansSelector().selectPlanByName(commPlanNames);
			app.sd_Communication_Plan_Id__c = commPlan != null ? commPlan[0].Id : null;
			applicationListToUpdate.add(app);
		}
		if (applicationListToUpdate != null) {
			update applicationListToUpdate;
		}
	}
}