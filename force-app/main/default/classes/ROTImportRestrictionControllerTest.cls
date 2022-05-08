@isTest
public class ROTImportRestrictionControllerTest {
    

    
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
    
    @isTest static void getRestrictionHierarchyTest() {
        
       final String POSITIVE_RESPONSE_BODY  ='{"GetGroupRestrictionHierarchiesForCustomerResponse":{"GetGroupRestrictionHierarchiesForCustomerResult":{"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"false","SystemErrorMessage":null,"Tag":null,"Data":{"GroupRestrictionHierarchyModel":[{"Description":null,"EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0012-DOF","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"211242","ClusterID":"BOT","Accounts":{"AccountModel":[{"Description":null,"EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2018-09-15T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4061025439","EntityType":"Account","ParentSchemeNodeID":"211242","SchemeNodeID":"211254"}]},"ExcludedAccounts":{"ExcludedAccountModel":[{"Description":"JB Pillar","EffectiveEndDate":"2019-06-28T00:00:00","EffectiveStartDate":"2019-06-28T00:00:00","IsEffectiveEndDateInfinity":"false","ObjectID":"4047738913","EntityType":"ExcludedAccount","ParentSchemeNodeID":"211242","SchemeNodeID":"226252"}]},"TransactionTypes":{"TransactionTypeModel":[{"Description":"Airtime Debit","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2018-09-15T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 ADF","EntityType":"TransactionType","ParentSchemeNodeID":"211242","SchemeNodeID":"211255"},{"Description":"Cheque Deposit","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2018-09-21T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 QD","EntityType":"TransactionType","ParentSchemeNodeID":"211242","SchemeNodeID":"213811"},{"Description":"Mixed Deposit Branch","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2018-09-21T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 MD","EntityType":"TransactionType","ParentSchemeNodeID":"211242","SchemeNodeID":"213812"}]}},{"Description":"CQ Excluded JUAT Test","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0002-JUAT","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"226124","ClusterID":"ABS","Accounts":{"AccountModel":[{"Description":"JB1","EffectiveEndDate":"2019-06-12T00:00:00","EffectiveStartDate":"2019-05-29T00:00:00","IsEffectiveEndDateInfinity":"false","ObjectID":"4054388729","EntityType":"Account","ParentSchemeNodeID":"226124","SchemeNodeID":"226125"},{"Description":"JB2","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-06-13T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4048261393","EntityType":"Account","ParentSchemeNodeID":"226124","SchemeNodeID":"226167"},{"Description":"JB10","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-06-26T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4047081344","EntityType":"Account","ParentSchemeNodeID":"226124","SchemeNodeID":"226211"}]},"Customers":{"CustomerModel":[{"Description":"JBCIF","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-05-29T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"AISERVI039","EntityType":"Customer","ParentSchemeNodeID":"226124","SchemeNodeID":"226126"}]},"ExcludedAccounts":{"ExcludedAccountModel":[{"Description":"JB EXCL1","EffectiveEndDate":"2019-06-12T00:00:00","EffectiveStartDate":"2019-05-29T00:00:00","IsEffectiveEndDateInfinity":"false","ObjectID":"4054388907","EntityType":"ExcludedAccount","ParentSchemeNodeID":"226124","SchemeNodeID":"226128"},{"Description":"JB EXCL2","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-06-13T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4048268044","EntityType":"ExcludedAccount","ParentSchemeNodeID":"226124","SchemeNodeID":"226166"},{"Description":"JB EXCL1 DA","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-06-13T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4061025439","EntityType":"ExcludedAccount","ParentSchemeNodeID":"226124","SchemeNodeID":"226169"},{"Description":"JB10","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-06-26T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4047081344","EntityType":"ExcludedAccount","ParentSchemeNodeID":"226124","SchemeNodeID":"226210"}]},"TransactionTypes":{"TransactionTypeModel":[{"Description":"JBCW","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-05-29T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 CW","EntityType":"TransactionType","ParentSchemeNodeID":"226124","SchemeNodeID":"226127"},{"Description":"JBQD","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-05-29T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 QD","EntityType":"TransactionType","ParentSchemeNodeID":"226124","SchemeNodeID":"226129"},{"Description":"JBMD","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-06-13T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 MD","EntityType":"TransactionType","ParentSchemeNodeID":"226124","SchemeNodeID":"226168"}]}},{"Description":null,"EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0013-COT","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"243059","ClusterID":"ABS","Accounts":{"AccountModel":[{"Description":"Exclude","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-05-09T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"78","EntityType":"Account","ParentSchemeNodeID":"243059","SchemeNodeID":"243064"}]},"Customers":{"CustomerModel":[{"Description":null,"EffectiveEndDate":"2019-05-10T00:00:00","EffectiveStartDate":"2018-09-21T00:00:00","IsEffectiveEndDateInfinity":"false","ObjectID":"CTMETRO001","EntityType":"Customer","ParentSchemeNodeID":"243059","SchemeNodeID":"243060"},{"Description":"CITY OF TSHWANE METROPOLITAN MUNICIPALITY","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-10-09T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CTMETRO001","EntityType":"Customer","ParentSchemeNodeID":"243059","SchemeNodeID":"243065"}]},"ExcludedAccounts":{"ExcludedAccountModel":[{"Description":"TEST","EffectiveEndDate":"2019-10-10T00:00:00","EffectiveStartDate":"2019-10-09T00:00:00","IsEffectiveEndDateInfinity":"false","ObjectID":"4047848154","EntityType":"ExcludedAccount","ParentSchemeNodeID":"243059","SchemeNodeID":"243066"},{"Description":"CITY OF TSHWANE TESTING","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-10-09T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4047848243","EntityType":"ExcludedAccount","ParentSchemeNodeID":"243059","SchemeNodeID":"243067"},{"Description":null,"EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-10-09T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"4047850997","EntityType":"ExcludedAccount","ParentSchemeNodeID":"243059","SchemeNodeID":"243068"}]},"TransactionTypes":{"TransactionTypeModel":[{"Description":"Cheque Deposit","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2018-09-21T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 QD","EntityType":"TransactionType","ParentSchemeNodeID":"243059","SchemeNodeID":"243061"},{"Description":"Mixed Deposit Branch","EffectiveEndDate":"2019-10-09T00:00:00","EffectiveStartDate":"2018-09-21T00:00:00","IsEffectiveEndDateInfinity":"false","ObjectID":"FN71 MD","EntityType":"TransactionType","ParentSchemeNodeID":"243059","SchemeNodeID":"243062"},{"Description":"ATM Deposit","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2018-09-21T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 QDA","EntityType":"TransactionType","ParentSchemeNodeID":"243059","SchemeNodeID":"243063"},{"Description":"CHEQUE PAYMENT","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-10-09T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 KQP","EntityType":"TransactionType","ParentSchemeNodeID":"243059","SchemeNodeID":"243069"},{"Description":"CHEQUE ENCASHMENT","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"2019-10-09T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"FN71 QE","EntityType":"TransactionType","ParentSchemeNodeID":"243059","SchemeNodeID":"243070"}]}}]}}}}';
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTGetGrpRestriHierarchiesForCu_IH_v1.INTEGRATION_SERVICE_NAME});
        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        ROTImportRestrictionController.getRestrictionHierarchy('CTMETRO001');
        Test.stopTest();
    }

    
     @isTest static void bulkImportNodesTest() {
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
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
       
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = account); 
        
        RestrictionGroupTransactionType__c tt = new RestrictionGroupTransactionType__c();
        tt.Restriction_Group_ID__c = currentRestriction.Id;
        insert tt;

        String records = '[{"ObjectID":"CQGR0012-DOF","EntityType":"GroupRestriction","EffectiveStartDate":"0001-01-01T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":null,"IsEffectiveEndDateInfinity":"true","ParentSchemeNodeID":null,"SchemeNodeID":211242,"ClusterID":"BOT"},{"SchemeNodeID":211254,"ParentSchemeNodeID":211242,"ObjectID":4061025439,"IsEffectiveEndDateInfinity":"true","EntityType":"Account","EffectiveStartDate":"2018-09-15T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":null},{"SchemeNodeID":226252,"ParentSchemeNodeID":211242,"ObjectID":4047738913,"IsEffectiveEndDateInfinity":"false","EntityType":"ExcludedAccount","EffectiveStartDate":"2019-06-28T00:00:00","EffectiveEndDate":"2019-06-28T00:00:00","Description":"JB Pillar"},{"SchemeNodeID":211255,"ParentSchemeNodeID":211242,"ObjectID":"FN71 ADF","IsEffectiveEndDateInfinity":"true","EntityType":"TransactionType","EffectiveStartDate":"2018-09-15T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"Airtime Debit"},{"SchemeNodeID":213811,"ParentSchemeNodeID":211242,"ObjectID":"FN71 QD","IsEffectiveEndDateInfinity":"true","EntityType":"TransactionType","EffectiveStartDate":"2018-09-21T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"Cheque Deposit"},{"SchemeNodeID":213812,"ParentSchemeNodeID":211242,"ObjectID":"FN71 MD","IsEffectiveEndDateInfinity":"true","EntityType":"TransactionType","EffectiveStartDate":"2018-09-21T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"Mixed Deposit Branch"},{"ObjectID":"CQGR0002-JUAT","EntityType":"GroupRestriction","EffectiveStartDate":"0001-01-01T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"CQ Excluded JUAT Test","IsEffectiveEndDateInfinity":"true","ParentSchemeNodeID":null,"SchemeNodeID":226124,"ClusterID":"ABS"},{"SchemeNodeID":226126,"ParentSchemeNodeID":226124,"ObjectID":"AISERVI039","IsEffectiveEndDateInfinity":"true","EntityType":"Customer","EffectiveStartDate":"2019-05-29T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JBCIF"},{"SchemeNodeID":226125,"ParentSchemeNodeID":226124,"ObjectID":4054388729,"IsEffectiveEndDateInfinity":"false","EntityType":"Account","EffectiveStartDate":"2019-05-29T00:00:00","EffectiveEndDate":"2019-06-12T00:00:00","Description":"JB1"},{"SchemeNodeID":226167,"ParentSchemeNodeID":226124,"ObjectID":4048261393,"IsEffectiveEndDateInfinity":"true","EntityType":"Account","EffectiveStartDate":"2019-06-13T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JB2"},{"SchemeNodeID":226211,"ParentSchemeNodeID":226124,"ObjectID":4047081344,"IsEffectiveEndDateInfinity":"true","EntityType":"Account","EffectiveStartDate":"2019-06-26T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JB10"},{"SchemeNodeID":226128,"ParentSchemeNodeID":226124,"ObjectID":4054388907,"IsEffectiveEndDateInfinity":"false","EntityType":"ExcludedAccount","EffectiveStartDate":"2019-05-29T00:00:00","EffectiveEndDate":"2019-06-12T00:00:00","Description":"JB EXCL1"},{"SchemeNodeID":226166,"ParentSchemeNodeID":226124,"ObjectID":4048268044,"IsEffectiveEndDateInfinity":"true","EntityType":"ExcludedAccount","EffectiveStartDate":"2019-06-13T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JB EXCL2"},{"SchemeNodeID":226169,"ParentSchemeNodeID":226124,"ObjectID":4061025439,"IsEffectiveEndDateInfinity":"true","EntityType":"ExcludedAccount","EffectiveStartDate":"2019-06-13T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JB EXCL1 DA"},{"SchemeNodeID":226210,"ParentSchemeNodeID":226124,"ObjectID":4047081344,"IsEffectiveEndDateInfinity":"true","EntityType":"ExcludedAccount","EffectiveStartDate":"2019-06-26T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JB10"},{"SchemeNodeID":226127,"ParentSchemeNodeID":226124,"ObjectID":"FN71 CW","IsEffectiveEndDateInfinity":"true","EntityType":"TransactionType","EffectiveStartDate":"2019-05-29T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JBCW"},{"SchemeNodeID":226129,"ParentSchemeNodeID":226124,"ObjectID":"FN71 QD","IsEffectiveEndDateInfinity":"true","EntityType":"TransactionType","EffectiveStartDate":"2019-05-29T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JBQD"},{"SchemeNodeID":226168,"ParentSchemeNodeID":226124,"ObjectID":"FN71 MD","IsEffectiveEndDateInfinity":"true","EntityType":"TransactionType","EffectiveStartDate":"2019-06-13T00:00:00","EffectiveEndDate":"9999-12-31T00:00:00","Description":"JBMD"}]';
 
        Test.startTest();
        try{
            //String result = RotCustomerController.bulkImportNodes(testCase.Id,records);
            ROTImportRestrictionController.bulkImportNodes(testCase.Id,records);
           // system.assertNotEquals(null, result);
        }
        catch(Exception e){
            system.debug('error'+e.getMessage());
        }
        Test.stopTest();
    }


}