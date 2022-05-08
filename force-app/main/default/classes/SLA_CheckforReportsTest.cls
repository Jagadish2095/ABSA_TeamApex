/* 
* This class used to test SLA_CheckforReports Batch Class
* Apex Class - SLA_CheckforReports
* @author   Vitthal j 
* @since    2021-06-02
*/

@isTest
public class SLA_CheckforReportsTest {
    
    @isTest static void validateBatchUpdate() 
    {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Client Review').getRecordTypeId();
        
        Account accObj2=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;  
        
        Case cObj=new Case();
        Date myDate = date.newInstance(2012,05,22);
        cObj.RecordTypeId=caseRecordTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c='112233';
        cObj.Customer_ID__c='1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c='Test Client';
        cObj.Last_Name__c='Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976' ;
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c='Test JKumar';
        cObj.AccountId=accObj2.id;
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c ='';
        cObj.Status='New';             
        insert cObj; 
        
        cObj.Status='Assigned'; 
        update cObj;
        System.assert(cObj != null, 'case Id is null');
        Test.startTest();
        SLA_CheckforReports cs1 = new SLA_CheckforReports();
        Database.executeBatch(cs1);
        Test.stopTest();        
    }
    @isTest static void validateBatchUpdate1() 
    {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Client Review').getRecordTypeId();
        
        Account accObj2=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;  
        
        Case cObj=new Case();
        Date myDate = date.newInstance(2012,05,22);
        cObj.RecordTypeId=caseRecordTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c='112233';
        cObj.Customer_ID__c='1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c='Test Client';
        cObj.Last_Name__c='Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976' ;
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c='Test JKumar';
        cObj.AccountId=accObj2.id;
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c ='';
        cObj.Status='Calling Attemps Started';             
        insert cObj; 
        
        cObj.Status='In Progress'; 
        update cObj;
        System.assert(cObj != null, 'case Id is null');
        Test.startTest();
        SLA_CheckforReports cs1 = new SLA_CheckforReports();
        Database.executeBatch(cs1);
        Test.stopTest();        
    }
    @isTest static void validateBatchUpdate3() 
    {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Maturity').getRecordTypeId();
        
        Account accObj2=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;  
        
        Case cObj=new Case();
        Date myDate = date.newInstance(2012,05,22);
        cObj.RecordTypeId=caseRecordTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c='112233';
        cObj.Customer_ID__c='1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c='Test Client';
        cObj.Last_Name__c='Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976' ;
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c='Test JKumar';
        cObj.AccountId=accObj2.id;
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c ='';
        cObj.Status='New';             
        insert cObj; 
        
        cObj.Status='Assigned'; 
        update cObj;
        System.assert(cObj != null, 'case Id is null');
        Test.startTest();
        SLA_CheckforReports cs1 = new SLA_CheckforReports();
        Database.executeBatch(cs1);
        Test.stopTest();        
    }
    @isTest static void validateBatchUpdate4() 
    {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Maturity').getRecordTypeId();
        
        Account accObj2=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;  
        
        Case cObj=new Case();
        Date myDate = date.newInstance(2012,05,22);
        cObj.RecordTypeId=caseRecordTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c='112233';
        cObj.Customer_ID__c='1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c='Test Client';
        cObj.Last_Name__c='Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976' ;
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c='Test JKumar';
        cObj.AccountId=accObj2.id;
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c ='';
        cObj.Status='New';  
        TriggerDispatcher.skip(CaseTriggerHandler.class.getName());           
        insert cObj;
        
        cObj.Status='Assigned';         
        update cObj;
        
        cObj.Status='Calling Attemps Started';         
        update cObj;
        
        cObj.Status='In Progress';         
        update cObj;
        System.assert(cObj != null, 'case Id is null');
        Test.startTest();
        SLA_CheckforReports cs1 = new SLA_CheckforReports();
        Database.executeBatch(cs1);
        Test.stopTest();        
    }
    
}