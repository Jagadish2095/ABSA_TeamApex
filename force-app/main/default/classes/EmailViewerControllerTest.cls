@isTest
public class EmailViewerControllerTest {
    
    public static testMethod void testEmailviewer(){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id retailSalesLead = rtInfo.get('Retail_Sales_Lead').getRecordTypeId();
        
        Lead lead = new Lead();
        lead.FirstName = 'Test';
        lead.LastName = 'Test';
        lead.RecordTypeId = retailSalesLead;
        insert lead;
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = false;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.Lead__c = lead.Id; 
        insert email;
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        String[] dIds = new List<String>();
        for(ContentDocument d : documents){
            dIds.add(d.id);
        }
        
        Test.startTest();
        
        EmailViewerController.fetchEmailBody(email.Id);
        EmailViewerController.fetchEmailDetails(email.Id);
        EmailViewerController.fetchNewEmailDetails(lead.Id);
        EmailViewerController.getData(lead.Id);
        EmailViewerController.getDataAtt(lead.Id);
        EmailViewerController.sendMailMethod(email.ToAddress, email.FromAddress, email.Subject, email.HtmlBody, lead.Id, dIds);
        
        Test.stopTest();
    }
}