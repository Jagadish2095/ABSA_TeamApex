/**
* Test class for the RefundApprovalProcessController class
*
*/
@isTest
public class RefundApprovalProcessControllerTest {
    
    @testSetup static void setup() {
        Account testAccount;
        Case newCase;
        Site__c testSite;
        User user = [Select id from user where id= :Userinfo.getUserId()];
        List<User> users =new List<User>();
        System.runAs(user){
            // Create common test user
            User newUser = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'].Id,
                LastName = 'last',
                Email = 'user000@absaaa1.com',
                Username = 'user000@absaaa1.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%Area%' LIMIT 1].Id,
                SiteCode__c = '0000',
                Zone__c = 'zone'
            );
            users.add(newUser);
            
            User newUser1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'].Id,
                LastName = 'last',
                Email = 'user000@absaaa2.com',
                Username = 'user000@absaaa2.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%Regional Head%' LIMIT 1].Id,
                SiteCode__c = '0000',
                Zone__c = 'zone'
            );
            users.add(newUser1);
            
            User newUser2 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'].Id,
                LastName = 'last',
                Email = 'user000@absaaa.com',
                Username = 'user000@absaaa.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%Managing Executive%' LIMIT 1].Id,
                SiteCode__c = '0000',
                Zone__c = 'zone'
            );
            users.add(newUser2);
            insert users;
            
            // Create common test account
            testAccount = new Account(CIF__c = 'I001',
                                      Client_Type__c = 'PRIVATE INDIVIDUAL',
                                      LastName = 'Test Account',
                                      PersonEmail = 'test@test.com',
                                      PersonMobilePhone = '0123456789',
                                      ownerId = newUser.Id
                                     );
            
            insert testAccount;
            
            Product2 prod = new Product2();
            prod.name ='test prod';
            insert prod;
            
            Refund_Transaction_Type__c refundTrans = new Refund_Transaction_Type__c();
            refundTrans.Product_Id__c = prod.Id;
            refundTrans.Approval_Group__c = 'test';
            insert refundTrans;

            // Create common test Case
            Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            System.debug('caseRecordTypeMap '+caseRecordTypeMap);
            newCase = new Case(Communication_Method__c = 'Email',
                               Status = 'New',
                               Origin = 'Email', 
                               AccountId = testAccount.Id,
                               Risk_Management_Centre__c = 'Digital Fraud',
                               Email__c = 'test@test.com',
                               Subject = 'test',
                               Description = 'test',
                               Expectation_of_the_Customer__c = 'test',
                               Incident_Date__c = date.today(),
                               Type__c = 'deposit',
                               Claim_Amount__C = 150,
                               Amount_Withdrawn__c = 130,
                               Amount_Received__c = 100,
                               Amount_Refunded__c = 1000,
                               Product_Search__c= prod.Id,
                               Refund_Transaction_Type_Id__c = refundTrans.Id,
                               Amount__c = 100001,
                               recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId());
            insert newCase;
            
            Map<String, Schema.RecordTypeInfo> siteRecordTypeMap = Site__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            testSite = new Site__c(Name ='test site',
                                Unique_Site_Code__c ='A0000',
                                Site_Code__c = '0000',
                                Zone__c ='zone',
                                recordTypeId =siteRecordTypeMap.get('Branch_Site').getRecordTypeId());
            
            insert testSite;
        }
    }
    
    @isTest
    private static void testGetSubmitter() {
        Test.startTest();
        User user = [SELECT Id FROM User WHERE Email ='user000@absaaa.com' LIMIT 1];
        Case caseRecord = [SELECT Id FROM Case WHERE Subject='test' LIMIT 1];
        System.runAs(user) {
            Id submitterId = RefundApprovalProcessController.getSubmitter(caseRecord.Id);
        }
        Test.stopTest();
    }
    
    @isTest
    private static void testSubmitLevel4ApprovalProcess() {
        Test.startTest();
        Case caseRecord = [SELECT Id,Refund_Approval_Stage__c FROM Case WHERE Subject='test' LIMIT 1];
        try{
        RefundApprovalProcessController.submitLevel4ApprovalProcess(caseRecord.Id);
        }
        catch(Exception e){
            System.debug('error '+e.getMessage());
        }
        Test.stopTest();
    }
    
     @isTest
    private static void testSubmitLevel3ApprovalProcess() {
        Test.startTest();
       
        User user = [SELECT Id FROM User WHERE Email ='user000@absaaa1.com' LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Client_Type__c = 'PRIVATE INDIVIDUAL' LIMIT 1];
        acc.ownerId = user.Id;
        update acc;
        
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Case newCase = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = acc.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Type__c = 'deposit',
                                Claim_Amount__C = 150,
                                Amount_Withdrawn__c = 130,
                                Amount_Received__c = 100,
                                Amount_Refunded__c = 100001,
                                Amount__c = 100001,
                                Mandate_Level_4_Approver__c = userinfo.getUserId(),
                                Mandate_Level_3_Approver__c = userinfo.getUserId(),
                                Mandate_Level_2_Approver__c = userinfo.getUserId(),
                                recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                               Refund_Approval_Stage__c = 'Level 3');
        insert newCase;
        RefundApprovalProcessController.submitLevel3ApprovalProcess(newCase.Id);
        Test.stopTest();
    }
    
     @isTest
    private static void testSubmitLevel2ApprovalProcess() {
        Test.startTest();
        User user = [SELECT Id FROM User WHERE Email ='user000@absaaa2.com' LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Client_Type__c = 'PRIVATE INDIVIDUAL' LIMIT 1];
        acc.ownerId = user.Id;
        update acc;
        
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Case newCase = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = acc.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Type__c = 'deposit',
                                Claim_Amount__C = 150,
                                Amount_Withdrawn__c = 130,
                                Amount_Received__c = 100,
                                Amount_Refunded__c = 100001,
                                Amount__c = 100001,
                                Mandate_Level_4_Approver__c = userinfo.getUserId(),
                                Mandate_Level_3_Approver__c = userinfo.getUserId(),
                                Mandate_Level_2_Approver__c = userinfo.getUserId(),
                                recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                               Refund_Approval_Stage__c = 'Level 2');
        insert newCase;
        RefundApprovalProcessController.submitLevel2ApprovalProcess(newCase.Id);
        Test.stopTest();
    }
    
     @isTest
    private static void testSubmitLevel1ApprovalProcess() {
        Test.startTest();
        User user = [SELECT Id FROM User WHERE Email ='user000@absaaa1.com' LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Client_Type__c = 'PRIVATE INDIVIDUAL' LIMIT 1];
        
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Case newCase = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = acc.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Type__c = 'deposit',
                                Claim_Amount__C = 150,
                                Amount_Withdrawn__c = 130,
                                Amount_Received__c = 100,
                                Amount_Refunded__c = 100001,
                                Amount__c = 100001,
                                Mandate_Level_4_Approver__c = userinfo.getUserId(),
                                Mandate_Level_3_Approver__c = userinfo.getUserId(),
                                Mandate_Level_2_Approver__c = userinfo.getUserId(),
                                recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                               Refund_Approval_Stage__c = 'Level 1');
        insert newCase;
        
        try{
        RefundApprovalProcessController.submitLevel1ApprovalProcess(newCase.Id);
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
    
     @isTest
    private static void testGetRefundApprovalStage() {
        Test.startTest();
        Case caseRecord = [SELECT Id FROM Case WHERE Subject='test' LIMIT 1];
        RefundApprovalProcessController.getRefundApprovalStage(caseRecord.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void testsendEscalationEmailsToLevel1() {
        Test.startTest();
        Group grp = new Group();
        grp.name = 'test';
        grp.Type = 'Regular';
        insert grp;
        
        GroupMember grpMem = new GroupMember(); 
        grpMem.UserorGroupId = Userinfo.getUserId();
        grpMem.GroupId = grp.Id;
        insert grpMem;
        
        Case caseRecord = [SELECT Id FROM Case WHERE Subject='test' LIMIT 1];
        RefundApprovalProcessController.sendEscalationEmailsToLevel1(caseRecord.Id);
        Test.stopTest();
    }

}