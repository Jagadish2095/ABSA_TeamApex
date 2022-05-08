/**
* Test class for LeadChangeStatusActionExt
*
* @author  Koketso Mpshane
* @since   2020-03-11
*
**/
@isTest
public class LeadChangeStatusActionExtTest {
    
    @testSetup
    static void dataCreation(){
        
        Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
        insert testFinancialProduct;
        
        RecordType retailRecodType = [Select Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' and DeveloperName = 'Retail_Sales_Lead'];
   	
        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Test';
        leadRecord.LastName = 'Lead';
        leadRecord.Status = 'Allocated';
        leadRecord.Hot_Deal__c = false;
        leadRecord.RecordTypeId = retailRecodType.Id;
        leadRecord.Bypass_Validation_Rules__c = true;
        leadRecord.Product_Interest_1__c = testFinancialProduct.Id;
        insert leadRecord;
        
    }
    
    static testMethod void testLeadChangeStatusActionExt(){
        
    	Lead leadRec = [Select Id From Lead Limit 1];
                
        Test.startTest();
        leadRec.Product_Offer_Status_1__c = 'Offer Declined';
        leadRec.Status = 'Working';
        leadRec.SubStatus__c ='Handling';
        update leadRec;
        LeadChangeStatusActionExt.getLeadCloseStatus(leadRec.Id);
        LeadChangeStatusActionExt.updateLeadStatus(leadRec.Id, 'Closed', 'Declined', '','Incorrect Number', 'test');
        
        Test.stopTest();
    }

}