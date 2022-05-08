/**
 * @description Test Class for AutoConvertClosedLead
 * @author  Koketso Mpshane
 * @date    09/04/2020
 */
@isTest
public class AutoConvertClosedLeadTest {
	/* @isTest
static void testAutoConvertClosedLead(){

Account acc = new Account(Name = 'testAccount');
insert acc;

Financial_Product__c finProduct = new Financial_Product__c();
finProduct.Name = 'test Product';
finProduct.Product_Type__c = 'Retail Banking';
finProduct.Business_Unit__c = 'Retail Banking';

insert finProduct;

RecordType retailRecodType = [Select Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' and DeveloperName = 'Retail_Sales_Lead'];

Lead leadRecord = new Lead();
leadRecord.FirstName = 'Test';
leadRecord.LastName = 'Lead';
leadRecord.Status = 'Allocated';
leadRecord.Hot_Deal__c = false;
leadRecord.RecordTypeId = retailRecodType.Id;
leadRecord.FinServ__RelatedAccount__c = acc.Id;
leadRecord.LeadSource = 'Web';
leadRecord.Financial_Product__c = finProduct.Id;
leadRecord.Product_Interest_1__c = finProduct.Id;
leadRecord.Product_Offer_Status_1__c = 'Offer Taken Up';

insert leadRecord;

leadRecord.Status = 'Working';
leadRecord.SubStatus__c = 'Handling';
update leadRecord;

//leadRecord.Status = 'Closed';
leadRecord.SubStatus__c = 'Offer Taken-up';
update leadRecord;

List<Id> leadIds = new List<Id>();
leadIds.add(leadRecord.Id);

Test.startTest();
AutoConvertClosedLead.convertLead(leadIds);
Test.stopTest();

}*/
	@isTest
	static void testAutoConvertClosedLeadSTI() {
		List<Id> personAccountIds = new List<Id>();
		personAccountIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId());
		personAccountIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId());

		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId();

		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		System.assertNotEquals(p, null);
		//Profile p = [SELECT Id FROM Profile LIMIT 1];

		Account acc = new Account();
		acc.FirstName = 'Test';
		acc.LastName = 'Tester';
		acc.CIF__c = '12345';
		acc.ID_Number__pc = '8903015800086';
		acc.RecordTypeId = personAccountRecordTypeId;
		insert acc; 

		Campaign campaign = new Campaign();
		campaign.Name = 'Test Campaign';
		insert campaign;

		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
		Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
		String uniqueName = orgId + dateString + randomInt;
		User uObj = new User();
		uObj.ProfileId = p.Id;
		uObj.LastName = 'JKumar';
		uObj.Email = 'testUser@gmail.com';
		uObj.Username = uniqueName + '@test' + orgId + '.org';
		uObj.CompanyName = 'TEST';
		uObj.Title = 'Mr.';
		uObj.EmailEncodingKey = 'ISO-8859-1';
		uObj.Alias = uniqueName.substring(18, 23);
		uObj.TimeZoneSidKey = 'America/Los_Angeles';
		uObj.LocaleSidKey = 'en_US';
		uObj.LanguageLocaleKey = 'en_US';
		uObj.Advisor_Code__c = '112233';
		insert uObj;

		Financial_Product__c finProduct = new Financial_Product__c();
		finProduct.Name = 'test Product';
		finProduct.Business_Unit__c = 'STI - CAF';

		insert finProduct;

		Id siteRecType = Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Branch_Site').getRecordTypeId();

		Site__c prefSite = new Site__c();
		prefSite.RecordTypeId = siteRecType;
		prefSite.Name = 'Western Cape';
		prefSite.Site_Code__c = '7456';

		insert prefSite;

		Id STIRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('STI_Lead').getRecordTypeId();
		System.assertNotEquals(STIRecType, null);
		Lead newLead1 = new Lead();
		newLead1.DD_Initials__c = 'MK';
		newLead1.DD_Marital_Status__c = 'Married';
		newLead1.DD_Gender__c = 'Female';
		newLead1.FirstName = 'Test';
		newLead1.LastName = 'Lead';
		newLead1.Salutation = 'Mr';
		newLead1.Status = 'Allocated';
		newLead1.Hot_Deal__c = false;
		newLead1.RecordTypeId = STIRecType;
		newLead1.LeadSource = 'Web';
		newLead1.Financial_Product__c = finProduct.Id;
		newLead1.Product_Interest_1__c = finProduct.Id;
		newLead1.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead1.ID_Number__c = '8903015800086';
		newLead1.Phone = '8987678787';
		newLead1.AIC_Relationship_Consultant_Name__c = 'Lesley Hunter (Lesley.Hunter@absa.co.za)';
		newLead1.Lead_Email__c = 'test@test.com';
		newLead1.Lead_Name__c = 'Test CAF Lead';
		newLead1.Lead_Phone__c = '8767878987';
		newLead1.Referring_Banker_s_Branch__c = prefSite.Id;
		newLead1.Lead_Source__c = 'Referral from AIC';
		newLead1.STI_Sub_Source__c = 'Email';
		newLead1.Preferred_Communication_Channel__c = 'Email';
		newLead1.Lead_Type__c = 'New';
		newLead1.Preferred_Site__c = prefSite.Id;
		newLead1.OwnerId = uObj.Id;
		newLead1.Parent_Account__c = acc.Id;

		insert newLead1;

		CampaignMember campaignMemberLead1 = new CampaignMember();
		campaignMemberLead1.LeadId = newLead1.Id;
		campaignMemberLead1.CampaignId = campaign.Id;
		insert campaignMemberLead1;

		List<Id> leadIds1 = new List<Id>();

		leadIds1.add(newLead1.Id);

		Lead crSTILead = [
			SELECT
				id,
				Preferred_Communication_Channel__c,
				DD_Initials__c,
				DD_Date_of_Birth__c,
				FirstName,
				LastName,
				DD_Marital_Status__c,
				DD_Gender__c,
				ID_Type__c,
				Salutation,
				DD_Source_of_Funds__c,
				DD_Source_of_Income__c
			FROM Lead
			LIMIT 1
		];
		Account accSTI = [
			SELECT
				id,
				Preferred_Communication_Method__pc,
				Initials__pc,
				PersonBirthdate,
				FirstName,
				LastName,
				Marital_Status__pc,
				Gender__pc,
				ID_Type__pc,
				Salutation,
				DD_Source_of_Funds__pc,
				Income_Source__pc,
				RecordTypeId
			FROM Account
			LIMIT 1
		];
		Test.startTest();
		//AutoConvertClosedLead.updateExistingAccountDetails(accSTI,crSTILead,personAccountIds);
		AutoConvertClosedLead.convertLead(leadIds1);

		Test.stopTest();
	}
	@isTest
	static void testAutoConvertClosedLeadDirectDelivery() {
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId();

		Account acc = new Account();
		acc.FirstName = 'Test';
		acc.LastName = 'Tester';
		acc.CIF__c = '12345';
		acc.ID_Number__pc = '8903015800086';
		acc.RecordTypeId = personAccountRecordTypeId;
		insert acc;

		Campaign campaign = new Campaign();
		campaign.Name = 'Test Campaign';
		insert campaign;

		Financial_Product__c finProduct = new Financial_Product__c();
		finProduct.Name = 'test Product';
		finProduct.Product_Type__c = 'Retail Banking';
		finProduct.Business_Unit__c = 'Retail Banking';

		insert finProduct;

		Id directDeliveryRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
		Id directDeliverySTIRecType;

		if (Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DD_STI_Lead') != null)
			directDeliverySTIRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DD_STI_Lead').getRecordTypeId();

		Lead newLead1 = new Lead();
		newLead1.FirstName = 'Test';
		newLead1.LastName = 'Lead';
		newLead1.Status = 'Allocated';
		newLead1.Hot_Deal__c = false;
		newLead1.RecordTypeId = directDeliveryRecType;
		newLead1.LeadSource = 'Web';
		newLead1.Financial_Product__c = finProduct.Id;
		newLead1.Product_Interest_1__c = finProduct.Id;
		newLead1.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead1.ID_Number__c = '8903015800086';
		newLead1.Preferred_Communication_Channel__c = 'Email';
		newLead1.DD_Initials__c = 'S';
		newLead1.DD_Date_of_Birth__c = System.today();

		Lead newLead2 = new Lead();
		newLead2.FirstName = 'Test';
		newLead2.LastName = 'Lead';
		newLead2.Status = 'Allocated';
		newLead2.Hot_Deal__c = false;
		newLead2.RecordTypeId = directDeliveryRecType;
		newLead2.LeadSource = 'Web';
		newLead2.Financial_Product__c = finProduct.Id;
		newLead2.Product_Interest_1__c = finProduct.Id;
		newLead2.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead2.Preferred_Communication_Channel__c = 'Email';
		newLead2.DD_Initials__c = 'S';
		newLead2.DD_Date_of_Birth__c = System.today();

		Lead newLead3 = new Lead();
		newLead3.FirstName = 'Test';
		newLead3.LastName = 'Lead';
		newLead3.Status = 'Allocated';
		newLead3.Hot_Deal__c = false;
		newLead3.RecordTypeId = directDeliveryRecType;
		newLead3.LeadSource = 'Web';
		newLead3.Financial_Product__c = finProduct.Id;
		newLead3.Product_Interest_1__c = finProduct.Id;
		newLead3.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead3.CIF__c = '12345';

		Lead newLead4 = new Lead();
		newLead4.FirstName = 'Test';
		newLead4.LastName = 'Lead';
		newLead4.Status = 'Allocated';
		newLead4.Hot_Deal__c = false;
		newLead4.LeadSource = 'Web';
		newLead4.Financial_Product__c = finProduct.Id;
		newLead4.Product_Interest_1__c = finProduct.Id;
		newLead4.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead4.CIF__c = '12345';
		newLead4.Preferred_Communication_Channel__c = 'SMS';
		newLead4.DD_Initials__c = 'S';
		newLead4.DD_Date_of_Birth__c = System.today();
		newLead4.DD_Marital_Status__c = 'Single';
		newLead4.DD_Gender__c = 'Female';
		newLead4.Salutation = 'Mr.';
		newLead4.DD_Source_of_Funds__c = 'Bonus';
		newLead4.DD_Source_of_Income__c = 'Bonus';

		if (String.isNotBlank(directDeliverySTIRecType))
			newLead4.RecordTypeId = directDeliverySTIRecType;

		insert newLead1;
		insert newLead2;
		insert newLead3;
		insert newLead4;

		CampaignMember campaignMemberLead1 = new CampaignMember();
		campaignMemberLead1.LeadId = newLead1.Id;
		campaignMemberLead1.CampaignId = campaign.Id;
		insert campaignMemberLead1;

		List<Id> leadIds1 = new List<Id>();
		List<Id> leadIds2 = new List<Id>();
		List<Id> leadIds3 = new List<Id>();
		List<Id> leadIds4 = new List<Id>();

		leadIds1.add(newLead1.Id);
		leadIds2.add(newLead2.Id);
		leadIds3.add(newLead3.Id);
		leadIds4.add(newLead4.Id);

		Test.startTest();
		AutoConvertClosedLead.convertLead(leadIds1);
		AutoConvertClosedLead.convertLead(leadIds2);
		AutoConvertClosedLead.convertLead(leadIds3);
		AutoConvertClosedLead.convertLead(leadIds4);
		Test.stopTest();

		Lead convertedLead1 = [SELECT ConvertedAccountId, IsConverted, ConvertedOpportunityId FROM Lead WHERE Id = :newLead1.Id];
		Lead convertedLead2 = [SELECT ConvertedAccountId FROM Lead WHERE Id = :newLead2.Id];
		Lead convertedLead3 = [SELECT ConvertedAccountId FROM Lead WHERE Id = :newLead3.Id];
		Lead convertedLead4 = [SELECT ConvertedAccountId FROM Lead WHERE Id = :newLead4.Id];

		//Check that the lead has been converted
		System.assertEquals(true, convertedLead1.IsConverted);

		//Check that an opportunity has been created
		System.assert(convertedLead1.ConvertedOpportunityId != null);

		//Check that no new account is created, instead it was merged with existing account
		//System.assert(convertedLead1.ConvertedAccountId == acc.Id);

		//Check that a new account was created for lead not matching existing account
		System.assert(convertedLead2.ConvertedAccountId != acc.Id);

		//Check that a new account was created for lead matching existing account
		System.assert(convertedLead3.ConvertedAccountId == acc.Id);

		//Check that a new account was created for lead matching existing account
		System.assert(convertedLead4.ConvertedAccountId == acc.Id);
	}

	@IsTest
	static void testFailedConvertingLead() {
		Id directDeliveryRecType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
		Financial_Product__c finProduct = new Financial_Product__c();
		finProduct.Name = 'test Product';
		finProduct.Product_Type__c = 'Retail Banking';
		finProduct.Business_Unit__c = 'Retail Banking';

		insert finProduct;

		Lead newLead3 = new Lead();
		newLead3.FirstName = 'Test';
		newLead3.LastName = 'Lead';
		newLead3.Status = 'Allocated';
		newLead3.Hot_Deal__c = false;
		newLead3.RecordTypeId = directDeliveryRecType;
		newLead3.LeadSource = 'Web';
		newLead3.Financial_Product__c = finProduct.Id;
		newLead3.Product_Interest_1__c = finProduct.Id;
		newLead3.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead3.ID_Number__c = '8754125963589';
		//newLead3.ID_Type__c = 'SA Identity Document';
		newLead3.ID_Type__c = 'Passport';

		insert newLead3;

		List<Id> leadIds3 = new List<Id>();
		leadIds3.add(newLead3.Id);

		Test.startTest();
		AutoConvertClosedLead.throwError = true;
		try {
			AutoConvertClosedLead.convertLead(leadIds3);
		} catch (Exception e) {
			System.assert(e.getMessage() != null);
		}
		Test.stopTest();
	}
    
    /* @isTest
static void testAutoConvertClosedLead(){

Account acc = new Account(Name = 'testAccount');
insert acc;

Financial_Product__c finProduct = new Financial_Product__c();
finProduct.Name = 'test Product';
finProduct.Product_Type__c = 'Retail Banking';
finProduct.Business_Unit__c = 'Retail Banking';

insert finProduct;

RecordType retailRecodType = [Select Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' and DeveloperName = 'Retail_Sales_Lead'];

Lead leadRecord = new Lead();
leadRecord.FirstName = 'Test';
leadRecord.LastName = 'Lead';
leadRecord.Status = 'Allocated';
leadRecord.Hot_Deal__c = false;
leadRecord.RecordTypeId = retailRecodType.Id;
leadRecord.FinServ__RelatedAccount__c = acc.Id;
leadRecord.LeadSource = 'Web';
leadRecord.Financial_Product__c = finProduct.Id;
leadRecord.Product_Interest_1__c = finProduct.Id;
leadRecord.Product_Offer_Status_1__c = 'Offer Taken Up';

insert leadRecord;

leadRecord.Status = 'Working';
leadRecord.SubStatus__c = 'Handling';
update leadRecord;

//leadRecord.Status = 'Closed';
leadRecord.SubStatus__c = 'Offer Taken-up';
update leadRecord;

List<Id> leadIds = new List<Id>();
leadIds.add(leadRecord.Id);

Test.startTest();
AutoConvertClosedLead.convertLead(leadIds);
Test.stopTest();

}*/
   
    
}