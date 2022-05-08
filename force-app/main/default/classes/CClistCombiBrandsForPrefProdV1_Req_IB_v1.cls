/**
* @description Apex Integration Request Bean class for CClistPrefProductsForClientV2 service
* @author  André Pietersen
* @since   2021-02-07
*
**/

public class CClistCombiBrandsForPrefProdV1_Req_IB_v1 extends Base_IB{
	public CClistCombiBrandsForPreferredProductV1 CClistCombiBrandsForPreferredProductV1;

	/**
    * @description
	*/

	public class CClistCombiBrandsForPreferredProductV1 {
		public NBSAPDPI nbsapdpi;
		public NBSMSGI nbsmsgi;
		public CCS306I ccp306i;
	}
    /**
    * @description
	*/

	public class NBSMSGI {
		public String msgLanguage;
		public String msgTarget;
		public finalMsgId finalMsgId;
	}

    /**
    * @description
	*/
	public class finalMsgId {
		public List<String> finalMsgClass;
		public List<String> finalMsgCode;
	}
    /**
    * @description
	*/
	public class CCS306I {
		public String prodType;
		public String prodCode;
		public String nxtBrand;
		public String nbrBrandReq;
		public String cardType;
		public String functionInd;
	}
    /**
    * @description
	*/
	public class NBSAPDPI {
		public String channel;
		public String application;
		public String trace;
	}
	
	/**
	* @description 
	* @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
	* @return CClistCombiBrandsForPrefProdV1_Req_IB_v1 
	**/
	public static CClistCombiBrandsForPrefProdV1_Req_IB_v1 createDummyRequest() {
        CClistCombiBrandsForPrefProdV1_Req_IB_v1 requestBean = new CClistCombiBrandsForPrefProdV1_Req_IB_v1();
        requestBean.CClistCombiBrandsForPreferredProductV1 = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.CClistCombiBrandsForPreferredProductV1();
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.CCS306I();
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.NBSAPDPI();
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.NBSMSGI();
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.finalMsgId = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.finalMsgId();
        
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.channel = 'BDP';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.application = 'BDP';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.trace = 'Y';
        
        
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.msgTarget = 'STD';
        
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodType = 'm';
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodCode = '99998';
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.nxtBrand = '99998';
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.nbrBrandReq = '45';
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.cardType = 'p';
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.functionInd = 't';
	
		return requestBean;
	}

}