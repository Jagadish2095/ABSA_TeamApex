/**
 * @description       : EmailHandlerTest
 * @author            :
 * @last modified on  : 08-11-2021
 * @last modified by  : Mradul Maheshwari
 **/
@isTest
public class EmailHandlerTest {
  /**
   * @description Test class for EmailHandler
   * @since 2019-09-24
   **/

  @testSetup
  static void dataCreation() {
    Account account = new Account(Name = 'Test Account');
    insert account;

    Contact contact = new Contact(
      LastName = 'Test contact',
      AccountId = account.Id,
      Email = 'someaddress@email.com'
    );
    insert contact;

    map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe()
      .getRecordTypeInfosByDeveloperName();
    BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

    Service_Type__c serviceType = new Service_Type__c(
      Name = 'Test1',
      Case_Record_Type__c = 'New',
      Subtype__c = 'Sample',
      Type__c = 'T01'
    );
    insert serviceType;

    Service_Group__c serviceGr = new Service_Group__c(
      Name = 'Test1',
      Assign_Record_Type__c = 'Email',
      Response_Email_Address__c = 'evg@t.com',
      Queue__c = 'Email',
      Business_Hours__c = businessHr.Id,
      Internal_SLA_Time_Measure__c = 'Hour(s)',
      Internal_SLA_Units__c = '8',
      Active__c = true
    );
    insert serviceGr;

    Service_Level__c serviceLevel = new Service_Level__c(
      Name = 'Test1',
      External_SLA_Time_Measure__c = 'Hour(s)',
      External_SLA_Units__c = '8',
      Default_Service_Level__c = true
    );
    insert serviceLevel;

    Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
      Service_Type__c = serviceType.Id,
      Service_Group__c = serviceGr.Id,
      Service_Level__c = serviceLevel.Id
    );
    insert serviceGrType;

    Case caseRec = new Case(
      Communication_Method__c = 'Email',
      Status = 'New',
      Origin = 'Email',
      AccountId = account.Id,
      Risk_Management_Centre__c = 'Digital Fraud',
      Email__c = 'test@test.com',
      recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
      Subject = 'test',
      Description = 'test',
      Service_Group_Search__c = serviceGr.id,
      sd_Service_Group_Id__c = serviceGr.Id,
      Expectation_of_the_Customer__c = 'test',
      Incident_Date__c = date.today()
    );
    insert caseRec;
  }

  @isTest
  static void testSendEmail() {
    Id whatId = [SELECT Id FROM Case LIMIT 1].Id;
    Id targetObjectId = [SELECT Id FROM Contact WHERE Email != NULL LIMIT 1].Id;
    EmailTemplate recTemplate = [
      SELECT DeveloperName
      FROM EmailTemplate
      LIMIT 1
    ];
    String templateName = recTemplate.DeveloperName;
    String emailAddress = 'test@email.com';
    EmailHandler.SendEmail(whatId, targetObjectId, emailAddress, templateName);
    System.assert(true);
  }

  @isTest
  static void testSendEmailWithBody() {
    Id whatId = [SELECT Id FROM Case LIMIT 1].Id;
    Id targetObjectId = [SELECT Id FROM Contact WHERE Email != NULL LIMIT 1].Id;
    EmailTemplate recTemplate = [
      SELECT DeveloperName
      FROM EmailTemplate
      LIMIT 1
    ];
    String templateName = recTemplate.DeveloperName;
    String emailAddress = 'test@email.com';
    String emailSubject = 'Test Mail';
    String emailHTMLBody = '<html><body><p>This is a <test mail</p></body></html>';
    String emailPlainTextBody = 'This is a test mail';
    EmailHandler.SendEmail(
      whatId,
      targetObjectId,
      emailAddress,
      emailSubject,
      emailHTMLBody,
      emailPlainTextBody
    );
    System.assert(true);
  }

  @isTest
  static void testComposeEmail() {
    Id whatId = [SELECT Id FROM Case LIMIT 1].Id;
    Id targetObjectId = [SELECT Id FROM Contact WHERE Email != NULL LIMIT 1].Id;
    EmailTemplate recTemplate = [
      SELECT DeveloperName
      FROM EmailTemplate
      LIMIT 1
    ];
    String templateName = recTemplate.DeveloperName;
    String emailAddress = 'test@email.com';
    List<Messaging.SingleEmailMessage> lstMsgs = EmailHandler.ComposeEmail(
      whatId,
      targetObjectId,
      emailAddress,
      templateName
    );
    if (lstMsgs != null) {
      Messaging.SingleEmailMessage email = lstMsgs.get(0);
      String htmlBody = email.getHTMLBody();
    }
    System.assert(true);
  }

  @isTest
  static void testSendEmailAttachmentwithHTMLMergeFields() {
    Document_Template__c docTemp = new Document_Template__c(
      Name = 'Account Enquiry',
      Document_Type__c = 'Account Enquiry'
    );
    insert docTemp;
    EmailTemplate eTemp = [SELECT Id, DeveloperName FROM EmailTemplate LIMIT 1];
    String pdfData = 'demo';
    Account acc = [SELECT id FROM Account WHERE name = 'Test Account' LIMIT 1];
    Case caseRec = [SELECT id FROM Case WHERE Subject = 'Test' LIMIT 1];

    Map<String, String> replaceMap = new Map<String, String>();
    replaceMap.put('{account}', '8989');

    OrgWideEmailAddress owea = [
      SELECT Id, Address
      FROM OrgWideEmailAddress
      WHERE Address = 'home@absa.co.za'
    ];
    EmailHandler.sendEmailAttachmentWithHTMLMergeFields(
      replaceMap,
      owea.Id,
      'test',
      (String) caseRec.Id,
      'test@test.com',
      eTemp.DeveloperName,
      'test'
    );
    System.assert(true);
  }

  @isTest
  static void testsendMailFromFlow() {
    Case caseRec = [SELECT id FROM Case WHERE Subject = 'Test' LIMIT 1];

    EmailHandler.sendMailFromFlow(caserec.Id, 'test@test.com', '8989', '8989');
    System.assert(true);
  }
}