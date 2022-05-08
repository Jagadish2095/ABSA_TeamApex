/**
* An class to encapsulate impression workflows.
*
*/
public class ImpressionsWorkflow {
    
    /**
* Starts a workflow given a list of signatories and
* the document to be signed.
*/
    @future
    public static void start(String workflowId) {
        
    }
    
    @future
    public static void start(String email, Map<String, String> context) {
        if (email != null && email != '' && context.keyset().size() > 0 && context.keyset() != null) {
            sendEmail(new String[] {email}, context);
        }
    }
    
    
    /**
* Resumes a workflow operation.
*/
    //@future
    public static void updateWf(String requestId, String doc) {
        //SignatureRequest__c req = [SELECT Id, impressionRequestID__C, signatureId__c, Processed__c FROM SignatureRequest__c WHERE signatureId__c = :requestId LIMIT 1];
        SignatureRequest__c req = new SignatureRequestSelector().selectbyRequestId(requestId);
        //ImpressionRequest__c workflow = [SELECT Id, RequestId__c, completed__c, Opportunity__c, Document__c FROM ImpressionRequest__c WHERE requestID__c = :req.impressionRequestID__C LIMIT 1];
        ImpressionRequest__c workflow = new ImpressionRequestsSelector().selectByRequestId(req.impressionRequestID__C);
        Document__c newDoc = cloneDocument(workflow.Document__c, doc);
        SignatureRequest__c next = getNext(requestId);
        if (next != null && next.Method__c == 'Deferred') {
            //send an email to this one
            String link;
            if (!test.isRunningTest()) {
                link = new Impressions_IH_v1().getViewLink(requestId);
            } else {
                link = 'test link';
            }
            Map<String, String> ctx = new Map<String, String>();
            ctx.put('link', link);
            ctx.put('fullname', next.Title__c + ' ' + next.Fullname__c);
            ctx.put('documentType', 'Record of Advice');
            sendEmail(new String[] {next.email__c}, ctx);
        }
        
        insert newDoc;
        workflow.Document__c = newDoc.Id;
        update workflow;
        req.Processed__c = true;
        update req;    	
    }
    
    /**
* Refreshes a given workflow synchronously taking into account
* updated signed documents. This algorithm only updates the @code{next} item.
*/
    @future
    public static void refresh(String wfId) {
        Impressions_Model.WorkflowAuditOutput wfo;
        if (!test.isRunningTest()) {
            wfo  = new Impressions_IH_v1().getSignatureAuditTrailByWorkflowId (wfId);
        } else {
            return;
        }
        wfo.items.sort();
        //navigate backwards to determine last updated item
        for ( Integer i = wfo.items.size() - 1; i >= 0; i--) {
            Impressions_Model.WorkflowAuditOutputItem item = wfo.items.get(i);
            if (item.EventStatus == 'COMPLETED') {
                //interesting event
                //SignatureRequest__c req = [SELECT Id, impressionRequestID__C, signatureId__c, Step__c, Processed__c FROM SignatureRequest__c WHERE signatureId__c = :item.SignatureRequestID LIMIT 1];
                SignatureRequest__c req = new SignatureRequestSelector().selectbyRequestId(item.SignatureRequestID);
                if (!req.Processed__c && (i == wfo.items.size() - 1)) { //we are only interested in the final document
                    Impressions_Model.SignatureAuditDocOutput sado = new Impressions_IH_v1().getSignatureAuditTrailAndDocumentByRequestId (item.SignatureRequestID);
                    if (!String.isBlank(sado.doc.data)) {
                        updateWf(item.SignatureRequestID, sado.doc.data);
                    }
                }
                
                break;
            }
        }
    }
    
    private static SignatureRequest__c getNext(String requestId) {
        //SignatureRequest__c req = [SELECT Id, impressionRequestID__C, signatureId__c, Step__c FROM SignatureRequest__c WHERE signatureId__c = :requestId LIMIT 1];
        SignatureRequest__c req = new SignatureRequestSelector().selectbyRequestId(requestId);
        return [SELECT Id, impressionRequestID__C, signatureId__c, Step__c, Method__c, Email__c, Mobile__c, Fullname__c, Title__c FROM SignatureRequest__c WHERE impressionRequestID__C = :req.impressionRequestID__C AND Step__c > :req.Step__c ORDER BY Step__c ASC LIMIT 1];
    }
    
    /**
* Clones an old @code{Document__c} with new content.
* This method should be moved to the @code{DocumentHandler}.
*/
    private static Document__c cloneDocument(Id oldId , String content) {
        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login;
        if (!test.isRunningTest()) {
            login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
        } else { 
            login = ECM_IH_V1.login('DGOLSDB', 'DEV_TestUser', 'D3vT#sting');
        }
        Document__c old = new DocumentsSelector().selectById(oldId);
        Document__c newDoc = old.clone();
        newDoc.Name = 'Signed_' + old.Name; //versioning of Document__c required
        //now insert this into ECM
        ECM_GetResult_IB_V1 source;
        if (!test.isRunningTest()) {
            source = ECM_IH_V1.getDocument(login.token, old.Reference__c);
        } else {
            source = ECM_GetResult_IB_V1.getExample();
        }
        ECM_AddRequest_IB_V1 addReq = new ECM_AddRequest_IB_V1().fromGetResult(source);
        if (!test.isRunningTest()) {
            addReq.AddRequest.Token = login.Token;
        } else {
            addReq.AddRequest.Token = 'Test Token'; //[Select Token__c from ImpressionToken__c LIMIT 1].Token__c;
            // now using a custom setting
                //'d2CyAwniCWSOJvqJSi+fhNoaYuBMPWLoyG9wetxzSJeeCdwEONWDCl1vygfQ1E9oHvg+9CKckSuI@!@!@!@r@!@!@!@nAJjCR7afQw==';
        }
        addReq.AddRequest.FileName = 'Signed_' + old.Name;
        addReq.AddRequest.Data = content;
        ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(addReq);
        newDoc.Reference__c = addResult.PID;
        newDoc.Document_Status__c = 'Signed'; //vladimir
        newDoc.Parent_Document__c = oldId; //vladimir
        newDoc.Reference__c = 'Reference test';
        return newDoc;
    }
    
    public static void sendEmail(String[] to, Map<String, String> context) {
        String templateName = 'ESignature_Template_Face_2_Face';
        EmailTemplate template = [SELECT Id, Name, htmlValue, DeveloperName, Subject FROM EmailTemplate WHERE DeveloperName =: templateName LIMIT 1];
        String body = template.htmlValue;
        for (String key : context.keySet()) {
            //this is a poor implementation which will fail if there are whitespaces
            if (context.get(key) != null){
                body = body.replace('#{' + key + '}', context.get(key));
            }
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[]{advisor.email};
        mail.setToAddresses(to);
        mail.setReplyTo('noreply@absa.co.za');
        mail.setSenderDisplayName('ABSA Face 2 Face');
        mail.setSubject(template.Subject);
        mail.setBccSender(false);
        mail.setUseSignature(false); 
        //mail.setPlainTextBody(template.Body); 
        mail.setHtmlBody(body);   
        //mail.setTargetObjectId(oppr.OwnerId);
        mail.setTemplateId(template.Id);
        mail.saveAsActivity = false;
        //Send email
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
}