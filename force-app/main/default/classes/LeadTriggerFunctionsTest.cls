/**
* @description: Test Class for - LeadTrigger, LeadTriggerHandler, LeadTriggerFunctions
* @Author:  Rakesh Byri(Absa)
* @Created Date:  2019-02-18
* CHANGE LOG:
*=======================================================================================================
*
*=======================================================================================================
**/
/**
* @description LeadTriggerFunctionsTest Description
*
*/
@isTest
public class LeadTriggerFunctionsTest {
    /* Method: Method that creates test data and can reused in the test methods
* @author: Rakesh Byri(Absa)
* @created date: 2019-03-04
* */
    @testSetup
    static void createTestData() {
        List<User> usersList = new List<User>();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            usersList = TestDataFactory.getTestUsers('System Administrator', 2);
            insert usersList;
        }
        List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 4);
        leadsList[0].Status = 'New'; // change owner to test user
        leadsList[1].OwnerId = usersList[0].Id;
        leadsList[1].OwnerId = usersList[0].Id; // owner change
        leadsList[2].OwnerId = usersList[0].Id;
        leadsList[3].OwnerId = usersList[0].Id;
        insert leadsList;
    }

    @isTest
    static void beforeUpdateStatusesTest() {
        List<User> usersList = [SELECT Id FROM User WHERE username LIKE '%testuser1%'];
        List<Lead> leadsList = [SELECT Id, Name, Status, OwnerId FROM Lead WHERE Name LIKE '%Test%'];
        System.assertNotEquals(usersList, null);
        for (Lead currentLead : leadsList) {
            if (currentLead.Name == 'Test1 Lead1') {
                // System.debug('Lead Status ==>   '+currentLead.Status);
                currentLead.OwnerId = usersList[1].Id;
                currentLead.Successful_Calls__c = 1;
                currentLead.Is_sent_to_ESP__c = true;
            }
            if (currentLead.Name == 'Test2 Lead2') {
                currentLead.Status = 'Accepted';
            }
            if (currentLead.Name == 'Test3 Lead3') {
                currentLead.OwnerId = UserInfo.getUserId();
            }
        }
        Test.startTest();
        update leadsList;
        Test.stopTest();
    }

    @isTest
    static void beforeUpdateLogACallTest() {
        List<User> usersList = [SELECT Id FROM User WHERE username LIKE '%testuser1%'];
        List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 2);
        System.assertNotEquals(usersList, null);
        System.assertNotEquals(usersList, null);
        leadsList[0].OwnerId = usersList[0].Id;
        insert leadsList;
        List<Task> tasksList = TestDataFactory.getTasks(null, 2, leadsList[0].Id, null, 'Call');
        tasksList[0].WhoId = leadsList[0].Id;
        for (Task t : tasksList) {
            t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Business_Bank').getRecordTypeId();
            t.Outcome__c = 'Client deceased';
            t.Call_Successful__c = 'Yes';
        }
        insert tasksList;
    }

    @isTest
    static void beforeInsertValidateId() {
        List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 2);
        leadsList[0].Nationality__c = 'South Africa';
        leadsList[0].ID_Number__c = '8503265339089';
        Test.startTest();
        try {
            insert leadsList;
        } catch (Exception e) {
            System.assert(
                e.getMessage()
                .contains('The ID Number value on this record is not a valid' + ' South African ID Number,' + ' please re-enter to save the record.')
            );
        }

        Test.stopTest();
    }
    @isTest
    static void beforeInsertValidateSTILeadId() {
        List<Lead> leadsList = TestDataFactory.getLeads('STI_Lead', 1);
        leadsList[0].Nationality__c = 'South Africa';
        leadsList[0].ID_Number__c = '8503265339089';
        Test.startTest();
        try {
            insert leadsList;
        } catch (Exception e) {
            system.assertEquals(leadsList.isEmpty(), false);
        }

        Test.stopTest();
    }

    @isTest
    static void beforeUpdateValidateId() {
        List<Lead> leadsList = [SELECT Id, Name, Status, OwnerId FROM Lead WHERE Name LIKE '%Test1 Lead1%'];
        leadsList[0].ID_Number__c = '8503265339089';
        leadsList[0].Nationality__c = 'South Africa';
        leadsList[0].Status = 'Assigned';
        Test.startTest();
        try {
            update leadsList;
        } catch (Exception e) {
            System.assert(
                e.getMessage()
                .contains('The ID Number value on this record is not a valid' + ' South African ID Number,' + ' please re-enter to save the record.')
            );
        }
        Id busHoursId = [SELECT Id FROM BusinessHours WHERE isDefault = TRUE].Id;
        Integer units = (60 * 60 * 1000) + 10;
        LeadTriggerFunctions.calculateSLADateTime(System.now(), busHoursId, 'Week', units);

        Test.stopTest();
    }

    @isTest
    static void afterUpdateSendSMS() {
        List<Financial_Product__c> prodList = TestDataFactory.getProducts(
            'BB - Borrow - Loans - Business Term Loan',
            'Loans',
            'Borrow',
            'Business Term Loan',
            'Borrow',
            'Business Banking',
            1
        );
        insert prodList;
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();
        System.assertNotEquals(recTypeId, null);
        Lead newLead = new Lead(
            FirstName = 'Dummy',
            LastName = 'Lead',
            Status = 'Nurturing',
            Company = 'Absa',
            MobilePhone = '0745028193',
            Phone = '0745028193',
            Financial_Product__c = prodList[0].Id,
            Unsuccessful_Calls__c = 3,
            RecordTypeId = recTypeId
        );
        insert newLead;
        Test.startTest();
        newLead.Status = 'Abandoned';
        update newLead;
        Test.stopTest();
    }

    // Madhava Palla 07/17/2019
    @isTest
    static void beforeDeleteChangeTaskStatusDuringMerge() {
        String whoIdLead;
        List<Lead> leadsList = [SELECT Id FROM Lead];
        System.assertNotEquals(leadsList, null);
        whoIdLead = leadsList[1].id;
        List<Task> tasksList = TestDataFactory.getTasks(null, 3, whoIdLead, null, 'Call');
        for (Task t : tasksList) {
            t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Business_Bank').getRecordTypeId();
            t.Outcome__c = 'Client deceased';
            t.Call_Successful__c = 'Yes';
        }
        insert tasksList;
        Database.merge(leadsList[0], leadsList[1]);
    }

    @isTest
    static void afterInsertEmailCreate() {
        User u;
        User thisUser = [SELECT Id, ProfileId, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(thisUser) {
            u = new User(
                alias = 'standt',
                email = 'standarduser@testorg.com',
                emailencodingkey = 'UTF-8',
                lastname = 'Testing',
                languagelocalekey = 'en_US',
                localesidkey = 'en_US',
                ProfileId = thisUser.ProfileId,
                UserRoleId = thisUser.UserRoleId,
                timezonesidkey = 'America/Los_Angeles',
                username = 'standarduser@absa2.com.complaints'
            );
        }

        EmailTemplate e = new EmailTemplate(
            developerName = 'TestTemplate',
            TemplateType = 'Text',
            Name = 'Test Template',
            FolderId = UserInfo.getUserId(),
            isActive = true
        );
        insert e;
        List<User> usersList = [SELECT Id FROM User WHERE username LIKE '%testuser1%'];
        System.assertNotEquals(usersList, null);
        Campaign c = new Campaign();
        System.runAs(usersList[0]) {
            c.Name = 'Test Campaign';
            insert c;
        }

        Lead lead = new Lead();
        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id retailSalesLead = rtInfo.get('Retail_Service_Lead').getRecordTypeId();
        lead.FirstName = 'Test';
        lead.LastName = 'Test';
        lead.sd_Email_Template_Lead_Creation__c = 'Test Template';
        lead.Email = 'test@test.com';
        lead.LeadSource = 'IB Campaign';
        lead.RecordTypeId = retailSalesLead;
        lead.ID_Number__c = '';
        lead.Campaign__c = c.id;
        //lead.Bulk_Transfer_Selected_Leads__c = true;
        Test.startTest();

        System.runAs(u) {
            insert lead;

            lead.ID_Number__c = '9301014800083';
            update lead;
        }

        Test.stopTest();
    }

    @isTest
    static void TestBulkTransferedLeads() {
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Lead> leadRecords = new List<Lead>();

        List<Financial_Product__c> prodList = TestDataFactory.getProducts(
            'BB - Borrow - Loans - Business Term Loan',
            'Loans',
            'Borrow',
            'Business Term Loan',
            'Borrow',
            'Business Banking',
            1
        );
        insert prodList;

        BusinessHours busiHours = [SELECT Id FROM BusinessHours LIMIT 1];

        RecordType retailRecodType = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Retail_Sales_Lead'];
        System.assertNotEquals(retailRecodType, null);
        Service_Group__c sg = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'SG',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead'
        );
        insert sg;

        serviceGroupIds.add(sg.Id);

        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true);
        insert sl;

        Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;

        Service_Group_Type__c sgt = new Service_Group_Type__c(
            Service_Group__c = sg.Id,
            Service_Level__c = sl.id,
            Service_Type__c = st.Id,
            Financial_Product__c = prodList[0].Id
        );
        insert sgt;

        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.LeadSource = 'Phone';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecodType.Id;
        leadRecord.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord.sd_Service_Group_Id__c = sg.Id;
        leadRecord.Financial_Product__c = prodList[0].Id;
        leadRecord.Product_Interest_1__c = prodList[0].Id;
        leadRecord.Business_Hours__c = busiHours.Id;
        //leadRecord.Manager__c=userinfo.getUserId();
        insert leadRecord;

        leadRecords.add(leadRecord);

        Test.startTest();

        LeadTriggerFunctions.bulkTransferLeads(leadRecords, serviceGroupIds);

        Test.stopTest();
    }

    @isTest
    static void TestLeadOffersRollUp() {
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Lead> leadRecords = new List<Lead>();

        List<Financial_Product__c> prodList = TestDataFactory.getProducts(
            'BB - Borrow - Loans - Business Term Loan',
            'Loans',
            'Borrow',
            'Business Term Loan',
            'Borrow',
            'Business Banking',
            5
        );
        insert prodList;

        BusinessHours busiHours = [SELECT Id FROM BusinessHours LIMIT 1];

        RecordType retailRecodType = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Retail_Sales_Lead'];
        System.assertNotEquals(retailRecodType, null);
        Service_Group__c sg = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'SG',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead'
        );
        insert sg;

        serviceGroupIds.add(sg.Id);

        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true);
        insert sl;

        Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;

        Service_Group_Type__c sgt = new Service_Group_Type__c(
            Service_Group__c = sg.Id,
            Service_Level__c = sl.id,
            Service_Type__c = st.Id,
            Financial_Product__c = prodList[0].Id
        );
        insert sgt;

        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.LeadSource = 'Phone';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecodType.Id;
        leadRecord.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord.sd_Service_Group_Id__c = sg.Id;
        leadRecord.sd_Service_Group__c = sg.Name;
        leadRecord.Product_Interest_1__c = prodList[0].Id;
        leadRecord.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord.Business_Hours__c = busiHours.Id;
        leadRecord.Manager__c = userinfo.getUserId();
        insert leadRecord;

        leadRecord.Product_Interest_2__c = prodList[1].Id;
        leadRecord.Product_Offer_Status_2__c = 'Offer Taken Up';
        leadRecord.Product_Interest_3__c = prodList[2].Id;
        leadRecord.Product_Offer_Status_3__c = 'Offer Declined';
        leadRecord.Product_Interest_4__c = prodList[3].Id;
        leadRecord.Product_Offer_Status_4__c = 'Offer Taken Up';
        leadRecord.Product_Interest_5__c = prodList[4].Id;

        update leadRecord;

        leadRecords.add(leadRecord);

        Test.startTest();

        LeadTriggerFunctions.rollupLeadOffers(leadRecords);

        Test.stopTest();
    }
    @isTest
    static void directDeliveryLeadInsertTest() {
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Lead> leadRecords = new List<Lead>();

        List<Financial_Product__c> prodList = TestDataFactory.getProducts(
            'BB - Borrow - Loans - Business Term Loan',
            'Loans',
            'Borrow',
            'Business Term Loan',
            'Borrow',
            'Business Banking',
            5
        );
        insert prodList;

        BusinessHours busiHours = [SELECT Id FROM BusinessHours LIMIT 1];
        System.assertNotEquals(busiHours, null);
        Service_Group__c sg = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'SG',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead'
        );
        insert sg;

        serviceGroupIds.add(sg.Id);

        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true);
        insert sl;

        Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;

        Service_Group_Type__c sgt = new Service_Group_Type__c(
            Service_Group__c = sg.Id,
            Service_Level__c = sl.id,
            Service_Type__c = st.Id,
            Financial_Product__c = prodList[0].Id
        );
        insert sgt;

        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.LeadSource = 'IB Campaign';
        leadRecord.ID_Number__c = '8908315241089';
        leadRecord.DD_Nationality__c = 'South African';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
        leadRecord.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord.sd_Service_Group_Id__c = sg.Id;
        leadRecord.sd_Service_Group__c = sg.Name;
        leadRecord.Product_Interest_1__c = prodList[0].Id;
        leadRecord.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord.Business_Hours__c = busiHours.Id;
        leadRecord.Manager__c = userinfo.getUserId();
        insert leadRecord;
    }
    @isTest
    static void directDeliveryLeadAOLInsertTest() {
        BusinessHours busiHours = [Select Id From BusinessHours Limit 1];
        System.assertNotEquals(busiHours, null);

        Campaign cmp = new Campaign();
        cmp.Name = 'Test Flexi Online Campaign';
        cmp.Campaign_Code__c = 'HealthOnline';
        cmp.Description = 'Health Assistance';
        insert cmp;

        Financial_Product__c fp = new Financial_Product__c();
        fp.Name = 'Health Assistance';
        fp.Business_Unit__c = 'Direct Delivery';
        insert fp;

        Lead newLead = new Lead(
            FirstName = 'Dummy',
            LastName = 'Lead',
            MobilePhone = '0745028193',
            Phone = '0745028193',
            Campaign_Code__c = 'HealthOnline',
            Direct_Delivery_Campaign__c = cmp.Id
        );
        insert newLead;
    }

    @isTest
    static void TestIBCampaigns() {
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Lead> leadRecords = new List<Lead>();

        List<Financial_Product__c> prodList = TestDataFactory.getProducts(
            'BB - Borrow - Loans - Business Term Loan',
            'Loans',
            'Borrow',
            'Business Term Loan',
            'Borrow',
            'Business Banking',
            5
        );
        insert prodList;

        Campaign cmp = new Campaign();
        cmp.Name = 'IB Campaign';
        insert cmp;

        BusinessHours busiHours = [SELECT Id FROM BusinessHours LIMIT 1];

        RecordType retailRecodType = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Retail_Sales_Lead'];
        System.assertNotEquals(retailRecodType, null);
        Service_Group__c sg = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'Test',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead',
            IB_Service_Group_Name__c = 'IB - Test',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '1',
            Business_Hours__c = busiHours.id
        );
        insert sg;

        Service_Group__c sg2 = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'IB - Test',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead',
            IB_Service_Group_Name__c = 'Test',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '1',
            Business_Hours__c = busiHours.id
        );
        insert sg2;

        serviceGroupIds.add(sg.Id);

        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true);
        insert sl;

        Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;

        Service_Group_Type__c sgt = new Service_Group_Type__c(
            Service_Group__c = sg.Id,
            Service_Level__c = sl.id,
            Service_Type__c = st.Id,
            Financial_Product__c = prodList[0].Id
        );
        insert sgt;

        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.LeadSource = 'Campaign/Event';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecodType.Id;
        leadRecord.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord.sd_Service_Group_Id__c = sg.Id;
        leadRecord.sd_Service_Group__c = sg.Name;
        leadRecord.Financial_Product__c = prodList[0].Id;
        leadRecord.Product_Interest_1__c = prodList[0].Id;
        leadRecord.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord.Business_Hours__c = busiHours.Id;
        leadRecord.Manager__c = userinfo.getUserId();
        leadRecord.Campaign__c = cmp.Id;
        insert leadRecord;

        Lead leadRecord2 = new Lead();
        leadRecord2.FirstName = 'Test';
        leadRecord2.LastName = 'Lead';
        leadRecord2.Status = 'Allocated';
        leadRecord2.LeadSource = 'Campaign/Event';
        leadRecord2.Hot_Deal__c = false;
        leadRecord2.RecordTypeId = retailRecodType.Id;
        leadRecord2.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord2.sd_Service_Group_Id__c = sg2.Id;
        leadRecord2.sd_Service_Group__c = sg2.Name;
        leadRecord.Financial_Product__c = prodList[0].Id;
        leadRecord2.Product_Interest_1__c = prodList[0].Id;
        leadRecord2.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord2.Business_Hours__c = busiHours.Id;
        leadRecord2.Manager__c = userinfo.getUserId();
        leadRecord2.Campaign__c = cmp.Id;
        insert leadRecord2;

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        User uObj = new User();
        uObj.ProfileId = p.Id;
        uObj.LastName = 'JKumar';
        uObj.Email = 'testUser@gmail.com';
        uObj.Username = uniqueName + '@test' + orgId + '.org';
        uObj.CompanyName = 'TEST';
        uObj.Title = 'Mr.';
        uObj.EmailEncodingKey = 'ISO-8859-1';
        uObj.Alias = uniqueName.substring(18, 23);
        uObj.TimeZoneSidKey = 'America/Los_Angeles';
        uObj.LocaleSidKey = 'en_US';
        uObj.LanguageLocaleKey = 'en_US';
        uObj.Advisor_Code__c = '112233';
        insert uObj;

        Lead leadRecord3 = new Lead();
        leadRecord3.FirstName = 'Test';
        leadRecord3.LastName = 'Lead';
        leadRecord3.Status = 'Allocated';
        leadRecord3.Salutation = 'Mr';
        leadRecord3.LeadSource = 'Campaign/Event';
        leadRecord3.Hot_Deal__c = false;
        leadRecord3.Lead_Email__c = 'test@gmail.com';
        leadRecord3.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'STI_Lead'].Id;
        leadRecord3.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord3.sd_Service_Group_Id__c = sg2.Id;
        leadRecord3.sd_Service_Group__c = sg2.Name;
        leadRecord3.Financial_Product__c = prodList[0].Id;
        leadRecord3.Product_Interest_1__c = prodList[0].Id;
        leadRecord3.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord3.Business_Hours__c = busiHours.Id;
        leadRecord3.Manager__c = userinfo.getUserId();
        leadRecord3.Campaign__c = cmp.Id;
        leadRecord3.AIC_Relationship_Consultant_Name__c = 'Ebrahim Majiet (Ebrahim.Majiet@absa.co.za)';
        leadRecord3.OwnerId = uObj.Id;
        insert leadRecord3;

        User uObj1 = new User();
        uObj1.ProfileId = p.Id;
        uObj1.LastName = 'JKumar';
        uObj1.Email = 'testUservk@gmail.com';
        uObj1.Username = uniqueName + '@testvk' + orgId + '.org';
        uObj1.CompanyName = 'TEST';
        uObj1.Title = 'Mr.';
        uObj1.EmailEncodingKey = 'ISO-8859-1';
        uObj1.Alias = uniqueName.substring(18, 23);
        uObj1.TimeZoneSidKey = 'America/Los_Angeles';
        uObj1.LocaleSidKey = 'en_US';
        uObj1.LanguageLocaleKey = 'en_US';
        uObj1.Advisor_Code__c = '112233';
        insert uObj1;

        //List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        //usersList[0].LastName='Sample User Unique One';
        //usersList[0].UserName='testuserABC@absa.com';
        //insert usersList;
        leadRecord3.OwnerId = uObj1.Id;
        update leadRecord3;
        // System.debug('old record owner test class test123'+uObj.Id);
        //     System.debug('new record owner test class test123'+uObj1.Id);
    }

    @isTest
    public static void testNotSti() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        System.assertNotEquals(p, null);
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        User uObj = new User();
        uObj.ProfileId = p.Id;
        uObj.LastName = 'JKumar';
        uObj.Email = 'testUservk@gmail.com';
        uObj.Username = uniqueName + '@test' + orgId + '.org';
        uObj.CompanyName = 'TEST';
        uObj.Title = 'Mr.';
        uObj.EmailEncodingKey = 'ISO-8859-1';
        uObj.Alias = uniqueName.substring(18, 23);
        uObj.TimeZoneSidKey = 'America/Los_Angeles';
        uObj.LocaleSidKey = 'en_US';
        uObj.LanguageLocaleKey = 'en_US';
        uObj.Advisor_Code__c = '112233';
        insert uObj;

        Lead leadRecord3 = new Lead();
        leadRecord3.FirstName = 'Test';
        leadRecord3.LastName = 'Lead';
        leadRecord3.Status = 'Allocated';
        leadRecord3.Salutation = 'Mr';
        leadRecord3.LeadSource = 'Campaign/Event';
        leadRecord3.Hot_Deal__c = false;
        leadRecord3.Lead_Email__c = 'test@gmail.com';
        leadRecord3.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'STI_Lead'].Id;
        leadRecord3.Bulk_Transfer_Selected_Leads__c = true;
        //  leadRecord3.sd_Service_Group_Id__c = sg2.Id;
        // leadRecord3.sd_Service_Group__c = sg2.Name;
        //leadRecord3.Financial_Product__c = prodList[0].Id;
        //leadRecord3.Product_Interest_1__c = prodList[0].Id;
        //leadRecord3.Product_Offer_Status_1__c = 'Offer Taken Up';
        //leadRecord3.Business_Hours__c = busiHours.Id;
        leadRecord3.Manager__c = userinfo.getUserId();
        //    leadRecord3.Campaign__c = cmp.Id;
        leadRecord3.AIC_Relationship_Consultant_Name__c = 'Ebrahim Majiet (Ebrahim.Majiet@absa.co.za)';
        leadRecord3.OwnerId = uObj.Id;
        insert leadRecord3;

        User uObj1 = new User();
        uObj1.ProfileId = p.Id;
        uObj1.LastName = 'JKumar';
        uObj1.Email = 'testUser@gmail.com';
        uObj1.Username = uniqueName + '@testvk' + orgId + '.org';
        uObj1.CompanyName = 'TEST';
        uObj1.Title = 'Mr.';
        uObj1.EmailEncodingKey = 'ISO-8859-1';
        uObj1.Alias = uniqueName.substring(18, 23);
        uObj1.TimeZoneSidKey = 'America/Los_Angeles';
        uObj1.LocaleSidKey = 'en_US';
        uObj1.LanguageLocaleKey = 'en_US';
        uObj1.Advisor_Code__c = '112233';
        insert uObj1;

        //List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        //usersList[0].LastName='Sample User Unique One';
        //usersList[0].UserName='testuserABC@absa.com';
        //insert usersList;
        leadRecord3.OwnerId = uObj1.Id;
        update leadRecord3;
        //System.debug('old record owner test class test123'+uObj.Id);
        //System.debug('new record owner test class test123'+uObj1.Id);
    }

    @isTest
    static void TestIBSCampaigns() {
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Lead> leadRecords = new List<Lead>();

        List<Financial_Product__c> prodList = TestDataFactory.getProducts(
            'BB - Borrow - Loans - Business Term Loan',
            'Loans',
            'Borrow',
            'Business Term Loan',
            'Borrow',
            'Business Banking',
            5
        );
        insert prodList;

        Campaign cmp = new Campaign();
        cmp.Name = 'IB Campaign';
        insert cmp;

        BusinessHours busiHours = [SELECT Id FROM BusinessHours LIMIT 1];

        RecordType retailRecodType = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'DD_STI_Lead'];
        System.assertNotEquals(retailRecodType, null);
        Service_Group__c sg = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'Test',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead',
            IB_Service_Group_Name__c = 'IB - Test',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '1',
            Business_Hours__c = busiHours.id
        );
        insert sg;

        Service_Group__c sg2 = new Service_Group__c(
            Manager__c = userinfo.getUserId(),
            Name = 'IB - Test',
            Queue__c = 'Retail Sales Lead',
            Active__c = true,
            Assign_Record_Type__c = 'Retail Sales Lead',
            IB_Service_Group_Name__c = 'Test',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '1',
            Business_Hours__c = busiHours.id
        );
        insert sg2;

        serviceGroupIds.add(sg.Id);

        Service_Level__c sl = new Service_level__c(Name = 'SL', Default_Service_Level__c = true);
        insert sl;

        Service_Type__c st = new Service_Type__c(Name = 'Type Subtype', Type__c = 'Type', Subtype__c = 'Subtype');
        insert st;

        Service_Group_Type__c sgt = new Service_Group_Type__c(
            Service_Group__c = sg.Id,
            Service_Level__c = sl.id,
            Service_Type__c = st.Id,
            Financial_Product__c = prodList[0].Id
        );
        insert sgt;

        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.LeadSource = 'Campaign/Event';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecodType.Id;
        leadRecord.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord.sd_Service_Group_Id__c = sg.Id;
        leadRecord.sd_Service_Group__c = sg.Name;
        leadRecord.Financial_Product__c = prodList[0].Id;
        leadRecord.Product_Interest_1__c = prodList[0].Id;
        leadRecord.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord.Business_Hours__c = busiHours.Id;
        leadRecord.Manager__c = userinfo.getUserId();
        leadRecord.Campaign__c = cmp.Id;
        insert leadRecord;

        Lead leadRecord2 = new Lead();
        leadRecord2.FirstName = 'Test';
        leadRecord2.LastName = 'Lead';
        leadRecord2.Status = 'Allocated';
        leadRecord2.LeadSource = 'Campaign/Event';
        leadRecord2.Hot_Deal__c = false;
        leadRecord2.RecordTypeId = retailRecodType.Id;
        leadRecord2.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord2.sd_Service_Group_Id__c = sg2.Id;
        leadRecord2.sd_Service_Group__c = sg2.Name;
        leadRecord.Financial_Product__c = prodList[0].Id;
        leadRecord2.Product_Interest_1__c = prodList[0].Id;
        leadRecord2.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord2.Business_Hours__c = busiHours.Id;
        leadRecord2.Manager__c = userinfo.getUserId();
        leadRecord2.Campaign__c = cmp.Id;
        insert leadRecord2;

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        User uObj = new User();
        uObj.ProfileId = p.Id;
        uObj.LastName = 'JKumar';
        uObj.Email = 'testUser@gmail.com';
        uObj.Username = uniqueName + '@test' + orgId + '.org';
        uObj.CompanyName = 'TEST';
        uObj.Title = 'Mr.';
        uObj.EmailEncodingKey = 'ISO-8859-1';
        uObj.Alias = uniqueName.substring(18, 23);
        uObj.TimeZoneSidKey = 'America/Los_Angeles';
        uObj.LocaleSidKey = 'en_US';
        uObj.LanguageLocaleKey = 'en_US';
        uObj.Advisor_Code__c = '112233';
        insert uObj;

        Lead leadRecord3 = new Lead();
        leadRecord3.FirstName = 'Test';
        leadRecord3.LastName = 'Lead';
        leadRecord3.Status = 'Allocated';
        leadRecord3.Salutation = 'Mr';
        leadRecord3.LeadSource = 'Campaign/Event';
        leadRecord3.Hot_Deal__c = false;
        leadRecord3.Lead_Email__c = 'test@gmail.com';
        leadRecord3.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'DD_STI_Lead'].Id;
        leadRecord3.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord3.sd_Service_Group_Id__c = sg2.Id;
        leadRecord3.sd_Service_Group__c = sg2.Name;
        leadRecord3.Financial_Product__c = prodList[0].Id;
        leadRecord3.Product_Interest_1__c = prodList[0].Id;
        leadRecord3.Product_Offer_Status_1__c = 'Offer Taken Up';
        leadRecord3.Business_Hours__c = busiHours.Id;
        leadRecord3.Manager__c = userinfo.getUserId();
        leadRecord3.Campaign__c = cmp.Id;
        leadRecord3.AIC_Relationship_Consultant_Name__c = 'Ebrahim Majiet (Ebrahim.Majiet@absa.co.za)';
        leadRecord3.OwnerId = uObj.Id;
        insert leadRecord3;

        User uObj1 = new User();
        uObj1.ProfileId = p.Id;
        uObj1.LastName = 'JKumar';
        uObj1.Email = 'testUservk@gmail.com';
        uObj1.Username = uniqueName + '@testvk' + orgId + '.org';
        uObj1.CompanyName = 'TEST';
        uObj1.Title = 'Mr.';
        uObj1.EmailEncodingKey = 'ISO-8859-1';
        uObj1.Alias = uniqueName.substring(18, 23);
        uObj1.TimeZoneSidKey = 'America/Los_Angeles';
        uObj1.LocaleSidKey = 'en_US';
        uObj1.LanguageLocaleKey = 'en_US';
        uObj1.Advisor_Code__c = '112233';
        insert uObj1;

        //List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        //usersList[0].LastName='Sample User Unique One';
        //usersList[0].UserName='testuserABC@absa.com';
        //insert usersList;
        leadRecord3.OwnerId = uObj1.Id;
        update leadRecord3;
        // System.debug('old record owner test class test123'+uObj.Id);
        //System.debug('new record owner test class test123'+uObj1.Id);
    }

    @isTest
    static void TestInvestLead()
    {
        Test.startTest();
         User thisUser = [SELECT Id, ProfileId, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
         User wimiAdviosr = [SELECT Id, ProfileId, UserRoleId FROM User WHERE Profile.Name ='Standard User (WIMI Advisor)' and isActive=true limit 1];
        List<PermissionSet> psList = [SELECT Id FROM PermissionSet WHERE Name = 'VA_Investment_Team_Leader' or Name='DD_Support'];
    List<PermissionSetAssignment> psAssignment=new List<PermissionSetAssignment>();

        for(PermissionSet ps:psList)
        {
            psAssignment.add(new PermissionSetAssignment(AssigneeId = wimiAdviosr.id, PermissionSetId = ps.Id));
        }
        if(!psAssignment.isEmpty())
        {
            insert psAssignment;
        }

        Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');

        Id InvrecTypeId = rtInfo.get('Investment_Lead').getRecordTypeId();
        Lead lead =new Lead();
    try
        {
             System.runAs(wimiAdviosr) {

                lead.FirstName = 'Test';
                lead.LastName = 'Test';
                lead.sd_Email_Template_Lead_Creation__c = 'Test Template';
                lead.Email = 'test@test.com';
                lead.LeadSource = 'IB Campaign';
                lead.ID_Number__c = '';
                lead.RecordTypeId =InvrecTypeId;

                insert lead;
                lead.Single_Transfer__c = false;
                 lead.Is_Inbound__c = true;
                lead.OwnerId = thisUser.Id;
                update lead;
          }
        }
        catch (Exception e) {
            String msg = e.getMessage();
            system.assertEquals(msg != null, true);
        }


        Test.stopTest();
    }
      @isTest
    static void MaturityLeadAOLLawInsertTest() {
    Map<String, Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
      Id recTypeId = rtInfo.get('Maturity_Retention').getRecordTypeId();
            List<User> usersList = [SELECT Id FROM User WHERE username LIKE '%testuser1%'];
            Test.startTest();
            Group VAGroup = [select Id from Group where DeveloperName = 'Maturity_Retention_Queue' LIMIT 1];
            List<GroupMember> gm = [select Id from GroupMember where GroupId =: VAGroup.Id ];
            //    new GroupMember(GroupId = VAGroup.Id, UserOrGroupId = usersList[0].Id);
      //insert gm;
            Test.stopTest();
      //List<Campaign> cmp = TestDataFactory.getCampaigns('VA Maturity','VA MAturity Campaign');
      Campaign cmp = new Campaign();
            cmp.Name = 'Test Law Online Campaign';
            cmp.Campaign_Code__c = 'lawforyou';
            cmp.Description = 'Law 4 U';
            insert cmp;
      System.assertNotEquals(recTypeId, null);

      Lead newLead = new Lead(
        FirstName = 'Dummy',
        LastName = 'Lead',
        MobilePhone = '0745028193',
        Phone = '0745028193',
        ID_Number__c = '8503265339089',
        RecordTypeId = recTypeId,
        Campaign_Code__c = 'VA MAturity Campaign',
        Campaign__c = cmp.Id,
        Status = 'New',
        External_SLA_Notification_User__c = userinfo.getUserId()
      );
      insert newLead;
               if(gm.size() > 0) {
      System.runAs(new User(Id = usersList[0].Id)) {
               Lead updaterec = [select Id,status from lead where RecordTypeId =: recTypeId];
      updaterec.Status = 'Work In Progress';
             //   system.debug('updated lead'+updaterec);
      //  update updaterec;

      }            }

        }
  }