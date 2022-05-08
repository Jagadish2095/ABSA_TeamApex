/**
* Test class for EmailTemplateRendererController class.
*
* @author  Peter Guest (CloudSmiths)
* @since   2020-06-18
*
**/
@IsTest(SeeAllData=false)
private class EmailTemplateRendererControllerTest {

    @testSetup
    private static void testData() {

        Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Absa Client Services';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        insert serviceGr;

        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();         
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = account);
        insert testCase;
    }

    @IsTest
    private static void testValidParameters() {

        Test.startTest();

        //Get an email template to test.
        Id templateId = [SELECT Id From EmailTemplate LIMIT 1].Id;

        //Get a sample case.
        Id caseId = [SELECT Id FROM Case LIMIT 1].Id;

        //Set VF page.
        PageReference pdfPage = Page.EmailTemplateRenderer; 
        Test.setCurrentPage(pdfPage);

        //Add page params.
        ApexPages.currentPage().getParameters().put('whatId', caseId);
        ApexPages.currentPage().getParameters().put('templateId', templateId);

        //Fire controller.
        EmailTemplateRendererController controller = new EmailTemplateRendererController();

        //Make sure we got html.
        System.assert(!String.isBlank(controller.htmlBody), 'Email Body Not Found');

        Test.stopTest();
    }
}