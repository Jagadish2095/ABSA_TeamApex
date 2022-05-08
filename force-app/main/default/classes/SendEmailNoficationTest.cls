/**
* This is the Send Email Notification Test Class
* @author   Sipho Mbulawa
* @since    2020/07/20
*/


@IsTest
public class SendEmailNoficationTest {
    @isTest
    public static void testSendEmailNotification(){
        
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Lead> leadRecords = new List<Lead>();
        Map<Id, sObject> oldRecordsMap = new Map<Id, sObject>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='sipho.mbulawa@absa.africa', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgabsa2.com');
        
        insert testUser;
        
        List<Financial_Product__c> prodList = TestDataFactory.getProducts('BB - Borrow - Loans - Business Term Loan', 
                                                                          'Loans', 'Borrow', 'Business Term Loan',
                                                                          'Borrow', 'Business Banking', 1);
        insert prodList;
        
        BusinessHours busiHours = [Select Id From BusinessHours Limit 1];
        
        RecordType retailRecodType = [Select Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' and DeveloperName = 'Retail_Sales_Lead'];
        
        Service_Group__c sg = new Service_Group__c(Name='SG',Queue__c='Retail Sales Lead',Active__c=true, Assign_Record_Type__c = 'Retail Sales Lead', Manager__c = testUser.Id);
        insert sg;
        
        serviceGroupIds.add(sg.Id);
        
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true);
        insert sl;
        
        Service_Type__c st = new Service_Type__c(Name='Type Subtype', Type__c='Type', Subtype__c='Subtype');
        insert st;
        
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=sg.Id, Service_Level__c=sl.id, Service_Type__c=st.Id, Financial_Product__c = prodList[0].Id);
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
        leadRecord.Product_Interest_1__c  = prodList[0].Id;
        leadRecord.Business_Hours__c = busiHours.Id;
        leadRecord.Manager__c = testUser.Id;
        insert leadRecord;
        
        Lead leadRecord1 = new Lead();
        leadRecord1.FirstName = 'Test';
        leadRecord1.LastName = 'Lead';
        leadRecord1.Status = 'Allocated';
        leadRecord1.LeadSource = 'Phone';
        leadRecord1.Hot_Deal__c = false;
        leadRecord1.RecordTypeId = retailRecodType.Id;
        leadRecord1.Bulk_Transfer_Selected_Leads__c = true;
        leadRecord1.sd_Service_Group_Id__c = sg.Id;
        leadRecord1.Financial_Product__c = prodList[0].Id;
        leadRecord1.Product_Interest_1__c  = prodList[0].Id;
        leadRecord1.Business_Hours__c = busiHours.Id;
        leadRecord1.Manager__c = testUser.Id;
        insert leadRecord1;
        
        
        leadRecords.add(leadRecord);
        oldRecordsMap.put(leadRecord1.Id, leadRecord1);
        
        System.debug('*************Lead Size*************' + leadRecords.size());
        System.debug('*************Map*************' +oldRecordsMap);
        Test.startTest();
        SendEmailNofication.sendEmailToManager(leadRecords, oldRecordsMap);     
        Test.stopTest();
        
    }
}