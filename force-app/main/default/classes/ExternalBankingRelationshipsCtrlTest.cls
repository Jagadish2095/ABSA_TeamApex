/**
 * @description       : test class for ExternalBankingRelationshipsCtrl
 * @author            : englarmerdge.mongwe@absa.africa
 * @last modified on  : 2021-06-10
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-06-10   englarmerdge.mongwe@absa.africa   Initial Version
**/
@IsTest
public class ExternalBankingRelationshipsCtrlTest {

    /**
     * @description : data creation for test methods
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
    **/
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
     * @description : test method for GetAllExtBankRelations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
    **/
    @IsTest
    public static void testGetAllExtBankRelations() {

        Test.startTest();
        Opportunity opportnity = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Map<String,Object> mapExtRela = ExternalBankingRelationshipsCtrl.getAllExtBankRelations(opportnity.Id);
        Test.stopTest();

        System.assert(!mapExtRela.isEmpty(), true);
    }

    /**
     * @description : test method for SaveAllExtBankRelations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
    **/
    @IsTest
    public static void testSaveAllExtBankRelations() {
        String jsonObj = '[{"LandBankLoan":[{"UqId":1,"Section":"Land Bank Loan","AccountLimit":"10000","ArrearsAmount":"0","ExpiryDate":"2020-09-30","MonthlyRepayment":1500,"OutstandingBalance":"5000","RepaymentFrequency":"M","TermOfFinance":"12","RepaymentAmount":"1500"}]},{"CoOperativeDebt":[{"UqId":1,"Section":"Co-Operative Debt","AccountLimit":"10000","ArrearsAmount":"0","ExpiryDate":"2020-09-30","InstitutionName":"FNB","MonthlyRepayment":400,"OutstandingBalance":"7000","RepaymentFrequency":"Q","RepaymentAmount":"1200"}]},{"ExternalChequeAccounts":[{"UqId":1,"Section":"External Cheque Account","AccountNumber":"23535254","Balance":"15000","InstitutionName":"Nedbank","MaximumDebitBalance":"3000","MaximumOverdraftLimit":"40000","MonthlyReduction":500,"NumberOfReturnedItems":"1","OtherBankName":"ned","OverdraftLimit":"20000","PeriodOfTheBankStatements":"1","ReductionAmount":"1500","ReductionFrequency":"Q","TurnoverForThePeriod":"12"}]},{"BusinessCreditCard":[{"UqId":1,"Section":"Business Credit Card","CreditCardLimit":"12000","CurrentBalance":"10000","InstitutionName":"Standard Bank","MonthlyRepayment":"1200","OtherBankName":"STD Bank"}]},{"ExternalTermLoan":[{"UqId":1,"Section":"External Term Loan","Instalment":"2900","InstitutionName":"Investec Bank","MonthlyRepayment":2900,"OutstandingBalance":"12000","Recalculate":"000","RepaymentFrequency":"M"}]},{"ExternalAssetAndVehicleFinance":[{"UqId":1,"Section":"External Asset And Vehicle Finance","Instalment":"500","InstitutionName":"African Bank","LastPaymentDate":"2020-09-30","MonthlyRepayment":500,"OtherBankName":"12000","OutstandingBalance":"356","RepaymentFrequency":"M"}]},{"ExternalMortgageLoans":[{"UqId":1,"Section":"External Mortgage Loan","Instalment":"2000","InstitutionName":"Other","MonthlyRepayment":2000,"OtherBankName":"boo","OutstandingBalance":"12000","RepaymentFrequency":"M"}]},{"ExternalSavingsAccount":[{"UqId":1,"Section":"External Savings Account","Balance":"5000","InstitutionName":"Capitec Bank","MonthlyInterestEarned":"500","OtherBankName":"nada"},{"UqId":2,"Section":"External Savings Account","Balance":"10000","InstitutionName":"FNB","MonthlyInterestEarned":"567","OtherBankName":"hey"}]},{"ExternalInvestment":[{"UqId":1,"Section":"External Investment","Balance":"30000","InstitutionName":"FNB","MonthlyInterestAndDividendsEarned":"678"}]},{"RetailAndOtherExternalCommitments":[{"UqId":1,"Section":"Retail And Other External Commitment","CreditorName":"booo","MonthlyRepayment":"3000","OutstandingBalance":"56000"}]}]'
            ,jsonObjUp
            ,jsonObjDelExc
            ,jsonObjDel;

        Test.startTest();

        Opportunity opportnity = [SELECT Id,Name FROM Opportunity LIMIT 1];

        Map<String,Object> mapExtRel = ExternalBankingRelationshipsCtrl.saveAllExtBankRelations(opportnity.Id, jsonObj, false);
        Map<String,Object> mapExtRelGet = ExternalBankingRelationshipsCtrl.getAllExtBankRelations(opportnity.Id);

        //update data
        jsonObjUp = '[{"LandBankLoan":' + JSON.serialize(mapExtRelGet.get('LandBankLoan')) + '},{"CoOperativeDebt":' + JSON.serialize(mapExtRelGet.get('CoOperativeDebt')) + '},{"ExternalChequeAccounts":' + JSON.serialize(mapExtRelGet.get('ExternalChequeAccounts')) + '},{"BusinessCreditCard":' + JSON.serialize(mapExtRelGet.get('BusinessCreditCard')) + '},{"ExternalTermLoan":' + JSON.serialize(mapExtRelGet.get('ExternalTermLoan')) + '},{"ExternalAssetAndVehicleFinance":' + JSON.serialize(mapExtRelGet.get('ExternalAssetAndVehicleFinance')) + '},{"ExternalMortgageLoans":' + JSON.serialize(mapExtRelGet.get('ExternalMortgageLoans')) + '},{"ExternalSavingsAccount":' + JSON.serialize(mapExtRelGet.get('ExternalSavingsAccount')) + '},{"ExternalInvestment":' + JSON.serialize(mapExtRelGet.get('ExternalInvestment')) + '},{"RetailAndOtherExternalCommitments":' + JSON.serialize(mapExtRelGet.get('RetailAndOtherExternalCommitments')) + '}]';
        Map<String,Object> mapExtRelUp = ExternalBankingRelationshipsCtrl.saveAllExtBankRelations(opportnity.Id, jsonObjUp, false);

        //delete data
        jsonObjDelExc = '[{},{},{},{},{},{"ExternalSavingsAccount":' + JSON.serialize(mapExtRelGet.get('ExternalSavingsAccount')) + '},{},{}]';
        jsonObjDel = '[{},{},{},{},{},{"ExternalInvestment":' + JSON.serialize(mapExtRelGet.get('ExternalInvestment')) + '},{},{}]';
        Map<String,Object> mapExtRelaDelExc = ExternalBankingRelationshipsCtrl.saveAllExtBankRelations(opportnity.Id, jsonObjDelExc, true);
        Map<String,Object> mapExtRelaDel = ExternalBankingRelationshipsCtrl.saveAllExtBankRelations(opportnity.Id, jsonObjDel, true);

        Test.stopTest();

        System.assert(!mapExtRel.isEmpty(), true);
        System.assert(!mapExtRelUp.isEmpty(), true);
        System.assert(!mapExtRelaDelExc.isEmpty(), true);
        System.assert(!mapExtRelaDel.isEmpty(), true);
    }
}