/*
* Integration Utility Bean for MBcomplEpSpaymentV4 Service
* @author Rankwe Lulu
* @created March 2020
*/

public class MBcomplEpSpaymentV4_IU_v1 {
    
    public static MBcomplEpSpaymentV4_Req_IB_v1 mapRequestFields(String uniqueEft){

        MBcomplEpSpaymentV4_Req_IB_v1 requestBean = new MBcomplEpSpaymentV4_Req_IB_v1();
        MBcomplEpSpaymentV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new MBcomplEpSpaymentV4_Req_IB_v1.nbsmsgi();
        MBcomplEpSpaymentV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new MBcomplEpSpaymentV4_Req_IB_v1.nbsapdpi();
        MBcomplEpSpaymentV4_Req_IB_v1.mbp302i mbp302iBean = new MBcomplEpSpaymentV4_Req_IB_v1.mbp302i();
        
        nbsmsgiBean.msgLanguage ='E';
        nbsmsgiBean.msgTarget = 'STD';
        
        nbsapdpiBean.application ='SALESFOR';
        nbsapdpiBean.channel ='SALESFOR';
        nbsapdpiBean.trace = 'Y';
        
        mbp302iBean.channel = 'SALESFOR'; 
        mbp302iBean.overrideCompl = ''; 
        mbp302iBean.instrType = 'OOP'; 
        mbp302iBean.uniqueEft = uniqueEft;
        mbp302iBean.paymNo = '1';
        mbp302iBean.paymIipInd = '';
        mbp302iBean.initpaymOverride ='';
        mbp302iBean.initpaymOverride = '';
        mbp302iBean.tellerAmtAuth = '';
        mbp302iBean.productsSpa = '';
        mbp302iBean.tranCodeDr = '';
        mbp302iBean.sfncCodeDr ='';
        mbp302iBean.sourceIndDr = '';
        mbp302iBean.tranCodeCr = '';
        mbp302iBean.sfncCodeCr = '';
        mbp302iBean.changeOverride = '';
        
        MBcomplEpSpaymentV4_Req_IB_v1.MBcomplEPSpaymentV4 MBcomplEPSpaymentV4Bean = new MBcomplEpSpaymentV4_Req_IB_v1.MBcomplEPSpaymentV4();
        MBcomplEPSpaymentV4Bean.nbsmsgi = nbsmsgiBean;
        MBcomplEPSpaymentV4Bean.nbsapdpi = nbsapdpiBean;
        MBcomplEPSpaymentV4Bean.mbp302i = mbp302iBean;
        requestBean.MBcomplEPSpaymentV4 = MBcomplEPSpaymentV4Bean;   

        System.debug('requestBean: ' + requestBean);
        return requestBean;

        
    } 
    
      public static MBcomplEpSpaymentV4_Req_IB_v1 mapPayBeneficiaryRequestFields(String uniqueEft, String paymNo){

        MBcomplEpSpaymentV4_Req_IB_v1 requestBean = new MBcomplEpSpaymentV4_Req_IB_v1();
        MBcomplEpSpaymentV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new MBcomplEpSpaymentV4_Req_IB_v1.nbsmsgi();
        MBcomplEpSpaymentV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new MBcomplEpSpaymentV4_Req_IB_v1.nbsapdpi();
        MBcomplEpSpaymentV4_Req_IB_v1.mbp302i mbp302iBean = new MBcomplEpSpaymentV4_Req_IB_v1.mbp302i();
        
        nbsmsgiBean.msgLanguage ='E';
        nbsmsgiBean.msgTarget = 'STD';
        
        nbsapdpiBean.application ='SALESFOR';
        nbsapdpiBean.channel ='SALESFOR';
        nbsapdpiBean.trace = 'Y';
        
        mbp302iBean.channel = 'SALESFOR'; 
        mbp302iBean.overrideCompl = ''; //change
        mbp302iBean.instrType = 'VP'; //change oo
        mbp302iBean.uniqueEft = uniqueEft;
        mbp302iBean.paymNo = paymNo;// '1';null// ""
        mbp302iBean.paymIipInd = '';
        mbp302iBean.initpaymOverride ='';
        mbp302iBean.initpaymOverride = '';
        mbp302iBean.tellerAmtAuth = '';
        mbp302iBean.productsSpa = '';
        mbp302iBean.tranCodeDr = '';
        mbp302iBean.sfncCodeDr ='';
        mbp302iBean.sourceIndDr = '';
        mbp302iBean.tranCodeCr = '';
        mbp302iBean.sfncCodeCr = '';
        mbp302iBean.changeOverride = '';
        
        MBcomplEpSpaymentV4_Req_IB_v1.MBcomplEPSpaymentV4 MBcomplEPSpaymentV4Bean = new MBcomplEpSpaymentV4_Req_IB_v1.MBcomplEPSpaymentV4();
        MBcomplEPSpaymentV4Bean.nbsmsgi = nbsmsgiBean;
        MBcomplEPSpaymentV4Bean.nbsapdpi = nbsapdpiBean;
        MBcomplEPSpaymentV4Bean.mbp302i = mbp302iBean;
        requestBean.MBcomplEPSpaymentV4 = MBcomplEPSpaymentV4Bean;   

        System.debug('requestBean: ' + requestBean);
        return requestBean;

        
    } 
    
    
    public static MBcomplEpSpaymentV4_Resp_IB_v1 mapResponseFields(HttpResponse responseP){ 
        
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean = (MBcomplEpSpaymentV4_Resp_IB_v1)JSON.deserialize(responseP.getBody().replace('transaction','transactionList'), MBcomplEpSpaymentV4_Resp_IB_v1.class);
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getstatusCode();
        responseBean.message = '';
        
        return responseBean;
        


    }
    
    public static MBcomplEpSpaymentV4_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean = new MBcomplEpSpaymentV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    
    
        


}