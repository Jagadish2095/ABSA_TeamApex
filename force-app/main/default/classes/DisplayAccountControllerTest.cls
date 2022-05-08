/*
* Display Account Controller (DisplayAccountControllerTest)
* @author Khaliq Abdul
* @created 2021-03-04
*/
@isTest
public class DisplayAccountControllerTest {
    
      @isTest 
    public static void testDisplayAccountControllerPositive() { 
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        sysAdminUser.SiteCode__c='8196';
        insert sysAdminUser;
        
       
        
        Account acc = new Account();       
        acc.FirstName='First test';
        acc.LastName='last test';
        //acc.CIF__c='LTD 933';       
        acc.Language__c='english';      
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        acc.CIF__c='ARENTAL001';
        insert acc;
      
        Test.startTest(); 
        string resp = DisplayAccountController.getAcctLinkedToClientCodeV3(acc.Id); 
        System.debug(resp);
        //System.assertEquals(500, resp.statusCode);
        
        Test.stopTest();
    } 
    
    @isTest 
    public static void testDisplayAccountControllerNegative() { 
        
         Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        sysAdminUser.SiteCode__c='8196';
        insert sysAdminUser;
        
        Account acc = new Account();       
        acc.FirstName='First test';
        acc.LastName='last test';
        acc.CIF__c='LTD 933';       
        acc.Language__c='english';      
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        insert acc;
        
       
       
        Test.startTest(); 
        string resp = DisplayAccountController.getAcctLinkedToClientCodeV3(acc.Id); 
        System.debug(resp);
        //System.assertEquals(500, resp.statusCode);
        
        Test.stopTest();
    }

     @isTest 
    public static void testDisplayAccountControllerCodePositive() { 
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        sysAdminUser.SiteCode__c='8196';
        insert sysAdminUser;
        
       
        
        Account acc = new Account();       
        acc.FirstName='First test';
        acc.LastName='last test';
        //acc.CIF__c='LTD 933';       
        acc.Language__c='english';      
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        acc.CIF__c='ARENTAL001';
        insert acc;
      
        Test.startTest(); 
        string resp = DisplayAccountController.getAcctLinkedToClientCode(acc.CIF__c); 
        System.debug(resp);
        //System.assertEquals(500, resp.statusCode);
        
        Test.stopTest();
    } 
    
    @isTest 
    public static void testDisplayAccountControllerCodeNegative() { 
        
         Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'actest';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser;
        
       
        Account acc = new Account();       
        acc.FirstName='First test';
        acc.LastName='last test';
        //acc.CIF__c='LTD 933';       
        acc.Language__c='english';      
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        insert acc;
        
       
       
        Test.startTest(); 
        string resp = DisplayAccountController.getAcctLinkedToClientCode(acc.CIF__c); 
        System.debug(resp);
        //System.assertEquals(500, resp.statusCode);
        
        Test.stopTest();
    }
    
}