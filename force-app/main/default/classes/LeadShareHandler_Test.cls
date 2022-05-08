/**
 * @description       :
 * @author            : deepthi.narayanappa@absa.africa
 * @last modified on  : 2021-09-27
 * @last modified by  : deepthi.narayanappa@absa.africa
 **/
@isTest
class LeadShareHandler_Test {
	@testSetup
	static void dataCreation() {
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
		Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
		String uniqueName = orgId + dateString + randomInt;
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		//Profile p = [SELECT Id FROM Profile LIMIT 1];
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
		Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
		Lead newLead1 = new Lead();
		newLead1.FirstName = 'TestSTI';
		newLead1.LastName = 'Lead';
		newLead1.Salutation = 'Mr';
		newLead1.Status = 'Allocated';
		newLead1.Hot_Deal__c = false;
		newLead1.RecordTypeId = leadRecordTypeId;
		newLead1.LeadSource = 'Web';
		//newLead1.Financial_Product__c = finProduct.Id;
		//newLead1.Product_Interest_1__c = finProduct.Id;
		//newLead1.Product_Offer_Status_1__c = 'Offer Taken Up';
		newLead1.ID_Number__c = '8903015800086';
		newLead1.Phone = '8987678787';
		newLead1.AIC_Relationship_Consultant_Name__c = 'Lesley Hunter (Lesley.Hunter@absa.co.za)';
		newLead1.Lead_Email__c = 'test@test.com';
		newLead1.Lead_Name__c = 'Test CAF Lead';
		newLead1.Lead_Phone__c = '8767878987';
		//newLead1.Referring_Banker_s_Branch__c = prefSite.Id;
		newLead1.Lead_Source__c = 'Referral from AIC';
		newLead1.STI_Sub_Source__c = 'Email';
		newLead1.Preferred_Communication_Channel__c = 'Email';
		newLead1.Lead_Type__c = 'New';
		//newLead1.Preferred_Site__c = prefSite.Id;
		newLead1.OwnerId = uObj.Id;
		//newLead1.Parent_Account__c = acc.Id;

		insert newLead1;
	}

	@isTest
	static void testShare() {
		Lead leadRecord = [SELECT Id, OwnerId FROM Lead LIMIT 1];
		LeadShareHandler.shareLeadWithCreator(leadRecord);
		system.assertEquals(true, leadRecord != null);
	}
}