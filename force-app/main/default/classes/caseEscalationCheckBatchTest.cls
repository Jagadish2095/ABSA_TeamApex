/* 
* Test Class for - caseEscalationCheckBatch
* @author   Vitthal Jivrag
* @since    2021-01-05
*/
@isTest
public class caseEscalationCheckBatchTest {
    @TestSetup
    public static void setTestData(){
        String orgId = UserInfo.getOrganizationId();
        String dateString = string.valueOf(date.today());
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        
        User uObj1 = new User();
        uObj1.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
        uObj1.LastName = 'JKumar';
        uObj1.Email = uniqueName + '@test1' + orgId + '.org';
        uObj1.Username =uniqueName + '@test1' + orgId + '.org';
        uObj1.CompanyName = 'TEST';
        uObj1.Title = 'Mr.';
        uObj1.EmailEncodingKey = 'ISO-8859-1';
        uObj1.Alias = uniqueName.substring(18, 23);
        uObj1.TimeZoneSidKey = 'America/Los_Angeles';
        uObj1.LocaleSidKey = 'en_US';
        uObj1.LanguageLocaleKey = 'en_US';
        uObj1.Advisor_Code__c='112211';
        Insert uObj1;
        
        User uObj = new User();
        uObj.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
        uObj.LastName = 'JKumar';
        uObj.Email = uniqueName + '@test' + orgId + '.org';
        uObj.Username = uniqueName + '@test' + orgId + '.org';
        uObj.CompanyName = 'TEST';
        uObj.Title = 'Mr.';
        uObj.EmailEncodingKey = 'ISO-8859-1';
        uObj.Alias = uniqueName.substring(18, 22);
        uObj.TimeZoneSidKey = 'America/Los_Angeles';
        uObj.LocaleSidKey = 'en_US';
        uObj.LanguageLocaleKey = 'en_US';
        uObj.Advisor_Code__c='112233';
        uobj.ManagerId=uObj1.id;
        Insert uObj;
        
       
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        Case c=new Case();
        c.RecordTypeId=devRecordTypeId;
        c.Status='New';       
        c.Adviser_Name__c ='Phuthi Railo';
        Date myDate = date.newInstance(2012,05,22);
        c.Birth_Date__c = myDate;
        c.First_Name__c = 'Test';
        c.Last_Name__c = 'Mbulis';
        c.Initials__c = 'MK';
        c.OwnerId=uObj1.Id;
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
        c.Status='New';        
        update c;  
    }
    @isTest
    public static void TestBatch(){
        
        case c=[select id,LastModifiedDate,CreatedDate,Case_Age__c from case];    
        
        test.startTest();    
        System.assertEquals(1,c.Case_Age__c);
        caseEscalationCheckBatch bb=new caseEscalationCheckBatch();
        Database.executeBatch(bb, 1);             
        test.stopTest();
    }
}