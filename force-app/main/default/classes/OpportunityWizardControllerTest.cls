/**
* @description This is the Opportunity Wizard Lightning Component Apex controller test class
*
* @author   Nelson Chisoko (Dariel)
* @since    2019/02/07
*/

@IsTest
private class OpportunityWizardControllerTest {
    
    static String willDetailString = '{"Fault":null,"WithdrawUserId":0,"WithdrawnCode":"","WillStatus":"L","WillOrigin":"","WillNo":41000051513,"WillLegal":"","WillFiled":"N","WillError":"N","WhoDied":"","UsrId":"EXMW152","TrustIndicator":"N","TransactionSite":"3232","TrackerStatus":"A","TimeWithdrawn":"00:00:00","Testatrix":"","Testator":"","SubmitterTelno":"","SubmittedBy":"","statusCode":200,"status":"OK","StandAlone":"","SpecialistName":"","SpecialistCode":0,"SpecialBequestVal":0.0,"SalaryNo":0,"safeCustodyFee":"Y","RevisionDate":20190408,"RegistrationDate":0,"ReferalReason":"","ReasonWithdrawn":"","RCMessage":"TRANSACTION SUCCESSFUL","RC":"0","ProductType":"WILL","ProductStatus":"REVIS","PricingFlag":"N","PayDate":20190408,"OldWillNo":"","OldFilingNumber":"","NewAmendRevise":"R","moreInformation":null,"message":null,"LeadName":"","LeadCode":0,"LanguageCode":"","httpMessage":null,"httpCode":null,"FirstFileDate":0,"FillNo":"","FileSize":0,"FilePath":"","FileName":"","FileAction":"","FeePaid":"","ExecutorFeePlan":"","EmergencyWill":"N","EisDate":0,"EffectiveDate":20190329,"DraftingBranch":3232,"DomicileSite":3232,"DispatchDate":0,"DeliverMethod":"","DeceasedDate":0,"DateWithdrawn":0,"DateSigned":0,"DateReturned":0,"DateFiled":0,"Date1stScfLetter":0,"CurrentBalance":0.0,"CSASent":"","Correction":"N","CorpCode":"0","CIFKey":"APPLEH 002","CaseNo":0,"CasaNo":"2059636","CasaIndicator":"","CasaDate":20190408,"BrokerName":"MICHAEL STEFANUS ANTONIE ROSSOUW","BrokerCode":234523,"BranchCode":"3650","BigPrint":"","AmountDue":0.0,"AdvisorName":"MICHAEL STEFANUS ANTONIE ROSSOUW","AdvisorCode":234523,"AcknowledgeLetter":"N"}';
    static String willBankingDetailsString = '{"Fault":null,"BankingDetailsResponse":{"WillNo":"41000051513","SiteCode":"0","EffectiveDate":"20190408","ClientName":"HARRY APPLE","BranchName":"8443","BranchCode":"0","BankName":"ABSA ELECTRONIC SETTL (632005)","AccountType":"SAVINGS","AccountNumber":"9050331503","statusCode":200,"status":"OK","RCMessage":"","RC":"0","message":null},"BankingDetailsRequest":null}';
    static String willAssetsLiabilitiesString = '{"Fault":null,"WillNo":"41000051513","TaxTestatrix":0,"TaxTestator":0,"SuretyTestatrix":0,"SuretyTestator":0,"statusCode":200,"status":"OK","RCMessage":"","RC":0,"OverDraftTestatrix":0,"OverDraftTestator":0,"OutCededAssTestatrix":0,"OutCededAssTestator":0,"OtherLTestatrix":0,"OtherLTestator":0,"OtherAssTestatrix":0,"OtherAssTestator":24234,"MovAssetsTestatrix":0,"MovAssetsTestator":0,"MortgaugeTestatrix":0,"MortgaugeTestator":0,"MortgageAssTestatrix":0,"MortgageAssTestator":0,"MineralTestatrix":0,"MineralTestator":0,"message":null,"LoanLTestatrix":0,"LoanLTestator":0,"LiquidAssTestatrix":0,"LiquidAssTestator":0,"Liabilities":"Y","LiabilAmt":0,"FixedPropTestatrix":0,"FixedPropTestator":0,"FarmingTestatrix":0,"FarmingTestator":0,"CreditTestatrix":0,"CreditTestator":0,"BusIntTestatrix":0,"BusIntTestator":0,"Assurance":"N","AssetsPayTestatrix":0,"AssetsPayTestator":0,"Assets":"Y","AssetAmt":24234}';
    static ClientFinderProduct productData = new ClientFinderProduct('00000041000051513', 'REVIS', 'WILL');


