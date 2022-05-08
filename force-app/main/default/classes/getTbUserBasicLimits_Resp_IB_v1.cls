/*
 * Response Integration Bean for getTbUserBasicLimits Service
 * @author Mashudu Raidmi
 * @created 2020-07-15
 */
public class getTbUserBasicLimits_Resp_IB_v1 extends Base_IB{
   
   public String status;
   public Integer statusCode;
   public getUserLimitResp getUserLimitResp; 
   public List<errorList> errorList;
    
   @AuraEnabled public Boolean error;
   @AuraEnabled public String additionalInfo;
    
    
    
    public class getUserLimitResp{
        @AuraEnabled public String intAccXfer;
        @AuraEnabled public String intAccXferUsed;
        @AuraEnabled public String ownDefPaym;
        @AuraEnabled public String ownDefPaymUsed;
        @AuraEnabled public String billPaym;
        @AuraEnabled public String billPaymUsed;
        @AuraEnabled public String futDtePaym;
        @AuraEnabled public String errorCode;
        @AuraEnabled public String errorMessage;
        
    }
    
    public class errorList{
        @AuraEnabled public String field;
        @AuraEnabled public String description;
    }
    
    
    
    public  getTbUserBasicLimits_Resp_IB_v1 (){}
         
     /*   getTbUserBasicLimits_Resp_IB_v1 responseBean = new getTbUserBasicLimits_Resp_IB_v1();
         
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.getUserLimitResp.intAccXfer = '10000';
        responseBean.getUserLimitResp.intAccXferUsed = '0';
        responseBean.getUserLimitResp.ownDefPaym = '10000';
        responseBean.getUserLimitResp.ownDefPaymUsed = '0';
        responseBean.getUserLimitResp.billPaym = '10000';
        responseBean.getUserLimitResp.billPaymUsed = '0';
        responseBean.getUserLimitResp.futDtePaym = '10000';
        responseBean.getUserLimitResp.errorCode = 'NA';
        responseBean.getUserLimitResp.errorMessage = 'NA';
         
        responseBean.error = false;
        responseBean.errorList = null;
        responseBean.additionalInfo = null;
         
       
         
        return responseBean;
        
         
     }*/

}