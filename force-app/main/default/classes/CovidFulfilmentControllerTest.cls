@IsTest
public class CovidFulfilmentControllerTest {

    @testSetup static void createData(){
        
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        
        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        Insert app;
        
       	Application_Product__c apcCovid = new Application_Product__c();
        apcCovid.Opportunity_Product_Id__c = opp.id;
        apcCovid.Opportunity__c = opp.id;
        apcCovid.Annual_Turnover__c = 11000000;
        apcCovid.Asset_Value__c = 200000000;
        apcCovid.IsMainProduct__c = true;
        insert apcCovid;
        
        
         Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Absa Client Services';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        insert serviceGr;
        
        
    }
   
    public static testMethod void testCaseFulfillment() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        Application_product__c appProd =[Select Id From Application_product__c LIMIT 1];
        Test.startTest();
         
		CovidFulfilmentController.createCasefulfilment(opp.Id); 
        Case cs = [Select Id,status From Case];
		cs.Status ='Awaiting Approval';
        update cs;
        
		 covidFulfilmentController.retrieveCaseHistory(cs.Id,appProd.id);
     
        CovidFulfilmentController.fetchcaseHistory(opp.Id);
        
        CovidFulfilmentController.CaseWrapper caeWrap = new CovidFulfilmentController.CaseWrapper();
        Test.stopTest();
        
    }
}