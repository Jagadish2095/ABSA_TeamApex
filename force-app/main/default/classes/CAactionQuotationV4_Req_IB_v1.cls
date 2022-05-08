/*
 * Request Integration Bean for IBgetClientDetails Service
 * @author Khaliq Abdul
 * @created 2020-10-30
 */
public class CAactionQuotationV4_Req_IB_v1 extends Base_IB{
    
    public CAactionQuotationV4 CAactionQuotationV4;
    
    public class CAactionQuotationV4 {
        public nbsapdpi nbsapdpi;       
        public cap096i cap096i; 
    }
    public class nbsapdpi{
        public String channel;
        public String application;
        public String trace;
    }
    
    public class cap096i{
        
        public String wkiQtAction;
		public String wkiNewStatus;
		public String wkiIdCiproRegn;
		public String wkiCifKey;
        public String wkiRefNbr;
		public String wkiOrigin;
		public String wkiQuoteNumber;
		public String wkFiid;
		public String wkAcctProd;
		public String wkAcctType;
		public String wkNbrPrimCrCards;
		public String wkNbrSecCrCards;
		public String wkNbrCreditCards;
		public String wkNbrGarageCards;
		public String wkTcCode;
		public String wkCreditLimit;
		public String wkBudgetLimit;
		public String wkBudgetPlan;
		public String wkBudgetRepayTrm;
        public String wkInitFeeInd;
		public String wkServFeeInd;
		public String wkLcpFeeInd;
		public String wkCrlifeFeeInd;
		public String wkCrlifeInsCd;
		public String wkCrlifeInsTyp;
		public String wkClientAge;
        public String wkAcctStatCd;
		public String riskMatrixStatus;
		public String riskMatrixCrRisk;
		public String casaRefNbr;       
    }  
    
    public class WkiRefNbr {
	}
    
    public static CAactionQuotationV4_Req_IB_v1 createDummyRequest(){        
        
        CAactionQuotationV4_Req_IB_v1 requestBean = new CAactionQuotationV4_Req_IB_v1();
        CAactionQuotationV4_Req_IB_v1.nbsapdpi nbsapdpiRequest = new CAactionQuotationV4_Req_IB_v1.nbsapdpi ();
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';

        CAactionQuotationV4_Req_IB_v1.cap096i Cap096iRequest = new CAactionQuotationV4_Req_IB_v1.cap096i();
        Cap096iRequest.wkiQtAction =  'A'  ;
        Cap096iRequest.wkiNewStatus =  'CRE'  ;
        Cap096iRequest.wkiIdCiproRegn =  '6409220103086'  ;
        Cap096iRequest.wkiCifKey =  'MFOLONP001'  ;
        Cap096iRequest.wkiRefNbr =  '1469'  ;
        Cap096iRequest.wkiOrigin =  '0'  ;
        Cap096iRequest.wkiQuoteNumber =  '0'  ;
        Cap096iRequest.wkFiid =  '4787692'  ;
        Cap096iRequest.wkAcctProd =  'VIS'  ;        
        Cap096iRequest.wkAcctType =  'PPK'  ;
        Cap096iRequest.wkNbrPrimCrCards =  '1'  ;
        Cap096iRequest.wkNbrSecCrCards =  '0'  ;
        Cap096iRequest.wkNbrCreditCards =  '1'  ;
        Cap096iRequest.wkNbrGarageCards =  '0'  ;
        Cap096iRequest.wkTcCode =  '0'  ;
        Cap096iRequest.wkCreditLimit =  '20000'  ;
        Cap096iRequest.wkBudgetLimit =  '0'  ;
        Cap096iRequest.wkBudgetPlan =  '0'  ;        
        Cap096iRequest.wkBudgetRepayTrm =  '0'  ;
        Cap096iRequest.wkInitFeeInd =  ''  ;
        Cap096iRequest.wkServFeeInd =  ''  ;
        Cap096iRequest.wkLcpFeeInd =  ''  ;
        Cap096iRequest.wkCrlifeFeeInd =  'Y'  ;
        Cap096iRequest.wkCrlifeInsCd =  'POA'  ;
        Cap096iRequest.wkCrlifeInsTyp =  'I'  ;
        Cap096iRequest.wkClientAge =  '25'  ;
        Cap096iRequest.wkAcctStatCd =  ''  ;
        Cap096iRequest.riskMatrixStatus =  ''  ;
        Cap096iRequest.riskMatrixCrRisk =  '0'  ;
        Cap096iRequest.casaRefNbr =  '0'  ;        
        
        CAactionQuotationV4_Req_IB_v1.CAactionQuotationV4 CAactionQuotationV4bean = new CAactionQuotationV4_Req_IB_v1.CAactionQuotationV4();
        CAactionQuotationV4bean.nbsapdpi = nbsapdpiRequest;
        CAactionQuotationV4bean.cap096i =  Cap096iRequest;
        
        requestBean.CAactionQuotationV4 = CAactionQuotationV4bean;
        return requestBean;
    }    
    
}