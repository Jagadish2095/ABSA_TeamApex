public class SendEmailForPaymentReq{   
    
    @AuraEnabled
    Public static String sendEmailOnCaseClose(Id caseRecordId, String emailAddress, String emailTemplate){
        String returnString ='success';
        try{   
            
            Case currentCase = [SELECT Id, CaseNumber, Account.Name,contactId FROM Case WHERE Id =: caseRecordId];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();//constructEmail.get(0);
            EmailTemplate et = [SELECT Id,body,htmlvalue,subject  FROM EmailTemplate WHERE DeveloperName =: emailTemplate];
             email.setToAddresses(new List<String>{emailAddress});
            email.setSubject(et.Subject);
            email.setSaveAsActivity(true);
            email.setWhatId(caseRecordId);
            String htmlBody = et.htmlvalue;
            System.debug('htmlBody++'+htmlBody);
            htmlBody = htmlBody.replace('{!Case.CaseNumber}', currentCase.CaseNumber).replace('{!Case.Account}', currentCase.Account.Name).replace('{!TODAY()}', ''+date.valueOf(system.today()));
            email.sethtmlbody(htmlBody);
            
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            if(caseRecordId!=null){
               Case caseObj = new Case(Id=caseRecordId);
               if(caseObj.Status != 'Closed'){
               caseObj.Status = 'Closed';
               }
               Update caseObj;
            }                          
        }catch(exception excp){
            system.debug(excp);
            system.debug(excp.getMessage());
            returnString = ''+excp.getMessage();
        }
        
        return returnString;
    }
  
    
}