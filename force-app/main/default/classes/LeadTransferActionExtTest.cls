/**
* Test class for LeadTransferActionExt
*
* @author  Koketso Mpshane
* @since   2020-03-11
*
**/
@isTest
public class LeadTransferActionExtTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        
        RecordType retailRecodType = [Select Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' and DeveloperName = 'Retail_Sales_Lead'];
   	
        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecodType.Id;
        insert leadRecord;
        
        Service_Group__c sg = new Service_Group__c(Name='SG',Queue__c='Retail Leads',Active__c=true, Assign_Record_Type__c = 'Retail Sales Lead');
        insert sg;
        
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true);
        insert sl;
        
        Service_Type__c st = new Service_Type__c(Name='Type Subtype', Type__c='Type', Subtype__c='Subtype');
        insert st;
        
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=sg.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        
    }
    
    //Method to test
    static testMethod void testLeadTransferActionExt(){
        
    	Lead leadRec = [Select Id From Lead Limit 1];
        leadRec.Business_Hours__c = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        update leadRec;
        
        
        Test.startTest();
        
        LeadTransferActionExt.getLeadCloseStatus(leadRec.Id);
		Service_Group__c sg = new Service_Group__c(Name='SG',Queue__c='MSA Leads',Active__c=true, Assign_Record_Type__c = 'Retail Sales Lead');
        insert sg;
        
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true);
        insert sl;
        
        Service_Type__c st = new Service_Type__c(Name='Type Subtype', Type__c='Type', Subtype__c='Subtype');
        insert st;
        
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=sg.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        
        LeadTransferActionExt.transferLead(String.valueOf(leadRec.Id), '', '', '', sg);
        LeadTransferActionExt.findServiceGroupRecord(sg.Id);
        
        Test.stopTest();
    }

}