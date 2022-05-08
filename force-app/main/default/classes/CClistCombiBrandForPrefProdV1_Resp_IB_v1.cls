/**
* Apex Integration Response Bean class for CClistPrefProductsForClientV2 service
* @author  André Pietersen
* @since   2021-02-07
*
**/
public class CClistCombiBrandForPrefProdV1_Resp_IB_v1 extends Base_IB{
	public wsd_CClistCombiBrandsForPreferredProductV1Response wsd_CClistCombiBrandsForPreferredProductV1Response;
	
	public class wsd_CClistCombiBrandsForPreferredProductV1Response{
		public CCS306O ccp306o;
		public NBSAPDPO nbsapdpo;
		public NBSMSGO3 nbsmsgo;
	}
  
    public String status;
    public Integer statusCode;
    public String message;

	public class CCS306O {
        public String prodRetrvdInd;
		public String nbrBrandRet;
		public prdBrandDetails prdBrandDetails;
	}

	public class PrdBrandDetails {
		public List<prdBrandLst> prdBrandLst;
	}

	public class NBSAPDPO {
		public String serviceVersion;
		public String returnCode;
		public String reasonCode;
	}

	public class msgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class NBSMSGO3 {
		public Integer nbrUserMsgs;
		public Integer nbrUserErrs;
		public msgEntry msgEntry;
	}

	public class prdBrandLst {
		public String brandNbr;
		public String brandSeq;
		public String brandType;
		public String brandSubType;
		public String brandSegm;
		public String brandSubSegm;
	}

	public override void setIntegrationTranslations()
    {
      	integrationTranslationsMap = new Map<String, String>();
	 	integrationTranslationsMap.put('wsd_CClistCombiBrandsForPreferredProductV1Response.ccp306o.prdBrandDetails.prdBrandLst.brandNbr','Combi;Brands');
	}
}