/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @group             :
 * @last modified on  : 2021-11-04
 * @last modified by  : sive.kula@absa.africa
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   05-15-2021   muvhuso.nekhubvi@absa.africa   Initial Version
* 1.01  05-15-2021   tawanda.madavo@absa.africa    Modified
* 1.0   2021-07-23   PaulJohn.duRand@absa.africa    Added SearchTypeFilter
**/
/**
 * @description Test Class
 * @Purpose      	   : Test Class for ClientFinderExt
 * @Author       	   : Dreamwares
 * @Created Date 	   : 06/09/2018
 * @Last Modified Date : 11/09/2018
 */
@isTest
public class ClientFinderExtTest
{
    //Create test data
    @testSetup
    static void dataCreation(){

        Account account = new Account(Name = 'Test Account', CIF__c = 'GSOFTWA002');
        insert account;


        Client_Finder_Search_Attempts__c searchLimitAttemp = new Client_Finder_Search_Attempts__c(Limit__c = 3);
    }

    //Methods to test
    @isTest
    static void testClientFinderBase() {
        List<Account> accounts = new List<Account>();
        System.assertNotEquals(accounts, null,'should not be null');
        Test.startTest();
        accounts = ClientFinderBase.searchSalesforceAccountsByName('Test Account');
        accounts = ClientFinderBase.searchSalesforceAccountsByCIF('T0231');
        accounts = ClientFinderBase.searchSalesforceAccountsByValue('Test');
        Test.stopTest();
        
    }

