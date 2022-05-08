@isTest 
private class SitesLogComplaintExtTest {

    @isTest
    private static void testTheClass() {

        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test', Assign_Record_Type__c = 'Complaint',
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '5', Queue__c = 'Email',
                                                          Pause_Statuses__c = 'Awaiting Customer Feedback',
                                                          Business_Hours__c = businessHr.Id, 
                                                          Email_Template_Case_Creation__c = 'Email template');
        insert serviceGr;

        Service_Level__c tstServT = new Service_Level__c();
        tstServT.Default_Service_Level__c = true;
        insert tstServT;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, 
                                                                        Service_Type__c = serviceType.Id,
                                                                        Service_Level__c =  tstServT.Id);
        insert serviceGrType;

        Test.startTest();

            ApexPages.StandardController sc = new ApexPages.StandardController(new Case());
            SitesLogComplaintExt slcExt = new SitesLogComplaintExt(sc);
            
            PageReference pageRef = Page.SitesLogComplaint;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('groupId',serviceGr.Id);
        
        	slcExt.incidentTime = Time.newInstance(12, 00, 00, 00);
            slcExt.accountInput = 'Test new';

            pageRef = slcExt.save();
            pageRef = slcExt.done();

        Test.stopTest(); 
    }
 }