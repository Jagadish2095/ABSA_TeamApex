/**  
 * @Purpose      : Test Class for CaseExtendSlaActionExt
 * @Author       : Dreamwares 
 * @Created Date : 05/09/2018
 */
@isTest
public class CaseExtendSlaActionExtTest {
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
                                Account = account,
                                SLA_Extension_Approval_Required__c = true, 
                                External_SLA_End_Date__c = Date.today(),
                                Accountid = Account.id,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        
        
        /*Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                         Response_Email_Address__c = 'evg@t.com',
                                                         Business_Hours__c = businessHr.Id,
                                                         Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                         Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Email_Template_Case_Classification__c = 'Test1',
                                                                        Email_Template_Case_Closure__c = 'Test2',
                                                                        External_SLA_Time_Measure__c = 'Hour(s)',
                                                                        External_SLA_Units__c = '10',
                                                                        Max_SLA_Time_Measure__c = 'Hour(s)',
                                                                        Max_SLA_Units__c = '10',
                                                                        Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id);
        insert serviceGrType;*/
    }
    
    //Method to test
    static testMethod void testCaseExtendSlaAction(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        //Added By Chenna Reddy -Start
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id queueId =[select Id, Name from Group where  Type = 'Queue' AND Name='2FA'].Id;
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        DateTime newDate = DateTime.Now().AddDays(20);
        Case caseRec1 = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                Account = account,
                                SLA_Extension_Approval_Required__c = true, 
                                External_SLA_End_Date__c = Date.today(),
                                Accountid = Account.id,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                //OwnerId=queueId,
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Max_SLA_Extension_Date__c=newDate);
         insert caseRec1;
       //Added By Chenna Reddy -End
        Test.startTest();
        Case testCase = CaseExtendSlaActionExt.getCaseRecord(String.valueOf(caseRec.Id));
        System.assertEquals(testCase.Id, caseRec.Id);
        try{
            CaseExtendSlaActionExt.extendExternalSLA(String.valueOf(caseRec.Id), 'Test', Date.today(), false );
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
        Boolean result = CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec.Id), 'Test', '10', 'Hour', Date.today());
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec.Id), 'Test', '10', 'Day', Date.today());
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec.Id), 'Test', '10', 'Week', Date.today());
        Boolean appResult = CaseExtendSlaActionExt.approvalProccessChecks(String.valueOf(caseRec.Id));
        try{
        //Added By Chenna Reddy -Start
        Boolean result1 = CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec1.Id), 'Test', '1', 'Hour', Date.today());
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec1.Id), 'Test', '1', 'Day', Date.today());
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec1.Id), 'Test', '1', 'Week', Date.today());
        Boolean appResult1 = CaseExtendSlaActionExt.approvalProccessChecks(String.valueOf(caseRec1.Id));
        }
        catch(exception e){}
        //Added By Chenna Reddy -End
        CaseExtendSlaActionExt.getHolidays();
        Test.stopTest();
        //System.assertEquals(true, appResult);
    }
    
    //Method to test
    static testMethod void negTestCaseExtendSlaAction(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        /******************** Added by Kalyani ********************/
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
               
        String contentdocumentid = [select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        
        Test.startTest();
        String returnstr = CaseExtendSlaActionExt.updateContentDocument(caseRec.Id,contentdocumentid);
        system.assertEquals('success', returnstr);
        /********************End of Code Added by Kalyani ********************/
        
        Case testCase = CaseExtendSlaActionExt.getCaseRecord('5004E000005Zgqy');
        try{
            Case testCase1 = CaseExtendSlaActionExt.getCaseRecord('');
        }catch(Exception e){}
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec.Id), 'Test', '10', 'Hour', null);
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec.Id), 'Test', '20', 'Day', null);
        CaseExtendSlaActionExt.calculateNewSlaDate(String.valueOf(caseRec.Id), 'Test', '10', 'Week', null);
        Test.stopTest();
    }        
}