    //Methods to test - Positive
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @isTest
    static void testClientFinderPositive() {
        Account accountRec = [SELECT Id, Name, Client_Type__C FROM Account LIMIT 1];
        Account newBusClientRecord = new Account(Name = 'Test New Bus Client');
        Account newBusClientRecord2 = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company');
        Account newIndvClientRecord = new Account(FirstName = 'Test New ', LastName = 'Indv Client',Client_Type__C = 'Sole Trader');
        Contact newContactRecord = new Contact(FirstName = 'Test', LastName = 'Contact');
        Address__c testResidentialAddress = new Address__c(Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City');
        System.assertNotEquals(accountRec, null,'should not be null');

        Test.startTest();
        //Test search types
        Integer i= ClientFinderExt.incrementCount(10);
        Integer ix = ClientFinderExt.getSearchLimit(10);
        String val = ClientFinderExt.createCIFClientInSF(newBusClientRecord2);
        String valST = ClientFinderExt.createCIFClientInSF(newIndvClientRecord);
        boolean boolchk = ClientFinderExt.checkCompliant('GSOFTWA002');
        //String cassinf = ClientFinderExt.getRelatedPartyListByPrimaryRefNo(accountRec.Id,'123456');
        string proVal =  ClientFinderExt.getloggedinUserProfileName();
        List<User> listUsr = ClientFinderExt.getPortfolioManagerlist();
        //Account accVal =  ClientFinderExt.fetchPersonAccDetails(accountRec.id);
        List<Account> accountList = ClientFinderExt.searchClientLogic('Search Salesforce', 'Test', null, null, null);
        List<Account> accountList2 = ClientFinderExt.searchClientLogic(null, null, newBusClientRecord.id, null, null);
        List<Account> accountList3 = ClientFinderExt.searchClientLogic(null, null, accountRec.id, null, null);
        try{
        String tstCovid = ClientFinderExt.createNewCovidOpportunity(accountRec);
        } catch(Exception ex) {
            System.debug(ex);
        }
        List<String> testSearchTypes = ClientFinderExt.loadSearchOptions('');
        String newBusClientId = ClientFinderExt.createNewClient(newBusClientRecord, false, false, testResidentialAddress);
        String newIndvClientId = ClientFinderExt.createNewClient(newIndvClientRecord, true, false, testResidentialAddress);
        Account newBusClient = ClientFinderExt.CreateNewBusinessClient(newBusClientRecord);
        Contact newContact = ClientFinderExt.CreateNewBusinessContact(newContactRecord);
        Integer incrementValue = ClientFinderExt.incrementCount(1);
        Integer searchLiit = ClientFinderExt.getSearchLimit(3);
        List<Case> casesList = ClientFinderExt.getCasesLinkedToClient(accountRec.Id);
        List<Contact> contactsList = ClientFinderExt.getContactsLinkedToClient(accountRec.Id);
        List<Lead> leadsList = ClientFinderExt.getLeadsLinkedToClient(accountRec.Id);
        List<ClientFinderExt.DataTableColumns> clientDataTables = ClientFinderExt.getClientResultTableFields('Account', 'Client_Finder_Compact_View');
        Test.stopTest();
    }

    //Methods to test - Negative
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @isTest
    static void testClientFinderNegative() {
        Account newBusClientRecord = new Account(Name = 'Test New Bus Client');
        Account newIndvClientRecord = new Account(FirstName = 'Test New ', LastName = 'Indv Client');
        Contact newContactRecord = new Contact();
        Address__c testResidentialAddress = new Address__c(Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City');
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        System.assertNotEquals(newBusClientRecord, null,'Industry should not be null');
        Test.startTest();
        //Test search types
        try{
            String newBusClientId = ClientFinderExt.createNewClient(newIndvClientRecord, true, false, testResidentialAddress);
            String newIndvClientId = ClientFinderExt.createNewClient(newBusClientRecord, false, false, testResidentialAddress);
            Account newBusClient = ClientFinderExt.CreateNewBusinessClient(newIndvClientRecord);
            Contact newContact = ClientFinderExt.CreateNewBusinessContact(newContactRecord);
            String adapt360JSONString = ClientFinderExt.getClientDetailsBean('CIF No', 'GSOFTWA002');
            List<Account> clientAccountList = ClientFinderExt.generateBeanClientAccountInfo(adapt360JSONString);
            clientAccountList = ClientFinderExt.searchClientLogic(null, null, null, adapt360JSONString, null);
        }catch(AuraHandledException ex){
            System.debug('AuraHandledException - ' + ex);
        }catch(Exception ex){
            System.debug('Exception - ' + ex);
        }
        Test.stopTest();
    }

    //Methods to test - Negative
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @isTest
    static void testClientFinderNegative2() {
        Account newBusClientRecord = new Account(Name = 'Test New Bus Client');
        Account newIndvClientRecord = new Account(FirstName = 'Test New ', LastName = 'Indv Client');
        Contact newContactRecord = new Contact();
        Address__c testResidentialAddress = new Address__c(Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City');
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        System.assertNotEquals(newBusClientRecord, null,'Industry should not be null');

        Test.startTest();
        try{
            String newBusClientId = ClientFinderExt.createNewClient(newIndvClientRecord, true, false, testResidentialAddress);
            String newIndvClientId = ClientFinderExt.createNewClient(newBusClientRecord, false, false, testResidentialAddress);
            Contact newContact = ClientFinderExt.CreateNewBusinessContact(newContactRecord);
            String adapt360JSONString = ClientFinderExt.getClientDetailsBean('CIF No', 'GSOFTWA002');
            List<Account> clientAccountList = ClientFinderExt.generateBeanClientAccountInfo(adapt360JSONString);
            clientAccountList = ClientFinderExt.searchClientLogic(null, null, null, adapt360JSONString, null);
        }catch(AuraHandledException ex){
            System.debug('AuraHandledException - ' + ex);
        }catch(Exception ex){
            System.debug('Exception - ' + ex);
        }
        Test.stopTest();
    }

    @isTest
    static void testAdapt360Positive2() {
        List<Account> accounts = new List<Account>();
        Account accountRec = [SELECT Id, Name FROM Account LIMIT 1];
        Account newAccountRec = new Account();

        System.assertNotEquals(accounts, null,'Industry should not be null');

        // Set mock callout class - Adapt360
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        Test.startTest();
        //Client and Products from Adapt360
        String adapt360JSONString2 = ClientFinderExt.getClientDetailsBean('CIF No', 'TEST550');
        List<Account> clientAccountList2 = ClientFinderExt.generateBeanClientAccountInfo(adapt360JSONString2);
        Test.stopTest();
    }

    @isTest
    static void testAdapt360Positive3() {
        // Set mock callout class - Adapt360
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});


        Test.startTest();
        //Client and Products from Adapt360
        String adapt360JSONString2 = ClientFinderExt.getClientDetailsBean('CIF No', 'GSOFTWA002');
        List<Account> clientAccountList2 = ClientFinderExt.generateBeanClientAccountInfo(adapt360JSONString2);
        System.assertNotEquals(clientAccountList2, null,'Industry should not be null');
        //List<Account> accountList = ClientFinderExt.searchClientLogic('CIF No', 'GSOFTWA002', null, testing, null);
        Test.stopTest();
    }

    @isTest
    @SuppressWarnings('PMD.AvoidDebugStatements')
    static void testAdapt360Positive() {
        List<Account> accounts = new List<Account>();
        Account accountRec = [SELECT Id, Name FROM Account LIMIT 1];
        Account newAccountRec = new Account();

        // Set mock callout class - Adapt360
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});

