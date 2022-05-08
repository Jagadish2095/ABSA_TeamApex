/**
* @description       : Handler class for EcaseView services 
* @author            : Prasanth Boggula
* @param             :caseId
* 
**/
public  class EcasaViewServices{
      /***
* @comment : getEcasadate
* @description Calling ECASA serives to display 
* @param caseId
* @return wqp102o 
* **/    
    @AuraEnabled
    public static wqp102o getEcasadate(string caseId){
        
        string caserefnumber;
        if(Account.SobjectType.getDescribe().isAccessible()){
            caserefnumber=[select Account.CASA_Reference_Number__c from case where id=:caseId].Account.CASA_Reference_Number__c;
        }
        
        WQgetCASAStatusByRefNoV7_Req_IB_v1 requestBean = WQgetCASAStatusByRefNoV7_Req_IB_v1.CreateInstance();
         requestBean.WQgetCASAStatusByRefNoV7.wqp102i.refNo =caserefnumber;//caserefnumber;// '120027254';
        
        WQgetCASAStatusByRefNoV7_Resp_IB_v1 ecaseResponse=new WQgetCASAStatusByRefNoV7_Resp_IB_v1();
        if(requestBean.WQgetCASAStatusByRefNoV7.wqp102i.refNo!=null && !test.isRunningTest()){
            ecaseResponse=WQgetCASAStatusByRefNoV7_IH_v1.WQgetCASAStatusByRefNoV7(requestBean);
        }
        if(test.isRunningTest()){
            ecaseResponse=WQgetCASAStatusByRefNoV7_Resp_IB_v1.DummyResponse();
        }
       
        
        wqp102o newwqp102o=new wqp102o();
        newwqp102o.firstName=string.valueof(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.firstName);
        newwqp102o.surnameComp=string.valueof(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.surnameComp);
        newwqp102o.idType=string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.idType);
        newwqp102o.idRegNo=string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.idRegNo);
        newwqp102o.casaStatus =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.casaStatus);
        newwqp102o.approvedSts =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.approvedSts);
        newwqp102o.documentSts  =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.documentSts);
        newwqp102o.pepSts  =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.pepSts);
        newwqp102o.comments  =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.comments);
        newwqp102o.msgNo  =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.msgNo);
        newwqp102o.msg  =string.valueOf(ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o.msg);
        
       // system.debug('testrestestres>>>'+ecaseResponse.WQgetCASAStatusByRefNoV7Response.wqp102o);
        
        return newwqp102o;
    }
    /**
* @description       : Handler class for EcaseView services 
* @author            : Prasanth Boggula
* @param             :caseId
* 
**/
    public class wqp102o {
         /**
        * @description
        */
        @AuraEnabled public String firstName {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String surnameComp {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String idType {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String idRegNo {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String casaStatus {set;get;}
         /**
        * @description
        */
        @AuraEnabled public string approvedSts {set;get;}
         /**
        * @description
        */
        @AuraEnabled public string documentSts {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String pepSts {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String comments {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String msgNo {set;get;}
         /**
        * @description
        */
        @AuraEnabled public String msg {set;get;}
    }
    
}