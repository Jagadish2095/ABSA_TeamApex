/** 
 * @description Integration Handler for SVcreateLinkSavingsDepAccount_Resp Service
 * @author edited by Prudence Shirindzi 
 * @created 2020-04-07
 */
public  without sharing class SVcreateLinkSavingsDepAccount_Resp_IB_v2 extends Base_IB {
    public  SVcreateLinkSavingsNoticeDepAccountV6Response SVcreateLinkSavingsNoticeDepAccountV6Response;
    /** 
     *@description svpp15o

     */
    public without sharing class svpp15o{
        public Decimal accountNumber;
    }
    /** 
     *@description SVcreateLinkSavingsNoticeDepAccountV6Response
     */
    public without sharing class SVcreateLinkSavingsNoticeDepAccountV6Response{
        public nbsmsgo3 nbsmsgo3;
        public svpp15o svpp15o;
        public nbsapdpo nbsapdpo;
    }
    /** 
     *@description nbsmsgo3
     */
    public without sharing class nbsmsgo3{
        public Integer nbrUserMsgs;
        public String sysErrTxt;
        public String version;
        public Integer nbrUserErrs;
        public msgentry msgentry;
    }
    /** 
     *@description nbsapdpo
     */
    public without sharing class nbsapdpo{
        public String version;
        public Integer returnCode;
        public String serviceVersion;
        public Integer reasonCode;
        public String echoKey;
    }
     /** 
     *@description msgentry
     */
    public without sharing class msgentry{        
        public string msgClass;
        public string msgCode; 
        public string msgErrInd;
        public string msgTxt;
        
    }
    /** 
     *@description createDummyResponse
     *@return SVcreateLinkSavingsDepAccount_Resp_IB_v2
     */
    public static SVcreateLinkSavingsDepAccount_Resp_IB_v2 createDummyResponse(){
        SVcreateLinkSavingsDepAccount_Resp_IB_v2 respBean = new SVcreateLinkSavingsDepAccount_Resp_IB_v2();
        SVcreateLinkSavingsDepAccount_Resp_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6Response sVcreateLinkSavingsDepAccountV2 = new SVcreateLinkSavingsDepAccount_Resp_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6Response();
        SVcreateLinkSavingsDepAccount_Resp_IB_v2.svpp15o svpp15o = new SVcreateLinkSavingsDepAccount_Resp_IB_v2.svpp15o();
        //svpp15o.accountNumber ='9051373299';
        
        SVcreateLinkSavingsDepAccount_Resp_IB_v2.nbsapdpo nbsapdpo = new SVcreateLinkSavingsDepAccount_Resp_IB_v2.nbsapdpo();
        nbsapdpo.echoKey = null;
        //nbsapdpo.reasonCode = '0';
        //nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO006';
        nbsapdpo.version = null;
        
        SVcreateLinkSavingsDepAccount_Resp_IB_v2.nbsmsgo3 nbsmsgo3 = new SVcreateLinkSavingsDepAccount_Resp_IB_v2.nbsmsgo3();
        //nbsmsgo3.nbrUserErrs = '0';
        //nbsmsgo3.nbrUserMsgs = '0';
        nbsmsgo3.sysErrTxt = null;
        nbsmsgo3.version = null;
        
        return respBean;
    }
    
}