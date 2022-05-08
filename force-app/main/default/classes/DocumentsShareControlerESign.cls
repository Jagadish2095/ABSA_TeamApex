/**
* Controller for Documents Share Lightning component
* @author Vladimir Panajic
* @created 2019-05-20
*/
public class DocumentsShareControlerESign {
    
    static Map <String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    
    /**
* @author Vladimir Panajic
* Method that gets a list of all documents for an Opportunity
*
* @param opportunityId
* @return documents
*/
    @AuraEnabled
    public static List<Document__c> getDocumentsData(Id opportunityId) {
        try {
            ImpressionsController.updateImpressionRequests(opportunityId);
        } catch (Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        
        List<Document__c> documents = new DocumentsSelector().getDocuments(opportunityId, 'Opportunity', 100);
        return documents;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets a list of all document audits (email and download) for an Opportunity
*
* @param opportunityId
* @return documentAudits
*/
    @AuraEnabled
    public static List<Document_Audit__c> getDocumentAudit(Id opportunityId) {
        List<Document_Audit__c> documentAudits = new DocumentAuditsSelector().selectDocumentsShare(opportunityId);
        return documentAudits;
    }
    
    /**
* @author Danie Booysen
* Method that gets a list of all document audits (email) for an Opportunity
*
* @param opportunityId
* @return documentAudits
*/
    @AuraEnabled
    public static List<Document_Audit__c> getDocAuditHistoryEmail(Id opportunityId) {
        List<Document_Audit__c> documentAudits = new DocumentAuditsSelector().selectDocumentsShareByEmail(opportunityId);
        return documentAudits;
    }
    
    /**
* @author Jason Quevauvilliers
* Method that gets a list of all Tasks (email) for an Opportunity
*
* @param opportunityId
* @return Tasks
*/
    @AuraEnabled
    public static List<Task> getDocumentAuditEmail(Id opportunityId) {
        return [SELECT Id, Subject, Document_Sharing_Email__c, Document_Sharing_Method__c, CreatedDate
                FROM Task WHERE WhatId =: opportunityId ORDER BY CREATEDDATE DESC];
    }
    
    /**
* @author Jason Quevauvilliers
* Method that gets a list of all Tasks (email) for an Opportunity
*
* @param opportunityId
* @return Tasks
*/
    @AuraEnabled
    public static List<Email_Document__c> getEmailDocuments(Id activityId) {
        return [SELECT Id, Name, Document__c, Email_Message__c, Email_Message_Name__c, Activity__c, CreatedDate
                FROM Email_Document__c WHERE Activity__c =: activityId ORDER BY CREATEDDATE DESC];
    }
    
    
    /**
* @author Jason Quevauvilliers
* Method that gets the Opportunity related to the task 
*
* @param Task Id
* @return Opportunity Id
*/
    @AuraEnabled
    public static Id getOpportunityIdFromTask(Id taskIdP) {
        return [SELECT WhatId
                FROM Task WHERE Id =: taskIdP].WhatId;
    }
    
    
    /**
* @author Vladimir Panajic
* Method that gets a list of all Impression requests for an Opportunity
*
* @param opportunityId
* @return impressionRequests
*/
    @AuraEnabled
    public static List<ImpressionRequest__c> fetchImpressionRequest(Id opportunityId) {
        List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectRequestsByOpptyId(opportunityId);
        return impressionRequests;
    }
    
    /**
* @author Vladimir Panajic
* Method that creates a documents share audit record
*
* @param opportunityId
* @param documentId
* @param sharingMethod
* @param clientEmail
*/
    @AuraEnabled
    public static void createDocumentSharingAudit(Id opportunityId, Id documentId, String sharingMethod, String clientEmail) {
        Document_Audit__c documentAudit = new Document_Audit__c();
        documentAudit.Document__c = documentId;
        documentAudit.Opportunity__c = opportunityId;
        documentAudit.Document_Sharing_Method__c = sharingMethod;
        documentAudit.Document_Sharing_Email__c = clientEmail;
        try {
            insert documentAudit;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    /**
* @author Vladimir Panajic
* Method that downloads a document to the desktop
*
* @param documentId
* @return ECM_GetResult_IB_V1.Content.data
*/
    @AuraEnabled
    public static String getDocumentContent(Id opportunityId, Id documentId, String sharingMethod, String clientEmail) {
        System.debug('***OPP ID: ' + opportunityId);
        System.debug('***DOCUMENT ID: ' + documentId);
        
        Document__c doc = new DocumentsSelector().selectById(documentId);
        ECM_LoginResult_IB_V1 login = ECMLogin();
        ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, doc.Reference__c);
        createDocumentSharingAudit(opportunityId, documentId, sharingMethod, clientEmail);
        return getResult.Content.data;
    }
    
    /**
* @author Vladimir Panajic
* Method that logs to ECM
*/
    public static ECM_LoginResult_IB_V1 ECMLogin() {
        /* if (Test.isRunningTest()) {
String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
Test.setMock(HttpCalloutMock.class, new ECM_IH_V1Test.ECM_Mock_ApiRest(body));
ECM_LoginResult_IB_V1 result = ECM_IH_V1.login('DGOLSDB', 'DEV_TestUser', 'D3vT#sting');
return result;
}*/
        Map<String, String> credentials = ECM_IH_V1.getCredentials();        
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));        
        return login;
    }
    
    /**
* @author Vladimir Panajic
* Method that does the component refresh on demand
*/
    @AuraEnabled
    public static void dummyRefresh() {
        //this is a dummy refresh
    }
    
    /**
* @author Vladimir Panajic
* Method that gets the name of the adviser (loged in user) for the documents share declaration
*
* @return Name
*/
    @AuraEnabled
    public static String fetchAdviserName() {
        return UserInfo.getName();
    }
    
    /**
* @author Vladimir Panajic
* Method that gets the name of the Opportunity Owner for the documents share declaration
*
* @return Name
*/
    @AuraEnabled
    public static String fetchOppOwnerName(Id oppId) {
        
        List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<User> userList = [SELECT Name FROM User WHERE Id =: opportunityList[0].OwnerId];
        return userList[0].Name;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets a content of a list of documents
*
* @param idListJSON
* @return docs
*/
    public static List<List<string>> getDocumentsContent(String idListJSON) { 
        List<List<string>> docs = new List<List<string>>();   
        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECMLogin();       
        
        Type idArrType = Type.forName('List<string>');     
        List<string> wrapperList = (List<string>) JSON.deserialize(idListJSON, idArrType);       
        for (String documentId : wrapperList) {         
            Document__c doc = new DocumentsSelector().selectById(documentId);  
            ECM_GetResult_IB_V1 getResult;
            if (!Test.isRunningTest()) {
                getResult = ECM_IH_V1.getDocument(login.token, doc.Reference__c); 
            } else {
                getResult = ECM_GetResult_IB_V1.getExample();
            }
            if(getResult.Content != null){
                docs.add(new List<string>{documentId, doc.Name, getResult.Content.data});
            }
        }
        return docs;
    }
    
    /** 
* @author Vladimir Panajic
* Method that sends a document sharing email with attachment(s)
*
* @param opportunityId
* @param clientEmail
* @param idListJSON
*/
    @AuraEnabled
    public static void sendDocumentSharingEmail(String opportunityId, String clientEmail, String idListJSON) {
        System.debug('idListJSON ' + idListJSON);
        List<List<string>> docs = getDocumentsContent(idListJSON);
        System.debug('Documents: ' + docs);
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        
        List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (applicationList.isEmpty() || applicationList.size()==0) {
            Application__c application = new Application__c();
            application.RecordTypeId = applicationRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
            application.Opportunity__c = opportunityId;
            application.Preferred_Email__c = clientEmail;
            try {
                insert application;
            } catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        } else {
            applicationList.get(0).Preferred_Email__c = clientEmail;
            try {
                update applicationList.get(0);
            } catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        //String clientEmail = accounts.get(0).PersonEmail;
        String templateName = StringConstants.WIMI_DOCUMENTS_SHARE_EMAIL;
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        Id templateId;
        List<EmailTemplate> emailTemplatesList = new EmailTemplatesSelector().selectByDeveloperName(templateName);
        if (!emailTemplatesList.isEmpty()) {
            templateId = emailTemplatesList.get(0).Id;
        }
        msg.setTemplateId(templateId);
        msg.setWhatId(opportunityId);
        msg.setTargetObjectId(accounts.get(0).PersonContactId);
        msg.setToAddresses(new List<String>{clientEmail});
        msg.plainTextBody = 'Please find attached the document.';
        lstMsgs.add(msg);
        for(Messaging.SingleEmailMessage email : lstMsgs) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            List<Messaging.Emailfileattachment> attList = new List<Messaging.Emailfileattachment>();
            for(Integer i=0;i < docs.size();i++) {
                System.debug('Index i: ' + i);
                Messaging.Emailfileattachment att = new Messaging.Emailfileattachment();  
                for(Integer j=0;j < docs[i].size();j++) {
                    System.debug('Index j: ' + j);
                    System.debug('docs[i][j]: ' + docs[i][j]);
                    if(j==1) {
                        att.setFileName(docs[i][j]);
                    } else if(j==2) {
                        Blob faqBlob;
                        faqBlob = EncodingUtil.base64Decode(docs[i][j]);
                        att.setBody(faqBlob);
                        attList.add(att);
                    }
                }
            }
            emailToSend.setFileAttachments(attList);
            //Needed for the setSaveAsActivity = true. Send the emails in a transaction, then roll it back
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(lstMsgs);
            Database.rollback(sp);
            emailToSend.setToAddresses(email.getToAddresses());
            emailToSend.setPlainTextBody(email.getPlainTextBody());
            emailToSend.setHTMLBody(email.getHTMLBody());
            emailToSend.setSubject(email.getSubject());
            emailToSend.setSaveAsActivity(false);
            emailToSend.setWhatId(opportunityId);
            lstMsgsToSend.add(emailToSend);
            
            //Create EmailMessage Object and map fields
            EmailMessage emailMessage = new EmailMessage();
            emailMessage.TextBody = email.getPlainTextBody();
            emailMessage.htmlBody = email.getHTMLBody();
            emailMessage.Subject = email.getSubject();
            emailMessage.FromName = UserInfo.getName();
            emailMessage.FromAddress = UserInfo.getUserEmail();
            emailMessage.ValidatedFromAddress = UserInfo.getUserEmail();
            emailMessage.ToAddress = clientEmail;
            emailMessage.RelatedToId = opportunityId;
            emailMessage.status = '3';
            emailMessage.MessageDate = System.now();
            emailMessage.IsClientManaged = false;
            emailMessage.IsTracked = false;
            emailMessage.IsBounced = false;
            emailMessage.Is_Auto_Response__c = false;
            emailMessage.Incoming = false;
            emailMessageList.add(emailMessage);
            
        }
        //Send Email
        Messaging.sendEmail(lstMsgsToSend);
        
        insert emailMessageList;
        //Get Id Set from EmailMessages
        Set<Id> messageIdSet = new Set<Id>();
        for(EmailMessage eMessage : emailMessageList){
            messageIdSet.add(eMessage.Id);
        }
        //Requery EmailMessages to get ActivityId
        List<EmailMessage> newEmailMessageList = [SELECT Id, ActivityId, Subject FROM EmailMessage WHERE Id IN : messageIdSet];
        System.debug(newEmailMessageList[0].ActivityId);
        //Query Task Based off of ActivityId
        List<Task> taskList = [SELECT Id, Subject, Document_Sharing_Method__c, Document_Sharing_Email__c FROM Task WHERE Id =: newEmailMessageList[0].ActivityId];
        System.debug(taskList);
        //Map Task Fields
        taskList[0].Document_Sharing_Method__c = 'Email';
        taskList[0].Document_Sharing_Email__c = clientEmail;
        
        List<Email_Document__c> emailDocumentList = new List<Email_Document__c>();
        //Map Email_Document__c for each Document for each Email
        for(EmailMessage eMessage : newEmailMessageList){
            
            for(Integer i=0;i < docs.size();i++) {
                
                Email_Document__c emailDocument = new Email_Document__c();
                emailDocument.Email_Message__c = eMessage.Id;
                emailDocument.Email_Message_Name__c = eMessage.Subject;
                emailDocument.Activity__c = eMessage.ActivityId;
                
                for(Integer j=0;j < docs[i].size();j++) {
                    System.debug(docs[i][j]);
                    if(j==0) {
                        emailDocument.Document__c = docs[i][j];
                    }
                    if(j==1){
                        emailDocument.Name = docs[i][j];
                    }
                }
                emailDocumentList.add(emailDocument);
            } 
        }
        
        update taskList;
        insert emailDocumentList;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets a list of all signatories for a document
*
* @param documentId
* @return listTotal
*/
    @AuraEnabled
    public static List<Map<String, Object>> getSigntoriesData(Id documentId) {
        Document__c doc = new DocumentsSelector().selectById(documentId);
        String documentType = doc.Type__c;
        String documentName = doc.Name;
        Id opportunityId = doc.Opportunity__c;
        List<Digital_Signature_Admin__c> admin = new DigitalSignatureAdminsSelector().selectDigitalSignatureAdminByType(documentType);
        Id adminId; // validation added in case Admin not setup
        //  W-004546 - Tinashe Shoko
        if (!admin.isEmpty() && admin.size() > 0 && admin != null) {
            adminId = admin.get(0).Id;
        } else {
            System.debug('Error! Please setup Digital Signature Admin records for ' + documentType);
            return null;
        }
        List<Digital_Signature_Signatory__c> signatories = new DigitalSignatorySignatoriesSelector().selectSignatory(adminId);
        if (signatories.isEmpty() || signatories.size() <= 0 || signatories == null) { // validation added in case Admin not setup
            //W-004546 - Tinashe Shoko
            System.debug('Error! Please setup Digital Signature Signatories records for ' + documentType);
            return null;
        }
        List<Map<String,Object>> listTotal = new List<Map<String,Object>>();
        for(Integer i = 0; i < signatories.size(); i++) {
            Map<String,String> mapObj = new Map<String,String>();
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
            if (signatories[i].Signatory_Type__c == 'Parent Owner') {
                User adviser = new UsersSelector().selectById(opportunities.get(0).OwnerId);
                mapObj.put('Id', adviser.Id);
                mapObj.put('Title', 'Advisor.');
                mapObj.put('Last_Name', adviser.LastName);
                String phoneNumber = adviser.MobilePhone;
                //Verify User's mobile number format is compatible with Impression format. Salesforce User's mobile number format is '+27 0600000000', so remove space and 0
                if (phoneNumber != null && phoneNumber != '') {
                    if (phoneNumber.substring(0, 4) == '+27 ') {
                        phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(5, 14);
                    }
                }
                mapObj.put('Mobile_Phone', phoneNumber);
                mapObj.put('Email', adviser.Email);
                mapObj.put('Order', String.valueOf(signatories[i].Order__c));
                mapObj.put('Role', 'Adviser');
                mapObj.put('Method', signatories[i].Preferred_Method__c);
                mapObj.put('Document_Name', documentName);
                mapObj.put('Document_Type', documentType);
                listTotal.add(mapObj);
            } else if (signatories[i].Signatory_Type__c == 'Parent Customer') {
                Account client = new AccountsSelector().selectById(opportunities.get(0).AccountId);
                List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.PersonContactId, 1);
                mapObj.put('Id', client.PersonContactId);
                if (client.Salutation != null) {
                    mapObj.put('Title', client.Salutation);
                } else {
                    mapObj.put('Title', '');
                }
                mapObj.put('Last_Name', client.LastName);
                //Mobile Phone, Email and Method
                String mobile;
                if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList.size() > 0 && signatoryPartyOveridesList != null) {
                    if(signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null) {
                        if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10) {
                            mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
                        } 
                        mapObj.put('Mobile_Phone', mobile);
                    } else {
                        if (client.PersonMobilePhone != '' && client.PersonMobilePhone != null) {
                            mobile = '+27' + client.PersonMobilePhone.substring(1, 10);
                            mapObj.put('Mobile_Phone', mobile);
                        }
                    }
                    
                    if(signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null) {
                        mapObj.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
                    } else {
                        mapObj.put('Email', client.PersonEmail);
                    }
                    
                    if(signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null) {
                        mapObj.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
                    } else {
                        mapObj.put('Method', signatories[i].Preferred_Method__c);
                    }
                } else {
                    if (client.PersonMobilePhone != '' && client.PersonMobilePhone != null) {
                        mobile = '+27' + client.PersonMobilePhone.substring(1, 10);
                        mapObj.put('Mobile_Phone', mobile);
                    } else {
                        mapObj.put('Mobile_Phone', '');
                    }
                    if (client.PersonEmail != '') {
                        mapObj.put('Email', client.PersonEmail);
                    } else {
                        mapObj.put('Email', '');
                    }
                    mapObj.put('Method', signatories[i].Preferred_Method__c);
                }
                mapObj.put('Order', String.valueOf(signatories[i].Order__c));
                mapObj.put('Role', 'Client');
                mapObj.put('Document_Name', documentName);
                mapObj.put('Document_Type', documentType);
                listTotal.add(mapObj);
            } else if (signatories[i].Signatory_Type__c == 'Authorised Signatory') {
                //String roles = '\'Individual with Authority to Act\'';
                List<OpportunityLineItem> oppLineList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunities.get(0).Id, 1);
                if (oppLineList != null && !oppLineList.isEmpty() &&  oppLineList.size() > 0) { // check if there are contacts found
                    // below line chnaged to search by and get details of identified Contact Person W-004546 - Tinashe Shoko
                    //List<AccountContactRelation> acrList =  new AccountContactRelationSelector().selectRelationByAcctIdAndRoles(opportunities.get(0).AccountId, roles);
                    List<AccountContactRelation> acrList =  new AccountContactRelationSelector().selectRelationById(oppLineList[0].Contact_Person__c);
                    List<merchantOnboardingAuthSignatoryCtrl.contactPerson> cpList = new List<merchantOnboardingAuthSignatoryCtrl.contactPerson>();
                    // changes made here to cater for person account if there is not ACR record
                    if (acrList != null && !acrList.isEmpty() && acrList.size() > 0) {
                        for (AccountContactRelation acr : acrList) {
                            merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
                            cp.id = acr.Id;
                            cp.salutation = acr.Contact.Salutation;
                            cp.initials = acr.Contact.Initials__c;
                            cp.lastName = acr.Contact.LastName;
                            cp.mobilePhone = acr.Contact.MobilePhone;
                            cp.email = acr.Contact.Email;
                            cp.roles = acr.Roles;
                            cpList.add(cp);
                        }
                    } else {
                        Account ac = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
                        if (ac != null) {
                            merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
                            cp.id = ac.Id;
                            cp.salutation = ac.PersonTitle;
                            cp.initials = ac.Initials__pc;
                            cp.lastName = ac.LastName;
                            cp.mobilePhone = ac.PersonMobilePhone;
                            cp.email = ac.PersonEmail;
                            cp.roles = 'Individual with Authority to Act';
                            cpList.add(cp);
                        }
                    }
                    for (merchantOnboardingAuthSignatoryCtrl.contactPerson client : cpList) {
                        Map<String,String> mapObjAuthSig = new Map<String,String>();
                        List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.id, 1);
                        mapObjAuthSig.put('Id', client.id);
                        if (client.salutation != null) {
                            mapObjAuthSig.put('Title', client.salutation);
                        } else {
                            mapObjAuthSig.put('Title', '');
                        }
                        mapObjAuthSig.put('Last_Name', client.lastname);
                        //Mobile Phone, Email and Method
                        String mobile;
                        if (!signatoryPartyOveridesList.isEmpty()  && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
                            if(signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null) {
                                if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10) {
                                    mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
                                } 
                                mapObjAuthSig.put('Mobile_Phone', mobile);
                            } else {
                                if (client.mobilePhone != '' && client.mobilePhone != null) {
                                    mobile = '+27' + client.mobilePhone.substring(1, 10);
                                    mapObjAuthSig.put('Mobile_Phone', mobile);
                                }
                            }
                            
                            if(signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null) {
                                mapObjAuthSig.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
                            } else {
                                mapObjAuthSig.put('Email', client.email);
                            }
                            
                            if(signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null) {
                                mapObjAuthSig.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
                            } else {
                                mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
                            }
                        } else {
                            if (client.mobilePhone != '' && client.mobilePhone != null) {
                                mobile = '+27' + client.mobilePhone.substring(1, 10);
                                mapObjAuthSig.put('Mobile_Phone', mobile);
                            } else {
                                mapObjAuthSig.put('Mobile_Phone', '');
                            }
                            if (client.email != '') {
                                mapObjAuthSig.put('Email', client.email);
                            } else {
                                mapObjAuthSig.put('Email', '');
                            }
                            mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
                        }
                        mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
                        mapObjAuthSig.put('Role', 'Client'); // this allows us to Overide e.g. the mobile number
                        mapObjAuthSig.put('Document_Name', documentName);
                        mapObjAuthSig.put('Document_Type', documentType);
                        listTotal.add(mapObjAuthSig);
                    }
                    // } // ends here - marker
                }
            }
        }
        return listTotal;
    }
    
    /**
* @author Vladimir Panajic
* Method that calls Impression for document digital signature
*
* @param documentId
* @param signatories
* @return wid
*/
    @AuraEnabled
    public static String sendForImpressionSignature(Id documentId, String signatories) {
        List<JSON2ApexSignatories> signatoryList = JSON2ApexSignatories.parse(signatories);
        List<Impressions_Model.Signatory> signatoriesList = new List<Impressions_Model.Signatory>();  
        List<Impressions_Model.SignatoryWrapper> wrappers = new List<Impressions_Model.SignatoryWrapper>();   
        if (!signatoryList.isEmpty()) {
            Integer ii = 0;
            for (JSON2ApexSignatories signatoryParty: signatoryList) {
                Impressions_Model.Signatory signatory = new Impressions_Model.Signatory();
                Impressions_Model.SignatoryWrapper wrapper = new Impressions_Model.SignatoryWrapper();
                signatory.title = signatoryList.get(ii).Title;
                signatory.surname = signatoryList.get(ii).Last_Name;
                signatory.email = signatoryList.get(ii).Email;
                signatory.mobile = signatoryList.get(ii).Mobile_Phone;
                Impressions_Model.CustomSignatoryOptions custom = new Impressions_Model.CustomSignatoryOptions();
                //custom.challenge =  'I, Adolf van Niekerk, test test test test test test tes agree on @ease Life insurance quotation:\nPremium R500 per month.\n1. Accept\n9. Decline';
                //custom.challenge =  'I, #{fullname}, agree on @ease Life insurance quotation. \n1. Accept\n9. Decline'.replace('#{fullname}', signatory.surname);
                custom.challenge = 'Absa Merchant OnBoarding: You are responding to a merchant proposal/application. \n Please select \n1-Accept\n9-Reject';
                signatory.custom = custom;
                signatoriesList.add(signatory);
                wrapper.title = signatory.title;
                wrapper.surname = signatory.surname;
                wrapper.mobile = signatory.mobile;
                wrapper.email = signatory.email;
                wrapper.method = signatoryParty.Method;
                wrapper.index = ii + 1;
                wrapper.signatory = signatory;
                wrappers.add(wrapper);
                ii += 1;
            }
        }
        if (test.isRunningTest()) return 'test done';
        String document = DocumentController.getDocumentContent(documentId);
        String wid = ImpressionsController.sendForSigning(wrappers, document, documentId);         
        return wid;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets all of the clients emails for sharing
*
* @param opportunity Id
* @return emails
*/
    @AuraEnabled
    public static List<String> getAllClientEmails(Id opportunityId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        List<String> emails = new List<String>();        
        List<Application__c> applications = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (applications.get(0).Preferred_Email__c != null && applications.get(0).Preferred_Email__c != '') {
                emails.add(applications.get(0).Preferred_Email__c);
            }
        }
        
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).PersonEmail != null && applications.get(0).Preferred_Email__c != accounts.get(0).PersonEmail) {
                emails.add(accounts.get(0).PersonEmail);
            }
        } else {
            if (accounts.get(0).PersonEmail != null) {
                emails.add(accounts.get(0).PersonEmail);
            }
        }
        
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).Alternative_Email__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email__c) {
                emails.add(accounts.get(0).Alternative_Email__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email__c);
        }
        
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).Alternative_Email_1__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_1__c) {
                emails.add(accounts.get(0).Alternative_Email_1__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_1__c);
        }
        
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).Alternative_Email_2__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_2__c) {
                emails.add(accounts.get(0).Alternative_Email_2__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_2__c);
        }
        
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).Alternative_Email_3__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_3__c) {
                emails.add(accounts.get(0).Alternative_Email_3__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_3__c);
        }
        
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).Alternative_Email_4__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_4__c) {
                emails.add(accounts.get(0).Alternative_Email_4__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_4__c);
        }
        // bug raised in UAT - solution is to read also email from Active Email field
        if (!applications.isEmpty() && applications != null && applications.size() > 0) {
            if (accounts.get(0).Active_Email__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Active_Email__c) {
                emails.add(accounts.get(0).Active_Email__c);
            }
        } else {
            emails.add(accounts.get(0).Active_Email__c);
        }
        // end bugfix for UAT
        
        return emails;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets all of the clients emails for the digital signature
