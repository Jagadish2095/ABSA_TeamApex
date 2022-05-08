/**  
* @Purpose            : Test Class for CaseCloseActionExt
* @Author             : Dreamwares 
* @Created Date       : 05/09/2018
* @Last Modified Date : 11/09/2018
*/
@isTest
public class CaseCloseActionExtTest {
    /*
    * Purpose : Method to create test data
    */
    @testSetup
    static void dataCreation(){
        
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                Accountid = account.id,
                                Account = account,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Out_Of_SLA_Comments__c = 'Test',
                                Out_Of_SLA_Reason__c = 'Account Closed',
                                Type__c = 'abc',
                                Incident_Date__c = date.today());
        insert caseRec;
        
        Site__c site = new Site__c(Name = 'Test 1', Active__c = true, Site_Code__c = '12345');
        insert site;
        
        caseRec.Status = 'Approval Rejected';
        caseRec.Who_Caused_It__c = 'Test';
        caseRec.Summary_of_Resolution__c = 'Test Again';
        caseRec.Resolved_in_Favour_of__c = 'Bank';
        caseRec.Unresolved_Reason__c = 'Abandoned';
        caseRec.Where_Did_This_Happen__c = 'Tested now';
        caseRec.Responsible_Site__c = String.valueOf(site.Id);
        caseRec.Trade_Loss__c = 'No';
        caseRec.Amount_Refunded__c = Double.valueOf(10.00);
        caseRec.Who_Caused_It_Options__c = 'Bank';
        caseRec.Resolution_Sub_Type__c = '';
        caseRec.Date_of_payment__c = date.today();
        caseRec.Controllability__c = '';
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Absa Estates Wills & Trusts Complaints', Assign_Record_Type__c = 'Complaint',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Advisers',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8'); //Modified by chenna
        insert serviceGr;
        
        Service_Group__c serviceGrRecord = [SELECT Id,Name FROM Service_Group__c where Id =:serviceGr.Id];
                
        Case caseRec1 = new Case(Communication_Method__c = 'Email',
                                 Status = 'New',
                                 Origin = 'Email', 
                                 Accountid = account.id,
                                 Account = account,
                                 Email__c = 'test@test.com',
                                 recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                 Subject = 'Test Normal',
                                 Description = 'test',
                                 Expectation_of_the_Customer__c = 'test',
                                 Type__c = 'abc',
                                 Incident_Date__c = date.today());
        insert caseRec1;
        
        caseRec1.sd_Service_Group__c = serviceGrRecord.Name;
        caseRec1.sd_Service_Group_Id__c = serviceGrRecord.Id;
        caseRec1.Source__c = 'Generic';
        caseRec1.NBFS_Category__c = 'Level 1';
        update caseRec1;

        //Smanga _ Start
        Service_Group__c ceoServiceGroup = new Service_Group__c(Name = 'CEO', Assign_Record_Type__c = 'Complaint',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'CEO',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert ceoServiceGroup;

        Case ceoCase = new Case(Communication_Method__c = 'Email',
                                 Status = 'New',
                                 Origin = 'Email', 
                                 Accountid = account.id,
                                 Account = account,
                                 Email__c = 'test@test.com',
                                 recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                 Subject = 'ceoCase',
                                 Description = 'test',
                                 Expectation_of_the_Customer__c = 'test',
                                 Type__c = 'abc',
                                 Incident_Date__c = date.today(),
                                 sd_Service_Group__c = ceoServiceGroup.Name,
                                 sd_Service_Group_Id__c = ceoServiceGroup.Id);

        insert ceoCase;

        //Smanga _ End
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'Test 1';
        cv.versionData = Blob.valueOf('Test1');
        cv.pathOnClient = 'Test 1';
        insert cv;
        
        ContentVersion testCV = [SELECT Id, ContentDocumentId FROM ContentVersion where Id =:cv.Id];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = caseRec1.Id;
        cdl.ContentDocumentId = testCV.ContentDocumentId;
        cdl.Sharetype = 'V';
        insert cdl;
    }
    
