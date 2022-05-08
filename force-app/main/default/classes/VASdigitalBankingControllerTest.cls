/**
 * @description       : VASdigitalBankingControllerTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-06-24
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-24   André Pietersen (IQ Business)   Initial Version
**/
@isTest
public class VASdigitalBankingControllerTest 
{
    public static final String POSITIVE_RESPONSE_BODY_CHECK = '{"IBgetClientDetailsV1Response": {"nbsapdpo": {"echoKey": null, "reasonCode": 0,            "returnCode": 0,            "serviceVersion": "BUSO001",            "version": null        },        "nbsmsgo3": {            "msgEntry": {                "msgClass": "NHSMGC01",                "msgCode": "0001",                "msgErrInd": "E",                "msgTxt": "Access account (0000004048200331) not registered for IB service"            },            "nbrUserErrs": 1,            "nbrUserMsgs": 1,            "sysErrTxt": null,            "version": "MSG3001"        },        "nhs400o": {            "accountPaymentAvail": 0,            "accountPaymentLimit": 0,            "accountPaymentUsed": 0,            "bdbSalaryServices": null,            "changeDate": 0,            "changeSite": 0,            "changeTeller": 0,            "changeTime": 0,            "clientName": null,            "clientType": null,            "combiCardNumber": 0,            "costAccount": 0,            "debitedAccount": 0,            "division": null,            "email": null,            "feeStructure": null,            "fundTransferAvail": 0,            "fundTransferLimit": 0,            "fundTransferUsed": 0,            "futureDatedLimit": 0,            "lastAccessUserName": null,            "lastAccessedDate": 0,            "lastAccessedTime": 0,            "lastUserNumber": 0,            "mindleaders": null,            "numOfAuthRequired": 0,            "numOfMainUsers": 0,            "numOfOperators": 0,            "operatorSystemEnabled": null,            "ownDefinedAvail": 0,            "ownDefinedLimit": 0,            "ownDefinedUsed": 0,            "pinValidationRequired": null,            "registeredForApp": null,            "registeredForInternet": null,            "registeredForMobile": null,            "registeredForWap": null,            "registeringSite": null,            "registrationDate": 0,            "registrationTeller": 0,            "registrationTime": 0,            "securityOption": null,            "serviceChangeDate": 0,            "serviceChangeTime": 0,            "serviceStatus": null,            "statusDate": 0,            "statusTime": 0,            "stopOrderLimit": 0        }    }}';
    public static final String POSITIVE_RESPONSE_BODY_GET = '{"IBgetRegistrationDetailsV1Response": {"nbsapdpo": {"echoKey": null, "reasonCode": 0, "returnCode": 0, "serviceVersion": "BUSO001", "version": null }, "nbsmsgo3": {"msgEntry": { "msgClass": "NHSMGC01",  "msgCode": "0003", "msgErrInd": "E", "msgTxt": "Please capture a valid Access Account number" }, "nbrUserErrs": 1, "nbrUserMsgs": 1,  "sysErrTxt": null, "version": "MSG3001" }, "nhp292o": { "clientName": null, "clientType": null,  "feeStructure": null,    "pinValidationRequired": null } }}';
    public static final String POSITIVE_RESPONSE_BODY_UPDATE = '{"IBupdIBRegistrationDetailsV2Response": {"nbsapdpo": {"echoKey": null,            "reasonCode": 0,            "returnCode": 0,            "serviceVersion": null,            "version": null        },        "nbsmsgo3": {            "msgEntry": {                "msgClass": "NHSMGC01",                "msgCode": "0010",                "msgErrInd": "E",                "msgTxt": "Access account (0000004048374867) already registered"            },            "nbrUserErrs": 1,            "nbrUserMsgs": 1,            "sysErrTxt": null,            "version": "MSG3001"        }    }}';
    public static final String POSITIVE_RESPONSE_BODY = '{"IBmaintainUserDetailsV1Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgClass":"NHSMGC01","msgCode":"0042","msgErrInd":"E","msgTxt":"User name (SAM SMITH) or ID Passport (1212323) duplicated"}]}}}';
    public static final String POSITIVE_RESPONSE_BODY_SET = '{"IBupdIBLimitsV2Response":{"nbsapdpo": {"echoKey": null, "reasonCode": 0, "returnCode": 0, "serviceVersion": "BUSO001", "version": null }, "nbsmsgo3": { "nbrUserErrs": 1, "nbrUserMsgs": 1,  "sysErrTxt": null, "version": "MSG3001" } }}';
    public static final String POSITIVE_RESPONSE_BODY_SET_RVN = '{"IBupdIBUserNotificationDetailsV1Response":{"nbsapdpo": {"echoKey": null, "reasonCode": 0, "returnCode": 0, "serviceVersion": "BUSO001", "version": null }, "nbsmsgo3": { "msgEntry": { "msgClass": "NHSMGC01",  "msgCode": "0003", "msgErrInd": "E", "msgTxt": "Please capture a valid Access Account number" }, "nbrUserErrs": 1, "nbrUserMsgs": 1,  "sysErrTxt": null, "version": "MSG3001" } }}';

