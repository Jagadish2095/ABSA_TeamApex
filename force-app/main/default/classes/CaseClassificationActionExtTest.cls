/**  
 * @Purpose      : Test Class for CaseClassificationActionExt
 * @Author       : Dreamwares 
 * @Created Date : 04/09/2018
 */
@isTest
public class CaseClassificationActionExtTest {
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
                                Email__c = 'test@test.com',
                                //recordTypeId = caseRecordTypeMap.get('NBFS_Dispute_Resolution').getRecordTypeId(),
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                sd_Service_Group__c='Test Service Group',
                                //Service_Group_Search__c='CEO',
                                //NBFS_Category__c='Level 1',
                                //Source__c='Generic',
                                //Case_Ownership__c='FPOC',
                                sd_Original_Service_Group__c='Ombudsman');//Added by Chenna

        insert caseRec;
        
        Product2 product = new Product2(Name = 'Product 1');
        insert product;
        
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01',
                                                          Product__c = 'aProduct');
        insert serviceType;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test Service Group',//Modified by Chenna
                                                         Assign_Record_Type__c = 'Email',
                                                         Response_Email_Address__c = 'evg@t.com',
                                                         Business_Hours__c = businessHr.Id,
                                                         Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                         Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id);
        insert serviceGrType;
        
        serviceType = new Service_Type__c(Name = 'Test2',
                                          Case_Record_Type__c = 'New',
                                          Subtype__c = 'Query',
                                          Type__c = 'Test',
                                          Product__c = 'aProduct',
                                          Linked_Product__c = product.Id);
        insert serviceType;
        
        serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Enquiry',
                                         Response_Email_Address__c = 'test@t.com',
                                         Business_Hours__c = businessHr.Id,
                                         Internal_SLA_Time_Measure__c = 'Day(s)',
                                         Internal_SLA_Units__c = '6');
        insert serviceGr;
        
        serviceGrType = new Service_Group_Type__c(
                                                  Service_Type__c = serviceType.Id,
                                                  Service_Group__c = serviceGr.Id);
        insert serviceGrType;
      
        serviceType = new Service_Type__c(Name = 'Test3',
                                          Case_Record_Type__c = 'Resolution',
                                          Subtype__c = 'Dispute',
                                          Type__c = 'Test');
        insert serviceType;
        
        serviceGr = new Service_Group__c(Name = 'Test2', Assign_Record_Type__c = 'Complaint',
                                         Response_Email_Address__c = 'check@tp.com',
                                         Business_Hours__c = businessHr.Id,
                                         Internal_SLA_Time_Measure__c = 'Day(s)',
                                         Internal_SLA_Units__c = '3');
        insert serviceGr;
        
    }
    
    //Method to test
    static testMethod void testCaseClassification(){
        Service_Group_Type__c sGtype = [select Service_Type__c,Service_Group__c from Service_Group_Type__c limit 1];
        Service_Type__c serviceType = [SELECT Id, Name, Type__c, Subtype__c, Case_Record_Type__c, Product__c, FAIS_NCA__c 
                                       FROM Service_Type__c 
                                       WHERE Name = 'Test1' LIMIT 1];
        Service_Group__c srvGroup = [Select Id, Name, Assign_Record_Type__c, Business_Hours__c, Internal_SLA_Time_Measure__c, Internal_SLA_Units__c 
                                     From Service_Group__c Where Name = 'Test2'];
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        //Smanga
        Service_Sub_Type__c servSubType = new Service_Sub_Type__c(Service_Type__c = serviceType.Id, Name='Test');
        insert servSubType;
        //Smanga
        
        
        
        Test.startTest();
        // Poulami modified to pass the Record Name for Service Type
        Service_Type__c testServiceType = CaseClassificationActionExt.findRecord(serviceType.Id,serviceType.Name);
        //String recId, Service_Type__c serviceTypeRec, Service_Group__c serviceGroupRec
        CaseClassificationActionExt.updateCase(String.valueOf(caseRec.Id), serviceType, srvGroup.Id, String.valueOf(servSubType.Id),'','','Non-Life Policy','Non-Life Product','testing','');
        
        Test.stopTest();
        Case testCase = [SELECT Id, Max_SLA_Extension_Date__c, Subtype__c, Type__c
                        FROM Case 
                        WHERE Id =: caseRec.Id];
        System.assertEquals(testServiceType.Id, serviceType.Id);
        System.assertEquals('Sample', testCase.Subtype__c);
        System.assertEquals('T01', testCase.Type__c);
    }
    
    //Method to test
    static testMethod void testCaseClassification1(){
        Service_Type__c serviceType = [SELECT Id, Name, Type__c, Subtype__c, Case_Record_Type__c, Product__c, FAIS_NCA__c , Linked_Product__c
                                       FROM Service_Type__c 
                                       WHERE Name = 'Test2' LIMIT 1];
         Service_Group__c srvGroup = [Select Id, Name, Assign_Record_Type__c, Business_Hours__c, Internal_SLA_Time_Measure__c, Internal_SLA_Units__c 
                                     From Service_Group__c Where Name = 'Test2'];
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        //Smanga
        Service_Sub_Type__c servSubType = new Service_Sub_Type__c(Service_Type__c = serviceType.Id, Name='Test');
        insert servSubType;
        //Smanga
        
        
        Test.startTest();
        // Poulami modified to pass the Record Name for Service Type
        Service_Type__c testServiceType = CaseClassificationActionExt.findRecord(serviceType.Id,serviceType.Name);
        CaseClassificationActionExt.findServiceTypesByProductAndServiceGroup(caseRec.Id, serviceType.Linked_Product__c, '');
        CaseClassificationActionExt.updateCase(String.valueOf(caseRec.Id), serviceType, srvGroup.Id, String.valueOf(servSubType.Id),'','','Non-Life Policy','Non-Life Product','testing',''); 
        Test.stopTest();
        
        Case testCase = [SELECT Id, Subtype__c, Type__c
                        FROM Case 
                        WHERE Id =: caseRec.Id];
        System.assertEquals(testServiceType.Id, serviceType.Id);
        System.assertEquals('Query', testCase.Subtype__c);
        System.assertEquals('Test', testCase.Type__c);
    }
    
    //Method to test
    static testMethod void testCaseClassification2(){
        Service_Type__c serviceType = [SELECT Id, Name, Type__c, Subtype__c, Case_Record_Type__c, Product__c, FAIS_NCA__c 
                                       FROM Service_Type__c 
                                       WHERE Name = 'Test3' LIMIT 1];
        Service_Group__c srvGroup = [Select Id, Name, Assign_Record_Type__c, Business_Hours__c, Internal_SLA_Time_Measure__c, Internal_SLA_Units__c 
                                     From Service_Group__c Where Name = 'Test2'];
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        // Poulami modified to pass the Record Name for Service Type
        Service_Type__c testServiceType = CaseClassificationActionExt.findRecord('',serviceType.Name);
        CaseClassificationActionExt.updateCase(String.valueOf(caseRec.Id), serviceType, srvGroup.Id, '','Test4','TestServiceSubType','','','','');
        Test.stopTest();
        
        Case testCase = [SELECT Id, Subtype__c, Type__c
                        FROM Case 
                        WHERE Id =: caseRec.Id];
        //System.assertNotEquals(testCase.Type__c, 'Test4');
    }
    
     //Method to test
    static testMethod void testCaseClassification3(){
        
        case caseRec = [
            SELECT 
                ID
            FROM
                Case
            Limit 1
        ];
        test.startTest();
        List<string> testResultList = CaseClassificationActionExt.getCaseInfo(caseRec.id);
        test.stopTest();
        System.assertEquals(testResultList.size() > 0, true);
    }
    
    //Method to test
    static testMethod void testCaseClassification4(){
        
        Service_Group__c serviceGroupRec = [
            SELECT 
                ID
            FROM
                Service_Group__c
            Limit 1
        ];
        
        test.startTest();
        Service_Group__c testserviceGroupRec = CaseClassificationActionExt.findServiceGroupRecord(serviceGroupRec.id);
        test.stopTest();
        System.assertEquals(testserviceGroupRec != Null, true);
    }
    
     //Method to test
    static testMethod void testCaseClassification5(){
        
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Product2 product = [SELECT ID FROM Product2 Limit 1];
        Service_Group__c serviceGroupRec = [SELECT ID FROM Service_Group__c Limit 1];
        
        test.startTest();
        CaseClassificationActionExt.findProductsByServiceGroup(serviceGroupRec.Id);
        //Added by Chenna - start
        CaseClassificationActionExt.findServiceTypesByProductAndServiceGroup(caseRec.Id, product.Id, serviceGroupRec.Id);
        CaseClassificationActionExt.findServiceTypesByProductAndServiceGroup(caseRec.Id, product.Id, null);
        CaseClassificationActionExt.selectOptionWrapper sowObj = new CaseClassificationActionExt.selectOptionWrapper('TestName',serviceGroupRec.Id, null); 
        //Added by Chenna - end
        test.stopTest();
    }
    
    //Method to test
    static testMethod void negTestCaseClassification(){  
        Test.startTest();
        // Poulami modified to pass the Record Name for Service Type
        Service_Type__c testServiceType = CaseClassificationActionExt.findRecord('a0X4E000005YXAY','');
        Test.stopTest();    
    }
}