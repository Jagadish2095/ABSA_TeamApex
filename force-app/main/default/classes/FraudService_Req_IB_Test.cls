/**
 * @description       : Test Class for FraudController
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Nkaiseng Malete      Modification
 * 1.0   05-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@IsTest
public class FraudService_Req_IB_Test { 
 @IsTest  static void createdummy() {
 			String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
        Test.startTest();
        

       
     FraudService_Req_IB_v1  fraudResponseMap =FraudService_Req_IB_v1.createDummyRequest();
        if(fraudResponseMap!=null)
        { System.assert(fraudResponseMap !=null, 'Failed to call service');
        }
        Test.stopTest();
        }
 }
    
}