    @isTest static void testGetOpportunityRecordTypesMap() {

        System.assert(!OpportunityWizardController.getOpportunityRecordTypesMap().isEmpty());

    }

    @isTest static void testGetSelectedOpportunityRecordTypeFields() {

        if (OpportunityWizardController.getOpportunityRecordTypesMap().keySet().contains('Wills')) {

            System.assert(!OpportunityWizardController.getSelectedOpportunityRecordTypeFields('Wills').isEmpty());

        }
    }

    @isTest static void testGetSelectedOpportunityRecordTypeId() {

        if (OpportunityWizardController.getOpportunityRecordTypesMap().keySet().contains('Wills')) {

            System.assertEquals(OpportunityWizardController.opportunityRecordTypesMap.get('Wills').getRecordTypeId(), OpportunityWizardController.getSelectedOpportunityRecordTypeId('Wills'));

        }
    }

    @isTest static void testDeleteOpportunity() {

        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        System.assert(testOpportunity != null, 'test Opportunity Id is null');
        OpportunityWizardController.deleteOpportunity(testOpportunity.Id);

    }

    @isTest static void testUpdateOpportunity() {

        Employee__c testEmployee = WillsTestDataFactory.createEmployee('Test', null, 'User', 'T', '9206146218096',
                'SA Identity Document', 'test@test.com', '0123456789', 'E00001', 'B00001', 'AB00001', 'A12345'
        );
        Site__c testSite = WillsTestDataFactory.createSite('Test', 'T00001');
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunityWithoutClient();
        Account testClient = WillsTestDataFactory.createAccount();
		System.assert(testClient != null, 'Account Id is null');

        //Id oppId, Account accountData, ClientFinderProduct productData, Id adviserId, Id siteId, String willDetailString, String willBankingDetailsString, String willAssetsLiabilitiesString, String willType
        OpportunityWizardController.updateOpportunity(testOpportunity.Id, testClient, productData, testEmployee.Id, testSite.Id, willDetailString, willBankingDetailsString, willAssetsLiabilitiesString, null);

        System.assertEquals(testClient.Id, new OpportunitiesSelector().selectByOpportunityId(testOpportunity.Id).get(0).AccountId);

    }

    @isTest static void testGetWillDetails() {
        
        Test.setMock(HttpCalloutMock.class, new GetWillDetailsMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_DETAILS});
        String result = OpportunityWizardController.getWillDetails(productData);

        System.assert(result != null);

    }

    @isTest static void testGetWillBankingDetails() {

        String result = OpportunityWizardController.getWillBankingDetails(productData);

        System.assert(result != null);

    }

    @isTest static void testGetWillAssetsLiabilities() {

        String result = OpportunityWizardController.getWillAssetsLiabilities(productData);

        System.assert(result != null);

    }
    
    @isTest static void testisVirtualAdvisorCase() {
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Client Review').getRecordTypeId();
		Case cObj = new Case();
        Date myDate = date.newInstance(2012, 5, 22);
        cObj.RecordTypeId = recTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c = '112233';
        cObj.Customer_ID__c = '1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c = 'Test Client';
        cObj.Last_Name__c = 'Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976';
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c = 'Test JKumar';
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c = '';
        cObj.Status = 'New';
        insert cObj;
        Account accObj2 = new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId = accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = accObj2.Id;
        insert oppsList;
        OpportunityWizardController.isVirtualAdvisorCase(cObj.Id);
		OpportunityWizardController.getAccountRecordId(cObj.Id);
        OpportunityWizardController.updateOppRecord(oppsList[0].Id,Userinfo.getUserId());
        System.assert(cObj != null);

    }

    @isTest static void testCreateClient() {
        Account temp = WillsTestDataFactory.createAccount();
        System.assert(temp != null, 'Account Id is null');
        Account testClient = temp.clone(false, false);
        delete temp;

        OpportunityWizardController.createClient(testClient);

        temp = WillsTestDataFactory.createAccount();
        testClient = temp.clone(false, false);
        testClient.ID_Number__pc = '9206215614086';
        delete temp;

        OpportunityWizardController.createClient(testClient);

        temp = WillsTestDataFactory.createAccount();
        testClient = temp.clone(false, false);
        testClient.ID_Number__pc = null;
        testClient.CIF__c = null;
        delete temp;

        OpportunityWizardController.createClient(testClient);
    }
}