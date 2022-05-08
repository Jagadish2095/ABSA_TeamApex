/**
 * @description       : 
 * @author            : deepthi.narayanappa@absa.africa
 * @last modified on  : 2021-09-27
 * @last modified by  : deepthi.narayanappa@absa.africa
**/
@isTest
public class EmailServiceForCaseTest {
	@isTest
	static void myEmailTest() {
		Case caseObj = new Case(Subject = 'Test', Status = 'New');
		insert caseObj;

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		/*String threadId = 'ref:' + EmailThreadId.getThreadId(email) + ':ref';
		Id recordId = Cases.getCaseIdFromEmailThreadId(threadId);*/
		email.subject = 'TestSubject';
		email.fromName = 'test test';
		email.plainTextBody = 'Hello, this a test email body. for testing purposes only';
		Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];
		Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
		binaryAttachment.Filename = 'test.txt';
		String algorithmName = 'HMacSHA1';
		Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'), Blob.valueOf('test_key'));
		binaryAttachment.Body = b;
		binaryAttachments[0] = binaryAttachment;
		email.binaryAttachments = binaryAttachments;
		envelope.fromAddress = 'user@absa.com';

		EmailServiceForCase catcher = new EmailServiceForCase();
		Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
		//EmailCreateCase ccc= NEW EmailCreateCase();
		//EmailCreateCase.createEmailMessage(email, envelope, recordId, 'case');
		System.assertEquals(result.success, true);
	}
}