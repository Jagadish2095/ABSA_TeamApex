/**  
 * @Purpose      : Test Class for CaseResolutionAndClosureController
 * @Author       : Dreamwares 
 * @Created Date : 06/09/2018
 */
@isTest
public class CaseResolutionAndClosureControllerTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
    	Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email', 
                                Status = 'New', 
                                Origin = 'Email', 
                                Subject = 'Subject', 
                                Description  = 'Description',
                                Expectation_of_the_Customer__c = 'resolution',
                                Deposit_Type__c = 'Cardless',
                                Originated_By__c = 'Absa Customer',
                                Entity__c = 'Company',
                                Reported_Date__c = System.today(),
                                Account = account, 
                                Email__c = 'test@test.com',
                               	Incident_Date__c = date.today());
        insert caseRec;
        
        Product2 product = new Product2(Name = 'Product 1');
        insert product;
        
        Service_Type__c newST = new Service_Type__c(Name = 'Name', Type__c = 'type', Subtype__c = 'subtype', Product__c = 'product', Linked_Product__c =product.Id);
        insert newST;
              
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                         Response_Email_Address__c = 'evg@t.com',
                                                         Business_Hours__c = businessHr.Id,
                                                         Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                         Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = newST.Id,
                                                                        Service_Group__c = serviceGr.Id);
        insert serviceGrType;
        
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
    }
    
    //Method to test
    static testMethod void testCaseResolutionNClosureController(){
    	Case caseRec = [SELECT Id FROM Case LIMIT 1];
        caseRec.Resolved_in_Favour_of__c = 'Bank';
        
        Product2 product = [SELECT ID FROM Product2 Limit 1];
        Service_Group__c serviceGroupRec = [SELECT ID FROM Service_Group__c Limit 1];
        
        Test.startTest();
        Case testCase = CaseResolutionAndClosureController.getCaseRecord( String.valueOf( caseRec.Id ) );
        System.assertNotEquals(null, testCase);
        Service_Type__c serviceTypeRecord = [Select Id, Name, Type__c, FAIS_NCA__c, Subtype__c, Product__c From Service_Type__c limit 1];
        //Update Case
        try {
            testCase = CaseResolutionAndClosureController.updateAndCloseCase(caseRec, serviceTypeRecord);
            CaseResolutionAndClosureController.findProductsByServiceGroup(serviceGroupRec.Id);
            CaseResolutionAndClosureController.findServiceTypesByProductAndServiceGroup(caseRec.Id, product.Id, serviceGroupRec.Id);
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        //Find Service Type 
        Service_Type__c testServiceType = CaseResolutionAndClosureController.findServiceType(serviceTypeRecord.id);
        
        List<ContentDocumentLink> cdlList = [select Id, LinkedEntityId, ContentDocumentId, Sharetype From ContentDocumentLink Where LinkedEntityId =:caseRec.Id];
        List<String> docIds = new List<String>();
        
        if(cdlList.size() > 0){
            for(ContentDocumentLink cdl: cdlList){
                docIds.add(cdl.ContentDocumentId);
            }
        }
        
        if(docIds.size() > 0){
            CaseResolutionAndClosureController.uploadContentDocuments(caseRec.Id, docIds);
        }
       
        Test.stopTest();
    }
    
    //Method to test
    static testMethod void negTestCaseResolutionNClosureController(){
    	Test.startTest(); 
        try{
        	Case testCase = CaseResolutionAndClosureController.getCaseRecord('5004E000005Zgqr');
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        try{
        	Case testCase = CaseResolutionAndClosureController.updateAndCloseCase(null, null);
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        try{
        	Case testCase = CaseResolutionAndClosureController.updateAndCloseCase(caseRec, null);
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        Test.stopTest();
    }

}