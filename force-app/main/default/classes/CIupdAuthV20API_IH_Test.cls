/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-06
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class CIupdAuthV20API_IH_Test 
{
/** 
     * @description dataCreation
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
        
          Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        
        Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings',ProductCode='09050');
        insert savingsprod; 
        
        PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
        insert savingsPrice;
        
        /*Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
        salesProcess.Request_Name__c = 'CAF Application';
        salesProcess.Name = 'stokvel Application';
        salesProcess.Opportunity_Record_Type__c = 'CAF Application';
        insert salesProcess;*/
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
     @isTest static void ciauthRelateParties() 
    {     OpportunityLineItem opportunityline = [SELECT Id, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '9051159122']; 
        
        CIupdtAuthV20API_Req_IB_v1 requestBean = new CIupdtAuthV20API_Req_IB_v1();
		requestBean.inputHeaders = new CIupdtAuthV20API_Req_IB_v1.InputHeaders();
		requestBean.inputHeaders.NBSAPLI = new CIupdtAuthV20API_Req_IB_v1.NBSAPLI();

		requestBean.inputMessageHeader = new CIupdtAuthV20API_Req_IB_v1.InputMessageHeader();
		requestBean.inputMessageHeader.inputMessage = new CIupdtAuthV20API_Req_IB_v1.InputMessage();
		requestBean.CIupdAuthV20Request = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20Request();
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20RequestInputData();
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.primaryCifKey = 'was';

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.accountNumber = long.valueOf(opportunityline.Policy_Number__c);

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.siteCode = 8474;

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.tellerNumber = 878;
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.supervisorOverride = 0;
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.authType = 'M';

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.numberOfSignatories = '2';
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.specialConditions = '';
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.inputTableData = new List<CIupdtAuthV20API_Req_IB_v1.InputTableData>();

		requestBean.inputHeaders.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.inputHeaders.NBSAPLI.providerApplication = 'ASP';
		requestBean.inputHeaders.NBSAPLI.trace = 'N';

		requestBean.inputMessageHeader.inputMessage.messageLanguage = 'E';
		requestBean.inputMessageHeader.inputMessage.messageTarget = 'STD';
		//for (ACRWrapper acr : relatedauthdetails) {
			CIupdtAuthV20API_Req_IB_v1.InputTableData inputData = new CIupdtAuthV20API_Req_IB_v1.InputTableData();
			
				inputData.compulsorySignatory = 'Y';
			
			inputData.designation = 21;
			inputData.signatoryCifKey ='was2';
			inputData.updateOption = 'N';
			inputData.signatoryCasaNumber = 123456;
			requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.inputTableData.add(inputData);
		//}
        
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
        CIupdAuthV20API_Resp_IB_v1 obj = CIupdAuthV20API_IH_v1.ciauthRelateParties(
			requestBean
        );
        System.assert(obj != null, 'assert failed');
        Test.stopTest();
	
    }
    }

}