/*
* Request Integration Bean for IBgetClientDetails Service
* @author Khaliq Abdul
* @created 2020-10-30
*/
public class CAactionQuotationV4_Resp_IB_v1 extends Base_IB{
    
    //@AuraEnabled
    public String status;
    public Integer statusCode;
    public String message;
    public CAactionQuotationV4Response CAactionQuotationV4Response;
    
    public class CAactionQuotationV4Response{
        public Nbsapdpo nbsapdpo{get;set;}
        public Cap096o cap096o{get;set;}            
    }
    
    public class Nbsapdpo{
        public String version;
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
        public String echoKey;        
    }
    
    public class Cap096o{
        
        public String rbpInd;
		public String wkAcctTypeDesc;
		public String wkActType;
		public String wkBlInstal;
		public String wkBlInstalXtras;
		public String wkBlIntRate;
		public String wkBlTotAllInstal;
		public String wkBlTotFees;
		public String wkBlTotInterest;
		public String wkClientAddr1;
		public String wkClientAddr2;
		public String wkClientAddr3;
		public String wkClientAddr4;
		public String wkClientDialcd;
		public String wkClientLang;
		public String wkClientTel;
		public String wkClpAmt;
		public String wkClpPct;
		public String wkCrProviderAddr1;
		public String wkCrProviderAddr2;
		public String wkCrProviderAddr3;
		public String wkCrProviderAddr4;
		public String wkCrProviderNm;
		public String wkCrProviderTel;
		public String wkCrlInstal;
		public String wkCrlInstalXtras;
		public String wkCrlIntRate;
		public String wkCrlNbrInstal;
		public String wkCrlTotAllInstal;
		public String wkCrlTotFees;
		public String wkCrlTotInterest;
		public String wkDateAdded;
		public String wkDateUpdated;
		public String wkInitFee;
		public String wkInstalPymtMWO;
		public String wkLcpFee;
		public String wkMthlyServiceFee;
		public String wkName;
		public String wkOptInstalDesc;
		public String wkOptInstalItems;
		public String wkQuoteCurrStat;
		public String wkQuoteGenRc;
		public String wkSname;
		public String wkTotAllInstals;
		public String wkTotInterestFees;
		public String wkTotalCredit;
		public String wkVariableIntMarkup;
		public String wkiNewStatus;
		public String wkiQuoteNumber;
		public String wkiResult;
        
    }
    
    public static CAactionQuotationV4_Resp_IB_v1 dummyResponse(){
        CAactionQuotationV4_Resp_IB_v1 responseBean = new CAactionQuotationV4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        CAactionQuotationV4_Resp_IB_v1.Nbsapdpo nbsapdpo = new CAactionQuotationV4_Resp_IB_v1.Nbsapdpo();
        nbsapdpo.version='0';
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        nbsapdpo.echoKey='';
        
        CAactionQuotationV4_Resp_IB_v1.Cap096o cap096o = new CAactionQuotationV4_Resp_IB_v1.Cap096o();
        cap096o.rbpInd='1';
        cap096o.wkAcctTypeDesc  = 'MR    UKA USMAN KHWAJA';
        cap096o.wkActType  = 'ABSA';
        cap096o.wkBlInstal  = '1';
        cap096o.wkBlInstalXtras  = '1';
        cap096o.wkBlIntRate  =  '1';
        cap096o.wkBlTotAllInstal = '1';
        cap096o.wkBlTotFees  ='1';
        cap096o.wkBlTotInterest = '1';
        cap096o.wkClientAddr1 = '1';
        cap096o.wkClientAddr2 ='1';
        cap096o.wkClientAddr3 = '1';
        cap096o.wkClientAddr4 = '07';
        cap096o.wkClientDialcd ='1';
        cap096o.wkClientLang = '404' ;
        cap096o.wkClientTel = '404' ;
        cap096o.wkClpAmt ='1';
        cap096o.wkClpPct ='1';
        cap096o.wkCrProviderAddr1 = '23';
        cap096o.wkCrProviderAddr2 = '0' ;
        cap096o.wkCrProviderAddr3 = '9999' ;
        cap096o.wkCrProviderAddr4 = '0' ;
        cap096o.wkCrProviderNm = '0';
        cap096o.wkCrProviderTel = '0';
        cap096o.wkCrlInstal = '1' ;
        cap096o.wkCrlInstalXtras = '100' ;
        cap096o.wkCrlIntRate = '2' ;
        cap096o.wkCrlNbrInstal = '2' ;
        cap096o.wkCrlTotAllInstal = '2';        
        cap096o.wkCrlTotFees='1';
        cap096o.wkCrlTotInterest  = '1';
        cap096o.wkDateAdded  = '1';
        cap096o.wkDateUpdated  = '1';
        cap096o.wkInitFee  = '1';
        cap096o.wkInstalPymtMWO  =  '1';
        cap096o.wkLcpFee = '1';
        cap096o.wkMthlyServiceFee  ='1';
        cap096o.wkName = '1';
        cap096o.wkOptInstalDesc = '1';
        cap096o.wkOptInstalItems ='1';
        cap096o.wkQuoteCurrStat = '1';
        cap096o.wkQuoteGenRc = '07';
        cap096o.wkSname ='1';
        cap096o.wkTotAllInstals = '404' ;
        cap096o.wkTotInterestFees = '404' ;
        cap096o.wkTotalCredit ='1';
        cap096o.wkVariableIntMarkup ='1';
        cap096o.wkiNewStatus = 'OFF';
        cap096o.wkiQuoteNumber = '0' ;
        cap096o.wkiResult = '9999' ;        
        
        CAactionQuotationV4_Resp_IB_v1.CAactionQuotationV4Response CAactionQuotationV4Responsebean = new CAactionQuotationV4_Resp_IB_v1.CAactionQuotationV4Response();
        CAactionQuotationV4Responsebean.Nbsapdpo = nbsapdpo;
        CAactionQuotationV4Responsebean.Cap096o = cap096o;
        
        responseBean.CAactionQuotationV4Response = CAactionQuotationV4Responsebean;
        
        return responseBean;
    }
}