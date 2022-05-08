/**
 * @description System Logger will map fields for a log record of an Inbound and Outbound Integration call
 * the log record will be returNed to where it was called where the record will be inserted
 * @author  Danie Booysen and Jason Quevauvilliers
 * @created 2018-05-28
 * @Updated by Danie Booysen and Jason Quevauvilliers
 * @Updated Date 2018-08-16
 */

public class SystemLogger {
	private static final String REST_API_PATH_SYS_LOG_INTEGRATION = '/services/data/v48.0/sobjects/Sys_Log_Integration__c';

	/**
	 * @description Created log for the request
	 * @param requestP
	 * @param methodNameP
	 * @param sourceSystemP
	 * @param destinationSystemP
	 * @return Sys_Log_Integration__c
	 */
	public static Sys_Log_Integration__c createRequestIntegrationLog(String requestP, String methodNameP, String sourceSystemP, String destinationSystemP) {
		Sys_Log_Integration__c log = new Sys_Log_Integration__c();
		log.Request_Timestamp__c = System.now();
		log.Request__c = Sys_Utilities_General.truncateFieldIfNeeded(
			requestP,
			Sys_Utilities_General.getSObjectFieldLength(StringConstants.SYS_LOGGER_OBJ_NAME, StringConstants.REQUEST_FIELD_NAME)
		);
		log.Method_Name__c = methodNameP;
		log.Source_System__c = sourceSystemP;
		log.Destination_System__c = destinationSystemP;
		log.User_Name__c = UserInfo.getName();

		if (sourceSystemP == StringConstants.SALESFORCE_STRING) {
			log.Log_Type__c = StringConstants.OUTBOUND_RECORD_TYPE;
		} else {
			log.Log_Type__c = StringConstants.INBOUND_RECORD_TYPE;
		}
		return log;
	}

	/**
	 * @description map audit fields
	 * @param logP
	 * @param transactionId
	 * @param initiatorP
	 * @param senderP
	 * @return Sys_Log_Integration__c
	 */
	public static Sys_Log_Integration__c mapAuditFields(Sys_Log_Integration__c logP, String transactionId, String initiatorP, String senderP) {
		logP.Transaction_Id__c = transactionId;
		logP.Initiator__c = initiatorP;
		logP.Sender__c = senderP;
		return logP;
	}

	/**
	 * @description map response fields
	 * @param logP
	 * @param statusCodeP
	 * @param statusP
	 * @param responseP
	 * @return Sys_Log_Integration__c
	 */
	public static Sys_Log_Integration__c mapResponseFields(Sys_Log_Integration__c logP, Integer statusCodeP, String statusP, String responseP) {
		logP.Response_Timestamp__c = System.now();
		logP.Status_Code__c = statusCodeP;
		logP.Status__c = statusP;
		logP.Response__c = Sys_Utilities_General.truncateFieldIfNeeded(
			responseP,
			Sys_Utilities_General.getSObjectFieldLength(StringConstants.SYS_LOGGER_OBJ_NAME, StringConstants.RESPONSE_FIELD_NAME)
		);
		return logP;
	}

	/**
	 * @description internal log
	 * @param methodNameP
	 * @param destinationSystemP
	 * @param statusCodeP
	 * @param statusP
	 * @param responseP
	 * @return Sys_Log_Integration__c
	 */
	public static Sys_Log_Integration__c createInternalIntegrationLog(
		String methodNameP,
		String destinationSystemP,
		Integer statusCodeP,
		String statusP,
		String responseP
	) {
		Sys_Log_Integration__c log = new Sys_Log_Integration__c();
		log.Request_Timestamp__c = System.now();
		log.Method_Name__c = methodNameP;
		log.Source_System__c = StringConstants.SALESFORCE_STRING;
		log.Destination_System__c = destinationSystemP;
		log.Status_Code__c = statusCodeP;
		log.Status__c = statusP;
		log.Response__c = Sys_Utilities_General.truncateFieldIfNeeded(
			responseP,
			Sys_Utilities_General.getSObjectFieldLength(StringConstants.SYS_LOGGER_OBJ_NAME, StringConstants.RESPONSE_FIELD_NAME)
		);
		log.Log_Type__c = StringConstants.OUTBOUND_RECORD_TYPE;
		log.User_Name__c = UserInfo.getName();

		return log;
	}

	/**
	 * @description PJAIN: 20200527
	 * This method inserts the log record using REST API. This is to get around the
	 * callout-dml-callout issue which results in 'You have uncommitted work pending'
	 * exception. So it would result in a callout rather than DML to insert logs.
	 * Updated: JQUEV 20210315
	 * Added check for DML Statements. IF DML has occurred in the transaction then Insert rather then performing a callout
	 * @param logP
	 */
	public static void insertLog(Sys_Log_Integration__c logP) {
		try {
			if (Limits.getDMLStatements() > 0) {
				insert logP;
			} else {
				String endpoint = 'callout:MetaDataAccess' + REST_API_PATH_SYS_LOG_INTEGRATION;

				HttpRequest req = new HttpRequest();
				req.setEndpoint(endpoint);
				req.setHeader('Authorization', 'OAuth {!$Credential.OAuthToken}');
				req.setHeader(StringConstants.CONTENT_TYPE_STRING, StringConstants.APPLICATION_JSON_STRING);
				req.setMethod(StringConstants.HTTP_POST_STRING);
				req.setBody(JSON.serialize(logP));
				Http http = new Http();
				HTTPResponse res = http.send(req);
			}
		} catch (CalloutException ce) {
			//CalloutException to catch the event where http.send still causes an error even when no DMLs were performed.
			System.debug('SystemLogger.insertLog.CalloutException. Inserting Log with DML. Original Exception: ' + ce.getMessage());
			//Insert Log with DML
			insert logP;
		} catch (Exception e) {
			// In case of exception, DO NOTHING other than logging the error
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			System.debug('SystemLogger.insertLog.exception message: ' + message);
		}
	}
}