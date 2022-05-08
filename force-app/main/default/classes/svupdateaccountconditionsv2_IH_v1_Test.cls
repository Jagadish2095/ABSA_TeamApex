/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
*/


@istest
public class svupdateaccountconditionsv2_IH_v1_Test {
/**
 * @description       : 
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
     @isTest static void updateaccountCondition() 
    {     OpportunityLineItem opportunityline = [SELECT Id, Policy_Number__c FROM OpportunityLineItem WHERE Policy_Number__c = '9051159122']; 
         User userRec = [ SELECT ID ,Alias,	Email,sitecode__c,Teller_Operator_Code__c,UserName,	MobilePhone,SiteType__c from user WHERE Email= 'UserAdmin@testorg.com'];
       svupdateaccountconditionsv2_IB_Req_v1 requestBean = new svupdateaccountconditionsv2_IB_Req_v1();
		svupdateaccountconditionsv2_IB_Req_v1.NBSAPDPI NBSAPDPI = new svupdateaccountconditionsv2_IB_Req_v1.NBSAPDPI();
		svupdateaccountconditionsv2_IB_Req_v1.NBSAPLI NBSAPLI = new svupdateaccountconditionsv2_IB_Req_v1.NBSAPLI();
		NBSAPLI.application = 'SALEFORCE';
		NBSAPLI.channel = 'SALEFORCE';
		NBSAPLI.trace = 'N';
		NBSAPDPI.NBSAPLI = NBSAPLI;
		svupdateaccountconditionsv2_IB_Req_v1.MSGI MSGI = new svupdateaccountconditionsv2_IB_Req_v1.MSGI();
		svupdateaccountconditionsv2_IB_Req_v1.NBSMSGI NBSMSGI = new svupdateaccountconditionsv2_IB_Req_v1.NBSMSGI();
		NBSMSGI.messageLanguage = 'E';
		NBSMSGI.messageTarget = 'STD';
		MSGI.NBSMSGI = NBSMSGI;

		svupdateaccountconditionsv2_IB_Req_v1.SVSP05I SVSP05I = new svupdateaccountconditionsv2_IB_Req_v1.SVSP05I();
		svupdateaccountconditionsv2_IB_Req_v1.SVSP05I_INPUT_AREA SVSP05I_INPUT_AREA = new svupdateaccountconditionsv2_IB_Req_v1.SVSP05I_INPUT_AREA();

		SVSP05I_INPUT_AREA.accountNumber =  opportunityline.Policy_Number__c; // pass from front end
		SVSP05I_INPUT_AREA.savingsDepositType = 'D';
		SVSP05I_INPUT_AREA.parameterRetrieveType = ''; //"3",
		SVSP05I_INPUT_AREA.chargeIndicator = 'N';
		SVSP05I_INPUT_AREA.tableCount = 2;
		Date dateToday = Date.today();
		svupdateaccountconditionsv2_IB_Req_v1.UpdateTable updateTable = new svupdateaccountconditionsv2_IB_Req_v1.UpdateTable();
    List<svupdateaccountconditionsv2_IB_Req_v1.UpdateTable> updateTables = new List<svupdateaccountconditionsv2_IB_Req_v1.UpdateTable>();
		updateTable.parameterID = 'NIA';
		updateTable.conditionValue = '2';
		updateTable.capturedAmount = '0';
		updateTable.capturedAmountSign = '+';
		updateTable.capturedPercentageIndicator = 'N';
		updateTable.capturedRiskIndicator = 'H'; //supply risk
		updateTable.capturedDate = integer.valueOf(CVSServicesHelper.getDateForSalesforce(dateToday));
		updateTable.authourisationCode = '';
		updateTable.supervisor = 0;
     
     
     
		updateTables.add(updateTable);
		svupdateaccountconditionsv2_IB_Req_v1.UpdateTable updateTable1 = new svupdateaccountconditionsv2_IB_Req_v1.UpdateTable();
		updateTable1.parameterID = 'PER';
		updateTable1.conditionValue = '70'; // PASS VALUE FROM FRONT END
		updateTable1.capturedAmount = '0';
		updateTable1.capturedAmountSign = '+';
		updateTable1.capturedPercentageIndicator = 'N';
		updateTable1.capturedRiskIndicator = '';
		updateTable1.capturedDate = integer.valueOf(CVSServicesHelper.getDateForSalesforce(dateToday));
		updateTable1.authourisationCode = '';
		updateTable1.supervisor = 0;
		updateTables.add(updateTable1);
    
		SVSP05I_INPUT_AREA.divisionCode = ''; //pass correct value
		SVSP05I_INPUT_AREA.workStation = '';
		SVSP05I_INPUT_AREA.branchCode = Integer.valueOf(userRec.SiteCode__c);
		SVSP05I_INPUT_AREA.agencyCode = 0;
		SVSP05I_INPUT_AREA.agencySiteType = userRec.SiteType__c;
		SVSP05I_INPUT_AREA.tellerCode = Integer.valueOf(userRec.Teller_Operator_Code__c);
		SVSP05I_INPUT_AREA.supervisorCode = 0;
		SVSP05I_INPUT_AREA.branchSiteType = userRec.SiteType__c;
        SVSP05I.SVSP05I_INPUT_AREA = SVSP05I_INPUT_AREA;
     	SVSP05I.SVSP05I_INPUT_AREA.updateTable = updateTables;
		
		requestBean.SVSP05I = SVSP05I;
		requestBean.NBSAPDPI = NBSAPDPI;
		requestBean.MSGI = MSGI; 
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
        svupdateaccountconditionsv2_IB_Resp_v1 obj = svupdateaccountconditionsv2_IH_v1.updateaccountcondition(
			requestBean
        );
        System.assert(obj != null, 'assert failed');
        Test.stopTest();
	
    }
    }
}