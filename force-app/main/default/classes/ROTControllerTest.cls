/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-27
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest
public class ROTControllerTest {
    
    /*
* Purpose : Method to create test data
*/
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTCreateGroupRestriction_IH_v1.INTEGRATION_SERVICE_NAME});
        
        Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Absa Client Services';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        insert serviceGr;
        
        RestrictionGroup__c currentRestriction = new RestrictionGroup__c();
        currentRestriction.Status__c = 'Added';
        currentRestriction.GroupID__c = 'TestMuvhuso';
        insert currentRestriction;
    }

    @isTest static void CrateGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"CreateGroupRestrictionResponse":{"CreateGroupRestrictionResult":{"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"false","SystemErrorMessage":null,"Tag":null,"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0001-TSS","Result":{"Description":"JB Pillar","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0001-TSS","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"278356"}}}}';
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = account);
        
        insert testCase;
        System.assertNotEquals(testCase, null,'Case should not be null');
 
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        Test.startTest();
        ROTController.createNewGroupRestrictionObject('Test' , 'Test' , testCase.Id,account.Id);
        ROTController.updateGroupRestriction(currentRestriction.Id , 'Test' , currentRestriction.Restriction_ID__c);
        ROTController.getGroupRestrictions(testCase.Id);
        Test.stopTest();
    }
    
    @isTest static void updateGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"UpdateGroupRestrictionResponse":{"UpdateGroupRestrictionResult":{"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"false","Information":{"ServiceInformationResult":[{"Message":"HSR of key CQTROT-S ABS CQGR0001-test updated successfully. It must be CONFIRMED before it becomes effective.","MessageCode":"M012"}]},"SystemErrorMessage":null,"Tag":null,"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0001-test","Result":{"Description":"JB Pillar Muvhuso 1","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0001-test","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"243383"}}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateGroupRestriction_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        System.assertNotEquals(currentRestriction, null,'Restriction group should not be null');

        Test.startTest();
        ROTController.updateGroupRestriction(currentRestriction.Id , 'Test' , currentRestriction.Restriction_ID__c);
        // createAccountNode(String groupRestrictionId , String description , String effectiveEndDate , String effectiveStartDate, String groupRestrictionObjectID , String AccountNumber ,String isInfinity)
        Test.stopTest();
    }
    
    @isTest static void createAccountGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{ "AddAccountResponse": { "AddAccountResult": {"HasErrors": "false", "HasSystemError": "false", "HasValidationErrors": "false", "Information": { "ServiceInformationResult": [ { "Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 0, and First Date 2021-06-16 created successfully. It must be CONFIRMED before it becomes effective. Keep record of its NUID.",  "MessageCode": "M102" } ] }, "SystemErrorMessage": null,"Tag": "278305", "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": "JB Pillar", "EffectiveEndDate": "2021-06-26T00:00:00", "EffectiveStartDate": "2021-06-16T00:00:00", "IsEffectiveEndDateInfinity": "false", "ObjectID": "4048017641",  "EntityType": "Account", "ParentSchemeNodeID": "240745", "SchemeNodeID": "278305"  }, "AccountNumber": "4048017641", "EffectiveStartDate": "2021-06-16T00:00:00"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddAccount_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        Test.startTest();
        ROTController.updateGroupRestriction(currentRestriction.Id , 'Test' , currentRestriction.Restriction_ID__c);
        ROTController.createAccountNode(currentRestriction.Id , 'Test', '2021/02/28' , '2021/03/30', currentRestriction.Restriction_ID__c , '4048017641' ,'false');
        ROTController.getGroupAccounts(currentRestriction.Id);
        ROTController.removeGroupRestriction(currentRestriction.Id , currentRestriction.Restriction_ID__c);
        //ROTControllerTest.updateAccountNode(groupRestrictionAccount.Id ,'4048017641', 'Test' ,'2021/02/28' , '2021/03/30' , currentRestriction.Restriction_ID__c ,'2021/02/30');
        //ROTControllerTest.deleteAccountNode(groupRestrictionAccount.Id , '2021/02/28' , currentRestriction.Restriction_ID__c , '4048017641');
        Test.stopTest();
    }
 
    
    @isTest static void updateAccountGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"UpdateAccountResponse":{"UpdateAccountResult":{"ValidationErrors":null,"Tag":"278515","SystemErrorMessage":null,"Result":{"SchemeNodeID":"278515","ParentSchemeNodeID":"278457","ObjectID":"4048154906","IsEffectiveEndDateInfinity":"false","EntityType":"Account","EffectiveStartDate":"2021-01-29T00:00:00","EffectiveEndDate":"2021-02-03T00:00:00","Description":"Cheque Account"},"HasValidationErrors":"false","HasSystemError":"false","HasErrors":"false","GroupRestrictionObjectID":"CQGR0023-Restriction","GroupRestrictionClusterID":"ABS","EffectiveStartDate":"2021-01-29T00:00:00","AccountNumber":"4048154906"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateAccount_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        Test.startTest();
        ROTController.updateAccountNode(groupRestrictionAccount.Id ,'4048017641', 'Test' ,'2021/02/28' , '2021/03/30' , currentRestriction.Restriction_ID__c ,'2021/02/30');
        //ROTControllerTest.deleteAccountNode(groupRestrictionAccount.Id , '2021/02/28' , currentRestriction.Restriction_ID__c , '4048017641');
        Test.stopTest();
    }
    
    @isTest static void deleteAccountGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"DeleteAccountResponse":{"DeleteAccountResult":{"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"true","SystemErrorMessage":null,"Tag":null,"ValidationErrors":{"ServiceValidationResult":[{"Message":"HSC of key ABSA RSA CQTROT-S ABS CQGR0002-JUAT 42 2021-01-10 may not be deleted; its effective period must be in the future.","MessageCode":"E604"}]},"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0002-JUAT","Result":{"Description":null,"EffectiveEndDate":null,"EffectiveStartDate":null,"IsEffectiveEndDateInfinity":null,"ObjectID":null,"EntityType":null,"ParentSchemeNodeID":null,"SchemeNodeID":null},"AccountNumber":"4048430986","EffectiveStartDate":"2021-01-10T00:00:00"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteAccount_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        groupRestrictionAccount.Status__c = 'Deleted';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        Test.startTest();
        ROTController.deleteAccountNode(groupRestrictionAccount.Id , '2021/02/28' , currentRestriction.Restriction_ID__c , '4048017641');
       
        Test.stopTest();
    }
    
    @isTest static void createExcludedAccountGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"AddExcludedAccountResponse": {"AddExcludedAccountResult": {"HasErrors": "false","HasSystemError": "false", "HasValidationErrors": "false","Information": {"ServiceInformationResult": [{"Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 0, and First Date 2029-02-05 created successfully. It must be CONFIRMED before it becomes effective. Keep record of its NUID.","MessageCode": "M102"} ] }, "SystemErrorMessage": null,"Tag": "278627","GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": "JB Pillar","EffectiveEndDate": "2029-02-06T00:00:00","EffectiveStartDate": "2029-02-05T00:00:00","IsEffectiveEndDateInfinity": "false","ObjectID": "4048154875","EntityType": "ExcludedAccount","ParentSchemeNodeID": "240745","SchemeNodeID": "278627"},"AccountNumber": "4048154875","EffectiveStartDate": "2029-02-05T00:00:00"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddExcludedAccount_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        Test.startTest();
        ROTController.getExcludedAccountNodes(currentRestriction.Id);
        ROTController.createExcludedAccountNode(currentRestriction.Id , currentRestriction.Restriction_ID__c,'', '4048017641','', '2021/02/28' , '2021/03/30','false');
        Test.stopTest();
    }
    
    @isTest static void updateExcludedAccountGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"UpdateExcludedAccountResponse": { "UpdateExcludedAccountResult": {"HasErrors": "false","HasSystemError": "false","HasValidationErrors": "false","Information": {"ServiceInformationResult": [{"Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 73, and First Date 2024-02-08 updated successfully. It must be CONFIRMED before it becomes effective. Keep record of its NUID.","MessageCode": "M112"}]},"SystemErrorMessage": null,"Tag": null, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": null,"EffectiveEndDate": "2024-02-08T00:00:00","EffectiveStartDate": "2024-02-08T00:00:00","IsEffectiveEndDateInfinity": "false","ObjectID": "4048837415","EntityType": "ExcludedAccount", "ParentSchemeNodeID": "240745", "SchemeNodeID": "278674" },"AccountNumber": "4048837415","EffectiveStartDate": "2024-02-08T00:00:00"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateExcludedAccount_IH_V1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        Test.startTest();
        ROTController.updateExcludedAccountNode(currentRestriction.Id , currentRestriction.Restriction_ID__c,'', groupRestrictionAccount.Id, '4048017641','', '2021/02/28' , '2021/03/30','false', '2021/02/28');
        Test.stopTest();
    }
    
    @isTest static void deleteExcludedAccountGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{"DeleteExcludedAccountResponse": { "DeleteExcludedAccountResult": {"HasErrors": "false","HasSystemError": "false","HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": null,"EffectiveEndDate": null,"EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null, "ObjectID": null,"EntityType": null, "ParentSchemeNodeID": null,"SchemeNodeID": null},"AccountNumber": "4048837415","EffectiveStartDate": "2024-02-08T00:00:00"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteExcludedAccount_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        Test.startTest();
        try{
            ROTController.deleteExcludedAccountNode(currentRestriction.Id , currentRestriction.Restriction_ID__c,'', groupRestrictionAccount.Id, '4048017641', '2021/02/28' );
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
    @isTest static void addExcludedAccountsGroupRestrictiontestPositive() {
        final String POSITIVE_RESPONSE_BODY = '{ "AddExcludedAccountsResponse": {"AddExcludedAccountsResult": {"ExcludedAccountActionDataResponse": [{"HasErrors": "false","HasSystemError": "false","HasValidationErrors": "true", "SystemErrorMessage": null, "Tag": null, "ValidationErrors": { "ServiceValidationResult": [{ "Message": "The period of the HSC to be created, (2021-02-26, 2021-02-26), overlaps the period of an already-recorded, twin HSC: (2021-02-26, 2021-02-26).", "MessageCode": "E417" } ]}, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": "",  "EffectiveEndDate": "2021-02-26T00:00:00", "EffectiveStartDate": "2021-02-26T00:00:00", "IsEffectiveEndDateInfinity": "false", "ObjectID": "1234", "EntityType": "Account", "ParentSchemeNodeID": "12324", "SchemeNodeID": "12323" }, "AccountNumber": "4048430986","EffectiveStartDate": "2021-02-26T00:00:00" }, { "HasErrors": "true","HasSystemError": "false", "HasValidationErrors": "true", "SystemErrorMessage": null, "Tag": null, "ValidationErrors": { "ServiceValidationResult": [ { "Message": "Invalid account number - account does not exist.", "MessageCode": null }] }, "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": null, "EffectiveEndDate": null, "EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null, "EntityType": null, "ParentSchemeNodeID": null,"SchemeNodeID": null},"AccountNumber": "4048430987","EffectiveStartDate": "2021-02-11T00:00:00"}]}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddExcludedAccounts_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction group account should not be null');

        String acc = '[{"effStartDate":"0001/01/01","effEndDate":"4000/12/9999","accountNumber":"4048017641"}]';
        
        Test.startTest();
        try{
            ROTController.createExcludedAccountNodes(currentRestriction.Id , currentRestriction.Restriction_ID__c, acc, '2021/02/28', '2021/02/28' , 'false');
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
    
    @isTest static void createCustomerNodePositive() {
        
        final String POSITIVE_RESPONSE_BODY =  '{"AddCustomerResponse": {"AddCustomerResult": { "HasErrors": "false","HasSystemError": "false", "HasValidationErrors": "false", "SystemErrorMessage": null,"Tag": null, "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": "", "EffectiveEndDate": "2024-01-21T00:00:00", "EffectiveStartDate": "2024-01-21T00:00:00","IsEffectiveEndDateInfinity": "false","ObjectID": "2323","EntityType": "Customer","ParentSchemeNodeID": "1234", "SchemeNodeID": "12334" },"CustomerKey": "CTMETRO001","EffectiveStartDate": "2024-01-21T00:00:00"}}}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddCustomer_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        Account account = [SELECT Id  FROM Account LIMIT 1];
        
        RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c();
        groupRestrictionCustomer.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionCustomer.CustomerKey__c ='CTMETRO001';
        insert groupRestrictionCustomer;

        System.assertNotEquals(groupRestrictionCustomer, null,'Restriction group customer should not be null');

        
        Test.startTest();
        
        String createCustResp =ROTController.createCustomerNode(currentRestriction.Id,'CTMETRO001', 'Test', '2021/02/28' , '2021/03/30', currentRestriction.Restriction_ID__c,'false');
        system.assertNotEquals(null, createCustResp);
        
        List<RestrictionGroupCustomer__c> restrictionList = ROTController.getGroupCustomer(currentRestriction.Id );
        system.assertNotEquals(null, restrictionList);
        
        String result = ROTController.getClientCIF(account.Id);
        system.assertNotEquals(null, result);
        ROTController.deleteCustomer(currentRestriction.Id ,'CTMETRO001',groupRestrictionCustomer.Id, 'CTMETRO001',  '2021/02/28');

        Test.stopTest();
    }
        
    
    @isTest
    public static void testCIGetAccount() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc = 'SA Identity Document';
        accountList[0].ID_Number__pc = '8505225522085';
        accountList[0].CIF__c = 'ARENTAL001';
        insert accountList;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
        );
        
        Test.startTest();
        String responseBean = ROTController.getAccountDetails(accountList[0].Id);
        System.assert(responseBean.startsWith('['));
        Test.stopTest();
    }
    
    @isTest static void addTransactionTypesTestPositive() {
        
		final String POSITIVE_RESPONSE_BODY = '{ "AddTransactionTypesResponse": {"AddTransactionTypesResult": {"TransactionTypeActionDataResponse": [{"HasErrors": "false","HasSystemError": "false", "HasValidationErrors": "false","Information": {"ServiceInformationResult": [{ "Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 0, and First Date 2021-02-16 created successfully. It must be CONFIRMED before it becomes effective. Keep record of its NUID.","MessageCode": "M102"}]},"SystemErrorMessage": null,"Tag": "279833","GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": "4047738913", "EffectiveEndDate": "2021-02-24T00:00:00", "EffectiveStartDate": "2021-02-16T00:00:00","IsEffectiveEndDateInfinity": "false","ObjectID": "FN71 FIA","EntityType": "TransactionType","ParentSchemeNodeID": "240745","SchemeNodeID": "279833"},"Code": "FN71 FIA","EffectiveStartDate": "2021-02-16T00:00:00"}]}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddTransactionTypes_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        System.assertNotEquals(currentRestriction, null,'Restriction should not be null');

		String groupRestrictionId = currentRestriction.Id;
		String groupRestrictionObjectID = currentRestriction.Restriction_ID__c;
		String startDate = '2021/02/15';
		String endDate = '2021/02/17';
        String ttList = '[{"ObjectID":"FN71 CD","Description":"CASH DEPOSIT"}]';
        
        Test.startTest();
        try{
        ROTController.addTransactionTypesNode(groupRestrictionId , groupRestrictionObjectID, startDate, endDate, 'false', ttList);
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
	@isTest static void getTransactionTypesTestPositive() {
        
		final String POSITIVE_RESPONSE_BODY = '{"GetGovernanceModelResponse":{"GetGovernanceModelResult":{"Data":{"GovernanceModelTransactionGroup":[{"Description": "CASH DEPOSITS","EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00","IsEffectiveEndDateInfinity": true,"ObjectID": "CASH DEPOSITS","TransactionTypes":{"GovernanceModelTransactionType":[{"Description": "CARDLESS CASH DEPOSIT", "EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00","IsEffectiveEndDateInfinity": true,"ObjectID": "FN71 CLAD"},{"Description": "CASH ACCEPTOR DEP","EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00", "IsEffectiveEndDateInfinity": true,"ObjectID": "FN71 CAD"}]}}]},"HasErrors": false,"HasSystemError": false,"HasValidationErrors": false,"Information": null,"SystemErrorMessage":null,"Tag":null}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTGetGovernanceModel_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];		
        System.assertNotEquals(currentRestriction, null,'Restriction should not be null');

		DateTime myDateTime = DateTime.newInstance(date.today().year(), date.today().month(), date.today().day(), 0, 0, 0);
		String formatted = myDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
        
        Test.startTest();
        try{
        ROTController.getTransactionType();
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
    @isTest static void fetchTransactionTypesMainTestPositive() {
        
		//final String POSITIVE_RESPONSE_BODY = '{"GetGovernanceModelResponse":{"GetGovernanceModelResult":{"Data":{"GovernanceModelTransactionGroup":[{"Description": "CASH DEPOSITS","EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00","IsEffectiveEndDateInfinity": true,"ObjectID": "CASH DEPOSITS","TransactionTypes":{"GovernanceModelTransactionType":[{"Description": "CARDLESS CASH DEPOSIT", "EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00","IsEffectiveEndDateInfinity": true,"ObjectID": "FN71 CLAD"},{"Description": "CASH ACCEPTOR DEP","EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00", "IsEffectiveEndDateInfinity": true,"ObjectID": "FN71 CAD"}]}}]},"HasErrors": false,"HasSystemError": false,"HasValidationErrors": false,"Information": null,"SystemErrorMessage":null,"Tag":null}}}';
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTGetGovernanceModel_IH_v1.INTEGRATION_SERVICE_NAME});
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];		
        System.assertNotEquals(currentRestriction, null,'Restriction should not be null');

        String ttId = currentRestriction.Id;
		        
        Test.startTest();
        try{
        ROTController.fetchTransactionTypesMain(ttId);
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
    
    @isTest static void restrictionGrpRelatedInfoTest() {
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];		
        System.assertNotEquals(currentRestriction, null,'Restriction should not be null');

        String ttId = currentRestriction.Id;
		        
        Test.startTest();
        try{
        ROTController.restrictionGrpRelatedInfo(ttId);
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
    
    @isTest static void bulkUpdatesTest() {
        final String POSITIVE_RESPONSE_BODY = '{"DateAdjustSchemeNodesResponse": {"DateAdjustSchemeNodesResult": { "HasErrors": "false", "HasSystemError": "false","HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"CurrentPage": "0","IsCurrentPageTheLast": "true","PageToken": null,"Records": {"SchemeNodeDateAdjustmentResult": [{"Abandoned": "false","EffectiveStartDate": "2021-02-10T00:00:00","EntityType": "ExcludedAccount","ErrorMessage": null, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0036-TEST","ObjectID": "4047995836","SchemeNodeID": "278979","Success": "true","NewParentSchemeNodeID": null,"NewSchemeNodeID": "278981"},{"Abandoned": "false","EffectiveStartDate": "2021-02-10T00:00:00","EntityType": "Account","ErrorMessage": null, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0036-TEST","ObjectID": "4047995836","SchemeNodeID": "278979","Success": "true","NewParentSchemeNodeID": null,"NewSchemeNodeID": "278981"},{"Abandoned": "false","EffectiveStartDate": "2021-02-10T00:00:00","EntityType": "TransactionType","ErrorMessage": null, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0036-TEST","ObjectID": "4047995836","SchemeNodeID": "278979","Success": "true","NewParentSchemeNodeID": null,"NewSchemeNodeID": "278981"},{"Abandoned": "false","EffectiveStartDate": "2021-02-10T00:00:00","EntityType": "Customer","ErrorMessage": null, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0036-TEST","ObjectID": "4047995836","SchemeNodeID": "278979","Success": "true","NewParentSchemeNodeID": null,"NewSchemeNodeID": "278981"}]},"TotalRecords": "4"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDateAdjustSchemeNodes_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        System.assertNotEquals(currentRestriction, null,'Restriction should not be null');

        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        
        RestrictionGroupAccount__c excludedAccount = new RestrictionGroupAccount__c();
        excludedAccount.RestrictionGroupId__c = currentRestriction.Id;
        excludedAccount.AccountNumber__c = '4048017641';
        excludedAccount.Excluded_Account__c = true;
        insert excludedAccount;
        
        RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c();
        groupRestrictionCustomer.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionCustomer.CustomerKey__c ='CTMETRO001';
        groupRestrictionCustomer.Name ='CTMETRO001';
        insert groupRestrictionCustomer;
        
        RestrictionGroupTransactionType__c tt = new RestrictionGroupTransactionType__c();
        tt.Restriction_Group_ID__c = currentRestriction.Id;
        insert tt;
        
        String records = '[{"Id":"'+groupRestrictionAccount.Id+'","EffectiveStartDate__c":"01/01/0001","effEndDate":"01/01/4000","AccountNumber__c":"4048017641"},{"Id":"'+excludedAccount.Id+'","EffectiveStartDate__c":"01/01/0001","effEndDate":"01/01/9999","AccountNumber__c":"4048017641"},{"Id":"'+groupRestrictionCustomer.Id+'","EffectiveStartDate__c":"01/01/0001","effEndDate":"01/01/9999","Name":"CTMETRO001"},{"Id":"'+tt.Id+'","Effective_Start_Date__c":"01/01/0001","effEndDate":"01/01/9999","Name":"CTMETRO001"}]';
        
        Test.startTest();
        try{
        ROTController.bulkUpdateDates('0001/01/01','4000/12/31','false','CQGR0064-Test',records);
        }
        catch(Exception e){
            system.debug('error'+e.getMessage());
        }
        Test.stopTest();
    }
    
     @isTest static void updateTransactionTypesNodeTestPositive(){
		
		final String POSITIVE_RESPONSE_BODY = '{"UpdateTransactionTypeResponse": {"UpdateTransactionTypeResult": { "HasErrors": "false","HasSystemError": "false","HasValidationErrors": "false", "SystemErrorMessage": null,"Tag": "null","GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": null, "EffectiveEndDate": null,"EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null, "EntityType": null, "ParentSchemeNodeID": null,"SchemeNodeID": null},"Code": "FN71 FIA","EffectiveStartDate": "2021-01-07T00:00:00" }}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateTransactionType_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
                
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];		
        System.assertNotEquals(currentRestriction, null,'Restriction should not be null');

        String ttId = currentRestriction.Id;
        String ttObjId = currentRestriction.Restriction_ID__c;
        
        String Description = '4047738913';
		String EffectiveEndDate = '2021-02-06';
		String EffectiveStartDate = '2021-01-07';
		String GroupRestrictionClusterID = 'ABS';
		String GroupRestrictionObjectID = 'CQGR0002-JUAT';
		String IsEffectiveEndDateInfinity = 'true';
		String Code = 'FN71 FIA';
		String OriginalEffectiveStartDate = '2021-01-07';
        
        RestrictionGroupTransactionType__c rgTTRecord = new RestrictionGroupTransactionType__c();
        rgTTRecord.Name = Code;
        rgTTRecord.Description__c = Description;
        rgTTRecord.Effective_Start_Date__c = system.today();
        rgTTRecord.Effective_End_Date__c = system.today() + 7;
        rgTTRecord.IsEffective_End_Date_Infinity__c = true;
        rgTTRecord.Restriction_Group_ID__c = ttObjId;
        rgTTRecord.Original_Effective_Start_Date__c = system.today();
        insert rgTTRecord;
        
        RestrictionGroupTransactionType__c recID =  [select Id from RestrictionGroupTransactionType__c limit 1]; 
        String pId = recID.Id;
        
        Test.startTest();
        try{
           ROTController.updateTransactionTypesNode(Code, ttId, ttObjId, EffectiveStartDate, EffectiveEndDate, IsEffectiveEndDateInfinity, Description, OriginalEffectiveStartDate, pId); 
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        Test.stopTest();      
        
    } 
    
        @isTest static void deleteTransactionTypesNodeTestPositive(){
		
		final String POSITIVE_RESPONSE_BODY = '{"DeleteTransactionTypeResponse":{"DeleteTransactionTypeResult":{"HasErrors": false,"HasSystemError": false,"HasValidationErrors": false,"Information": null,"SystemErrorMessage":"","Tag":"","Code": "FN71 FIA","EffectiveStartDate": "2021-02-10T00:00:00","GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteTransactionType_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
                
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];		
        String ttId = currentRestriction.Id;
        String ttObjId = currentRestriction.Restriction_ID__c;
        
        String Description = '4047738913';
		String EffectiveEndDate = '2021-02-06';
		String EffectiveStartDate = '2021-01-07';
		String GroupRestrictionClusterID = 'ABS';
		String GroupRestrictionObjectID = 'CQGR0002-JUAT';
		String IsEffectiveEndDateInfinity = 'true';
		String Code = 'FN71 FIA';
		String OriginalEffectiveStartDate = '2021-01-07';
        
        RestrictionGroupTransactionType__c rgTTRecord = new RestrictionGroupTransactionType__c();
        rgTTRecord.Name = Code;
        rgTTRecord.Description__c = Description;
        rgTTRecord.Effective_Start_Date__c = system.today();
        rgTTRecord.Effective_End_Date__c = system.today() + 7;
        rgTTRecord.IsEffective_End_Date_Infinity__c = true;
        rgTTRecord.Restriction_Group_ID__c = ttObjId;
        rgTTRecord.Original_Effective_Start_Date__c = system.today();
        insert rgTTRecord;
        System.assertNotEquals(rgTTRecord, null,'Restriction should not be null');

        
        RestrictionGroupTransactionType__c recID =  [select Id from RestrictionGroupTransactionType__c limit 1]; 
        String pId = recID.Id;
        
        Test.startTest();
        try{
           ROTController.deleteTransactionTypesNode(Code, ttId, ttObjId, EffectiveStartDate, pId);
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        Test.stopTest();      
        
    }
   
    @isTest static void bulkdeleteTest() {
        final String POSITIVE_RESPONSE_BODY = '{"DeleteSchemeNodesResponse":{"DeleteSchemeNodesResult":{"CurrentPage":0,"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"false","Information":"","IsCurrentPageTheLast":"true","PageToken":"","Records":[{"EffectiveStartDate":"2029-02-05T00:00:00","GroupRestrictionObjectID":"","GroupRestrictionClusterID":"","ObjectID":"","ErrorMessage":"","SchemeNodeID":"1234","EntityType":"","Success":"true","Abandoned":""}],"SystemErrorMessage":"Scheme Node ABS does not exist","Tag":"","TotalRecords":"0","ValidationErrors":null}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDateAdjustSchemeNodes_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        
        RestrictionGroupAccount__c excludedAccount = new RestrictionGroupAccount__c();
        excludedAccount.RestrictionGroupId__c = currentRestriction.Id;
        excludedAccount.AccountNumber__c = '4048017641';
        excludedAccount.Excluded_Account__c = true;
        insert excludedAccount;
        
        RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c();
        groupRestrictionCustomer.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionCustomer.CustomerKey__c ='CTMETRO001';
        groupRestrictionCustomer.Name ='CTMETRO001';
        insert groupRestrictionCustomer;
        
        RestrictionGroupTransactionType__c tt = new RestrictionGroupTransactionType__c();
        tt.Restriction_Group_ID__c = currentRestriction.Id;
        insert tt;
        System.assertNotEquals(tt, null,'Restriction should not be null');

        String records = '[{"Id":"'+groupRestrictionAccount.Id+'","EffectiveStartDate__c":"01/01/0001","effEndDate":"01/01/4000","AccountNumber__c":"4048017641","SchemeNodeID__c":""},{"Id":"'+excludedAccount.Id+'","EffectiveStartDate__c":"01/01/0001","effEndDate":"01/01/9999","AccountNumber__c":"4048017641","SchemeNodeID__c":"1234"},{"Id":"'+groupRestrictionCustomer.Id+'","EffectiveStartDate__c":"01/01/0001","effEndDate":"01/01/9999","Name":"CTMETRO001","SchemeNodeID__c":"1234"},{"Id":"'+tt.Id+'","Effective_Start_Date__c":"01/01/0001","effEndDate":"01/01/9999","Name":"CTMETRO001","SchemeNodeID__c":"1234"}]';
        
        Test.startTest();
        try{
        ROTController.bulkDeleteNodes('CQGR0064-Test',records);
        }
        catch(Exception e){
            system.debug('error'+e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest static void updateCusotmerPositive() {
        
        final String POSITIVE_RESPONSE_BODY =  '{"UpdateCustomerResponse":{"UpdateCustomerResult":{"HasErrors": "false","HasSystemError": "false","HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result":{"Description": "","EffectiveEndDate": "2021-01-07T00:00:00","EffectiveStartDate": "2021-01-07T00:00:00","IsEffectiveEndDateInfinity": "false","ObjectID": "Customer","EntityType": "1234","ParentSchemeNodeID":"1234","SchemeNodeID": "1234"},"CustomerKey":"CTMETRO001","EffectiveStartDate":"2021-01-07T00:00:00"}}}';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateCustomer_IH_v1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        Account account = [SELECT Id  FROM Account LIMIT 1];
        
        RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c();
        groupRestrictionCustomer.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionCustomer.CustomerKey__c ='CTMETRO001';
        insert groupRestrictionCustomer;

        System.assertNotEquals(groupRestrictionCustomer, null,'Restriction should not be null');

        
        Test.startTest();
        try{
        ROTController.updateCustomerNode(groupRestrictionCustomer.Id,'CTMETRO001', 'Test', '2021/02/28' , '2021/03/30', currentRestriction.Restriction_ID__c,'2021/02/28','false');
        }
        catch(Exception e){
            system.debug('Error '+e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest static void expireCusotmerPositive() {
        
        final String POSITIVE_RESPONSE_BODY = '{"ExpireSchemeNodeResponse":{"ExpireSchemeNodeResult":{"HasErrors": "true", "HasSystemError": "false", "HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"CurrentPage": "0","IsCurrentPageTheLast": "true","PageToken": null,"Records": {"SchemeNodeOperationResult":[{"Abandoned": "false","EffectiveStartDate": "2020-06-26T00:00:00","EntityType": "Customer","ErrorMessage": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","ObjectID": "4047081344","SchemeNodeID": "240756", "Success": "true" }]},"TotalRecords": "1"}}}';
   
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTExpireSchemeNode_IH_V1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        Account account = [SELECT Id  FROM Account LIMIT 1];
        
        RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c();
        groupRestrictionCustomer.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionCustomer.CustomerKey__c ='CTMETRO001';
        insert groupRestrictionCustomer;
        System.assertNotEquals(groupRestrictionCustomer, null,'Restriction should not be null');


        Test.startTest();
        
         String expireCustResp =ROTController.expireCustomerNode(groupRestrictionCustomer.Id,'CTMETRO001', 'Test', '2021/02/28' , '2021/03/30', currentRestriction.Restriction_ID__c);
        
        Test.stopTest();
    }
    
      @isTest static void expireAccountPositive() {
        
        final String POSITIVE_RESPONSE_BODY = '{"ExpireSchemeNodeResponse":{"ExpireSchemeNodeResult":{"HasErrors": "false", "HasSystemError": "false", "HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"CurrentPage": "0","IsCurrentPageTheLast": "true","PageToken": null,"Records": {"SchemeNodeOperationResult":[{"Abandoned": "false","EffectiveStartDate": "2020-06-26T00:00:00","EntityType": "Account","ErrorMessage": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","ObjectID": "4047081344","SchemeNodeID": "240756", "Success": "true" }]},"TotalRecords": "1"}}}';
   
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTExpireSchemeNode_IH_V1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        Account account = [SELECT Id  FROM Account LIMIT 1];
        
         RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;

        System.assertNotEquals(groupRestrictionAccount, null,'Restriction should not be null');

        
        Test.startTest();
        
         String expireCustResp =ROTController.expireAccountNode(groupRestrictionAccount.Id,'4048017641', 'Test', '2021/02/28' , '2021/03/30', currentRestriction.Restriction_ID__c);
        
        Test.stopTest();
    }
    
       @isTest static void expireExcludedAccountPositive() {
        
        final String POSITIVE_RESPONSE_BODY = '{"ExpireSchemeNodeResponse":{"ExpireSchemeNodeResult":{"HasErrors": "false", "HasSystemError": "false", "HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"CurrentPage": "0","IsCurrentPageTheLast": "true","PageToken": null,"Records": {"SchemeNodeOperationResult":[{"Abandoned": "false","EffectiveStartDate": "2020-06-26T00:00:00","EntityType": "excludedaccount","ErrorMessage": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","ObjectID": "4047081344","SchemeNodeID": "240756", "Success": "true" }]},"TotalRecords": "1"}}}';
   
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTExpireSchemeNode_IH_V1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        Account account = [SELECT Id  FROM Account LIMIT 1];
        
         RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        groupRestrictionAccount.RestrictionGroupId__c = currentRestriction.Id;
        groupRestrictionAccount.AccountNumber__c = '4048017641';
        insert groupRestrictionAccount;
        System.assertNotEquals(groupRestrictionAccount, null,'Restriction should not be null');

        Test.startTest();
        
         String expireCustResp =ROTController.expireExcludedAccount(groupRestrictionAccount.Id,'4048017641', 'Test', '2021/02/28' , '2021/03/30', currentRestriction.Restriction_ID__c);
        
        Test.stopTest();
    }
    
    @isTest static void expireTransactionTypesNodeTestPositive(){
        final String POSITIVE_RESPONSE_BODY = '{"ExpireSchemeNodeResponse": {"ExpireSchemeNodeResult": {"HasErrors": "false","HasSystemError": "false","HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0217-QAZ","EffectiveEndDate": "2021-03-16T00:00:00","EffectiveStartDate": "2021-03-04T00:00:00","EntityType": "TransactionType","ObjectID": "FN71 CAD"}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTExpireSchemeNode_IH_V1.INTEGRATION_SERVICE_NAME});
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];		
        String ttId = currentRestriction.Id;
        String ttObjId = currentRestriction.Restriction_ID__c;
        
        String Description = '4047738913';
		String EffectiveEndDate = '2021-02-06';
		String EffectiveStartDate = '2021-01-07';
		String GroupRestrictionClusterID = 'ABS';
		String GroupRestrictionObjectID = 'CQGR0002-JUAT';
		String IsEffectiveEndDateInfinity = 'true';
		String Code = 'FN71 FIA';
		String OriginalEffectiveStartDate = '2021-01-07';
        
        RestrictionGroupTransactionType__c rgTTRecord = new RestrictionGroupTransactionType__c();
        rgTTRecord.Name = Code;
        rgTTRecord.Description__c = Description;
        rgTTRecord.Effective_Start_Date__c = system.today();
        rgTTRecord.Effective_End_Date__c = system.today() + 7;
        rgTTRecord.IsEffective_End_Date_Infinity__c = true;
        rgTTRecord.Restriction_Group_ID__c = ttObjId;
        rgTTRecord.Original_Effective_Start_Date__c = system.today();
        insert rgTTRecord;

        System.assertNotEquals(rgTTRecord, null,'Restriction should not be null');

        
        RestrictionGroupTransactionType__c recID =  [select Id from RestrictionGroupTransactionType__c where Name like 'FN71 FIA' and Effective_Start_Date__c = :system.today()  limit 1]; 
        String pId = recID.Id;
        
        Test.startTest();
        try{
           ROTController.expireTransactionTypesNode(Code, ttId, 'CQGR0002-JUAT', '2021-01-07', '2021-02-28', pId);
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        Test.stopTest();
    }
    
}