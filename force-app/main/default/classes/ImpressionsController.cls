/**
 *@description A controller for generic Impressions operations.
 *
 * @author Masimba Chingwende
 */
public class ImpressionsController {
	
	/**
	 *@description Sends a base64 encoded pdf document for signing by specified signatories.
	 * @param signatories The signatories to sign this document.
	 * @param documentId The Id of the document in the Document__c object.
	 * @return String
	 */
	@AuraEnabled
	public static String sendForSigningById(List<Impressions_Model.Signatory> signatories, String documentId) {
		String document = DocumentController.getDocumentContent(documentId);
		String wfid = signatories.size() > 1 ? sendForSigning(signatories, document, documentId) : sendForSigning(signatories, document, documentId);
		return wfid;
	}
	/**
	@AuraEnabled
	public static String sendForSigningById(List<Impressions_Model.SignatoryWrapper> signatories, String documentId) {
        String document = DocumentController.getDocumentContent(documentId);
		String wfid = signatories.size() > 1 ? sendForSigning(signatories, document, documentId) : sendForSigning(signatories, document, documentId);
        return wfid;
	} **/
	
	/**
	 *@description Send for Signature
	 * @param signatories The signatories to sign this document.
	 * @param document
	 * @param documentId The Id of the document in the Document__c object.
	 * @return String
	 */
	@AuraEnabled
	public static String sendForSigning(List<Impressions_Model.SignatoryWrapper> signatories, String document, Id documentId) {
		Document__c doc = new DocumentsSelector().selectById(documentId);
		Impressions_Model.CreatePDFSignatureRequestEventInput request = null;
		Impressions_Model.CreatePDFSignatureRequestEventOutput response = null;
		Impressions_IH_v1 api = new Impressions_IH_v1();
		List<String> requests = new List<String>();
		List<Impressions_Model.Signatory> sigs = new List<Impressions_Model.Signatory>();
		for (Impressions_Model.SignatoryWrapper sig : signatories) {
			 request = new Impressions_Model.CreatePDFSignatureRequestEventInput ();
	         request.title = sig.signatory.title;
	         request.surname = sig.signatory.surname;
	         request.sender = 'Impression';
	         request.docName = doc.Name;
	         request.docType = 'application/pdf';
	         request.email = sig.signatory.email;
	         request.silent = false;
	         request.emailNotifications = 'ALWAYS';
	         request.schedule = 'WORKFLOW';
	         request.disableWebSigning = false;
	         request.mobile = sig.signatory.mobile;
	         request.language = 'en';
	         request.custom = sig.signatory.custom;
	         request.doc = document;
	         response = api.createPDFSignatureRequestEvent(request);
	         requests.add(response.requestId);
	         sigs.add(sig.signatory);
		}
		//now create workflow
		Impressions_Model.CreateSignatureWorkflowInput workflow = new Impressions_Model.CreateSignatureWorkflowInput ();
	    workflow.stepCount = requests.size();
	    List<Impressions_Model.CreateSignatureWorkflowInputStep> steps = new List<Impressions_Model.CreateSignatureWorkflowInputStep>();
	    for (Integer i = 0; i < requests.size(); i++) {
	    	Impressions_Model.CreateSignatureWorkflowInputStep step = new Impressions_Model.CreateSignatureWorkflowInputStep ();
	    	step.id = i;
	    	step.condition = 'ALL';
	    	step.requestIDList = new List<String> {requests.get(i)};
	    	steps.add(step); 
	    }
        workflow.steps = steps;
        Impressions_Model.CreateSignatureWorkflowOutput wo = api.createSignatureWorkflow( workflow );
        createImpressionRequest(wo.workflowID, documentId, doc.Opportunity__c, requests, sigs);
        String link;
        if (!test.isRunningTest()) {
            link = api.getViewLink(requests.get(0));        
        } else {
            link = 'test link';
        }
        Map<String, String> ctx = new Map<String, String>();
        ctx.put('link', link);
        ctx.put('fullname', sigs.get(0).title + ' ' + sigs.get(0).surname);
        ctx.put('documentType', doc.Type__c);
        if (sigs.get(0).email != null && sigs.get(0).email != '') {
            ImpressionsWorkflow.start(sigs.get(0).email, ctx);
        }
        
        return wo.workflowID;
    } 
	
