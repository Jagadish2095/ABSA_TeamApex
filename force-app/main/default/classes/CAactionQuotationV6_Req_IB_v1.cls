/**
 *@description Response Integration Bean for CAactionQuotationV6 request
 * @author Jabulani Mashia
 * @created 2021-09-06
 **/
public with sharing class CAactionQuotationV6_Req_IB_v1 extends Base_IB {
	public NBSAPDPI NBSAPDPI;
	public CAS096I CAS096I;

	/**
	 * @description NBSAPDPI
	 **/
	public class NBSAPDPI {
		public InputHeaders inputHeaders;
	}
	/**
	 * @description CAS096I
	 **/
	public class CAS096I {
		public Can096iInputArea can096iInputArea;
	}
	/**
	 * @description InputHeaders
	 **/
	public class InputHeaders {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}
	/**
	 * @description Can096iInputArea
	 **/
	public class Can096iInputArea {
		public String wkiQtAtion;
		public String wkiNewStatus;
		public String wkiIdCiproRegn;
		public String wkiCifKey;
		public String wkiRefNbr;
		public String wkiOrigin;
		public String wkiQuoteNumber;
		public String wkFIID;
		public String wkAcctProd;
		public String wkAcctType;
		public String wkNbePrimCrCards;
		public String wkNbrSecCrCards;
		public String wkNbrCreditCards;
		public String wkNbrGarageCards;
		public String wkTcCode;
		public String wkCreditLimit;
		public String wkBudgetLimit;
		public String wkBudgetPlan;
		public String wkBudgetRepayTerm;
		public String wkInitFeeInd;
		public String wkServFeeInd;
		public String wkLcpFeeInd;
		public String wkCrLifeInd;
		public String wkCrLifeInsCd;
		public String wkCrLifeInsTyp;
		public String wkClientAge;
		public String wkAcctStatCode;
		public String riskMatrixStatus;
		public String riskMatrixCrRisk;
		public String casaRefNbr;
	}
	/**
	 *@description createDummyRequest
	 * @return CAactionQuotationV6_Req_IB_v1
	 **/
	public static CAactionQuotationV6_Req_IB_v1 createDummyRequest() {
		CAactionQuotationV6_Req_IB_v1 requestBean = new CAactionQuotationV6_Req_IB_v1();
		requestBean.NBSAPDPI = new CAactionQuotationV6_Req_IB_v1.NBSAPDPI();
		requestBean.CAS096I = new CAactionQuotationV6_Req_IB_v1.CAS096I();
		requestBean.CAS096I.can096iInputArea = new CAactionQuotationV6_Req_IB_v1.Can096iInputArea();
		requestBean.NBSAPDPI.inputHeaders = new CAactionQuotationV6_Req_IB_v1.InputHeaders();
		requestBean.NBSAPDPI.inputHeaders.channelName = 'DP';
		requestBean.NBSAPDPI.inputHeaders.applicationName = 'CAM';
		requestBean.NBSAPDPI.inputHeaders.traceIndicator = 'Y';
		requestBean.CAS096I.can096iInputArea.wkiQtAtion = '0';
		requestBean.CAS096I.can096iInputArea.wkiNewStatus = 'OFF';
		requestBean.CAS096I.can096iInputArea.wkiIdCiproRegn = '6409220103086';
		requestBean.CAS096I.can096iInputArea.wkiCifKey = '';
		requestBean.CAS096I.can096iInputArea.wkiRefNbr = '';
		requestBean.CAS096I.can096iInputArea.wkiOrigin = '';
		requestBean.CAS096I.can096iInputArea.wkiQuoteNumber = '0';
		requestBean.CAS096I.can096iInputArea.wkFIID = '455027';
		requestBean.CAS096I.can096iInputArea.wkAcctProd = 'VIS';
		requestBean.CAS096I.can096iInputArea.wkAcctType = 'GLD';
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
		requestBean.CAS096I.can096iInputArea.wkServFeeInd = '';
		requestBean.CAS096I.can096iInputArea.wkLcpFeeInd = '';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInd = 'Y';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInsCd = 'POA';
		requestBean.CAS096I.can096iInputArea.wkCrLifeInsTyp = 'I';
		requestBean.CAS096I.can096iInputArea.wkClientAge = '24';
		requestBean.CAS096I.can096iInputArea.wkAcctStatCode = '0';
		requestBean.CAS096I.can096iInputArea.riskMatrixStatus = '0';
		requestBean.CAS096I.can096iInputArea.riskMatrixCrRisk = '0';
		requestBean.CAS096I.can096iInputArea.casaRefNbr = '0';
		return requestBean;
	}
}