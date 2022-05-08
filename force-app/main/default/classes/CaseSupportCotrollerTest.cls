@isTest
public class CaseSupportCotrollerTest {
    
    @testSetup static void setup() {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Maturity').getRecordTypeId();
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
        
        
        Account accObj2=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
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
        cObj.SelectedAdvisorIdF2F__c = uObj.Id;
        insert cObj; 
        
             
        Case_Support__c csObj=new Case_Support__c();
        csObj.RecordTypeId=caseSupportRecordTypeId;
        csObj.Case__c=cObj.Id; 
        csObj.Policy_Number__c= 'JN90345';
        insert csObj; 
        
    }
   @isTest 
    public static void test1(){
        Case c=[select id from case limit 1]; 
       // Case_Support__c csObj=[select id from Case_Support__c limit 1];
       System.assert(c != null, 'case Id is null');

        CaseSupportCotroller.getCaseDetails(c.Id);
        CaseSupportCotroller.getPolicyDetails(c.Id);
        
    }    
    
}