*
* @param opportunity Id
* @return emails
*/
    @AuraEnabled
    public static List<String> getAllClientEmailsSignature(Id opportunityId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        List<String> emails = new List<String>();        
        List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, accounts.get(0).PersonContactId, 1);
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (signatoryPartyOveridesList.get(0).Preferred_Email__c != null) {
                emails.add(signatoryPartyOveridesList.get(0).Preferred_Email__c);
            }
        }
        
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (accounts.get(0).PersonEmail != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).PersonEmail) {
                emails.add(accounts.get(0).PersonEmail);
            }
        } else {
            if (accounts.get(0).PersonEmail != null) {
                emails.add(accounts.get(0).PersonEmail);
            }
        }
        
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (accounts.get(0).Alternative_Email__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email__c) {
                emails.add(accounts.get(0).Alternative_Email__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email__c);
        }
        
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (accounts.get(0).Alternative_Email_1__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_1__c) {
                emails.add(accounts.get(0).Alternative_Email_1__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_1__c);
        }
        
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (accounts.get(0).Alternative_Email_2__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_2__c) {
                emails.add(accounts.get(0).Alternative_Email_2__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_2__c);
        }
        
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (accounts.get(0).Alternative_Email_3__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_3__c) {
                emails.add(accounts.get(0).Alternative_Email_3__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_3__c);
        }
        
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (accounts.get(0).Alternative_Email_4__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_4__c) {
                emails.add(accounts.get(0).Alternative_Email_4__c);
            }
        } else {
            emails.add(accounts.get(0).Alternative_Email_4__c);
        }
        
        return emails;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets all of the clients mobile numbers
