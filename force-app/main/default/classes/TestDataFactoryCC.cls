/**
 * Test Data factory for Contact Center
* 
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-08-29
*
**/

@isTest
public class TestDataFactoryCC {
    
    //default number of records to create
    public static Integer testDataSize = 10;
    
    // Get Contact Record type Map
    public static Map <String, Schema.RecordTypeInfo> mapContactRecordTypes = Contact.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    // Get Account Record type Map
    public static Map <String, Schema.RecordTypeInfo> mapAccountRecordTypes = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    // Get Case Record type Map
    public static Map <String, Schema.RecordTypeInfo> mapCaseRecordTypes = Case.sObjectType.getDescribe().getRecordTypeInfosByName();

/**
* @Description get the thread ID of a case
* @Param Case.Id
* @Return the Thread ID as String
**/
    public static String getTestCaseThreadID(String caseID) {
        return 'ref:_'  + UserInfo.getOrganizationId().left(4)  + 'E' + UserInfo.getOrganizationId().mid(11,4) + '._' + caseID.left(4) + 'E' + caseID.mid(10,5) + ':ref';
    }    

/**
* @Description Method to create a user
* @Param Profile Name, User Name
* @Return User
**/
    public static User createUser(string profile, string username) {
        username = Math.random() + username;
        user newUser;
        
        try{
            
            Profile userProfile = [select Name from Profile where Name = :profile];
            
            newUser = new User(Alias = 'test',
                               Email = 'one@test.sbsa.co.za',
                               Emailencodingkey = 'UTF-8',
                               Lastname = profile + ' User',
                               Languagelocalekey = 'en_US',
                               City = 'Johannesburg',
                               Country = 'South Africa',
                               //BRID__c = String.valueOf(Math.random()).left(9),
                               Localesidkey = 'en_US',
                               Profileid = userProfile.Id,
                               Timezonesidkey = 'America/Los_Angeles',
                               Username = username);
            
        }Catch(Exception e) {
            system.assertEquals('List has no rows for assignment to SObject Profile', e.getMessage());
        }
        return newUser;
    }
    
    /**
* @Description Create Account records
* @Param RecordTypeId
* @Return List<Account>
**/
    
    public static list<Account> getAccountList(String recordTypeName) {
        
        list <Account> lstAccount = new list <Account> ();
        
        for (Integer i = 0; i < testDataSize; i++) {
            
            Account testAccount = new Account();
            testAccount.recordTypeId = mapAccountRecordTypes.get(recordTypeName).getRecordTypeId();
            testAccount.Name = 'test ' +  recordTypeName  + i;
            testAccount.ShippingCountry = 'South Africa';
            
            lstAccount.add(testAccount);
        }
        return lstAccount;
    }  
    
    /**
* @Description Populate Contact record
* @Param List<Account>
* @Return List<Contact>
**/
    
    public static list<Contact> getContactList(list<Account> lstAccount) {
        
        list <Contact> lstcontact = new list <Contact> ();
        
        for (Integer i = 0; i < lstAccount.size(); i++) {
            
            Contact con = new Contact();
            con.AccountId = lstAccount[i].Id;
            con.LastName = 'testcontact' + i;
            con.FirstName = 'test' + i;
            con.MobilePhone = '0823343399';
            con.Email = Math.Random() + 'absa@test.co.za';
            lstcontact.add(con);
        }
        return lstcontact;
    }  
    
/**
* @Description Create Case records
* @Param RecordTypeId
* @Param OwnerId
* @Return list<Case>
**/
    
    public static list<Case> getCaseList(String recordTypeName, String ownerId) {
        
        list<Case> lstCases = new list<Case>();
        
        for (Integer i = 0; i < testDataSize; i++) {
            
            Case testCase = new Case();
            testCase.recordTypeId = mapCaseRecordTypes.get(recordTypeName).getRecordTypeId();
            testCase.Subject = 'Support test ' +  recordTypeName  + i;
            testCase.OwnerId = ownerId;
            testCase.Origin = 'Email';
            testCase.Status = 'New';
            testCase.Priority = 'High';
            testCase.Email_From_Address__c = 'wouter@styne.co.za';
            lstCases.add(testCase);
        }
        
        return lstCases;
    }  
    
    /**
* @Description Create EmailMessage records
* @Param isHtml
* @Param ParentId
* @Return list<EmailMessage>
**/
    