	/**
	 * @description Sends a base64 encoded pdf document for signing by specified signatories.
	 * @param signatories The signatories to sign this document.
	 * @param document A base64 encoded document.
	 * @param documentId
	 * @return String
	 */
	@AuraEnabled
	public static String sendForSigning(List<Impressions_Model.Signatory> signatories, String document, Id documentId) {
        Document__c doc = new DocumentsSelector().selectById(documentId);
		Impressions_Model.CreatePDFSignatureRequestEventInput request = null;
		Impressions_Model.CreatePDFSignatureRequestEventOutput response = null;
		Impressions_IH_v1 api = new Impressions_IH_v1();
		List<String> requests = new List<String>();
		for (Impressions_Model.Signatory sig : signatories) {
			 request = new Impressions_Model.CreatePDFSignatureRequestEventInput ();
	         request.title = sig.title;
	         request.surname = sig.surname;
	         request.sender = 'Impression';
	         request.docName = doc.Name;
	         request.docType = 'application/pdf';
	         request.email = sig.email;
	         request.silent = false;
	         request.emailNotifications = 'ALWAYS';
	         request.schedule = 'WORKFLOW';
	         request.disableWebSigning = false;
	         request.mobile = sig.mobile;
	         request.language = 'en';
	         request.custom = sig.custom;
	         request.doc = document;
	         response = api.createPDFSignatureRequestEvent(request);
			 //if (!test.isRunningTest()) {
			 	requests.add(response.requestId);
			// }
		}
		//now create workflow
		Impressions_Model.CreateSignatureWorkflowInput workflow = new Impressions_Model.CreateSignatureWorkflowInput ();
	    workflow.stepCount = requests.size();
	    List<Impressions_Model.CreateSignatureWorkflowInputStep> steps = new List<Impressions_Model.CreateSignatureWorkflowInputStep>();
	    for (Integer i = 0; i < requests.size(); i++) {
	    	Impressions_Model.CreateSignatureWorkflowInputStep step = new Impressions_Model.CreateSignatureWorkflowInputStep ();
	    	step.id = i;
	    	step.condition = 'ALL';
	    	step.requestIDList = new List<String> {requests.get(i)};
	    	steps.add(step); 
	    }
	    workflow.steps = steps;
	    Impressions_Model.CreateSignatureWorkflowOutput wo = api.createSignatureWorkflow( workflow ); 
		//if (!test.isRunningTest()) {       
			createImpressionRequest(wo.workflowID, documentId, doc.Opportunity__c, requests, signatories);
			ImpressionsWorkflow.start(wo.workflowID);
		//}
		ImpressionsWorkflow.start(wo.workflowID);
	    return wo.workflowID;		
	}
	
	
	/**
	 * @description Refesh workflow
	 * @param workflowId
	 */
	@AuraEnabled
	public static void refreshWorkflow(String workflowId) {
		ImpressionsWorkflow.refresh(workflowId);		
	}
    
/* does not seem to be used anywhere Tinashe SHoko
     @AuraEnabled
    public static String sendForSigning2(List<Impressions_Model.Signatory> signatories, String document, Id documentId) {
        Document__c doc = new DocumentsSelector().selectById(documentId); //Vladimir - to get the request.docName
        System.debug('doc id  ' + doc.id);
        Impressions_Model.CreateInlinePDFSignatureRequestEventInput request = new Impressions_Model.CreateInlinePDFSignatureRequestEventInput ();
        request.stepCount = signatories.size();
        request.sender = 'Salesforce F2F';
        request.returnEmail = 'no-reply@absa.co.za';
        request.docName = doc.Name;
        request.docType = 'application/pdf';
        request.signatories = signatories;
        request.doc = document;
        system.debug('related request is ' + request);
        Impressions_Model.CreateInlinePDFSignatureRequestEventOutput wo = new Impressions_IH_v1().createInlineSignatureWorkflow( request );
        String[] requests = new String[] {};
        if (wo.requests != null) {
        	for (Impressions_Model.SignatureRequest req : wo.requests) {
        		requests.add(req.id);
        	}
        }
        createImpressionRequest(wo.workflowID, documentId, doc.Opportunity__c, requests, signatories);
        return wo.workflowID;
    }
    */

