/**
* Apex Integration Response Bean class for CClistPrefProductForClientV2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/
public class CClistPrefProductForClientV2_Resp_IB_v1 extends Base_IB{
    
    public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public CClistPrefProductsForClientV2Response CClistPrefProductsForClientV2Response;

	public class Nbsmsgo {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}

	public class Ccp317o {
		public String sbuCode;
		public String nbrProdRet;
		public List<PrdProdLst> prdProdLst;
	}

	public class CClistPrefProductsForClientV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Ccp317o ccp317o;
	}

	public class PrdProdLst {
		public String accntNbr;
		public String prodType;
		public String prodCode;
		public String prodBrand;
	}

	
	public static CClistPrefProductForClientV2_Resp_IB_v1 createDummyResponse() {
        CClistPrefProductForClientV2_Resp_IB_v1 responseBean = new CClistPrefProductForClientV2_Resp_IB_v1();
        responseBean.CClistPrefProductsForClientV2Response = new CClistPrefProductForClientV2_Resp_IB_v1.CClistPrefProductsForClientV2Response();
        responseBean.CClistPrefProductsForClientV2Response.nbsapdpo = new CClistPrefProductForClientV2_Resp_IB_v1.Nbsapdpo();
        responseBean.CClistPrefProductsForClientV2Response.nbsmsgo = new CClistPrefProductForClientV2_Resp_IB_v1.Nbsmsgo();
        responseBean.CClistPrefProductsForClientV2Response.ccp317o = new CClistPrefProductForClientV2_Resp_IB_v1.Ccp317o();
        CClistPrefProductForClientV2_Resp_IB_v1.PrdProdLst prdProdLstBean = new CClistPrefProductForClientV2_Resp_IB_v1.PrdProdLst();
        List<CClistPrefProductForClientV2_Resp_IB_v1.PrdProdLst> prdProdLstBeanList = new List<CClistPrefProductForClientV2_Resp_IB_v1.PrdProdLst>();
        
        responseBean.CClistPrefProductsForClientV2Response.nbsapdpo.version = 'APLO003';
        responseBean.CClistPrefProductsForClientV2Response.nbsapdpo.returnCode = '0';
        responseBean.CClistPrefProductsForClientV2Response.nbsapdpo.reasonCode = '0';
        responseBean.CClistPrefProductsForClientV2Response.nbsapdpo.serviceVersion = 'BUSO001';
        responseBean.CClistPrefProductsForClientV2Response.nbsapdpo.echoKey = 'DP78004351613468111';
        
        responseBean.CClistPrefProductsForClientV2Response.nbsmsgo.version = 'MSG3001';
        responseBean.CClistPrefProductsForClientV2Response.nbsmsgo.nbrUserMsgs = '0';
        responseBean.CClistPrefProductsForClientV2Response.nbsmsgo.nbrUserErrs = '0';

        prdProdLstBean.accntNbr = '4048063812';
        prdProdLstBean.prodType = 'CQ';
        prdProdLstBean.prodCode = '11032';
        prdProdLstBean.prodBrand = 'N';
        
        prdProdLstBeanList.add(prdProdLstBean); 
        responseBean.CClistPrefProductsForClientV2Response.ccp317o.sbuCode = 'F';
        responseBean.CClistPrefProductsForClientV2Response.ccp317o.nbrProdRet = '3';
        responseBean.CClistPrefProductsForClientV2Response.ccp317o.prdProdLst = prdProdLstBeanList;
        
		return responseBean;
	}

}