    public static list<EmailMessage> getEmailMessageList(String parentObjId, Boolean isHTML) {
        
        list<EmailMessage> lstEmailMessages = new list<EmailMessage>();
        
        for (Integer i = 0; i < testDataSize; i++) {
            
            EmailMessage testEmailMessage = new EmailMessage();
            testEmailMessage.Subject = 'Email Message test ' + i;
            testEmailMessage.ParentId = parentObjId;
            testEmailMessage.MessageDate = System.now();
            
            if(isHTML){
                testEmailMessage.HtmlBody = '<html><head><meta charset="utf-8"><title>Outlook</title></head><table><tr><td>Test Email HTML body</td></tr></table></html>';
            }else{
                testEmailMessage.TextBody = 'Test Email Plaintext body';
            }
            
            lstEmailMessages.add(testEmailMessage);
        }
        return lstEmailMessages;
    }  
    
/**
* @Description Create a Queue
* @Param QueueName
* @Return QueueId
**/
    public static list<CaseComment> getCaseComments(String caseID, Boolean pvt) {
        list<CaseComment> newCaseComments = new list<CaseComment>();
        
        for (Integer i = 0; i < testDataSize; i++){
            
            CaseComment cc = new CaseComment();
            cc.IsPublished = pvt;
            cc.CommentBody = 'Comment Number ' + i;
            cc.ParentId = caseID;
            
            newCaseComments.add(cc); 
        }
        
        return newCaseComments;
    }  
    
    /**
* @Description Create an InboundEmail record
* @Return Messaging.InboundEmail
**/
    public static Messaging.InboundEmail getInboundEmail() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.htmlBody = '<html><head><meta charset="utf-8"><title>Outlook</title></head><table><tr><td>Pls rest my password</td></tr></table></html>';
        email.subject = 'Please reset my pwd...now!';
        email.fromName = 'Wouter Styne';
        email.fromAddress = 'wouter@styne.co.za';
        return email;
    }  
    /**
* @Description Create an InboundEnvelope record
* @Return Messaging.InboundEnvelope
**/
    public static Messaging.InboundEnvelope getInboundEnvelope() {
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        env.toAddress = 'Passwords@absa.co.za';
        env.fromAddress = 'littleJonny@abc.co.za';
        return env;
    } 
    /**
* @Description Create an InboundEmail BinaryAttachment record
* @Return an array of Messaging.InboundEmail.BinaryAttachment[]
**/
    public static Messaging.InboundEmail.BinaryAttachment[] getBinaryAttachment() {
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
        return new Messaging.inboundEmail.BinaryAttachment[] { attachment };
    }  
    
    /**
* @Description Create an Attachment record
* @Param Attachment ParentId
* @Return an Attachment Record
**/
    public static Attachment getAttachment(String pid) {
        Attachment att = new Attachment();
        att.body = blob.valueOf('my attachment text');
        att.Description = 'Test Att';
        att.Name = 'Afile.txt';
        att.ParentId = pid;
        return att;
    }  
/**
* get a list of Shared_Email__c SObjects
* 
* @Return list<Shared_Email__c>
**/
    public static list<Shared_Email__c> getSharedEmails() {
        
        list<Shared_Email__c> newSharedEmails = new list<Shared_Email__c>();
        
        for (Integer i = 0; i < testDataSize; i++){
            
       		Shared_Email__c shamail = new Shared_Email__c();
            shamail.Active__c = true;
            shamail.Inbox_Address__c = Math.Random() + 'absatest@dummy.com';
            shamail.Salesforce_Email_Address__c = 'dummytest@salesforce-domain.com';
            shamail.Verified__c = true;
            
            newSharedEmails.add(shamail); 
        }
        
        return newSharedEmails;
    }

/**
* get a list of Email_Rule__c SObjects
* 
* @Return list<Email_Rule__c>
**/
    public static list<Email_Rule__c> getEmailRules() {
        
        list<Email_Rule__c> newEmailRules = new list<Email_Rule__c>();
        
        for (Integer i = 0; i < testDataSize; i++){
            
            Email_Rule__c rule = new Email_Rule__c();
            rule.Active__c = true;
            rule.From__c = System.today();
            Date toDate = System.today();
            rule.To__c = toDate.addMonths(12);
            
   //Math.Random()
            
            newEmailRules.add(rule); 
        }
        
        return newEmailRules;
    }  
}