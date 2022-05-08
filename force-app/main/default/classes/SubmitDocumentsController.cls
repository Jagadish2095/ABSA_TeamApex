/**
* Controller for Submitting Documents Lightning component
* @author  Kyle Alexander
* @created 2018-10-11
*/
public class SubmitDocumentsController {
    
    /**
     * Method that checks if a Policy Number exists on an opportunity 
     *
     * @param oppId - opportunity Id
     * @return Boolean - if the Policy number exists or not
     */
    @AuraEnabled
    public static Boolean getPolicyNumber(Id oppId) {     
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        if(opportunities.get(0).WBIF_Policy_Number__c != null){
            return true;
        }
        else{
            return false; 
        }
    }
    
    /**
     * Method that checks what the email status is (whether or not emails have been sent)
     *
     * @param oppId - opportunity Id
     * @return Boolean - email status
     */
    @AuraEnabled
    public static Boolean checkEmailStatus(Id oppId) {     
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        if(opportunities.get(0).Email_Status__c == 'Valid'){
            return true;
        }
        else{
            return false;
        }
    }
    
	/**
     * Method that sends email to client
     *
     * @param oppId - opportunity Id
     * @param emailAddress - email address being sent to
     * @param isAlternative - if the email address being sent to in an alternative one or not
     * @return Boolean - successful send or not
     */
    @AuraEnabled
    public static Boolean sendEmail(Id oppId, List<Account> accs, List<Opportunity> opps, String emailAddress, Boolean isAlternative) {     
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        List<Account> accounts;
        List<User> advisor = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);

        if(!isAlternative){

            opportunities.get(0).Selected_Email__c = emailAddress;
            accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        }
        else{
            accounts = accs;
            opportunities = opps;
        }
        
