/**
 * @description       :
 * @author            : Almas.Aleem@absa.africa
 * @last modified on  : 2021-07-13
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-07-13   Almas.Aleem@absa.africa   Initial Version
**/
@isTest
public class AuthorizedUsersControllerTest {
    @testSetup
    static void dataCreation() {
        insertUser();

        Account account = new Account();
        account.Name = 'Test Account001';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;

        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact;

        Opportunity oppCovid = new Opportunity();
        oppCovid.Name = 'Covid Onboarding';
        oppCovid.CloseDate = Date.today();
        oppCovid.StageName = 'New';
        oppCovid.AccountId = account.Id;
        insert oppCovid;

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppCovid.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;

        Application__c  appcovid = new Application__c();
        appcovid.Opportunity__c = oppCovid.id;
        appcovid.Title__c = 'Dr';
        appcovid.FirstNameSignature__c = 'Rob';
        appcovid.SurnameSignature__c = 'Robbello';
        appcovid.Signing_Date__c = System.today();
        insert appcovid;

        String abfupdateStatusResponse= '{"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": [{"msgClass": "PLSMGC01","msgCode": "0020","msgErrInd": "E","msgTxt": "Account status is invalid"}]},"plpa03o": {"mandateNbr": "0","contractSignedInd": null,"contractSignIndUpdbl": null,"payMethodReqInd": null,"cessionPledgeInd": null,"autoSettlementInd": null,"autoSettleIndUpdbl": null,"creditLifeInd": null,"creditLifeIndUpdbl": null,"landlordWaiverInd": null,"insuranceInd": null,"elecTransferInd": null,"elecTransferIndUpdbl": null}}';

        Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = oppCovid.id;
        apcCovid.Opportunity__c = oppCovid.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.Account_Number__c = Long.valueOf('3001537899');
        apcCovid.IsMainProduct__c = true;
        apcCovid.ABFupdAccountDetails_Response__c = abfupdateStatusResponse;
        insert apcCovid;

        BusinessHours bh = [SELECT Id, Name FROM BusinessHours where Name = '24 Hours including Public Holidays'];
        User u = [SELECT Id, UserRoleId FROM User LIMIT 1];

        Case caseRec = new Case();
        caseRec.BusinessHoursId = bh.Id;
        caseRec.Subject = 'Test Case';
        caseRec.AccountId = account.Id;
        caseRec.Banker_RE__c = u.UserRoleId;
        caseRec.ContactId=testContact.Id;
        caseRec.Application_Product_Id__c = apcCovid.Id;

        insert caseRec;
    }

    @future
    private static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
        UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];

        User futureUser = new User(
            ProfileId = p.Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            SiteCode__c = '8198',
            SiteType__c = '034',
            Teller_Operator_Code__c = '12345',
            Supervisor__c = '0',
            Division__c = 'RBB',
            UserRoleId = r.Id
        );
        insert(futureUser);
    }

    @isTest
    static void testCalculations() {
        Account account1 = new Account();
        account1.Name = 'Test Account0011';
        account1.Client_Type__c = 'Private Individual';
        account1.CIF__c = 'Test+020';
        insert account1;

        Opportunity oppCovid1 = new Opportunity();
        oppCovid1.Name = 'Covid Onboarding';
        oppCovid1.CloseDate = Date.today();
        oppCovid1.StageName = 'New';
        oppCovid1.AccountId = account1.Id;
        insert oppCovid1;


        Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = oppCovid1.id;
        apccovid.Product_Name__c = 'Credit Card';
        apcCovid.Opportunity__c = oppCovid1.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.Account_Number__c = Long.valueOf('3001537899');
        apcCovid.IsMainProduct__c = true;

        List<Application_Product__c> appProd = new List<Application_Product__c>();
        appProd.add(apcCovid);
        insert appProd;

        Application__c  appcovid = new Application__c();
        appcovid.Opportunity__c = oppCovid1.id;
        appcovid.Title__c = 'Dr';
        appcovid.FirstNameSignature__c = 'Rob';
        appcovid.SurnameSignature__c = 'Robbello';
        appcovid.Signing_Date__c = System.today();
        insert appcovid;

        Test.startTest();
            Account accRecord = new account();
            accRecord.Name = 'Test Acc1114';
            insert accRecord;

            Account accRecord2 = new account();
            accRecord2.Name = 'Test Acc2';
            insert accRecord2;

            contact conRecord = new contact();
            conRecord.AccountId = accRecord2.id;
            conrecord.lastname = 'TestCon1114';
            conrecord.firstname = 'Iam';
            insert conRecord;
            AccountContactRelation acr = new AccountContactRelation();
            acr.Accountid = oppCovid1.accountid;
            acr.Contactid = conRecord.id;
            acr.Roles = 'Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
            acr.Share_Percentage__c = 66;
            insert acr;
            AuthorizedUsersController.getRelatedParties(oppCovid1.Id,apcCovid.Id);
            AuthorizedUsersController.authorizedUsersWrapper authrec =  new AuthorizedUsersController.authorizedUsersWrapper();
            authrec.AccountId = accRecord2.id;
            authrec.FName = acr.Contact.FirstName+' '+acr.Contact.LastName;
            authrec.ClientCode = acr.contact.account.cif__c;
            authrec.Passport = acr.Contact.Account.ID_Number__pc != null ? acr.Contact.Account.ID_Number__pc : acr.Contact.Account.Passport_Number__pc != null ? acr.Contact.Account.Passport_Number__pc : acr.Contact.Account.Registration_Number__c != null ? acr.Contact.Account.Registration_Number__c : null;
            authrec.CASA = acr.contact.account.CASA_Reference_Number__pc;
            authrec.AppProductId = apcCovid.id;
            authrec.NameCard = authrec.FName;
            authrec.AccountId = acr.Contact.AccountId;
            authrec.label = authrec.FName;
            authrec.value = acr.Id;
            authrec.ActionRequired = 'New';
            authrec.NameCard =  'abc';
            authrec.CreditLimit = 1000;
            authrec.FacilityRequired = 'Aviation';

            authrec.BranchName = 'abc branch';

            authrec.ClientType = 'Absa Staff';
            authrec.CardType = 'New Card';
            authrec.AircraftRegNo = '87654';
            authrec.Designation = 'ACCOUNTANT';
            authrec.DeliveryMethodValue = 'To another address';

            authrec.DeliveryAddressLine1 = 'ac';
            authrec.DeliveryAddressLine2 = 'bc';
            authrec.DeliveryAddressSuburb = 'dc';
            authrec.DeliveryAddressTown = 'ef';
            authrec.DeliveryAddressPostalCode = 'gh';
            authrec.DeliveryAddressCountry = 'country';
            authrec.ids=acr.id;
            AuthorizedUsersController.saveAuthorizedUsers(authrec, oppCovid1.id);
            System.assert(AuthorizedUsersController.getRelatedParties(oppCovid1.Id,apcCovid.Id) != null, true);
        Test.stopTest();
    }
}