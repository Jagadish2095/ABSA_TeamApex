@isTest
public class FPSBUSegmentCtrlTest {

    public static testMethod void SBUTest() {
        
       Account acct1   = new Account();
       acct1.Name      = 'testAccount1';
       Insert acct1;
       id accountid=acct1.id;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];        
        User u2 = new User(Alias = 'standard', Email='bankerusermanager@testorg.com', 
                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                  LocaleSidKey='en_US', ProfileId = p.Id, BRID__c='123456',FirstName='banker',MobilePhone='1234567788',
                  AB_Number__c='123434',SiteCode__c='1234',Last_Login_Date__c=System.now(),
                  TimeZoneSidKey='America/Los_Angeles', UserName='bankermanager@testorg.com');
            insert u2;
        
        id managerid=u2.id;
        User u1 = new User(Alias = 'standt', Email='bankeruser@testorg.com', 
                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                  LocaleSidKey='en_US', ProfileId = p.Id, BRID__c='123456',FirstName='banker',MobilePhone='1234567788',
                  AB_Number__c='123434',SiteCode__c='1234',Last_Login_Date__c=System.now(),ManagerId=managerid,
                  TimeZoneSidKey='America/Los_Angeles', UserName='bankeruser@testorg.com');
            insert u1;
        
      string managerName=u1.Name;
        
      Test.startTest();        
        FPSBUSegmentCtrl.getManagerDetails(managerName);
        FPSBUSegmentCtrl.getRelationshipBanker(accountid);
      Test.stopTest();
    }

}