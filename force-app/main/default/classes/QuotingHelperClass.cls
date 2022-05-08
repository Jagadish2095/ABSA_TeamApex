/**
* Helper that generates the mail to be sent out at quote stage
* @author  Kyle Alexander
* @created 2018-10-11
*/
public class QuotingHelperClass {

    /**
    * Method that does orchestration, generates and sends email
    *
    * @param mMail - email address
    * @param oppId - Opportunity ID
    */
    public static Boolean sendMailMethod(String mMail, Id oppId){
        Boolean r ;
    	try {
            LoggingContext.start();
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
            List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
            List<User> advisor = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
            Quote q = new QuotesSelector().selectBySyncedQuoteId(opportunities.get(0).SyncedQuoteId);
            List<EmailTemplate> etList = new List<EmailTemplate>();
            String emailBody = null;
            String emailSubject = null;
            etList = new EmailTemplatesSelector().selectByName('EPP Quote Email');
            if (!etList.isEmpty() && etList != null) {
                emailBody = etList.get(0).HTMLValue;
                emailSubject = etList.get(0).Subject;
            }
            Set<String> docNameSet = new Set<String>();
            docNameSet.add('Email Header');
            docNameSet.add('Email Colour Bar');
            List<Document> lstDocument =  new List<Document>();
            Id lstDocumentHeader = null;
            Id lstDocumentBar = null;
            lstDocument = new DocumentSelector().selectByName(docNameSet);
            if (!lstDocument.isEmpty() && lstDocument != null) {
                for (Document d : lstDocument) {
                    if (d.Name == 'Email Header') {
                        lstDocumentHeader = d.Id;
                    }
                    if (d.Name == 'Email Colour Bar') {
                        lstDocumentBar = d.Id;
                    }
                }
            }
            String strOrgIdHeader = UserInfo.getOrganizationId();
            String strDocUrlHeader = '';
            if(!Test.isRunningTest()){
                strDocUrlHeader = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentHeader+'&oid=' + strOrgIdHeader;
            }
            String strOrgIdBar = UserInfo.getOrganizationId();
            String strDocUrlBar = '';
            if(!Test.isRunningTest()){
                strDocUrlBar = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentBar+'&oid=' + strOrgIdBar;
            }
            emailBody = emailBody.replace('{!$Resource.EPPHeader}', strDocUrlHeader);
            emailBody = emailBody.replace('{!$Resource.ColourBar}', strDocUrlBar);
            emailBody = emailBody.replace('{!Account.Name}', accounts.get(0).FirstName + ' ' + accounts.get(0).LastName);
            emailBody = emailBody.replace('{!User.Name}', advisor.get(0).Name);
            Map<Id, sObject> objectMap = new Map<Id, sObject>();
            objectMap.put(accounts.get(0).Id, accounts.get(0));
            objectMap.put(advisor.get(0).Id, advisor.get(0));
            objectMap.put(q.Id, q);
            objectMap.put(opportunities.get(0).Id, opportunities.get(0));
            Map<String, String> lookupMappings = new Map<String, String>();
            lookupMappings.put('Quote.QuoteLineItem', 'QuoteId');
            lookupMappings.put('Opportunity.Opportunity_Party__c', 'Opportunity__c');
            Document_Template__c template = new DocumentTemplateSelector().selectTemplateByName('EPP Quote Stage');
            String res = DocumentTemplateMapper.createXml(objectMap, template.XML__c, lookupMappings);
            CC_GenerateContentRequest quoteRequest = generateContentRequest('Quote.pdf', '42', 'Ent_Quotation', accounts.get(0).CIF__c, 'Not Available', res);
            CC_GenerateContentResponse response;
            Map<String, String> credentials;
            ECM_LoginResult_IB_V1 login;
            ECM_GetResult_IB_V1 getResult;
            Blob quoteBlob;
            if(!Test.isRunningTest()){
                response = CC_ContentService_IH_v1.generateContent(quoteRequest);
                credentials = ECM_IH_V1.getCredentials();
                login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
                getResult = ECM_IH_V1.getDocument(login.token, response.contentStoreToken);
                quoteBlob = EncodingUtil.base64Decode(getResult.Content.data);
            }
            Document__c doc = new Document__c();
            doc.Name= 'Quote - ' + DateTime.now() + '.pdf';
            doc.Type__c = 'EPP - Quote';
            doc.Opportunity__c = opportunities.get(0).Id;
            if(!Test.isRunningTest()){
                doc.Reference__c = response.contentStoreToken;
                insert doc;
            }
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(emailSubject);
            mail.setToAddresses(new List<String>{mMail});
            mail.setSaveAsActivity(true);
            mail.setWhatId(oppId);
            mail.setHtmlBody(emailBody);
            mail.setBccAddresses(new List<String>{advisor.get(0).email});
            Set<String> nameSet = new Set<String>();
            nameSet.add('Advice Gurus');
            List<OrgWideEmailAddress> owea = new List<OrgWideEmailAddress>();
            owea = new OrgWideEmailAddressesSelector().selectByName(nameSet);
            if (!owea.isEmpty() && owea != null) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('Quote.pdf');
            efa.setBody(quoteBlob);
            fileAttachments.add(efa);
            mail.setFileAttachments(fileAttachments);
            mails.add(mail);
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mails);
            }
            r = true;
    	} catch (Exception ex) {
            AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingHelperClass', 'sendMailMethod', 'Send email with attached quote');
            r = false;
    	} finally {
    		LoggingContext.flush();
        }
        return r;
    }

    private static CC_GenerateContentRequest generateContentRequest(String fileName, String templateId, String ecmType, String cifNum, String accNum, String xmlTemplate){
        CC_GenerateContentRequest request = new CC_GenerateContentRequest();
        request.FileName = fileName;
        request.TemplateDataType = 'XML';
        request.LogLevel = 'Debug';
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
        params.ItemType = 'CIFNumer';
        params.ItemValue = cifNum;
        cspList.add(params);
        params = new CC_GenerateContentRequest.ContentStoreParams();
        params.ItemType = 'AccNumber';
        params.ItemValue = accNum;
        cspList.add(params);
        request.contentStoreParamaters = cspList;
        request.templateData = xmlTemplate;
        return request;
    }
}