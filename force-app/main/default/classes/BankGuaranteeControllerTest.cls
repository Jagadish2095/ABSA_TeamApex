/*
* Test Class For BankGuaranteeController
* @author  Himani Joshi: Absa
* @version v1.0
* @since   2021-05-25
*
*/

@IsTest
public class BankGuaranteeControllerTest {
    @testSetup static void createData(){
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
        
    }
    @isTest static void testgetBankGuarantees(){
        Opportunity opp=[select Id from Opportunity];
        system.assertNotEquals(null, opp);
        List<Application_Financial_Account__c>appFinList=[select ClientCode__c,Application__c,Facility_account_number__c,Facility_limit__c,Product__c,Review_date__c,Total_Contract_Balance__c,Requested_facility_limit__c,Requested_review_date__c from Application_Financial_Account__c ];
        List<Application_Product__c>appProd=[select Id,Temp_Account_Number__c,Facility_limit__c,Facility_review_date__c,Product_State__c,Opportunity__c from Application_Product__c where Product_State__c='New'];
        
        List<Contract__c>conList=[select Id from contract__c];
        test.startTest();
        Map<String,List<sobject>>getResponse=BankGuaranteeController.getExistingAccounts(opp.Id);
        List<Map<String, String>>getManagedLDP=BankGuaranteeController.getManagedLDPAccounts(opp.Id);
        Application_Product__c app=BankGuaranteeController.getApplicationProducts(opp.Id);
        Boolean response=BankGuaranteeController.saveClass(appFinList, appProd, conList, opp.Id);
        Boolean deletion=BankGuaranteeController.deleteManagedAccount(appFinList[0].Id);
        List<Application_Product__c> newAccounts=BankGuaranteeController.getNewAccounts(opp.Id);
        List<Contract__c> getUpdatedContracts=BankGuaranteeController.getUpdatedCon(conList[0].Id,true,opp.Id);
        test.stopTest();
    }

}