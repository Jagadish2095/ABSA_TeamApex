/**
* @description Test class for ApplicationValidatorLightning controller class. 
* @return TestMethodCoverage
* @author Jaco de Lange 
* @since 2021-01-04
* @param
**/
@isTest
public class ApplicationValidatorLightningTest { 
    /**
* @description Test class for ApplicationValidatorLightning controller class. 
* @author Jaco de Lange 
* @since 2021-01-04
* @param
**/
    @isTest
    public static void testCaseValidator() {
        
        Id cafRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CAF_Application').getRecordTypeId();
        
        Account acc1 = new Account(Name='testaccount', Trust_Number__c='1',Trust_Number_New_format__c='1', Client_Type__c='Individual');
        insert acc1;  
        system.assertEquals(acc1.Name,'testaccount');
        Account acc2 = new Account(Name='testaccount2', Trust_Number__c='2',Trust_Number_New_format__c='1', Client_Type__c='Sole Trader');
        insert acc2; 
        system.assertEquals(acc2.Name,'testaccount2');
        Opportunity opp1 = new Opportunity (Name='testopp', AccountId=acc1.Id, StageName='Won',CloseDate=system.today());
        insert opp1;
        system.assertEquals(opp1.Name,'testopp');
        Opportunity opp2 = new Opportunity (Name='testopp2', AccountId=acc2.Id, StageName='Won',CloseDate=system.today());
        insert opp2;
        system.assertEquals(opp2.Name,'testopp2');
        Contact co = new Contact(FirstName='contname',LastName='contlastName',AccountId=acc1.Id);
        insert co; 
        system.assertEquals(co.FirstName,'contname');
        Case ca = new Case(RecordTypeId = cafRecordTypeId,Status='Payout Release', Opportunity__c=opp1.Id);    
        insert ca;   
        system.assertEquals(ca.Opportunity__c,opp1.Id);
        Decision_History__c dh = new Decision_History__c(Decision__c='Accepted',Details__c='approved',Case__c = ca.Id);   
        insert dh; 
        system.assertEquals(dh.Case__c, ca.Id);
        
        Test.startTest();
        	ApplicationValidatorLightning.insertDecisionHistoryRec(ca.Id,'detail','comments',false,true,'Payout Validator','');
        	ApplicationValidatorLightning.insertDecisionHistoryRec(ca.Id,'detail','comments',true,false,'Payout Validator','');
        	ApplicationValidatorLightning.insertDecisionHistoryRec(ca.Id,'detail','comments',true,false,'Payout Release','');
        	ApplicationValidatorLightning.getHistory(ca.Id);
        	ApplicationValidatorLightning.getOppsList(opp1.Id);
        //checkNCAStatus(String oppId, Double agreementSize, String securedByMortgage, Integer numberOfTrustees, Double annualTurnover, Double netAssetValue) 
        	//opp1.Id,200000, 'Yes', 2, 1000000, 500000
            //ApplicationValidatorLightning.checkNCAStatus(null, 200,'agreetype',300,400,'Yes');
            //ApplicationValidatorLightning.checkNCAStatus(null, 200, 'Yes', 2, 300, 400);
        	//ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 200,'agreetype',300,400,'Yes');
        	ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 200, 'Yes', 2, 300, 400);
        	//ApplicationValidatorLightning.checkNCAStatus(opp2.Id, 200,'agreetype',300,400,'No');
            ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 200, 'No', 2, 300, 400);
        	//ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 300000,'agreetype',2000000,2000000,'Yes');
             ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 300000, 'Yes', 2, 2000000, 2000000);
        	//ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 300000,'agreetype',2000000,2000000,'No');
        	 ApplicationValidatorLightning.checkNCAStatus(opp1.Id, 300000, 'No', 2, 2000000, 2000000);
        	ApplicationValidatorLightning.getOppId(ca.Id);
        	ApplicationValidatorLightning.getCase(ca.Id);
        ApplicationValidatorLightning.queryNumberOfTrustees(acc1.Id);
        	ApplicationValidatorLightning.getPickListValuesIntoList('Case','Reason_for_more_information__c');
            ApplicationValidatorLightning.fetchSendToFromCase(ca.Id);
        Test.stopTest();            
    }
}