/**
* @description    : Test class for CaseSupportSelector
* @auther - Vj
* Last modified date : 02/12/2020
*/

@isTest 
public class CaseSupportSelectorTest {

    
    @testSetup static void setup() {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        Id caseSupportRecordTypeId = Schema.SObjectType.Case_Support__c.getRecordTypeInfosByName().get('Policy').getRecordTypeId();
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
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
        uObj.Advisor_Code__c='112233';
        Insert uObj;        
        
        Account accObj=new Account();
        accObj.Name='Test Account';
        insert accObj;        
        
        Case c=new Case();
        c.RecordTypeId=caseRecordTypeId;
        c.Status='New';       
        c.Adviser_Name__c ='Phuthi Railo';
        Date myDate = date.newInstance(2012,05,22);
        c.Birth_Date__c = myDate;
        c.First_Name__c = 'Test';
        c.Last_Name__c = 'Mbulis';
        c.Initials__c = 'MK';
        c.OwnerId=uObj.Id;
        c.ID_Type__c = 'SA ID';
        c.Customer_ID__c = '1234567891238';
        c.Nationality__c = 'South Africa';
        c.Alternate_Phone4__c = '4444444444';
        c.Alternate_Phone2__c = '2222222222';
        c.Alternate_Phone1__c = '1111111111';
        c.Work_Phone__c = '9999999999';
        c.Home_Phone__c = '8888888888';
        c.Mobile__c = '7777777777';
        c.Adviser_Code__c='112233';
        c.Phys_Addr_Post_Code__c = '8976' ;
        c.Phys_Addr_Line1__c = 'University of PET';
        c.CIF_Custom__c = 'MBULIS 004';    
        insert c;    
        
        Case_Support__c csObj=new Case_Support__c();
        csObj.RecordTypeId=caseSupportRecordTypeId;
        csObj.Policy_Number__c='PLO233';
        csObj.Case__c=c.Id; 
        insert csObj;        
        
    }
    
    @isTest static void testselectByCaseID() {
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        System.assert(cObj != null, 'case Id is null');
        Id caseId=cObj.Case__c;
        list<String> listOfPolicy=new list<String>();
        listOfPolicy.add(cObj.id);
        CaseSupportSelector cs=new CaseSupportSelector();
        cs.selectByCaseID(caseId);
        cs.showPoliciesWise();
        cs.showPoliciesWise(cObj.id);
       cs.showPoliciesWise(listOfPolicy);
    }
}