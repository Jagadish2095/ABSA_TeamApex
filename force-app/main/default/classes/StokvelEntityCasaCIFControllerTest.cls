/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-10-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-04   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest

public class StokvelEntityCasaCIFControllerTest {
	public static final String POSITIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success","refNo":"120004946","status":"P"}';
	public static final String NEGATIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success","refNo":"0","status":""}';
    	public static final String POSITIVE_RESPONSE_BODY_GetStatus = '{"WQgetCASAStatusByRefNoV7Response":{"wqp102o":{"surnameComp":"BOOTH","casaStatus":"I","pepSts":null,"msgNo":0,"msg":"INCOMPLETE-RISKP","idType":1,"idRegNo":8805240649081,"firstName":"MAYA","documentSts":"I","comments":null,"approvedSts":null},"nbsapdpo":{"version":"APLO003","serviceVersion":"BUSO001","returnCode":0,"reasonCode":0,"echoKey":null}}}';

    	
   	@testSetup
	static void dataCreation() {
        
        
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
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
      
		Account mainacc = new Account(
			Name = 'TheStokvel',
           // LastName='stokProd',
			Phone = '0840404898',
            CIF__c = 'Clinet 001',
			Preferred_Communication_Method__c = 'Email',
			CASA_Reference_Number__c = '121229158',
            CASA_Screening_Status__c= 'C',
			Client_Group__c = 'Non Individual',
			Number_of_Participants__c = 2,
			Country_of_Registration__c = 'South Africa',
			Country_of_Incorporation__c = 'South Africa',
			RepresetentiveName__c = 'anna',            
			RepresentativeLastname__c = 'dave',
            Language__c='English'
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
            
			PersonBirthdate = Date.valueOf('1986-04-25')
		);
		insert relatedPartyAccount;

		Account relatedParty = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane' LIMIT 1];
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
        FROM Contact WHERE ID = :relatedParty.PersonContactId];

		 relatedcntParty.ID_Number__c='12121212121212';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121212';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
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
        
        Address__c postalAddress = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Account__c = relatedParty.ID,
			Address_TYpe__c = 'Postal'
		);
		insert postalAddress;
		Address__c residential = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Residential',
			Account__c = relatedParty.ID
		);
        insert residential;
        Integration_Translation__c returnValues = new Integration_Translation__c(
			External_Value__c = '02',
			Value_Type__c = 'Prefcomms',
			Internal_Value__c = 'Email',
			System_Name__c = 'CIFCodesList',
			Direction__c = 'Outbound'
		);
		insert returnValues;

	}

  
    @IsTest
	static void getTranslationValuesPositiveTest() {
		  Integration_Translation__c  intertranslation= [ Select External_Value__c, Value_Type__c, Internal_Value__c , System_Name__c , Direction__c
                                                         from  Integration_Translation__c 	WHERE	Value_Type__c = 'Prefcomms'];
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
		string outb =	StokvelEntityCasaCIFController.getTranslationValues('CIFCodesList', 'Email', 'Prefcomms', 'Outbound');

			Test.stopTest();
			System.assert(outb =='02', 'assert failed');
		}
	}
	@IsTest
	static void getTranslationValuesnEGATIVETest() {

      Integration_Translation__c intertranslation = [ Select External_Value__c, Value_Type__c, Internal_Value__c , System_Name__c , Direction__c
                                                     from  Integration_Translation__c WHERE	Value_Type__c = 'Prefcomms'];
        
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
			string outb =	StokvelEntityCasaCIFController.getTranslationValues('CIFCodesList', 'Email', 'Prefcomms', 'Outbound');
	  
				Test.stopTest();
				System.assert(outb =='02', 'assert failed');
		}
	}
	@IsTest
	static void createCIFPositiveTest() {
	
Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		//Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		String POSITIVE_RESPONSE_BODY = '{"status":"OK","body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":""}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":200,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}}';

		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CVSCreateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME });        
       
       
        
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
			String CIFKEY=		StokvelEntityCasaCIFController.createstokvelCIF(mainacc.Id);
			Test.stopTest();
			System.assert(CIFKEY != null, 'assert failed');
		}
	}

	@IsTest   static void createCIFNegativeTest() {
		Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Contact relatedPartyAccount = [SELECT ID FROM Contact WHERE lastName = 'Pjane' limit 1];
		//Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		String NEGATIVE_RESPONSE_BODY = '{"status":"OK","body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":""}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":500,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}}';

		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NEGATIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CVSCreateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME });        
       
       
        
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
			String CIFKEYcreated =		StokvelEntityCasaCIFController.createstokvelCIF(mainacc.Id);
				
			System.assert(CIFKEYcreated !=null,'assert failed');
			Test.stopTest();
			
		}

		}


