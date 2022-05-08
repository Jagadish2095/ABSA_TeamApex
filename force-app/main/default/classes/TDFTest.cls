/**
 * @description       :
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-06-29
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-06-29   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class TDFTest {
	@testSetup
	static void dataCreation() {
		User u = UserTDF.addUser('System Administrator (Custom)', 'UserAdmin', 'UserAdmin@testorg.com');
		System.runAs(u) {
			Account addClient = AccountTDF.addClient('Private Company', 'Client Private Company');
			Account addIndustriesBusiness = AccountTDF.addIndustriesBusiness('Individual', 'IndustiresBusiness Individual');
			Account addProspect = AccountTDF.addProspect('Private Company', 'Prospect Private Company');
			Account addIndustriesHousehold = AccountTDF.addIndustriesHousehold('Individual', 'IndustriesHousehold Individual');
			Account addIndustriesIndividual = AccountTDF.addIndustriesIndividual('Individual', 'IndustriesIndividual Individual');
			Account addIndividualClient = AccountTDF.addIndividualClient('Individual', 'IndividualClient Individual');
			Account addIndividualProspect = AccountTDF.addIndividualProspect('Individual', 'IndividualProspect Individual');
			Account addIndustriesInstitution = AccountTDF.addIndustriesInstitution('Individual', 'IndustriesInstitution Individual');

			Date closeDate = Date.today();
			String stage = 'New';
			Account vaAccount = AccountTDF.addIndividualClient('Individual', 'vcAccount');
			vaAccount.PersonBirthdate = closeDate.addYears(-35);
			update vaAccount;

			Opportunity addCAFOpp = OpportunityTDF.addCAFOpp('getCAFOpp', stage, closeDate, addClient.Id);
			Opportunity addCPFOpp = OpportunityTDF.addCPFOpp('getCPFOpp', stage, closeDate, addClient.Id);
			Opportunity addCreditMaintenanceOpp = OpportunityTDF.addCreditMaintenanceOpp('getCreditMaintenanceOpp', stage, closeDate, addClient.Id);
			Opportunity addCreditOnboardingOpp = OpportunityTDF.addCreditOnboardingOpp('getCreditOnboardingOpp', stage, closeDate, addClient.Id);
			Opportunity addCustomerRemediationOpp = OpportunityTDF.addCustomerRemediationOpp('getCustomerRemediationOpp', stage, closeDate, addClient.Id);
			Opportunity addDDSalesOpp = OpportunityTDF.addDDSalesOpp('getDDSalesOpp', stage, closeDate, addClient.Id);
			Opportunity addGeneralOpp = OpportunityTDF.addGeneralOpp('getGeneralOpp', stage, closeDate, addClient.Id);
			Opportunity addMerchantOnboardingOpp = OpportunityTDF.addMerchantOnboardingOpp('getMerchantOnboardingOpp', stage, closeDate, addClient.Id);
			Opportunity addBusinessBankOpp = OpportunityTDF.addBusinessBankOpp('getBusinessBankOpp', stage, closeDate, addClient.Id);
			Opportunity addStandardOpp = OpportunityTDF.addStandardOpp('getStandardOpp', stage, closeDate, addClient.Id);
			Opportunity addPhysicalChannelsOpp = OpportunityTDF.addPhysicalChannelsOpp('getPhysicalChannelsOpp', stage, closeDate, addClient.Id);
			Opportunity addProductOnboardingOpp = OpportunityTDF.addProductOnboardingOpp('getProductOnboardingOpp', stage, closeDate, addClient.Id);
			Opportunity addRetailOpp = OpportunityTDF.addRetailOpp('getRetailOpp', stage, closeDate, addClient.Id);
			Opportunity addRetirementPlanningOpp = OpportunityTDF.addRetirementPlanningOpp('getRetirementPlanningOpp', stage, closeDate, addClient.Id);
			Opportunity addSPMOnboardingOpp = OpportunityTDF.addSPMOnboardingOpp('getSPMOnboardingOpp', stage, closeDate, addClient.Id);
			Opportunity addSTIOpp = OpportunityTDF.addSTIOpp('getSTIOpp', stage, closeDate, addClient.Id);
			Opportunity addStokvelOpp = OpportunityTDF.addStokvelOpp('getStokvelOpp', stage, closeDate, addClient.Id);
			Opportunity addSuretyOnboardingOpp = OpportunityTDF.addSuretyOnboardingOpp('getSuretyOnboardingOpp', stage, closeDate, addClient.Id);
			Opportunity addVirtualAdvisorOpp = OpportunityTDF.addVirtualAdvisorOpp('getVirtualAdvisorOpp', stage, closeDate, vaAccount.Id);
			Opportunity addWalletShareOpp = OpportunityTDF.addWalletShareOpp('getWalletShareOpp', stage, closeDate, addClient.Id);
			Opportunity addWillsOpp = OpportunityTDF.addWillsOpp('getWillsOpp', stage, closeDate, addClient.Id);

			Application__c addMerchantOnboardingApp = ApplicationTDF.addMerchantOnboardingApp(addMerchantOnboardingOpp.Id);
			Application__c addOnboardingApp = ApplicationTDF.addOnboardingApp(addCreditOnboardingOpp.Id);
			Application__c addWillsApp = ApplicationTDF.addWillsApp(addWillsOpp.Id);
		}
	}
	@isTest
	public static void test1() {
		User uA = new User();
		String email = 'UserAdmin@testorg.com';
		uA = UserTDF.getUser(email);
		System.assertEquals('useradmin@testorg.com', uA.Email, 'Wrong user');
		System.runAs(uA) {
			Account acc = [SELECT Id, Client_Type__c, Name FROM Account WHERE Name = 'Client Private Company'];
			System.assertEquals('Client Private Company', acc.Name, 'acc Failed');
			System.debug('----- test1 acc -' + acc);
		}
	}
}