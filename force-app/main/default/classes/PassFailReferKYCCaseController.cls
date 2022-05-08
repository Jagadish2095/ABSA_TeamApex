/**
 *
 * @author  Kamil Rega
 * @since   2021-05-10
 * @description : LightningFileUploadHandler
**/
public with sharing class PassFailReferKYCCaseController {
    /**
         * @comment : getCase
         * @description get case from DB
         * @param caseId
         * @return Case
         * */
        @AuraEnabled
        public static Case getCase(String caseId) {
            List<Case> listCases = new List<Case>();
            if (Case.SObjectType.getDescribe().isAccessible()) {
            listCases = [SELECT Id, Status, Referral_Reason__c,AccountId,Customer_Type__c,Client_Number__c,Account.PersonEmail,Account.IsPersonAccount,ContactId,Account.Active_Email__c, Fail_Additional_Information__c, Fail_Reason__c, Email_From_Address__c, Additional_Information__c, CaseNumber, Owner_Queue_Name__c, OwnerId,Case_Record_Type_Name__c FROM Case WHERE Id = :caseId];
            } else {
                return null;
            }
            if (!listCases.isEmpty()) {
                if (Case.SObjectType.getDescribe().isAccessible()) {
                    return listCases[0];
                } else {
                    return null;
                }
            } else {
                throw new ApplicationException('There is no Case for this Id');
            }
        }
        /**
         * @comment : getDocumentsOrder
         * @description get Documents Order
         * @param caseId
         * @return notAllDocsInOrder
         * */
        @AuraEnabled
        public static Boolean getDocumentsOrder(String caseId) {
            Boolean notAllDocsInOrder = false;
            List<Document__c> documents = new List<Document__c>();
            if (Document__c.SObjectType.getDescribe().isAccessible()) {
                documents = [SELECT Is_Fic_Document_Consent__c  FROM Document__c WHERE Case__c = :caseId];
            } else {
                return null;
            }
            for (Document__c doc : documents) {
                if (doc.Is_Fic_Document_Consent__c == false) {
                    notAllDocsInOrder = true;
                }
            }
            return notAllDocsInOrder;
        }
    /**
         * @comment : updateCaseToReferred
         * @description update Case
         * @param caseToAssign
         * @param status
         * @param isFailed
         * */
        @AuraEnabled
        public static void updateCaseToReferred(Case caseToAssign, String status, Boolean isFailed) {
            caseToAssign.Status = status;
            caseToAssign.FiC_Additional_Information__c = setAdditionalInfo(caseToAssign, isFailed);
            caseToAssign.SLA_Pause_Flag__c = true;
            caseToAssign.Type__c = caseToAssign.Case_Record_Type_Name__c=='AIC' ?'AIC Case':'FIC Case';
            map<string, id> queueNamesMap=new map<string, id>();
            
            Account account;
            if(caseToAssign.AccountId != null){
               account = new AccountsSelector().selectAllById(caseToAssign.AccountId);
            }

            if(caseToAssign.AccountId != null && isFailed == false && status != 'Referred'){
                if(caseToAssign.Customer_Type__c == 'Joints and Several'){
                   updateJointCIF(caseToAssign.AccountId, caseToAssign.Client_Number__c);
                 }else{
                   updateCIFRemediate(caseToAssign.AccountId);
                 }
             }

            if(Group.sObjectType.getDescribe().isAccessible()) {
                for(Group g:[select Id,DeveloperNAME from Group 
                             where Type = 'Queue' 
                         AND (DeveloperNAME = 'Awaiting_Documents' OR DeveloperNAME = 'Archive_AIC' OR DeveloperNAME ='Awaiting_Documents_AIC' OR DeveloperNAME = 'FIC_Archive' OR DeveloperNAME = 'New_Request' OR DeveloperNAME = 'FIC_Voice_Queue_Outbound'OR DeveloperNAME ='FIC_Remediation' OR DeveloperNAME = 'Sales_Enablement')]){
                    queueNamesMap.put(g.DeveloperNAME,g.id);
                }
            }
            if(isFailed==true && caseToAssign.ContactId != null && caseToAssign.Case_Record_Type_Name__c == 'AIC'){
                    PassFailReferKYCCaseController.sendFailEmailtoCustomer(caseToAssign);
            }
            if(caseToAssign.Case_Record_Type_Name__c=='AIC'){
                //caseToAssign.Status='Resolved';
                caseToAssign.OwnerId = isFailed==true ? queueNamesMap.get('Awaiting_Documents_AIC') : queueNamesMap.get('Archive_AIC'); 
            }
            else if(caseToAssign.Case_Record_Type_Name__c=='DSP Sales'){
                caseToAssign.OwnerId = queueNamesMap.get('Sales_Enablement');
                caseToAssign.Status = 'FIC Verified';
            }else if(caseToAssign.Case_Record_Type_Name__c == 'Home Loans'){
                caseToAssign.OwnerId = isFailed == true ? queueNamesMap.get('Awaiting_Documents') : queueNamesMap.get('FIC_Archive');
            }
            else if(caseToAssign.Case_Record_Type_Name__c == 'AOL'){
                if(status == 'Referred'){ 
                    string reason = caseToAssign.Referral_Reason__c; 
                    Switch on reason{
                        when 'Non-res'{
                           caseToAssign.OwnerId = queueNamesMap.get('Awaiting_Documents');
                        }
                        when 'Awaiting Documents'{
                           caseToAssign.OwnerId = queueNamesMap.get('Awaiting_Documents');
                           caseToAssign.Extended_SLA_End_Date__c=System.now();
                        }
                        when 'Remediation'{
                            caseToAssign.OwnerId = queueNamesMap.get('FIC_Remediation');
                            caseToAssign.Extended_SLA_End_Date__c=System.now();
                        }
                        when 'Branch' {
                            caseToAssign.OwnerId = queueNamesMap.get('FIC_Archive');
                            caseToAssign.Status = 'Closed';
                        }
                        
                        when 'Junk'{
                            caseToAssign.OwnerId = queueNamesMap.get('FIC_Archive');
                            caseToAssign.Status = 'Closed';
                        }
                        
                        when 'Absa admin client'{
                            caseToAssign.OwnerId = queueNamesMap.get('FIC_Archive');
                            caseToAssign.Status = 'Closed';
                        }
                        
                         when 'Manual remediation'{
                            caseToAssign.OwnerId = queueNamesMap.get('Awaiting_Documents');
                            caseToAssign.Status = 'Referred';
                        }
                        
                        when 'Private Bank'{
                            caseToAssign.OwnerId = queueNamesMap.get('Awaiting_Documents');
                            caseToAssign.Status = 'Referred';
                        }
                        
                        when 'Business Bank'{
                            caseToAssign.OwnerId = queueNamesMap.get('Awaiting_Documents');
                            caseToAssign.Status = 'Referred';
                        }
                    }
                }else{
                   if(account.Preferred_Communication_Method__pc != null && isFailed == true){
                        if(account.Preferred_Communication_Method__pc == 'Phone'){
                            caseToAssign.OwnerId = queueNamesMap.get('FIC_Voice_Queue_Outbound');
                        }else{
                            caseToAssign.OwnerId = queueNamesMap.get('Awaiting_Documents');
                        }
                    }else{
                        caseToAssign.OwnerId = queueNamesMap.get('FIC_Archive');
                    } 
                }
              } 
            
    
    //        if(status == 'Closed'){
    //            Group gQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'FIC_Archive'];
    //            caseToAssign.OwnerId = gQueue.Id;
    //        } else if (status == 'Return') {
    //            Group gQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'FIC_Remediation'];
    //            caseToAssign.OwnerId = gQueue.Id;
    //        } else if(status == 'Referred') {
    //            Group gQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'FIC_Referral'];
    //            caseToAssign.OwnerId = gQueue.Id;
    //        }
            string message;
            try {
                if (Case.SObjectType.getDescribe().isAccessible()) {
                      update caseToAssign;
                }
            } catch (Exception ex) {
                message = ex.getMessage();
            }
        }
    
     /**
     * @comment : updateCaseToReferred
     * @description update Case
     * @param caseToAssign
     *
     */
    @AuraEnabled
    public static void sendFailEmailtoCustomer(Case caseToAssign) {
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        list<EmailMessage> emailMsgList = new list<EmailMessage>();
        list<String> toAddress = new list<String>(); 
        //List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        if(caseToAssign.Account.IsPersonAccount == true && caseToAssign.Account.PersonEmail != null){
            toAddress.add(caseToAssign.Account.PersonEmail);
        }
        else if(caseToAssign.Account.Active_Email__c != null){
            toAddress.add(caseToAssign.Account.Active_Email__c);                                   
         }
        Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
        emailOut.setSenderDisplayName('ABSA Support');
        emailOut.setTargetObjectId(caseToAssign.ContactId); 
        emailOut.setToAddresses(toAddress);
        emailOut.setWhatId(caseToAssign.Id);				
        emailOut.setSaveAsActivity(false);    
        string emailTemplateName = caseToAssign.Account.IsPersonAccount==true?'AIC Standard Individual Template':'AIC Standard Complex Entity Template';
        List<EmailTemplate> emailTemps = new EmailTemplatesSelector().selectByName(emailTemplateName);
        if (!emailTemps.isEmpty()) {
            emailOut.setTemplateId(emailTemps[0].Id);
            emailsOutList.add(emailOut);					                                           
        }
        if(!emailsOutList.isEmpty() && !toAddress.isEmpty()){
            Messaging.sendEmail(emailsOutList);
            for(Messaging.SingleEmailMessage eachEmail : emailsOutList){
                //Create Email Message - to store on Case
                EmailMessage emailMsg = new EmailMessage();
                emailMsg.ToAddress=(eachEmail.getToAddresses()[0]);
                emailMsg.Subject=eachEmail.getSubject();
                emailMsg.HtmlBody=eachEmail.getHtmlBody();
                emailMsg.ParentId = eachEmail.getWhatId();
                emailMsg.MessageDate = system.now();
                emailMsg.Status = '0';
                emailMsg.Is_Auto_Response__c = true;
                emailMsgList.add(emailMsg);
            }
            try {
                if (!emailMsgList.isEmpty()) {
                    insert emailMsgList;
                }
            } catch (DMLException e) {
                AuditTrailLog.logException(e,
                    'New',
                    'Warning',
                    'Case_Trigger_Functions',
                    'emailResponse',
                    'There was an error while inserting the Case email message Task'
                );
            }
        }
    }
    /**
         * @comment : updateCaseToReferred
         * @description update Case
         * @param caseId
         * @return DocumentsConsent
         * */
        @AuraEnabled
        public static DocumentsConsent checkFailReason(String caseId) {
            List<Document__c> documents = new List<Document__c>();
            DocumentsConsent documentsConsent = new DocumentsConsent();
            if (Document__c.SObjectType.getDescribe().isAccessible()) {
                documents = [SELECT Fic_Document_no_consent_reason__c, Is_Fic_Document_Consent__c, Type__c FROM Document__c WHERE Case__c = :caseId];
            } else {
                return null;
            }
            for (Document__c doc : documents) {
                if (doc.Is_Fic_Document_Consent__c == false && String.isEmpty(doc.Fic_Document_no_consent_reason__c)) {
                    documentsConsent.allReasonAreFulfill = false;
                    documentsConsent.tab = doc.Type__c;
                }
            }
            return documentsConsent;
        }
        /**
            * @comment : setAdditionalInfo
            * @description setAdditionalInfo Case
            * @param caseToAssign
            * @param isFailed
            * @return String
            * */
        private static String setAdditionalInfo(Case caseToAssign, Boolean isFailed) {
            String additionalInfo = '';
            /* additionalInfo  = UserInfo.getName() + ' ' + Datetime.now()+  '\r\n' ;
             if(caseToAssign.Fail_Reason__c != null && isFailed == true){
                 additionalInfo = additionalInfo + 'Fail reason : ' + caseToAssign.Fail_Reason__c + ' ';
             }
             if(caseToAssign.Referral_Reason__c != null && isFailed == false){
                 additionalInfo = additionalInfo + 'Referral Reason: ' + caseToAssign.Referral_Reason__c + '\r\n';
             }
             if(caseToAssign.Fail_Additional_Information__c != null && isFailed == true){
                 additionalInfo = additionalInfo + 'Additional Information: ' + caseToAssign.Additional_Information__c +  '\r\n';
             }
             if(caseToAssign.Fail_Additional_Information__c == null && isFailed == true){
                 additionalInfo = additionalInfo + '\r\n';
             }
             if(caseToAssign.Additional_Information__c != null && isFailed == false){
                 additionalInfo = additionalInfo + 'Additional Information: ' + caseToAssign.Additional_Information__c + '\r\n';
             }
             if(caseToAssign.Additional_Information__c == null && isFailed ==false){
                 additionalInfo = additionalInfo + '\r\n';
             }
             if(caseToAssign.FIC_Case_FailedComments__c != null && isFailed == true) {
                 additionalInfo = additionalInfo + 'Additional Fail Information: '+caseToAssign.FIC_Case_FailedComments__c +  '\r\n';
             }*/
            return additionalInfo;
        }
        /**
     *
     * @author  Kamil Rega
     * @since   2021-05-10
     * @description : LightningFileUploadHandler
    **/
        public Class DocumentsConsent {
            /* * @comment : allReasonAreFulfill
            * @description allReasonAreFulfill Case
            **/
            @auraEnabled public Boolean allReasonAreFulfill;
           /* * @comment : tab
            * @description tab Case
            **/
            @auraEnabled public String tab;
             /**
            * @comment : setAdditionalInfo
            * @description setAdditionalInfo Case
            * */
            public DocumentsConsent() {
                allReasonAreFulfill = true;
            }
        }
        
        //Anka Ganta - W-006976 - Remediate Existing Customer Onboarding - Call getClientDetails and updateClientDetails to update Client details
        
        /**
        * @description 
        * @author muvhuso.nekhubvi@absa.africa | 2021-09-27 
        * @param accId 
        * @return cifwrappercls 
        **/
        @AuraEnabled
        public static cifwrappercls updateCIFRemediate(Id accId){
            
            Account accRec;
            String siteCode;
            cifwrappercls cifwrpr=new cifwrappercls();
            
            List<String> reasonList = new List<String>();
            
            accRec = new AccountsSelector().selectAllById(accId);
    
            
            Set<Id> userIds = new Set<Id>();
            userIds.add(UserInfo.getUserId());
            List<User> loggedInUserInfo = new UsersSelector().selectById(userIds); 
            siteCode = loggedInUserInfo[0].SiteCode__c;
            
            //Call CIGetClientDetailsCIF Service
            GetClientDetailsCIF_Resp_IB_v1 respBeanGetClient = new GetClientDetailsCIF_Resp_IB_v1();
            respBeanGetClient = GetClientDetailsCIF_IH_v1.getClientDetails(accRec.CIF__c,'0',siteCode, false);
            String respBeanGetClientString = JSON.serialize(respBeanGetClient);
            List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(accRec.Id);  
            
            //Call CIUpdateClientDetailsCIF Service
            ciupdateclientdetailV12_Resp_IB_v1 respBeanUpdateClient = new ciupdateclientdetailV12_Resp_IB_v1();
            map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c>  respBeanUpdateClientMap= new map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c>();
            
            List<Integration_Translation__c> translation = [SELECT Direction__c, External_Value__c, System_Name__c, Value_Type__c ,Internal_Value__c 
                                                            FROM Integration_Translation__c 
                                                            WHERE Direction__c = :'Outbound' 
                                                            AND (System_Name__c =:'CIF'
                                                                 OR System_Name__c =:'eCasa')];
            
            Map<String,String> translations = new Map<String,String>();
            for(Integration_Translation__c translatedVars: translation ){ 
                String mapKey = translatedVars.External_Value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
                String mapKey1 = translatedVars.Internal_value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
                translations.put(mapKey, translatedVars.Internal_value__c); 
                translations.put(mapKey1, translatedVars.External_Value__c); }
            User usr = [Select Id, EmployeeNumber from User where Id =:UserInfo.getUserId() LIMIT 1];
            
           // System.debug('process type----'+opportunities.get(0).Process_Type__c + ' ' + usr.EmployeeNumber);
            CvsValidationService_Req_IB_v1 cvsValidateBean = new CvsValidationService_Req_IB_v1();
            Map<String, String> translationMap = CreateClientCIF_IH_v1.getTranslations(accRec, addressList);
            //if (opportunities.get(0).Process_Type__c == 'Remediate Existing Customer') {
            // call cvs validation service
            map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> cvsResponseBeanMap;
            if(accRec.Client_Group__c == 'Non Individual') {
                cvsResponseBeanMap = OnboardingGenerateCIFController.cvsValidateClientInfo(accRec.Id);
            }else if(accRec.Client_Group__c == 'SOLE TRADER CLIENT'){
                //Call Validate Method (cvsValidate & ValidateAddress)
                cvsValidateBean = CvsValidationService_IU_v1.mapRBBIndividualRequestFields(accRec, addressList, 'S', translationMap);
                cvsResponseBeanMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false);  
            } else if(accRec.Client_Group__c == 'Individual'){
                //Call Validate Method (cvsValidate & ValidateAddress)
                cvsValidateBean = CvsValidationService_IU_v1.mapRBBMiniIndividualRequestFields(accRec, addressList, 'I', translationMap);
                cvsResponseBeanMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false); 
            }
            List<CvsValidationService_Resp_IB_v1> cvsResponseBeanList = new List<CvsValidationService_Resp_IB_v1>(cvsResponseBeanMap.keySet());  
            List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
            logList.add(cvsResponseBeanMap.values()[0]); 
            CvsValidationService_Resp_IB_v1 cvsResponseBean = new CvsValidationService_Resp_IB_v1();
            cvsResponseBean = cvsResponseBeanList[0];
            List<CvsValidationService_Resp_IB_v1.cls_Error> errorListbean = new List<CvsValidationService_Resp_IB_v1.cls_Error>();
            CvsValidationService_Resp_IB_v1.cls_Error errorobjbean = new CvsValidationService_Resp_IB_v1.cls_Error();
            CvsValidationService_Resp_IB_v1.cls_StatusMessage StatusMessagebean = new CvsValidationService_Resp_IB_v1.cls_StatusMessage();
    
            //Call ciupdateclientdetail service on cvs validation success
            if(cvsResponseBean.statusCode == 200 && cvsResponseBean.valStatusCode == '0'){
                if(cvsResponseBean.statusCode == 200 ){
                respBeanUpdateClientMap = ciupdateclientdetailV12_IH_v1.ciUpdateRemediateCustomer(accRec, addressList, translations ,accRec.Client_Type__c, siteCode,usr.EmployeeNumber,respBeanGetClient);
                
                List<ciupdateclientdetailV12_Resp_IB_v1> respBeanUpdateClientList = new List<ciupdateclientdetailV12_Resp_IB_v1>(respBeanUpdateClientMap.keySet()); 
                respBeanUpdateClient = respBeanUpdateClientList[0];
                ciupdateclientdetailV12_Resp_IB_v1.CIupdateClientDetailV12Response CIupdateClientDetailV12ResponseBean = new ciupdateclientdetailV12_Resp_IB_v1.CIupdateClientDetailV12Response();
                ciupdateclientdetailV12_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new ciupdateclientdetailV12_Resp_IB_v1.Nbsapdpo();
                ciupdateclientdetailV12_Resp_IB_v1.Nbsmsgo3 Nbsmsgo3Bean = new ciupdateclientdetailV12_Resp_IB_v1.Nbsmsgo3();
                ciupdateclientdetailV12_Resp_IB_v1.Cib004o Cib004oBean = new ciupdateclientdetailV12_Resp_IB_v1.Cib004o();
                ciupdateclientdetailV12_Resp_IB_v1.MsgEntry MsgEntryBean = new ciupdateclientdetailV12_Resp_IB_v1.MsgEntry();
                List<ciupdateclientdetailV12_Resp_IB_v1.MsgEntry> MsgEntryBeanList = new List<ciupdateclientdetailV12_Resp_IB_v1.MsgEntry>();
                CIupdateClientDetailV12ResponseBean =  respBeanUpdateClient.CIupdateClientDetailV12Response ;
                if(CIupdateClientDetailV12ResponseBean != null){
                    Cib004oBean = CIupdateClientDetailV12ResponseBean.Cib004o;
                        if(Cib004oBean.retCode != '0'){
                             Nbsmsgo3Bean = CIupdateClientDetailV12ResponseBean.Nbsmsgo3;
                             MsgEntryBeanList = Nbsmsgo3Bean.msgEntry;
                        for(ciupdateclientdetailV12_Resp_IB_v1.MsgEntry MsgEntryItem : MsgEntryBeanList){
                            reasonlist.add(MsgEntryItem.msgTxt);
                    }
                    
                }
               }
              
            }else if(cvsResponseBean.statusCode == 200 && cvsResponseBean.valStatusCode != '0'){
                StatusMessagebean = cvsResponseBean.statusMessage;
                errorListbean = StatusMessagebean.error;
                errorobjbean = StatusMessagebean.errorObj;
                if(errorListbean != null){   
                    for(CvsValidationService_Resp_IB_v1.cls_Error errorbean:errorListbean){
                        reasonList.add(errorbean.reason);
                    }
                }
                if(errorobjbean != null){
                    reasonlist.add(errorobjbean.reason);
                    if(errorobjbean.reasonList != null) {
                        for(String str:errorobjbean.reasonList){
                            reasonlist.add(str); 
                        }
                    }
                }
            }
            cifwrpr.errormsglist = new List<String>();
            cifwrpr.errormsglist= reasonlist;
            if(respBeanUpdateClientMap.values().size() > 0 && !respBeanUpdateClientMap.values().isEmpty()){
                logList.add(respBeanUpdateClientMap.values()[0]);
            }
            if(logList.size() >0 && !logList.isEmpty()){
                insert logList;
            }
    
          }
          return null;
       }
       /** 
        * @description 
       */
        public class cifwrappercls {
        /** 
        * @description 
        */
         @AuraEnabled public list<String> errormsglist{get;set;}
         /** 
        * @description 
       */
         @AuraEnabled  public String cifoutput{get;set;}
        /** 
        * @description 
        */
         @AuraEnabled  public String cifoutputerror{get;set;}
        /** 
        * @description 
        */
         @AuraEnabled  public String errorObjMsg {get;set;}
        /** 
        * @description 
        */
         @AuraEnabled  public ciupdateclientdetailV12_Resp_IB_v1 respBeanUpdateClient {get;set;}
        }

        /**
        * @description 
        * @author muvhuso.nekhubvi@absa.africa | 2021-11-29 
        * @param accId 
        * @param jointCIF 
        **/
        public static void updateJointCIF(String accId, String jointCIF){
        	Account accRec = new AccountsSelector().selectAllById(accId);
            
            
            List<Integration_Translation__c> translation = [SELECT Direction__c, External_Value__c, System_Name__c, Value_Type__c ,Internal_Value__c 
                                                            FROM Integration_Translation__c 
                                                            WHERE Direction__c = :'Outbound' 
                                                            AND (System_Name__c =:'CIF'
                                                                 OR System_Name__c =:'eCasa')];
            
            Map<String,String> translations = new Map<String,String>();
            for(Integration_Translation__c translatedVars: translation ){ 
                String mapKey = translatedVars.External_Value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
                String mapKey1 = translatedVars.Internal_value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
                translations.put(mapKey, translatedVars.Internal_value__c); 
                translations.put(mapKey1, translatedVars.External_Value__c); }
            GetJointParticipant_Resp_IB_v1 responseBeanJointsParticipants = new GetJointParticipant_Resp_IB_v1();
            responseBeanJointsParticipants = GetJointParticipant_IH_v1.getJointParticipant(jointCIF,false); 
            List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(accRec.Id);  

            // System.debug('process type----'+opportunities.get(0).Process_Type__c + ' ' + usr.EmployeeNumber);
            CvsValidationService_Req_IB_v1 cvsValidateBean = new CvsValidationService_Req_IB_v1();
            
            Map<String, String> translationMap = CreateClientCIF_IH_v1.getTranslations(accRec, addressList);
            //if (opportunities.get(0).Process_Type__c == 'Remediate Existing Customer') {
            // call cvs validation service
            map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> cvsResponseBeanMap;
            
            if(accRec.Client_Group__c == 'Individual'){
                //Call Validate Method (cvsValidate & ValidateAddress)
                cvsValidateBean = CvsValidationService_IU_v1.mapRBBMiniIndividualRequestFields(accRec, addressList, 'I', translationMap);
                cvsResponseBeanMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false); 
             }
            List<CvsValidationService_Resp_IB_v1> cvsResponseBeanList = new List<CvsValidationService_Resp_IB_v1>(cvsResponseBeanMap.keySet());  
            List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
            logList.add(cvsResponseBeanMap.values()[0]); 
            CvsValidationService_Resp_IB_v1 cvsResponseBean = new CvsValidationService_Resp_IB_v1();
            cvsResponseBean = cvsResponseBeanList[0];
            List<CvsValidationService_Resp_IB_v1.cls_Error> errorListbean = new List<CvsValidationService_Resp_IB_v1.cls_Error>();
            CvsValidationService_Resp_IB_v1.cls_Error errorobjbean = new CvsValidationService_Resp_IB_v1.cls_Error();
            CvsValidationService_Resp_IB_v1.cls_StatusMessage StatusMessagebean = new CvsValidationService_Resp_IB_v1.cls_StatusMessage();
            
            //Call ciupdateclientdetail service on cvs validation success
            if(cvsResponseBean.statusCode == 200 && cvsResponseBean.valStatusCode == '0'){
                if(cvsResponseBean.statusCode == 200 ){
                   CIupdJointPByClientCodeV7_IH_v1.updateJoints(accRec, jointCIF,translations,responseBeanJointsParticipants);
                }
            }
            
        }
    }