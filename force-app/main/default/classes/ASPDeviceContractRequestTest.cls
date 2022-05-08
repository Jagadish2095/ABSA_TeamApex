/**
 * @description       : Controller to generate contract request
 * @author            : Khaliq Abdul
 * @created 2021-10-18 
 * 1.0   2021-07-27   Khaliq Abdul
 */
@isTest
public class ASPDeviceContractRequestTest {

     @TestSetup
    static void makeData()
    {
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
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
            SiteCode__c ='8999',
			Advisor_Code__c = '112233'
		);
		insert au;
        
        List<User> currentUser = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		Site__c site = new Site__c();
		site.Name = 'New ATM SIte';
		site.Branch_ATM__c = true;
		site.Branch_Site_Name__c = 'Fourways';
		site.Branch_Site_Code__c = 1007;
		site.Site_Code__c = '8999';
		site.Site_Address__c = 'ABC';
		insert site;
    }
    
    @isTest
	public static void ASPContractRequestTestMethod() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
        
		System.runAs(au) {
			Test.startTest();
            ASPDeviceContractRequest request = ASPDeviceContractRequest.getNewInstance();
			System.assert(request != null, 'Test Working');
			Test.stopTest();
		}
	}
}