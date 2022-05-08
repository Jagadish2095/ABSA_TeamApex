public class TravelNoticeController {
    
     @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        system.debug('----clientAccountId----'+clientAccountId);
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        system.debug('----accountList----'+accountList);
        if(accountList != null){
          if(accountList.size() > 0){
            if(String.isNotBlank(accountList[0].CIF__c)){
                CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,accountList[0].CIF__c);
        
        		if(response.statusCode == 200){
            		CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
            
            		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
            		accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
            
            		for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                		accountWrapperList.add(accWrObj);
                
            		}
            		system.debug(LoggingLevel.FINE,'outputBean3: ' + accountWrapperList);
            		return JSON.serialize(accountWrapperList);
             
        		}
            }
        }
      }
        
        
        return null;
        
    }
    
   @AuraEnabled
    public static String getTravelEnquiry(String accessNumber,String language , String action , String cardNbr){
        
        Map<nHenquiryPauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nHenquiryPauseCardV1_IH_v1.getNHenquiryPauseCardV1(accessNumber, language, action, cardNbr);
                 
        nHenquiryPauseCardV1_Resp_IB_v1 responseBean = (new List<nHenquiryPauseCardV1_Resp_IB_v1>(responseMap.keySet()))[0];
        if(responseBean  != null){
        	if(responseBean.statusCode == 200){
                if(responseBean.NHenquiryPauseCardV1Response != null){
                    if(responseBean.NHenquiryPauseCardV1Response.nhs142o != null){
                        return JSON.serialize(responseBean.NHenquiryPauseCardV1Response.nhs142o);
                    }
                }
        	}
        }
        return null;
        }    
    @AuraEnabled 
    public static String updateTravelNotice(String accessNumber, String pauseHold,String iatmHold, String iposHold, String latmHold,String lposHold, String cnpHold, String digwHold, String pauseDate, String language , String action , String cardNbr){
        
        String tellerCode, site, teller,supervisor;                                                      
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId()); 
        site = currentUser.SiteCode__c;
        teller = currentUser.Teller_Operator_Code__c;                                                      
        supervisor = currentUser.Supervisor__c;
        
        Map<nHupdatePauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nHupdatePauseCardV1_IH_v1.nHupdatePauseardv1(accessNumber, teller, supervisor, site, pauseHold, iatmHold, iposHold, latmHold, lposHold, cnpHold, digwHold, formatDate(pauseDate), language, action, cardNbr);
                 
        nHupdatePauseCardV1_Resp_IB_v1 responseBean = (new List<nHupdatePauseCardV1_Resp_IB_v1>(responseMap.keySet()))[0];
        if(responseBean  != null){
            if(responseBean.statusCode == 200){
                if(responseBean.NHupdatePauseCardV1Response != null){
                    if(responseBean.NHupdatePauseCardV1Response.nhs141o != null){
                        return JSON.serialize(responseBean.NHupdatePauseCardV1Response.nhs141o);
                    }
                    
                }
            }
        }
        return null; 
    }
    
    public static String formatDate(string dateValue){
        if(String.isNotBlank(dateValue)){
        	string year =  dateValue.split('-')[0];
        	string month =  integer.valueof(dateValue.split('-')[1]) < 10 ? '0' + dateValue.split('-')[1] : dateValue.split('-')[1];
        	string sDate =  dateValue.split('-')[2];
            return year + month + sDate;
         }   
        return '';
    }
    
    @AuraEnabled
    public static String sendEmail(String emailAddress, Id caseRecordId){

        String returnString = 'success';
        
         try{   
                
                Case currentCase = [SELECT Id, CaseNumber, AccountId, Account.Name FROM Case WHERE Id =: caseRecordId];
                
                String contactId = [Select PersonContactId From Account Where Id = :currentCase.AccountId].PersonContactId;

                if( String.isNotBlank(contactId) ){

                    Contact con = [Select Email From Contact Where Id =:contactId];

                    if(String.isBlank(con.email)){
                        
                        con.email = emailAddress;

                        try{
                            update con;
                        }catch(DMLException ex){
                            throw ex;
                        }
                    }

                }else{
                    
                    List<Contact> contList = [Select Id, Email From Contact Where Email = :emailAddress and AccountId = :currentCase.AccountId];

                    if(contList.size() > 0){

                        if(String.isBlank( contList[0].Email )){
                            
                            contList[0].Email = emailAddress;

                            try{
                                update contList[0];
                            }catch(DmlException ex){
                                throw ex;
                            }
                        }

                        contactId = contList[0].Id;

                    }else{

                        String[] contNames = emailAddress.split('@');

                        Contact newCon = new Contact();
                        newCon.Email = emailAddress;
                        newCon.LastName = contNames[0];
                        newCon.AccountId = currentCase.AccountId;

                        try{

                            insert newCon;
                            contactId = newCon.Id;

                        }catch(DmlException ex){

                            throw ex;
                        }
                    }

                }

                List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress,'Travel_Notice');
                Messaging.SingleEmailMessage email = constructEmail.get(0);
                
                String htmlBody = email.getPlainTextBody();
                
                htmlBody = htmlBody.replace('{!Case.CaseNumber}', currentCase.CaseNumber).replace('{!Case.ClientName__c}', currentCase.Account.Name).replace('{!TODAY()}', ''+date.valueOf(system.today()));
                email.setPlainTextBody(htmlBody);

                sendTravelNoticeEmail(email, emailAddress,email.getHTMLBody());
                
            }catch(exception ex){
                system.debug(ex);
                system.debug(ex.getMessage());
                returnString = '' + ex.getMessage();
                throw ex;
            }

        

        try{
            
            if(caseRecordId!=null){
                Case caseObj = new Case(Id=caseRecordId);
                caseObj.Email__c = emailAddress;
                caseObj.Status = 'Closed';
                Update caseObj;
            }

        }catch(DmlException ex){
            throw ex;
        }
 
        return returnString;

    }
    
    private static void sendTravelNoticeEmail(Messaging.SingleEmailMessage constructEmail, String emailAddress, string emailBody){
        System.debug('RN## To Addresses : ' + constructEmail.getToAddresses());
        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { constructEmail });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
}