/*
 * Test class for BGProductApplicationController
 * @author  Himani Joshi: Absa
 * @version v1.0
 * @since   2021-09-06
 *
 */
@IsTest
public class BGProductApplicationControllerTest {

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
        Application_Product__c ApplicationRecord = new Application_Product__c();
        ApplicationRecord.Opportunity__c = opp.Id;
        ApplicationRecord.Product_Name__c = 'Bank Guarantee';
        ApplicationRecord.Opportunity_Product_Id__c = opp.Id;
        ApplicationRecord.Documents_Required__c = 'Absa 4012';
        insert ApplicationRecord;
    }
    @isTest static void testgetgenerateProdWrapper(){
        string prodWrap='{"additionalFields":[{"dueFeesFirstSixMonths":"3","dueFeesSecondSixMonths":"4","establishmentAmount":"2","minAmount":"1"},{"dueFeesFirstSixMonths":"7","dueFeesSecondSixMonths":"8","establishmentAmount":"6","minAmount":"5"}],"agreementCompletion":"Absa 4012","amendments":"hh","amountIncrease":"gg","appReference":"fre","cancellations":"ff","capacity1":"ccc","capacity2":"ddd","casaReference":"121211107","claims":"jj","clientRep1":"hg","clientRep2":"drsr","contractNo":"7351782098","debitAccNo":"1111","escapeClause":"","expiryDate":"2021-08-03","expiryEvent":"event","goodsDescription":"tre","guaranteeAmount":"20","guaranteeIssued1":"In writing","guaranteeType":"JBCC CONSTRUCTION GUARANTEE","proddate":"2021-08-30","reIssueGuarantees":"ii","termExtension":"ee","variablemap":[{"accountNo":"101","accountType":"savings","addressLine1":"123","beneficiaryName":"mani1","clearingCode":"ccc","country":"Antarctica","postalCode":"201","suburb":"re","town":""},{"accountNo":"current","accountType":"current","addressLine1":"567","beneficiaryName":"mani2","clearingCode":"dddd","country":"Armenia","postalCode":"708","suburb":"tre"}],"signaturesVerified":"HJ","approvedAmount":"200","authorisedBy":"KK","forAttentionOf":"MM","emailAddress":"himani.joshi@gmail.com","clientCode":"123","clientCodeIncome":"456","sourceOfFunds":"Retirement Annuity"}';
        Opportunity opp=[select Id from Opportunity];
        Application_Product__c appProduct=[select Id from Application_Product__c where Opportunity_Product_Id__c=:opp.Id ];
        system.assertNotEquals(null, opp);
        test.startTest();
        BGProductApplicationController.generateProdWrapper(opp.Id,'Absa 4012'); 
        BGProductApplicationController.returnProdId(opp.Id,'Absa 4012');
        BGProductApplicationController.saveBGProduct(prodWrap,appProduct.Id);
        BGProductApplicationController.addNewProduct(prodWrap,1,appProduct.Id);
        BGProductApplicationController.addAdditionalFields(prodWrap,1, appProduct.Id);
        BGProductApplicationController.getCountriesList();
        test.stopTest();
    }
}