	/**
	 * @description Create Impression request
	 * @param workflowId
	 * @param documentId
	 * @param opportunityId
	 * @param signatureRequests
	 * @param signatories
	 */
    public static void createImpressionRequest(String workflowId, String documentId, String opportunityId, String[] signatureRequests, List<Impressions_Model.Signatory> signatories) {
       	ImpressionRequest__c ir = new ImpressionRequest__c();
        ir.requestID__c = workflowId;
        ir.docId__c = documentId;
        ir.Document__c = documentId;
        ir.completed__c = false;
        List<SignatureRequest__c> listOfNewRecords = new List<SignatureRequest__c>();
        for (integer i = 0; i < signatureRequests.size(); i++) {
	        SignatureRequest__c s = new SignatureRequest__c();
	        s.signatureId__c = signatureRequests.get(i);
	        s.impressionRequestID__C = ir.requestID__c;
	        s.Title__c = signatories.get(i).title;
	        s.Fullname__c = signatories.get(i).surname;
	        s.Email__c = signatories.get(i).email;
	        s.Mobile__c = signatories.get(i).mobile;
	        s.Method__c = 'Deferred';
	        s.Step__c = i + 1;
	        listOfNewRecords.add(s);
        }
        insert ir;
        insert listOfNewRecords;
    }
    
