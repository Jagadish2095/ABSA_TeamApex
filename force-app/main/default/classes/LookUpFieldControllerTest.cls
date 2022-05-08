@isTest
public class LookUpFieldControllerTest {
    
    @isTest
    public static void testfetchMatchingServiceGroup(){
    
    	BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        List<Service_Group__c> servReqList = new List<Service_Group__c>();
        List<Service_Group__c> complainList = new List<Service_Group__c>();
        List<Service_Group__c> retailSalesList = new List<Service_Group__c>();
        for(Integer x = 0; x<5; x++){
            Service_Group__c serviceGr  = new Service_Group__c(Name = 'Test' + x, Assign_Record_Type__c = 'Service Request',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8',
                                                          Active__c=true);
            servReqList.add(serviceGr);
        }
        insert servReqList;
        
        for(Integer x = 0; x<5; x++){
            Service_Group__c serviceGr  = new Service_Group__c(Name = 'Test' + x, Assign_Record_Type__c = 'Complaint',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8',
                                                          Active__c=true);
            complainList.add(serviceGr);
        }
        
       insert complainList;
        
       for(Integer x = 0; x<5; x++){
            Service_Group__c serviceGr  = new Service_Group__c(Name = 'Test' + x, Assign_Record_Type__c = 'Retail Sales Lead',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Email',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8',
                                                          Active__c=true);
            retailSalesList.add(serviceGr);
        }
        
       insert retailSalesList;
        
        
        String searchKeyWord = 'Test';
        String objApiName = 'Service_Group__c';
        String caseTypeValue = 'Service_Request';
        String childObjectTypeCase ='Case';
        String childObjectTypeLead ='Lead';
        String leadSourceString = 'IB Walk-in';
        
        
    
    Test.startTest();
        //Positive Tests
        String query = LookUpFieldController.getQueryString('ServiceGroupLookupSearch');
        LookUpFieldController.fetchMatchingLookupRecord(searchKeyWord, query);

       
    Test.stopTest();
    }
    
    

}