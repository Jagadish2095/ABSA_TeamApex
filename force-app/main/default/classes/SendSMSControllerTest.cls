/**
 * @description       : SendSMSController Test Class
 * @author            : Ignecious Mushanguri
 * @group             : Cloudsmiths
 * @last modified on  : 11-25-2020
  * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   11-22-2020   Ignecious Mushanguri   Initial Version
**/

@isTest
public with sharing class SendSMSControllerTest {
    
    @TestSetup
    static void createTestData(){

    Map<String,Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();  
    
    Map<String,Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

    Account account =  new Account( Name = 'Test Account SMS Feature');

    insert account;

    Case caseRec = new Case( Status = 'New',
    Origin ='Email',
    AccountId = account.Id, 
    Subject = 'Test Case SMS Feature',
    Description = 'Test',
    Email__c = 'test@test.com'
    );

    insert caseRec;

    QuickText smstemplate = new QuickText ( Name = 'Request for ID SMS',Message = 'Please send ID');
    insert  smstemplate;

    Integration_API__c api = new Integration_API__c();
        api.Name = 'iTouchxx';
        api.Environment__c = 'UAT';
        api.Base_URL__c = 'https://testme/';
        api.Client_ID__c = '89797897987';
        api.Client_Secret__c = '789798';
        insert api;

        Integration_Service__c intsrv = new Integration_Service__c();
        intsrv.Integration_API_ID__c = api.Id;
        intsrv.Name = 'iTouch SMS Submit';
        intsrv.Method__c = 'POST';
        intsrv.URL_Extension__c = 'iTouch';
        intsrv.Username__c = 'abc';
        intsrv.Password__c = 'zyx';
        intsrv.Content_Type__c = 'application/json';
        insert intsrv;      
    }
   
    @isTest
    static void initMethodGetLinkedAccount(){   

    Case caseRec = [SELECT Id,RecordTypeId FROM Case WHERE Subject = 'Test Case SMS Feature' LIMIT 1];
    
    Test.startTest();
        List<String> linkedAcc = SendSMSController.getLinkedAccount(caseRec.Id);
        System.AssertEquals(2,linkedAcc.size());
    Test.stopTest();

    }

    @isTest
    static void smsTemplates(){

     List<Folder> folders = new List<Folder>([SELECT Id,Name from  Folder WHERE Name = 'Contact Centre']);   
     String folderName = '';
     Id folderId;
    
     if(folders.size() > 0){

        folderName = folders.get(0).Name;
        folderId = folders.get(0).Id;
     }

     QuickText smstemplate = new QuickText ( Name = 'Load Approved SMS',Message = 'Load Approved SMS',FolderId = folderId);
     insert  smstemplate;

     Test.startTest();
     List<QuickText> linkedSmsTemplates = SendSMSController.getQuickTextTemplates(folderName);
     Test.stopTest();
    }

    @isTest 
    static void sendSMSQuickAction(){ 
        
    Case caseRec = [SELECT Id,RecordTypeId FROM Case WHERE Subject = 'Test Case SMS Feature' LIMIT 1];

    String quickTextName = ''; 
    String phoneNumber = '0782441803';  
    
    List<QuickText> smsTemplateNames = new List<QuickText>([SELECT Name from QuickText WHERE Name = 'Request for ID SMS']);
        
    if(smsTemplateNames.size() > 0){

        quickTextName = smsTemplateNames.get(0).Name;
        
        }
        
        test.startTest();
        
            SendSMSController.sendSMSQuickAction(caseRec.Id,phoneNumber,quickTextName);
            System.assertEquals('Request for ID SMS', quickTextName);
            System.AssertEquals(1,smsTemplateNames.size());
        
        test.stopTest();
    }
}