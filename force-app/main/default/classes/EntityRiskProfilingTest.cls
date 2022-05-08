/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-09-28
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         HAppy                                Modification
 * 1.0   03-18-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

@isTest
public class EntityRiskProfilingTest {
    private static Account getstokvelTestAccount() {
        Account account = new Account();

        account.FirstName = '';
        account.LastName = 'Stokweni stokvel';
        account.ID_Type__pc = '';
        account.ID_Number__pc = '';
        account.Client_Group__c = 'Non Individual';
        account.PersonBirthdate = null;
        account.Nationality_List__pc = 'South African';
        account.Country_of_Residence__pc = 'South Africa';
        account.Country_of_Birth__pc = 'South Africa';

        account.CASA_Reference_Number__pc = '' ;
        account.Occupation_Category__pc = 'Advertising';
        account.Occupation_Status__pc = '' ;
     
        List<String> selectOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Schema.Account.Source_of_Income__pc.getDescribe();
        account.Source_of_Income__pc = fieldResult.getPicklistValues()[0].getValue();

        insert account;
        return account;
    }  
    
    private static AccountContactRelation relatedPartyAccount() {
        Account relatedPartyAccount = new Account(FirstName = 'Phukubyane', LastName = 'Pjane',Phone = '0835002323', CIF__c = 'AubreP009',
		CASA_Reference_Number__c= '121229159',
		Nationality__pc ='South Africa',
		Country_of_Residence__pc ='South Africa',
		ID_Number__pc ='8604254315089', Client_Group__c='Individual', ID_Type__c= 'SA Identity Document',PersonBirthdate = Date.valueOf('1986-04-25'));
		insert relatedPartyAccount;
        
        Account account = GetstokvelTestAccount();
        Account relatedParty = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = account.Id;
		acr.ContactId = relatedParty.PersonContactId;
		acr.Primary_Entity_Id__c = account.Id;
		
        insert acr;
        return acr;
     }
    
    
    public static final String POSITIVE_RESPONSE_BODY = '{"headers":{"X-Backside-Transport":["OK OK"],"Connection":["Keep-Alive"],"Transfer-Encoding":["chunked"],"X-Powered-By":["Servlet/3.1"],"Content-Type":["application/json; charset=UTF-8"],"Content-Language":["en-US"],"Date":["Mon, 07 Dec 2020 10:13:34 GMT"],"Expires":["Thu, 01 Dec 1994 16:00:00 GMT"],"Cache-Control":["no-cache=\"set-cookie, set-cookie2\""],"X-Global-Transaction-ID":["1cf73a895fce004ec67f67ad"],"Access-Control-Expose-Headers":["APIm-Debug-Trans-Id, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-Global-Transaction-ID"],"Access-Control-Allow-Origin":["*"],"Access-Control-Allow-Methods":["POST"],"Set-Cookie":["LtpaToken2=\"\"; Expires=Thu, 01 Dec 1994 16:00:00 GMT; Path=/; Secure; HttpOnly","LtpaToken2=Qq0mFXVDnbh6/7BhhI1hjCV3+KnusyxFT6nT9aNiNwPjXvFB1HEeJTvzVTRRGtOqD4pg1f1xn1eJiWYxrydSiazSk+XWFqmvcCr8xvqefLZMQoxOHYt5dgUVHzo8YnsmiB3hqow3mU5/izpXvJtFzYboBgQVqsj0IUH2jlvPhsNKutTVe1aCuPnHyAIqvsVx0eDEuFpEUxyrFQGGAbrub8cASWpcAllj6vAV/A1FeIA0H6fBxopcWkj97uAodN0BMMtD+GZhCUN7jUaO4pbcVJXtEPhprfJnq8rJm7PzNs2xPwHw8Ah9x3W3JUuD+MuV; Path=/; HttpOnly"],"X-RateLimit-Limit":["name=100 Per Minute,100;"],"X-RateLimit-Remaining":["name=100 Per Minute,99;"]},"body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":""}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":0,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"DUPLICATE PROFILE EXITS","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}';
    
    @isTest
    public static void testStokvelEntityRiskProfiling(){
        Account relatedPartyAccount = new Account(FirstName = 'Phukubyane', LastName = 'Pjane',Phone = '0835002323', CIF__c = 'AubreP009',
		CASA_Reference_Number__c= '121229159',
		Nationality__pc ='South Africa',
		Country_of_Residence__pc ='South Africa',
		ID_Number__pc ='8604254315089', Client_Group__c='Individual', ID_Type__c= 'SA Identity Document',PersonBirthdate = Date.valueOf('1986-04-25'));
		insert relatedPartyAccount;
        
        Account account = GetstokvelTestAccount();        
        Account relatedParty = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
         Contact relatedcntParty = [SELECT Id  FROM Contact WHERE ID = :relatedParty.PersonContactId];
        relatedcntParty.ID_Number__c='12121212121212';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121212';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
        relatedcntParty.Birthdate = date.valueof('2021-06-11');
        relatedcntParty.Country_of_Birth__c= 'South Africa';
		relatedcntParty.Country_of_Residence__c= 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
        relatedcntParty.Occupation_Category__c= 'account';
		relatedcntParty.Gender__c = 'Male';
        relatedcntParty.Occupation_Category__c = 'Account';
        update relatedcntParty;
        
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = account.Id;
		acr.ContactId = relatedParty.PersonContactId;
		acr.Primary_Entity_Id__c = account.Id;		
        insert acr;
        Integration_Translation__c returnValues = new Integration_Translation__c(
			External_Value__c = '02',
			Value_Type__c = 'Occupation Category',
			Internal_Value__c = 'Account',
			System_Name__c = StringConstants.ECASA_STRING,
			Direction__c = 'Outbound'
		);
		insert returnValues;

        Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '09050');
		insert savingsprod;

		PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPrice;

		Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
		salesProcess.Request_Name__c = 'CAF Application';
		salesProcess.Name = 'stokvel Application';
		salesProcess.Opportunity_Record_Type__c = 'CAF Application';
		insert salesProcess;
		site__c siteRec = new site__c();
		siteRec.Site_Code__c = '1334';
		siteRec.Name = 'Test';
		insert siteRec;

		Opportunity savingsOpportunity = new Opportunity();
		savingsOpportunity.Name = 'Test Savings Onboarding';
		savingsOpportunity.CloseDate = Date.today();
		savingsOpportunity.StageName = 'New';
		savingsOpportunity.Pricebook2Id = pb.id;
		savingsOpportunity.AccountId = account.id;
		savingsOpportunity.Site__c = siteRec.id;
		savingsOpportunity.CBPIndicator__c = '123456789';
		insert savingsOpportunity;

		OpportunityLineItem savingsLineItem = new OpportunityLineItem();
		savingsLineItem.OpportunityId = savingsOpportunity.id;
		savingsLineItem.Product2Id = savingsprod.id;
		savingsLineItem.PricebookEntryId = savingsPrice.id;
		//savingsLineItem.Product_Name__c = 'savinfn';
		savingsLineItem.Quantity = 1;
		savingsLineItem.TotalPrice = 100;
		savingsLineItem.Policy_Number__c = '9051159122';
		insert savingsLineItem;
         Opportunity opp= [SELECT Id FROM Opportunity WHERE name = 'Test Savings Onboarding']; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        String resp = EntityRiskProfiling.getEntityRiskProfiling(account.Id,opp.id);
        System.assert(resp!= '', 'assert failed');
        Test.stopTest();
    }   
}