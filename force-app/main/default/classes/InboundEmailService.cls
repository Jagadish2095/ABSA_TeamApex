/**
 * @description : The custome email for the call center.
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2018-06-14
 *
 * Code Review : 2018-08-13 - Rudolf Niehaus
 */

global class InboundEmailService implements Messaging.InboundEmailHandler {
	/**
     @description CustomException description
     @param email (InboundEmail)  : email
     @param envelope (InboundEnvelope)  : envelope
     @return Return String : Return result
    */

	public class CustomException extends Exception {
	}
	/**
	 * @description handleInboundEmail description
	 *
	 * @param email (Messaging.InboundEmail): email
	 * @param envelope (Messaging.InboundEnvelope): envelope
	 * @return Return Messaging.InboundEmailResult: Return description
	 */
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		System.debug(LoggingLevel.FINE, 'InboundEmailService Running');
		System.debug(LoggingLevel.FINE, '-------------------------------------------------');
		System.debug(LoggingLevel.FINE, 'Headers : ' + email.headers);
		System.debug(LoggingLevel.FINE, 'From Address : ' + email.fromAddress);
		System.debug(LoggingLevel.FINE, 'From Name : ' + email.fromName);
		System.debug(LoggingLevel.FINE, 'To Addresses : ' + email.toAddresses);
		System.debug(LoggingLevel.FINE, 'CC Addresses : ' + email.ccAddresses);
		System.debug(LoggingLevel.FINE, '-------------------------------------------------');

		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

		String threadId = null;
		String externalReferenceNumber = null;
		String caseNumber = null;
		Id caseId = null;

		//Variable to carry all email addresses copied
		Set<String> copiedAdresses = new Set<String>();
		if (email.toAddresses != null) {
			copiedAdresses.addAll(email.toAddresses);
		}
		if (email.ccAddresses != null) {
			copiedAdresses.addAll(email.ccAddresses);
		}

		//Call method to extract the Thread Id from the Email Subject/Body
		threadId = EmailThreadId.getThreadId(email);

		//Call method to extract the External Reference Number from the Email Subject/Body
		externalReferenceNumber = EmailExternalReferenceNo.getExternalReferenceNo(email);
		if (!Test.isRunningTest()){
			string dummyaddres=email.toAddresses[0].split('@')[0];
        	system.debug('dummyaddres '+dummyaddres);
			//Call method to extract the Case Number from the Email Subject/Body
			if (dummyaddres.contains('atkv') || dummyaddres.contains('eInfo') 
			|| dummyaddres.contains('eRetentionSTI') || dummyaddres.contains('eNewBusiness')
			|| dummyaddres.contains('eComplaints') || dummyaddres.contains('Eteleadvisti')
			|| dummyaddres.contains('WimiDDReferralSTI') || dummyaddres.contains('WIMIDD.Shortterm')){
            System.debug('Came here for STI');
			caseNumber = EmailExternalReferenceNo.getCaseNumber(email);
		}
	}

		//Call method to get

		boolean skipResponse = false;

		//Use std Case method to find the related case for the thread id
		//If the threadId belongs to a Case in a different or, the exception will
		//throw
		if (String.isNotBlank(threadId)) {
			try {
				Cases.getCaseIdFromEmailThreadId(threadId);
			} catch (Exception e) {
				email.subject = email.subject.replace('ref:' + threadId + ':ref', ' ');
				threadId = null;
				skipResponse = true;
			}
		}

		//Call method to avoid loops - if the From Email Address is one of the OWD Email Addresses
		if (String.isBlank(threadId)) {
			if (EmailRuleEngine.isSenderOrgWideEmailAddress(email.fromAddress)) {
				try {
					throw new CustomException('The Email sender used a restricted From email address : ' + email.fromAddress + ' - The Email was ignored');
				} catch (CustomException e) {
					return result;
				}
			}
		}

		// If we get an error, we need to rollback the whole process and disply friend message to users
		SavePoint sp = Database.setSavepoint();

		try {
			//Make instance of the rule engin data class
			EmailRuleEngine.RuleData ruleData = new EmailRuleEngine.RuleData();

			System.debug('###ruleData : ' + ruleData);

			if (String.isNotBlank(threadId)) {
				//return case id regardless of close status, unless its a service request case then
				//we only pass the Id back if the case us open, else we set the caseid of the closed
				//on the email class to be used on case creation. email class is passed in by referance
				caseId = EmailThreadId.findCaseByThreadId(threadId, false, email);
			}

			if (String.isNotBlank(externalReferenceNumber)) {
				System.debug('###externalReferenceNumber : ' + externalReferenceNumber);
				//return case id regardless of close status
				caseId = EmailExternalReferenceNo.findCaseByExternalReferenceNo(externalReferenceNumber, false);
			}

			if (String.isNotBlank(caseNumber)) {
				System.debug('###caseNumber : ' + caseNumber);
				//return case id regardless of close status
				caseId = EmailExternalReferenceNo.findCaseByCaseNo(caseNumber);
			}

			if (caseId == null) {
				/*if ( String.isNotBlank(externalReferenceNumber) ) {
                     System.debug('###externalReferenceNumber : ' + externalReferenceNumber);
                     //return case id regardless of close status
                     caseId = EmailExternalReferenceNo.findCaseByExternalReferenceNo(externalReferenceNumber, false);
                 }*/

				ruleData = EmailRuleEngine.findMatchingRule(email, skipResponse, 'Case');

				if (ruleData.hasMathingRule) {
					if (ruleData.ruleType == 'Routing_Rule' || ruleData.ruleType == 'Classify_Rule') {
						caseId = ruleData.caseId;
					}

					EmailRuleEngine.updateTriggerCount(ruleData.ruleId);
				} else {
					Database.rollback(sp);

					try {
						throw new CustomException(
							'No configuration and no default email rule found for the Shared Email address : ' +
							email.toAddresses +
							' : The Email was ignored'
						);
					} catch (CustomException e) {
						return result;
					}
				}
			}

			if (ruleData.ruleType != 'Blocking_Rule' && String.isNotBlank(caseId)) {
				System.debug('In not Blocking Rule : ' + caseId);

				EmailCreateCase.createEmailMessage(email, envelope, caseId, 'Case');

				//Koketso Mpshane: Check if prioritised emails are copied on incoming email
				if (copiedAdresses.size() > 0) {
					Id serviceGroupId;

					List<Shared_Email__c> prioritySharedEmails = new SharedEmailsSelector().selectByToAddressesAndPriorityWithEmailRules(copiedAdresses);

					system.debug('DEBUG_Email: prioritySharedEmails: ' + prioritySharedEmails);

					if (prioritySharedEmails.size() > 0) {
						Shared_Email__c sharedEmail = prioritySharedEmails[0];
						if (sharedEmail.Shared_Email_Rules__r.size() > 0) {
							Shared_Email_Rule__c sharedEmailRule = sharedEmail.Shared_Email_Rules__r[0];
							List<Email_Rule__c> emailRules = new EmailRulesSelector().selectSharedEmailDefaultWithRelatedInfo(sharedEmailRule.Email_Rule__c);
							if (emailRules.size() > 0) {
								serviceGroupId = emailRules[0].Route_To_Queue__c;
							}
						}
						system.debug('DEBUG_Email: serviceGroupId: ' + serviceGroupId);
						EmailCreateCase.prioritiseCaseToCopiedGroup(caseId, serviceGroupId, copiedAdresses);
					}
				}
			} else if (ruleData.ruleType == 'Blocking_Rule') {
				//RN - These are purged based on the retention period defined on the  after creation by a schduled batch process
				Boolean fOk = EmailCreateCase.createUnwantedEmailRecord(email, ruleData.retentionPeriod);

				if (!fOk) {
					//RN : TODO - Do something here?
					String notdo = 'OK';
				}
			}
		} catch (Exception e) {
			Database.rollback(sp);
			AuditTrailLog.logException(e, 'New', 'Error', 'InboundEmailService', 'handleInboundEmail', 'Exception on Inbound Email Case creation');
			result.message =
				'Your email to the ABSA Customer Support Center could not be processed due to a technical error.  ' +
				'Please wait a few minutes and resend the email.  ' +
				'Please accept our apologies for any inconvenience caused.';

			return result;
		}

		return result;
	}
}