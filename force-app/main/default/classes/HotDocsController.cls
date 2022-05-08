/**
* @description A controller class to mediate interaction with HotDocs services.
*/
public class HotDocsController {
    
    private String answerSetId;
    private String workItemId;
    private static final String WILL_COMPLETED_DRAFT_ENGLISH = 'Will_Completed_Draft_English';
    private static final String WILL_COMPLETED_DRAFT_AFRIKAANS = 'Will_Completed_Draft_Afrikaans';
    private static final String WILL_COMPLETED_DRAFT_ENGLISH_CLIENT_SMS = 'Will Completed Draft English Client SMS';
    private static final String WILL_COMPLETED_DRAFT_AFRIKAANS_CLIENT_SMS = 'Will Completed Draft Afrikaans Client SMS';
    private static final String WILL_COMPLETED_DRAFT_ENGLISH_CLIENT_EMAIL = 'Will_Completed_Draft_English_Client';
    private static final String WILL_COMPLETED_DRAFT_AFRIKAANS_CLIENT_EMAIL = 'Will_Completed_Draft_Afrikaans_Client';
    
    
    @AuraEnabled
    public static List<String> getAdviserEmail(Id oppId){
        Opportunity opp = [SELECT Id, Name, AccountId, Adviser__c, Site__c, Adviser_Employee__c, OwnerId FROM Opportunity WHERE Id = :oppId]; 
        Employee__c advisor = new EmployeesSelector().selectById(opp.Adviser_Employee__c);
        List<String> emails = new List<String>();
        if(advisor.Email__c != null){
            emails.add(advisor.Email__c);
        }
        
        return emails;
    }
    
    /**
	 * @description Logs into the hotdocs system and creates an interview session required to show an interview to the user.
	 */
    @AuraEnabled
    public static HotDocsInitResponse init(String client, String answerSet, Map<String, Object> context) {
        HotDocsInitResponse response = new HotDocsInitResponse();
        HotDocsConfig config = HotDocs_IH_V1.getHotDocsConfigs(client); //this needs to be handled by a proper config manager
        HotDocsToken token = HotDocs_IH_V1.authenticate(config.clientId, config.clientSecret);
        response.token = token.accessToken;
        HotDocsAnswerSet answer = createAnswerSet(token.accessToken, config.answerSetGenerator, context);
        response.answerSetId = answer.id;
        response.templateId = config.templateId;
        String session = getInterviewSession(token.accessToken, config.templateId, answer.id);
        String url = HotDocs_IH_V1.getInterviewUrl(session);
        response.url = url;
        return response;
    }
    
    /**
	 * Creates the interview URL given the template and initial answers. The URL will be embedded
	 * by the client as an iframe.
	 *
	 * @param token The authentication token for this session
	 * @param templateId The template to be used
	 * @param answerSetId The answerset to provide default answers.
	 * @return The interview URL
	 */
    @AuraEnabled
    public static String getInterviewSession(String token, String templateId, String answerSetId) {
        return HotDocs_IH_V1.getInterviewSession(token, templateId, answerSetId);
    }
    
