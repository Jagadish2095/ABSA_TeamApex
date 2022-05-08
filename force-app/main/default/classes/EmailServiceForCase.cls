/**
 * @description Class is created to handle incoming Emails
 * CLient Review & Client Maturity
 * */
global class EmailServiceForCase implements Messaging.InboundEmailHandler {
	/**
	 * @description handleInboundEmail to parse the incoming Email
	 * @param email
	 * @param envelope
	 * @return Messaging.InboundEmailResult
	 * */
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String threadId = 'ref:' + EmailThreadId.getThreadId(email) + ':ref';
        
		if (threadId != null && !Test.isRunningTest()) {
           
			Id recordId = Cases.getCaseIdFromEmailThreadId(threadId);
			EmailCreateCase.createEmailMessage(email, envelope, recordId, 'case');		
            
		}

		result.success = true;
		return result;
	}
}