/**
 * @description       : Helper class for CVS ServiceCalls
 * @author            : Clifford Willers : ABSA (IQ Business)
 * @last modified on  : 2021-09-06
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @last modified on  : 11 September 2021
 * @last modified by  : Jabulani Mashia
 **/

public without sharing class CreditCardHelper {
	/**
    * @description getActionQuotation
    * @param accountId
    * @param newCreditLimit
    * @param wkFind
    * @param wkAcctProd
    * @param wkAcctType
	* @return String
    */
	@AuraEnabled
    public static String getActionQuotation(String accountId, String newCreditLimit, String wkFind, String wkAcctProd, String wkAcctType) {
   		CAactionQuotationV6_Req_IB_v1 requestBean = new CAactionQuotationV6_Req_IB_v1();
		requestBean.CAS096I = new CAactionQuotationV6_Req_IB_v1.CAS096I();
		requestBean.CAS096I.can096iInputArea = new CAactionQuotationV6_Req_IB_v1.Can096iInputArea();
        requestBean.NBSAPDPI = new CAactionQuotationV6_Req_IB_v1.NBSAPDPI();
        requestBean.NBSAPDPI.inputHeaders = new CAactionQuotationV6_Req_IB_v1.InputHeaders();
        requestBean.CAS096I.can096iInputArea.wkFIID = wkFind;
        requestBean.CAS096I.can096iInputArea.wkAcctProd = wkAcctProd;
        requestBean.CAS096I.can096iInputArea.wkAcctType = wkAcctType;
        requestBean.CAS096I.can096iInputArea.wkCreditLimit = newCreditLimit;

        requestBean.NBSAPDPI.inputHeaders.channelName = 'Salesforce';
		requestBean.NBSAPDPI.inputHeaders.applicationName = 'Salesforce';
		requestBean.NBSAPDPI.inputHeaders.traceIndicator = 'Y';

        Account acc = new AccountsSelector().selectAllById(accountId);
		string ageString = String.valueOf(acc.Age__pc);
		string[] ageSplit = ageString.split('\\.');

        requestBean.CAS096I.can096iInputArea.wkiQtAtion = 'O';
		requestBean.CAS096I.can096iInputArea.wkiNewStatus = 'OFF';
		requestBean.CAS096I.can096iInputArea.wkiIdCiproRegn = String.valueOf(acc.ID_Number__pc);
		requestBean.CAS096I.can096iInputArea.wkiCifKey = String.valueOf(acc.CIF__c);
		requestBean.CAS096I.can096iInputArea.wkiRefNbr = '';
		requestBean.CAS096I.can096iInputArea.wkiOrigin = '';
		requestBean.CAS096I.can096iInputArea.wkiQuoteNumber = '0';
		requestBean.CAS096I.can096iInputArea.wkNbePrimCrCards = '1';
		requestBean.CAS096I.can096iInputArea.wkNbrSecCrCards = '0';
		requestBean.CAS096I.can096iInputArea.wkNbrCreditCards = '1';
		requestBean.CAS096I.can096iInputArea.wkNbrGarageCards = '0';
		requestBean.CAS096I.can096iInputArea.wkTcCode = '';
		requestBean.CAS096I.can096iInputArea.wkBudgetLimit = '0';
		requestBean.CAS096I.can096iInputArea.wkBudgetPlan = '0';
		requestBean.CAS096I.can096iInputArea.wkBudgetRepayTerm = '0';
		requestBean.CAS096I.can096iInputArea.wkInitFeeInd = 'Y';
		requestBean.CAS096I.can096iInputArea.wkServFeeInd = 'Y';
		requestBean.CAS096I.can096iInputArea.wkLcpFeeInd = '';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInd = 'Y';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInsCd = 'POA';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInsTyp = 'I';
		requestBean.CAS096I.can096iInputArea.wkClientAge = ageSplit[0];
		requestBean.CAS096I.can096iInputArea.wkAcctStatCode = '0';
		requestBean.CAS096I.can096iInputArea.riskMatrixStatus = '0';
		requestBean.CAS096I.can096iInputArea.riskMatrixCrRisk = '0';
		requestBean.CAS096I.can096iInputArea.casaRefNbr = '0';
        CAactionQuotationV6_Resp_IB_v1 responsebean = (CAactionQuotationV6_Resp_IB_v1)CAactionQuotationV6_IH_v1.caActionQuotation(requestBean);
		return responsebean.serialize(responsebean);
    }
}