    /**
	 * @description Creates a new answerset given a generator.
	 * @param token The auth token.
	 * @param generator The implementation of a generator to be used.
	 * @return An answerset with default values.
	 */
    @AuraEnabled
    public static HotDocsAnswerSet createAnswerSet(String token, String generatorName, Map<String, Object> context) {
        List<Asset> wills = new AssetsSelector().selectAssetsByOpportunityId((Id) context.get('id'), 'Will');
        try {
            Asset will = wills.get(0);
            GetXmlWillDraft_Resp_IB_v1 xml = null;
            try {
            	xml = GetXmlWillDraft_IH_v1.GetXmlWillDraft(will.SerialNumber);
            } catch (Exception ex) {
            	System.debug('Error retrieving XML answerset from wills system ');
            }
            String overlayAnswerSet = xml != null ? xml.AnswerSheetXml : null;
            if (!String.isBlank(overlayAnswerSet)) {
                overlayAnswerSet = overlayAnswerSet.replace('"', '\'');
            }			
            HotDocsAnswerSetGenerator generator = HotDocsAnswerSetGeneratorFactory.getInstance(generatorName, context, overlayAnswerSet);
            overlayAnswerSet = generator.generate();
            //insertFile(overlayAnswerSet);
            HotDocsAnswerSet answerSet = HotDocs_IH_V1.addAnswerSet(token, overlayAnswerSet);
            return answerSet;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getAnswerSet(String token, String answerSetId) {
        return HotDocs_IH_v1.getAnswerSet(token, answerSetId);
    }
    
    @AuraEnabled
    public static HotDocsWorkItem saveDocuments(String token, String workItemId, String answerSetId, Id objectId) {
        List<Attachment> attachments = new List<Attachment>();
        String answerSet = getAnswerSet(token, answerSetId);
        attachments.add(createAttachment(objectId, Blob.valueOf(answerSet), 'Created-AnswerFile.xml'));
        saveAnswerSet(answerSet, objectId);
        HotDocsWorkItem workItem = HotDocs_IH_v1.getWorkItem(token, workItemId); 
        for (HotDocsWorkItem.AssembledDocument doc : workItem.primaryTemplate.assembledDocuments) {
            attachments.add(saveDocument(doc, token, workItemId, objectId));
        }
        //update tracker status
        try {
    		List<Asset> wills = new AssetsSelector().selectAssetsByOpportunityId(objectId, 'Will');
    		Asset will = wills.get(0);
        	createTrackerStatus(will.SerialNumber, 'D', 'ARK', 'ARKcdxiqbsmyglenftph', 'Will Drafted');
        	updateWillDetails(will.SerialNumber, 'K');
        } catch (Exception ex) {
        	System.debug('Error updating tracker status : ' + ex.getMessage());
        }
        insert attachments;
        return workItem;
    }
    
    private static Attachment saveDocument(HotDocsWorkItem.AssembledDocument doc, String token, String workItemId, ID assetId) {
        Blob content = HotDocs_IH_v1.getDocument(token, workItemId, doc.documentId);   
        return createAttachment(assetId, content, 'Assembled-document-' + doc.documentId + '.docx');
    }
    
    private static Attachment createAttachment(Id parentId, Blob content, String name) {
        Attachment attachment = new Attachment();
        attachment.Body = content; 
        attachment.Name = name;
        attachment.ParentId = parentId;
        return attachment;
    }
    
    @AuraEnabled
    public static void dispatchWill(Id recordId,Application__c application, String cc) { // CC Added New
        System.debug('CC' + cc);
    	checkDocumentExists(recordId);
    	Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(recordId).get(0);
    	List<Asset> wills = new AssetsSelector().selectAssetsByOpportunityId(recordId, 'Will');
    	Asset will = wills.get(0);
        createTrackerStatus(will.SerialNumber, 'D', 'D', 'ARKCDxiqbsmyglenftph', 'Will Dispatched');
        updateWillDetails(will.SerialNumber, 'D');
        //send email to drafter
        if (!Test.isRunningTest()) {
        	sendEmail(recordId, cc);
        }
        opp.StageName = 'Dispatching';
        update opp;      
    }
    
    /**
	 * Retrieves Exempted Reasons form the Application Object 
	 * @return  List<String>    A list Exempted Reasons
	 */
    @AuraEnabled
    public static List<String> getCheckExemptedReasons() {
        
        List<String> exemptedReasonsList = new List<String>();
        Schema.DescribeFieldResult checkExemptedReasons = Application__c.Legality_Check_Required_Reason__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = checkExemptedReasons.getPicklistValues();
        for (Schema.PicklistEntry picklistEntry : picklistEntries) {
            exemptedReasonsList.add(picklistEntry.getValue());
        }
        return exemptedReasonsList;
        
    }
    
    @AuraEnabled
    public static Application__c getApplication(Id opportunityId) {
    	Application__c application = null;
    	List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);         
        if (!applicationsList.isEmpty()) {
            application = applicationsList.get(0); 
        }
        return application;
    }
    
    private static void saveAnswerSet(String answerSet, String objectId) {
        List<Asset> wills = new AssetsSelector().selectAssetsByOpportunityId(objectId, 'Will');
        try {
            Asset will = wills.get(0);
            List<SaveXmlWillDraft_Req_IB_v1> attributes = new List<SaveXmlWillDraft_Req_IB_v1>();
            attributes.add (new SaveXmlWillDraft_Req_IB_v1('willNo', will.SerialNumber));
            attributes.add (new SaveXmlWillDraft_Req_IB_v1('createdDate', 
                                                           DateTime.now().format('yyyy-MM-dd HH:mm:ss')));
            attributes.add (new SaveXmlWillDraft_Req_IB_v1('modifiedDate', 
                                                           DateTime.now().format('yyyy-MM-dd HH:mm:ss')));
            attributes.add (new SaveXmlWillDraft_Req_IB_v1('xmlData', answerSet));
            SaveXmlWillDraft_IH_v1.saveXmlWillDraft(attributes);
        } catch (Exception ex) {
            throw new AuraHandledException('Error saving answerset to Wills system');
        }
    }
    
    @future(callout = true)
    public static void sendEmail(Id oppId, String AltEmailId) {  //  AltEmailId added new 
        //Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(oppId); 
        Opportunity opp = [SELECT Id, Name, AccountId, Adviser__c, Site__c, Adviser_Employee__c, OwnerId FROM Opportunity WHERE Id = :oppId];        
        Set<Id> ids = new Set<Id>();
        ids.add(opp.AccountId);
        List<Account> accs = new AccountsSelector().selectById(ids, 1);
        Account acc = accs.get(0);
        Asset will = null;
        List<Asset> assets = new AssetsSelector().selectAssetByAccId(acc.Id);
        if (assets != null && !assets.isEmpty()) {
        	will = assets.get(0);
        }
        Application__c application = null;
    	List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(oppId);         
        if (!applicationsList.isEmpty()) {
            application = applicationsList.get(0); 
        }
        Employee__c advisor = new EmployeesSelector().selectById(opp.Adviser_Employee__c);
        //set the details
        Map<String, String> credentials = ECM_IH_V1.getCredentials();
    	ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
    	//Set email file attachments
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Document__c doc : [select Id, Name, Reference__c, CreatedDate from Document__c where Asset__c = :will.Id AND Name LIKE '%.pdf' ORDER BY CreatedDate DESC LIMIT 1]) {
            // Add to attachment file list
    		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, doc.Reference__c);    		
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(doc.Name);
            efa.setBody(EncodingUtil.base64Decode(getResult.Content.Data));
            fileAttachments.add(efa);
        }
        
