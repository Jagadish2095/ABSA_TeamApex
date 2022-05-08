/*
 * Request Integration Bean for ExergyPolicyGetCover Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

 @isTest
 public class PRICreationByCommSystem_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"Envelope":{"Body": {"PRIResponses": [{"PRIResponse": {"PRINumber": "232930159016","ProductCode": "99999999","ErrorMessage": null,"StatusCode": "200","Status": "UPDATED","ProposalNumber": "0067Z00000OJJwBQAX"}}],"Result": {"TransactionId": "207e843a-bcea-4fbc-be99-99b7380f8585","Code": "0","Status": "Success","Description": "Query successful"}}}}';
		
    	@TestSetup
    	static void makeData(){
        	IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PRICreationByCommSystem_IH_v1.INTEGRATION_SERVICE_NAME});
    	}
		
    	@isTest static void testPositive() {
        	// Set mock callout class
        	

        	Test.startTest();
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        	PRICreationByCommSystem_Resp_IB_v1 responseBean = callHandlerMethod();
        	Test.stopTest();
    	}

    	private static PRICreationByCommSystem_Resp_IB_v1 callHandlerMethod() {
            PRICreationByCommSystem_Resp_IB_v1 responseBean = new PRICreationByCommSystem_Resp_IB_v1();
            List<User> usersList = new List<User>();
			System.runAs(new User(Id = UserInfo.getUserId())) {
				usersList = TestDataFactory.getTestUsers('System Administrator (Custom)', 2);
				usersList[0].Business_Area__c = 'WIMI';
				insert usersList;
			} 
			List<User> usersList1 = [SELECT Id FROM User WHERE username LIKE '%testuser1%'];
			RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'DD STI Opportunity'];
			Financial_Product__c newProd = new Financial_Product__c(
                Name = 'STI',
                Description__c = 'STI',  
                Product__c = 'STI', 
                Sub_Product__c = 'STI',
                Business_Unit__c = 'Direct Delivery'
            );
            insert newProd;
			System.runAs(usersList1[0]) {
				List<Account> accListInsert = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
				accListInsert[0].PersonBirthdate = date.parse('06/07/1900');
                accListInsert[0].Phone = '0845563377';
                accListInsert[0].PersonHomePhone = '0845563377';
                accListInsert[0].Work_Phone__c = '0845563377';
				insert accListInsert;
				Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
				testOpportunity.RecordTypeId = rt.Id;
				testOpportunity.accountid = accListInsert[0].id;
                testOpportunity.STI_Policy_Number__c = '87452659';
				testOpportunity.Policy_Inception_Date__c = System.today();
				testOpportunity.Product_Provider__c = 'AIC/WEBSURE';
				testOpportunity.Policy_Income_Type__c = 'ST Personal Lines Code 54';
            	testOpportunity.StageName = 'Quote';
                testOpportunity.Product_Interest__c = newProd.Id;
				update testOpportunity;
        		responseBean = PRICreationByCommSystem_IH_v1.GetPRIforAtowrk(testOpportunity.Id);
            }
        	PRICreationByCommSystem_Req_IB_v1 dummyBean = PRICreationByCommSystem_Req_IB_v1.createDummyRequest();
        	
        	return responseBean;
    	}
}