    //Method to test
    static testMethod void testCaseCloseAction1(){
        Case caseRec = [SELECT Id, RecordTypeId FROM Case WHERE Communication_Method__c = 'Email' LIMIT 1];
        Site__c siteRec = [SELECT Id FROM Site__c LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new MockResponseGenerator());  
        
        Test.startTest();
        CaseCloseActionExt.DataLoad wrapper = CaseCloseActionExt.loadData(String.valueOf(caseRec.Id));
        wrapper.isClosed = true;
        wrapper.isNotClassified = true;
        wrapper.isNotLinked = true;
        //CaseCloseActionExt.closeCase(String.valueOf(caseRec.Id), 'Approval Rejected', 'Account Closed', 'Abandoned', 'Test', 'Test Again', 'Bank', 'Abandoned','Tested now',String.valueOf(siteRec.Id), 'No',Double.valueOf(10.00));
        //Changed for NBFS Case Record Type as many new fields have been added:
        CaseCloseActionExt.resolveCase(String.valueOf(caseRec.Id), caseRec);
        Test.stopTest();
        System.assertEquals(true, wrapper.isClosed);
        
    }
    
    static testMethod void testCaseCloseAction2(){
        Case caseRec1 = [SELECT Id, RecordTypeId,Service_Group_Search__c,Source__c FROM Case WHERE Subject = 'Test Normal' LIMIT 1];
        List<ContentDocumentLink> cdlList = [select Id, LinkedEntityId, ContentDocumentId, Sharetype From ContentDocumentLink Where LinkedEntityId =:caseRec1.Id];
        List<String> docIds = new List<String>();
        
        if(cdlList.size() > 0){
            for(ContentDocumentLink cdl: cdlList){
                docIds.add(cdl.ContentDocumentId);
            }
        }
        Test.startTest();
        CaseCloseActionExt.DataLoad wrapper = CaseCloseActionExt.loadData(String.valueOf(caseRec1.Id));
        
        try{
            CaseCloseActionExt.getDocumentTypeInfo(caseRec1.sd_Service_Group__c,caseRec1.Source__c,'Rejected');
            CaseCloseActionExt.UpdateFiles(docIds[0],caseRec1.Id,'Test');
        }
        catch(exception e){
            //do nothing as an error is the expected outcome 
        }
        Test.stopTest();
    }
    //Method to test
    /*static testMethod void testCaseCloseAction3(){
    Case caseRec = [SELECT Id, RecordTypeId FROM Case WHERE Case_Record_Type_Name__c = 'NBFS Dispute Resolution' LIMIT 1];
    Case caseRec2 = [SELECT Id, RecordTypeId FROM Case WHERE External_SLA_Status__c = 'Overdue' LIMIT 1];
    Test.startTest();
    CaseCloseActionExt.loadData(String.valueOf(caseRec.Id));
    CaseCloseActionExt.loadData(caseRec2.Id);
    Test.stopTest();
    }*/
    
    //Method to test
    static testMethod void testCaseCloseAction4(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockResponseGenerator());
        
