/** 
    * @description get TestCafApplication
    * @author: 
    
    */ 
@isTest
public class TestCafApplication {
/** 
    * @description get TestCafApplication
    * @author:  
    
    */
    @isTest
    static void getAndCreateNewApplicationsTest(){

        Product2 prod = new Product2(Name = 'CAF', Family = 'Cheque', ProductCode = '11021', Scheme_Code__c = '1', Product_Classification__c = 'Value Added Service');
        insert prod; 

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = 'MSA 002';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;



        Account accDealer = new Account(Name = 'XXX Vihecle Dealer');
        accDealer.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        accDealer.Country_of_Incorporation__c='South Africa';
        accDealer.Countries_Traded_With__c = 'South Africa';
        account.Client_Group__c = 'Individual';
        accDealer.Type = 'Dealer';
        accDealer.Phone = '0126117000';
        accDealer.Dealer_Code__c = 'WSD2020';
        insert accDealer;

        Opportunity opp = new Opportunity();
        opp.Name = account.Name + 'CAF';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Sanctioner_work_queue_regions__c = 'SME Gauteng South';
        opp.AccountId = account.Id;
        insert opp;

        Application_Product_CAF__c cafApp 	= new Application_Product_CAF__c();
        cafApp.VAT_Pay_Back__c 				= 'MONTH 3';
        cafApp.Client_Details__c 			= opp.AccountId;
        insert cafApp;

        OpportunityLineItem oppProduct 			= new OpportunityLineItem();
        oppProduct.OpportunityId 				= opp.Id;
        oppProduct.Application_Product_CAF__c 	= cafApp.Id;
        oppProduct.Quantity 					= 1;
        oppProduct.TotalPrice 					= 1;
        oppProduct.Type__c 						= 'CAF';
        oppProduct.PricebookEntryId 			= customPrice.Id;
        insert oppProduct;

        OpportunityLineItem extra = new OpportunityLineItem();
        extra.OpportunityId 						= opp.Id;
        extra.Parent_Opportunity_Line_Item_Id__c 	= oppProduct.Id;
        extra.Type_Extra__c 						= 'CD PLAYER';
        extra.Additional_Fee_Amount__c 				= '560';
        extra.Quantity 								= 1;
        extra.TotalPrice 							= 1;
        extra.PricebookEntryId 						= customPrice.Id;
        extra.Type__c 								= 'Extras';
        insert extra;
        
        Case fulfilmentcase = new Case();
        fulfilmentcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
        fulfilmentcase.Status ='Review Context';
        fulfilmentCase.Opportunity__c = opp.Id;
        fulfilmentCase.Product__c ='CAF';
        fulfilmentCase.Subject='CAF Case';
        fulfilmentcase.Relationship_Banker__c = opp.OwnerId;
        fulfilmentcase.AccountId = opp.AccountId;
        fulfilmentCase.Type ='CAF Fulfilment';
        fulfilmentCase.Application_Product_Id__c = cafApp.Id ;
        fulfilmentCase.External_Reference_Type__c = 'BCMS';
        fulfilmentCase.External_Reference_Number__c  = 'sdfarefdfdfd';
        fulfilmentCase.Application_Number__c = cafApp.Name;
        fulfilmentCase.CAF_Application_Number__c = cafApp.Name;
        insert fulfilmentCase;
         
        cafApp.Case__c = fulfilmentCase.Id;
        update cafApp;
        
        Test.startTest();
        cafApplicationController.getApplications(opp.Id);
        String createNewAppResult = cafApplicationController.createNewApplication(opp.Id);
        cafApplicationController.getApplicationToEdit(cafApp.Id);
        System.assertEquals(createNewAppResult, 'CAF Application created successful');
        cafApplicationController.getApplicationId(fulfilmentCase.Id);
        cafApplicationController.updateCaseStatus(cafApp.Id);
        cafApplicationController.updateOpportunityStage(opp.Id, 'Review Context');
        String contractExtrasResult = cafApplicationController.addContractExtras(opp.Id,oppProduct.Id,'CD PLAYER','BLUETOOTH','1500');
        System.assertEquals('Extras Added', contractExtrasResult);
        List<OpportunityLineItem> extras  	= cafApplicationController.getContractExtras(opp.Id, oppProduct.Id);
        OpportunityLineItem oneExtra  		= cafApplicationController.getContractExtraToEdit(extra.Id);
        String updateContractExtrasResult = cafApplicationController.updateContractExtras(extra.Id,'CD PLAYER','1500');
        System.assertEquals(updateContractExtrasResult, 'Extras Updated');
        String deteleOpplineItemResult = cafApplicationController.deteleOpplineItem(extra.Id);
        System.assertEquals(deteleOpplineItemResult, 'Extras Deleted');

        String addVAPResult = cafApplicationController.addVAP(opp.Id,oppProduct.Id,'SSAk','10022','Absa insure','4','35', '950',oppProduct.Id);
        System.assertEquals(addVAPResult, 'VAP added');
        List<OpportunityLineItem> vaps  = cafApplicationController.getVAPs(opp.Id, oppProduct.Id);
        //OpportunityLineItem oneVap  	= cafApplicationController.getVAP2Edit(extras[0].Id);
        String updateVAPResult = cafApplicationController.updateVAP(opp.Id,vaps[0].Id,'ASAk','12022','Absa insure','8','45', '1050',oppProduct.Id);
        System.assertEquals(updateVAPResult, 'VAP Updated');
        List<Account> accDealers = cafApplicationController.getDealers();
        cafApplicationController.getDealer(accDealers[0].Id);
        cafApplicationController.queryAccountData(accDealers[0].Id);
        cafApplicationController.getVAP2Edit(opp.Id);
        cafApplicationController.duplicateApplication(cafApp.Id, opp.Id, true, true, true, true, true, true, true, true, true, true, true, '1');

        String submitForApprovalResult = cafApplicationController.submitForApproval(opp.Id, opp.Sanctioner_work_queue_regions__c, 'Submitted for approval');
        String accAndOpp 				= cafApplicationController.getAccAndOpp(opp.Id);
        //System.assertEquals(submitForApprovalResult, 'Sent for approval!');
         List<Product2> product2 = cafApplicationController.getVAPsProduct2();
		
        Test.stopTest();
    }

    /** 
    * @description get testGetMultipleSelectOptions
    * @author: PJAIN: 20210119
    
    */
    @isTest
    static void testGetMultipleSelectOptions() {
        List<String> fieldList = new List<String>{'Account.Type'};
        Map<String, List<CustomSelectOptions>> testMap = cafApplicationController.getMultipleSelectOptions(fieldList);
        System.assertNotEquals(null, testMap.get('Account.Type'));
    }
}