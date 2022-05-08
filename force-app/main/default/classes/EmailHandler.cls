/**
 * Class that is used to send emails with a particular template and email address
 * @author  Kyle Alexander
 * @created 2018-06-06
 * @last modified on  : 08-11-2021
 * @description       : EmailHandler
 * @last modified by  : Mradul Maheshwari
 * Update : 2019-09-24 TC - Overloaded SendEmail and added ComposeEmail
 * Description : EmailHandler
 * @
 */

public without sharing class EmailHandler {
  /**
   * Method that sends the email
   * @description       : SendEmail
   * @param whatId - object that the email is being sent from
   * @param targetObjectId - target contact that the email is stored on
   * @param emailAddress - email address that the email is being sent to
   * @param templateName - email template that needs to be sent
   */

  public static void SendEmail(
    Id whatId,
    Id targetObjectId,
    String emailAddress,
    String templateName
  ) {
    // Construct a list for email we want to send
    List<Messaging.SingleEmailMessage> lstMsgs = ComposeEmail(
      whatId,
      targetObjectId,
      emailAddress,
      templateName
    );

    OrgWideEmailAddress[] owea = [
      SELECT Id
      FROM OrgWideEmailAddress
      WHERE DisplayName = 'Wills'
    ];
    // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
    // contents to a new SingleEmailMessage. Then send those new messages.
    List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
    for (Messaging.SingleEmailMessage email : lstMsgs) {
      Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
      emailToSend.setToAddresses(email.getToAddresses());
      emailToSend.setPlainTextBody(email.getPlainTextBody());
      emailToSend.setHTMLBody(email.getHTMLBody());
      emailToSend.setSubject(email.getSubject());
      emailToSend.setSaveAsActivity(true);
      emailToSend.setWhatId(whatId);
      //Set from address

      if (owea.size() > 0) {
        emailToSend.setOrgWideEmailAddressId(owea.get(0).Id);
      }
      lstMsgsToSend.add(emailToSend);
    }
    Messaging.sendEmail(lstMsgsToSend);
  }

  /**
   * Method that sends email (Subject and Body already composed)
   * @description : SendEmail
   * @param whatId - object that the email is being sent from
   * @param targetObjectId - target contact that the email is stored on
   * @param emailAddress - email address that the email is being sent to
   * @param emailSubject - email subject that needs to be sent
   * @param emailHTMLBody - HTML email body that needs to be sent
   * @param emailPlainTextBody - plain text email body that needs to be sent
   */

  public static void SendEmail(
    Id whatId,
    Id targetObjectId,
    String emailAddress,
    String emailSubject,
    String emailHTMLBody,
    String emailPlainTextBody
  ) {
    // Construct a list for email we want to send
    List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();

    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
    msg.setWhatId(whatId);
    msg.setTargetObjectId(targetObjectId);
    msg.setToAddresses(new List<String>{ emailAddress });
    msg.setSubject(emailSubject);
    msg.setPlainTextBody(emailPlainTextBody);
    msg.setHTMLBody(emailHTMLBody);
    msg.setSaveAsActivity(true);

    lstMsgs.add(msg);

    // Send the emails
    Messaging.sendEmail(lstMsgs);
  }

  /**
   * @description ComposeEmail
   * @author Mradul Maheshwari | 28-10-2021
   * @param whatId
   * @param targetObjectId
   * @param emailAddress
   * @param templateName
   * @return List<Messaging.SingleEmailMessage>
   **/
  public static List<Messaging.SingleEmailMessage> ComposeEmail(
    Id whatId,
    Id targetObjectId,
    String emailAddress,
    String templateName
  ) {
    // Construct the list of emails we want to send
    List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();

    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
    msg.setTemplateId(
      [SELECT Id FROM EmailTemplate WHERE DeveloperName = :templateName]
      .Id
    );
    msg.setWhatId(whatId);
    msg.setTargetObjectId(targetObjectId);
    msg.setToAddresses(new List<String>{ emailAddress });

    lstMsgs.add(msg);

    // Send the emails in a transaction, then roll it back
    Savepoint sp = Database.setSavepoint();
    Messaging.sendEmail(lstMsgs);
    Database.rollback(sp);

    return lstMsgs;
  }

  /**
   *
   * Method that genrates html body and sends the email for Balance Enquiry flow
   *
   * @description sendMailFromFlow
   * @param whatId - object that the email is being sent from
   * @param emailAddress - email address that the email is being sent to
   * @param accountNumber - masked account number that we are sending to customer
   * @param balanceDetails - balance details
   */
  public static void sendMailFromFlow(
    Id whatId,
    string emailAddress,
    string accountNumber,
    string balanceDetails
  ) {
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    string[] to = new List<string>{ emailAddress };
    //string[] cc = new string[] {ccMail};

    email.setToAddresses(to);
    /* if(ccMail!=null && ccMail != '')
	        email.setCcAddresses(cc);
        if(repmail!=null && repmail!= '')
        	email.setInReplyTo(repMail); */

    email.setSubject('View Balance Mail');

    email.setHtmlBody(
      'Hello, <br/><br/>This is the test mail that you generated. <br/>The Email Id for which this mail was generated by ' +
      emailAddress +
      '<br/> your Account Balance for Account number ' +
      accountNumber +
      '  is ' +
      balanceDetails +
      '   <br/>Regards<br/> Developer'
    );
    try {
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    } catch (exception e) {
      apexpages.addmessage(
        new apexpages.message(apexpages.severity.error, e.getMessage())
      );
    }
  }

  /**
   * @description : this method can send email with and attchment with replacing valuees in HTML email template
   * @author Mradul Maheshwari | 28-10-2021
   * @param replaceMap replace string(s) from original email template
   * @param orgWideAddressId
   * @param pdfData attachment data with base 64 value
   * @param caseId
   * @param email
   * @param templateName
   * @param documentName
   * @return String
   **/
  public static String sendEmailAttachmentWithHTMLMergeFields(
    Map<String, String> replaceMap,
    Id orgWideAddressId,
    String pdfData,
    String caseId,
    String email,
    String templateName,
    String documentName
  ) {
    Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
    List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(
      caseId,
      targetObjectId,
      email,
      templateName
    );
    if (constructEmail != null && constructEmail.size() > 0) {
      Messaging.SingleEmailMessage emailConstruct = constructEmail[0];
      string[] toAddress = new List<string>{ email };
      String subject = emailConstruct.getSubject();

      String emailBody = emailConstruct.getHtmlBody();

      if (replaceMap != null) {
        for (String bodyString : replaceMap.keySet()) {
          emailBody = emailBody.replace(bodyString, replaceMap.get(bodyString));
        }
      }

      Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
      emailMessage.setOrgWideEmailAddressId(orgWideAddressId);
      emailMessage.setToAddresses(toAddress);
      emailMessage.setSubject(subject);
      emailMessage.setHtmlBody(emailBody);
      emailMessage.saveAsActivity = false;

      if (pdfData != null || pdfData != '') {
        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment emailFileAttach = new Messaging.EmailFileAttachment();
        emailFileAttach.setFileName(documentName);
        emailFileAttach.setBody(EncodingUtil.base64Decode(pdfData));
        fileAttachments.add(emailFileAttach);
        emailMessage.setFileAttachments(fileAttachments);
      }
      //Send Email
      Messaging.sendEmail(
        new List<Messaging.SingleEmailMessage>{ emailMessage }
      );

      OrgWideEmailAddress owea = [
        SELECT Id, Address
        FROM OrgWideEmailAddress
        WHERE Id = :orgWideAddressId
      ];

      //Attach Email to Case
      EmailMessage emailMsg = new EmailMessage();
      emailMsg.FromAddress = owea.Address;
      emailMsg.Subject = subject;
      emailMsg.HtmlBody = emailBody;
      emailMsg.ParentId = caseId;
      emailMsg.ToAddress = email;
      insert emailMsg;

      return 'Email sent Successfully.';
    } else {
      //Error - unable to construct Email
      return 'Error: Unable to construct email. EmailHandler.ComposeEmail(' +
        caseId +
        ' ' +
        email +
        ' ' +
        templateName +
        ')';
    }
  }
}