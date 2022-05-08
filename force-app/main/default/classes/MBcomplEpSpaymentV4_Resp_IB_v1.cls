/*
* Integration Response for MBcomplEpSpaymentV4 service
* @author Lulu Rankwe
* @created March 202
*/
public class MBcomplEpSpaymentV4_Resp_IB_v1 extends Base_IB{
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;   
    
    // public MBcomplEPSpaymentV4Response MBcomplEPSpaymentV4Response;
    @AuraEnabled public MBcomplEPSpaymentV4Response MBcomplEPSpaymentV4Response{get;set;}
   // @AuraEnabled public mbp302o mbp302o;
    
    public class nbsapdpo{
        @AuraEnabled public String serviceVersion{get;set;}
        @AuraEnabled public String reasonCode{get;set;}
        @AuraEnabled public String returnCode{get;set;}
    }
    public class nbsmsgo{
        @AuraEnabled public String version{get;set;}
        @AuraEnabled public String nbrUserErrs{get;set;}
        @AuraEnabled public String nbrUserMsgs{get;set;}
    }
    
    public class mbp302o{
        @AuraEnabled public String trgAccType{get;set;}
        @AuraEnabled public String corpCode{get;set;}
        @AuraEnabled public String trgStmtRef{get;set;}
        @AuraEnabled public String sbu{get;set;}
        @AuraEnabled public String trgInstCode{get;set;}
        @AuraEnabled public String payDay{get;set;}
        @AuraEnabled public String trgClrCode{get;set;}
        @AuraEnabled public String doType{get;set;}
        @AuraEnabled public String trgAcc{get;set;}
        @AuraEnabled public String cardAuth{get;set;}
        @AuraEnabled public String srcStmtRef{get;set;}
        @AuraEnabled public String notifInd{get;set;}
        @AuraEnabled public String srcInstCode{get;set;}
        @AuraEnabled public String srcNotifMed{get;set;}
        @AuraEnabled public String srcClrCode{get;set;}
        @AuraEnabled public String trgNotifMed{get;set;}
        @AuraEnabled public String srcAccType{get;set;}
        @AuraEnabled public String lastMaintOvrId{get;set;}
        @AuraEnabled public String srcAcc{get;set;}
        @AuraEnabled public String lastMaintOvr2Id{get;set;}
        @AuraEnabled public String amount{get;set;}
        @AuraEnabled public String changeOverride2{get;set;}
        @AuraEnabled public String trigDate{get;set;}
        @AuraEnabled public String changeOverride{get;set;}
        @AuraEnabled public String actDate{get;set;}
        @AuraEnabled public String paymStatus{get;set;}
        @AuraEnabled public String intExtBenInd{get;set;}
        @AuraEnabled public String paymTime{get;set;}
        @AuraEnabled public String instrStatus{get;set;}
        @AuraEnabled public String paymProcessAmnt{get;set;}
        @AuraEnabled public String fwWarnInd{get;set;}
        @AuraEnabled public String paymErrCode{get;set;}
        @AuraEnabled public String respDesc{get;set;}
        @AuraEnabled public String paymIipInd{get;set;}
        @AuraEnabled public String recsReturn{get;set;}
        @AuraEnabled public String paymIipAuth{get;set;}
        @AuraEnabled public String respOther{get;set;}
        @AuraEnabled public String paymBusRef{get;set;}
        @AuraEnabled public String respCode{get;set;}
        @AuraEnabled public String paymNotes{get;set;}
        @AuraEnabled public String timeNow{get;set;}
        @AuraEnabled public String initpaymOverride{get;set;}
        @AuraEnabled public String todaysDate{get;set;}
        @AuraEnabled public String productsSpa{get;set;}
        @AuraEnabled public String procMode{get;set;}
    }
    
    public class MBcomplEpSpaymentV4Response{
        @AuraEnabled  public nbsmsgo nbsmsgo{get;set;}
        @AuraEnabled  public nbsapdpo nbsapdpo{get;set;}
        @AuraEnabled  Public mbp302o mbp302o{get;set;}
    }
       
    public static MBcomplEpSpaymentV4_Resp_IB_v1 dummyResponse(){
        
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean = new MBcomplEpSpaymentV4_Resp_IB_v1();
        MBcomplEpSpaymentV4_Resp_IB_v1.nbsapdpo  nbsapdpo =  new MBcomplEpSpaymentV4_Resp_IB_v1.nbsapdpo();
        MBcomplEpSpaymentV4_Resp_IB_v1.nbsmsgo  nbsmsgo =  new MBcomplEpSpaymentV4_Resp_IB_v1.nbsmsgo();
        MBcomplEpSpaymentV4_Resp_IB_v1.mbp302o  mbp302o = new MBcomplEpSpaymentV4_Resp_IB_v1.mbp302o();
        
        responseBean.status ='';
        responseBean.statusCode = 200;
        responseBean.message = '';
        
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO001';
        
        nbsmsgo.version = 'MSG3021';
        nbsmsgo.nbrUserErrs = '0';
        nbsmsgo.nbrUserMsgs = '0';

        
        mbp302o.procMode = '0';
        mbp302o.todaysDate = '20200413';
        mbp302o.timeNow = '14162108';
        mbp302o.respCode = '0';
        mbp302o.respOther = '0';
        mbp302o.recsReturn = '1';
        mbp302o.respDesc = 'SUCCESSFUL PROCESS';
        mbp302o.fwWarnInd = '';
        mbp302o.instrStatus= 'CURRENT';
        mbp302o.intExtBenInd = 'E';
        mbp302o.actDate = '20200218';
        mbp302o.trigDate = '20200218';
        mbp302o.amount = '500.23';
        mbp302o.srcAcc = '000000000000009050544469';
        mbp302o.srcAccType = 'SA';
        mbp302o.srcClrCode = '632005';
        mbp302o.srcInstCode = 'ABSA BANK';
        mbp302o.srcStmtRef = 'test ac';
        mbp302o.trgAcc = '000000000000062001847237';
        mbp302o.trgAccType = '1';
        mbp302o.trgClrCode = '250655';
        mbp302o.trgInstCode = 'FIRSTRAND';
        mbp302o.trgStmtRef = 'test ac';
        mbp302o.corpCode = 'Z';
        mbp302o.sbu = 'F';
        mbp302o.payDay = '0';
        mbp302o.doType ='';
        mbp302o.cardAuth = '0';
        mbp302o.notifInd = '';
        mbp302o.srcNotifMed = 'N';
        mbp302o.trgNotifMed = 'N';
        mbp302o.lastMaintOvrId ='';
        mbp302o.lastMaintOvr2Id = '';
        mbp302o.changeOverride2 = '';
        mbp302o.changeOverride = '';
        mbp302o.paymStatus = 'COMPLPAYM';
        mbp302o.paymTime = '114900';
        mbp302o.paymProcessAmnt = '500.23';
        mbp302o.paymErrCode = '0';
        mbp302o.paymIipInd = 'D';
        mbp302o.paymIipAuth = '323589';
        mbp302o.paymBusRef = '1605F9ACE7';
        mbp302o.paymNotes ='';
        mbp302o.initpaymOverride = '';
        mbp302o.productsSpa = '';
        
        return responseBean;
    }  
 
    
}