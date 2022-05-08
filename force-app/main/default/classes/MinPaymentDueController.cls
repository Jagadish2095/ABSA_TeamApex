/**
* Apex controller class for the Aura bundle MinimumPaymentDue.
* Test Class Name: MinPaymentDueController_Test
* @author Haritha P : Absa
* @since   2019-09-20
*
**/
public class MinPaymentDueController {
    @AuraEnabled
    public static String getMinimumPayDueCHQ(String selectedAccNumber){
          Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>> responseMap = CQgetPaymentDue_IH_v1.getCQPaymentDueResponseDetails('BDP', 'BDP', 'Y', 'E', 'STD',selectedAccNumber, '034', '034', '1234', '1');
          CQgetPaymentDue_Resp_IB_V1 responseBean = (new List<CQgetPaymentDue_Resp_IB_V1>(responseMap.keySet()))[0];
          if(responseBean.statusCode == 200){
            CQgetPaymentDue_Resp_IB_V1.CQgetPaymentDueV1Response wrapper = responseBean.CQgetPaymentDueV1Response;
      		CQgetPaymentDue_Resp_IB_V1.Cqh844o cls_Cqh844o = wrapper.cqh844o;
            return JSON.serialize(cls_Cqh844o);
        }
        return null;
    }
    
     @AuraEnabled
    public static void sendEmailNotifications(String accNumber, String minAmountDue, 
                                              Id caseRecordId, String emailAddress, 
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
       Id targetObjectId = [Select id,Email from Contact where Email != '' limit 1].Id; //get any dummy contact just for sake of passing it
         List<Messaging.SingleEmailMessage> EmailMsg =   EmailHandler.composeEmail(caseRecordId,targetObjectId,emailAddress,'MinimumPaymentDue');
         Messaging.SingleEmailMessage email = EmailMsg.get(0);
            String htmlBody = email.getHTMLBody();
            String addMaskedAccInEmailBody =  htmlBody.replace('[accountNumber] ', accNumber);                                    
            String addAmtDueInEmailBody = addMaskedAccInEmailBody.replace('[AmountDue]', minAmountDue);
            sendMailFromFlowforminpay(emailAddress,addAmtDueInEmailBody); 
      }
    
    //Send email to client using dymanic body and email
     public static void sendMailFromFlowforminpay( string emailAddress, string emailBody ){
         
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'businessbanking@absa.africa'];
         
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {emailAddress};
        email.setToAddresses(to);
        email.setOrgWideEmailAddressId(owea.get(0).Id);
        email.setSubject('Minimum PaymentDue for your Account');
        email.setHtmlBody(emailBody); 
       
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
        
    
   }
}