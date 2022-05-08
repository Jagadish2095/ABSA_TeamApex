/**
 * @description Test Class for LeadsSelector
 *
 * @author Robert McLean 
 * @date 19/02/2021
 *
 **/
@isTest
private class LeadsSelectorTest {
    
   
    @TestSetup
    /**
    * @description method makeData
    */
    static void makeData() {
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User au = new User(
            Alias = 'standt',
            Email = aemail,
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = auniqueUserName,
            MobilePhone = '0823389021'
        );
        insert au;
        System.runAs(au) {
            String uniqueUserName = 'UserA' + DateTime.now().getTime() + '@testorg.com';
            String email = 'UserA@testorg.com';
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User (Business Banker)'];
            User u = new User(
                Alias = 'standt',
                Email = email,
                EmailEncodingKey = 'UTF-8',
                LastName = 'UserA',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'Africa/Johannesburg',
                UserName = uniqueUserName,
                MobilePhone = '0823389021'
            );
            insert u;

            Financial_Product__c testFinancialProduct = new Financial_Product__c();
            testFinancialProduct.Name = 'Estate Provider Plan';
            testFinancialProduct.Type__c = 'Borrow';
            testFinancialProduct.Description__c = 'Test Product';
            testFinancialProduct.Business_Unit__c = 'Business Banking';
            testFinancialProduct.Product_Type__c = 'Bank';
            insert testFinancialProduct;

            Map<String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            Account testAccount = new Account();
            testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
            testAccount.CASA_Reference_Number__c = '1712994';
            testAccount.CASA_Risk_Status__c = 'Low';
            testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
            testAccount.CASA_Screening_Status__c = 'Approved';
            testAccount.CASA_Analyst_Comments__c = '30406';
            testAccount.PersonMobilePhone = '0747003747';
            testAccount.Country_of_Residence__pc = 'South Africa';
            testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
            testAccount.PersonEmail = 'test@test.co.za';
            testAccount.FirstName = 'Tony';
            testAccount.External_Siebel_ID__c = '1-1IV9MC';
            testAccount.ID_Number__pc = '8107115017084';
            testAccount.ID_Type__pc = 'SA Identity Document';
            testAccount.LastName = 'Stark';
            testAccount.Nationality__pc = 'South Africa';
            testAccount.Occupation__pc = 'Engineer';
            testAccount.Onboarding_Channel__c = 'Test';
            testAccount.Communication_Language__pc = 'Afrikaans';
            testAccount.PersonTitle = 'Mr.';
            testAccount.Client_Type__c = 'Individual Client';
            testAccount.Phone = '0114453322';
            testAccount.Gender__pc = 'Male';
            testAccount.Initials__pc = 'T';
            testAccount.Country_of_Birth__pc = 'South Africa';
            testAccount.Marital_Status__pc = 'Married';
            testAccount.Marital_Contract_Type__pc = 'Community of Property';
            testAccount.Income_Source__pc = 'Bonus';
            testAccount.Occupation_Status__pc = 'Full Time Employed';
            testAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
            testAccount.Occupation_Category__pc = 'Advertising';
            testAccount.ShippingCity = 'CAPE TOWN';
            testAccount.ShippingCountry = 'South Africa';
            testAccount.ShippingStreet = '01 PUERTA DEL SOL';
            testAccount.ShippingPostalCode = '8001';
            testAccount.BillingCity = 'GROBLERSDAL';
            testAccount.BillingCountry = 'South Africa';
            testAccount.BillingStreet = '01 MABOPANE SECTION';
            testAccount.BillingPostalCode = '1060';
            testAccount.CIF__c = 'AFIFTAP001';
            testAccount.Alternative_Email__c = 'test@test.com';
            testAccount.Alternative_Email_1__c = 'test@test.com';
            testAccount.Alternative_Email_2__c = 'test@test.com';
            testAccount.Alternative_Email_3__c = 'test@test.com';
            testAccount.Alternative_Email_4__c = 'test@test.com';
            testAccount.PersonAssistantPhone = '0114453322';
            testAccount.PersonAssistantName = 'Test Name';
            testAccount.PersonHomePhone = '0114453322';
            testAccount.PersonOtherPhone = '0114453322';
            testAccount.Phone = '0114453322';
            testAccount.Fax = '0114453322';
            testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
            testAccount.AccountNumber = '0114453322';
            insert testAccount;

            Lead leadTest1 = new Lead();
            leadTest1.FirstName = 'Test Lead';
            leadTest1.LastName = '1';
            leadTest1.Company = 'Test Lead 1';
            leadTest1.Financial_Product__c = testFinancialProduct.Id;
            leadTest1.Business_Unit__c = 'Business Banking';
            leadTest1.MobilePhone = '0987654321';
            leadTest1.Phone = '0987654321';
            leadTest1.OwnerId = u.Id;
            leadTest1.FinServ__RelatedAccount__c = testAccount.Id;
            insert leadTest1;

            Lead leadTest2 = new Lead();
            leadTest2.FirstName = 'Testing Lead';
            leadTest2.LastName = '2';
            leadTest2.Financial_Product__c = testFinancialProduct.Id;
            leadTest2.Company = 'Testing Lead 2';
            leadTest2.MobilePhone = '0987654321';
            leadTest2.Phone = '0987654321';
            leadTest2.OwnerId = u.Id;
            leadTest2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Business_Bank_Lead').getRecordTypeId();
            leadTest2.Email = 'fromAddress@testorg.com';
            leadTest2.sd_Inbox_Name__c = 'toAddresss@testorg.com';
            insert leadTest2;
        }
    }

