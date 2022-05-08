/**
* Apex Integration Response Bean class for CAstpLostStolenCardV2 Service
* @author  Madhava Palla : Absa
* @since   2019-09-10
*
**/
public class CAstpLostStolenCardV2_Resp_IB_v5 extends Base_IB{
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public String plasticCardNum;
    @AuraEnabled public String accHolderName;
    public class Nbsapdpo {
        @AuraEnabled public String returnCode;
        @AuraEnabled public String reasonCode;
    }
    
    public CAstpLostStolenCardV2Response CAstpLostStolenCardV2Response;
    
    public class Can912o {
        @AuraEnabled public String returnCd;
        @AuraEnabled public String returnMsg;
    }
    
    public class CAstpLostStolenCardV2Response {
        @AuraEnabled public Nbsapdpo nbsapdpo;
        @AuraEnabled public Can912o can912o;
    }
    
    public static CAstpLostStolenCardV2_Resp_IB_v5 dummyResponse(){
        CAstpLostStolenCardV2_Resp_IB_v5 responseBean = new CAstpLostStolenCardV2_Resp_IB_v5();
        responseBean.status ='Passes';
        responseBean.accHolderName ='Account Name';
        responseBean.message ='Display Message';
        responseBean.statusCode =200;
        responseBean.plasticCardNum ='123456';
        CAstpLostStolenCardV2_Resp_IB_v5.Nbsapdpo nbs = new CAstpLostStolenCardV2_Resp_IB_v5.Nbsapdpo();
        nbs.reasonCode ='123';
        nbs.returnCode ='123';
        CAstpLostStolenCardV2_Resp_IB_v5.Can912o can= new CAstpLostStolenCardV2_Resp_IB_v5.Can912o();
        can.returnCd='123';
        can.returnMsg ='Message';
        return responseBean;
    }
}