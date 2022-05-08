/**
* @description CaseExistingLDPControllerTest Description
*
*/
@isTest
public class CaseExistingLDPControllerTest{
    @testSetup
    static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account();
        account.Name = 'Absa Bank';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c='1990/011515/23';
        insert account;
        Opportunity opp = new Opportunity();
        opp.AccountId=account.Id;
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        application.Accounts_Orchestration_JSON__c='{"statusCode":200,"status":"OK","message":null,"Fault":null,"LDPgetAccountInfoV2Responses":[{"LDPgetAccountInfoV2Response":{"nbsapdpo":{"version":null,"serviceVersion":null,"returnCode":"0","reasonCode":"0","echoKey":null},"ld300a3o":{"recordNumber1":"NaN","recordIde":null,"recordId":"D","numberOfContracts":"1","errorNumber":"NaN","errorLine3":null,"errorLine2":null,"errorLine1":null,"contractData":[{"contractSubProduct":"GAR","contractProdType":"2","contractProdCode":"2","contractNumber":"30440109881","contractExpiryDate":"0001-01-01","contractBalance":"22270","contractAmount":"22270"}],"clientCode":"EAEROSP006","accountTotReviewDate":"2002-07-30","accountTotLimit":"0","accountTotExpiryDate":"2002-07-30","accountTotBalance":"22270","accountNumber":"6900028770"}}},{"LDPgetAccountInfoV2Response":{"nbsapdpo":{"version":null,"serviceVersion":null,"returnCode":"0","reasonCode":"0","echoKey":null},"ld300a3o":{"recordNumber1":"NaN","recordIde":null,"recordId":"E","numberOfContracts":"NaN","errorNumber":"NaN","errorLine3":null,"errorLine2":null,"errorLine1":null,"contractData":null,"clientCode":"001000002N","accountTotReviewDate":null,"accountTotLimit":"NaN","accountTotExpiryDate":null,"accountTotBalance":"33645300000000","accountNumber":"NaN"}}},{"LDPgetAccountInfoV2Response":{"nbsapdpo":{"version":null,"serviceVersion":null,"returnCode":"0","reasonCode":"0","echoKey":null},"ld300a3o":{"recordNumber1":"NaN","recordIde":null,"recordId":"D","numberOfContracts":"1","errorNumber":"NaN","errorLine3":null,"errorLine2":null,"errorLine1":null,"contractData":[{"contractSubProduct":"LU","contractProdType":"2","contractProdCode":"2","contractNumber":"899300018","contractExpiryDate":"0001-01-01","contractBalance":"4000","contractAmount":"4000"}],"clientCode":"EAEROSP006","accountTotReviewDate":"2002-07-30","accountTotLimit":"0","accountTotExpiryDate":"2002-07-30","accountTotBalance":"4000","accountNumber":"18000383364"}}}],"CQgetBasicAcctDetailsV7Responses":null,"CAgetCassACSBEnqV1Responses":null,"ABFvalAutosettlementAccountV1Responses":null,"ABFgetGeneralDetailsV2Responses":null,"ABFgetBasicDetailsV1Responses":null}';
        Insert application;
        Application_Financial_Account__c fin=new Application_Financial_Account__c();
        fin.ClientCode__c='EAEROSP006';
        fin.Application__c=application.Id;
        fin.Facility_account_number__c='18000383364';
        fin.Facility_limit__c='0';
        fin.Product__c='Bank Guarantee';
        fin.Total_Contract_Balance__c='4000';
        fin.Review_date__c=Date.newInstance(2002,07,30);
        fin.Requested_facility_limit__c='6000';
        fin.Requested_review_date__c=Date.today();
        fin.isSelected__c=false;
        insert fin;
        Contract__c con=new Contract__c();
        con.Application_Financial_Account__c=fin.Id;
        con.Contract_amount__c=4000;
        con.Contract_balance__c='4000';
        con.Contract_number__c='899300018';
        con.Contract_sub_product_code__c='LU';
        con.Contract_type__c='2';
        insert con;
        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Product_Name__c='Bank Guarantee';
        testAppProdCred.Facility_account_number__c=fin.Facility_account_number__c;
        testAppProdCred.Product_State__c='Existing';
        testAppProdCred.Opportunity__c=opp.Id;
        testAppProdCred.Opportunity_Product_Id__c=opp.Id;
        //testAppProdCred.RecordId__c='a2p5r0000008Ud5AAE';
        testAppProdCred.RecordId__c=fin.Id;
        insert testAppProdCred;
        Application_Product__c testAppProdCred1 = new Application_Product__c();
        testAppProdCred1.Product_Name__c='Bank Guarantee';
        //testAppProdCred1.Facility_account_number__c=fin.Facility_account_number__c;
        testAppProdCred1.Product_State__c='New';
        testAppProdCred1.Opportunity__c=opp.Id;
        testAppProdCred1.Opportunity_Product_Id__c=opp.Id;
        //testAppProdCred1.RecordId__c='a2p5r0000008Ud5AAE';
        insert testAppProdCred1;
        
        Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', Account = account, Email__c = 'test@test.com', recordTypeId = caseRecordTypeMap.get('CAF_Application').getRecordTypeId(), Subject = 'test', Description = 'test', Expectation_of_the_Customer__c = 'test', Incident_Date__c = date.today(),Application_Product_Id__c=testAppProdCred.Id,opportunity__c=opp.Id);
        insert caseRec;
    }
    
    @isTest
    public static void fetchLDPinfoTest(){
        Case cs = [Select Id, Opportunity__c, Application_Product_Id__c
                   from Case
                   LIMIT 1];
        
        test.startTest();
        system.assertNotEquals(null, CaseExistingLDPController.fetchLDPinfo(cs.Id));
        List<Map<String, String>>getManagedLDP=CaseExistingLDPController.getManagedLDPAccounts(cs.Id);
        test.stopTest();
        
        
    }
    @isTest
    public static void fetchLDPinfoTest1(){
        Case cs = [Select Id, Opportunity__c, Application_Product_Id__c
                   from Case
                   LIMIT 1];
        
        Application_Financial_Account__c csP = [Select Product__c
                                                from Application_Financial_Account__c where Product__c = 'Bank Guarantee'
                                                LIMIT 1];
       
        csp.Product__c = '';
        update csp;
        test.startTest();
        system.assertNotEquals(null, CaseExistingLDPController.fetchLDPinfo(cs.Id));
        test.stopTest();
        
    }
}