    @isTest
    /**
    * @description method test
    */
    private static void test() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            LeadsSelector leadSelectorTest = new LeadsSelector();
            User ua = new User();
            Set<String> uuserEmails = new Set<String>();
            uuserEmails.add('UserA@testorg.com');
            List<User> uuserList = new UsersSelector().selectByEmail(uuserEmails);
            if (uuserList.size() > 0) {
                for (User u : uuserList) {
                    if (u.Email == 'UserA@testorg.com') {
                        ua = u;
                    }
                }
            }
            List<Lead> leadList = [SELECT Id, OwnerId, Email, sd_Inbox_Name__c, CreatedDate FROM Lead WHERE OwnerID = :ua.Id];
            Account acc = [SELECT Id FROM Account WHERE CIF__c = 'AFIFTAP001'];
            Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Business_Bank_Lead').getRecordTypeId();
            Set<Id> leadIdSet = new Set<Id>();
			List<Id> leadIdList = new List<Id>();
            Set<Id> accountIdSet = new Set<Id>();
            DateTime today = DateTime.now();
            DateTime yesterday = today.addDays(-1);
            accountIdSet.add(acc.Id); 
            leadIdSet.add(leadList.get(0).Id);
            leadIdSet.add(leadList.get(1).Id);
			leadIdList.add(leadList.get(0).Id);
            leadIdList.add(leadList.get(1).Id);
            List<Lead> aLeadTestList = leadSelectorTest.selectByAccountId(accountIdSet, 2);
            List<Lead> bLeadTestList = leadSelectorTest.selectIsUnreadByOwner(true, 1, recTypeId);
            List<Lead> cLeadTestList = leadSelectorTest.selectById(leadIdSet);
			List<Lead> ccLeadTestList = leadSelectorTest.selectLeadById(leadIdSet);
            List<Lead> dLeadTestList = leadSelectorTest.selectByIdsWithActivityTracking(leadIdSet);
            List<Lead> eLeadTestList = leadSelectorTest.selectIsOpenByOwnerByAccount(ua.Id, acc.Id);
            List<Lead> fLeadTestList = leadSelectorTest.selectByLeadId(eLeadTestList.get(0).Lead_Ref_No__c);
			List<Lead> ffLeadTestList = leadSelectorTest.getLeadsById(leadIdList);
            Lead hLeadTestList = leadSelectorTest.selectLeadById(leadList.get(0).Id);
            Integer numLeads = leadSelectorTest.selectCountByFromAndToAddress('fromaddress@testorg.com', 'toAddresss@testorg.com', yesterday);
            System.assertEquals(1, aLeadTestList.size(), 'selectByAccountId failed.');
            System.assertEquals(1, bLeadTestList.size(), 'selectIsUnreadByOwner failed.');
            System.assertEquals(2, cLeadTestList.size(), 'selectById failed.');
            System.assertEquals(2, dLeadTestList.size(), 'selectByIdsWithActivityTracking failed.');
            System.assertEquals(1, eLeadTestList.size(), 'selectByLeadId failed.');
            System.assertEquals(1, fLeadTestList.size(), 'selectCountByFromAndToAddress failed.');
			List<Schema.SObjectField> schemaLeadTestList = leadSelectorTest.getSObjectFieldList();
        }
    }
}