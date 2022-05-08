/**
*@description this is test class used for Impressions_Model_Test
*Apex Class Impressions_Model_Test
* @author  
* @version v1.0
* @since   
*
*/
@isTest
public class Impressions_Model_Test {
     /** 
    * @description  
    */
    @isTest public static void testAll() {
        test.startTest();
        Impressions_Model im = new Impressions_Model();
        Impressions_Model.CreatePDFSignatureRequestEventInput request = new Impressions_Model.CreatePDFSignatureRequestEventInput ();
	         request.title = 'sig.signatory.title';
	         request.surname = 'sig.signatory.surname';
	         request.sender = 'Salesforce';
	         request.docName =' doc.Name';
	         request.docType = 'application/pdf';
	         request.email = 'sig.signatory.email';
	         request.silent = true;
	         request.emailNotifications = 'ALWAYS';
	         request.schedule = 'WORKFLOW';
	         request.disableWebSigning = false;
	         request.mobile = 'sig.signatory.mobile';
	         request.language = 'en';
	         //request.custom = sig.signatory.custom;
	         request.doc = 'document';
        request.getExample();
        
        Impressions_Model.CreatePDFSignatureRequestEventOutput im2 = new Impressions_Model.CreatePDFSignatureRequestEventOutput();
        im2.status='Status';
        im2.message = 'Message';
        im2.requestID = 'requst ID';
        im2.getExample();
        
        Impressions_Model.CreateInlinePDFSignatureRequestEventInput im3 = new Impressions_Model.CreateInlinePDFSignatureRequestEventInput();
        im3.deadline='deadlone';
        im3.doc='doc';
        im3.docName='doc name';
        im3.docType='doc type';
        im3.regTemplate='template';
        im3.returnEmail='return email';
        im3.sender='sender';
        im3.signType='sign type';
        im3.getExample();
        
        Impressions_Model.CreateInlinePDFSignatureRequestEventOutput im4 = new Impressions_Model.CreateInlinePDFSignatureRequestEventOutput();
        //im4.requests='requests';
        im4.status='Statis';
        im4.workflowID='wfid';
        im4.getExample();
        
        Impressions_Model.SignatureRequest im5 = new Impressions_Model.SignatureRequest();
        im5.email='email';
        im5.id='id';
        
        Impressions_Model.EmailTemplatePUTInput im6 = new Impressions_Model.EmailTemplatePUTInput();
        im6.name='name';
        im6.template='template';
        im6.getExample();
        
        Impressions_Model.EmailTemplateOutput im7 = new Impressions_Model.EmailTemplateOutput();
        im7.message='msg';
        im7.status='status';
        im7.getExample();
        
        Impressions_Model.RemoveDocOutput im8 = new Impressions_Model.RemoveDocOutput();
        im8.message='ms';
        im8.status='status';
        im8.getExample();
        
        Impressions_Model.CreateSignatureWorkflowInputStep im9 = new Impressions_Model.CreateSignatureWorkflowInputStep();
        im9.condition='conditions';
        im9.id=1;
        im9.getExample();
        
        Impressions_Model.CreateSignatureWorkflowInput im10 = new Impressions_Model.CreateSignatureWorkflowInput();
        im10.batchCount=1;
        im10.emailNotifications='string';
        im10.stepCount=1;
        im10.getExample();
        
        Impressions_Model.CreateSignatureWorkflowOutput im11 = new Impressions_Model.CreateSignatureWorkflowOutput();
        im11.reason='ssds';
        im11.status='Status';
        im11.workflowID='wfid';
        im11.getExample();
        
        Impressions_Model.AuthenticationIntentOutput im12 = new Impressions_Model.AuthenticationIntentOutput();
        im12.status='status';
        im12.getExample();
        
        Impressions_Model.AuthenticationStatusOutput im13 = new Impressions_Model.AuthenticationStatusOutput();
        im13.intentApplied=true;
        im13.intentStatus='strug';
        im13.getExample();
        
        Impressions_Model.SMSNotifyAuthenticationIntentInput im14 = new Impressions_Model.SMSNotifyAuthenticationIntentInput();
        im14.message='msg';
        im14.getExample();
        
        Impressions_Model.SMSNotifyAuthenticationIntentOutput im15 = new Impressions_Model.SMSNotifyAuthenticationIntentOutput();
        im15.message='msg';
        im15.status='side';
        im15.txID='txid';
        im15.getExample();
        
        Impressions_Model.SigningDeferredInput im16 = new Impressions_Model.SigningDeferredInput();
        im16.addLtv=true;
        im16.getExample();
        
        Impressions_Model.SigningDeferredOutput im17 = new Impressions_Model.SigningDeferredOutput();
        im17.reason='reason';
        im17.status='status';
        im17.getExample();
        
        Impressions_Model.SignatureAuditDocOutput im18 = new Impressions_Model.SignatureAuditDocOutput();
        im18.requestID='strug';
        im18.getExample();
        
        Impressions_Model.SignatureAuditOutput im19 = new Impressions_Model.SignatureAuditOutput();
        im19.count=1;
        im19.requestID='string';
        im19.getExample();
        
        Impressions_Model.RulesOutput im20 = new Impressions_Model.RulesOutput();
        im20.sigCount=1;
        im20.getExample();
        
        Impressions_Model.Signatory im21 = new Impressions_Model.Signatory();
       im21.emailBody='body';
        im21.email='email';
        im21.mobile='mobile';
        
        Impressions_Model.Signatory im22 = new Impressions_Model.Signatory();
         im22.email='strug';
        im22.emailBody='body';
        im22.mobile='free';
        im22.surname='name';
        im22.title='title';
        
        Impressions_Model.AuditItem im23 = new Impressions_Model.AuditItem();
        im23.EventStatus='dara';
        im23.LastUpdated='last';
        
        Impressions_Model.Doc im24 = new Impressions_Model.Doc();
        im24.data='data';
        im24.status='status';
                
        Impressions_Model.SignatoryWrapper is = new Impressions_Model.SignatoryWrapper();
        is.email='free';
        is.index=1;
        is.method='method';
        is.mobile='mobile';
        is.next=true;
        is.requestId='string';
        is.signedStatus='status';
        is.surname='surname';
        is.title='tiele';
        
        Impressions_Model.AnonymousTokenResponse ima = new Impressions_Model.AnonymousTokenResponse();
        ima.message='msg';
        ima.status='status';
        ima.token='token';
        ima.username='usernMe';
        ima.viewerpath='viewpath';
        
        Impressions_Model.WorkflowAuditOutputItem imw = new Impressions_Model.WorkflowAuditOutputItem();
        imw.EventStatus='evenstatis';
        imw.fullname='fullanme';
        imw.LastUpdated='last updated';
        imw.method ='methode';
        imw.SignatureRequestID='sig req';
        imw.Step=1;
        System.assertNotEquals(null, imw);
        test.stopTest();
    }
}