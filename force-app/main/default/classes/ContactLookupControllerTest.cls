@isTest
public class ContactLookupControllerTest {
    
    /*@testSetup static void setup() {
  //Group g1 = new Group(Name='VAQueueEmailMembersGroup');
        //insert g1;
      
        Group g2 = new Group(Name='Virtual STI Bancassurance',  type='Queue');
        insert g2;
        
        QueuesObject q1 = new QueueSObject(QueueID = g2.id, SobjectType = 'Lead');
        insert q1;
        
       
       
        String userId=UserInfo.getUserId();
        GroupMember member = new GroupMember();
        member.UserOrGroupId = userId;
        member.GroupId = g2.Id;
        
        insert member;
     
    }
    */
    @isTest static void vadlidateContactLookupController() {
        
        Account accObj=new Account();
        accObj.Name='Test Account';
        insert accObj; 
        
        Contact conObj=new Contact();
        conObj.LastName='Test Contact';
        conObj.AccountId = accObj.Id;
        insert conObj;
        
        String keyWord = 'Test';
        String Objname = 'Contact';
        account acc=new account();
        acc.lastname='test';
        acc.PersonBirthdate=system.today();
        insert acc;
        
        ContactLookupController.fetchContactRecords(keyWord,Objname,keyWord);
        
        
    }
    
    @isTest static void test2(){
        
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
        
        //test.startTest();
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
        
        Lead lObj=new Lead();
        lObj.OwnerId=uObj.Id;
        lObj.LastName='Doe';
         lObj.Lead_Email__c='test@test.com';
        lObj.AIC_Relationship_Consultant_Name__c = 'Ebrahim Majiet (Ebrahim.Majiet@absa.co.za)';
        lObj.FirstName='John';
        lObj.Company='Test';
     
        lObj.Salutation='mr';
        lObj.RecordTypeId=leadRecordTypeId;
        lObj.Status='Unallocated';
        insert lObj;
        Lead leadObj = [select Id,RecordTypeId,Owner_Type__c,AIC_Relationship_Consultant_Name__c from Lead ];
        
        
        
        list<string>strList=new list<string>();
        strList.add(leadObj.Id);
        ContactLookupController.getMailAddresses();
        ContactLookupController.sendEmailToQueueMembers(strList);
        System.debug('owner of lead'+leadObj);
        //test.stopTest();
        
        
    }
    /*
@isTest static void test3(){
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
     //test.startTest
     Group groupObj = [select Id from Group where  type='Queue' LIMIT 1];
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
        
        Lead lObj=new Lead();
        lObj.OwnerId=uObj.Id;
        lObj.LastName='Doe';
         lObj.Lead_Email__c='test@test.com';
        lObj.AIC_Relationship_Consultant_Name__c = 'Ebrahim Majiet (Ebrahim.Majiet@absa.co.za)';
        lObj.FirstName='John';
        lObj.Company='Test';
        
        lObj.Salutation='mr';
        lObj.RecordTypeId=leadRecordTypeId;
        //lObj.Status='Unallocated';
        insert lObj;
       
        
        lObj.OwnerId=groupObj.Id;
    lObj.Status='allocated';
    	Update lObj;
         Lead leadObj = [select Id,RecordTypeId,Owner_Type__c,AIC_Relationship_Consultant_Name__c from Lead];
        list<string>strList=new list<string>();
        strList.add(leadObj.Id);
        System.debug('owner of lead'+leadObj);
        ContactLookupController.sendEmailToQueueMembers(strList);
        System.debug('owner of lead'+leadObj);
        //test.stopTest();
}
        
    */
    
}