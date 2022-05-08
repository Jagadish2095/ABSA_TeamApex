/*
* Response Integration Bean for CCcloseV2 Service
* @author Lulu Rankwe
* @created 19-03-2020
* @modified by Mashudu Raidimi
*/
public class CCcloseV2_Resp_IB_v1 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message; 
    
    public CCcloseV2Response CCcloseV2Response{get;set;}
    
    public class nbsapdpo{
        public String serviceVersion{get;set;}
        public String reasonCode{get;set;}
        public String returnCode{get;set;}
    }
    public class nbsmsgo{
        public String version{get;set;}
        public String nbrUserMsgs{get;set;}
        public list<msgEntry> msgEntry{get;set;}
        public String nbrUserErrs{get;set;}
    }
    
	public class msgEntry{
		public String msgClass{get;set;}
		public String msgTxt{get;set;}
		public String msgErrInd{get;set;}
		public String msgCode{get;set;}
    }
    
   public class ccp327o{
        public String combiRetrvdInd{get;set;}
        public String combiClosedInd{get;set;}
       
    }
    
    public class CCcloseV2Response{
        public nbsmsgo nbsmsgo{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
        public ccp327o ccp327o{get;set;}
        
    }
    
    public Static CCcloseV2_Resp_IB_v1 dummyResponse(){
        CCcloseV2_Resp_IB_v1 response = new CCcloseV2_Resp_IB_v1();
        response.statusCode = 200;
        response.status='OK';
        
        CCcloseV2_Resp_IB_v1.nbsapdpo nbsapdpo = new CCcloseV2_Resp_IB_v1.nbsapdpo();
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        CCcloseV2_Resp_IB_v1.nbsmsgo nbsmsgo = new CCcloseV2_Resp_IB_v1.nbsmsgo();
        nbsmsgo.version = 'MSG3001';
        nbsmsgo.nbrUserErrs = '1';
        nbsmsgo.nbrUserMsgs = '1';
        
        CCcloseV2_Resp_IB_v1.msgEntry msgEntry = new CCcloseV2_Resp_IB_v1.msgEntry();
        msgEntry.msgClass = 'CCS299';
        msgEntry.msgCode = '0025';
        msgEntry.msgErrInd = 'E';
        msgEntry.msgTxt = 'Combi card number 4451430000030415 does not exist';
        
        CCcloseV2_Resp_IB_v1.ccp327o ccp327o = new CCcloseV2_Resp_IB_v1.ccp327o();
        ccp327o.combiRetrvdInd = null;
        ccp327o.combiClosedInd =null;
        
        CCcloseV2_Resp_IB_v1.CCcloseV2Response CCcloseV2bean = new CCcloseV2_Resp_IB_v1.CCcloseV2Response();
         CCcloseV2bean.nbsapdpo = nbsapdpo;
         CCcloseV2bean.nbsmsgo = nbsmsgo;
         CCcloseV2bean.ccp327o = ccp327o;
        
        response.CCcloseV2Response = CCcloseV2bean;
        
        return response;
    }
    



}