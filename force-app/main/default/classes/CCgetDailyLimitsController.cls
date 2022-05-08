/**
* Apex controller class for the Aura bundle GetDailyLimits.
* Test Class Name: CCgetDailyLimitsController_Test
* @author Muvhuso N : Absa
* @since   2019-10/16
*
**/
public class CCgetDailyLimitsController {
   @AuraEnabled
    public static String getDailyLimits(String selectedCombiNumber){
          Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(selectedCombiNumber);
          CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
          if(responseBean.statusCode == 200){
            CCgetDailyLimits_Resp_IB_v1.CCgetDailyLimitsV2Response wrapper = responseBean.CCgetDailyLimitsV2Response;
      		CCgetDailyLimits_Resp_IB_v1.ccp312o cls_CCp312o = wrapper.ccp312o;
            return JSON.serialize(cls_CCp312o);
        }
        return null;
    }
    
    @AuraEnabled
    public static String updateDailyLimits(String telerCode , String workStation, String supervisor , String branchCode, String combiNbr, String cardCshLim, String cardTrfLim, String cardPosLim, String cardCntLim, String cheqNomAcc, String cheqApplNo, String cheqCshLim, String cheqTrfLim, String cheqPosLim,String savsNomAcc,String savsApplNo, String savsCshLim, String savsTrfLim, String savsPosLim){
          Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCupdDailyTransactionLimitsV2_IH_v1.CCupdateDailyLimits(telerCode, workStation, supervisor, branchCode, combiNbr, cardCshLim, cardTrfLim, cardPosLim, cardCntLim, cheqNomAcc, cheqApplNo, cheqCshLim, cheqTrfLim, cheqPosLim, savsNomAcc, savsApplNo, savsCshLim, savsTrfLim, savsPosLim);
        system.debug('combiNbr------'+combiNbr);
          CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = (new List<CCupdDailyTransactionLimitsV2_Resp_IB_v1>(responseMap.keySet()))[0];
        system.debug('responseBean----'+responseBean);
          if(responseBean.statusCode == 200){
              system.debug('enteredd------');
            CCupdDailyTransactionLimitsV2_Resp_IB_v1.ccUpdDailyTransactionLimitsV2Response wrapper = responseBean.ccUpdDailyTransactionLimitsV2Response;
      		//CCupdDailyTransactionLimitsV2_Resp_IB_v1.Ccp321o ccp321o = wrapper.Ccp321o;
            system.debug('ccp321o------'+JSON.serialize(wrapper));
            return JSON.serialize(wrapper);
              
        }
        return null;

}
    //Added for sending email notification for Change Combi Card Transaction limit  
    @AuraEnabled
    public static void sendEmailNotifications(Id caseRecordId, String emailAddress, 
                                              String mobileNumber, String commMethod){
       if(caseRecordId!=null){
            Case caseObj = new Case(Id=caseRecordId);
            caseObj.Email__c = emailAddress;
            caseObj.Mobile__c = mobileNumber;
            caseObj.Communication_Method__c = commMethod;
            caseObj.Status = 'Closed';
            caseObj.Bypass_Validation_Rules__c = true;
            Update caseObj;
        }
       Id targetObjectId = [Select id,Email from Contact where Email!='' limit 1].Id; //get any dummy contact just for sake of passing it
         List<Messaging.SingleEmailMessage> EmailMsg =   EmailHandler.composeEmail(caseRecordId,targetObjectId,emailAddress,'CombiCardsTransactionLimit');
         Messaging.SingleEmailMessage email = EmailMsg.get(0);
            String htmlBody = email.getHTMLBody();
            sendMailFromFlowforcardlimit(emailAddress,htmlBody); 
      }
    
    //Send email to client using dymanic body and email
     public static void sendMailFromFlowforcardlimit( string emailAddress,string emailBody){
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {emailAddress};
        email.setToAddresses(to);
        email.setSubject('Change in your Card Limits');
        email.setHtmlBody(emailBody); 
       
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
        
    
   }
}