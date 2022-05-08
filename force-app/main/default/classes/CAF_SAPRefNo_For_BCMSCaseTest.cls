/** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @return 
    * @param 
    
    */
@isTest
public class CAF_SAPRefNo_For_BCMSCaseTest {
     /** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
   
    */
    @isTest 
    static void testFetchSAPNo() {
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Email__c = 'wow@absa.com',
            Bypass_Validation_Rules__c = true,
            Risk_Management_Centre__c = 'Digital Fraud',
            External_Reference_Type__c = 'BCMS',
            Get_SAP_Ref_No__c = true
        );
        insert caseRec;
        
        Application_Product_CAF__c aPC = new Application_Product_CAF__c();
        aPC.Case__c = caseRec.Id;
        insert aPC;

        caseRec.Application_Product_Id__c = aPC.Id;
        caseRec.External_Reference_Number__c = '0d7b9d05-a783-4c2d-b7fc-36f2396dd040';
        update caseRec;
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CAFGetCase_IH_v1.INTEGRATION_SERVICE_NAME, CAFGetDocumentsforCase_IH_v1.INTEGRATION_SERVICE_NAME});
        JitterbitAuthResponse authResponse = JitterbitAuthResponse.getExample();
        authResponse.token = '127168272819';
        
        RestClientUtils.QueueHttpMock queueHttpMock = new RestClientUtils.QueueHttpMock();
        queueHttpMock.addResponse(CAFGetCase_IH_v1_Test.POSITIVE_RESPONSE_BODY); // Mock response for CAFGetCase callout
        queueHttpMock.addResponse('{}'); // Mock response for SystemLogger.insertLog callout
        queueHttpMock.addResponse(JSON.serialize(authResponse));
        queueHttpMock.addResponse(JSON.serialize(CC_GenerateContentResponse.getExample()));
        Test.setMock(HttpCalloutMock.class, queueHttpMock);
        
        String cronexpression = '0 0 0 15 3 ? *';
        
        Test.startTest();
        	//CAF_SAPRefNo_For_BCMSCase b = new CAF_SAPRefNo_For_BCMSCase();
        	//Database.executeBatch(b);  
        	String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new CAF_SAPRefNo_For_BCMSCase_ScheduleBatch());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];   
        	System.assertEquals(cronexpression, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();        
    }
}