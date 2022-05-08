/**
 * @description       : Controller for thirdparty list
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Happy Baloyi                               Modification
 * 1.0   05-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/

@IsTest
public class CASAScreenRelatedParty_IU_v3_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"headers":{"X-Backside-Transport":["OK OK"],"Connection":["Keep-Alive"],"Transfer-Encoding":["chunked"],"X-Powered-By":["Servlet/3.1"],"Content-Type":["application/json; charset=UTF-8"],"Content-Language":["en-US"],"Date":["Mon, 07 Dec 2020 10:13:34 GMT"],"Expires":["Thu, 01 Dec 1994 16:00:00 GMT"],"Cache-Control":["no-cache=\"set-cookie, set-cookie2\""],"X-Global-Transaction-ID":["1cf73a895fce004ec67f67ad"],"Access-Control-Expose-Headers":["APIm-Debug-Trans-Id, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-Global-Transaction-ID"],"Access-Control-Allow-Origin":["*"],"Access-Control-Allow-Methods":["POST"],"Set-Cookie":["LtpaToken2=\"\"; Expires=Thu, 01 Dec 1994 16:00:00 GMT; Path=/; Secure; HttpOnly","LtpaToken2=Qq0mFXVDnbh6/7BhhI1hjCV3+KnusyxFT6nT9aNiNwPjXvFB1HEeJTvzVTRRGtOqD4pg1f1xn1eJiWYxrydSiazSk+XWFqmvcCr8xvqefLZMQoxOHYt5dgUVHzo8YnsmiB3hqow3mU5/izpXvJtFzYboBgQVqsj0IUH2jlvPhsNKutTVe1aCuPnHyAIqvsVx0eDEuFpEUxyrFQGGAbrub8cASWpcAllj6vAV/A1FeIA0H6fBxopcWkj97uAodN0BMMtD+GZhCUN7jUaO4pbcVJXtEPhprfJnq8rJm7PzNs2xPwHw8Ah9x3W3JUuD+MuV; Path=/; HttpOnly"],"X-RateLimit-Limit":["name=100 Per Minute,100;"],"X-RateLimit-Remaining":["name=100 Per Minute,99;"]},"body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":""}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":0,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"DUPLICATE PROFILE EXITS","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}';
	/**
	 * @description       : mapRequestTradingAsName
	 */
	@testSetup
	public static void makeData() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		//Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
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
	}

	@IsTest
	static void mapRequestTradingAsNamePositiveTest() {
		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Individual',
			Number_of_Participants__c = 2,
			ID_Type__c = 'SA Identity Document'
		);
		insert mainacc;
		Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
		testTradingAsName.Name = 'T/A Test';

		testTradingAsName.Account__c = mainacc.id;
		insert testTradingAsName;
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
			CASAScreenRelatedParty_Req_IB_v3 cASAScreenRelatedPartyReq = CASAScreenRelatedParty_IU_v3.mapRequestTradingAsName(testTradingAsName, '121212');

			System.assert(cASAScreenRelatedPartyReq.surnameComp != '121212', 'assert failed');
			Test.stopTest();
		}

	}
	@IsTest
	static void mapRequestTradingAsNameNegativeTest() {
		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Individual',
			Number_of_Participants__c = 2,
			ID_Type__c = 'SA Identity Document'
		);
		insert mainacc;
		Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
		testTradingAsName.Name = 'T/A Test';

		testTradingAsName.Account__c = mainacc.id;
		insert testTradingAsName;
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
			CASAScreenRelatedParty_Req_IB_v3 cASAScreenRelatedPartyReq = CASAScreenRelatedParty_IU_v3.mapRequestTradingAsName(testTradingAsName, '121212');

			System.assert(cASAScreenRelatedPartyReq.surnameComp != '121f212', 'assert failed');
			Test.stopTest();
		}
	}
	/**
	 * @description       : Controller for thirdparty list
	 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
	 * @group             :
	 * @last modified on  : 2021-07-10
	 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
	 * Modifications Log
	 * Ver   Date         Happy Baloyi                               Modification
	 * 1.0   05-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
	 **/
	@IsTest
	static void mapRequestJntAccountFieldsBusinessPositveTest() {
		Account mainacc = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Individual',
			Number_of_Participants__c = 2,
			ID_Type__c = 'SA Identity Document',
			PersonBirthdate = Date.valueOf('1986-04-25')
		);
		insert mainacc;
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
			CASAScreenRelatedParty_Req_IB_v3 cASAScreenRelatedPartyReq = CASAScreenRelatedParty_IU_v3.mapRequestJntAccountFieldsBusiness(mainacc, '121212');
			System.assert(cASAScreenRelatedPartyReq.surnameComp != '121212', 'assert failed');
			Test.stopTest();
		}

	}
	@IsTest
	static void mapRequestJntAccountFieldsBusinessNegativeTest() {
		Account mainacc = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Individual',
			Number_of_Participants__c = 2,
			ID_Type__c = 'SA Identity Document',
			PersonBirthdate = Date.valueOf('1986-04-25')
		);
		insert mainacc;
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
			CASAScreenRelatedParty_Req_IB_v3 cASAScreenRelatedPartyReq = CASAScreenRelatedParty_IU_v3.mapRequestJntAccountFieldsBusiness(mainacc, '121212');
			System.assert(cASAScreenRelatedPartyReq.surnameComp != '1212g12', 'assert failed');
			Test.stopTest();
		}
	}

	@IsTest
	static void mapRequestStokvelaccountFieldsPositiveTest() {
		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',            
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Account relatedPartyAccount = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			Phone = '0835002323',
			CIF__c = 'AubreP009',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'South Africa',
			Country_of_Residence__pc = 'South Africa',          
			ID_Number__pc = '8604254315089',
			Client_Group__c = 'Individual',            
			ID_Type__c = 'SA Identity Document',
            Countries_Traded_With__c='India',
			PersonBirthdate = Date.valueOf('1986-04-25'),
            Date_Issued__pc = Date.valueOf('2021-07-05')
		);
		insert relatedPartyAccount;
        Account relatedPartfy = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
        
        Contact relatedcntParty = 
            [SELECT Id,
             CASA_Reference_Number__c,
             CASA_Screening_Date__c,
             CASA_Screening_Status__c,
             Birthdate,
             Country_of_Birth__c,
             Source_of_Income__c,
             FirstName,
             LastName,
             ID_Number__c,
             Country_of_Residence__c,
             Nationality__c,
             Gender__c
             FROM Contact WHERE ID = :relatedPartfy.PersonContactId];
        
        relatedcntParty.ID_Number__c='6905257273088';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121238147';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
        relatedcntParty.Source_of_Income__c = 'Salary';
        relatedcntParty.OtherPhone='0897897654';
        relatedcntParty.Birthdate = date.valueof('2021-06-11');
        relatedcntParty.Country_of_Birth__c= 'South Africa';
		relatedcntParty.Country_of_Residence__c= 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
		relatedcntParty.Gender__c = 'Male';
        update relatedcntParty;
        
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = mainacc.Id;
		acr.ContactId = relatedcntParty.Id;
        acr.Control_of_Passive_Non_Financial_Entity__c = true;
        acr.Controlling_Person_is_Taxed_Outside__c = true;
		acr.Primary_Entity_Id__c = mainacc.Id;
        
		insert acr;
        
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

			CASAScreenRelatedParty_Req_IB_v3 cASAScreenRelatedPartyReq = CASAScreenRelatedParty_IU_v3.mapRequestStokvelaccountFields(acr, '121212');
			//System.assert(cASAScreenRelatedPartyReq.surnameComp != '121212', 'assert failed');
			System.assertNotEquals('','assert failed');
			Test.stopTest();
		}
	}

       @IsTest
	static void mapRequestStokvelaccountFieldsNegativeTest() {
		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',            
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Account relatedPartyAccount = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			Phone = '0835002323',
			CIF__c = 'AubreP009',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'South Africa',
			Country_of_Residence__pc = 'South Africa',          
			ID_Number__pc = '8604254315089',
			Client_Group__c = 'Individual',            
			ID_Type__c = 'SA Identity Document',
            Countries_Traded_With__c='India',
			PersonBirthdate = Date.valueOf('1986-04-25'),
            Date_Issued__pc = Date.valueOf('2021-07-05')
		);
		insert relatedPartyAccount;
        Account relatedPartfy = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
        
        Contact relatedcntParty = 
            [SELECT Id,
             CASA_Reference_Number__c,
             CASA_Screening_Date__c,
             CASA_Screening_Status__c,
             Birthdate,
             Country_of_Birth__c,
             Source_of_Income__c,
             FirstName,
             LastName,
             ID_Number__c,
             Country_of_Residence__c,
             Nationality__c,
             Gender__c
             FROM Contact WHERE ID = :relatedPartfy.PersonContactId];
        
        relatedcntParty.ID_Number__c='6905257273088';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121238147';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
        relatedcntParty.Source_of_Income__c = 'Salary';
        relatedcntParty.OtherPhone='0897897654';
        relatedcntParty.Birthdate = date.valueof('2021-06-11');
        relatedcntParty.Country_of_Birth__c= 'South Africa';
		relatedcntParty.Country_of_Residence__c= 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
		relatedcntParty.Gender__c = 'Male';
        update relatedcntParty;
        
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = mainacc.Id;
		acr.ContactId = relatedcntParty.Id;
        acr.Control_of_Passive_Non_Financial_Entity__c = true;
        acr.Controlling_Person_is_Taxed_Outside__c = true;
		acr.Primary_Entity_Id__c = mainacc.Id;
        
		insert acr;
        
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

			CASAScreenRelatedParty_Req_IB_v3 cASAScreenRelatedPartyReq = CASAScreenRelatedParty_IU_v3.mapRequestStokvelaccountFields(acr, '121212');
			System.assertNotEquals('', 'assert failed');
			Test.stopTest();
		}
	}
	/**
 * @description       : Controller for thirdparty list
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Happy Baloyi                               Modification
 * 1.0   05-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
*  
@IsTest
 static void mapResponseFieldsTest() {
  CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyResp = new CASAScreenRelatedParty_Resp_IB_v3();
        screenRelatedPartyResp.msgNo = '0';
        screenRelatedPartyResp.msg = 'CSA 0 added succesfully';
        screenRelatedPartyResp.refNo = '0';
        screenRelatedPartyResp.respStatus = '';        
          HttpResponse response = new HttpResponse();        
        Test.startTest();
     CASAScreenRelatedParty_IU_v3.mapResponseFields(response, '121212');
        Test.stopTest(); 
            
 }*/
}