/** 
    * @description get cafApplication
    
    
    */
@isTest

public class CAF_Sanctioning_Controller_Test {
    /** 
    * @description get cafApplication
    
    */
     @testSetup
    static void dataCreation(){
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
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Advisor'];
        
        insert new PermissionSetAssignment(AssigneeId = sysAdminUser.id, PermissionSetId = ps.Id);
        
        PermissionSet fsps = [SELECT Id FROM PermissionSet WHERE Name = 'FinancialServicesCloudStandard'];
        insert new PermissionSetAssignment(AssigneeId = sysAdminUser.id, PermissionSetId = fsps.Id);
        
        Group queueName = new Group();
    queueName.Name = 'Sales Support Consultant';
    queueName.Type = 'Queue';  
    insert queueName;
        
    QueuesObject testQueue = new QueueSObject(QueueID = queueName.id, SObjectType = 'Case');
    insert testQueue;
    }
    
    /** 
    * @description get cafApplication
   
    */
  @isTest 
    public static void testSanctioningController(){  
         User sysUser = [Select Id,FirstName from User where LastName = 'last_test'];
      System.runAs(sysUser) {   
    Account account = new Account(Name = 'Test Account');
    account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
    account.Country_of_Incorporation__c='South Africa';
    account.Client_Group__c = 'Non Individual';
    account.CASA_Reference_Number__c = '12233';
    account.CIF__c = '';
    account.Countries_Traded_With__c = 'South Africa';
    account.Source_of_Income__c = 'Donation';
    insert account;   
    
    Opportunity opp = new Opportunity();
    opp.Name =  account.Name + 'CAF';
    opp.RecordTypeId = schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
    opp.CloseDate = date.today()+30;
    opp.StageName = 'Confirm Client Eligibility';
    insert opp;
        
      Product2 product = new Product2();
      product.Name = 'Business Evolve';
      product.Product_Classification__c = 'Package';
      insert product;
        
       Id pricebookId = Test.getStandardPricebookId(); 
        
        Pricebook2 standardPricebook = new Pricebook2(Id = pricebookId,IsActive = true);
        update standardPricebook;

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = product.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Application_Product_CAF__c apc = new Application_Product_CAF__c ();
        apc.Company_turnover__c = '10000';
        insert apc;
        
       
        
     OpportunityLineItem oli = new OpportunityLineItem(
     OpportunityId = opp.Id,
     Quantity = 5,
     PricebookEntryId = standardPrice.Id,
     TotalPrice = 5 * standardPrice.UnitPrice,
     Application_Product_CAF__c = apc.id);
     insert oli;   
     
    Service_Group__c serviceGroup = new Service_Group__c();
    serviceGroup.Name = 'CAF Onboarding';
    serviceGroup.Queue__c = 'Sales Support Consultant';   
    insert serviceGroup;
        
    Id queueId = new GroupsSelector().selectByNameAndType(serviceGroup.Queue__c, 'Queue')[0].Id;
        
    // Create an approval request for the account
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    req1.setComments('Submitting request for approval.');
    req1.setObjectId(opp.id);
    req1.setSubmitterId(sysUser.Id);
    Approval.ProcessResult result = Approval.process(req1);      
    System.assert(result.isSuccess());
    System.assertEquals('Pending', result.getInstanceStatus(),'Instance Status'+result.getInstanceStatus());
    //String oppId, String approvalName, String comments, String status, String reasons, String approverId 
    CAF_Sanctioning_Controller.processRequest(opp.id, '', 'Reject Comments', 'Reject','MATCH enquiry outstanding','');   
    CAF_Sanctioning_Controller.formatDateTime(datetime.now());  
    CAF_Sanctioning_Controller.getApprovalRequests(opp.id, '');
        
    CAF_Sanctioning_Controller.createCase(apc.id, 'ab2bbd91-8fab-45e9-8de1-904fdbe3dde1');
        Case testCase = [Select Id, Application_Product_Id__c from Case where Application_Product_Id__c =: apc.id];
    CAF_Sanctioning_Controller.updateCaseStatus(apc.id,'','');
    CAF_Sanctioning_Controller.createDecisionHistory(testCase.Id, 'Approved', 'Approved As Is', 'comments', 'Securities Validator', true, 'Security Validator');
    CAF_Sanctioning_Controller.getCaseDetails(testCase.Id);
    CAF_Sanctioning_Controller.getApplicationId(testCase.Id);    
   // CAF_Sanctioning_Controller.changeOwner(testCase.Id, 'Sales Support Consultant', 'Get Contracts Signed');
     CAF_Sanctioning_Controller.changeOwner(testCase.Id, 'Sales Support Consultant', 'Get Contracts Signed','');    
    CAF_Sanctioning_Controller.updateCaseStatus(apc.id,'Validate Payout', 'Sales Support Consultant');
    CAF_Sanctioning_Controller.getApplicationId(testCase.Id);
   CAF_Sanctioning_Controller.createCase(apc.id, 'ab2bbd91-8fab-45e9-8de1-904fdbe3dde1');    
   CAF_Sanctioning_Controller.fetchSendToFromCase(testCase.Id);
   CAF_Sanctioning_Controller.fetchCaseOwner(testCase.Id);
   CAF_Sanctioning_Controller.updateDecisionDataToCase(testCase.Id,'componentName', sysUser.id);
        
        
    }
    }
}