        String clientLanguage;
        //client communication, can be SMS or Email, in English or Afrikaans
        if(acc.Client_Type__c == 'Joint & Several'){
            List<Contact> contactList = new AccountContactRelationSelector().selectContactListByAccId(acc.Id);
            Integer contactListNum = -1;
            for(Contact accContact : contactList){
                contactListNum = contactListNum+1;
 				 clientLanguage = contactList.get(contactListNum).Communication_Language__c;                               
            }
        }
        system.debug(' clientLanguage' + clientLanguage);
        
        //send to client
        String templateName = getClientTemplateName(clientLanguage, application);
        system.debug('Client templateName' + templateName);
        
        EmailTemplate template = null;
        if (!String.isEmpty(application.Preferred_Email__c)) { //email
        	template = [SELECT Id, Name, Body, DeveloperName, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName =: templateName LIMIT 1];
            system.debug('Client template' + template);
        	sendCommunication(new String[]{application.Preferred_Email__c}, template, null, will.Id , null);   //added new     
        } else if (!String.isEmpty(application.Preferred_SMS__c)) { //SMS        	
        	SMSHandler.sendSMS(null, null, application.Preferred_SMS__c, application.Preferred_SMS__c, templateName, StringConstants.ITOUCH_SUBMIT, false);
        }
        //send to advisor
        templateName = clientLanguage == 'Afrikaans'? WILL_COMPLETED_DRAFT_AFRIKAANS : WILL_COMPLETED_DRAFT_ENGLISH;
        system.debug(' template templateName' + templateName);
        template = [SELECT Id, Name, Body, DeveloperName, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName =: templateName LIMIT 1];
        system.debug('Advisr template' + template);
        for (Attachment attach : [SELECT Id, Body, Name FROM Attachment WHERE parentId = :template.Id]) {
        	Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(attach.Name);
            efa.setBody(attach.Body);
            fileAttachments.add(efa);
        }
        sendCommunication(new String[] {advisor.Email__c}, template, fileAttachments, will.Id , AltEmailId ); //Added new 
    }
    
    @TestVisible
    private static String getClientTemplateName(String language, Application__c application) {
    	if (!String.isEmpty(application.Preferred_Email__c)) {
    		return language == 'Afrikaans'? WILL_COMPLETED_DRAFT_AFRIKAANS_CLIENT_EMAIL:WILL_COMPLETED_DRAFT_ENGLISH_CLIENT_EMAIL;
    	} else if (!String.isEmpty(application.Preferred_SMS__c)) {
    		return language == 'Afrikaans'? WILL_COMPLETED_DRAFT_AFRIKAANS_CLIENT_SMS:WILL_COMPLETED_DRAFT_ENGLISH_CLIENT_SMS;
    	} else {
    		return null;
    	}
    }
    
    @TestVisible
    private static void sendCommunication(String[] toAddresses, EmailTemplate template, List<Messaging.Emailfileattachment> fileAttachments, Id objectId , String ccEmail) {
        system.debug('Inside sendCommunication');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        if(ccEmail!=null){ // Only for Adviser
            String cc1 = 'willsdirect@absa.africa,'+ccEmail;
			String[] cc = cc1.split('\\,');
            system.debug('cc' + cc);
            mail.setCcAddresses(cc);
        }
       // mail.setReplyTo('noreply@absa.co.za');
       // mail.setSenderDisplayName('Wills System');
        mail.setSubject(template.Subject);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        //template substitution
        List<Messaging.RenderEmailTemplateBodyResult> resolved = Messaging.renderEmailTemplate(null, objectId, new String[] {template.HtmlValue});
        //mail.setPlainTextBody(resolved.get(0).getMergedBody()); 
        mail.setHtmlBody(resolved.get(0).getMergedBody());
        mail.setTemplateId(template.Id);
        mail.saveAsActivity = false;
        if (fileAttachments != null) {
            mail.setFileAttachments(fileAttachments);
        }
        
        //Set from address
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'Wills'];
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
		
        //Send email
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    	
    }
    
    
    private static boolean checkDocumentExists(Id oppId) {
        try {
            List<Asset> wills = new AssetsSelector().selectAssetsByOpportunityId(oppId, 'Will');
    		Asset will = wills.get(0);
            List<Document__c> docs = [SELECT Id, Name FROM Document__c WHERE Name Like '%.pdf' AND Asset__c = :will.Id];
            if (docs == null || docs.isEmpty()) {
                throw new AuraHandledException('No documents found for this will.');
            }
            return true;
        } catch (Exception ex) {
            throw new AuraHandledException('No documents found for this will.');
        }
    }
    
    private static void createTrackerStatus(String willNo, String tstatus, String sstatus, String statCd, String action) {
		try {
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        CreateTracker_Resp_IB_v1 tracker =  CreateTracker_IH_v1.createTracker(
        									'WILLS', 
        									'WILLS', 
        									'Y', 
    										willNo, 
    										tstatus, 
    										DateTime.now().format('yyyyMMdd'), 
    										DateTime.now().format('HHmm'), 
    										currentUser.AB_Number__c, 
    										sstatus, 
    										statCd, 
    										'', 
    										'', 
    										action, 
    										'', 
    										'3232');
        } catch (Exception ex) {
        	System.debug('Error creating status in Wills system : ' + ex.getMessage());
        }
    }
    
    private static void updateWillDetails(String willNo, String status) {
    	try {
	    	GetWillDetails_Resp_IB_v1 source = GetWillDetails_IH_v1.getWillDetails(willNo);
	    	UpdateWillsDetails_Req_IB_v1 request = UpdateWillsDetails_Req_IB_v1.fromDetails(source);
	    	request.trackerStatus = status;
	    	request.channel='WILLS';
			request.application='WILLS';
			request.trace='Y';
			request.functioni='DRAFT';
			request.timeWithdrawn = '0';
			request.tellerNo = '0';
	    	UpdateWillsDetails_Resp_IB_v1 response = UpdateWillsDetails_IH_v1.updateWillsDetails(request);
    	} catch (Exception ex) {
    		System.debug('Error updating wills system: ' + ex.getMessage());
    	}
    }
    
        
    @AuraEnabled
    public static String getApplicationDetails(Id opportunityId) {
        String application = null;
    	List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);         
        if (!applicationsList.isEmpty()) {
            Application__c app = applicationsList.get(0); 
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeBooleanField('Legality_Checking_Completed__c', app.Legality_Checking_Completed__c == null ? false : app.Legality_Checking_Completed__c);
            gen.writeStringField('Legality_Checking_Required__c', app.Legality_Checking_Required__c == null ? '' : app.Legality_Checking_Required__c);
            gen.writeStringField('Legality_Check_Required_Reason__c', app.Legality_Check_Required_Reason__c == null ? '' : app.Legality_Check_Required_Reason__c);
            application = gen.getAsString();
        }
        return application;
    }
    
    @AuraEnabled
    public static void updateApplicationDetails(Id opportunityId, Application__c application) {
    	Opportunity opp = [SELECT Id, Name, AccountId, Adviser__c, Site__c, Adviser_Employee__c, OwnerId FROM Opportunity WHERE Id = :opportunityId];        
        Set<Id> ids = new Set<Id>();
        ids.add(opp.AccountId);
        List<Account> accs = new AccountsSelector().selectById(ids, 1);
        Account acc = accs.get(0);
        Asset will = null;
        List<Asset> assets = new AssetsSelector().selectAssetByAccId(acc.Id);
        if (assets != null && !assets.isEmpty()) {
        	will = assets.get(0);
        }
        List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);         
        if (!applicationsList.isEmpty()) {
            Application__c app = applicationsList.get(0);
            app.Legality_Checking_Required__c = application.Legality_Checking_Required__c;
            app.Legality_Check_Required_Reason__c = application.Legality_Check_Required_Reason__c;
            app.Legality_Checking_Completed__c = application.Legality_Checking_Completed__c;
            if (app.Legality_Checking_Completed__c) {
                //update tracker
                createTrackerStatus(will.SerialNumber, 'D', 'C', 'ARKCdxiqbsmyglenftph', 'Will Checked');
                updateWillDetails(will.SerialNumber, 'C');
            }
            update app;
        }
    }
    
}