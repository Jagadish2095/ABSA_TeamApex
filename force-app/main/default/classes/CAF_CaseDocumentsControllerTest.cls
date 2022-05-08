@isTest
public class CAF_CaseDocumentsControllerTest {
    @isTest
    static void testGetDocumentsForCase() {
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
            External_Reference_Type__c = 'BCMS'
        );
        insert caseRec;

        Application_Product_CAF__c aPC = new Application_Product_CAF__c();
        aPC.Case__c = caseRec.Id;
        insert aPC;

        caseRec.Application_Product_Id__c = aPC.Id;
        caseRec.External_Reference_Number__c = '0d7b9d05-a783-4c2d-b7fc-36f2396dd040';
        update caseRec;

        Document_Template__c cpb = new Document_Template__c(
            Name = 'Avaf contract',
            Document_Type__c = 'Avaf contract',
            ECM_Filing_Date_Metadata__c = true,
            ECM_ID_Number_Metadata__c = true,
            ECM_CIF_Code_Metadata__c = true,
            ECM_Origin_Metadata__c = true,
            ECM_Business_Unit_Metadata__c = true,
            ECM_Account_Number_Metadata__c = true
        );
        insert cpb;

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CAFGetCase_IH_v1.INTEGRATION_SERVICE_NAME, CAFGetDocumentsforCase_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{'ECM Query Path', 'ECM Authenication Path', 'ECM Add Path'});

        JitterbitAuthResponse authResponse = JitterbitAuthResponse.getExample();
        authResponse.token = '127168272819';

        RestClientUtils.QueueHttpMock queueHttpMock = new RestClientUtils.QueueHttpMock();
        queueHttpMock.addResponse(CAFGetCase_IH_v1_Test.POSITIVE_RESPONSE_BODY); // Mock response for CAFGetCase callout
        queueHttpMock.addResponse('{}'); // Mock response for SystemLogger.insertLog callout
        queueHttpMock.addResponse(CAFGetDocumentsforCase_IH_v1_Test.POSITIVE_RESPONSE_BODY); // Mock response for CAFGetDocumentsforCase callout
        queueHttpMock.addResponse('{}'); // Mock response for SystemLogger.insertLog callout
        queueHttpMock.addResponse(JSON.serialize(authResponse));
        queueHttpMock.addResponse(JSON.serialize(CC_GenerateContentResponse.getExample()));
        Test.setMock(HttpCalloutMock.class, queueHttpMock);

        Test.startTest();
        CAF_CaseDocumentsController.getDocumentsForCase(caseRec.Id);
        Test.stopTest();
    }
}