/**
* Test class for the SitesSelector class
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-10-01
*/
@isTest
public class SitesSelectorTest {
    
    @isTest
    private static void testSelectById() {
        
        //Test data
        Site__c site = new Site__c();
        site.Name = 'New ATM SIte';
        site.Branch_ATM__c = true;
        site.Branch_Site_Name__c = 'Fourways';
        site.Branch_Site_Code__c = 1007;
        site.Site_Code__c = '7001';
        site.Site_Address__c = 'ABC';
        insert site;
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(site.Id);
        
        Test.startTest();
        
 		List<Site__c> siteList = new SitesSelector().selectById(idSet); 
        Site__c siteRecord = new SitesSelector().selectById(site.Id);
        
        System.assertEquals(siteList.size(), 1);
        
		Test.stopTest();
    }
    
        @isTest
    private static void testSelectByServiceGroup() {
        
        //Test data
        Site__c site = new Site__c();
        site.Name = 'New ATM SIte';
        site.Branch_ATM__c = true;
        site.Branch_Site_Name__c = 'Fourways';
        site.Branch_Site_Code__c = 1007;
        site.Site_Code__c = '7001';
        site.Site_Address__c = 'ABC';
        insert site;
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(site.Id);
        
        Test.startTest();
        
 		List<Site__c> siteList = new SitesSelector().selectByServiceGroup(idSet); 
        
		Test.stopTest();
    }
    
    @isTest
    private static void testselectBySiteCode() {
        //Test data
        Site__c site = new Site__c();
        site.Name = 'New ATM SIte';
        site.Branch_ATM__c = true;
        site.Branch_Site_Name__c = 'Fourways';
        site.Branch_Site_Code__c = 1007;
        site.Site_Code__c = '7001';
        site.Site_Address__c = 'ABC';
        insert site;
        
        Test.startTest();
        
 		List<Site__c> siteList = new SitesSelector().selectBySiteCode(site.Site_Code__c); 
        
		Test.stopTest();
    }
}