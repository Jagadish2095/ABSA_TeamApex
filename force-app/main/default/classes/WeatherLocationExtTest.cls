/**
* Test class for WeatherBasedOnLocation
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2020-01-28
*
**/

@isTest
public class WeatherLocationExtTest {
    
    //Methods to test
    @isTest 
    public static void testWeatherLocationExtTest() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='Africa/Johannesburg', 
                          AB_Number__c = 'ABAB111', City = 'Johannesburg',Weather_City__c = 'Johannesburg',
                          UserName=uniqueUserName);
        
        Test.startTest();        
        System.runAs(u) {
            String cityLocation = WeatherLocationExt.getLoggedInUserLocation();
        }
        Test.stopTest();
        
    }
    @isTest 
    public static void testWeatherLocationExtTest2() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='Africa/Johannesburg', 
                          AB_Number__c = 'ABAB111', City = 'Johannesburg',Weather_City__c = 'Bloemfontein',
                          UserName=uniqueUserName);
        String cityLocation = 'Johannesburg';
        Test.startTest();        
        System.runAs(u) {
            cityLocation = WeatherLocationExt.getLoggedInUserLocation();
        }
        Test.stopTest();
              
    }
    
}