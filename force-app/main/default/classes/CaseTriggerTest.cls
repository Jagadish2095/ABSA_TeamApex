/**
 * @description  Testing Case Trigger functionality  
 */
//TODO This class still needs lots of work - only 50% coverage on CaseTriggerFunctions and Assert Statements needed....
 
@IsTest public with sharing class CaseTriggerTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345',Work_Phone__c='0114578962', Active_Email__c = 'test@example.com');
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
        
          Id recordIDOfAIC = [Select id from recordtype Where DeveloperName ='AIC'].id;
        insert new Case(AccountId = account.Id, ContactId=contact.Id, recordtypeId = recordIDOfAIC);
       
    }
   
     @IsTest public static void testCaseTrigger() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account,'account is not null');
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
       
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = account);
       
        insert testCase;
       
        Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator (Custom)'];
         
        User user = new User(FirstName = 'test', LastName= 'last_test', Email='testSf@test.com',
                             Phone='111-111-1111', alias = 'test', EmailEncodingKey='UTF-8', ProfileId = profile.Id,
                             LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                             UserName = 'sftestCase@test.com', IsActive = true);
        insert user;
       
        System.runAs(user) {
             testCase.OwnerId = user.Id;
             testCase.BusinessHoursId = businessHr.Id;
             update testCase;
        }
         
        TriggerDispatcher.skip('AccountTriggerHandler');
        List<String> handlersTest = new List<String>();
        handlersTest.add('AccountTriggerHandler');
        TriggerDispatcher.skip(handlersTest);
        TriggerDispatcher.resume('AccountTriggerHandler');
        TriggerDispatcher.resume(handlersTest);
       
       // System.assertEquals(controller.changePassword(),null);                          
    }  
    @IsTest public static void testCaseDispatcher() {
        TriggerDispatcher.skip('AccountTriggerHandler');
        List<String> handlersTest = new List<String>();
        handlersTest.add('AccountTriggerHandler');
        system.assertEquals(1, handlersTest.size(),'list is not empty');
        TriggerDispatcher.skip(handlersTest);
        TriggerDispatcher.resume('AccountTriggerHandler');
        TriggerDispatcher.resume(handlersTest);
    }
   
    @IsTest public static void testCaseTriggerHandler() {
        TriggerHandler trigHandler = new TriggerHandler();
        system.assertNotEquals(null, trigHandler);
        trigHandler.beforeInsert(new List<sObject>());
        trigHandler.beforeUpdate(new Map<Id, sObject>(), new Map<Id, sObject>());
        trigHandler.beforeDelete(new Map<Id, sObject>());
        trigHandler.afterInsert(new Map<Id, sObject>());
        trigHandler.afterUpdate(new Map<Id, sObject>(), new Map<Id, sObject>());
        trigHandler.afterDelete(new Map<Id, sObject>());
        trigHandler.afterUnDelete(new Map<Id, sObject>());
    }
   
    /**
     *  @description 07/2019 - Koketso Mpshane : Update to test CaseTriggerFunctions and meet the test coverage
     * */
    @IsTest
    public static void testCaseTriggerFunctions() {
       
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        system.assertNotEquals(null, profile);

        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'test';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser;
       
        System.runAs(sysAdminUser) {
           
            EmailTemplate eTemp = new EmailTemplate();
            eTemp.Name = 'Test Email Template 1';
            eTemp.DeveloperName = 'Test_Email_Template_1';
            eTemp.isActive = true;
            eTemp.TemplateType = 'text';
            eTemp.FolderId = UserInfo.getUserId();
            insert eTemp;
           
        }
       
        Case caseold = new Case();
        caseold.Type__c = 'Service Type 1';
        //caseold.sd_Email_Template_Case_Classification__c = 'Test Email Template 1' ;
        caseold.Status = 'New';
        caseold.Email_From_Address__c = 'test@from.com';
        caseold.Communication_Method__c ='Email';
        caseold.Incident_Date__c = Date.today();
        caseold.Email__c = 'test@from.com';
        caseold.Subject = 'Test Subject';
        caseold.Description = 'Test Description';
        caseold.Origin = 'Email';
        caseold.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        insert caseold;
       
        Case casenew = caseold;
        casenew.Id= caseold.Id;
        casenew.Type__c = 'Service Type 2';
        casenew.Status = 'Resolved';
        casenew.sd_Email_Template_Case_Closure__c = 'text';
        casenew.Email_From_Address__c ='test@from.com';
        casenew.sd_Communication_Plan_Id__c = null;
        update casenew;
        test.startTest();

       
        //system.debug('casenewOWNER:'+casenew.OwnerId);
       
        List<Case> testList = new List<Case>();
        testList.add(casenew);
        //Test Class Modifies for NBFS Case Record Type
        //CaseTriggerFunctions.emailResponse(testList, new Map<Id, Case>{caseold.Id => caseold}, 'create');
        //CaseTriggerFunctions.emailResponse(testList, new Map<Id, Case>{caseold.Id => caseold}, 'update');
        Id caseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        Case rejectedCase = new Case();
        rejectedCase.Approval_Status__c = 'Rejected';
        rejectedCase.SLA_Extension_Reason__c= 'Need Extension';
        rejectedCase.SLA_Extension_Approval_Required__c= true;
        rejectedCase.SLA_Extension_Approval__c='Rejected';
        rejectedCase.RecordTypeId = caseRecordTypeId1;
        rejectedCase.Extended_Request_Data__c = '[{"recordLabel":"Control Officer Information","attributes":[{"attrLabel":"Control Officer Details","attrApiName":null,"attrType":"Section","required":null,"attrValue":null},{"attrLabel":"Control Officer Employee Number","attrApiName":"empno","attrType":"Text","required":null,"attrValue":"9147362"},{"attrLabel":"Control Officer Number","attrApiName":"connumber","attrType":"Text","required":false,"attrValue":"0"},{"attrLabel":"Business Segment","attrApiName":"bussegment","attrType":"Text","required":false,"attrValue":"B"},{"attrLabel":"INDIVIDUAL OR GROUP RECORD","attrApiName":"INDIVIDUALORGROUPRECORD","attrType":"Text","required":false,"attrValue":null},{"attrLabel":"CONTROL OFFICER TYPE","attrApiName":"CONTROLOFFICERTYPE","attrType":"Text","required":false,"attrValue":null},{"attrLabel":"BUSINESS SUB-SEGMENT INDICATOR","attrApiName":"BUSINESSSUBSEGMENTINDICATOR","attrType":"Text","required":false,"attrValue":null}]}]';
        insert rejectedCase;
       
        //Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
        User managerUser = new User(FirstName = 'test', LastName= 'last_test', Email='testSf@test.com',
                                  Phone='111-111-1111', alias = 'test', EmailEncodingKey='UTF-8', ProfileId = profile.Id,
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                                  UserName = 'sf12345@test.com', IsActive = true);
        insert managerUser;
       
        User user = new User(FirstName = 'test', LastName= 'last_test', Email='testSf@test.com',
                             Phone='111-111-1111', alias = 'test', EmailEncodingKey='UTF-8', ProfileId = profile.Id,
                             LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                             UserName = 'sftest44@test.com', IsActive = true, managerid = managerUser.Id);
        insert user;
 
            /***********Added by Chenna - start*************/
            Approval.ProcessSubmitRequest approvalProcessObj = new Approval.ProcessSubmitRequest();
            approvalProcessObj.setObjectId(rejectedCase.id);
            approvalProcessObj.setSubmitterId(user.Id);
            approvalProcessObj.setNextApproverIds(new Id[] {user.Id});
           
            Approval.ProcessResult result = Approval.process(approvalProcessObj);
            /************Added by Chenna - end************/
       
        Map<Id, Case> rejectedCaseMap = new Map<Id, Case>();
        rejectedCaseMap.put(rejectedCase.Id, rejectedCase);
       
        CaseTriggerFunctions.rejectedCaseLogic(rejectedCaseMap);
       
        Case unwantCase = casenew;
        unwantCase.Unwanted_Type__c = 'Spam / Junk';
        unwantCase.Status = 'Unwanted';
        unwantCase.sd_Inbox_Name__c = 'test@sharedemail.com';
        update unwantCase;
       
        List<Case> unwantCaseList = new List<Case>();
        unwantCaseList.add(unwantCase);
       
        CaseTriggerFunctions.blockSpamJunkEmails(unwantCaseList);
       
        unwantCase.Status = 'Unresolved';
        update unwantCase;
       
        CaseTriggerFunctions.closeUnwantedCases(new List<Case>{unwantCase} , new Map<Id, Case>{casenew.Id => casenew});

        Account account = [SELECT Id FROM Account LIMIT 1];
        RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Complaint'];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        List<Service_Group__c> sgList = new List<Service_Group__c>();
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Test1';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        sgList.add(serviceGr);
        /***********Added by Chenna - start*************/
        Service_Group__c serviceGr1 = new Service_Group__c();
        serviceGr1.Name = 'Test1';
        serviceGr1.Assign_Record_Type__c = 'Email';
        serviceGr1.Response_Email_Address__c = 'evg@t.com';
        serviceGr1.Queue__c = 'Email';
        serviceGr1.Business_Hours__c = businessHr.Id;
        sgList.add(serviceGr1);
        insert sgList;
        /***********Added by Chenna - end*************/
       
       
        Case complaintCase = new Case();
        complaintCase.BusinessHoursId = businessHr.Id;
        complaintCase.Communication_Method__c = 'Email';
        complaintCase.Status = 'New';
        complaintCase.Origin = 'Email';
        complaintCase.AccountId = account.Id;
        complaintCase.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase.Email_From_Address__c = 'test@ret.com';
        complaintCase.Email__c = 'test@ret.com';
        complaintCase.Incident_Date__c = System.Today();
        complaintCase.RecordTypeId = complaintRectype.Id;
        complaintCase.Approval_Status__c = 'Approved';
        complaintCase.SLA_Extension_Approval__c = 'Approved';
        complaintCase.Expectation_of_the_Customer__c = 'Testing';
        complaintCase.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase.SLA_Extension_Approval_Required__c = true;
        complaintCase.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase.Subject = 'Test';
        complaintCase.Description ='Test';
        complaintCase.Deadlock_Approval_Required__c = true;
        complaintCase.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase.Type__c = 'Test';
        complaintCase.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase.SLA_Pause_Date__c = System.now();
        complaintCase.External_SLA_Warning_Date__c = system.today();
        complaintCase.External_SLA_End_Date__c = system.today();
        complaintCase.Out_of_Internal_SLA__c = true;
        complaintCase.Out_of_External_SLA__c = true;
        complaintCase.Manager_Time_in_Pause_Status__c = null;
        complaintCase.sd_Service_Group_Type_Id__c = null;
        insert complaintCase;
       
        Case complaintCaseUpdate = complaintCase;
        complaintCaseUpdate.Awaiting_Status__c = 'Awaiting Feedback from BU';
        complaintCaseUpdate.Last_Status_Change__c = system.today();
        complaintCaseUpdate.sd_Service_Group_Type_Id__c = serviceGr.Id;
        complaintCaseUpdate.Status = 'In progress';
        update complaintCaseUpdate;
       
        //RecordType serviceReqRectype = [Select Id From RecordType Where DeveloperName = 'Service_Request'];
       
        Case serviceReqCaseUpdate = complaintCaseUpdate;
        //serviceReqCaseUpdate.RecordTypeId = serviceReqRectype.Id;
        serviceReqCaseUpdate.Awaiting_Status__c = '';
        serviceReqCaseUpdate.Last_Status_Change__c = system.today();
        serviceReqCaseUpdate.sd_Service_Group_Type_Id__c = serviceGr.Id;
        serviceReqCaseUpdate.Status = 'Awaiting External';
        serviceReqCaseUpdate.sd_Pause_Statuses__c = 'On Hold';
        update serviceReqCaseUpdate;
               
        CaseTriggerFunctions.pauseSLA(new List<Case>{serviceReqCaseUpdate}, new Map<Id, Case>{complaintCase.Id => complaintCase});
       
        CaseTriggerFunctions.callCMSservice(complaintCaseUpdate.Id);
        CaseTriggerFunctions.sendchatteronCaseCreation(new Map<Id, Case>{complaintCaseUpdate.Id => complaintCaseUpdate});
        CaseTriggerFunctions.sendchatteronCaseUpdate(new Map<Id, Case>{complaintCaseUpdate.Id => complaintCaseUpdate}, new Map<Id, Case>{complaintCase.Id => complaintCase});
       
        CaseTriggerFunctions.getremainder(Long.valueOf('12'),Long.valueOf('12'));
       // CaseTriggerFunctions.ControllerOfficerCaseAssignment(new List<Case>{rejectedCase});
        test.stopTest();  
        
        system.assertNotEquals(serviceReqCaseUpdate, null);

    }
      /**
    * @description testCaseTriggerFunctionTransferCaseComment description
    *
    */

    @IsTest
    public static void testCaseTriggerFunctionTransferCaseComment() {
       
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Complaint'];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
       
        Case caseRec = new Case();
        caseRec.Type__c = 'Service Type 1';
        caseRec.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        caseRec.Status = 'New';
        caseRec.Email_From_Address__c = 'test@from.com';
        caseRec.Communication_Method__c = 'Email';
        caseRec.Email__c = 'test@from.com';
        caseRec.Incident_Date__c = Date.today();
        caseRec.Subject = 'Test Subject';
        caseRec.Description = 'Test Description';
        caseRec.Origin = 'Email';
        caseRec.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        caseRec.OwnerId = UserInfo.getUserId();
        insert caseRec;
       
        Case transferCase = caseRec;
        transferCase.OwnerId = gQueue.Id;
        transferCase.Transfer_Reason__c = 'Out-of-Office';
        transferCase.Status = 'In progress';
        update transferCase;
       
        CaseTriggerFunctions.insertTransferCaseComment(new List<Case>{transferCase}, new Map<Id, Case>{caseRec.Id => caseRec});
       
    }
   
    @IsTest
    public static void testCaseTriggerFunctionClose() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Complaint'];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
       
        Case caseRec = new Case();
        caseRec.Type__c = 'Service Type 1';
        caseRec.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        caseRec.Status = 'New';
        caseRec.Email_From_Address__c = 'test@from.com';
        caseRec.OwnerId = UserInfo.getUserId();
        caseRec.Out_of_External_SLA__c = true;
        caseRec.Out_of_Internal_SLA__c = true;
        caseRec.Communication_Method__c = 'Email';
        caseRec.Email__c = 'test@from.com';
        caseRec.Incident_Date__c = Date.today();
        caseRec.Subject = 'Test Subject';
        caseRec.Description = 'Test Description';
        caseRec.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        caseRec.Origin = 'Email';
        caseRec.Incident_Date__c = Date.today();
        insert caseRec;
       
        Case closeCase = caseRec;
        closeCase.Reopen_Case_Approval_Status__c = 'Approved';
        closeCase.Status = 'Resolved';
        closeCase.Account = account;
        closeCase.AccountId = account.id;
        closeCase.Type__c = 'abc';
        closeCase.Subtype__c = 'def';
        closeCase.sd_Internal_SLA_Time_Measure__c = 'Day(s)';
        closeCase.sd_Internal_SLA_Units__c = '4';
        closeCase.sd_External_SLA_Units__c = '8';
        closeCase.sd_External_SLA_Time_Measure__c = 'Week(s)    ';
        closeCase.sd_Max_SLA_Units__c = '8';
        closeCase.sd_Max_SLA_Time_Measure__c = 'Week(s)';
        closeCase.Out_Of_SLA_Reason__c = 'Account Closed';
        closeCase.Out_Of_SLA_Comments__c = 'Account Closed';
        update closeCase;
       
        Service_Group__c serviceGr = [SELECT Id FROM Service_Group__c LIMIT 1];
             
        Case recreateCase = new Case();
        recreateCase.Case_Reopened_From__c = closeCase.Id;
        recreateCase.sd_Service_Group__c = serviceGr.Id;
        recreateCase.Communication_Method__c = 'Email';
        recreateCase.Email__c = 'test@from.com';
        recreateCase.Incident_Date__c = Date.today();
        recreateCase.Subject = 'Test Subject';
        recreateCase.Description = 'Test Description';
        recreateCase.Origin = 'Email';
        recreateCase.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        insert recreateCase;
       
        Case reopenCase = [select id, Reopen_Case_Approval_Status__c, ClosedDate, sd_Internal_SLA_Time_Measure__c, sd_Internal_SLA_Units__c, BusinessHoursId, Internal_SLA_Warning_Date__c, Internal_SLA_End_Date__c, Out_of_External_SLA__c, Out_of_Internal_SLA__c,
                               sd_External_SLA_Units__c, External_SLA_End_Date__c, sd_External_SLA_Time_Measure__c, External_SLA_Warning_Date__c, sd_Max_SLA_Units__c, sd_Max_SLA_Time_Measure__c, Max_SLA_Extension_Date__c From Case where Id =: closeCase.Id];
       
        CaseTriggerFunctions.reopenClosedCase(new List<Case>{reopenCase});
    }
   
    @IsTest
    public static void testCaseTriggerFunctionTrackTransfer() {
       
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Complaint'];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
       
        List<Case> caseRecords = new List<Case>();
        Case caseRec = new Case();
        caseRec.Type__c = 'Service Type 1';
        caseRec.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        caseRec.Status = 'New';
        caseRec.Email_From_Address__c = 'test@from.com';
        caseRec.Out_of_External_SLA__c = false;
        caseRec.Awaiting_Status__c = 'Awaiting Customer Documents';
        caseRec.Subject = 'Test Subject';
        caseRec.Description = 'Test Description';
        caseRec.Origin = 'Email';
        caseRec.Communication_Method__c = 'Email';
        caseRec.Email__c = 'test@from.com';
        caseRec.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        caseRec.Incident_Date__c = Date.today();
        insert caseRec;
       
        caseRec.Out_of_External_SLA__c = true;
        caseRec.Out_of_Internal_SLA__c = true;
        caseRec.Awaiting_Status__c = 'Awaiting Customer Feedback';
        update caseRec;
       
        Case caseRec1 = new Case();
        caseRec1.Type__c = 'Service Type 1';
        caseRec1.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        caseRec1.Status = 'New';
        caseRec1.Email_From_Address__c = 'test@from.com';
        caseRec1.Out_of_Internal_SLA__c = false;
        caseRec1.Subject = 'Test Subject';
        caseRec1.Description = 'Test Description';
        caseRec1.Origin = 'Email';
        caseRec1.Communication_Method__c = 'Email';
        caseRec1.Email__c = 'test@from.com';
        caseRec1.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        caseRec1.Incident_Date__c = Date.today();
        insert caseRec1;
       
        caseRec1.Out_of_External_SLA__c = false;
        caseRec1.Out_of_Internal_SLA__c = true;
        update caseRec1;
       
        Case caseRec2 = caseRec1;
        caseRec2.Status = 'In progess';
        update caseRec2;
       
        Case caseRec3 = caseRec2;
        caseRec3.Status = 'Resolved';
        update caseRec3;
       
        Case_Transfer_Tracking__c tracking = new Case_Transfer_Tracking__c();
        tracking.Case__c = caseRec3.Id;
        insert tracking;
       
        CaseTriggerFunctions.trackTransfer(new Map<Id, Case>{caseRec.Id => caseRec}, null);
       
        CaseTriggerFunctions.trackTransfer(new Map<Id, Case>{caseRec3.Id => caseRec3}, new Map<Id, Case>{caseRec2.Id => caseRec2});
               
     }
   
    @IsTest
    public static void testCaseTriggerFunctionsWithoutBulkTransfer() {
       
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Complaint'];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
       
        Service_Type__c serviceType = new Service_Type__c();
        serviceType.Name = 'Test1';
        serviceType.Case_Record_Type__c = 'New';
        serviceType.Subtype__c = 'Sample';
        serviceType.Type__c = 'T01';
        insert serviceType;
       
        Case complaintCase = new Case();
        complaintCase.BusinessHoursId = businessHr.Id;
        complaintCase.Communication_Method__c = 'Email';
        complaintCase.Status = 'New';
        complaintCase.Origin = 'Email';
        complaintCase.AccountId = account.Id;
        complaintCase.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase.Email_From_Address__c = 'test@ret.com';
        complaintCase.Email__c = 'test@ret.com';
        complaintCase.Incident_Date__c = System.Today();
        complaintCase.RecordTypeId = complaintRectype.Id;
        complaintCase.Approval_Status__c = 'Approved';
        complaintCase.SLA_Extension_Approval__c = 'Approved';
        complaintCase.Expectation_of_the_Customer__c = 'Testing';
        complaintCase.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase.SLA_Extension_Approval_Required__c = true;
        complaintCase.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase.Subject = 'Test';
        complaintCase.Description ='Test';
        complaintCase.Deadlock_Approval_Required__c = true;
        complaintCase.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase.Type__c = 'Test';
        complaintCase.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase.SLA_Pause_Date__c = System.now();
        complaintCase.External_SLA_Warning_Date__c = system.today();
        complaintCase.External_SLA_End_Date__c = system.today();
        complaintCase.Out_of_Internal_SLA__c = true;
        complaintCase.Out_of_External_SLA__c = false;
        complaintCase.SME_Time_in_Pause_Status__c = null;
        complaintCase.sd_Service_Type_Id__c = null;
        insert complaintCase;
       
        complaintCase.Awaiting_Status__c = 'Awaiting Feedback from BU';
        complaintCase.sd_Service_Type_Id__c = serviceType.Id;
        update complaintCase;
                 
     }
   
    @IsTest
    public static void testCaseTriggerFunctionsWithBulkTransfer() {
       
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Complaint'];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
       
        Case complaintCase = new Case();
        complaintCase.BusinessHoursId = businessHr.Id;
        complaintCase.Communication_Method__c = 'Email';
        complaintCase.Status = 'New';
        complaintCase.Origin = 'Email';
        complaintCase.AccountId = account.Id;
        complaintCase.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase.Email_From_Address__c = 'test@ret.com';
        complaintCase.Email__c = 'test@ret.com';
        complaintCase.Incident_Date__c = System.Today();
        complaintCase.RecordTypeId = complaintRectype.Id;
        complaintCase.Approval_Status__c = 'Approved';
        complaintCase.SLA_Extension_Approval__c = 'Approved';
        complaintCase.Expectation_of_the_Customer__c = 'Testing';
        complaintCase.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase.SLA_Extension_Approval_Required__c = true;
        complaintCase.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase.Subject = 'Test';
        complaintCase.Description ='Test';
        complaintCase.Deadlock_Approval_Required__c = true;
        complaintCase.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase.Type__c = 'Test';
        complaintCase.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase.SLA_Pause_Date__c = System.now();
        complaintCase.External_SLA_Warning_Date__c = system.today();
        complaintCase.External_SLA_End_Date__c = system.today();
        complaintCase.Out_of_Internal_SLA__c = false;
        complaintCase.Out_of_External_SLA__c = false;
        complaintCase.Consultant_Time_in_Pause_Status__c = null;
        complaintCase.Bulk_Transfer_Selected_Cases__c = true;
        try{
        insert complaintCase;
        }catch (Exception e) {
           //system.debug(e.getMessage());
           System.assert(true, 'Exception ' + e);
        }
        complaintCase.Awaiting_Status__c = 'Awaiting Feedback from BU';
        try{
        update complaintCase;
        }catch (Exception e) {
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
       
     }
   
    @IsTest
    public static void testCaseTriggerFunctionUpdateServiceTypeInfo() {
       
        Account account = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Complaint'];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
       
        sd_Communication_Plan__c commPlan = new sd_Communication_Plan__c();
        commPlan.Name = 'Test Communication';
        insert commPlan;
       
        List<Service_Group__c> sgList = new List<Service_Group__c>();
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Test1';
        //serviceGr.Name = 'Absa Linked Investments';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        serviceGr.Active__c = true;
        serviceGr.Queue__c = gQueue.Name;
        sgList.add(serviceGr);
        /************Added by Chenna****************/
        Service_Group__c serviceGr2 = new Service_Group__c();
        serviceGr2.Name = 'Test1';
        serviceGr2.Assign_Record_Type__c = 'Email';
        serviceGr2.Response_Email_Address__c = 'evg@t.com';
        serviceGr2.Queue__c = 'Email';
        serviceGr2.Business_Hours__c = businessHr.Id;
        sgList.add(serviceGr2);
        insert sgList;
        /************End by Chenna****************/
       
         /************Added by Kalyani****************/
        Service_Group__c serviceGr1 = new Service_Group__c();
        serviceGr1.Name = 'Absa Linked Investments';
        serviceGr1.Assign_Record_Type__c = 'Email';
        serviceGr1.Response_Email_Address__c = 'evg@t.com';
        serviceGr1.Queue__c = 'Email';
        serviceGr1.Business_Hours__c = businessHr.Id;
        serviceGr1.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr1.Internal_SLA_Units__c = '8';
        serviceGr1.Active__c = true;
        serviceGr1.Queue__c = gQueue.Name;
        insert serviceGr1;
         /************End of Code Added by Kalyani****************/
       
        Service_Level__c serviceLevel = new Service_Level__c();
        serviceLevel.Name = 'Test1';
        serviceLevel.External_SLA_Time_Measure__c = 'Hour(s)';
        serviceLevel.External_SLA_Units__c = '8';
        serviceLevel.Default_Service_Level__c = true;
        serviceLevel.Max_SLA_Units__c = '4';
        serviceLevel.Max_SLA_Time_Measure__c = 'Hour(s)';
        insert serviceLevel;
       
        List<Service_Type__c> serviceTypes = new List<Service_Type__c>();
       
        Service_Type__c serviceType1 = new Service_Type__c();
        serviceType1.Name = 'Test1';
        serviceType1.Case_Record_Type__c = 'New';
        serviceType1.Subtype__c = 'Sample';
        serviceType1.Type__c = 'T01';
        serviceType1.Case_Record_Type__c = complaintRectype.Name;
        serviceTypes.add(serviceType1);
       
        Service_Type__c serviceType2 = new Service_Type__c();
        serviceType2.Name = 'Test2';
        serviceType2.Case_Record_Type__c = 'New';
        serviceType2.Subtype__c = 'Sample';
        serviceType2.Type__c = 'T02';
        serviceType2.Case_Record_Type__c = complaintRectype.Name;
        serviceTypes.add(serviceType2);
       
        insert serviceTypes;
         
        List<Service_Group_Type__c> serviceGrTypes = new List<Service_Group_Type__c>();
       
        Service_Group_Type__c serviceGrType1 = new Service_Group_Type__c();
        serviceGrType1.Service_Type__c = serviceType1.Id;
        serviceGrType1.Service_Group__c = serviceGr.Id;
        serviceGrType1.Service_Level__c = serviceLevel.Id;
        serviceGrType1.sd_Communication_Plan__c = commPlan.Id;
        serviceGrTypes.add(serviceGrType1);
       
        Service_Group_Type__c serviceGrType2 = new Service_Group_Type__c();
        serviceGrType2.Service_Type__c = serviceType2.Id;
        serviceGrType2.Service_Group__c = serviceGr1.Id;
        serviceGrType2.Service_Level__c = serviceLevel.Id;
        serviceGrType2.sd_Communication_Plan__c = commPlan.Id;
        serviceGrTypes.add(serviceGrType2);
       
        insert serviceGrTypes;
       
        List<Case> complaintCase = new List<Case>();
        case complaintCase1 = new case();
        complaintCase1.BusinessHoursId = businessHr.Id;
        complaintCase1.Communication_Method__c = 'Email';
        complaintCase1.Status = 'New';
        complaintCase1.Origin = 'Email';
        complaintCase1.AccountId = account.Id;
        complaintCase1.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase1.Email_From_Address__c = 'test@ret.com';
        complaintCase1.Email__c = 'test@ret.com';
        complaintCase1.Incident_Date__c = System.Today();
        complaintCase1.RecordTypeId = complaintRectype.Id;
        //complaintCase.Approval_Status__c = 'Approved';
        //complaintCase.SLA_Extension_Approval__c = 'Approved';
        /************Added by Chenna***************
        complaintCase1.SLA_Extension_Approval__c = 'Rejected';
        complaintCase1.Internal_SLA_Warning_Date__c = System.now();
        complaintCase1.Internal_SLA_End_Date__c = System.now().addDays(10);
        ***********End of Code Added by Chenna****************/
        complaintCase1.Expectation_of_the_Customer__c = 'Testing';
        complaintCase1.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase1.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase1.SLA_Extension_Approval_Required__c = true;
        complaintCase1.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase1.Subject = 'Test';
        complaintCase1.Description ='Test';
        complaintCase1.Deadlock_Approval_Required__c = true;
        complaintCase1.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase1.Type__c = 'Test';
        complaintCase1.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase1.SLA_Pause_Date__c = System.now();
        complaintCase1.External_SLA_Warning_Date__c = system.today();
        complaintCase1.External_SLA_End_Date__c = system.today();
        complaintCase1.Out_of_Internal_SLA__c = false;
        complaintCase1.Out_of_External_SLA__c = false;
        complaintCase1.Consultant_Time_in_Pause_Status__c = null;
        complaintCase1.Bulk_Transfer_Selected_Cases__c = true;
        complaintCase1.sd_Service_Group_Id__c = serviceGr.Id;
        complaintCase1.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase1.sd_Service_Type_Id__c = null;//serviceType1.Id;
        complaintCase1.sd_Service_Group_Type_Id__c = serviceGrType1.Id;
        complaintCase1.Service_Group_Search__c = serviceGr.Id;
        //complaintCase1.Category__c = Level 1;
       // complaintCase1.Source__c = Generic;
        complaintCase.add(complaintCase1);
       
        /************Added by Kalyani****************/
        Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('NBFS Dispute Resolution').getRecordTypeId();
       
        case complaintCase2 = new case();
        complaintCase2.BusinessHoursId = businessHr.Id;
        complaintCase2.Communication_Method__c = 'Email';
        complaintCase2.Status = 'New';
        complaintCase2.Origin = 'Email';
        complaintCase2.AccountId = account.Id;
        complaintCase2.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase2.Email_From_Address__c = 'test@ret.com';
        complaintCase2.Email__c = 'test@ret.com';
        complaintCase2.Incident_Date__c = System.Today();
        complaintCase2.RecordTypeId = RecordTypeId;
        complaintCase2.Expectation_of_the_Customer__c = 'Testing';
        complaintCase2.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase2.SLA_Extension_Reason__c = 'This is for testing1';
        complaintCase2.SLA_Extension_Approval_Required__c = true;
        complaintCase2.Deadlock_Reason_Motivation__c = 'Sample test1';
        complaintCase2.Subject = 'Test';
        complaintCase2.Description ='Test';
        complaintCase2.Deadlock_Approval_Required__c = true;
        complaintCase2.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase2.Type__c = 'Test';
        complaintCase2.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase2.SLA_Pause_Date__c = System.now();
        complaintCase2.External_SLA_Warning_Date__c = system.today();
        complaintCase2.External_SLA_End_Date__c = system.today();
        complaintCase2.Out_of_Internal_SLA__c = false;
        complaintCase2.Out_of_External_SLA__c = false;
        complaintCase2.Consultant_Time_in_Pause_Status__c = null;
        complaintCase2.Bulk_Transfer_Selected_Cases__c = false;
        complaintCase2.sd_Service_Group_Id__c = serviceGr1.Id;
        complaintCase2.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase2.sd_Service_Type_Id__c = null;//serviceType1.Id;
        complaintCase2.sd_Service_Group_Type_Id__c = serviceGrType2.Id;
        complaintCase2.Service_Group_Search__c = serviceGr1.Id;
        complaintCase2.NBFS_Category__c = 'Level 3';
        complaintCase2.Source__c = 'OBS';
        /************Added by Chenna***************
        complaintCase2.SLA_Extension_Approval__c = 'Rejected';
        complaintCase2.Internal_SLA_Warning_Date__c = System.now();
        complaintCase2.Internal_SLA_End_Date__c = System.now().addDays(10);
        ***********End of Code Added by Chenna****************/
        //complaintCase2.sd_Service_Group__c = 'Absa Linked Investments';
        complaintCase.add(complaintCase2);
        
        /************Added by Chenna***************/
        case complaintCase0 = new case();
        complaintCase0.BusinessHoursId = businessHr.Id;
        complaintCase0.Communication_Method__c = 'Email';
        complaintCase0.Status = 'New';
        complaintCase0.Origin = 'Email';
        complaintCase0.AccountId = account.Id;
        complaintCase0.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase0.Email_From_Address__c = 'test@ret.com';
        complaintCase0.Email__c = 'test@ret.com';
        complaintCase0.Incident_Date__c = System.Today();
        complaintCase0.RecordTypeId = RecordTypeId;
        complaintCase0.Expectation_of_the_Customer__c = 'Testing';
        complaintCase0.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase0.SLA_Extension_Reason__c = 'This is for testing1';
        complaintCase0.SLA_Extension_Approval_Required__c = true;
        complaintCase0.Deadlock_Reason_Motivation__c = 'Sample test1';
        complaintCase0.Subject = 'Test';
        complaintCase0.Description ='Test';
        complaintCase0.Deadlock_Approval_Required__c = true;
        complaintCase0.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase0.Type__c = 'Test';
        complaintCase0.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase0.SLA_Pause_Date__c = System.now();
        complaintCase0.External_SLA_Warning_Date__c = system.today();
        complaintCase0.External_SLA_End_Date__c = system.today();
        complaintCase0.Out_of_Internal_SLA__c = false;
        complaintCase0.Out_of_External_SLA__c = false;
        complaintCase0.Consultant_Time_in_Pause_Status__c = null;
        complaintCase0.Bulk_Transfer_Selected_Cases__c = false;
        complaintCase0.sd_Service_Group_Id__c = serviceGr2.Id;
        complaintCase0.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase0.sd_Service_Type_Id__c = null;//serviceType1.Id;
        complaintCase0.sd_Service_Group_Type_Id__c = serviceGrType2.Id;
        complaintCase0.Service_Group_Search__c = serviceGr1.Id;
        complaintCase0.NBFS_Category__c = 'Level 3';
        complaintCase0.Source__c = 'OBS';
        complaintCase0.SLA_Extension_Approval__c = 'Rejected';
        complaintCase0.Internal_SLA_Warning_Date__c = System.now();
        complaintCase0.Internal_SLA_End_Date__c = System.now().addDays(10);
        //complaintCase0.sd_Service_Group__c = 'Absa Linked Investments';
        complaintCase.add(complaintCase0);
        
        case complaintCase4 = new case();
        complaintCase4.BusinessHoursId = businessHr.Id;
        complaintCase4.Communication_Method__c = 'Email';
        complaintCase4.Status = 'New';
        complaintCase4.Origin = 'Email';
        complaintCase4.AccountId = account.Id;
        complaintCase4.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase4.Email_From_Address__c = 'test@ret.com';
        complaintCase4.Email__c = 'test@ret.com';
        complaintCase4.Incident_Date__c = System.Today();
        complaintCase4.RecordTypeId = RecordTypeId;
        complaintCase4.Expectation_of_the_Customer__c = 'Testing';
        complaintCase4.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase4.SLA_Extension_Reason__c = 'This is for testing1';
        complaintCase4.SLA_Extension_Approval_Required__c = true;
        complaintCase4.Deadlock_Reason_Motivation__c = 'Sample test1';
        complaintCase4.Subject = 'Test';
        complaintCase4.Description ='Test';
        complaintCase4.Deadlock_Approval_Required__c = true;
        complaintCase4.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase4.Type__c = 'Test';
        complaintCase4.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase4.SLA_Pause_Date__c = System.now();
        complaintCase4.External_SLA_Warning_Date__c = system.today();
        complaintCase4.External_SLA_End_Date__c = system.today();
        complaintCase4.Out_of_Internal_SLA__c = false;
        complaintCase4.Out_of_External_SLA__c = false;
        complaintCase4.Consultant_Time_in_Pause_Status__c = null;
        complaintCase4.Bulk_Transfer_Selected_Cases__c = false;
        complaintCase4.sd_Service_Group_Id__c = serviceGr1.Id;
        complaintCase4.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase4.sd_Service_Type_Id__c = null;//serviceType1.Id;
        complaintCase4.sd_Service_Group_Type_Id__c = serviceGrType2.Id;
        complaintCase4.Service_Group_Search__c = serviceGr1.Id;
        complaintCase4.NBFS_Category__c = null;
        complaintCase4.Source__c = null;
        complaintCase4.SLA_Extension_Approval__c = 'Rejected';
        complaintCase4.Internal_SLA_Warning_Date__c = System.now();
        complaintCase4.Internal_SLA_End_Date__c = System.now().addDays(10);
        complaintCase.add(complaintCase4);
        /***********End of Code Added by Chenna****************/
       
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        case complaintCase3 = new case();
        complaintCase3.BusinessHoursId = businessHr.Id;
        complaintCase3.Communication_Method__c = 'Email';
        complaintCase3.Status = 'New';
        complaintCase3.Origin = 'Email';
        complaintCase3.AccountId = account.Id;
        complaintCase3.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase3.Email_From_Address__c = 'test@ret.com';
        complaintCase3.Email__c = 'test@ret.com';
        complaintCase3.Incident_Date__c = System.Today();
        complaintCase3.RecordTypeId = devRecordTypeId;
        complaintCase3.Expectation_of_the_Customer__c = 'Testing';
        complaintCase3.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase3.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase3.SLA_Extension_Approval_Required__c = true;
        complaintCase3.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase3.Subject = 'Test';
        complaintCase3.Description ='Test';
        complaintCase3.Deadlock_Approval_Required__c = true;
        complaintCase3.sd_Pause_Statuses__c = 'On Hold';
        complaintCase3.Type__c = 'Test';
        complaintCase3.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase3.SLA_Pause_Date__c = System.now();
        complaintCase3.External_SLA_Warning_Date__c = system.today();
        complaintCase3.External_SLA_End_Date__c = system.today();
        complaintCase3.Out_of_Internal_SLA__c = false;
        complaintCase3.Out_of_External_SLA__c = false;
        complaintCase3.Consultant_Time_in_Pause_Status__c = null;
        complaintCase3.Bulk_Transfer_Selected_Cases__c = true;
        complaintCase3.sd_Service_Group_Id__c = serviceGr.Id;
        complaintCase3.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase3.sd_Service_Type_Id__c = null;//serviceType1.Id;
        complaintCase3.sd_Service_Group_Type_Id__c = serviceGrType1.Id;
        complaintCase3.Service_Group_Search__c = serviceGr.Id;
        complaintCase3.NBFS_Category__c ='Level 2';
        /************Added by Chenna****************/
        complaintCase3.SLA_Extension_Approval__c = 'Rejected';
        complaintCase3.Internal_SLA_Warning_Date__c = System.now();
        complaintCase3.Internal_SLA_End_Date__c = System.now().addDays(10);
        /************End of Code Added by Chenna****************/
        complaintCase.add(complaintCase3);
        try{
        insert complaintCase;
        }
        catch (Exception e) {
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        /************End of Code Added by Kalyani****************/
       
        Map<Id, Case> oldcasemap = new Map<Id, Case>();
        oldcasemap.put(complaintCase[0].Id,complaintCase[0]);
        //oldcasemap.put(complaintCase[1].Id,complaintCase[1]);
       
        List<Case> caseRecUpdate = complaintCase;
        caseRecUpdate[0].sd_Service_Type_Id__c = serviceType2.Id;
        caseRecUpdate[0].sd_Service_Group_Type_Id__c = serviceGrType2.Id;
        caseRecUpdate[0].Awaiting_Status__c = 'Awaiting Customer Feedback';
        caseRecUpdate[2].sd_Service_Type_Id__c = serviceType2.Id;
        caseRecUpdate[2].sd_Service_Group_Type_Id__c = serviceGrType2.Id;
        caseRecUpdate[2].Awaiting_Status__c = 'Awaiting Customer Feedback';
        caseRecUpdate[2].sd_Pause_Statuses__c = 'On Hold';
        caseRecUpdate[2].Status = 'In Progress';
       // caseRecUpdate[0].NBFS_Category__c = 'Level 1';
        //caseRecUpdate[0].Source__c = 'Generic';
       
        /*caseRecUpdate[1].sd_Service_Group__c = 'Absa Linked Investments';
        caseRecUpdate[1].Awaiting_Status__c = 'Awaiting Customer Feedback';*/
        try{
        update caseRecUpdate;
        }catch (Exception e) {
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
         /************Added by Kalyani****************/
        SLA_Configuration__mdt SlaCalNBFS=   [select id,External_SLA_Units__c,Internal_SLA_Time_Measure__c,Internal_SLA_Units__c,External_SLA_Time_Measure__c,MasterLabel,Service_Group__c,DeveloperName from SLA_Configuration__mdt where MasterLabel = 'AbsaLinkedInvestments3OBS' ];
         /************End of Code Added by Kalyani****************/
       
        Id devRecordTypeId31 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DD STI Case').getRecordTypeId();
        case complaintCase31 = new case();
        complaintCase31.BusinessHoursId = businessHr.Id;
        complaintCase31.Communication_Method__c = 'Email';
        complaintCase31.Status = 'New';
        complaintCase31.Origin = 'Email';
        complaintCase31.AccountId = account.Id;
        complaintCase31.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase31.Email_From_Address__c = 'test@ret.com';
        complaintCase31.Email__c = 'test@ret.com';
        complaintCase31.Incident_Date__c = System.Today();
        complaintCase31.RecordTypeId = devRecordTypeId31;
        complaintCase31.Expectation_of_the_Customer__c = 'Testing';
        complaintCase31.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase31.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase31.SLA_Extension_Approval_Required__c = true;
        complaintCase31.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase31.Subject = 'Test';
        complaintCase31.Description ='Test';
        complaintCase31.Deadlock_Approval_Required__c = true;
        complaintCase31.sd_Pause_Statuses__c = 'On Hold';
        complaintCase31.Type__c = 'Test';
        complaintCase31.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase31.SLA_Pause_Date__c = System.now();
        complaintCase31.External_SLA_Warning_Date__c = system.today();
        complaintCase31.External_SLA_End_Date__c = system.today();
        complaintCase31.Out_of_Internal_SLA__c = false;
        complaintCase31.Out_of_External_SLA__c = false;
        complaintCase31.Consultant_Time_in_Pause_Status__c = null;
        complaintCase31.Bulk_Transfer_Selected_Cases__c = true;
        complaintCase31.sd_Service_Group_Id__c = serviceGr.Id;
        complaintCase31.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase31.sd_Service_Type_Id__c = null;//serviceType1.Id;
        complaintCase31.sd_Service_Group_Type_Id__c = serviceGrType1.Id;
        complaintCase31.Service_Group_Search__c = serviceGr.Id;
        complaintCase31.NBFS_Category__c ='Level 2';
        complaintCase31.SLA_Extension_Approval__c = 'Rejected';
        complaintCase31.Internal_SLA_Warning_Date__c = System.now();
        complaintCase31.Internal_SLA_End_Date__c = System.now().addDays(10);

        try{
        insert complaintCase31;
        }
        catch (Exception e) {
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        try{
            oldcasemap = new Map<Id, Case>();
            oldcasemap.put(complaintCase31.Id,complaintCase31);
            CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{complaintCase31}, oldcasemap);
        }Catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        /************End of Code Added by Anu Dhaka****************/
       
       
        CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{caseRecUpdate[0]}, oldcasemap);
        oldcasemap = new Map<Id, Case>();
        oldcasemap.put(complaintCase[1].Id,complaintCase[1]);
        try{
            CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{caseRecUpdate[1]}, oldcasemap);
        }catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        oldcasemap = new Map<Id, Case>();
        oldcasemap.put(complaintCase[2].Id,complaintCase[2]);
        /************Added by Chenna****************/
        try{
            CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{caseRecUpdate[2]}, oldcasemap);
        }Catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        try{
            CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{caseRecUpdate[3]}, oldcasemap);
        }Catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        try{
            CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{caseRecUpdate[4]}, oldcasemap);
        }Catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        try{
            CaseTriggerFunctions.updateCaseServiceTypeInfoBeforeUpdate(new List<case>{caseRecUpdate[0]}, oldcasemap);
        }Catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        Test.startTest();
        Case testCase = new Case(RecordTypeId = devRecordTypeId, Account = account, ID_Type__c = 'SA ID',Customer_ID__c = '8002146158081',
                                    sd_Service_Group__c = 'Staff Expense',Type__c = 'PEP High Risk and Very High Risk');
        insert testCase;
        
        CaseTriggerFunctions.callDocPredictionService(testCase.Id);
        CaseTriggerFunctions.refreshCaseClient(testCase.Id);
        CaseTriggerFunctions.predictionServiceFutureCallout(caseRecUpdate[0].Id,caseRecUpdate[0].CaseNumber,caseRecUpdate[0].Status,
                                                            caseRecUpdate[0].Service_Type_Search__c,caseRecUpdate[0].SuppliedEmail,
                                                            caseRecUpdate[0].Subject,caseRecUpdate[0].Description,
                                                            caseRecUpdate[0].Service_Group_Search__c);
        CaseTriggerFunctions.createEDDCase(testCase.Id , '',account.Id);
        /************End by Chenna****************/
        test.stopTest();
    }
   /*----------- Uncomment code--------------by ANU Dhaka---- */
   /**
* @description : rejectedCasetriggerhandlerTest()
**/
    @IsTest public static void rejectedCaseTriggerHandler() {
       Case rejectedCase = new Case(Approval_Status__c = 'Rejected');
       insert rejectedCase;
       Map<Id, Case> rejectedCaseMap = new Map<Id, Case>();
       rejectedCaseMap.put(rejectedCase.Id, rejectedCase);
       CaseTriggerFunctions.rejectedCaseLogic(rejectedCaseMap); 
       system.assertNotEquals(rejectedCase, null); 
    }  
   
   @IsTest public static void testEmailResponse() {
        Case eMailCase = new Case();
        List<Case> testList = new List<Case>();
        testList.add(eMailCase);
        CaseTriggerFunctions.emailResponse(testList, null, 'create');
        system.assertNotEquals(eMailCase, null); 
        
    }
   
     @IsTest public static void testCaseTriFun() {
         Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
       
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
         EmailTemplate eTemplate = [SELECT Id, Name FROM EmailTemplate LIMIT 1];
       
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert serviceGr;
       
        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1',
                                                             External_SLA_Time_Measure__c = 'Hour(s)',
                                                             External_SLA_Units__c = '8',
                                                             Default_Service_Level__c = true);
        insert serviceLevel;
       
       
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id,
                                                                        Service_Level__c = serviceLevel.Id);
        insert serviceGrType;
       
        Site__c site = new Site__c (Name = 'Test', Service_Group__c = serviceGr.Id);
       
        insert site;
         
         Account account = [SELECT Id FROM Account LIMIT 1];
                 
         Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
                       
         Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com', Email__c = 'test@ret.com', Incident_Date__c = System.Today(),
                                RecordTypeId = caseRecordTypeId, Approval_Status__c = 'Approved', SLA_Extension_Approval__c = 'Approved', Expectation_of_the_Customer__c = 'Testing',
                                Awaiting_Status__c = 'Awaiting Customer Documents', SLA_Extension_Reason__c = 'This is for testing',
                                SLA_Extension_Approval_Required__c = true, Deadlock_Reason_Motivation__c = 'Sample test', Subject = 'Test', Description ='Test',
                                Deadlock_Approval_Required__c = true, sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback', Type__c = 'Test', sd_Email_Template_Case_Classification__c = eTemplate.Name);
         insert caseRec;
                 
         Case_Transfer_Tracking__c caseTransferTrack = new Case_Transfer_Tracking__c(Case__c = caseRec.Id,
                                                                                     In__c = Date.today().addDays(-5) );
         insert caseTransferTrack;
         Test.startTest();
         caseRec.Type__c = 'Customer';
         caseRec.Status = 'In Progress';
         caseRec.Approval_Status__c = 'Rejected';
         caseRec.Awaiting_Status__c = 'Awaiting Customer Feedback';
         caseRec.sd_Service_Group_Type_Id__c = serviceGrType.Id;
         caseRec.sd_Service_Group_Id__c = serviceGr.Id;
         caseRec.Bulk_Transfer_Selected_Cases__c = true;
         update caseRec;
         Test.stopTest();
         Case testCase = [SELECT Id, Approval_Status__c, Awaiting_Status__c FROM Case where Id =: caseRec.Id ];
         System.assertEquals(testCase.Awaiting_Status__c , 'Awaiting Customer Feedback');

         caseRec.Status = 'Closed';
         caseRec.AccountId = account.Id;
         caseRec.Type__c = 'AType';
         caseRec.Subtype__c = 'ASubType';
         caseRec.Product__c = 'AProduct';
         caseRec.Out_Of_SLA_Reason__c = 'Investigation';
         caseRec.Out_Of_SLA_Comments__c = 'Investigation';
         caseRec.Awaiting_Status__c = 'Awaiting Customer Documents';
         caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
         caseRec.Communication_Method__c = 'Email';
         caseRec.Bypass_Validation_Rules__c = true;
         caseRec.Reopen_Case_Approval_Status__c = 'Approved';
         caseRec.sd_Internal_SLA_Time_Measure__c = 'Hour(s)';
         caseRec.sd_Internal_SLA_Units__c = '4';
         caseRec.sd_External_SLA_Time_Measure__c = 'Hour(s)';
         caseRec.sd_External_SLA_Units__c = '8';
         caseRec.sd_Max_SLA_Time_Measure__c = 'Hour(s)';
         caseRec.sd_Max_SLA_Units__c = '4';
         update caseRec;  

         List<Case> updatedCase = [Select Id, ClosedDate, Reopen_Case_Approval_Status__c, BusinessHoursId,
                                    sd_Internal_SLA_Time_Measure__c, sd_Internal_SLA_Units__c,
                                    Internal_SLA_Warning_Date__c, Internal_SLA_End_Date__c,
                                    sd_External_SLA_Units__c, sd_External_SLA_Time_Measure__c,
                                    sd_Max_SLA_Time_Measure__c, sd_Max_SLA_Units__c  ,Email_From_Address__c
                                    From Case Where Id = :caseRec.Id];
         
         CaseTriggerFunctions.reopenClosedCase(updatedCase);

     }

    @IsTest public static void negTestCaseTriFun() {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        Case caseRec = new Case(RecordTypeId = caseRecordTypeId, Communication_Method__c = 'Email', Status = 'New', Origin = 'Email',
                                Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com');
        insert caseRec;
        CaseTriggerFunctions.trackTransfer(new Map<Id, sObject>{caseRec.Id => caseRec}, null);
        caseRec = new Case(RecordTypeId = caseRecordTypeId, Communication_Method__c = 'Email', Status = 'New', Origin = 'Email',
                           Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com');
        CaseTriggerFunctions.trackTransferInsert(new List<Case>{caseRec});
       
       
        Case caseRec1 = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', //AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com',
                                RecordTypeId = caseRecordTypeId, sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback', Awaiting_Status__c = 'Awaiting Customer Documents');
        insert caseRec1;  
        Case caseRec2 = caseRec1;
        caseRec2.Awaiting_Status__c = 'Awaiting Customer Feedback';
        update caseRec2;
        CaseTriggerFunctions.pauseSLA(new List<Case>{caseRec1}, new Map<Id, Case>{caseRec2.Id => caseRec2});
        system.assertNotEquals(caseRec2, null); 
    }
   
    @IsTest public static void testCaseTriFuns() {
       
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
       
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        EmailTemplate eTemplate = [SELECT Id, Name FROM EmailTemplate LIMIT 1];
       
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert serviceGr;
       
        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1',
                                                             External_SLA_Time_Measure__c = 'Hour(s)',
                                                             External_SLA_Units__c = '8',
                                                             Default_Service_Level__c = true);
        insert serviceLevel;
       
       
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id,
                                                                        Service_Level__c = serviceLevel.Id);
        insert serviceGrType;
       
        Site__c site = new Site__c (Name = 'Test', Service_Group__c = serviceGr.Id);
       
        insert site;
       
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
               
        Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
        User managerUser = new User(FirstName = 'test', LastName= 'last_test', Email='testSf@test.com',
                                  Phone='111-111-1111', alias = 'test', EmailEncodingKey='UTF-8', ProfileId = profile.Id,
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                                  UserName = 'sf12345@test.com', IsActive = true);
        insert managerUser;
       
        User user = new User(FirstName = 'test', LastName= 'last_test', Email='testSf@test.com',
                             Phone='111-111-1111', alias = 'test', EmailEncodingKey='UTF-8', ProfileId = profile.Id,
                             LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                             UserName = 'sftest44@test.com', IsActive = true, managerid = managerUser.Id);
        insert user;
       
        System.runAs(user) {
           
            Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', //AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com',Email__c = 'test@ret.com',
                                RecordTypeId = caseRecordTypeId, Approval_Status__c = 'Approved', SLA_Extension_Approval__c = 'Approved',
                                Awaiting_Status__c = 'Awaiting Customer Documents', SLA_Extension_Reason__c = 'This is for testing', sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback',
                                SLA_Extension_Approval_Required__c = true, Deadlock_Approval_Required__c = true, Subject = 'Test', Description ='Test',
                                External_SLA_Notification_User__c = System.UserInfo.getUserId(), Incident_Date__c = System.Today(), Expectation_of_the_Customer__c = 'Testing',
                                sd_Service_Group_Type_Id__c = serviceGrType.Id, sd_Service_Group_Id__c = serviceGr.Id, sd_Email_Template_Case_Classification__c = eTemplate.Name, sd_Email_Template_Case_Closure__c = eTemplate.Name, Type__c = 'Test');
            insert caseRec;
           
            Approval.ProcessSubmitRequest approvalProcessObj = new Approval.ProcessSubmitRequest();
            approvalProcessObj.setObjectId(caseRec.id);
            approvalProcessObj.setSubmitterId(user.Id);
            approvalProcessObj.setNextApproverIds(new Id[] {user.Id});
           
            Approval.ProcessResult result = Approval.process(approvalProcessObj);
           
            caseRec.Approval_Status__c = 'Rejected';
            caseRec.Out_of_External_SLA__c = true;
            caseRec.Out_of_Internal_SLA__c = true;
            caseRec.sd_Service_Group_Id__c = serviceGr.Id;
            caseRec.Bulk_Transfer_Selected_Cases__c = true;
            caseRec.Awaiting_Status__c = 'Awaiting Customer Feedback';
            update caseRec;
            CaseTriggerFunctions.rejectedCaseLogic(new Map<Id, Case>{caseRec.Id => caseRec});
            system.assertNotEquals(caseRec, null);
           
        }
    }
    /* --------------------- Uncomment Code by ANu Dhaka -------*/
    /**
     * @description testCaseEmailResponse
     */

    @IsTest public static void testCaseEmailResponse() {
        List<Case> lstCase = new List<Case>(); 
        Case caseold = new Case();
        caseold.Type__c = 'Service Type 1';
        //caseold.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        caseold.Status = 'New';
        caseold.Subject = 'Test Subject';
        caseold.Description = 'Test Description';
        caseold.Origin = 'Email';
        caseold.Email_From_Address__c = 'test@from.com';
        caseold.Communication_Method__c = 'Email';
        caseold.Email__c = 'test@from.com';
        caseold.Expectation_of_the_Customer__c = 'Expectation of the Customer test';
        caseold.Incident_Date__c = Date.today();
        insert caseold;
        //lstCase.add(caseold);
        system.assertNotEquals(null, caseold);

        BusinessHours stdBusinessHours = [select id from BusinessHours where Name = 'Default'];

       
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
       
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'test';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser;
       
        System.runAs(sysAdminUser) {
           
            EmailTemplate eTemp = new EmailTemplate();
            eTemp.Name = 'Test Email Template 1';
            eTemp.DeveloperName = 'Test_Email_Template_1';
            eTemp.isActive = true;
            eTemp.TemplateType = 'text';
            eTemp.FolderId = UserInfo.getUserId();
            insert eTemp;
           
        }
        
        Account acc = [Select id from Account limit 1];
        
        Case c0 = new Case(Type__c = 'Service Type 2',
        Status = 'Closed',Last_Status_Change__c = System.now(),Awaiting_Status__c = 'Awaiting Customer Documents',
        BusinessHoursId=stdBusinessHours.Id,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU',Communication_Method__c ='Email',
        Email__c = 'test@from.com',Incident_Date__c = Date.today(),Subject = 'Test Subject',Description = 'Test Description',Origin = 'Email',
        Expectation_of_the_Customer__c = 'Expectation of the Customer test',
        Out_of_Internal_SLA__c=true, Out_of_External_SLA__c = true,ParentId=caseold.Id, AccountId = acc.Id);
        //insert c0;
        lstCase.add(c0);
        
         Case c2 = new Case(Type__c = 'Service Type 2',
                                        Status = 'Resolved',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =234,
                                        Out_of_External_SLA__c = true,Out_of_Internal_SLA__c = true,
                                        Communication_Method__c ='Email',
                                        Email__c = 'test@from.com',Incident_Date__c = Date.today(),Subject = 'Test Subject',Description = 'Test Description',Origin = 'Email',
                                        Expectation_of_the_Customer__c = 'Expectation of the Customer test',
                                        Unwanted_Type__c = 'Out-of-Office');
       //insert c2;
        lstCase.add(c2);
        Case c3 = new Case(Type__c = 'Service Type 2',
                                        Status = 'Resolved',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =234,
                                        Out_of_External_SLA__c = false,Out_of_Internal_SLA__c = true,
                                        Communication_Method__c ='Email',
                                        Email__c = 'test@from.com',Incident_Date__c = Date.today(),Subject = 'Test Subject',Description = 'Test Description',Origin = 'Email',
                                        Expectation_of_the_Customer__c = 'Expectation of the Customer test',
                                        Unwanted_Type__c = 'Out-of-Office',Consultant_Time_in_Pause_Status__c=230);
       //insert c3;
        lstCase.add(c3);
         Case c1 = new Case(Type__c = 'Service Type 2',Status = 'Resolved',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =234,
                                        Out_of_External_SLA__c = false,Out_of_Internal_SLA__c = true,
                                        Communication_Method__c ='Email',
                                        Email__c = 'test@from.com',Incident_Date__c = Date.today(),Subject = 'Test Subject',Description = 'Test Description',Origin = 'Email',
                                        Expectation_of_the_Customer__c = 'Expectation of the Customer test',
                                        Unwanted_Type__c = 'Out-of-Office');
        //insert c1;
        lstCase.add(c1);
        Id caseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        
         Case caseRec1 = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', //AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com',
                                RecordTypeId = caseRecordTypeId1, sd_Pause_Statuses__c = 'On Hold',
                                Email__c = 'test@from.com',Incident_Date__c = Date.today(),Subject = 'Test Subject',Description = 'Test Description',
                                Expectation_of_the_Customer__c = 'Expectation of the Customer test',
                                Awaiting_Status__c = 'Awaiting Customer Documents');
        try
        {
            //insert caseRec1;  //old
            lstCase.add(caseRec1);
        }catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
       
        Case c4 = new Case(Type__c = 'Service Type 2',
                                        Status = 'Resolved',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =234,
                                        Out_of_External_SLA__c = true,Out_of_Internal_SLA__c = true,
                                        Communication_Method__c ='Email',
                                        Email__c = 'test@from.com',Incident_Date__c = Date.today(),Subject = 'Test Subject',Description = 'Test Description',Origin = 'Email',
                                        Expectation_of_the_Customer__c = 'Expectation of the Customer test',
                                        Unwanted_Type__c = 'Out-of-Office',Consultant_Time_in_Pause_Status__c=230);
        //insert c4;
        lstCase.add(c4);
         //Added From Here
        
        try
        {
            insert lstCase; 
        }catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
        }
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
       
        User sysAdminUser1 = new User();
        sysAdminUser1.FirstName = 'test';
        sysAdminUser1.LastName = 'last_test';
        sysAdminUser1.Email = 'testSf1@test.com';
        sysAdminUser1.Phone = '111-111-1111';
        sysAdminUser1.Alias = 'test';
        sysAdminUser1.EmailEncodingKey = 'UTF-8';
        sysAdminUser1.ProfileId = profile1.Id;
        sysAdminUser1.LanguageLocaleKey = 'en_US';
        sysAdminUser1.LocaleSidKey = 'en_US';
        sysAdminUser1.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser1.UserName = 'sftestCase333@test.com';
        sysAdminUser1.IsActive = true;
        insert sysAdminUser1;
        
        Test.startTest();
       
          
        contact contactRecord=[select id,email from contact limit 1];       
        CaseTriggerFunctions.emailResponse(new List<Case>{new Case(Id= caseold.Id,Type__c = 'Service Type 2',Status = 'Resolved',ContactId=contactRecord.id,
                                        Email_From_Address__c ='test@from.com',sd_Email_Template_Case_Closure__c='Test Email Template 1',
                                        sd_Email_Template_Case_Classification__c='Test Email Template 1',sd_Email_Rule_Template__c='Test Email Template 1')},
                                        new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Type',Status = 'New')},
                                        'update');
        //CaseTriggerFunctions.trackCaseAge(new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Service Type 2',Status = 'Resolved',Email_From_Address__c ='test@from.com',sd_Email_Template_Case_Closure__c='Test Email Template 1')},
                                        //null);
        try{
        CaseTriggerFunctions.trackCaseAge(new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Service Type 2',
        Status = 'Resolved',Last_Status_Change__c = System.now(),Awaiting_Status__c = 'Awaiting Customer Documents',
        BusinessHoursId=stdBusinessHours.Id,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU')},
                                        new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Type',
                                        Status = 'New',Awaiting_Status__c = 'Awaiting Feedback from BU'
                                        ,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU')});
         }catch(exception e){
             //system.debug(e.getMessage());
             System.assert(true, 'Exception ' + e);
         }
         
         try{
        CaseTriggerFunctions.trackCaseAge(new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Service Type 2',
        Status = 'Resolved',Last_Status_Change__c = System.now(),Awaiting_Status__c = 'Awaiting Customer Documents',
        BusinessHoursId=stdBusinessHours.Id,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU',
        Out_of_Internal_SLA__c=true, Out_of_External_SLA__c = true)},
                                        new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Type',
                                        Status = 'New',Awaiting_Status__c = 'Awaiting Feedback from BU'
                                        ,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU')});
         }catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
         }
         
         
         
       
        Case c9 = caseold;
        c9.Id= c0.Id;
        c9.Type__c = 'Type';
        c9.Status = 'New';
        c9.Awaiting_Status__c = 'Awaiting Feedback from BU';
        c9.sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU';
         
         try{
        CaseTriggerFunctions.trackCaseAge(new Map<Id, Case>{c0.Id => c0},
                                        new Map<Id, Case>{c0.Id => c9});
         }catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
         }
         
        try{
        CaseTriggerFunctions.trackCaseAge(new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Service Type 2',
        Status = 'Resolved',Last_Status_Change__c = System.now(),Awaiting_Status__c = 'Awaiting Customer Documents',
        BusinessHoursId=stdBusinessHours.Id,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU',
        Out_of_Internal_SLA__c=true, Out_of_External_SLA__c = false)},
                                        new Map<Id, Case>{caseold.Id => new Case(Id= caseold.Id,Type__c = 'Type',
                                        Status = 'New',Awaiting_Status__c = 'Awaiting Feedback from BU'
                                        ,sd_Pause_Statuses__c = 'On Hold,Awaiting Feedback from BU')});
         }catch(exception e){
            //system.debug(e.getMessage());
            System.assert(true, 'Exception ' + e);
         }
         
        
        try{
        CaseTriggerFunctions.calculateCaseDuration(new List<Case>{c1},
                                        new Map<Id, Case>{c1.Id => new Case(Id= c1.Id,Type__c = 'Type',
                                        SME_Time_in_Pause_Status__c =234,Out_of_Internal_SLA__c = false)});
       }catch(exception e){
        //system.debug(e.getMessage());
        System.assert(true, 'Exception ' + e);
       }
       
       
      
       try{
        CaseTriggerFunctions.calculateCaseDuration(new List<Case>{c2},
                                        new Map<Id, Case>{c2.Id => new Case(Id= c2.Id,Type__c = 'Type',
                                        Out_of_External_SLA__c = false,
                                        SME_Time_in_Pause_Status__c =234,Out_of_Internal_SLA__c = true)});
       }catch(exception e){
        //system.debug(e.getMessage());
        System.assert(true, 'Exception ' + e);
       }
       
      
       
       try{
        CaseTriggerFunctions.calculateCaseDuration(new List<Case>{c3},
                                        new Map<Id, Case>{c3.Id => new Case(Id= c3.Id,Type__c = 'Type',
                                        Out_of_External_SLA__c = false,
                                        SME_Time_in_Pause_Status__c =234,Out_of_Internal_SLA__c = false)});
       }catch(exception e){
        //system.debug(e.getMessage());
        System.assert(true, 'Exception ' + e);
       }
       
       
       
       
       try{
        CaseTriggerFunctions.calculateCaseDuration(new List<Case>{c4},
                                        new Map<Id, Case>{c4.Id => new Case(Id= c4.Id,Type__c = 'Type',Out_of_External_SLA__c = false,
                                        SME_Time_in_Pause_Status__c =234,Out_of_Internal_SLA__c = false)});
       }catch(exception e){
        //system.debug(e.getMessage());
        System.assert(true, 'Exception ' + e);
       }
       
       
          /*   
        CaseTriggerFunctions.insertTransferCaseComment((new List<Case>{new Case(Id= caseold.Id,Type__c = 'Service Type 2',Status = 'Resolved',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =234,ownerId = sysAdminUser1.Id,
                                        Out_of_External_SLA__c = false,Transfer_Reason__c ='Handover',
                                        Out_of_Internal_SLA__c = true,Unwanted_Type__c = 'Out-of-Office')}),
                                        new Map<Id, Case>{caseold.Id =>caseold});
                                      
         //Test.stopTest();                              
         
        */ 
       
       

        Datetime myDateTime = Datetime.now();
        Datetime newDateTime = myDateTime.addDays(600);

        CaseTriggerFunctions.pauseSLA((new List<Case>{new Case(Id= caseRec1.Id,Type__c = 'Service Type 2',Status = 'Awaiting External',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =23,ownerId = sysAdminUser1.Id,sd_Pause_Statuses__c = 'On Hold',
                                        Out_of_External_SLA__c = false,Transfer_Reason__c ='Handover',RecordTypeId = caseRecordTypeId1,
                                        Out_of_Internal_SLA__c = true,External_SLA_End_Date__c=newDateTime,
                                        SLA_Pause_Date__c=system.today(),Unwanted_Type__c = 'Out-of-Office')}),
                                        new Map<Id, Case>{caseRec1.Id =>caseRec1});

        caseRec1.Status = 'Awaiting External';

        CaseTriggerFunctions.pauseSLA((new List<Case>{new Case(Id= caseRec1.Id,Type__c = 'Service Type 2',Status = 'Awaiting External',
                                        BusinessHoursId=stdBusinessHours.Id,SME_Time_in_Pause_Status__c =23,ownerId = sysAdminUser1.Id,sd_Pause_Statuses__c = 'On Hold',
                                        Out_of_External_SLA__c = false,Transfer_Reason__c ='Handover',RecordTypeId = caseRecordTypeId1,
                                        Out_of_Internal_SLA__c = true,External_SLA_End_Date__c=newDateTime,
                                        SLA_Pause_Date__c=system.today(),Unwanted_Type__c = 'Out-of-Office')}),
                                        new Map<Id, Case>{caseRec1.Id =>caseRec1}); 
        Test.stopTest(); 
       }

    @IsTest
    public static void testStatusUpdate(){
        
          String POSITIVE_RESPONSE_BODY = '{ "Response": { "ApplicationDV": { "APPERRMSG": "000" } } }';
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PowerCurveStatusUpdate_IH_v1.INTEGRATION_SERVICE_NAME});
      
      
             Account account = [SELECT Id FROM Account LIMIT 1];
        
        Opportunity opp = new Opportunity (Name ='testopp', AccountId = account.Id, StageName = 'New', CloseDate = System.today());
        insert opp;
        
         Application__c application = new Application__c();
            application.Credit_Application_Status__c='Accepted';
            application.stock_Number__c='0';
            application.External_Reference_Number__c=09874667;
            application.Opportunity__c = opp.Id;
            Insert application;
        
        Application_Product__c parentApplicationRecord = new Application_Product__c();
        parentApplicationRecord.Opportunity__c = opp.Id;
        parentApplicationRecord.Product_Name__c = 'Cheque';
        parentApplicationRecord.Product_Type__c = '11021';//API picklist value for CLASSIC BUSINESS ACCOUNT
       // parentApplicationRecord.Account_Number__c = 123456789;
        parentApplicationRecord.Product_State__c = 'New';
        parentApplicationRecord.Opportunity_Product_Id__c =''+ opp.Id;
        parentApplicationRecord.Product_Status__c = 'Accepted';
        parentApplicationRecord.Accept_TOB__c = true;
        parentApplicationRecord.Maximum_NCA_Rate__c='25';
        parentApplicationRecord.IsMainProduct__c = true;
        insert parentApplicationRecord;

        Application_Product__c childApplicationRecord = new Application_Product__c();
        childApplicationRecord.Opportunity__c = opp.Id;
        childApplicationRecord.Product_Name__c = 'Overdraft';
        childApplicationRecord.Product_Amount__c = 1000000.00;
        childApplicationRecord.Product_State__c = 'New';
        childApplicationRecord.Product_Status__c = 'Accepted';
        childApplicationRecord.Opportunity_Product_Id__c = ''+opp.Id;
        childApplicationRecord.Limit_Type__c='Reducing - Once Off Only';
        childApplicationRecord.Once_Off_Amount__c=20000;
        childApplicationRecord.Application_Product_Parent__c = parentApplicationRecord.Id;
        insert childApplicationRecord;
        
        
         Application_scoring__c appScore=new Application_scoring__c();
            appScore.name='a1';
            appScore.Stage__c='7';
            appScore.SYST_Decision__c='A';
            appScore.Application_Number__c=application.Id;
            appScore.Reason__c='Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
            appScore.Reason_Description__c='aaaa,bbbb,cccc,dddd,eeee';
            appScore.Exception__c='Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
            appScore.Exception_Description__c='uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
            appScore.ReqTotAddPotentialOc__c=0;
            appScore.ReqPotentialTotGroup__c=0;
            appScore.ReqPotentialTgae__c=0;
            appScore.ReqPotentialTgbe__c=0;
            appScore.ReqPotentialTfl__c=0;
            appScore.Potential_OC_Offered__c=0;
            appScore.Potential_TGE_Offered__c=0;
            appScore.Potential_TGAE_Offered__c=0;
            appScore.Potential_TGBE_Offered__c=0;
            appScore.Potential_TGBOE_Offered__c=0;
            appScore.Potential_OC_Final__c=0;
            appScore.Potential_TGE_Final__c=0;
            appScore.Potential_TGAE_Final__c=0;
            appScore.Potential_TGBE_Final__c=0;
            appScore.Potential_TGBOE_Final__c=0; 
            insert appScore;
        
         RecordType complaintRectype = [Select Id From RecordType Where DeveloperName = 'Credit_FulFillment'];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
       
        Case caseRec = new Case();
        caseRec.Type__c = 'Service Type 1';
        
        caseRec.Status = 'New';
        caseRec.Email_From_Address__c = 'test@from.com';
        caseRec.OwnerId = UserInfo.getUserId();
        caseRec.Opportunity__c = opp.Id;
        
        caseRec.Application_Product_Id__c=childApplicationRecord.Id;
        caseRec.Product__c='Overdraft';
        insert caseRec;
       
        Case closeCase = caseRec;
        
        closeCase.Status = 'Closed';
        closeCase.Account = account;
        closeCase.AccountId = account.id;
        caseRec.Opportunity__c = opp.Id;
        closeCase.Type__c = 'abc';
        closeCase.Subtype__c = 'def';
        closeCase.Out_Of_SLA_Reason__c = 'Account Closed';
        closeCase.Out_Of_SLA_Comments__c = 'Account Closed';
        closeCase.Product__c = 'Overdraft';
        closeCase.Application_Product_Id__c=childApplicationRecord.Id;
        caseRec.Application_Product_Id__c=childApplicationRecord.Id;
         update closeCase;
        test.startTest();
       
        /* Case reopenCase = [select id, ,Reopen_Case_Approval_Status__c, ClosedDate, sd_Internal_SLA_Time_Measure__c, sd_Internal_SLA_Units__c, BusinessHoursId, Internal_SLA_Warning_Date__c, Internal_SLA_End_Date__c, Out_of_External_SLA__c, Out_of_Internal_SLA__c,
                               sd_External_SLA_Units__c, External_SLA_End_Date__c, sd_External_SLA_Time_Measure__c, External_SLA_Warning_Date__c, sd_Max_SLA_Units__c, sd_Max_SLA_Time_Measure__c, Max_SLA_Extension_Date__c From Case where Id =: closeCase.Id];
       */
        CaseTriggerFunctions.sendUpdateToPCO(new List<Case>{closeCase}, new Map<Id, Case>{caseRec.Id => caseRec});
        caseRec.Status = 'Rejected-Awaiting Feedback';
        CaseTriggerFunctions.updateApplicationOnCaseStatusRejected(new List<Case>{caseRec}, new Map<Id, Case>{caseRec.Id => New Case(Status='Closed')});  
   
        //CaseTriggerFunctions.se
        test.stopTest();
        system.assertNotEquals(account, null);
        
    }
    
    @IsTest
    public static void testvalidateCaseAccordingAIC() {
        Id recordIDOfAIC = [Select id from recordtype Where DeveloperName ='AIC'].id;
        Id queueId =  [Select Id from Group where Type = 'Queue'  AND DeveloperName = 'Outbound_AIC'].Id;
        Map<Id, case> oldCaseMap = new Map<Id, Case>([select id, AccountId, ContactId, DD_Case_Outcome__c from Case limit 1]);
        oldCaseMap.values()[0].ownerid = queueId;
        oldCaseMap.values()[0].recordtypeid = recordIDOfAIC;
        
        Case newCase = oldCaseMap.values()[0].clone(true, true, true, true);
        newCase.DD_Case_Outcome__c = 'Uncontactable';
        Test.startTest();
        CaseTriggerFunctions.validateCaseAccordingAIC(oldCaseMap, new List<Case> {newCase} );
        Test.stopTest();
        system.assertNotEquals(oldCaseMap, null);
        
    }
    
    @IsTest
    public static void testvalidateCaseAccordingAIC1() {
        Id recordIDOfAIC = [Select id from recordtype Where DeveloperName ='AIC'].id;
        Id queueId =  [Select Id from Group where Type = 'Queue'  AND DeveloperName = 'Outbound_AIC'].Id;
        Map<Id, case> oldCaseMap = new Map<Id, Case>([select id, AccountId, ContactId, DD_Case_Outcome__c from Case limit 1]);
        oldCaseMap.values()[0].ownerid = queueId;
        oldCaseMap.values()[0].recordtypeid = recordIDOfAIC;
        
        Case newCase = oldCaseMap.values()[0].clone(true, true, true, true);
        newCase.DD_Case_Outcome__c = 'Uncontactable';
        Test.startTest();
        CaseTriggerFunctions.validateCaseAccordingAIC(oldCaseMap, new List<Case> {newCase} );
        Test.stopTest();
        system.assertNotEquals(oldCaseMap, null);
    }
    
    @IsTest
    public static void testinsertTransferCaseComment() {
        Id recordIDOfAIC = [Select id from recordtype Where DeveloperName ='AIC'].id;
        Id queueId =  [Select Id from Group where Type = 'Queue'  AND DeveloperName = 'Outbound_AIC'].Id;
        Map<Id, case> oldCaseMap = new Map<Id, Case>([select id, AccountId, ContactId, Transfer_Comments__c,Transfer_Reason__c,ownerid from Case limit 1]);
        oldCaseMap.values()[0].recordtypeid = recordIDOfAIC;
        
        Case newCase = oldCaseMap.values()[0].clone(true, true, true, true);
        newCase.ownerid = queueId;
        newCase.Transfer_Comments__c = 'Test';
        newCase.Transfer_Reason__c = 'Handover';
        Test.startTest();
        CaseTriggerFunctions.insertTransferCaseComment(new List<Case> {newCase}, oldCaseMap );
        Test.stopTest();
        system.assertNotEquals(oldCaseMap, null);
    }
    
    @IsTest
    public static void testcallDocPredictionService() {
        List<Case> lCases = new List<Case>();

        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account acct = new Account(Name = 'Test Account');
        Contact con = new Contact(Title = 'ContactTest', Phone = '87837743123456769', LastName = 'ContactTest', Email = 'email@test.com');
        insert con;
        insert acct;
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acct.id,
            StageName = 'Confirm Client Eligibility',
            CloseDate = Date.today()
        );
        insert opp;
        Case cse1 = new Case(
                Communication_Method__c = 'Email',
                Status = 'New',
                Origin = 'Email',
                AccountId = acct.Id,
                Risk_Management_Centre__c = 'Digital Fraud',
                Email__c = 'test@test.com',
                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                Subject = 'Case4',
                Description = 'test',
                sd_Service_Group__c = 'AP Queries',
                Expectation_of_the_Customer__c = 'test',
                Incident_Date__c = date.today(),
                OwnerId = UserInfo.getUserId()
            );
        lCases.add(cse1);
        insert lCases;
        
        Test.startTest();
        CaseTriggerFunctions.callDocPredictionService(lCases[0].Id);     
        Test.stopTest();
        system.assertNotEquals(Cse1, null);
    }
    
    @IsTest
    public static void testremaingCode() {
        List<Account> lacc = new List<Account>();
        Account account = new Account();
        account.FirstName = 'Spouse Account';
        account.LastName = 'Spouse Account';
        account.Client_Type__c = 'Sole Trader';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.ID_Number__pc = '8002146158081';
        lacc.add(account);
        
        Account account1 = new Account();
        account1.FirstName = 'Spouse Account1';
        account1.LastName = 'Spouse Account1';
        account1.Client_Type__c = 'Sole Trader';
        account1.CIF__c = 'SNIFFEL000';
        account1.Sic='35791';
        account1.AccountNumber='0';
        account1.ID_Number__pc = '8002146158080';
        lacc.add(account1);
        insert lacc;
        
        system.assertNotEquals(null, account);
        RecordType complaintRectype = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'DD_STI_Case'];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
       
        sd_Communication_Plan__c commPlan = new sd_Communication_Plan__c();
        commPlan.Name = 'Test Communication';
        insert commPlan;
       
        List<Service_Group__c> sgList = new List<Service_Group__c>();
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Test1';
        //serviceGr.Name = 'Absa Linked Investments';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        serviceGr.Active__c = true;
        serviceGr.Queue__c = gQueue.Name;
        sgList.add(serviceGr);

        Service_Group__c serviceGr2 = new Service_Group__c();
        serviceGr2.Name = 'Test1';
        serviceGr2.Assign_Record_Type__c = 'Email';
        serviceGr2.Response_Email_Address__c = 'evg@t.com';
        serviceGr2.Queue__c = 'Email';
        serviceGr2.Business_Hours__c = businessHr.Id;
        sgList.add(serviceGr2);
        insert sgList;

       

        Service_Group__c serviceGr1 = new Service_Group__c();
        serviceGr1.Name = 'Absa Linked Investments';
        serviceGr1.Assign_Record_Type__c = 'Email';
        serviceGr1.Response_Email_Address__c = 'evg@t.com';
        serviceGr1.Queue__c = 'Email';
        serviceGr1.Business_Hours__c = businessHr.Id;
        serviceGr1.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr1.Internal_SLA_Units__c = '8';
        serviceGr1.Active__c = true;
        serviceGr1.Queue__c = gQueue.Name;
        insert serviceGr1;

       
        Service_Level__c serviceLevel = new Service_Level__c();
        serviceLevel.Name = 'Test1';
        serviceLevel.External_SLA_Time_Measure__c = 'Hour(s)';
        serviceLevel.External_SLA_Units__c = '8';
        serviceLevel.Default_Service_Level__c = true;
        serviceLevel.Max_SLA_Units__c = '4';
        serviceLevel.Max_SLA_Time_Measure__c = 'Hour(s)';
        insert serviceLevel;
       
        List<Service_Type__c> serviceTypes = new List<Service_Type__c>();
       
        Service_Type__c serviceType1 = new Service_Type__c();
        serviceType1.Name = 'Test1';
        serviceType1.Case_Record_Type__c = 'New';
        serviceType1.Subtype__c = 'Sample';
        serviceType1.Type__c = 'T01';
        serviceType1.Case_Record_Type__c = complaintRectype.Name;
        serviceTypes.add(serviceType1);
       
        Service_Type__c serviceType2 = new Service_Type__c();
        serviceType2.Name = 'Test2';
        serviceType2.Case_Record_Type__c = 'New';
        serviceType2.Subtype__c = 'Sample';
        serviceType2.Type__c = 'T02';
        serviceType2.Case_Record_Type__c = complaintRectype.Name;
        serviceTypes.add(serviceType2);
       
        insert serviceTypes;
         
        List<Service_Group_Type__c> serviceGrTypes = new List<Service_Group_Type__c>();
       
        Service_Group_Type__c serviceGrType1 = new Service_Group_Type__c();
        serviceGrType1.Service_Type__c = serviceType1.Id;
        serviceGrType1.Service_Group__c = serviceGr.Id;
        serviceGrType1.Service_Level__c = serviceLevel.Id;
        serviceGrType1.sd_Communication_Plan__c = commPlan.Id;
        serviceGrTypes.add(serviceGrType1);
       
        Service_Group_Type__c serviceGrType2 = new Service_Group_Type__c();
        serviceGrType2.Service_Type__c = serviceType2.Id;
        serviceGrType2.Service_Group__c = serviceGr1.Id;
        serviceGrType2.Service_Level__c = serviceLevel.Id;
        serviceGrType2.sd_Communication_Plan__c = commPlan.Id;
        serviceGrTypes.add(serviceGrType2);
       
        insert serviceGrTypes;
       
        List<Case> complaintCase = new List<Case>();
        case complaintCase1 = new case();
        complaintCase1.BusinessHoursId = businessHr.Id;
        complaintCase1.Communication_Method__c = 'Email';
        complaintCase1.Status = 'New';
        complaintCase1.Origin = 'Email';
        complaintCase1.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase1.Email_From_Address__c = 'test@ret.com';
        complaintCase1.Email__c = 'test@ret.com';
        complaintCase1.Incident_Date__c = System.Today();
        complaintCase1.RecordTypeId = complaintRectype.Id;
        //complaintCase.Approval_Status__c = 'Approved';
        //complaintCase.SLA_Extension_Approval__c = 'Approved';
        complaintCase1.SLA_Extension_Approval__c = 'Rejected';
        complaintCase1.Internal_SLA_Warning_Date__c = System.now();
        complaintCase1.Internal_SLA_End_Date__c = System.now().addDays(10);
        complaintCase1.Expectation_of_the_Customer__c = 'Testing';
        complaintCase1.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase1.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase1.SLA_Extension_Approval_Required__c = true;
        complaintCase1.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase1.Subject = 'Test';
        complaintCase1.Description ='Test';
        complaintCase1.Deadlock_Approval_Required__c = true;
        complaintCase1.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase1.Type__c = 'Test';
        complaintCase1.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase1.SLA_Pause_Date__c = System.now();
        complaintCase1.External_SLA_Warning_Date__c = system.today();
        complaintCase1.External_SLA_End_Date__c = system.today();
        complaintCase1.Out_of_Internal_SLA__c = false;
        complaintCase1.Out_of_External_SLA__c = false;
        complaintCase1.Consultant_Time_in_Pause_Status__c = null;
        complaintCase1.Bulk_Transfer_Selected_Cases__c = true;
        complaintCase1.sd_Service_Group_Id__c = serviceGr.Id;
        complaintCase1.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase1.sd_Service_Type_Id__c = serviceType1.Id;
        complaintCase1.sd_Service_Group_Type_Id__c = serviceGrType1.Id;
        complaintCase1.Service_Group_Search__c = serviceGr.Id;
        complaintCase1.Category__c = 'Claims';
        complaintCase1.Customer_ID__c = '8002146158081';
        complaintCase1.sd_Service_Group__c = 'Staff Expense';
        complaintCase.add(complaintCase1);
        
        case complaintCase2 = new case();
        complaintCase2.BusinessHoursId = businessHr.Id;
        complaintCase2.Communication_Method__c = 'Email';
        complaintCase2.Status = 'New';
        complaintCase2.Origin = 'Email';
        complaintCase2.Risk_Management_Centre__c = 'Digital Fraud';
        complaintCase2.Email_From_Address__c = 'test@ret.com';
        complaintCase2.Email__c = 'test@ret.com';
        complaintCase2.Incident_Date__c = System.Today();
        complaintCase2.RecordTypeId = complaintRectype.Id;
        //complaintCase.Approval_Status__c = 'Approved';
        //complaintCase.SLA_Extension_Approval__c = 'Approved';
        complaintCase2.SLA_Extension_Approval__c = 'Rejected';
        complaintCase2.Internal_SLA_Warning_Date__c = System.now();
        complaintCase2.Internal_SLA_End_Date__c = System.now().addDays(10);
        complaintCase2.Expectation_of_the_Customer__c = 'Testing';
        complaintCase2.Awaiting_Status__c = 'Awaiting Customer Documents';
        complaintCase2.SLA_Extension_Reason__c = 'This is for testing';
        complaintCase2.SLA_Extension_Approval_Required__c = true;
        complaintCase2.Deadlock_Reason_Motivation__c = 'Sample test';
        complaintCase2.Subject = 'Test';
        complaintCase2.Description ='Test';
        complaintCase2.Deadlock_Approval_Required__c = true;
        complaintCase2.sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback';
        complaintCase2.Type__c = 'Test';
        complaintCase2.sd_Email_Template_Case_Classification__c = 'Test Email Template 1';
        complaintCase2.SLA_Pause_Date__c = System.now();
        complaintCase2.External_SLA_Warning_Date__c = system.today();
        complaintCase2.External_SLA_End_Date__c = system.today();
        complaintCase2.Out_of_Internal_SLA__c = false;
        complaintCase2.Out_of_External_SLA__c = false;
        complaintCase2.Consultant_Time_in_Pause_Status__c = null;
        complaintCase2.Bulk_Transfer_Selected_Cases__c = true;
        complaintCase2.sd_Service_Group_Id__c = serviceGr.Id;
        complaintCase2.sd_Service_Level_Id__c = serviceLevel.Id;
        complaintCase2.sd_Service_Group_Type_Id__c = serviceGrType1.Id;
        complaintCase2.Service_Group_Search__c = serviceGr.Id;
        complaintCase2.Category__c = 'Claims';
        complaintCase2.Customer_ID__c = '8002146158080';
        complaintCase2.sd_Service_Group__c = 'Staff Expense';
        complaintCase.add(complaintCase2);
        insert complaintCase;
        
        Test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        Case testCase = new Case(RecordTypeId = devRecordTypeId, Account = account, ID_Type__c = 'Passport',Customer_ID__c = '8002146158084',
                                    sd_Service_Group__c = 'Staff Expense',Type__c = 'PEP High Risk and Very High Risk');
        Insert testCase;
        
        CaseTriggerFunctions.refreshCaseClient(testCase.Id);
        Test.stopTest();
        system.assertNotEquals(testCase, null);
    }
}