        try{
            //Send email and attach quote
            generateAndSendROA(oppId, accounts.get(0), opportunities.get(0).Selected_Email__c, advisor.get(0), false);
			opportunities.get(0).Email_Status__c = 'Valid';
            update opportunities;
            update accounts;
            
            return true;
        }
        catch(Exception e){
            System.debug(e.getCause() + ', ' + e.getLineNumber() + ', ' + e.getMessage());
            update opportunities;  
            update accounts;
            
            return false;
        }        
    }
    
    /**
     * Method that sends to client's alternative email
     *
     * @param oppId - opportunity Id
     * @param altEmailAddress - altermative email address being sent to
     * @return Boolean - successful send or not
     */
    @AuraEnabled
    public static Boolean sendAlternativeEmail(Id oppId, String altEmailAddress) {     
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);

        if(accounts.get(0).Alternative_Email__c == null){
            accounts.get(0).Alternative_Email__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_1__c == null){
            accounts.get(0).Alternative_Email_1__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_2__c == null){
            accounts.get(0).Alternative_Email_2__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_3__c == null){
            accounts.get(0).Alternative_Email_3__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_4__c == null){
            accounts.get(0).Alternative_Email_4__c = altEmailAddress;
        }
        
        opportunities.get(0).Selected_Email__c = altEmailAddress;
        
        //update accounts;
        
        return sendEmail(oppId, accounts, opportunities, altEmailAddress, true);        
    }
    
    /**
     * Method that gets all of the clients emails
     *
     * @param oppId - opportunity Id
     * @return List<String> - list of clients emails
     */
    @AuraEnabled
    public static List<String> getEmails(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        
        List<String> emails = new List<String>();

        if(opportunities.get(0).Selected_Email__c != null){
            emails.add(opportunities.get(0).Selected_Email__c);
        }
        
        if(opportunities.get(0).Selected_Email__c != accounts.get(0).PersonEmail){
        	emails.add(accounts.get(0).PersonEmail);
        }
         
        if(accounts.get(0).Alternative_Email__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email__c){
            emails.add(accounts.get(0).Alternative_Email__c);
        }
        if(accounts.get(0).Alternative_Email_1__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_1__c){
            emails.add(accounts.get(0).Alternative_Email_1__c);
        }
        if(accounts.get(0).Alternative_Email_2__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_2__c){
            emails.add(accounts.get(0).Alternative_Email_2__c);
        }
        if(accounts.get(0).Alternative_Email_3__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_3__c){
            emails.add(accounts.get(0).Alternative_Email_3__c);
        }
        if(accounts.get(0).Alternative_Email_4__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_4__c){
            emails.add(accounts.get(0).Alternative_Email_4__c);
        }

        return emails;
    }
    
    /**
     * Method that generates the ROA PDF and emails it to the clients active email
     * 
     * @param oppId - Opportunity Id
     * @param emailAddress - Emails address it is to be sent to
     */
    public static void generateAndSendROA(Id oppId, Account account, String emailAddress, User advisor, Boolean isFuture) {
		try{
		LoggingContext.start();
        EmailTemplate et = [SELECT Id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'EPP_Successful_Sale_Email'];
        String emailBody = et.HTMLValue;
        String emailSubject = et.Subject;
		
        List<Document> lstDocumentHeader = [Select Id,Name,LastModifiedById from Document where Name = 'Email Header' limit 1];
        String strOrgIdHeader = UserInfo.getOrganizationId();
        String strDocUrlHeader = '';
        if(!Test.isRunningTest()){
           strDocUrlHeader = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentHeader[0].Id+'&oid=' + strOrgIdHeader;
        }
 
        List<Document> lstDocumentBar = [Select Id,Name,LastModifiedById from Document where Name = 'Email Colour Bar' limit 1];
        String strOrgIdBar = UserInfo.getOrganizationId();
        String strDocUrlBar = '';
        if(!Test.isRunningTest()){
            strDocUrlBar = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentBar[0].Id+'&oid=' + strOrgIdBar;
        }
        
        emailBody = emailBody.replace('{!$Resource.EPPHeader}', strDocUrlHeader);
        emailBody = emailBody.replace('{!$Resource.ColourBar}', strDocUrlBar);
        emailBody = emailBody.replace('{!Account.Name}', account.FirstName + ' ' + account.LastName);
        emailBody = emailBody.replace('{!User.Name}', advisor.Name);
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                                
        List<Document__c> documents = new List<Document__c>();
        
        //Roa
        Opportunity opp = [SELECT Id, CloseDate, Commencement_Date__c, Debit_Order_Date__c, Commission1stYearnew__c, Commission2ndYearnew__c, SyncedQuoteId FROM Opportunity where Id = :oppId LIMIT 1];
        Quote q = new QuotesSelector().selectBySyncedQuoteId(opp.SyncedQuoteId);
        
        Map<Id, sObject> objectMap = new Map<Id, sObject>();
        objectMap.put(account.Id, account);
        objectMap.put(opp.Id, opp);
        objectMap.put(advisor.Id, advisor);
        objectMap.put(q.Id, q);
        
        Map<String, String> lookupMappings = new Map<String, String>();
        lookupMappings.put('Quote.QuoteLineItem', 'QuoteId');
        lookupMappings.put('Opportunity.Opportunity_Party__c', 'Opportunity__c');
        
        Document_Template__c template = new DocumentTemplateSelector().selectTemplateByName('EPP ROA');
        String res = DocumentTemplateMapper.createXml(objectMap, template.XML__c, lookupMappings);        
        
        CC_GenerateContentRequest roaRequest = generateContentRequest('RecordOfAdvice.pdf', '41', 'Ent_RecordOfAdvice', account.CIF__c, 'Not Available', res);
        CC_GenerateContentResponse response;
        Map<String, String> credentials;
        ECM_LoginResult_IB_V1 login;
        ECM_GetResult_IB_V1 getResult;
        Blob roaBlob;
        if(!Test.isRunningTest()){
			response = CC_ContentService_IH_v1.generateContent(roaRequest);  
            credentials = ECM_IH_V1.getCredentials();
            login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
            getResult = ECM_IH_V1.getDocument(login.token, response.contentStoreToken);
            roaBlob = EncodingUtil.base64Decode(getResult.Content.data); 
        }
             	
        Document__c doc = new Document__c();
        doc.Name= 'ROA - ' + DateTime.now() + '.pdf';
        doc.Type__c = 'EPP - ROA';
        doc.Opportunity__c = opp.Id;
        if(!Test.isRunningTest()){
            doc.Reference__c = response.contentStoreToken;
        }
        
        documents.add(doc); 
        
        //Quote
        
        objectMap = new Map<Id, sObject>();
        objectMap.put(account.Id, account);
        objectMap.put(advisor.Id, advisor);
        objectMap.put(q.Id, q);
        objectMap.put(opp.Id, opp);
        
        lookupMappings = new Map<String, String>();
        lookupMappings.put('Quote.QuoteLineItem', 'QuoteId');
        lookupMappings.put('Opportunity.Opportunity_Party__c', 'Opportunity__c');
        
        template = new DocumentTemplateSelector().selectTemplateByName('EPP Acceptance Quote');
        res = DocumentTemplateMapper.createXml(objectMap, template.XML__c, lookupMappings);
        
        CC_GenerateContentRequest quoteRequest = generateContentRequest('Quote.pdf', '45', 'Ent_Quotation', account.CIF__c, 'Not Available', res);
        Blob quoteBlob;
        if(!Test.isRunningTest()){
			response = CC_ContentService_IH_v1.generateContent(quoteRequest);  
            getResult = ECM_IH_V1.getDocument(login.token, response.contentStoreToken);
            quoteBlob = EncodingUtil.base64Decode(getResult.Content.data); 
        }
        
 		doc = new Document__c();
        doc.Name= 'Quote - ' + DateTime.now() + '.pdf';
        doc.Type__c = 'EPP - Quote';
        doc.Opportunity__c = opp.Id;
        if(!Test.isRunningTest()){
            doc.Reference__c = response.contentStoreToken;
        }
        documents.add(doc);
        
        //T&C's
        Blob tAndCBlob;
        template = new DocumentTemplateSelector().selectTemplateByName('EPP T&C');
        if(!Test.isRunningTest()){
    		getResult = ECM_IH_V1.getDocument(login.token, template.PID__c);
			tAndCBlob = EncodingUtil.base64Decode(getResult.Content.data); 
        }

 		doc = new Document__c();
        doc.Name= 'T&Cs - ' + DateTime.now() + '.pdf';
        doc.Type__c = 'EPP - T&Cs';
        doc.Opportunity__c = opp.Id;
        if(!Test.isRunningTest()){
            //doc.Reference__c = response.contentStoreToken;
            doc.Reference__c = template.PID__c;
        }
        documents.add(doc);
        
        //FAQ's
        
        Blob faqBlob;
        template = new DocumentTemplateSelector().selectTemplateByName('EPP FAQ');
        if(!Test.isRunningTest()){
    		getResult = ECM_IH_V1.getDocument(login.token, template.PID__c);
			faqBlob = EncodingUtil.base64Decode(getResult.Content.data);
        }

 		doc = new Document__c();
        doc.Name= 'FAQ - ' + DateTime.now() + '.pdf';
        doc.Type__c = 'EPP - FAQ';
        doc.Opportunity__c = opp.Id;
        if(!Test.isRunningTest()){
            //doc.Reference__c = response.contentStoreToken;
            doc.Reference__c = template.PID__c;
        }
        documents.add(doc);
        
        // Sets the paramaters of the email
        //email.setTemplateId(et.Id);
        email.setSubject(emailSubject);
        email.setToAddresses(new List<String>{emailAddress});
        email.setSaveAsActivity(true);
        email.setWhatId(oppId);
        //email.setTargetObjectId(account.PersonContactId);
        email.setHtmlBody(emailBody);
        email.setBccAddresses(new List<String>{advisor.Email});
        //Set from address
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'Advice Gurus'];
        if (owea.size() > 0) {
            email.setOrgWideEmailAddressId(owea.get(0).Id);
        }
                
        // Create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('RecordOfAdvice.pdf');
        efa.setBody(roaBlob);
        
        Messaging.EmailFileAttachment quoteEfa = new Messaging.EmailFileAttachment();
        quoteEfa.setFileName('Quote.pdf');
        quoteEfa.setBody(quoteBlob);
        
        Messaging.EmailFileAttachment tAndCEfa = new Messaging.EmailFileAttachment();
        tAndCEfa.setFileName('T&Cs.pdf');
        tAndCEfa.setBody(tAndCBlob);
        
        Messaging.EmailFileAttachment faqsEfa = new Messaging.EmailFileAttachment();
        faqsEfa.setFileName('FAQs.pdf');
        faqsEfa.setBody(faqBlob);
        
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa, quoteEfa, tAndCEfa, faqsEfa});
        
        if(!Test.isRunningTest()){
            // Sends the email
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        }
        
        insert documents; 
        
        if(!isFuture){
            //Send SMS - Successful Sale to the Client
        	dispatchSMS(account.PersonContactId, oppId, '', '', StringConstants.CLIENT_EPP_SUCCESSFUL_SALE_SMS, StringConstants.EPP_ITOUCH_SMS_INTEGRATION_SERVICE, true);
        }
		} catch (Exception ex) {
			System.debug('Error in SubmitDocumentsController: ' + ex.getMessage());
		} finally {
			LoggingContext.flush();
		}
    }
    
    /**
    * Method that sends the SMS - Successful Sale to the Client
    * 
    * @param whoId - Person Contact Id
    * @param whatId - Opportunity Id
    * @param phoneNumberOverride - mobile number override
    * @param recipientNameOverride - full name override
    * @param quickTextName - Quick Text template name
    * @param integrationService - The integration service to be used, it is defined for a business unit
    * @param saveAsActivity - indicates if the Task SMS activity is to be created 
    * 
    */
    @Future(callout=true)
    private static void dispatchSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
        SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
    }
    
    private static CC_GenerateContentRequest generateContentRequest(String fileName, String templateId, String ecmType, String cifNum, String accNum, String xmlTemplate){
        CC_GenerateContentRequest request = new CC_GenerateContentRequest();
        request.FileName = fileName;
        request.TemplateDataType = 'XML';
        request.LogLevel = 'None';
        request.ScheduleTimeStamp = String.valueOf(Date.today());
        request.RecordSystemFeedbackID = '123';
        request.ContentRequestType = 'PDF';
        request.ContentStoreType = 'ECM';
        request.ContentVersion = '1.0.0.0';
        request.Password = '';
        request.encodingType = '';
        request.ReturnEmptyContent = true;
        request.TemplateID = templateId;
        
        List<CC_GenerateContentRequest.ContentStoreParams> cspList = new List<CC_GenerateContentRequest.ContentStoreParams>();
        CC_GenerateContentRequest.ContentStoreParams params = new CC_GenerateContentRequest.ContentStoreParams();
        
        params.ItemType = 'Origin';
        params.ItemValue = 'Sales-Force Wimmi';
        cspList.add(params);
        
        params = new CC_GenerateContentRequest.ContentStoreParams();
        params.ItemType = 'ECMItemType';
        params.ItemValue = ecmType;
        cspList.add(params);
        
        params = new CC_GenerateContentRequest.ContentStoreParams();
        params.ItemType = 'BusinessUnit';
        params.ItemValue = 'Virtual Advisor';
        cspList.add(params);
        
        params = new CC_GenerateContentRequest.ContentStoreParams();
        params.ItemType = 'CIFNr';
        params.ItemValue = cifNum;
        cspList.add(params);
        
        params = new CC_GenerateContentRequest.ContentStoreParams();
        params.ItemType = 'AcctNr';
        params.ItemValue = accNum;
        cspList.add(params);
        
        request.contentStoreParamaters = cspList;
        request.templateData = xmlTemplate;
        
        return request;
    }
}