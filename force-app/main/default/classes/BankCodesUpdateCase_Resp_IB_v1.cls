/*
 * Integration Handler for BankCodesUpdateCase Service
 * @author Thabo K Senkomane
 * @created 2020-07-30
 */

public class BankCodesUpdateCase_Resp_IB_v1  extends Base_IB {
     @AuraEnabled public String caseId{get;set;}
     @AuraEnabled public Boolean success{get;set;}
     @AuraEnabled public String status{get;set;}
    // @AuraEnabled public String message{get;set;}
    
    public static BankCodesUpdateCase_Resp_IB_v1 dummyResponse(){
        BankCodesUpdateCase_Resp_IB_v1 responseBean = new BankCodesUpdateCase_Resp_IB_v1();
       
        responseBean.status='UPDATED';
        responseBean.success=true;
        responseBean.caseId='REG-936';
        
        return responseBean;
    }    
}
 /*   public static BankCodesUpdateCase_Resp_IB_v1 dummyResponse(){
       BankCodesUpdateCase_Resp_IB_v1 responseBean = new BankCodesUpdateCase_Resp_IB_v1();
         responseBean.statusCode=200;
       responseBean.caseId='"REG-936'; 
       responseBean.success=true;
       responseBean.status='OK';

       return responseBean;
    }   
}

  * {
    "caseId": "REG-936",
    "success": true,
    "status": "UPDATED"
}
  */