/*
* Test Class for InstinctRiskFraud_IH_v1 Integration Class
*
* @author Manoj Danthala : Absa
* @since   09-03-2020
*
*/
@isTest
public class InstinctRiskFraud_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"InstinctFraudCheck_XMLStringResponse":{"InstinctFraudCheck_XMLStringResult":"<?xml version=\\"1.0\\" encoding=\\"UTF-8\\"?><OutputSchema><Output><Organisation>ABS</Organisation><Country_Code>ZA</Country_Code><Group_Member_Code></Group_Member_Code><Application_Number>O-0000010360</Application_Number><Capture_Date></Capture_Date><Capture_Time></Capture_Time><Application_Type>CFTS</Application_Type><Fraud_Score>0</Fraud_Score><Fraud_Alert>C</Fraud_Alert><Action_Taken> </Action_Taken><Error_Code></Error_Code><User_Defined_Alert></User_Defined_Alert><Action_User></Action_User><Rule_Triggered_1></Rule_Triggered_1><Rule_Triggered_2></Rule_Triggered_2><Rule_Triggered_3></Rule_Triggered_3><Rule_Triggered_4></Rule_Triggered_4><Rule_Triggered_5></Rule_Triggered_5><Rule_Triggered_6></Rule_Triggered_6><Rule_Triggered_7></Rule_Triggered_7><Rule_Triggered_8></Rule_Triggered_8><Rule_Triggered_9></Rule_Triggered_9><Rule_Triggered_10></Rule_Triggered_10><Rule_Triggered_11></Rule_Triggered_11><Rule_Triggered_12></Rule_Triggered_12><Rule_Triggered_13></Rule_Triggered_13><Rule_Triggered_14></Rule_Triggered_14><Rule_Triggered_15></Rule_Triggered_15><Rule_Triggered_16></Rule_Triggered_16><Rule_Triggered_17></Rule_Triggered_17><Rule_Triggered_18></Rule_Triggered_18><Rule_Triggered_19></Rule_Triggered_19><Rule_Triggered_20></Rule_Triggered_20><Decision_Reason></Decision_Reason></Output></OutputSchema>"}}';
    public static final String NEGATIVE_RESPONSE_BODY = '{"InstinctFraudCheck_XMLStringResponse":{"InstinctFraudCheck_XMLStringResult":"<?xml version=\\"1.0\\" encoding=\\"UTF-8\\"?><OutputSchema><Output><Organisation>ABS1</Organisation><Country_Code></Country_Code><Group_Member_Code></Group_Member_Code><Application_Number></Application_Number><Capture_Date></Capture_Date><Capture_Time></Capture_Time><Application_Type></Application_Type><Fraud_Score></Fraud_Score><Fraud_Alert></Fraud_Alert><Action_Taken> </Action_Taken><Error_Code>01</Error_Code><User_Defined_Alert></User_Defined_Alert><Action_User></Action_User><Rule_Triggered_1></Rule_Triggered_1><Rule_Triggered_2></Rule_Triggered_2><Rule_Triggered_3></Rule_Triggered_3><Rule_Triggered_4></Rule_Triggered_4><Rule_Triggered_5></Rule_Triggered_5><Rule_Triggered_6></Rule_Triggered_6><Rule_Triggered_7></Rule_Triggered_7><Rule_Triggered_8></Rule_Triggered_8><Rule_Triggered_9></Rule_Triggered_9><Rule_Triggered_10></Rule_Triggered_10><Rule_Triggered_11></Rule_Triggered_11><Rule_Triggered_12></Rule_Triggered_12><Rule_Triggered_13></Rule_Triggered_13><Rule_Triggered_14></Rule_Triggered_14><Rule_Triggered_15></Rule_Triggered_15><Rule_Triggered_16></Rule_Triggered_16><Rule_Triggered_17></Rule_Triggered_17><Rule_Triggered_18></Rule_Triggered_18><Rule_Triggered_19></Rule_Triggered_19><Rule_Triggered_20></Rule_Triggered_20><Decision_Reason></Decision_Reason></Output></OutputSchema>"}}';

    /**
    * @description test data
    **/
    @TestSetup
    static void makeData(){
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{InstinctRiskFraud_IH_v1.INTEGRATION_SERVICE_NAME});
    	
		Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CASA_Screening_Status__c = 'Cancelled';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        //account.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
		insert account;
        
        
        //insert related acct;
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.CASA_Reference_Number__pc = '12454' ;
        acctSecondary.CASA_Screening_Status__pc = 'Matched';
        insert acctSecondary;        
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
        insert accConRel;
        acrList.add(accConRel);
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            relatedPartIdSet.add(acr.ContactId);
        }
        
        Account account2 = new Account(Name = 'Test Account2');
		account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
		account2.Country_of_Incorporation__c = 'South Africa';
		account2.Client_Group__c = 'Non Individual';
		account2.Client_Type__c = 'Private Company';
		account2.CASA_Reference_Number__c = '12233';
		account2.CIF__c = '';
		account2.Countries_Traded_With__c = 'South Africa';
		account2.Source_of_Income__c = 'Donation';
        //account2.UBO_ParentAccountWrapper__c = '[{"Type":"Private Company","ShareholderCount":3,"Shareholder":"PASCAL SOLUTIONS (PTY) LTD","recordId":"0015r00000Ht2mtAAB","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"GAMBULELA TRADING (PTY) LTD","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYE78AAH","recordId":"a005r000001u7LyAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Director;Individual with Authority to Act;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users);Manager","relatedAccountId":"0035r00000C2V0PAAV","recordId":"5r000002QR7cAAG","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":10.00,"parentAccountId":"0015r00000EYE78AAH","idType":"SA Identity Document","Controllinginterest":2.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Greyling Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000EYC4QAAX","recordId":"a005r000001b3GJAAY","primaryEntityId":"0015r00000EYE78AAH","ParentShareholding":90.00,"parentAccountId":"0015r00000EYE78AAH","idType":"Non-Registered Entity","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"GANAS SOOBRAMONY NAIDU","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C1GWKAA3","recordId":"07k5r000002QQTtAAO","primaryEntityId":"0015r00000EYB8FAAX","ParentShareholding":80.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"SA Identity Document","Controllinginterest":18.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"HFR Properties KZN (pty )Ltd","roles":"Trustees","relatedAccountId":"0015r00000HtjKwAAJ","recordId":"a005r000001u7M3AAI","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000EYC4QAAX","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Named Beneficiaries","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FVZFAA4","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Capolie Botha Eiendomme (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtmrpAAB","recordId":"a005r000001u7MDAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000HtjKwAAJ","idType":"Registration Number","Controllinginterest":22.50,"childwrplist":[{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"Test Light (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Ht94NAAR","recordId":"a005r000001u7MIAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnpIAAS","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":60.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Passport","Controllinginterest":6.75,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Trusts","ShareholderCount":2,"Shareholder":"Mara Trust","roles":"Shareholder/Controller","relatedAccountId":"0015r00000HtrEtAAJ","recordId":"a005r000001u7MSAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000Ht94NAAR","idType":"Non-Registered Entity","Controllinginterest":5.62,"childwrplist":[{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"JOHANNES HENDRIK BESTER","roles":"Named Beneficiaries","relatedAccountId":"0035r000009TLRHAA4","recordId":"07k5r000004FKs8AAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"},{"UBO":"No","Type":"Individual","ShareholderCount":0,"Shareholder":"HEIDI MICHELLE WENKE","roles":"Named Beneficiaries","relatedAccountId":"0035r00000DWT7zAAH","recordId":"07k5r000004FKscAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":25.00,"parentAccountId":"0015r00000HtrEtAAJ","idType":"SA Identity Document","Controllinginterest":1.41,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":2,"Shareholder":"REcord Hut (Pty) LTd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000Hns30AAB","recordId":"a005r000001u7MNAAY","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":50.00,"parentAccountId":"0015r00000HtmrpAAB","idType":"Registration Number","Controllinginterest":11.25,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"DANISILE DERRICK MBALO","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FNDlXAAX","recordId":"07k5r000004FSneAAG","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":100.00,"parentAccountId":"0015r00000Hns30AAB","idType":"SA Identity Document","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"Mara Mahlatse","roles":"Shareholder/Controller","relatedAccountId":"0035r00000FMe1oAAD","recordId":"07k5r000004FnGpAAK","primaryEntityId":"0015r00000EYC4QAAX","ParentShareholding":40.00,"parentAccountId":"0015r00000Hns30AAB","idType":"Passport","Controllinginterest":11.25,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"","Type":"Private Company","ShareholderCount":1,"Shareholder":"Test Complex Structure (Pty) Ltd","roles":"Shareholder/Controller","relatedAccountId":"0015r00000DmDe9AAF","recordId":"a005r000001u7SpAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Trusts","ShareholderCount":1,"Shareholder":"BOTHA FAMILY TRUST","roles":"Shareholder/Controller","relatedAccountId":"0015J00000F06smQAB","recordId":"a005r000001u9LnAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000DmDe9AAF","idType":null,"Controllinginterest":25.00,"childwrplist":[{"UBO":"","Type":"Close Corporation","ShareholderCount":2,"Shareholder":"Two stone Gardening services cc","roles":"Named Beneficiaries","relatedAccountId":"0015r00000HuCsaAAF","recordId":"a005r000001u9LsAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015J00000F06smQAB","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"NTEMBEKO NTANTISO MAKALIMA","roles":"Members/Controllers","relatedAccountId":"0035r00000C2V0PAAV","recordId":"07k5r000004FkojAAC","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":30.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"SA Identity Document","Controllinginterest":32.50,"childwrplist":null,"accType":"AccountContact"},{"UBO":"","Type":"Close Corporation","ShareholderCount":1,"Shareholder":"P and D Trading CC","roles":"Members/Controllers","relatedAccountId":"0015r00000HuCokAAF","recordId":"a005r000001u9LxAAI","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCsaAAF","idType":"Registration Number","Controllinginterest":25.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"A Burgess","roles":"Members/Controllers","relatedAccountId":"0035r00000FNDbMAAX","recordId":"07k5r000004FSjFAAW","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":100.00,"parentAccountId":"0015r00000HuCokAAF","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"}],"accType":"AccountAccount"},{"UBO":"Yes","Type":"Individual","ShareholderCount":0,"Shareholder":"FRANCOIS MARIO WOLVAARDT","roles":"Director;Shareholder/Controller;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)","relatedAccountId":"0035r00000FMaS4AAL","recordId":"07k5r000004FAwoAAG","primaryEntityId":"0015r00000Ht2mtAAB","ParentShareholding":25.00,"parentAccountId":"0015r00000Ht2mtAAB","idType":"SA Identity Document","Controllinginterest":25.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"Account"}]';
		
		insert account2;
        
        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
		resRole.FinServ__CreateInverseRole__c = true;
		resRole.FinServ__InverseRole__c = 'Director';
		insert resRole;

		FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
			FinServ__Account__c = account.Id,
			FinServ__RelatedAccount__c = account2.Id,
			Roles__c = 'Shareholder/Controller',
			FinServ__Role__c = resRole.id,
			Primary_Entity_Id__c = account.Id,
			Shareholding_Percentage__c = 0
		);
		insert accAccRel;

        String json1 = '[{"Type":"PrivateCompany","ShareholderCount":4,"Shareholder":"LONDANICOAL(PTY)LTD","recordId":"0015r00000HvTN3AAN","ParentShareholding":100,"Controllinginterest":100,"Accwrplist":[{"UBO":"","Type":"CentralBankorRegulator","ShareholderCount":3,"Shareholder":"PINEAPPLECENTRALBANKANDREG","roles":"Director;IndividualwithAuthoritytoAct;Shareholder/Controller","relatedAccountId":"0015r00000HJk9qAAD","recordId":"a005r000001uMlTAAU","primaryEntityId":"0015r00000HvTN3AAN","ParentShareholding":20.00,"parentAccountId":"0015r00000HvTN3AAN","idType":"RegistrationNumber","Controllinginterest":20.00,"childwrplist":[{"UBO":"Yes","Type":"Individual","ShareholderCount":50,"Shareholder":"FANTAFANTA","roles":"Director;Shareholder/Controller","relatedAccountId":"0035r00000EccagAAB","recordId":"';
        String json2 = '","primaryEntityId":"0015r00000HJk9qAAD","ParentShareholding":60.00,"parentAccountId":"0015r00000HJk9qAAD","idType":"SAIdentityDocument","Controllinginterest":12.00,"childwrplist":null,"accType":"AccountContact"}],"accType":"AccountAccount"}],"accType":"Account"}]';
        account.UBO_ParentAccountWrapper__c = json1 + accConRel.Id + json2;
        update account;
        
        account2.UBO_ParentAccountWrapper__c = json1 + accAccRel.Id + json2;
        update account2;
        
		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.SiteCode__c = '4531';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = account.Id;
        insert testOpp;		
        
        Integration_Translation__c translations = new Integration_Translation__c();
        translations.External_Value__c = 'C';
		translations.Internal_Value__c = 'Clean';
        translations.System_Name__c = 'Fraud Risk';
        translations.Value_Type__c = 'Fraud Risk Alert';
        translations.Direction__c = 'Outbound';
        insert translations;
    }
    /**
    * @description positive test
    **/
    @isTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
            InstinctRiskFraud_Res_IB_v1 responseBean = callHandlerMethod();
            System.assertEquals(200, responseBean.statusCode);
        
          	Opportunity testOpp = [SELECT Id,Name,AccountId,CreatedDate,Opportunity_Number__c,SiteCode__c from Opportunity where Name='Test Opp'];
        	OnboardingFraudRiskController.callFraudRiskScreening(testOpp.id);
        	OnboardingFraudRiskController.getOpportunityData(testOpp.id);
        Test.stopTest();
    }

    /**
    * @description negative test
    **/
    @isTest
    static void testNegative() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.NEGATIVE_STRING, NEGATIVE_RESPONSE_BODY));

        Test.startTest();
            InstinctRiskFraud_Res_IB_v1 responseBean = callHandlerMethod();
            System.assertNotEquals(200, responseBean.statusCode);
        
          	Opportunity testOpp = [SELECT Id,Name,AccountId,CreatedDate,Opportunity_Number__c,SiteCode__c from Opportunity where Name='Test Opp'];
        	OnboardingFraudRiskController.callFraudRiskScreening(testOpp.id);
        	OnboardingFraudRiskController.getOpportunityData(testOpp.id);
        Test.stopTest();
    }

    /**
    * @description 
    * @return InstinctRiskFraud_Res_IB_v1 
    **/
    private static InstinctRiskFraud_Res_IB_v1 callHandlerMethod() {
        
        Opportunity testOpp = [SELECT Id,Name,AccountId,CreatedDate,Opportunity_Number__c,SiteCode__c, ExecutionLayerRequestID_Text__c from Opportunity where Name='Test Opp'];
        
        InstinctRiskFraud_Res_IB_v1 responseBean = InstinctRiskFraud_IH_v1.InstinctRiskFraud(testOpp);
        return responseBean;
    }

}