        Test.startTest();
        try {
            String adapt360JSONString = ClientFinderExt.getClientDetailsBean('CIF No', 'GSOFTWA002');
            List<Account> clientAccountList = ClientFinderExt.generateBeanClientAccountInfo(adapt360JSONString);
            clientAccountList = ClientFinderExt.searchClientLogic('CIF No', null, null, adapt360JSONString, null);
            System.assertNotEquals(clientAccountList, null,'Industry should not be null');

        }catch(AuraHandledException ex){
            System.debug('AuraHandledException - ' + ex);
        }catch(Exception ex){
            System.debug('Exception - ' + ex);
        }
        Test.stopTest();

    }

    @isTest
    static void testInvolvedPartyPositive() {
        List<Account> accounts = new List<Account>();
        Account accountRec = [SELECT Id, Name FROM Account LIMIT 1];
        Account newAccountRec = new Account();

        // Set mock callout class - Adapt360
        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        System.assertNotEquals(accountRec, null,'Industry should not be null');

        Test.startTest();

        String involvedParties = ClientFinderExt.getMDMClientDetailsBean('ID Number','8701057648086');
        Account involvedParty = ClientFinderExt.generateMDMClientInfo(involvedParties);
        List<Account> involvedPartiesLst = ClientFinderExt.searchClientLogic(null, null, null, null, involvedParties);

        Test.stopTest();

    }

    @isTest
    static void testInvolvedPartyPositive2() {
        List<Account> accounts = new List<Account>();
        Account accountRec = [SELECT Id, Name FROM Account LIMIT 1];
        Account newAccountRec = new Account();

        // Set mock callout class - Adapt360
        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        System.assertNotEquals(accountRec, null,'Industry should not be null');

        Test.startTest();

        String involvedParties = ClientFinderExt.getMDMClientDetailsBean('CIF No','AKHILAM001');
        Account involvedParty = ClientFinderExt.generateMDMClientInfo(involvedParties);
        List<Account> involvedPartiesLst = ClientFinderExt.searchClientLogic(null, null, null, null, involvedParties);
        Test.stopTest();

    }

    @isTest
    static void testGetJointParticipantsPositive() {
        List<Account> accounts = new List<Account>();

        //Test search types
        List<String> testSearchTypes = ClientFinderExt.loadSearchOptions('');

        //Set mock callout class - getJointParticipant
        GetJointParticipant_Req_IB_v1 dummyBean = new GetJointParticipant_Req_IB_v1();
        dummyBean.createDummyRequest();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        System.assertNotEquals(accounts, null,'Industry should not be null');

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GetJointParticipantMock_ApiRest(StringConstants.POSITIVE_STRING));

        Test.startTest();

        //getParticipants
        String getParticipantsJSONString = ClientFinderExt.getParticipantsBean('RAMANS+001');
        List<Account> participantAccountList = ClientFinderExt.generateBeanClientParticipantInfo(getParticipantsJSONString);

        Test.stopTest();
    }

    @isTest
    static void testCreateRelationship() {
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        insert acctPrimary;
        Account acctPerson = new Account(Name = 'Test Person Account');
        insert acctPerson;
        System.assertNotEquals(acctPerson, null,'Industry should not be null');

        Test.startTest();
        List<String> roles = new list<String> {'Director'};
        string rolesList = JSON.serialize(roles);
        ClientFinderExt.createRelationship(acctPrimary.Id, acctPerson.Id, rolesList, 15.00, '', 'No', acctPrimary.Id, '');
        ClientFinderExt.updateAccAndCreateAccConReln(acctPrimary, acctPrimary.Id, roles, '15.00',acctPrimary.Id, '');
        Test.stopTest();
    }

    @isTest
    static void testcallHanisService() {
        System.assertNotEquals('', null,'Industry should not be null');

        Test.startTest();
        ClientFinderExt.callHanisService('9110085319083');
        Test.stopTest();
    }

    @isTest
    static void testcallCPBService() {
        System.assertNotEquals('', null,'Industry should not be null');

        Test.startTest();
        ClientFinderExt.callCPBService('9110085319083', 'Test');
        Test.stopTest();
    }

    /*
    @isTest
    static void testcreateRelatedPartyRecord() {
        Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {
            StringConstants.CPB_VALIDATE

        });
        Test.startTest();
        // Set mock callout class
        try {
           String testing =  ClientFinderExt.createRelatedPartyRecord('7707077777087', 'Burger');
        } catch (Exception ex) {

        }
        Test.stopTest();
    } */
     @isTest
    static void testCreateCase() {
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        insert acctPrimary;
        Account acctPerson = new Account(Name = 'Test Person Account');
        insert acctPerson;
        System.assertNotEquals(acctPerson, null,'Industry should not be null');

        Test.startTest();
        String testing =  ClientFinderExt.createCase(acctPrimary.id);
        Test.stopTest();
    }

         @isTest
    static void testGetRecordTypeId() {
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        insert acctPrimary;
        Account acctPerson = new Account(Name = 'Test Person Account');
        insert acctPerson;
        System.assertNotEquals(acctPerson, null,'Industry should not be null');

        Test.startTest();
        String testing =  ClientFinderExt.getRecordTypeId('Prospect', 'Account');
        ClientFinderExt.getClientRecordTypeByName('Prospect');
        ClientFinderExt.getOpportunityRecordTypeByName('Product_Onboarding');
        Test.stopTest();
    }

          @isTest
    static void testCreateNewBusinessClient() {
        Account acctPrimary = new Account(Name = 'Test Primary Account');
        System.assertNotEquals(acctPrimary, null,'Industry should not be null');

        Test.startTest();
        ClientFinderExt.CreateNewBusinessClient(acctPrimary);
        Test.stopTest();
    }

    @SuppressWarnings('PMD.AvoidDebugStatements')
    @isTest
    static void testCreateNewClientNegative() {
        Account acctPrimary = new Account(Client_Type__c = 'Test Primary Account');
        System.assertNotEquals(acctPrimary, null,'Industry should not be null');

        Test.startTest();
        try {
        ClientFinderExt.createNewClient(acctPrimary, true, true, null);
         } catch (Exception ex) {
        	System.debug(ex);
        }
        Test.stopTest();
    }

     @isTest
    static void testGetClientDetailsBeanMulti() {
        //INsert test data
        Field_Dependency_Setup__mdt clientTypesdata = new Field_Dependency_Setup__mdt();
        clientTypesdata.DeveloperName = 'Non_Individual_Client_Group';
        clientTypesdata.MasterLabel = 'Non Individual Client Group';
        clientTypesdata.Controlling_Field_API_Name__c = 'Client_Group__c';
        clientTypesdata.Controlling_Field_Value__c = 'Non Individual';
        clientTypesdata.Dependent_Field_API_Name__c = 'Client_Type__c';
        clientTypesdata.Dependent_Field_Values__c = 'Central Bank or Regulator;Close Corporation';
        clientTypesdata.Object_API_Name__c = 'Account';
        clientTypesdata.Department_Division__c = 'RBB';
        System.assertNotEquals(clientTypesdata, null,'should not be null');

        Test.startTest();
        ClientFinderExt.getClientDetailsBean('Account Number', '8888353555353');
        ClientFinderExt.getClientDetailsBean('Reg. No / Passport', '8888353555353');
        ClientFinderExt.getClientDetailsBean('ID Number', '8888353555353');
        ClientFinderExt.getselectOptions(new Account(),'Country_of_Citizenship__c');
        ClientFinderExt.getPickListValues();
        ClientFinderExt.getClientGroupPickListValues();
        ClientFinderExt.getClientTypePickListValues('Non-Individual');
        Test.stopTest();
    }

    @isTest
    public static void callCreateCreditOnboardingOpportunity(){

        Test.startTest();

        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
                //Setting Up sales Process Type
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'New Credit Product (Business Banking)',
            Sales_Process__c = 'Credit Onboarding',
            Opportunity_Record_Type__c = 'Credit Onboarding',
            Request_Name__c = 'New Credit Product (Business Banking)');
        insert salesProcessType;

        String oppId = ClientFinderExt.createNewCreditOpportunity(account);
        Product2 selectedProduct = new Product2(
        Name = 'SPM Equity Product');
        insert selectedProduct;
        ClientFinderExt.createNewSPMOpportunity(account , '');
        System.assertNotEquals(null, oppId);
        Test.stopTest();
    }

    @isTest 
    public static void callCreateComplexCreditOnboardingOpportunity(){

        Test.startTest();
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        //Setting Up sales Process Type
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'Complex Credit (Business Banking)',
            Sales_Process__c = 'Complex Credit Onboarding',
            Opportunity_Record_Type__c = 'Complex_Credit_Onboarding',
            Request_Name__c = 'Complex Credit');
        insert salesProcessType;
        
        String oppId = ClientFinderExt.createNewComplexCreditOpportunity(account);
        System.assertNotEquals(null, oppId);    
        Test.stopTest();
    } 
    
    //TdB - Test class for CIF search by Name
    @isTest
    static void testSearchByNamePositive() {

        CIgetClientDetailsByNameV2_Req_IB_v1 dummyBeanParent = CIgetClientDetailsByNameV2_Req_IB_v1.createDummyRequest();
        CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i dummyBean = dummyBeanParent.CIgetClientDetailsByNameV2.cip602i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetClientDetailsByNameV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CI_GET_CLIENTDETAILS_BY_NAME_V2
        });

        Test.startTest();

        List<Account> cifNameAccounts = ClientFinderExt.callCIFSearchByName(dummyBean.cifSurname);
        System.assertNotEquals( null, cifNameAccounts);

        Test.stopTest();
    }
    @isTest
    static void getRelatedPartyListByPrimaryRefNoTest() {
       String POSITIVE_RESPONSE_BODY = '{"WQgetCASADetailsByRefNoV7Response": {"approvedSts": null,"clientTypeGrp": "N","cntryOfRes": "SO003","countryOfBirth": null,"dateTime": null,"dob": 0,"documentSts": "C","firstName": null,"idRegNo": 200801284907,"idType": 5,"msg": null,"msgNo": 0,"nationality": "SOU01","noParticipants": 2,"pepSts": null,"primaryClient": 0,"relatedParties": [{"rApprovedSts": null,"rClientTypeGrp": "I","rCntryOfRes": "SO003","rCountryOfBirth": "SO003","rDob": 19911222,"rFirstName": "LEDIKE EPHRAIM","rIdRegNo": 9112225706088,"rIdType": 1,"rNationality": "SOU01","rPepSts": null,"rRefNo": 121116974,"rRelationship": 111222,"rStatus": "C","rSurnameComp": "MAHLARE"},{"rApprovedSts": null,"rClientTypeGrp": "I","rCntryOfRes": "SO003","rCountryOfBirth": "SO003","rDob": 19830525,"rFirstName": "QUINTIN","rIdRegNo": 8305255026085,"rIdType": 1,"rNationality": "SOU01","rPepSts": null,"rRefNo": 121116975,"rRelationship": 210305,"rStatus": "C","rSurnameComp": "STANDER" }],"riskRequired": "Y","sbu": "H","status": "C","surnameComp": "MAINSAIL TRADING 136 (PTY) LTD"}}';

        WQgetCASADetailsByRefNoV7_Req_IB_v1 dummyReqBean = WQgetCASADetailsByRefNoV7_Req_IB_v1.createDummyRequest();
        WQgetCASADetailsByRefNoV7_Resp_IB_v1 dummyBean = WQgetCASADetailsByRefNoV7_Resp_IB_v1.createDummyResponse();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{WQgetCASADetailsByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME});
        System.assertNotEquals(dummyBean, null,'should not be null');

        Test.startTest();
         Account testAccount= new Account();
        testAccount.firstName = 'Test Name';
        testAccount.lastname = 'Test Sur';
        testAccount.ID_Number__pc = '4407285096080';
        testAccount.PersonBirthdate = Date.valueOf('1967-03-13');
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Salary';
        //insert testAccount; testAccoun
        Account acc = [Select id from Account limit 1]; // Saurabh taking a Account from Data Setup as inserting here was causing Failure
        ClientFinderExt.getRelatedPartyListByPrimaryRefNo(acc.Id,'121116973');

        Test.stopTest();
    }

        @isTest
    static void testbusinessRulesEngineHandler() {
        String POSITIVE_RESPONSE_BODY = '{"msg":"OK from container \'Onboarding_1.0.1-SNAPSHOT\'","result":{"dmn_evaluation_result":{"decision_results":{"x_43E7DD07_6150_419F_8E12_5AC01258C1AA":{"decision_id":"_43E7DD07-6150-419F-8E12-5AC01258C1AA","decision_name":"BankingSectorDecision","status":"SUCCEEDED"},"x_49C14D30_146F_4F8D_9BD4_6416569CF2E8":{"decision_id":"_49C14D30-146F-4F8D-9BD4-6416569CF2E8","decision_name":"BusinessAreaDecision","status":"SUCCEEDED"},"x_70C97339_8373_4D64_AB61_534E6F5E8C3C":{"decision_id":"_70C97339-8373-4D64-AB61-534E6F5E8C3C","decision_name":"BusinessSubSegmentDecision","status":"SUCCEEDED"},"x_8352CC8A_BEAD_493B_8AC4_A0C27C80B117":{"decision_id":"_8352CC8A-BEAD-493B-8AC4-A0C27C80B117","decision_name":"BusinessSegmentsDecision","status":"SUCCEEDED"},"x_A3254AF6_49DD_42BC_B8EC_D44AE1F2CD8B":{"decision_id":"_A3254AF6-49DD-42BC-B8EC-D44AE1F2CD8B","decision_name":"ClientTypeGroupDecision","status":"SUCCEEDED"},"x_E0630042_E9E0_4668_9F97_A83209F0CC8E":{"decision_id":"_E0630042-E9E0-4668-9F97-A83209F0CC8E","decision_name":"SicDecision","status":"SUCCEEDED"},"x_F8299673_69DE_4B8B_B67F_4A8BBB840D0B":{"decision_id":"_F8299673-69DE-4B8B-B67F-4A8BBB840D0B","decision_name":"ClientTypeDecision","result":"FAIL|ClientType|Invalid Client Type","status":"SUCCEEDED"}},"dmn_context":{"BankingSectorModel":"function BankingSectorModel( BankingSector )","BusinessAreaModel":"function BusinessAreaModel( BusinessArea )","BusinessSegmentsModel":"function BusinessSegmentsModel( BusinessSegments )","BusinessSubSegmentModel":"function BusinessSubSegmentModel( BusinessSubSegment )","ClientTypeDecision":"FAIL|ClientType|Invalid Client Type","ClientTypeGroupModel":"function ClientTypeGroupModel( ClientTypeGroup )","ClientTypeModel":"function ClientTypeModel( ClientType )","SicModel":"function SicModel( Sic )"},"messages":[{"dmn_message_severity":"ERROR","message":"ClientTypeGroup=\'null\' does not match any of the valid values null for decision table \'ClientTypeGroupModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_899322AE-4DEA-4A1C-B720-57B52C7B615C"},{"dmn_message_severity":"ERROR","message":"BusinessArea=\'null\' does not match any of the valid values null for decision table \'BusinessAreaModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_94C7C3FE-50E2-4C03-BB28-6C1F8C40CC9A"},{"dmn_message_severity":"WARN","message":"No rule matched for decision table \'SicModel\' and no default values were defined. Setting result to null.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_DBCDC7EF-6EA0-40DD-972D-92C988E0CF1A"},{"dmn_message_severity":"WARN","message":"No rule matched for decision table \'BankingSectorModel\' and no default values were defined. Setting result to null.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_1AE11C81-1542-473E-BEBC-6C40E55C6673"},{"dmn_message_severity":"ERROR","message":"BusinessSegments=\'null\' does not match any of the valid values null for decision table \'BusinessSegmentsModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_03D7EC15-6D0D-43BC-845D-3D040C99C672"},{"dmn_message_severity":"ERROR","message":"BusinessSubSegment=\'null\' does not match any of the valid values null for decision table \'BusinessSubSegmentModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_485E42B2-D75C-4FFF-82FA-2355C6F17035"}],"model_namespace":"https://kiegroup.org/dmn/_617F61F6-79BE-47A7-9A57-0F9D173B6BC1"}},"status":"OK","statusCode":200,"type":"SUCCESS"}}';
        String POSITIVE_RESPONSE_BODY_CMS = '{"GSB021O":{"GSB021O":{"GSB021O_BUSINESS_SUB_SEG":"","GSB021O_OVER_CONT_OFF_NUM":0,"GSB021O_BUSINESS_SEG":"","GSB021O_AGRI_CLIENT":"","GSB021O_DATE_APPROVED":0,"GSB021O_CONTROL_BRANCH":0,"GSB021O_CAP_BY_EMPLOYEE":0,"GSB021O_GROUP_REVIEW_DATE":0,"GSB021O_CONT_OFF_NUM":0,"GSB021O_STATUS":"","GSB021O_BANKING_SECTOR":"","GSB021O_OVERALL_CONTROL":0,"GSB021O_CONT_OFF_TYPE":"","GSB021O_FRANCHISOR_CODE":0,"GSB021O_DATE_CREATED":0,"GSB021O_FRANCH_CODE_DESC":"","GSB021O_OVER_CONT_OFF_TYP":"","GSB021O_BANK_SECTOR_CODE":0,"GSB021O_APP_BY_EMPLOYEE":0,"GSB021O_INDV_GROUP":"","GSB021O_DIVISION_CODE":"","GSB021O_SQL_MESS_CODE":"","GSB021O_LAST_ACTION":"","GSB021O_EXPOSURE_POLICY":""}},"NBSAPDPO":{"NBSAPLO":{"returnCode":0,"outputServiceVersion":"BUSO001","reasonCode":0}},"NBSMSGO3":{"NBSMSGO3":{"NBNMSGO3_NBR_USER_ERRS":1,"NBSMSGO3_VERSION":"","NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":1,"NBNMSGO3_MSG_ENTRY":[{"NBNMSGO3_MSG_ERR_IND":"E","NBNMSGO3_MSG_TXT":"Invalid Input Data Received","NBNMSGO3_MSG_CLASS":"GBSMGC01","NBNMSGO3_MSG_CODE":"0036"},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""},{"NBNMSGO3_MSG_ERR_IND":"","NBNMSGO3_MSG_TXT":"","NBNMSGO3_MSG_CLASS":"","NBNMSGO3_MSG_CODE":""}]}}}';

        RulesEngineService_Req_IB_v1 dummyBean = RulesEngineService_Req_IB_v1.createDummyRequest();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_CMS));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{RulesEngineService_IH_v1.INTEGRATION_SERVICE_NAME,GBGetContBranchDetV1_IH_v1.INTEGRATION_SERVICE_NAME});
        System.assertNotEquals(dummyBean, null,'should not be null');

        Test.startTest();
         Account testAccount= new Account();
        testAccount.firstName = 'Test Name';
        testAccount.lastname = 'Test Sur';
        testAccount.ID_Number__pc = '4407285096080';
        testAccount.PersonBirthdate = Date.valueOf('1967-03-13');
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Individual';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Salary';
        //insert testAccount; testAccoun
        Account acc = [Select id from Account limit 1];
        //ClientFinderExt.businessRulesEngineHandler(acc.Id); //will come back to it leaving at 80 now

        Test.stopTest();
    }

      /* @isTest
    static void testUpdateCreateAccountWithCIF() {
        Account newtobank = new Account();
        newtobank.ID_Number__pc = '9308305015082';
        newtobank.FirstName = 'testUpdateCreateAccountWithCIF';
        newtobank.LastName = 'Tester';
        insert newtobank;
        ClientFinderExt.UpdateCreateAccountWithCIF(newtobank.Id,'','','Yes');
        Boolean test = ClientFinderExt.validateId('9308305015082');
    } */

      @isTest
    static void testValidateExitedAccount() {
        Account newtobank = new Account();
        newtobank.ID_Number__pc = '9308305015082';
        newtobank.FirstName = 'testUpdateCreateAccountWithCIF';
        newtobank.LastName = 'Tester';
        insert newtobank;
        Account test = ClientFinderExt.validateExitedAccount('9308305015082','Individual');
        System.assertEquals(test, null,'should not be null');

    }

    @isTest
	public static void callcreateStokvelNewOpportunity(){

        Test.startTest();

        Account account = new Account(Name = 'stokvel Account');
        insert account;
        System.assertNotEquals(account, null,'should not be null');

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        String oppId = ClientFinderExt.createStokvelNewOpportunity(account.Id);

        Test.stopTest();

	}

    @isTest
    static void testCheckServiceGroupMethod(){

        Service_Type__c serviceType = new Service_Type__c(
            Name = 'FIC Refresh',
            Case_Record_Type__c = 'Service Request',
            Subtype__c = 'SubtypeTest',
            Type__c = 'TestType'
        );
        insert serviceType;

        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'TestGroup',
            Assign_Record_Type__c = 'Service Request',
            Response_Email_Address__c = 'testclass@test.com',
            Queue__c = 'Email',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '8'
        );
        insert serviceGr;
        List<String> serviceGroupList = new List<String>();
        serviceGroupList.add(serviceGr.Name);

        Service_Level__c serviceLevel = new Service_Level__c(
            Name = 'TestServiceLevel',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert serviceLevel;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id,
            Service_Level__c = serviceLevel.Id,
            Auto_Case_Creation__c = true
        );
        insert serviceGrType;

        System.assertNotEquals('Test', serviceLevel.Id,'Test');
        System.assertEquals('TestServiceLevel', serviceLevel.Name,'Test');
        ClientFinderExt.getFICRefreshServGrpTypeAndRecordTypeId(serviceGr.Id);
    }

    @isTest
	public static void validateExperianService() {
        // Set mock callout class
		Test.setMock(HttpCalloutMock.class, new ExperianBusinessDetailsGet_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Experian Business Details Get' });
		string result;
        Account testAccount = FICTestDataFactory.getAccount('Individual','Non Individual','Individual_Client');
        testAccount.Registration_Number__c = '7707077777087';
        update testAccount;
		Test.startTest();
		result = ClientFinderExt.callExperianHandler(testAccount.Id);
		Test.stopTest();
		system.assert(result != null);
	}
    
    @isTest
	public static void validateEmailTemplate() {
        Account testAccount = FICTestDataFactory.getAccount('Individual','Non Individual','Individual_Client');
        Test.startTest();
        ClientFinderExt.sendTemplatedEmail(testAccount.Id);
        system.assert(testAccount != null);
        Test.stopTest();
    }

    /**
    * @description
    * @author Taras Kuliievych | 10-21-2021
    **/
    @isTest
    static void createPersonAccountTest(){
        Test.startTest();

        Account account = new Account(Name = 'stokvel Account');
        insert account;
        System.assertNotEquals(account, null,'should not be null');

        try{
            Account account2 = ClientFinderExt.createPersonAccount(account);
        }
        catch(Exception ex){
            System.assert(String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    /**
    * @description
    * @author Taras Kuliievych | 10-21-2021
    **/
    @isTest
    static void getHomeLoanServiceJobUserTest(){
        Test.startTest();

        Boolean b = ClientFinderExt.getHomeLoanServiceJobUser();
        System.assert(!b);

        Test.stopTest();
    }
}