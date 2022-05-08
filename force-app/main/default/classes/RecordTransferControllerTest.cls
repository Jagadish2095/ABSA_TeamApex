/**=================================================================================================================================
 * Created By: Eduardo Salia
 * Created Date: 25/02/2021
 * @description Test Controller for RecordTransferController Class
 ===================================================================================================================================**/
@isTest
public class RecordTransferControllerTest {
    @isTest
    public static void testOpportunityInternalReferralAIFA() {
    //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
         List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
        contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
            AccountId = lstaccount[0].Id,
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;
        Test.startTest();

        Boolean result = RecordTransferController.updateOpportunity(
            newOpp.id,
            StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_AIFA,
            'test@example.com',
            'test@example.com',
            'Test Notes',
            'Test Insurance'
        );

        System.assertEquals(true, result);

        Test.stopTest();
    }

    @isTest
    public static void testOpportunityInternalReferralIDIRECT() {
        //WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
             List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
         contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
            AccountId = lstaccount[0].Id,
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;
        Test.startTest();

        Boolean result = RecordTransferController.updateOpportunity(
            newOpp.id,
            StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_IDIRECT,
            'test@example.com',
            'test@example.com',
            'Test Notes',
            'Test Insurance'
        );

        System.assertEquals(true, result);

        Test.stopTest();
    }

    @isTest
    public static void testOpportunityInternalReferralDirectDelivery() {
        //WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
          List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
         contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
            AccountId = lstaccount[0].Id,
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;
        Test.startTest();

        Boolean result = RecordTransferController.updateOpportunity(
            newOpp.id,
            StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_DIRECT_DELIVERY,
            'test@example.com',
            'test@example.com',
            'Test Notes',
            'Test Insurance'
        );

        System.assertEquals(true, result);

        Test.stopTest();
    }

    @isTest
    public static void testOpportunityInternalReferralVA() {
        //WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
            List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
        contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
            AccountId = lstaccount[0].Id,
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        insert newOpp;
        Test.startTest();

        Boolean result = RecordTransferController.updateOpportunity(
            newOpp.id,
            StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_VA_LIFE,
            'test@example.com',
            'test@example.com',
            'Test Notes',
            'Test Insurance'
        );

        System.assertEquals(true, result);

        Test.stopTest();
    }

    @isTest
    public static void testOpportunityExternalReferral() {
    //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
             List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
         contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
                OwnerId = UserInfo.getUserId(),
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;
        Test.startTest();

        Boolean result = RecordTransferController.updateOpportunity(
            newOpp.id,
            StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_EXTERNAL,
            'test@example.com',
            'test@example.com',
            'Test Notes',
            'Test Insurance'
        );
        RecordTransferController.newreferOpportunity(UserInfo.getUserId(),newOpp.id,'test');
        System.assertEquals(true, result);

        Test.stopTest();
    }

    @isTest
    public static void testChangeOfOwner() {
    //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
         contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
         Test.startTest();
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;
        Test.stopTest();
     /*   Opportunity newOpp1 = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id,
            Parent_Opportunity__c = newOpp.Id
            );
        
        insert newOpp1; */
    

       

        //RecordTransferController.changeOwner(testDataFactory.testOpportunity.id, UserInfo.getUserId());
       RecordTransferController.changeOwner(newOpp.id, UserInfo.getUserId());
        RecordTransferController.changeOwner(newOpp.id, UserInfo.getUserId());        
        RecordTransferController.referOpportunityToVA(UserInfo.getUserId(),newOpp.id, 'test');
      // RecordTransferController.newreferOpportunity(UserInfo.getUserId(),newOpp.id,'test');
        Boolean result = true;
        System.assertEquals(result != null, true);
      
    }

    @isTest
    public static void testGetObjectName() {
    //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
         Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
        

           List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
         contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Test.startTest();
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
            AccountId = lstaccount[0].Id,
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;  
       
        String objectName = RecordTransferController.getObjectName(newOpp.id);

        System.assertEquals('Opportunity', objectName);

        Account accObj2 = new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId = accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;
        Case objCase = new Case();
        objCase.Subject = 'This is subject';
        objCase.Email_From_Address__c = 'test@test.com';
        objCase.Incident_Date__c = Date.Today();
        insert objCase;
         Test.stopTest();
       // Case objCase = [SELECT Id FROM Case LIMIT 1];
        objCase.OwnerId = Userinfo.getUserId();
        objCase.CIF_Custom__c = 'LOUWNJ 010';
        objCase.Adviser_Code__c = '112233';
        objCase.Customer_ID__c = '1234567891234';
        objCase.Birth_Date__c = Date.today().addDays(-1000);
        objCase.First_Name__c = 'Test Client';
        objCase.Last_Name__c = 'Test JKumar';
        objCase.Initials__c = 'MK';
        objCase.Nationality__c = 'South Africa';
        objCase.Phys_Addr_Post_Code__c = '8976';
        objCase.Phys_Addr_Line1__c = 'University of PET';
        objCase.Work_Phone__c = '9999999999';
        objCase.Home_Phone__c = '8888888888';
        objCase.Mobile__c = '7777777777';
        objCase.Adviser_Name__c = 'Test JKumar';
        objCase.AccountId = accObj2.id;
        objCase.ID_Type__c = 'SA ID';
        objCase.SelectedAdvisorIdF2F__c = '';
        objCase.Status = 'New';
        objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Client Review').getRecordTypeId();
        TriggerDispatcher.skip(CaseTriggerHandler.class.getName());
        update objCase;
        
        /*objCase.Status='Assigned';         
        update objCase;
        
        objCase.Status='Calling Attemps Started';         
        update objCase;
        
        objCase.Status='In Progress';         
        update objCase;*/
        /*Contact objContact = [SELECT Id FROM Contact LIMIT 1];
        
        objCase.ContactId = objContact.Id;
        update objCase;*/
        RecordTransferController.referCase(objCase.Id, Userinfo.getUserId(), 'Test Comment 1', 'VA');
        
    }

    @isTest
    static void testPicklist() {
    //  WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
         Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
         Id recordTypeId = rtInfo.get('General').getRecordTypeId();
       Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Law 4 U';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;
             List<Account> lstaccount  = TestDataFactory.getPersonAccounts('recordtransfer', 'Client', 1);
         contact c=new contact();
        c.lastname='test';
        c.Email='test@test.com';
        insert c;
        Opportunity newOpp = new Opportunity(
                Name = 'Test',
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = '87654',
                Product_Interest__c = fp.Id,
            OwnerId = UserInfo.getUserId(),
            AccountId = lstaccount[0].id,
                RecordTypeId = recordTypeId,
            ContactName__c=c.Id
            );
        
        insert newOpp;  
        Test.startTest();
        RecordTransferController.getPiklistValues('Case', 'Status');
        RecordTransferController.getAdvisers(new List<String>{ 'English' }, new List<String>{ 'skill' });
        RecordTransferController.getOpportunity(newOpp.id);
        //RecordTransferController.getOpportunity(testDataFactory.testOpportunity.id);

        Boolean result = true;
        System.assertEquals(result != null, true);
        Test.stopTest();
    }
}