@IsTest
	static void cifGetClientDetailsPositiveTest() {
        Account mainacc = [SELECT ID, CIF__c FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CASA_SCREEN_RELATED_PARTY_V6 });
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
            CIgetClientDetailsV12_Resp_IB_v1 exist =	StokvelEntityCasaCIFController.cifGetClientDetails('SEBENZA037');
   
            Test.stopTest();
         
            System.assert(exist != null, 'Assert  failed');
		}

	}

	@IsTest
	static void cifGetClientDetailsNegativeTest() {
		Account mainacc = [SELECT ID, CIF__c FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
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
            CIgetClientDetailsV12_Resp_IB_v1 nonexist =	StokvelEntityCasaCIFController.cifGetClientDetails('SEBENZA037');			
            Test.stopTest();
      //      System.debug('exist ' + exist);
            System.assert(nonexist.addressEntry == null, 'Assert  failed');
		}
	}
    	@IsTest
	static void checkifCIFExistNegativeTest() {
		Account mainacc = [SELECT ID, CIF__c FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
        
        String POSITIVE_RESPONSE_BODY = '{"status":"OK","body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":"Clinet 001"}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":200,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}}';
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CVSCreateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME });        
       
        
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
            string nonexist =	StokvelEntityCasaCIFController.checkifCIFExist(mainacc.id);			
            Test.stopTest();
            
           // Console.log('nonexistPasha' + nonexist);
           // System.assert(false, 'Assert  failed');
            System.assertNotEquals('', nonexist);
		}
	}

		@IsTest
	static void createstokvelCIFtes() {
	
        Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Contact relatedPartyAccount = [SELECT ID FROM Contact WHERE lastName = 'Pjane' limit 1];
		String NEGATIVE_RESPONSE_BODY = '{"status":"OK","body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":"WWWA"}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":500,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}}';

		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NEGATIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CVSCreateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME });  

            
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
           String Casa=		StokvelEntityCasaCIFController.createstokvelCIF(mainacc.Id);
            Test.stopTest();
          System.assert(Casa !=null,'assert failed');
		}
	}
    
    
		@IsTest
	static void  getEntityCasastatustes() {
	
        Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Contact relatedPartyAccount = [SELECT ID FROM Contact WHERE lastName = 'Pjane' limit 1];
				Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GetStatus));
       
        
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
           StokvelEntityCasaCIFController.StokvelWrapper Casa=		StokvelEntityCasaCIFController.getEntityCasastatus(mainacc.Id);
            Test.stopTest();
          System.assert(Casa !=null,'assert failed');
		}
	}
	@IsTest
	static void  getrelatedCasastatustes() {
	
        Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Contact relatedPartyAccount = [SELECT ID FROM Contact WHERE lastName = 'Pjane' limit 1];
				Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GetStatus));
       
        
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
           StokvelEntityCasaCIFController.StokvelWrapper Casa=		StokvelEntityCasaCIFController.getrelatedCasastatus(mainacc.Id);
            Test.stopTest();
          System.assert(Casa !=null,'assert failed');
		}
	}
}