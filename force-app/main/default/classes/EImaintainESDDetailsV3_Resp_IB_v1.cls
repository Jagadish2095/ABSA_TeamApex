/*
* Response Integration Bean for EImaintainESDDetailsV3 Service
* @author Muvhuso Nekhubvi
* @created 2020/04/07
*/
public class EImaintainESDDetailsV3_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    public class EImaintainESDDetailsV3Response {
        @AuraEnabled public Nbsapdpo nbsapdpo;
        @AuraEnabled public Nbsmsgo nbsmsgo;
        @AuraEnabled public Eip103o eip103o;
    }
    
    public class Nbsapdpo {
        @AuraEnabled public String version;
        @AuraEnabled public String returnCode;
        @AuraEnabled public String reasonCode;
        @AuraEnabled public String serviceVersion;
    }
    
    public class Entry {
        @AuraEnabled public String wm;
        @AuraEnabled public String eLngth;
        @AuraEnabled public String email;
    }
    
    @AuraEnabled public EImaintainESDDetailsV3Response EImaintainESDDetailsV3Response;
    
    public class Nbsmsgo {
        @AuraEnabled public String version;
        @AuraEnabled public String nbrUserMsgs;
        @AuraEnabled public String nbrUserErrs;
    }
    
    public class Eip103o {
        @AuraEnabled public String request;
        @AuraEnabled public String channel;
        @AuraEnabled public String site;
        @AuraEnabled public String teller;
        @AuraEnabled public String acn;
        @AuraEnabled public String product;
        @AuraEnabled public String prodCode;
        @AuraEnabled public String jvCode;
        @AuraEnabled public String sdate;
        @AuraEnabled public String stime;
        @AuraEnabled public String eCount;
        @AuraEnabled public String lDate;
        @AuraEnabled public String lTime;
        @AuraEnabled public String lChannel;
        @AuraEnabled public String lSite;
        @AuraEnabled public String lTeller;
        @AuraEnabled public String status;
        @AuraEnabled public String marketerCodeInit;
        @AuraEnabled public String marketerCodeAmend;
        @AuraEnabled public List<Entry> entry;
    }
    
    public static EImaintainESDDetailsV3_Resp_IB_v1 dummyResponse(){
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean = new EImaintainESDDetailsV3_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        EImaintainESDDetailsV3_Resp_IB_v1.Nbsapdpo nbsapdpo = new EImaintainESDDetailsV3_Resp_IB_v1.Nbsapdpo();
        nbsapdpo.version='0';
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        EImaintainESDDetailsV3_Resp_IB_v1.Nbsmsgo nbsmsgo = new EImaintainESDDetailsV3_Resp_IB_v1.Nbsmsgo();
        nbsmsgo.version = 'MSG3001';
        nbsmsgo.nbrUserErrs = '0';
        nbsmsgo.nbrUserMsgs = '0';
        
        EImaintainESDDetailsV3_Resp_IB_v1.Eip103o Eip103oRequest = new EImaintainESDDetailsV3_Resp_IB_v1.Eip103o();
        Eip103oRequest.request =  'E' ;
        Eip103oRequest.channel =  'B'  ;
        Eip103oRequest.site =  '0'  ;
        Eip103oRequest.teller =  '0'  ;
        Eip103oRequest.acn =  '0'  ;
        Eip103oRequest.product =  'CQ'  ;
        Eip103oRequest.prodCode =  '11032'  ;
        Eip103oRequest.jvCode =  '0'  ;
        Eip103oRequest.sdate =  '0'  ;        
        Eip103oRequest.stime =  '0' ;
        Eip103oRequest.eCount =  '0'  ;
        Eip103oRequest.lDate =  '0'  ;
        Eip103oRequest.lTime =  '0'  ;
        Eip103oRequest.lChannel =  '0'  ;
        Eip103oRequest.lSite =  '0'  ;
        Eip103oRequest.lTeller =  '0'  ;
        Eip103oRequest.status =  '0'  ;
        Eip103oRequest.marketerCodeInit =  '0'  ;        
        Eip103oRequest.marketerCodeAmend =  '0' ;
        
        List<EImaintainESDDetailsV3_Resp_IB_v1.entry> entryList = new List<EImaintainESDDetailsV3_Resp_IB_v1.entry>();            
        EImaintainESDDetailsV3_Resp_IB_v1.entry entry = new EImaintainESDDetailsV3_Resp_IB_v1.entry();
        entry.email = 'test@test,co,za';
        entry.wm = '';
        entryList.add(entry);
        Eip103oRequest.entry =  entryList  ;
        
        EImaintainESDDetailsV3_Resp_IB_v1.EImaintainESDDetailsV3Response EImaintainESDDetailsV3Responsebean = new EImaintainESDDetailsV3_Resp_IB_v1.EImaintainESDDetailsV3Response();
        EImaintainESDDetailsV3Responsebean.nbsapdpo = nbsapdpo;
        EImaintainESDDetailsV3Responsebean.nbsmsgo = nbsmsgo;
        EImaintainESDDetailsV3Responsebean.Eip103o = Eip103oRequest;
        
        responseBean.EImaintainESDDetailsV3Response = EImaintainESDDetailsV3Responsebean;
        
        return responseBean;
    }
}