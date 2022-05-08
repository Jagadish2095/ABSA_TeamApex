/**
* @Purpose         : Test class for UserSitesSelecto
* @Last modified date : 2021-01-26
* @Author: Venkatesh Kanukuntla
*/ 
@isTest 
private class UserSitesSelectorTest {
@testSetup static void setup() {
         Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
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
        
        Site__c mySite = new Site__c();
        mySite.Cities_PickList__c='Bethal';
        mySite.Branch_Site_Name__c='Alberton';
        mySite.Name='TestClassSite';
        mySite.Site_Code__c='TEST123';Insert mySite;
    
        User_Site__c us = new User_Site__c();
        us.User__c=uObj.Id;
        us.Site__c=mySite.Id;
        Insert us;
    }
    @isTest
    private static void testselectByUserId() {
        User UserTest = [select id from user][0];
        UserSitesSelector uSelector=new UserSitesSelector();         
        list<User_Site__c> uObj=uSelector.selectByUserId(UserTest.Id); 
        
    }
    @isTest
    private static void testselectBySiteCity() {
        UserSitesSelector uSelector=new UserSitesSelector();         
        list<User_Site__c> uObj=uSelector.selectBySiteCity('bet%'); 
    }

}