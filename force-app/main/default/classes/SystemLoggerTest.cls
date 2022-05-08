/*
 * Test Integration Handler for TransunionProcessRequest41 Service
 * @author Prashant Jain
 * @created 2020-05-20
 */

@isTest
public class SystemLoggerTest {
	@isTest
	public static void testAllMethods() {
		Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog('requestP', 'methodNameP', 'sourceSystemP', 'destinationSystemP');
		System.assertNotEquals(null, log, 'Assert Failed');

		log = SystemLogger.createRequestIntegrationLog('requestP', 'methodNameP', StringConstants.SALESFORCE_STRING, 'destinationSystemP');
		System.assertNotEquals(null, log, 'Assert Failed');

		log = SystemLogger.mapAuditFields(log, 'transactionId', 'initiatorP', 'senderP');
		System.assertNotEquals(null, log, 'Assert Failed');

		log = SystemLogger.mapResponseFields(log, 200, 'statusP', 'responseP');
		System.assertNotEquals(null, log, 'Assert Failed');

		log = SystemLogger.createInternalIntegrationLog('methodNameP', 'destinationSystemP', 200, 'statusP', 'responseP');
		System.assertNotEquals(null, log, 'Assert Failed');

		//This would Insert the log via http.send
		SystemLogger.insertLog(log);
		// insertLog is a void method so nothing to assert
		//Perform DML to trigger a DML on the next method call
		insert log;
		SystemLogger.insertLog(log);
		// insertLog is a void method so nothing to assert
	}
}