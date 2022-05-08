/**
 * @description       : Controller for auth list
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-11-05
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Happy Baloyi                               Modification
 * 1.0   08-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@IsTest
public class RelatedPartyAuthorityController_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success"}';
	public static final String NEGATIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success"}';
/**
 * @description data creation
 *  
 */
	@testSetup
	public static void dataCreation() {
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
			sitecode__c='8404',
			Teller_Operator_Code__c= '878',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
        
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
			CIF__c = '',
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
        
      
        Account relatedPartyAccount2 = new Account(FirstName = 'MAar',
                                                   LastName = 'Wawa',
                                                  CIF__C = 'MASKIE11',
                                                  date_issued__pc = date.valueOf('2021-07-09'),
                                                  Employer_Phone__c= '0121231234'
                                                  );
        insert relatedPartyAccount2;
        Account relatedPartyd = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Wawa'];
        
        	Address__c residential1 = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Residential',
			Account__c = relatedPartyd.ID
		);insert residential1 ;	
Address__c postal1= new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Postal',
			Account__c = relatedPartyd.ID
		);
insert postal1;

Address__c employer1= new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Employers',
			Account__c = relatedPartyd.ID
		);
insert employer1;
        
        
        Contact relatedcntParty2 = 
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
             FROM Contact WHERE ID = :relatedPartyd.PersonContactId];
        
        relatedcntParty2.ID_Number__c='6906257273088';
        relatedcntParty2.FirstName = 'MAar';
        relatedcntParty2.LastName = 'Wawa';
		relatedcntParty2.CASA_Reference_Number__c= '121212';
		relatedcntParty2.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty2.CASA_Screening_Status__c = 'P';
        relatedcntParty2.Birthdate = date.valueof('2021-06-11');
        relatedcntParty2.Country_of_Birth__c= 'South Africa';
		relatedcntParty2.Country_of_Residence__c= 'South Africa';
		relatedcntParty2.Nationality__c = 'South Africa';
		relatedcntParty2.Gender__c = 'Male';
        update relatedcntParty2;
        
        Account relatedParty5 = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'wawa'];
        AccountContactRelation acr1 = new AccountContactRelation();
        acr1.AccountId = mainacc.Id;
        acr1.ContactId = relatedcntParty2.Id;
        acr1.Primary_Entity_Id__c = mainacc.Id;
        acr1.Control_of_Passive_Non_Financial_Entity__c = false;
        acr1.Controlling_Person_is_Taxed_Outside__c = false;
        insert acr1;
         
		Address__c postalAddress = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Account__c = relatedPartyAccount.ID,
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
			Account__c = relatedPartyAccount.ID
		);
        insert residential;
	Address__c employer = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Employers',
			Account__c = relatedPartyAccount.ID
		);
        insert employer;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        
        Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings',ProductCode='09050');
        insert savingsprod; 
        
        PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
        insert savingsPrice;
        
        Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
        salesProcess.Request_Name__c = 'CAF Application';
        salesProcess.Name = 'stokvel Application';
        salesProcess.Opportunity_Record_Type__c = 'CAF Application';
        insert salesProcess;
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;   
        
        Opportunity savingsOpportunity = new Opportunity();
        savingsOpportunity.Name = 'Test Savings Onboarding';
        savingsOpportunity.CloseDate = Date.today();
        savingsOpportunity.StageName = 'New';
        savingsOpportunity.Pricebook2Id=pb.id;
        savingsOpportunity.AccountId=mainacc.id;
        savingsOpportunity.Site__c=siteRec.id;
        savingsOpportunity.CBPIndicator__c = '123456789';
        insert savingsOpportunity;
        
        OpportunityLineItem savingsLineItem = new OpportunityLineItem();
        savingsLineItem.OpportunityId = savingsOpportunity.id;
        savingsLineItem.Product2Id = savingsprod.id;
        savingsLineItem.PricebookEntryId = savingsPrice.id;
      //  savingsLineItem.Product_Name__c = 'savinfn';
        savingsLineItem.Quantity = 1;
        savingsLineItem.TotalPrice = 100;
        savingsLineItem.Policy_Number__c='9051159122';
        insert savingsLineItem;
	}@IsTest
	public static void getRelatedPartiesDetails() {
	    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
         Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
         Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
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
			List<RelatedPartyAuthorityController.ACRWrapper> acwrappers = RelatedPartyAuthorityController.getRelatedPartiesDetails(opportunity.id);
			Test.stopTest();
           
			System.assertEquals(acwrappers.size(),2, 'assert failed');
		}
	}


