/*
* Apex Class for Fulfillment -Term Loans Conditions and Agreements 
* 
* @author  Almas Aleem
* @version v1.0
* @since   2020-11-30
* @UserStory W-008016
*/
public class TermloanConditionsController {
    
    
    @AuraEnabled 
    public static Application_Product__c getAppProduct(Id oppId){
        List<Application_Product__c > prodlist = new ApplicationproductSelector().selectByOpportunityId(oppId);
        
        
        return prodlist[0];
        
        
    }
     
    @AuraEnabled
    public static String updateConditionsOfAgreement(Id appProdId,String landlordWaiverInd,String insuranceInd,String elecTransferInd,String contractSigned,
                                                    Integer mandateNum,Integer tellerNum){
       String result ='' ; 
        
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProdId));
        // term loan account number
        String accountNo = String.valueof(appProdRec.Account_Number__c); 
        //response of update service
        String ABFAccresponse = appProdRec.ABFupdAccountDetails_Response__c;
        ABFupdAccountStatusV1_Resp_IB_V1 ABFresponse ;
                       if(ABFAccresponse !=null ){
                            ABFresponse = (ABFupdAccountStatusV1_Resp_IB_V1) JSON.deserialize(ABFAccresponse, ABFupdAccountStatusV1_Resp_IB_V1.class);
                      
                       }else{
                           return 'Update Account Details!';
                       }
              user u = new UsersSelector().selectById(userinfo.getUserId());
                                                        //use selector later
        //user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User where id=:userinfo.getUserId()];                                        
       
         ABFupdConditionsOfAgreement_Resp_IB_v1 responseBean = ABFupdConditionsOfAgreement_IH_v1.GetABFupdConditions(u,accountNo,ABFresponse,landlordWaiverInd ,insuranceInd, elecTransferInd,contractSigned,
                                                     mandateNum,tellerNum);                                              
                 
         if(responseBean != null){
            List<ABFupdConditionsOfAgreement_Resp_IB_v1.MessageEntryTabel>  messageEnteryList=  responseBean.messageErrors.outPutMessageErrors.MessageEntryTabel == null ? null :responseBean.messageErrors.outPutMessageErrors.MessageEntryTabel; 
          
             if(messageEnteryList !=null && messageEnteryList.size()>0){
                 for(ABFupdConditionsOfAgreement_Resp_IB_v1.MessageEntryTabel message :messageEnteryList){
                     if(message.messageText != null && message.messageText !=''){
                        result = message.messageText;
                         break;
                     }
                    // result = message.messageText == null ? 'Error in service response':message.messageText ;
                     // result = 'Failure';
                      //con; 
                    else{
                        result = 'Success';
                    }
                 }
                 
             }else{
                 result = 'Success';
             }
         }
               
      //generate request
      ABFupdConditionsOfAgreement_Req_IB_v1 requestBean = ABFupdConditionsOfAgreement_IU_v1.mapRequestFields(u,accountNo,ABFresponse,landlordWaiverInd, insuranceInd, elecTransferInd,contractSigned,
                                                     mandateNum,tellerNum); 
         //future method to insert request and response of abf conditions of agreement                                            
       TermloanConditionsController.insertRespBean(JSON.serialize(requestBean),JSON.serialize(responseBean),appProdId);   
                                                        
       return result;
    }
@future 
    public static void insertRespBean(String reqBean,String respBean,string appProdId)  
        {                
            Application_Product__c appProdResp = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            Application_Product__c appPrdUpdateResp = new Application_Product__c();
            if(appProdResp !=null){
                appPrdUpdateResp.id = appProdResp.Id;
                appPrdUpdateResp.ABFConditions_RequestBean__c = reqBean;
                appPrdUpdateResp.ABFConditions_ResponseBean__c = respBean;
                try{
                    update appPrdUpdateResp;
                    System.debug('appPrdUpdateResp ' + appPrdUpdateResp);
                }
                catch(Exception ex) {
                    
                    System.debug('Error appPrdUpdateResp: ' + ex.getDmlMessage(0));  
                }
            }      
            
        }   
}