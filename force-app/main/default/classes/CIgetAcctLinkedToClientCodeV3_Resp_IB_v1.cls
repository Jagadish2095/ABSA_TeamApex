/*
* Response Integration Bean for CIgetAcctLinkedToClientCodeV3 Service
* @author Khaliq Abdul
* @created 2021-02-26
*/
public class CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 extends Base_IB {
    
   
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;     
    
    @AuraEnabled public Nbsapdpo nbsapdpo {get;set;} 
    @AuraEnabled public Nbsmsgo3 nbsmsgo3 {get;set;} 
    @AuraEnabled public Cip047o cip047o {get;set;}
    
    public class Nbsapdpo 
    {
        @AuraEnabled public String version {get;set;} 
        @AuraEnabled public String returnCode {get;set;} 
        @AuraEnabled public String reasonCode {get;set;} 
        @AuraEnabled public String serviceVersion {get;set;} 
        @AuraEnabled public String echoKey {get;set;} 
    }
    
    public class Nbsmsgo3 
    {
        @AuraEnabled public String version {get;set;} 
        @AuraEnabled public String sysErrTxt {get;set;} 
        @AuraEnabled public String nbrUserMsgs {get;set;} 
        @AuraEnabled public String nbrUserErrs {get;set;} 
        @AuraEnabled public List<MsgEntry> msgEntry {get;set;} 
    }
    
    public class MsgEntry 
    {
        @AuraEnabled public String msgClass {get;set;} 
        @AuraEnabled public String msgCode {get;set;} 
        @AuraEnabled public String msgErrInd {get;set;} 
        @AuraEnabled public String msgTxt {get;set;} 
    }
    public class Cip047o {
        @AuraEnabled public String counter {get;set;} 
        @AuraEnabled public String orestart {get;set;} 
        @AuraEnabled public List<OutputTable> outputTable {get;set;} 
    }
    
    public class OutputTable {
        @AuraEnabled public String oaccntnbr {get;set;} 
        @AuraEnabled public String product {get;set;} 
        @AuraEnabled public String productType {get;set;} 
        @AuraEnabled public String branch {get;set;} 
        @AuraEnabled public String corp {get;set;} 
        @AuraEnabled public String status {get;set;} 
        @AuraEnabled public String dtclosed {get;set;} 
        @AuraEnabled public String balance {get;set;} 
        @AuraEnabled public String limit_Z {get;set;} // in json: limit
        @AuraEnabled public String balanceTxt {get;set;} 
        @AuraEnabled public String detail {get;set;} 
        @AuraEnabled public String availableBalance {get;set;} 
        @AuraEnabled public String srcOfFnds1 {get;set;} 
        @AuraEnabled public String srcOfFnds2 {get;set;} 
        @AuraEnabled public String srcOfFnds3 {get;set;} 
        @AuraEnabled public String srcOfFnds4 {get;set;} 
        @AuraEnabled public String srcOfFnds5 {get;set;} 
    }
    
    public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"limit":', '"limit_Z":');
    }
    
    public static CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 dummyResponse(){
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Nbsapdpo nbsapdpo = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Nbsapdpo();
        nbsapdpo.version='0';
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        nbsapdpo.echoKey='';
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Nbsmsgo3 nbsmsgo3 = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.sysErrTxt='';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry msgEntrybean = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry(); 
        List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry> msgEntrybeanList = new List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.msgEntry>();
        msgEntrybean.msgClass = 'Linking';
        msgEntrybean.msgCode = '0005';
        msgEntrybean.msgErrInd = 'E';
        msgEntrybean.msgTxt = 'Details does not exist';
        
        msgEntrybeanList.add(msgEntrybean);
        nbsmsgo3.msgEntry = msgEntrybeanList;
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Cip047o Cip047oRequest = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.Cip047o();
        Cip047oRequest.counter =  '0' ;
        Cip047oRequest.orestart =  '0'  ;
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable OutputTableRequest= new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable();         
        List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> OutputTableRequestList = new List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable>();
        OutputTableRequest.oaccntnbr =  '00000004048280107'  ;
        OutputTableRequest.product =  'BUSIESS'  ;
        OutputTableRequest.productType =  'CQ'  ;
        OutputTableRequest.branch =  '5920'  ;
        OutputTableRequest.corp =  'ABS'  ;
        OutputTableRequest.status =  'CLOSED'  ;
        OutputTableRequest.dtclosed =  'APR 20'  ;        
        OutputTableRequest.balance =  '0' ;
        OutputTableRequest.limit_Z =  '0'  ;
        OutputTableRequest.balanceTxt =  '0'  ;
        OutputTableRequest.detail =  '0'  ;
        OutputTableRequest.availableBalance =  ''  ;
        OutputTableRequest.srcOfFnds1 =  ''  ;
        OutputTableRequest.srcOfFnds2 =  '0'  ;
        OutputTableRequest.srcOfFnds3 =  '0'  ;
        OutputTableRequest.srcOfFnds4 =  '0'  ;
        OutputTableRequest.srcOfFnds5 =  ''  ;
        
        OutputTableRequestList.add(OutputTableRequest);
        Cip047oRequest.outputTable =  OutputTableRequestList ;
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 CIgetAcctLinkedToClientCodeV3_Resp_IB_v1bean = new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1();
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1bean.nbsapdpo = nbsapdpo;
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1bean.nbsmsgo3 = nbsmsgo3;
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1bean.Cip047o = Cip047oRequest;
        
        responseBean = CIgetAcctLinkedToClientCodeV3_Resp_IB_v1bean;
        
        return responseBean;
    }
    
}