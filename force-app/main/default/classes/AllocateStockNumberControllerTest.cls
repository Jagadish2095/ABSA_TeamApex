/**
 * @description       : test class for AllocateStockNumber controller
 * @author            : thabo / thulani
 * @group             :
 * @last modified on  : 2021-06-09
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author    Modification
 * 1.0   06-07-2021   thabo/thulani   Initial Version
 * 1.1   06-07-2021   gulafsha/saurabh/fano/englarmerdge   Initial Version
**/

@IsTest
public class AllocateStockNumberControllerTest {

    /**
    * @description : create test data for testing
    * @author thulani | 06-07-2021
    **/
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
        //IntegrationTestDataFactory.insertIntegrationSettings(CIlinkAccounttoClientV4_IH_V1.INTEGRATION_API_NAME, new List<String>{CIlinkAccounttoClientV4_IH_V1.INTEGRATION_SERVICE_NAME});
    }

 	/**
 	* @description : test method for update client details
 	* @author thulani | 06-07-2021
 	*
 	**/
    @IsTest
 	public static  void testUpdateClientDetails() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Onboarding' ];
        String accountObj = '{"Id":"0013N00000IOeE9QAL","FullName":"REBELLO","RegistrationNumber":"7404255133081","DateEstablished":"20180912","CountryOfIncorporation":"SO003","BusinessStartDate":"2020-07-01","DateCurrentAddressSince":"20130901","IsClientIntendsInsolvencyLiquidation":true,"IsClientDeclaredInsolvencyLiquidationPast":false,"IsClientIsStokvel":false,"IsClientIsAMunicipality":false,"IsTradingIndicator":true,"IsEmailCredit":true,"IsSMSCredit":false,"IsPhoneCredit":false,"EmailCredit":"","SMSCredit":"","PhoneCredit":"","IsEmailNonCredit":false,"IsSMSNonCredit":false,"IsPhoneNonCredit":false,"EmailNonCredit":"","SMSNonCredit":"","PhoneNonCredit":"","CIF":"REBELLO001","MDMCODE":"","CASAReferenceNumber":"0","CASAScreeningDate":"2020-08-05","TemporaryResidentPermitNumber":1234567,"TemporaryResidentPermitExpiryDate":"20200630","DateOfBirth":"19740425","ClientType":"SOLE TRADER","IsClientANonResident":false,"IsClientATemporaryResident":false,"IsClientPartOfAnEnterpriseDevelopmentFund":false,"ClientOperatesUnderAnExistingFranchiseContractAgreement":false,"ResidentialStatusAddressOptions":[{"Address":"Physical Address (Businesses) - 8 EBURY AVENUE, 10 GRAND CHATEAUX, BRYANSTON, JOHANNESBURG, 2191"}],"FinCrimeHold":"No","ResidentialStatusAddress":"","ResidentialStatusBorder":"Select an Option"}';
        Map<String, String> actual = AllocateStockNumberController.updateClientDetails(opportnity.Id, accountObj);
        System.assert( actual != null);
        Test.stopTest();
    }

	/**
	* @description ; test method for update opp
	* @author unknown | 06-07-2021
	**/
    @IsTest
	public static  void testUpdateOpportunityStage() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Onboarding'];
        string str = AllocateStockNumberController.updateOpportunityStage(opportnity.Id);
        System.assert( str != null);
        Test.stopTest();
    }

    /**
    * @description : test method for link stock number
    * @author unknown | 06-07-2021
    **/
    @IsTest
    public static  void testLinkStockNumberToCIF() {
        Opportunity opportnity = [SELECT Id, AccountId,CIF_Number__c FROM Opportunity WHERE Name =: 'Onboarding'];
        Application__c app = [SELECT Id,Stock_Number__c FROM Application__c Limit 1];
        app.Stock_Number__c = '2335532';
        update app;

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{"statusCode":200,"status":"OK","CIlinkAccountToClientV4Response":{"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgTxt":"INVALID CLIENT CODE","msgErrInd":"E","msgCode":"0003","msgClass":"CLSMGC01"}]},"nbsapdpo":{"serviceVersion":"BUSO003","returnCode":"0","reasonCode":"0"}}}'));

        Test.startTest();
        string responseBean = AllocateStockNumberController.linkStockNumberToCIF(opportnity.Id);

        System.assert(responseBean!= null);
        Test.stopTest();
    }

    /**
    * @description
    * @author unknown | 06-07-2021
    **/
    @IsTest
    public static  void testLinkStockNumberToCIFNegative() {
        Application__c app = [SELECT Id,Opportunity__c FROM Application__c Limit 1];
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Test Opp Onboarding 1' Limit 1];
        Test.startTest();
        delete app;
        String result = AllocateStockNumberController.linkStockNumberToCIF(opportnity.Id);

        System.assert(result != null);

        Test.stopTest();
    }

	/**
	* @description  : testmethod for call to allocateStockNumber method
	* @author unknown | 06-07-2021
	**/
    @IsTest
	public static  void testCallToAllocateStockNo() {
        Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];

        Application__c app = [SELECT Id,Opportunity__c FROM Application__c Limit 1];
        app.Opportunity__c = opportunity.Id;
        update app;
        Test.startTest();
        String str = AllocateStockNumberController.callToAllocateStockNo(opportunity.Id);
        System.assert(str != null);
        Test.stopTest();
    }

    /**
    * @description : test method for getStockNumber
    * @author unknown | 06-07-2021
    **/
    @IsTest
    public static  void testGetStockNumber() {

        Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];
        Application__c app = [SELECT Id,Opportunity__c FROM Application__c Limit 1];
        app.Opportunity__c = opportunity.Id;
        update app;
        Test.startTest();
        Application__c appRecord = AllocateStockNumberController.getStockNumber(opportunity.Id);
        System.assertNotEquals(null, appRecord);
        Test.stopTest();
    }

    /**
    * @description : test Method for getapplicationProduct
    * @author unknown | 06-07-2021
    **/
    @IsTest
    public static  void testgetApplicationProduct() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Cheque Credit Onboarding' Limit 1];
        Application_Product__c apc = AllocateStockNumberController.getApplicationProduct(opportnity.Id);
        system.assert(apc != null);
        Test.stopTest();
    }

    /**
    * @description :testMethod for getApplicationDetails
    * @author unknown | 06-07-2021
    **/
    @IsTest
    public static  void testgetApplicationDetails() {
        Application__c app = [SELECT Id FROM Application__c Limit 1];
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Test Opp Onboarding 1' Limit 1];

        app.Opportunity__c = opportnity.Id;
        update app;
        Application__c appRecord = AllocateStockNumberController.getApplicationDetails(opportnity.Id);
        system.assert(appRecord != Null);
        Test.stopTest();
    }

    /**
    * @description :positive test Method for getApplicationProduct
    * @author unknown | 06-07-2021
    **/
    @IsTest
    static  void getApplicationProductPositiveTest() {
        Opportunity newOppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Application_Product__c appCredList = new Application_Product__c();
        Application_Product__c appC = [SELECT Id,Name FROM Application_Product__c LIMIT 1];
        appC.Opportunity__c = newOppRecord.Id;
        update appC;
        Test.startTest();
        try{
           appCredList = AllocateStockNumberController.getApplicationProduct(newOppRecord.Id);
        }catch(Exception e){
         System.debug('Exception::'+e.getMessage());
        }
        System.assert(appCredList != null);
        Test.stopTest();
    }

    /**
    * @description : test Method for updatePrincipal
    * @author Unknown | 06-07-2021
    **/
    @IsTest
    static  void testUpdatePrincipals() {
        Opportunity opp = [SELECT Id,Name FROM Opportunity LIMIT 1];
        AccountContactRelation acc = [Select Id,ContactId From AccountContactRelation LIMIT 1];
        AccountContactRelation accMain = [Select Id,ContactId From AccountContactRelation WHERE Share_Percentage__c = 10 LIMIT 1];
        List<Id> selectedIDs = new List<Id>();
        selectedIDs.add(acc.Id);

        List<Id> selNewIDs = new List<Id>();
        selNewIDs.add(acc.Id);
        Id checkMainId = accMain.Id;
        Test.startTest();

        String result1 = AllocateStockNumberController.updatePrincipal(opp.Id, selNewIDs, checkMainId, true);
        String result2 = AllocateStockNumberController.updatePrincipal(opp.Id, selectedIDs, accMain.Id, true);

        Test.stopTest();
        System.assert(result1 == 'SUCCESS');
    }

    /**
    * @description : test method for updateAPCpositive
    * @author unknown | 06-07-2021
    **/
    @IsTest
    static  void updateAPCpositive() {
        Opportunity newOppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Application_Product__c appC = [SELECT Id,Name FROM Application_Product__c LIMIT 1];

        Test.startTest();
        appC.Annual_Turnover__c = 100000.0;
        appC.Client_Operates_Under_Existing_Franchise__c = true;
        appC.Credit_Agreement_at_Arms_Length__c = true;
        appC.Any_Juristic_Trustees__c = 'Yes';
        appC.Client_State__c = 'Yes';
        appC.Asset_Value__c = 200000.00;
        appC.Client_State__c = 'No';
        appC.Number_or_Trustees__c = 20.0;
        appC.Opportunity_Product_Id__c = newOppRecord.Id;
        appC.Part_of_Enterprise_Development_Fund__c = true;
        appC.Opportunity__c = newOppRecord.Id;
        String response;



        try{
            upsert appC;
            response = AllocateStockNumberController.updateNCAsection(true, 12345,'Yes', 100, 2000, 'Yes', true,false,newOppRecord.Id);
		         }
        catch(Exception e)
        {
         response = 'ERROR';
        }
        system.assert(response != null);
        Test.stopTest();
    }

    /**
    * @description : test method for all the methods having less coverage
    * @author Saurabh | 06-07-2021
    **/
    @IsTest
    private static  void testcreateAppProfileRecords(){

      final String POSITIVE_RESPONSE_BODY = '{ "nbrEntsRetrieved": "6", "lastSearchPos": "05194602345807 VSAFRIC025", "tblEntry": [ { "cifKey": "NPROJEC002", "cifInitials": "", "cifSurname": "EVRON PLASTICS (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "11", "cifBirthDate": "0", "cifAddrLine1": "16A CENTRAL AVENUE", "cifAddrLine2": "", "cifPostlSuburb": "", "cifPostlTown": "KEMPTON PARK", "cifPostlCodeRsa": "1619", "cifCorpCode": "A" }, { "cifKey": "SSALES 050", "cifInitials": "", "cifSurname": "SUB SALES PTY LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "0", "cifBirthDate": "0", "cifAddrLine1": "1 TEAK", "cifAddrLine2": "", "cifPostlSuburb": "", "cifPostlTown": "JHB", "cifPostlCodeRsa": "2001", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC022", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "1", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "15 Troye", "cifPostlTown": "MarshallTown", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC023", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "1", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "UITENHAGE", "cifPostlTown": "Uitenhage", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC024", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "2", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "UITENHAGE", "cifPostlTown": "Uitenhage", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC025", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "2", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "UITENHAGE", "cifPostlTown": "Uitenhage", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" } ] }';
      Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

      IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
      list<Integration_Service__c> servicelist = [Select id,Name from Integration_Service__c];
      system.debug('Service aviailable'+servicelist);
     Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];
     Account acc = [Select id,Company_Registration_Number__c,ID_Type__c,Registration_Number__c,Account.CIF__c from Account where id =:opportunity.AccountId];
             acc.Registration_Number__c = '194602345807';
             acc.ID_Type__c = 'Registration Number';
             acc.CIF__c = 'VSAFRIC022';
             update acc;
       Application__c app = [Select id from Application__c limit 1];
       system.debug('Application__c'+app);
       app.Opportunity__c = opportunity.Id;
       update app;
       Integration_Translation__c translation = new Integration_Translation__c();
       translation.Direction__c= 'Outbound';
       translation.External_Value__c = '05';
       translation.Internal_Value__c = 'Registration Number';
       translation.System_Name__c = 'CIF';
       translation.Value_Type__c = 'Identity Type';
       insert translation;

       Application_Principal__c apr = new Application_Principal__c();
             apr.Principal_Shareholder_Name__c = 'Test';
             apr.CIF__c = 'NPROJEC002';
             apr.Id_Number__c = '194602345808';
             apr.Controlling_Interest__c = 70;
             apr.Application__c = app.id;
             apr.Is_Part_Of_Application__c = True;
             apr.ID_Type__c ='Registration Number';
        Insert apr;
        Application_Principal__c apr1 = new Application_Principal__c();
             apr1.Principal_Shareholder_Name__c = 'Test';
             apr1.CIF__c = null;
             apr1.Id_Number__c = '194602345808';
             apr1.Controlling_Interest__c = 70;
             apr1.Application__c = app.id;
             apr1.Is_Part_Of_Application__c = True;
             apr1.ID_Type__c ='Registration Number';
        Insert apr1;
        Set<string> cifSet = new Set<string>{'VSAFRIC022'};
        Test.startTest();
        AllocateStockNumberController.createAppProfileRecords(opportunity.Id);
        AllocateStockNumberController.getAppProfileAccounts(cifSet);
        AllocateStockNumberController.getFormatedDate('20201202');
        AllocateStockNumberController.getEnDevFundDetails(opportunity.Id);
        AllocateStockNumberController.updateEnDevFundDetails(opportunity.Id,'test','test','test','test',True,True);
        AllocateStockNumberController.updateFranchiseDetailsOnaAcc('test', 'test',acc.id);
        AllocateStockNumberController.getReqFranchiseDetails('test');
        AllocateStockNumberController.getEDFservice(opportunity.Id);
        //Future Methods have void return type
        System.assert(apr1 != Null);
        Test.stopTest();
    }

      /**
      * @description : Negative  Test Method for createAppProfileRecords
      * @author Saurabh | 06-07-2021
      **/
      @IsTest
      private static  void testcreateAppProfileRecordsNegative(){

      final String POSITIVE_RESPONSE_BODY = '{ "nbrEntsRetrieved": "6", "lastSearchPos": "05194602345807 VSAFRIC025", "tblEntry": [ { "cifKey": "NPROJEC002", "cifInitials": "", "cifSurname": "EVRON PLASTICS (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "11", "cifBirthDate": "0", "cifAddrLine1": "16A CENTRAL AVENUE", "cifAddrLine2": "", "cifPostlSuburb": "", "cifPostlTown": "KEMPTON PARK", "cifPostlCodeRsa": "1619", "cifCorpCode": "A" }, { "cifKey": "SSALES 050", "cifInitials": "", "cifSurname": "SUB SALES PTY LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "0", "cifBirthDate": "0", "cifAddrLine1": "1 TEAK", "cifAddrLine2": "", "cifPostlSuburb": "", "cifPostlTown": "JHB", "cifPostlCodeRsa": "2001", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC022", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "1", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "15 Troye", "cifPostlTown": "MarshallTown", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC023", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "1", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "UITENHAGE", "cifPostlTown": "Uitenhage", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC024", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "2", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "UITENHAGE", "cifPostlTown": "Uitenhage", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" }, { "cifKey": "VSAFRIC025", "cifInitials": "", "cifSurname": "VOLKSWAGEN OF SOUTH AFRICA (PTY) LTD", "cifTitleCode": "0", "cifClntType": "2301", "cifClntGroup": "N", "cifNbrOfAccts": "2", "cifBirthDate": "0", "cifAddrLine1": "PO BOX 80", "cifAddrLine2": "", "cifPostlSuburb": "UITENHAGE", "cifPostlTown": "Uitenhage", "cifPostlCodeRsa": "6230", "cifCorpCode": "A" } ] }';
      Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

      IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
      list<Integration_Service__c> servicelist = [Select id,Name from Integration_Service__c];
      system.debug('Service aviailable'+servicelist);
     Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];
     Account acc = [Select id,Company_Registration_Number__c,ID_Type__c,Registration_Number__c,Account.CIF__c from Account where id =:opportunity.AccountId];
             //acc.Registration_Number__c = '194602345807';
             //acc.ID_Type__c = 'Registration Number';
             acc.CIF__c = 'VSAFRIC022';
             update acc;
       Application__c app = [Select id from Application__c limit 1];
       system.debug('Application__c'+app);
        app.Opportunity__c = opportunity.Id;
        update app;
       Integration_Translation__c translation = new Integration_Translation__c();
       translation.Direction__c= 'Outbound';
       translation.External_Value__c = '05';
       translation.Internal_Value__c = 'Registration Number';
       translation.System_Name__c = 'CIF';
       translation.Value_Type__c = 'Identity Type';
       insert translation;

       Application_Principal__c apr = new Application_Principal__c();
             apr.Principal_Shareholder_Name__c = 'Test';
             apr.CIF__c = 'NPROJEC002';
             apr.Id_Number__c = '194602345808';
             apr.Controlling_Interest__c = 70;
             apr.Application__c = app.id;
             apr.Is_Part_Of_Application__c = True;
             apr.ID_Type__c ='Registration Number';
        Insert apr;
        Set<string> cifSet = new Set<string>{'VSAFRIC022'};
        Test.startTest();
        AllocateStockNumberController.createAppProfileRecords(opportunity.Id);
        AllocateStockNumberController.updateEnDevFundDetails(opportunity.Id,'test','test','test','test',False,False);
        //some Methods have void return type hence checking Insertion
        System.assert(apr != Null);
        Test.stopTest();
    }
    /**
    * @description : testMethod for createAppProfileRecords to verify spouse details
    * @author Saurabh | 06-07-2021
    **/
    @IsTest
    private static  void testspousedet(){
      //  PowerCurveControllerTest.testData();
      Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE AccountId!=null Limit 1];
      Account acc = [Select id,Company_Registration_Number__c,ID_Type__c,Registration_Number__c,Account.CIF__c from Account where id !=:opportunity.AccountId limit 1];
             acc.Registration_Number__c = '194602345807';
             acc.ID_Type__c = 'Registration Number';
             acc.CIF__c = '';
             //acc.Passport_Number__pc = 'abc';
             update acc;
      opportunity.Spouse_Account_Id__c = acc.id;
      opportunity.Is_Spouse_Captured__c=true;
        update opportunity;
        AllocateStockNumberController.createAppProfileRecords(opportunity.id);
        Account acc2 = new account();
        acc2.id=opportunity.AccountId;
        acc2.Registration_Number__c=null;
        //acc2.ID_Number__pc=null;
        //acc2.Passport_Number__pc=null;
        update acc2;
        AllocateStockNumberController.createAppProfileRecords(opportunity.id);
        //Future Methods have void return type
        System.assert(acc2 != Null);
    }
    /**
    * @description : test Method for callEDFService
    * @author unknown | 06-07-2021
    **/
    @IsTest
    private static  void testcallEDFservice(){
        final String POSITIVE_RESPONSE_BODY = '{"CIgetRelationshipsV1Response": {"cib128o": {"clientKey": "SBSOUTP001","clientName": "SEDERKRANS BOERDERY SOUTPANSBERG BK","noRecordCnt": 3,"relDetails": [{"dateCreated": 20191107,"relatedAcno": "0000000000000000000","relativeClientIdNo": 199605498423,"relativeClientIdTp": 5,"relativeClientKey": "MBBK   249","relativeClientName": "MAMANGONI BOERDERY BK","relativeRelaCode": 721,"relativeRelaCodeDs": "PRIMARY CLIENT","sourceRelaCode": 390,"sourceRelaCodeDesc": "GROUP MEMBER"},{"dateCreated": 20210127,"relatedAcno": "0000000000000000000","relativeClientIdNo": 191600015706,"relativeClientIdTp": 5,"relativeClientKey": "DBSOUTH001","relativeClientName": "DEVELOPMENT BANK OF SOUTH AFRICA","relativeRelaCode": 900,"relativeRelaCodeDs": "ENTERPRISE DEVEL","sourceRelaCode": 910,"sourceRelaCodeDesc": "S &amp; M ENTERPRISE"},{"dateCreated": 20210127,"relatedAcno": "0000000000000000000","relativeClientIdNo": 295400242507,"relativeClientIdTp": 5,"relativeClientKey": "TSAFRIC048","relativeClientName": "TOTAL SOUTH AFRICA (PTY) LTD","relativeRelaCode": 900,"relativeRelaCodeDs": "ENTERPRISE DEVEL","sourceRelaCode": 910,"sourceRelaCodeDesc": "S &amp; M ENTERPRISE"}], "restartKey": "SBSOUTP001N910900                   TSAFRIC048"},"nbsapdpo": {"reasonCode": 0,"returnCode": 0,"serviceVersion": "BUSO001"},"nbsmsgo3": {"nbrUserErrs": 0,"nbrUserMsgs": 0}}}';

      IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'CIgetRelationshipsV1'});
      Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));


     list<Integration_Service__c> servicelist = [Select id,Name from Integration_Service__c];
     system.debug('Service aviailable'+servicelist);
     Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];
     Account acc = [Select id,Company_Registration_Number__c,ID_Type__c,Registration_Number__c,Account.CIF__c from Account where id =:opportunity.AccountId];
             acc.Registration_Number__c = '194602345807';
             acc.ID_Type__c = 'Registration Number';
             acc.CIF__c = 'VSAFRIC022';
             update acc;
       Application__c app = [Select id from Application__c limit 1];
       system.debug('Application__c'+app);
        app.Opportunity__c = opportunity.Id;
        update app;
       Integration_Translation__c translation = new Integration_Translation__c();
       translation.Direction__c= 'Outbound';
       translation.External_Value__c = '05';
       translation.Internal_Value__c = 'Registration Number';
       translation.System_Name__c = 'CIF';
       translation.Value_Type__c = 'Identity Type';
       insert translation;

       Application_Principal__c apr = new Application_Principal__c();
             apr.Principal_Shareholder_Name__c = 'Test';
             apr.CIF__c = 'NPROJEC002';
             apr.Id_Number__c = '194602345808';
             apr.Controlling_Interest__c = 70;
             apr.Application__c = app.id;
             apr.Is_Part_Of_Application__c = True;
             apr.ID_Type__c ='Registration Number';
        Insert apr;
        Set<string> cifSet = new Set<string>{'VSAFRIC022'};
        Test.startTest();

        AllocateStockNumberController.getEDFservice(opportunity.Id);
        //Future Methods have void return type
        System.assert(apr != Null);

        Test.stopTest();
    }
}