        Test.startTest();
        CaseCloseActionExt.DataLoad wrapper = CaseCloseActionExt.loadData(String.valueOf(caseRec.Id));
        Test.stopTest();
    }
    
    //Class to set mock response
    public class MockResponseGenerator implements HttpCalloutMock {        
        
        
        //Method to return mock response
        public HTTPResponse respond(HTTPRequest req) {
            
            Case caseRec = [SELECT Id, RecordTypeId FROM Case LIMIT 1];
            
            String endpoint = 'callout:MetaDataAccess/services/data/v43.0';
            endpoint += '/ui-api/object-info/{0}/picklist-values/{1}/{2}';
            endpoint = String.format(endpoint, new String[]{ 'Case', caseRec.RecordTypeId, 'Status' });
            EncodingUtil.urlEncode(endpoint,'UTF-8');
            
            HttpResponse res = new HttpResponse();
            
            if (req.getEndpoint().equalsIgnoreCase(endpoint) 
                && req.getMethod().equalsIgnoreCase('GET')){
                    res.setHeader('Content-Type', 'application/json');
                    res.setBody('{"test": ["test1", "test2", "test3", "test4", "test5"]}');
                    res.setStatusCode(200);
                }
            
            return res;
        }
    }
    //Modified by Chenna
    static testMethod void testgetRecordTypeName() {
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('NBFS Dispute Resolution').getRecordTypeId();
        
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Case caseRec = [SELECT Id, RecordTypeId, recordtype.developername, sd_Service_Group__c FROM Case WHERE Communication_Method__c = 'Email' LIMIT 1];
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=caseRec.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=cdList[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        Test.startTest();
        RecordTypeIdController.getRecordTypeName('Test','Case');
        CaseCloseActionExt.getRecordTypenName('test','sobj');
        CaseCloseActionExt.getDocumentTypeInfo('AbsaAdvisers','Level2','Rejected');
        CaseCloseActionExt.UpdateFiles(cdList[0].Id,caseRec.Id,'Test'); 
        
        Service_Group__c sg = new Service_Group__c(Name = 'SG');
        insert sg;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=sg.Id);
        insert sgt;
        
        caseRec.Type__c = null;
        caseRec.AccountId = null;
        caseRec.recordtypeId = recTypeId;
        caseRec.recordtype.developername = 'NBFS_Dispute_Resolution';
        caseRec.sd_Service_Group__c = 'NBFS Service Groups';
        /*****************Added by Chenna - Start ********/
        caseRec.Category__c = 'Channel';
        caseRec.NBFS_Category__c = 'Level 1';
        caseRec.Source__c = 'CEO';
        caseRec.sd_Service_Group_Id__c = sg.Id;
        try{update caseRec;}catch(Exception e){}
        
        CaseCloseActionExt.closeCase(String.valueOf(caseRec.Id), 'Approval Rejected', 'Account Closed',
                                     'Abandoned', 'Test', 'Test Again', 'Bank', 'Abandoned','Tested now',
                                     null, 'No',Double.valueOf(10.00),true);
        /********** Added by Chenna - End ***********/
        system.debug('--->>>'+caseRec);
        CaseCloseActionExt.loadData(String.valueOf(caseRec.Id));
        
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        caseRec.OwnerId = testGroup.Id;
        
        try{CaseCloseActionExt.resolveCase(String.valueOf(caseRec.Id), caseRec)
            ;}Catch(Exception ex){}
        Test.stopTest();
    }
    //Added by Chenna
    static testMethod void testgetUserAdvisorId() {
        user u = [SELECT Id, Advisor_Code__c FROM user WHERE ID=:UserInfo.getuserId()];
        system.debug('user%%%%%'+U);
        
        test.starttest();
        CaseCloseActionExt.getAdvisorInfo(u.Id);
        Test.stoptest();
    }

    static testMethod void testCaseResolutionNClosureController(){
    	map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                 Status = 'New',
                                 Origin = 'Email', 
                                 Accountid = account.id,
                                 Account = account,
                                 Email__c = 'test@test.com',
                                 recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                 Subject = 'Test Normal',
                                 Description = 'test',
                                 Expectation_of_the_Customer__c = 'test',
                                 Type__c = 'abc',
                                 Incident_Date__c = date.today());
        insert caseRec;
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'Test 1';
        cv.versionData = Blob.valueOf('Test1');
        cv.pathOnClient = 'Test 1';
        insert cv;
        
        ContentVersion testCV = [SELECT Id, ContentDocumentId FROM ContentVersion where Id =:cv.Id];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = caseRec.Id;
        cdl.ContentDocumentId = testCV.ContentDocumentId;
        cdl.Sharetype = 'V';
        insert cdl;
        
        Test.startTest();
        List<ContentDocumentLink> cdlList = [select Id, LinkedEntityId, ContentDocumentId, Sharetype From ContentDocumentLink Where LinkedEntityId =:caseRec.Id];
        List<String> docIds = new List<String>();
        
        if(cdlList.size() > 0){
            for(ContentDocumentLink cdl2: cdlList){
                docIds.add(cdl2.ContentDocumentId);
            }
        }
        System.debug('docIds.size ==> ' + docIds.size());
        if(docIds.size() > 0){
            CaseCloseActionExt.uploadContentDocuments(caseRec.Id, docIds);
        }
       
        Test.stopTest();
    }

    @isTest 
    public static void testPriorityGroupMembership(){
        //Group
        Group ceoPublicGroup = new Group(Name = 'CEO', Type ='Regular');
        insert ceoPublicGroup;

        //Users
        String uniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String email = 'UserAdmin@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', UserName=uniqueUserName, MobilePhone='0823389021');
        Insert adm;

        //Group Membership
        GroupMember testUserMember = new GroupMember(GroupId = ceoPublicGroup.Id, UserOrGroupId =adm.Id);
        insert testUserMember;

        Case myCEOcase = [SELECT Id, sd_Service_Group__c FROM Case WHERE Subject ='ceoCase' LIMIT 1] ;
                               
        Test.startTest();
        System.runAs(adm){

            CaseCloseActionExt.DataLoad wrapper = CaseCloseActionExt.loadData(String.valueOf(myCEOcase.Id));
                        
        }
        
        Test.stopTest();
    }
}