@IsTest
public static void insertIntoProductContactRelationshipTest() {
    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
     Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
     Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
     Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
     List<RelatedPartyAuthorityController.ACRWrapper> acwrappers = RelatedPartyAuthorityController.getRelatedPartiesDetails(opportunity.id);
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
        ProductContactSignatoryRelationship__c obj = RelatedPartyAuthorityController.insertIntoProductContactRelationship(
            acwrappers.get(0)  
        ,mainacc.id,   
        opportunity.id,
        '',
        '2',
        'www');
        Test.stopTest();
   
        System.assert(obj != null, 'assert failed');
    }
}
@IsTest
public static void createProductContactRelation() {
    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
     Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
     Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
     Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
     List<RelatedPartyAuthorityController.ACRWrapper> acwrappers = RelatedPartyAuthorityController.getRelatedPartiesDetails(opportunity.id);
	String relatedauthdetails = JSON.serialize(new List<RelatedPartyAuthorityController.ACRWrapper>());
	
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
        string obj = RelatedPartyAuthorityController.createProductContactRelation(
			relatedauthdetails,
        opportunity.id,
        'MO',
        '6'
        );
        Test.stopTest();
	
        System.assert(obj != null, 'assert failed');
    }
}
@IsTest
public static void createRelatedPartiesAuth() {
    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
     Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
     Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
     Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
     List<RelatedPartyAuthorityController.ACRWrapper> acwrappers = RelatedPartyAuthorityController.getRelatedPartiesDetails(opportunity.id);
	String relatedauthdetails = JSON.serialize(acwrappers);
	
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
        string obj = RelatedPartyAuthorityController.createRelatedPartiesAuth(
			relatedauthdetails,
        opportunity.id,
        '',
            '4'
        );
        Test.stopTest();
	
        System.assert(obj != null, 'assert failed');
    }
}
    @IsTest
public static void checkifRelatioshipExist() {
    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
     Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
     Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
     Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
     List<RelatedPartyAuthorityController.ACRWrapper> acwrappers = RelatedPartyAuthorityController.getRelatedPartiesDetails(opportunity.id);
	String relatedauthdetails = JSON.serialize(new List<RelatedPartyAuthorityController.ACRWrapper>());
	
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
        string obj = RelatedPartyAuthorityController.checkifProductContactRelationshipExist(
			relatedPartyAccount1.id,
            mainacc.id,
        opportunity.id
        );
        Test.stopTest();
	
        System.assert(obj != null, 'assert failed');
    }
}

@IsTest
public static void updateProductContactRelationship() {
    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
     Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
   
     Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
     OpportunityLineItem lineitme = [SELECT Id, Product_Name__c FROM OpportunityLineItem WHERE opportunityid = :opportunity.id]; 
     List<RelatedPartyAuthorityController.ACRWrapper> acwrappers = RelatedPartyAuthorityController.getRelatedPartiesDetails(opportunity.id);
	String relatedauthdetails = JSON.serialize(new List<RelatedPartyAuthorityController.ACRWrapper>());
	

  

    ProductContactSignatoryRelationship__c productsignatoory = new ProductContactSignatoryRelationship__c();
		productsignatoory.PrimaryAccountId__c =  mainacc.id;
		productsignatoory.AccountContactRelationshipId__c = relatedPartyAccount1.id;
		productsignatoory.OpportunityProductId__c = lineitme.id;
		productsignatoory.Special_Instruction__c = '';
		productsignatoory.SigningAuthorityFromDate__c = Date.today();
		productsignatoory.Number_of_Signatories_for_account__c = '2';
		productsignatoory.Product_Name__c = lineitme.Product_Name__c;
		productsignatoory.Signing_Purpose__c = 'AccountMaintenance';
		productsignatoory.Signing_Instructions__c = 'Any "A" and one "B" to sign together';

			productsignatoory.Compulsory_Signature__c = 'Yes';
	insert  productsignatoory;
     
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
        ProductContactSignatoryRelationship__c obj = RelatedPartyAuthorityController.updateProductContactRelationship(
			relatedPartyAccount1.id,
            mainacc.id,
            lineitme.id,
        'TEST','2'
        );
        Test.stopTest();
	
        System.assert(obj != null, 'assert failed');
    }
}
}