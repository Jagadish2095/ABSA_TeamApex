/*
  This test class will cover code coverage of below triggers/classes:
	1. ApplicationSecurityTrigger
	2. TriggerDispatcher
	3. TriggerHandlerApplicationSecurity
*/
@isTest
public class ApplicationSecurityTrigger_Test {
    
    @isTest
    public static void ApplicationSecurityTriggertest(){    
        
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'UoW Test Name ';
        opp.StageName = 'Open';
        opp.CloseDate = System.today();
        opp.accountid = ac.id;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        
        Application_Profile__c appProfile = new Application_Profile__c();
        appProfile.Client_CIF_Code__c = 'AABK   007';
        appProfile.Client_Name__c = 'Absa Bank';
        appProfile.Related_to_Client_ID_or_Reg_Number__c ='AABK   007';
        appProfile.Application__c = application.Id;
        appProfile.Applicant_Type__c = 'Main Applicant';
        insert appProfile;
        
        Application_Security__c appsec = new Application_Security__c();
        appsec.Application__c = application.id;
        appsec.Security_Type__c = 'Bond';
        appsec.Application_Id_Text__c = application.id;
        appsec.Specific__c = 'Test';
        appsec.ASV__c = 10;
        appsec.Status__c = 'Open';
        insert appsec;
        System.assertEquals(10,appsec.ASV__c);
        appsec.Specific__c = 'Testing';
        appsec.ASV__c = 101;
        appsec.Client_Code__c ='AABK   007';
        System.assertEquals(101,appsec.ASV__c);
        update appsec;
        List<string> handlerNames = new List<string>();
        handlerNames.add('Test');
        system.debug(appsec);
        TriggerDispatcher.resume(handlerNames);
        TriggerDispatcher.skip(handlerNames);
        delete appsec;
        undelete appsec;            
    }   
}