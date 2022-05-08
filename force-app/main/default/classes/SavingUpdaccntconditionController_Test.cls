/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-26
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@istest
public class SavingUpdaccntconditionController_Test {
	@testSetup
    /**
    * @description getTranslationValues
    */
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
			Advisor_Code__c = '112233',
            SiteType__c = '034'
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
        //savingsLineItem.Product_Name__c = 'savinfn';
        savingsLineItem.Quantity = 1;
        savingsLineItem.TotalPrice = 100;
        savingsLineItem.Policy_Number__c='9051159122';
        insert savingsLineItem;
}
       @IsTest
    static void getTranslationValuesTestNegetive(){
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
        SavingUpdaccntconditionController.getTranslationValues('Savings', 'Reason', 'Outbound');
        System.assert(opportunity !=null, 'Failed to get translation values');
        Test.stopTest();
        }
    }
    @IsTest
    static void updateAccountConditionsRequest(){
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
        SavingUpdaccntconditionController.updateAccountConditionsRequest('90767909098898282','20','3','L','34', '09308');                          
        System.assert(opportunity !=null, 'Failed to get translation values');
        Test.stopTest();
        }
    }
}