/**
 * @description       : PackageFeeServiceController
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-10-01
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-09-13   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-09-27   André Pietersen (IQ Business)   Added cheque service
 **/
public class PackageFeeServiceController implements IProductSystemService {
	/**
	 * @description callProductSystem
	 * @author André Pietersen (IQ Business) | 2021-09-07
	 * @param productId
	 * @return ProductSystemDetails
	 **/
	public static ProductSystemDetails callProductSystem(string productId) {
		Product2 product = [SELECT Name FROM Product2 WHERE Id = :productId];
		ROAFeature__c productFeature = [
			SELECT Id, Name, Cheque_Monthly_Fee__c, Credit_Card_Facility_Fee__c, Credit_Card_Monthly_Account_Fee__c, Montly_Fee__c
			FROM ROAFeature__c
			WHERE Name = :product.Name
		];

		string accountType = productFeature.Name == 'Gold Package' ? 'GLD' : 'PPR';
		string fiid = productFeature.Name == 'Gold Package' ? '455027' : '4787692';

		CAactionQuotationV6_Req_IB_v1 requestBean = new CAactionQuotationV6_Req_IB_v1();
		requestBean.NBSAPDPI = new CAactionQuotationV6_Req_IB_v1.NBSAPDPI();
		requestBean.CAS096I = new CAactionQuotationV6_Req_IB_v1.CAS096I();
		requestBean.CAS096I.can096iInputArea = new CAactionQuotationV6_Req_IB_v1.Can096iInputArea();
		requestBean.NBSAPDPI.inputHeaders = new CAactionQuotationV6_Req_IB_v1.InputHeaders();

		requestBean.NBSAPDPI.inputHeaders.channelName = 'Salesforce';
		requestBean.NBSAPDPI.inputHeaders.applicationName = 'Salesforce';
		requestBean.NBSAPDPI.inputHeaders.traceIndicator = 'N';

		requestBean.CAS096I.can096iInputArea.wkiQtAtion = 'O';
		requestBean.CAS096I.can096iInputArea.wkiNewStatus = 'OFF';
		requestBean.CAS096I.can096iInputArea.wkiIdCiproRegn = '6409220103086';
		requestBean.CAS096I.can096iInputArea.wkiCifKey = '';
		requestBean.CAS096I.can096iInputArea.wkiRefNbr = '';
		requestBean.CAS096I.can096iInputArea.wkiOrigin = '';
		requestBean.CAS096I.can096iInputArea.wkiQuoteNumber = '0';
		requestBean.CAS096I.can096iInputArea.wkFIID = fiid;
		requestBean.CAS096I.can096iInputArea.wkAcctProd = 'VIS';
		requestBean.CAS096I.can096iInputArea.wkAcctType = accountType;
		requestBean.CAS096I.can096iInputArea.wkNbePrimCrCards = '1';
		requestBean.CAS096I.can096iInputArea.wkNbrSecCrCards = '0';
		requestBean.CAS096I.can096iInputArea.wkNbrCreditCards = '1';
		requestBean.CAS096I.can096iInputArea.wkNbrGarageCards = '0';
		requestBean.CAS096I.can096iInputArea.wkTcCode = '';
		requestBean.CAS096I.can096iInputArea.wkCreditLimit = '18000';
		requestBean.CAS096I.can096iInputArea.wkBudgetLimit = '0';
		requestBean.CAS096I.can096iInputArea.wkBudgetPlan = '0';
		requestBean.CAS096I.can096iInputArea.wkBudgetRepayTerm = '0';
		requestBean.CAS096I.can096iInputArea.wkInitFeeInd = '';
		requestBean.CAS096I.can096iInputArea.wkServFeeInd = 'Y';
		requestBean.CAS096I.can096iInputArea.wkLcpFeeInd = '';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInd = 'Y';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInsCd = 'POA';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInsTyp = 'I';
		requestBean.CAS096I.can096iInputArea.wkClientAge = '24';
		requestBean.CAS096I.can096iInputArea.wkAcctStatCode = '0';
		requestBean.CAS096I.can096iInputArea.riskMatrixStatus = '0';
		requestBean.CAS096I.can096iInputArea.riskMatrixCrRisk = '0';
		requestBean.CAS096I.can096iInputArea.casaRefNbr = '0';

		decimal creditMonthlyFee = 0;
		decimal creditAccountFee = 0;
		CAactionQuotationV6_Resp_IB_v1 responseBean = CAactionQuotationV6_IH_v1.caActionQuotation(requestBean);
		if (responseBean != null && responseBean.CAS096O.can096oOutPutArea != null) {
			creditMonthlyFee = Decimal.valueOf(responseBean.CAS096O.can096oOutPutArea.wkMonthlyServiceFee);
			creditAccountFee = Decimal.valueOf(responseBean.CAS096O.can096oOutPutArea.wkAccountFee);
			productFeature.Credit_Card_Facility_Fee__c = 'R' + responseBean.CAS096O.can096oOutPutArea.wkMonthlyServiceFee;
			productFeature.Credit_Card_Monthly_Account_Fee__c = 'R' + responseBean.CAS096O.can096oOutPutArea.wkAccountFee;
		}

		//Cheque service call
		string scheme = productFeature.Name == 'Gold Package' ? 'CQT01S48' : 'CQT01S49';
		decimal chequeMonthlyFee = 0;
		string rate;
		IPCBPTariffEnquiry_Resp_IB_v1 chequeResponse = IPCBPTariffEnquiry_IH_v1.callToIPCBPTariffEnquiryPricingSchemeToListChargeCodes(
			scheme,
			null,
			null,
			null
		);
		if (chequeResponse.IPCBPTariffEnquiryResponse != null && chequeResponse.IPCBPTariffEnquiryResponse.GroupCode[0].ChargeCodesList[0].Rate != null) {
			rate = chequeResponse.IPCBPTariffEnquiryResponse.GroupCode[0].ChargeCodesList[0].Rate;
			chequeMonthlyFee = decimal.valueOf(rate.replace('R', ''));
			productFeature.Cheque_Monthly_Fee__c = rate;
		}

		decimal unitPrice = creditMonthlyFee + creditAccountFee + chequeMonthlyFee;
		productFeature.Montly_Fee__c = 'R' + String.valueOf(unitPrice);

		ProductSystemDetails productSystemDetails = new ProductSystemDetails();
		productSystemDetails.ProductId = productId;
		productSystemDetails.UnitPrice = unitPrice;
		productSystemDetails.Description = null;
		productSystemDetails.AdditionalObjectToUpdate = productFeature;

		return productSystemDetails;
	}
}