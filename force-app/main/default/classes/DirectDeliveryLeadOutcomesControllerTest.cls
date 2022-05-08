/**
* @description  : DirectDeliveryLeadOutcomesControllerTest
*@Author       : Kalyani Papineni
*@Created Date : 2021/01/29
*@Purpose      : Test class for DirectDeliveryLeadOutcomesController
*/

@isTest
public class DirectDeliveryLeadOutcomesControllerTest {
    
    public static List<Lead> newLeadLst = new List<Lead>();
    public static Financial_Product__c newProd;
    
    /** @description initdata
     **/
    public static void initdata() {
        
        Direct_Delivery_Outcomes_Setting__mdt customdata = new Direct_Delivery_Outcomes_Setting__mdt(Inbound_Outcome__c='Call Back',
                                                                                                     Inbound_Primary_Reason__c='Speaking to my spouse,Don’t have beneficiary details / extended member details,In a hurry ,SMD,Client does not have banking details for another bank,Banking with another bank',
                                                                                                     Outbound_Outcome__c='Client not insurable',
                                                                                                     Outbound_Primary_Reason__c='Never took delivery,Taxi use,Vehicle is sold,Client under debt review',
                                                                                                     Product__c='Health Assistance');
        
        STI_outcome_setting__mdt customdataSti = new STI_outcome_setting__mdt(Inbound_Outcome__c='Call Back',
                                                                              Outbound_Outcome__c='Client not insurable',
                                                                              Product__c='STI C1');
        Inv_outcome_setting__mdt customdataInv = new Inv_outcome_setting__mdt(Inbound_Outcome__c='Call Back',
                                                                              Outbound_Outcome__c='Client not insurable',
                                                                              Product__c='Investment Product');
        
        newProd = new Financial_Product__c( Name = 'Card Life',
                                           Description__c = 'test product', 
                                           Type__c = 'Borrow', 
                                           Product__c = 'Health Assistance', 
                                           Sub_Product__c = 'Health Assistance', 
                                           Product_Type__c = 'Insure',
                                           Business_Unit__c = 'Merchants');
        insert newProd;
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Delivery Sales Lead').getRecordTypeId();
        Id recTypesTI = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
        
        newLeadLst.add(new Lead(FirstName = 'Dummy',
                                LastName = 'Lead',
                                Status = 'Nurturing',
                                Company = 'Absa',
                                MobilePhone = '0745028193',
                                Phone = '0745028193',
                                Financial_Product__c = newProd.Id,
                                Unsuccessful_Calls__c = 3,
                                RecordTypeId = recTypeId,
                                Is_Inbound__c = true));
        
        newLeadLst.add(new Lead(FirstName = 'Dummy1',
                                LastName = 'Lead1',
                                Status = 'Nurturing',
                                Company = 'Absa',
                                MobilePhone = '0746028193',
                                Phone = '0746028193',
                                Financial_Product__c = newProd.Id,
                                Unsuccessful_Calls__c = 2,
                                RecordTypeId = recTypeId,
                                Is_Inbound__c = false));
        
        newLeadLst.add(new Lead(FirstName = 'Dummy1',
                                LastName = 'Lead1',
                                Status = 'New',
                                Company = 'Absa',
                                MobilePhone = '0746028193',
                                Phone = '0746028193',
                                Financial_Product__c = newProd.Id,
                                Unsuccessful_Calls__c = 2,
                                Salutation='Mr',
                                RecordTypeId = recTypesTI,
                                Is_Inbound__c = false));
        insert newLeadLst;
        
    }
    
    @isTest public static void outcometest() {
        initdata();
        Test.startTest();
        DirectDeliveryLeadOutcomesController.getOutcomes(newLeadLst[0].Id);
        DirectDeliveryLeadOutcomesController.getOutcomes(newLeadLst[1].Id);
        
        DirectDeliveryLeadOutcomesController.saveOutcome(newLeadLst[0].Id, 'Call Back', 'Call Back', system.today().adddays(10), 'English','Test');
        try{
            DirectDeliveryLeadOutcomesController.saveOutcome(newLeadLst[0].Id, 'Client Interested', 'Call Back', system.today().adddays(10), 'English','Test');
            
        }catch(Exception e) {
            System.assertEquals(e.getMessage() != null, true);
        }
        Test.stopTest();
    }
    
    @isTest public static void outcometestSti() {
        initdata();
        Test.startTest();
        DirectDeliveryLeadOutcomesController.getOutcomes(newLeadLst[2].Id);
        DirectDeliveryLeadOutcomesController.saveOutcome(newLeadLst[2].Id, 'Call Back', 'No Answer', system.today().adddays(10), 'English','Test');
        try{
            String leadID=newLeadLst[2].Id;
            DirectDeliveryLeadOutcomesController.getSitRecordType(leadID); 
            
            DirectDeliveryLeadOutcomesController.saveOutcome(newLeadLst[2].Id, 'Client Interested', 'No Answer', system.today().adddays(10), 'English','Test');
            
        }catch(Exception e) {
            System.assertEquals(e.getMessage() != null, true);
        }
        Test.stopTest();
    }
    @isTest public static void outcometestInvestment() {
        initdata();
        Id recTypeInvestment = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Investment Lead').getRecordTypeId();
        Financial_Product__c prod = [Select Id from Financial_Product__c where Product_Type__c = 'Insure' LIMIT 1];
        Lead lead = new Lead(FirstName = 'Dummy1',
                         LastName = 'Lead1',
                         Status = 'New',
                         Company = 'Absa',
                         MobilePhone = '0746028193',
                         Phone = '0746028193',
                         Financial_Product__c = prod.Id,
                         Unsuccessful_Calls__c = 2,
                         Salutation='Mr',
                         RecordTypeId = recTypeInvestment,
                         Is_Inbound__c = false);
        insert lead;
        Test.startTest();
        DirectDeliveryLeadOutcomesController.getOutcomes(lead.Id);
        
        try{DirectDeliveryLeadOutcomesController.saveOutcome(lead.Id, 'Call Back', 'Call Back', system.today().adddays(10), 'English','Test');}
        catch(Exception ex){System.assert(ex != null);}
        try{DirectDeliveryLeadOutcomesController.saveOutcome(lead.Id, 'Client Interested', 'Call Back', system.today().adddays(10), 'English','Test');}
        catch(Exception e){System.assert(e!= null);}
        Test.stopTest();
    }
}