/**
* Descripton: Apex controller to execute after approval submitted.
* Class Name: RefundApprovalProcessController
* @author  Bhanumurty : Absa
* @since   2020-12-15
*
* Further Modified by Tinashe M Shoko
**/



public class RefundApprovalProcessController {
    
    @auraEnabled
    public static Id getSubmitter(Id caseId){
        User submitter = new UsersSelector().selectByIdRefunds(UserInfo.getUserId());
        //system.debug('Submitter: ' +submitter);
        Id submitterid = submitter.Id;
        //system.debug('Submitter ID: ' +submitterid);
        
        List<Case> caseaccowneridlists = [select Account.OwnerId from Case where id = :caseId];
       
        for(Case csowner : caseaccowneridlists){
            if(csowner.Account.OwnerId != submitterid){ 
                submitterid = csowner.Account.OwnerId;
            }else{
                submitterid = submitter.Id;
            }
        }
       	 return submitterid;
    }
    
    @auraEnabled
    public static void submitLevel4ApprovalProcess(Id caseId){
        List<Case> refundCaseList = new CasesSelector().selectByCaseId(caseId);
        //system.debug('Case list from case selector: ' +refundCaseList);
        List<String> siteCodes = new List<String>();
        List<String> siteZones = new List<String>();
        List<User> areaManagers = new List<User>();
        List<User> regionalManagers = new List<User>();
        List<User> executiveManagers = new List<User>();
        
        //system.debug(refundCaseList.size() + ' ' + refundCaseList.get(0).Refund_Approval_Stage__c + ' ' + refundCaseList.get(0).Amount__c);
        if (!refundCaseList.isEmpty() && refundCaseList.size() > 0 && refundCaseList != null 
            && refundCaseList.get(0).Refund_Approval_Stage__c == null && refundCaseList.get(0).Amount__c > 0) {
                // get current logged user (advisor) ddetails
                //User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
                User currentUser = new UsersSelector().selectByIdRefunds(getSubmitter(caseId));
                
                System.debug('current user details: ' +currentUser);
                
                List<Site__c> siteData = new SitesSelector().selectBySiteCodeRefund(currentUser.SiteCode__c);
                
                system.debug('Site Data details:::::' +siteData);
                
                if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null && siteData.get(0).Zone__c != '' && siteData.get(0).Region__c != '') {
                    List<Site__c> siteList = new SitesSelector().selectByZone(siteData.get(0).Zone__c);
                    //system.debug('Site List records after passing the site data::::' +siteList);
                    
                    for (Site__c s : siteList) {
                        siteCodes.add(s.Site_Code__c);
                        siteZones.add(s.Zone__c);
                    }                        
                    system.debug('siteCodes '+siteCodes);
                    areaManagers = [select id, name, SiteCode__c, UserRole.Name, RBB_Region__c, Zone__c, ProfileId
                                    from User
                                    where SiteCode__c IN :siteCodes AND UserRole.Name like '%Area%' 
                                    /*AND Zone__c IN :siteZones*/ AND ProfileId =: currentUser.ProfileId];
                    
                    regionalManagers = [select id, name, SiteCode__c, UserRole.Name, RBB_Region__c, Zone__c, ProfileId
                                        from User
                                        where SiteCode__c IN :siteCodes AND UserRole.Name like '%Regional Head%' 
                                        AND IsActive = true /*AND Zone__c IN :siteZones*/ AND ProfileId =: currentUser.ProfileId];
                    
                    executiveManagers = [select id, name, SiteCode__c, UserRole.Name, RBB_Region__c, Zone__c, ProfileId
                                         from User
                                         where SiteCode__c IN :siteCodes AND UserRole.Name like '%Managing Executive%' 
                                         AND IsActive = true /*AND Zone__c IN :siteZones*/ AND ProfileId =: currentUser.ProfileId];
                }
                system.debug('areaManagers '+areaManagers.get(0).Name +'regionalManagers '+regionalManagers.get(0).Name +'executiveManagers '+executiveManagers.get(0).Id);
                List<Refund_Transaction_Type__c> transList = new List<Refund_Transaction_Type__c>([select id, Approval_Group__c,Product_Id__c, Name from Refund_Transaction_Type__c
                                                                                                  where id =: refundCaseList.get(0).Refund_Transaction_Type_Id__c
                                                                                                   and Product_Id__c =: refundCaseList.get(0).Product_Search__c]);
                
                // if(areaManagers.size() == 0 || regionalManagers.size() == 0 || executiveManagers.size() == 0){
                String errorMsg = '';
                if(areaManagers.size() == 0){
                    errorMsg = errorMsg+ 'Area Manager, ';
                }
                if(regionalManagers.size() == 0 && refundCaseList.get(0).Amount__c < 10000 ){
                    errorMsg=  errorMsg+ 'Regional Manager ';
                }
                if(regionalManagers.size() == 0 && refundCaseList.get(0).Amount__c > 10000){
                    errorMsg= errorMsg+ 'Regional Manager, ';
                }
                if(executiveManagers.size() == 0  && refundCaseList.get(0).Amount__c > 10000 ){
                    errorMsg=  errorMsg+ ' Executive Manager ';
                }
                if(refundCaseList.get(0).Amount__c > 30000 && (refundCaseList.get(0).Refund_Transaction_Type_Id__c == NULL || transList.size() == 0 || transList.get(0).Approval_Group__c == NULL)){
                    throw new AuraHandledException('No Level 1 Group found');
                }
                if(!String.isBlank(errorMsg))
                    throw new AuraHandledException('No '+errorMsg+ 'found for the Site Code : '+currentUser.SiteCode__c);
                //}
                
                Id areaManagerApproverId = areaManagers.size() > 0 ? areaManagers.get(0).Id : NULL;
                Id regionalManagerApproverId = regionalManagers.size() > 0 ? regionalManagers.get(0).Id : NULL;
                Id executiveManagerApproverId = executiveManagers.size() > 0 ?executiveManagers.get(0).Id : NULL;
                
                case  caseRecord = new Case();
                caseRecord.Id = caseId;
                caseRecord.Mandate_Level_4_Approver__c = areaManagerApproverId;
                caseRecord.Mandate_Level_3_Approver__c = regionalManagerApproverId;
                caseRecord.Mandate_Level_2_Approver__c = executiveManagerApproverId;
                update caseRecord;
                
                // Create an approval request for the Case
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for Approval');
                req1.setObjectId(caseId);
                req1.setProcessDefinitionNameOrId('Level4_Approval_Process');
                req1.setSkipEntryCriteria(false);
                req1.setNextApproverIds(new Id[] {areaManagerApproverId});
                
                // Submit the approval request for the Case
                Approval.ProcessResult result = Approval.process(req1);
            }
    }
    
    @auraEnabled
    public static void submitLevel3ApprovalProcess(Id caseId){
        List<Case> refundCaseList = new CasesSelector().selectByCaseId(caseId);
        List<String> siteCodes = new List<String>();
        List<String> siteZones = new List<String>();
        List<User> areaManagers = new List<User>();
        //system.debug(refundCaseList.size() + ' ' + refundCaseList.get(0).Refund_Approval_Stage__c + ' ' + refundCaseList.get(0).Amount__c);
        if (!refundCaseList.isEmpty() && refundCaseList.size() > 0 && refundCaseList != null 
            && refundCaseList.get(0).Refund_Approval_Stage__c == 'Level 3' && refundCaseList.get(0).Amount__c > 10000) {
                // get current logged user (advisor) ddetails
                //User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
               /* User currentUser = new UsersSelector().selectByIdRefunds(getSubmitter(caseId));
                
                System.debug('current user details: ' +currentUser);
                List<Site__c> siteData = new SitesSelector().selectBySiteCodeRefund(currentUser.SiteCode__c);
                if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null && siteData.get(0).Zone__c != '') {
                    List<Site__c> siteList = new SitesSelector().selectByZone(siteData.get(0).Zone__c);
                    for (Site__c s : siteList) {
                        siteCodes.add(s.Site_Code__c);
                        siteZones.add(s.Zone__c);
                    }
                    areaManagers = [select id, name, SiteCode__c, UserRole.Name, RBB_Region__c, Zone__c, ProfileId
                                    from User
                                    where SiteCode__c IN :siteCodes AND UserRole.Name like '%Regional Manager%' 
                                    AND IsActive = true AND Zone__c IN :siteZones AND ProfileId =: currentUser.ProfileId];
                }
                id approverId = areaManagers.get(0).Id;*/
                // Create an approval request for the Case
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for Approval');
                req1.setObjectId(caseId);
                req1.setProcessDefinitionNameOrId('Level3_Approval_Process');
                req1.setNextApproverIds(new Id[] {refundCaseList.get(0).Mandate_Level_3_Approver__c});
                
                // Submit the approval request for the Case
                Approval.ProcessResult result = Approval.process(req1);
            }
    }
    
    @auraEnabled
    public static void submitLevel2ApprovalProcess(Id caseId){
        List<Case> refundCaseList = new CasesSelector().selectByCaseId(caseId);
        List<String> siteCodes = new List<String>();
        List<String> siteZones = new List<String>();
        List<User> areaManagers = new List<User>();
        //system.debug(refundCaseList.size() + ' ' + refundCaseList.get(0).Refund_Approval_Stage__c + ' ' + refundCaseList.get(0).Amount__c);
        if (!refundCaseList.isEmpty() && refundCaseList.size() > 0 && refundCaseList != null 
            && refundCaseList.get(0).Refund_Approval_Stage__c == 'Level 2' && refundCaseList.get(0).Amount__c > 30000) {
                // get current logged user (advisor) ddetails000
                //User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
                 /*User currentUser = new UsersSelector().selectByIdRefunds(getSubmitter(caseId));
                
                System.debug('current user details: ' +currentUser);
                List<Site__c> siteData = new SitesSelector().selectBySiteCodeRefund(currentUser.SiteCode__c);
                if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null && siteData.get(0).Zone__c != '') {
                    List<Site__c> siteList = new SitesSelector().selectByZone(siteData.get(0).Zone__c);
                    for (Site__c s : siteList) {
                        siteCodes.add(s.Site_Code__c);
                        siteZones.add(s.Zone__c);
                    }
                    areaManagers = [select id, name, SiteCode__c, UserRole.Name, RBB_Region__c, Zone__c, ProfileId
                                    from User
                                    where SiteCode__c IN :siteCodes AND UserRole.Name like '%Managing Executive%' 
                                    AND IsActive = true AND Zone__c IN :siteZones AND ProfileId =: currentUser.ProfileId];
                    System.debug('we selected');
                }
                id approverId = areaManagers.get(0).Id;*/
                // Create an approval request for the Case
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for Approval');
                req1.setObjectId(caseId);
                req1.setProcessDefinitionNameOrId('Level2_Approval_Process');
                req1.setNextApproverIds(new Id[] {refundCaseList.get(0).Mandate_Level_2_Approver__c});
                
                // Submit the approval request for the Case
                Approval.ProcessResult result = Approval.process(req1);
            }
    }
    
    @auraEnabled
    public static void submitLevel1ApprovalProcess(Id caseId){
        List<Case> refundCaseList = new CasesSelector().selectByCaseId(caseId);
        List<String> refundProductList = new List<String>();
        List<String> refundTransList = new List<String>();
        
        if (!refundCaseList.isEmpty() && refundCaseList.size() > 0 && refundCaseList != null 
            && refundCaseList.get(0).Refund_Approval_Stage__c == 'Level 1' && refundCaseList.get(0).Amount__c > 100000) {
                for(Case cs : refundCaseList){
                    refundProductList.add(cs.Product_Search__c);
                    refundTransList.add(cs.Refund_Transaction_Type_Id__c);
                }
                
                String queueName;
                
                List<Refund_Transaction_Type__c> transList = new List<Refund_Transaction_Type__c>([select id, Approval_Group__c, 
                                                                                                   Product_Id__c, Name
                                                                                                  from Refund_Transaction_Type__c
                                                                                                  where id IN :refundTransList 
                                                                                                   and Product_Id__c in :refundProductList]);
                //system.debug('Refund Transanction List>>>>>>>>>' +transList);
                if(!transList.isEmpty() && transList.size()>0 && transList != NULL){
                    for(Refund_Transaction_Type__c rt : transList){
                    queueName = rt.Approval_Group__c;
                    //system.debug('Queue Name >>>>>>>>>' +queueName);
                	}
                }
                else{
                    throw new AuraHandledException('Queue name is empty');
                }
                
                
                Id agQueueId;
                
                Group queueAG = new Group();
                queueAG = [select id, Name, Type from Group where Type like 'Queue' and Name like :queueName];
                //system.debug('Group details>>>>>' +queueAG);
                agQueueId = queueAG.Id;
                //system.debug('Queue ID only>>>>>>' +agQueueId);
                
               /* List<Group> queueAGList = new GroupsSelector().selectByNameAndType('Queue', 'queueName');
                system.debug('Queue List>>>>>>>>>>>>>' +queueAGList);
                if(!queueAGList.isEmpty() && queueAGList.size()>0 && queueAGList != null){
                    for(Group ag : queueAGList){
                    	agQueueId = ag.id;
                        system.debug('AG Queue ID>>>>>>' +agQueueId);                     
                	}
                }else{
                    throw new AuraHandledException('AG list is empty');
                }
                */                
                // Create an approval request for the Case
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for Approval');
                req1.setObjectId(caseId);
                req1.setProcessDefinitionNameOrId('Level1_Group_Approval');
                req1.setNextApproverIds(new Id[] {agQueueId});
                
                // Submit the approval request for the Case
                Approval.ProcessResult result = Approval.process(req1);
            }
    }
    
    @AuraEnabled
    public static Case getRefundApprovalStage(id caseId) {
        List<Case> refundCaseList = new CasesSelector().selectByCaseId(caseId);
        return refundCaseList.get(0);
    }
    
    public static void sendEscalationEmailsToLevel1(id caseId){
        List<Case> refundCaseList = new CasesSelector().selectByCaseId(caseId);
        List<String> emails = new List<String>();
        List<Refund_Transaction_Type__c> transList = new List<Refund_Transaction_Type__c>([select id, Approval_Group__c,Product_Id__c, Name from Refund_Transaction_Type__c
                                                                                           where id =: refundCaseList.get(0).Refund_Transaction_Type_Id__c
                                                                                           and Product_Id__c =: refundCaseList.get(0).Product_Search__c]);
        
        system.debug('transList '+transList.get(0).Id +''+transList.get(0).Approval_Group__c);
        if(refundCaseList.size() > 0 && transList.size() > 0 && transList.get(0).Approval_Group__c != NULL){
            for(User grpMember : [Select Id, Email from User where Id IN (Select UserOrGroupId From GroupMember where Group.Name =: transList.get(0).Approval_Group__c)]){
                emails.add(grpMember.Email);
            }
        }
        system.debug('emails '+emails);
        if(emails.size() > 0){
            EmailTemplate template = [Select id,name from EmailTemplate where developername ='Journal_Processing_Escalation_Email_Template'];
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
				mail.setToAddresses(emails);
                mail.setTargetObjectId([Select id from contact limit 1].Id); 
                mail.setTemplateId(template.Id); 
                mail.setWhatId(caseId);  
                mail.setSaveAsActivity(false); 
				//mail.setSenderDisplayName('Absa');
				mail.setTreatTargetObjectAsRecipient(false);
                emailsToSend.add(mail);
            Messaging.sendEmail(emailsToSend);
        }
        system.debug('emails '+emails);
    }
}