*
* @param opportunityId
* @return mobile
*/
    @AuraEnabled
    public static List<String> getMobile(Id opportunityId) {
        System.debug('getMobile-opportunityId: ' + opportunityId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
        System.debug('getMobile1');
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        System.debug('getMobile2');
        Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        System.debug('getMobile3');
        List<String> mobile = new List<String>();
        System.debug('getMobile4');
        List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, accounts.get(0).PersonContactId, 1);
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0) {
            if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null) {
                mobile.add(signatoryPartyOveridesList.get(0).Preferred_Mobile__c);
            }
        }
        System.debug('getMobile5');
        if (account.PersonMobilePhone != null) {
            mobile.add(account.PersonMobilePhone);
        }
        System.debug('getMobile6');
        return mobile;
    }
    
    /**
* @author Vladimir Panajic
* Gets the LOVs for Digital Signatory input field
*
* @param fld
* @return allOpts
*/    
    @AuraEnabled
    public static List <String> getDigitalSignatorySelectOptions(string fld) {
        List <String> allOpts = new list <String> ();
        Digital_Signature_Signatory__c dss = new Digital_Signature_Signatory__c();
        Schema.sObjectType objType = dss.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    /**
* @author Vladimir Panajic
* Method that gets an updated list of all signatory items for a document
*
* @param opportunityId
* @param documentId
* @param signatoryId
* @param signatoriesInput
* @param method
* @param mobile
* @param email
* @return listTotal
*/
    @AuraEnabled
    public static List<Map<String, Object>> getUpdatedSignatoriesData(Id opportunityId, Id documentId, Id signatoryId, String signatoriesInput, String method, String mobile, String email) {
        //Overide method, mobile, email for a signatory party
        if (email != '' || mobile != '' || method != '') {
            List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, signatoryId, 1);
            if (signatoryPartyOveridesList.isEmpty() || signatoryPartyOveridesList == null || signatoryPartyOveridesList.size() < 1) {
                Signatory_Party_Overide__c signatoryPartyOveride = new Signatory_Party_Overide__c();
                signatoryPartyOveride.Opportunity__c = opportunityId;
                signatoryPartyOveride.Signatory_Party__c = signatoryId;
                if (email != '') {
                    signatoryPartyOveride.Preferred_Email__c = email;
                }
                if (mobile != '') {
                    signatoryPartyOveride.Preferred_Mobile__c = mobile;
                }
                if (method != '') {
                    signatoryPartyOveride.Preferred_Method__c = method;
                }
                
                try {
                    insert signatoryPartyOveride;
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            } else {
                if (email != '') {
                    signatoryPartyOveridesList.get(0).Preferred_Email__c = email;
                }
                if (mobile != '') {
                    signatoryPartyOveridesList.get(0).Preferred_Mobile__c = mobile;
                }
                if (method != '') {
                    signatoryPartyOveridesList.get(0).Preferred_Method__c = method;
                }
                try {
                    update signatoryPartyOveridesList.get(0);
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            }
        }
        
        Document__c doc = new DocumentsSelector().selectById(documentId);        
        String documentType = doc.Type__c;
        String documentName = doc.Name;
        List<Map<String,Object>> listTotal = new List<Map<String,Object>>();
        List<JSON2ApexSignatories> signatoryList = JSON2ApexSignatories.parse(signatoriesInput);
        if (!signatoryList.isEmpty() && signatoryList != null && signatoryList.size() > 0) {           
            Integer ii = 0;
            for (JSON2ApexSignatories signatoryParty: signatoryList) {
                Map<String,String> mapObj = new Map<String,String>();
                mapObj.put('Id', signatoryList.get(ii).Id);
                mapObj.put('Title', signatoryList.get(ii).Title);
                mapObj.put('Last_Name', signatoryList.get(ii).Last_Name);
                if(signatoryId == signatoryList.get(ii).Id && mobile != signatoryList.get(ii).Mobile_Phone && mobile != '') {                    
                    //Verify mobile number format is compatible with Impression format.
                    if (mobile.length() == 10) {
                        mobile = '+27' + mobile.substring(1, 10);
                        mapObj.put('Mobile_Phone', mobile);
                    }
                } else {
                    mapObj.put('Mobile_Phone', signatoryList.get(ii).Mobile_Phone);
                }
                
                if(signatoryId == signatoryList.get(ii).Id && email != signatoryList.get(ii).Email && email != '') {
                    mapObj.put('Email', email);
                } else {
                    mapObj.put('Email', signatoryList.get(ii).Email);
                }
                mapObj.put('Order', signatoryList.get(ii).Order);
                mapObj.put('Role', signatoryList.get(ii).Role);
                if(signatoryId == signatoryList.get(ii).Id && method != signatoryList.get(ii).Method && method != '') {
                    mapObj.put('Method', method);
                } else {
                    mapObj.put('Method', signatoryList.get(ii).Method);
                }
                mapObj.put('Document_Name', documentName);
                mapObj.put('Document_Type', documentType);
                listTotal.add(mapObj);
                ii += 1;
            }
        }
        return listTotal;
    }
    
    /**
* @author Vladimir Panajic
* Method that indicates if the document is restricted for digital signature (either In Progress, Signed or not eligible)
*
* @param opportunityId
* @param documentId
* @return restricted
*/
    @AuraEnabled
    public static boolean documentRestricted(Id opportunityId, Id documentId) {
        boolean restricted = false;
        List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(opportunityId, documentId, 'In Progress');
        if (!impressionRequests.isEmpty() && impressionRequests != null && impressionRequests.size() > 0) {
            restricted = true;
        }
        List<ImpressionRequest__c> impressionRequests2 = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(opportunityId, documentId, 'Signed');
        if (!impressionRequests2.isEmpty() && impressionRequests2 != null && impressionRequests2.size() > 0) {
            restricted = true;
        }
        Document__c doc = new DocumentsSelector().selectById(documentId);
        if (doc.Document_Status__c == 'Signed Manually' || doc.Document_Status__c == 'Signed Digitally') {
            restricted = true;
        }
        return restricted;
    }
    
    /**
* Method that checks if the casa screening has been done on init
*
* @param oppId - opportunity Id
* @return String - casa status i.e. valid, invalid etc.
*/
    @AuraEnabled
    public static String checkCASAValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        
        return opportunities.get(0).CASA_Status__c;
        //return 'Valid';
    }
    
    
    @AuraEnabled
    public static String getUserRole(Id oppId) {
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if(opportunities[0].OwnerId == UserInfo.getUserId()){
            //Is Adviser
            return 'Adviser';
        }else{
            List<OpportunityTeamMember> oppMemberList = [SELECT Advisor__c, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId 
                                                         FROM OpportunityTeamMember 
                                                         WHERE OpportunityId =: oppId];
            Boolean isAssistant = false;
            
            for(OpportunityTeamMember oppMember : oppMemberList){
                if(oppMember.UserId == UserInfo.getUserId()){
                    if(oppMember.TeamMemberRole == 'Assistant'){
                        isAssistant = true;
                    }
                }
            }
            if(isAssistant){
                //Is Assistant
                return 'Assistant';
            }else{
                //Not Access
                return 'No Access';
            }
        }
    }
}