    @testSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBgetClientDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBgetRegistrationDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBmaintainUserDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
        insert prod;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.id = test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';

        account.CIF__c = 'LTD 933';
        account.Language__c = 'english';
        account.Number_Of_Dependents__c = 0;
        account.PersonEmail = 'test@absa.africa';
        account.PersonMobilePhone = '0819908786';
        account.ID_Type__pc = 'PASSPORT';
        account.Nationality__pc = 'ZIM';
        account.Highest_Qualification__pc = 'Matric';
        account.Residential_Status__pc = 'Owner';
        account.Marital_Status__pc = 'MARRIED';
        account.CASA_Risk_Status__c = 'High';
        insert account;

        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=account.id;
        opp.Site__c=siteRec.id;
        opp.CBPIndicator__c = '123456789';
        insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.id;
        app.Source_of_Funds__c = 'ALLOWANCE';
        insert app;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4048272164';
        insert oppLineItem;

        Address__c addr = new Address__c();
        addr.Shipping_Zip_Postal_Code__c = '0081';
        addr.Shipping_Street__c = 'Test';
        addr.Shipping_City__c = 'City';
        addr.Address_TYpe__c = 'Residential';
        addr.Account__c = account.Id;
        insert addr;

        Application_Product__c appProd = new Application_Product__c();
        appProd.Opportunity__c = opp.Id;
        appProd.Opportunity_Product_Id__c = oppLineItem.Id;
        insert appProd;
        
        
          Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',            
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Account relatedPartyAccount = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
			Phone = '0835002323',
			CIF__c = '',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'South Africa',
			Country_of_Residence__pc = 'South Africa',          
			ID_Number__pc = '8604254315089',
			Client_Group__c = 'Individual',            
			ID_Type__c = 'SA Identity Document',
            Countries_Traded_With__c='India',
			PersonBirthdate = Date.valueOf('1986-04-25'),
            Date_Issued__pc = Date.valueOf('2021-07-05')
		);
		insert relatedPartyAccount;
        Account relatedPartfy = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
        
        Contact relatedcntParty = 
            [SELECT Id,
             CASA_Reference_Number__c,
             CASA_Screening_Date__c,
             CASA_Screening_Status__c,
             Birthdate,
             Country_of_Birth__c,
             Source_of_Income__c,
             FirstName,
             LastName,
             ID_Number__c,
             Country_of_Residence__c,
             Nationality__c,
             Gender__c
             FROM Contact WHERE ID = :relatedPartfy.PersonContactId];
        
        relatedcntParty.ID_Number__c='6905257273088';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121238147';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
        relatedcntParty.Source_of_Income__c = 'Salary';
        relatedcntParty.OtherPhone='0897897654';
        relatedcntParty.Birthdate = date.valueof('2021-06-11');
        relatedcntParty.Country_of_Birth__c= 'South Africa';
		relatedcntParty.Country_of_Residence__c= 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
		relatedcntParty.Gender__c = 'Male';
        update relatedcntParty;
        
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = mainacc.Id;
		acr.ContactId = relatedcntParty.Id;
        acr.Control_of_Passive_Non_Financial_Entity__c = true;
        acr.Controlling_Person_is_Taxed_Outside__c = true;
		acr.Primary_Entity_Id__c = mainacc.Id;
        
		insert acr;
        
      
  
       Opportunity oppStokvel = new Opportunity();
        oppStokvel.Name = 'Test Stokvel Opp Onboarding';
        oppStokvel.CloseDate = Date.today();
        oppStokvel.StageName = 'New';
        oppStokvel.Pricebook2Id=pb.id;
        oppStokvel.AccountId=mainacc.id;
        oppStokvel.Site__c=siteRec.id;
        oppStokvel.CBPIndicator__c = '123056789';
        insert oppStokvel;        
        
        
    }

    @isTest
    public static void testCheckForInternetBanking() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_CHECK));

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        Boolean response = VASdigitalBankingController.checkForInternetBanking(opp.id);
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }
    @isTest
    public static void testEnableInternetBanking() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_UPDATE));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
       String jsonObj = '{"oppId":"' + opp.id + '","rvnCellphone":"0761234567","isAdditionalUsers":"True","numberOfAuths":"1","users" : [{"username":"test","idNumber":"9308131231234"}],"isStokvel":' + true + '}';
        String response = VASdigitalBankingController.enableInternetBanking(jsonObj);
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }
    
    @isTest
    public static void testMaintainUserDetails() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        String jsonObj = '{"oppId":"' + opp.id + '","rvnCellphone":"0761234567","isAdditionalUsers":"True","numberOfAuths":"1","users" : [{"username":"test","idNumber":"9308131231234"}],"productFamily":"Cheque"}';
        VASdigitalBankingController.InternetBankingObject details = (VASdigitalBankingController.InternetBankingObject)JSON.deserialize(jsonObj, VASdigitalBankingController.InternetBankingObject.class);
        VASdigitalBankingController.setOpportunityDetails(details.oppId);
        String response = VASdigitalBankingController.maintainUserDetails(jsonObj);
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }

    @isTest
    public static void testgetRelatedPartiesforStokvel() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_UPDATE));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Stokvel Opp Onboarding'];
        String jsonObj = '{"oppId":"' + opp.id + '","rvnCellphone":"0761234567","isAdditionalUsers":"True","numberOfAuths":"1","users" : [{"username":"test","idNumber":"9308131231234"}],"productFamily":"Cheque"}';
         List<VASdigitalBankingController.InternetBankingUsersObject> response = VASdigitalBankingController.getRelatedPartiesDetails(opp.id);
        System.assert(response.size() > 0 , 'Test Successful');
        Test.stopTest();
    }

    @isTest
    public static void testSetLimitation() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_SET));
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        String jsonObj = '{"oppId":"' + opp.id + '","rvnCellphone":"0761234567","isAdditionalUsers":"True","numberOfAuths":"1","users" : [{"username":"test","idNumber":"9308131231234"}],"isStokvel":' + true + '}';
        VASdigitalBankingController.InternetBankingObject details = (VASdigitalBankingController.InternetBankingObject)JSON.deserialize(jsonObj, VASdigitalBankingController.InternetBankingObject.class);
        VASdigitalBankingController.setOpportunityDetails(details.oppId);
        String response = VASdigitalBankingController.setLimitation();
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }

    @isTest
    public static void testSetRvnMethod() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_SET_RVN));
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
        String jsonObj = '{"oppId":"' + opp.id + '","rvnCellphone":"0761234567","isAdditionalUsers":"True","numberOfAuths":"1","users" : [{"username":"test","idNumber":"9308131231234"}],"isStokvel":' + true + '}';
        VASdigitalBankingController.InternetBankingObject details = (VASdigitalBankingController.InternetBankingObject)JSON.deserialize(jsonObj, VASdigitalBankingController.InternetBankingObject.class);
        VASdigitalBankingController.setOpportunityDetails(details.oppId);
        String response = VASdigitalBankingController.setRvnMethod(details.users[0]);
        System.assert(response != null, 'Test Successful');
        Test.stopTest();
    }
}