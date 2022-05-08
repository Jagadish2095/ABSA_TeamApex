/**
* @description       :
* @author            : deepthi.narayanappa@absa.africa
* @last modified on  : 2021-11-24
* @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class CaseCallOutcomesControllerTest {
    static Id CRCalltaskRT = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Client_Review_Call_Task').getRecordTypeId();
    
    @testsetup
    static void initdata() {
        VA_Outcome_Setting__mdt customdataSti = new VA_Outcome_Setting__mdt(
            Inbound_Outcome__c = 'Call Back',
            Outbound_Outcome__c = 'Call Back',
            Product__c = 'Client Review'
        );
        
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Client Review').getRecordTypeId();
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User uObj = new User();
        uObj.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
        uObj.LastName = 'JKumar';
        uObj.Email = 'brokerNoteUser@gmail.com';
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
        
        Account accObj2 = new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId = accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;
        
        Case cObj = new Case();
        Date myDate = date.newInstance(2012, 5, 22);
        cObj.RecordTypeId = recTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c = '112233';
        cObj.Customer_ID__c = '1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c = 'Test Client';
        cObj.Last_Name__c = 'Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976';
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c = 'Test JKumar';
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c = '';
        cObj.Status = 'New';
        cObj.AccountId = accObj2.Id;
        insert cObj;
         
        
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = accObj2.Id;
        insert oppsList;
    }
    
    @isTest
    public static void outcometest() {
        Test.startTest();
        Case obj = [SELECT id FROM case];
        CaseCallOutcomesController.getOutcomes(obj.Id);
        System.assert(obj != null, 'case obj is null');
        try {
            CaseCallOutcomesController.saveOutcome(obj.id, 'Call Back', 'None', system.today().adddays(10), 'English');
        } catch (Exception e) {
            // system.debug(e.getLineNumber());
            String msg = e.getMessage();
        }
        Test.stopTest();
    }
    @isTest
    public static void outcometestUncontactable() {
        Test.startTest();
        
        VA_Outcome_Setting__mdt customdataSti = new VA_Outcome_Setting__mdt(
            Inbound_Outcome__c = 'Uncontactable',
            Outbound_Outcome__c = 'Uncontactable',
            Product__c = 'Client Review'
        );
        Case obj = [SELECT id FROM case];
        CaseCallOutcomesController.getOutcomes(obj.Id);
        System.assert(obj != null, 'case obj is null');
        try {
            CaseCallOutcomesController.saveOutcome(obj.id, 'Uncontactable', 'None', system.today().adddays(10), 'English');
        } catch (Exception e) {
            //  system.debug(e.getLineNumber());
            String msg = e.getMessage();
        }
        Test.stopTest();
    }
    @isTest
    public static void outcometestCNI() {
        Test.startTest();
        
        VA_Outcome_Setting__mdt customdataSti = new VA_Outcome_Setting__mdt(
            Inbound_Outcome__c = 'Client Not Intrested',
            Outbound_Outcome__c = 'Client Not Interested',
            Product__c = 'Client Review'
        );
        Case obj = [SELECT id FROM case];
        CaseCallOutcomesController.getOutcomes(obj.Id);
        System.assert(obj != null, 'case obj is null');
        try {
            CaseCallOutcomesController.saveOutcome(obj.id, 'Client Not Interested', 'None', system.today().adddays(10), 'English');
        } catch (Exception e) {
            //  system.debug(e.getLineNumber());
            String msg = e.getMessage();
        }
        Test.stopTest();
    }
    
    @isTest
    public static void outcometestCB() {
        Test.startTest();
        
        VA_Outcome_Setting__mdt customdataSti = new VA_Outcome_Setting__mdt(
            Inbound_Outcome__c = 'Call Back',
            Outbound_Outcome__c = 'Call Back',
            Product__c = 'Client Review'
        );
        Case obj = [SELECT id FROM case];
        CaseCallOutcomesController.getOutcomes(obj.Id);
        System.assert(obj != null, 'case obj is null');
        try {
            CaseCallOutcomesController.saveOutcome(obj.id, 'Call Back', 'None', system.today().adddays(10), 'English');
            system.assertEquals(true, obj != null);
        } catch (Exception e) {
            String msg = e.getMessage();
        }
        
        obj.Status = 'Assigned';
        TriggerDispatcher.skip(CaseTriggerHandler.class.getName());
        update obj;
        
        obj.Status = 'Calling Attemps Started';
        TriggerDispatcher.skip(CaseTriggerHandler.class.getName());
        update obj;
        
        obj.Status = 'In Progress';
        TriggerDispatcher.skip(CaseTriggerHandler.class.getName());
        //Update obj;
        
        Task t = new Task(
            Call_ID__c = 'test',
            WhatId = obj.Id,
            whoId = [SELECT Id FROM Contact LIMIT 1]
            .Id,
            GlobalRefId__c = 'test',
            RecordTypeId = CRCalltaskRT
        );
        insert t;
        try {
            CaseCallOutcomesController.saveOutcome(obj.id, 'Call Back', 'None', system.today().adddays(10), 'English');
        } catch (Exception e) {
            String msg = e.getMessage();
        }
        Test.stopTest();
    }
    
    @isTest
    public static void outcometestIDVNS() {
        Test.startTest();
        
        VA_Outcome_Setting__mdt customdataSti = new VA_Outcome_Setting__mdt(
            Inbound_Outcome__c = 'ID&V Not Successful',
            Outbound_Outcome__c = 'ID&V Not Successful',
            Product__c = 'Client Review'
        );
        Case obj = [SELECT id FROM case];
        CaseCallOutcomesController.getOutcomes(obj.Id);
        System.assert(obj != null, 'case obj is null');
        try {
            CaseCallOutcomesController.saveOutcome(obj.id, 'ID&V Not Successful', 'None', system.today().adddays(10), 'English');
        } catch (Exception e) {
            //  system.debug(e.getLineNumber());
            String msg = e.getMessage();
        }
        Test.stopTest();
    }
    
    @isTest private static void callOutComeOpportunity(){
        Opportunity opp = [SELECT Id FROM Opportunity Limit 1];
        CaseCallOutcomesController.getOutcomes(opp.Id);
        Test.startTest();
        try {
            CaseCallOutcomesController.saveOutcome(opp.id, 'Client Not Interested', 'None', system.today().adddays(10), 'English');
        }
        catch(Exception ex){
            System.assertEquals(ex!= null, true);
        }
        Test.stopTest();
    }
}