	/**
	 * @description Update Impression request
	 * @param opportunityId
	 */
    public static void updateImpressionRequests(Id opportunityId) {
    	List<Document__c> signedDocs = new List<Document__c>();
		Map<String, List<SignatureRequest__c>> impressionMap = new Map<String, List<SignatureRequest__c>>();
		Map<String, String> impressionDocMap = new Map<String, String>();
    	List<ImpressionRequest__c> impressionRequests = [SELECT Id, RequestId__c, completed__c, Opportunity__c, Document__c FROM ImpressionRequest__c WHERE Opportunity__c = :opportunityId AND completed__c = false];
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));    	
    	
		//Add Req Id to set
		Set<String> reqIdSet = new Set<String>();
		for(ImpressionRequest__c req : impressionRequests) {
			reqIdSet.add(req.RequestId__c);
		}
		List<SignatureRequest__c> sigsAll = [SELECT Id, SignatureID__c, ImpressionRequestID__c, Name FROM SignatureRequest__c WHERE ImpressionRequestID__c IN :reqIdSet ORDER BY Name DESC];
    	for(SignatureRequest__c eachSig : sigsAll) {
			if(!impressionMap.containsKey(eachSig.ImpressionRequestID__c)) {
				impressionMap.put(eachSig.ImpressionRequestID__c, new List<SignatureRequest__c>{eachSig});
			} else {
				impressionMap.get(eachSig.ImpressionRequestID__c).add(eachSig);
			}
			
		}
		
		for (ImpressionRequest__c req : impressionRequests) {
    		List<SignatureRequest__c> sigs = impressionMap.get(req.RequestId__c);
    		//Impressions_Model.SignatureAuditOutput sao = new Impressions_IH_v1().getSignatureAuditTrailByWorkflowId (String workflowId);
    		for (SignatureRequest__c sig : sigs) {
                Impressions_Model.SignatureAuditDocOutput sado = new Impressions_Model.SignatureAuditDocOutput();
				Boolean flagAsRejected = false;
                if (test.isRunningTest()) {
                    sado.doc = new Impressions_Model.Doc();
                    sado.doc.data = 'COMPLETED';
                } else {
                	sado = new Impressions_IH_v1().getSignatureAuditTrailAndDocumentByRequestId (sig.SignatureID__c);
                }

				List<Impressions_Model.AuditItem> impressionItem = new List<Impressions_Model.AuditItem>();
                if(sado != null) {
                    impressionItem = sado.items;
                    if(impressionItem != null) {
                        for(Impressions_Model.AuditItem eachItem : impressionItem) {
                            if(eachItem.EventStatus.contains('REJECTED')) {
                                flagAsRejected = true;
                                break;
                            }
                    	}
                    }
                }
				
                if (!String.isBlank(sado.doc.data)) {
    				Document__c old = new DocumentsSelector().selectById(req.Document__c);
    				Document__c signed = old.clone();
    				signed.Name = ('Signed_' + old.Name).left(80);
    				//now insert this into ECM
                    if (!test.isRunningTest()) {
                        ECM_GetResult_IB_V1 source = ECM_IH_V1.getDocument(login.token, old.Reference__c);
                        ECM_AddRequest_IB_V1 addReq = new ECM_AddRequest_IB_V1().fromGetResult(source);
                        addReq.AddRequest.Token = login.Token;
                        addReq.AddRequest.FileName = 'Signed_' + old.Name;
                        addReq.AddRequest.Data = sado.doc.data;
                        ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(addReq);
                        signed.Reference__c = addResult.PID;
                    }
                    signed.Document_Status__c = 'Signed'; //vladimir
                    signed.Parent_Document__c = req.Document__c; //vladimir
					if(flagAsRejected == true) {
                        signed.Document_Status__c = 'Rejected'; 
                    }
                    if (signed.Reference__c != null) { // there seems to be an issue with 5122 and its breaking here
                        signedDocs.add(signed);
                        req.completed__c = true;
						impressionDocMap.put(req.id, signed.Reference__c);
                    }
    			}
    			break;
    		}
    		
    	}

		Map<String, String> docRefId = new Map<String, String>();
    	try {
			insert signedDocs;
			for(Document__c eachDoc : signedDocs) {
                docRefId.put(eachDoc.Reference__c, eachDoc.Id);
            }
		} catch(DMLException ex){
			throw new AuraHandledException(ex.getMessage());
		} catch(Exception ex){
			//throw all other exception message
			throw new AuraHandledException(ex.getMessage());
		}
        
        if (impressionRequests != null) {
            try {
                update impressionRequests;

				if(docRefId != null && docRefId.size() > 0) {
				try {
					List<ImpressionRequest__c> updateImpressionReq = new List<ImpressionRequest__c>();
					for(ImpressionRequest__c eachImpression : impressionRequests) {
						ImpressionRequest__c eachReq = new ImpressionRequest__c();
						String docRef = impressionDocMap.get(eachImpression.id);
						eachReq = eachImpression;
						eachReq.Document__c = docRefId.get(docRef);
						updateImpressionReq.add(eachReq);
					}
					if(updateImpressionReq != null && updateImpressionReq.size() > 0) {
						update updateImpressionReq;
					}
            } catch(DMLException ex){
                throw new AuraHandledException(ex.getMessage());
            } 
		}
			
		}catch(Exception ex){
                //throw all other exception message
                throw new AuraHandledException(ex.getMessage());
            }
        } 
    }
    
	/**
	 * @description Track the impression request with signatories
	 * @param wfid
	 * @return String
	 */
    @AuraEnabled
    public static String track(String wfid) {
    	ImpressionRequest__c req = [SELECT Id, RequestId__c, completed__c, Opportunity__c, Document__c FROM ImpressionRequest__c WHERE Id = :wfid];
    	Document__c doc = new DocumentsSelector().selectById(req.Document__c);
    	Impressions_Model.WorkflowAuditOutput wfo  = new Impressions_IH_v1().getSignatureAuditTrailByWorkflowId (req.RequestId__c);
    	wfo.items.sort();
    	wfo.filename = doc.Name;

		Map<String, SignatureRequest__c> signatureReqMap = new Map<String, SignatureRequest__c>();
		Set<String> impressionItems = new Set<String>();
		for (Impressions_Model.WorkflowAuditOutputItem item : wfo.items) {
			impressionItems.add(item.SignatureRequestID);
		}
		for(SignatureRequest__c eachSig : [SELECT Id, Name, SignatureID__c, Fullname__c, Title__c, Method__c FROM SignatureRequest__c WHERE SignatureID__c IN :impressionItems]) {
			signatureReqMap.put(eachSig.SignatureID__c, eachSig);
		}

    	//now retrieve detailed audit trail
    	for (Impressions_Model.WorkflowAuditOutputItem item : wfo.items) {
    		Impressions_Model.SignatureAuditOutput sao = new Impressions_IH_v1().getSignatureAuditTrailByRequestId (item.SignatureRequestID);
    		//get additional details from SFDC
    		SignatureRequest__c sr = signatureReqMap.get(item.SignatureRequestID);
    		item.fullname = sr.Title__c + sr.Fullname__c;
            item.auditItems = sao.items;
    		item.method = sr.Method__c;
    	}
    	return JSON.serialize(wfo);
    }
    
    /**
     * @description Downloads document as signed by the signatory designated for this
     * signature request
     * @param requestId The signature request id
	 * @return String
     **/
    @AuraEnabled
    public static String downloadDocument(String requestId) {
		Impressions_Model.SignatureAuditDocOutput sado = new Impressions_IH_v1().getSignatureAuditTrailAndDocumentByRequestId (requestId);
		if (!String.isBlank(sado.doc.data)) {
			return sado.doc.data;
		}	
		throw new AuraException('Error downloading document or document missing');	
    }
    
	 /**
     * @description Send Reminder
     * @param requestId The signature request id
     **/
    @AuraEnabled
    public static void sendReminder(String requestId) {
        SignatureRequest__c req = [SELECT Id, impressionRequestID__C, signatureId__c, Title__c, Fullname__c, Email__c FROM SignatureRequest__c WHERE signatureId__c = :requestId LIMIT 1];
        String link;
        if (!test.isRunningTest()) {
            link = new Impressions_IH_v1().getViewLink(requestId); 
        } else{
            link = 'test';
        }
		Map<String, String> ctx = new Map<String, String>();
		ctx.put('link', link);
		ctx.put('fullname', req.Title__c + ' ' + req.Fullname__c);
		ctx.put('documentType', 'Record of Advice');
        if (!test.isRunningTest()) {
            ImpressionsWorkflow.start(req.Email__c, ctx);
        }
    }
    
	/**
     * @description Sign Now
     * @param requestId The signature request id
     **/
    @AuraEnabled
    public static void signNow(String requestId) {
        new Impressions_IH_v1().createAuthenticationIntent(requestId); 
    }
    
	/**
     * @description Track
     * @param wfid
	 * @return String
     **/
    @AuraEnabled
    public static String track2(String wfid) {
    	String result = track(wfid);
    	String oppId = new ImpressionRequestsSelector().selectById(wfid).Opportunity__c;
        ImpressionsController.updateImpressionRequests(oppId);
		//ImpressionsWorkflow.refresh(workflowId);
    	return result;
    }
    
	/**
     * @description Impression details response
     **/
    class ImpressionDetailResponse {
		/**
     * @description File name
     **/
    	public String filename { get; set; }
		/**
     * @description List of steps
     **/
    	public List<Impressions_Model.SignatoryWrapper> listOfSteps { get; set; }
    }
	
}