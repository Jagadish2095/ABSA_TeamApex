/**
 *@description Integration Handler for SVcreateLinkSavingsDepAccount_Req_IB_v2 Service
 * @author edited by Prudence Shirindzi 
 * @created 2020-05-14
 * 2020-09-08  Brian Maswanganyi   change sofsoi to sof
 */
public class SVcreateLinkSavingsDepAccount_Req_IB_v2 extends Base_IB {
    public SVcreateLinkSavingsNoticeDepAccountV6 SVcreateLinkSavingsNoticeDepAccountV6;
		/** 
     * @description svpp15i
     */
    public class svpp15i{
		public String marketersCode;
		public String agencyCode;
		public String effectiveDate;
		public String tellerCode;
		public String versionNbr;
		public String supervisorCode;
		public String productCode;
		public String noticePeriod;
		public String brandCode;
		public String withdrwlPerc;
		public String tranSiteType;
		public String channelInd;
		public String tranSiteCode;
		public String srcOfFnds1;
		public String acctSiteType;
		public String srcOfFnds2;
		public String acctSiteCode;
		public String srcOfFnds3;
		public String clientCode;
		public String srcOfFnds4;
		public String rateOption;
		public String crpCode;
		public String investTerm;
		public String freqCode;
		public String investAmount;
		public String rbaEddRating;
		public String srcOfFnds5;
	}
        /** 
     * @description SVcreateLinkSavingsNoticeDepAccountV6
     */
	public class SVcreateLinkSavingsNoticeDepAccountV6{
		public nbsmsgi nbsmsgi;
		public svpp15i svpp15i;
		public nbsapdpi nbsapdpi;
	}
	/** 
     * @description nbsmsgi
     */
	public class nbsmsgi{
		public String msgTarget;
		public String msgLanguage;
		public finalMsgId finalMsgId;
	}
	/** 
     * @description nbsapdpi
     */
	public class nbsapdpi{
		public String trace;
		public String application;
		public String channel;
	}
	/** 
     * @description finalMsgId
     */
	public class finalMsgId{
		public String finalMsgClass;
		public String finalMsgCode;
	}
    
    
       /** 
     * @description createDummyRequest
     * @return SVcreateLinkSavingsDepAccount_Req_IB_v2
     */ 
    public static SVcreateLinkSavingsDepAccount_Req_IB_v2 createDummyRequest(){ 
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2 requestBean = new SVcreateLinkSavingsDepAccount_Req_IB_v2();
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsapdpi nbsapdpi = new SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsapdpi();
        nbsapdpi.application = 'BDP';
        nbsapdpi.channel = 'BDP';
        nbsapdpi.trace = 'Y';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.finalMsgId msgIdClsObj = new SVcreateLinkSavingsDepAccount_Req_IB_v2.finalMsgId();
        msgIdClsObj.finalMsgClass = '';
        msgIdClsObj.finalMsgCode = '';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsmsgi nbsmsgi = new SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsmsgi();
        nbsmsgi.finalMsgId = msgIdClsObj;
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.svpp15i svpp15i = new SVcreateLinkSavingsDepAccount_Req_IB_v2.svpp15i();
        svpp15i.marketersCode = '0';
        svpp15i.agencyCode = '034';
        svpp15i.effectiveDate = '20210222';
        svpp15i.tellerCode = '999999';
        svpp15i.versionNbr = '0';
        svpp15i.supervisorCode = '999999';
        svpp15i.productCode = '09007';
        svpp15i.noticePeriod = '0';
        svpp15i.brandCode = 'ABS';
        svpp15i.withdrwlPerc = '0';
        svpp15i.tranSiteType = '034';
        svpp15i.channelInd = 'B';
        svpp15i.tranSiteCode = '8193';
        svpp15i.srcOfFnds1 = '39';
        svpp15i.acctSiteType = '034';
        svpp15i.srcOfFnds2 = '';
        svpp15i.acctSiteCode = '8474';
        svpp15i.srcOfFnds3 = '';
        svpp15i.clientCode = 'MAN    007';
        svpp15i.srcOfFnds4 = '';
        svpp15i.rateOption = '';
        svpp15i.crpCode = 'ABS';
        svpp15i.investTerm = '0';
        svpp15i.freqCode = '0';
        svpp15i.investAmount = '0';
        svpp15i.rbaEddRating = 'L';
        svpp15i.srcOfFnds5 = '';
        
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6 v6Obj = new SVcreateLinkSavingsDepAccount_Req_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6();
        v6Obj.nbsapdpi = nbsapdpi;
        v6Obj.nbsmsgi = nbsmsgi;
        v6Obj.svpp15i = svpp15i;
        
        
        requestBean.SVcreateLinkSavingsNoticeDepAccountV6 = v6Obj;
        return requestBean;
    }
    /** 
     * @description SVcreateLinkSavingsNoticeDepAccountV6
     */
    public override void setIntegrationTranslations()
    {
        integrationTranslationsMap = new Map<String, String>();
        integrationTranslationsMap.put('SVcreateLinkSavingsNoticeDepAccountV6.svpp15i.srcOfFnds1','CIFCodesList;Sof' );
    }
}