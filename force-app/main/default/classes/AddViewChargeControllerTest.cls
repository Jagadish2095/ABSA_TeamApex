@isTest
public class AddViewChargeControllerTest {
    
    static testmethod void AddViewChargeLoadTest() {
        
        AddViewChargeController.Response response = new AddViewChargeController.Response();
        Test.startTest();
        
        List<Case> caseList  = [Select ID,Charge_Locked__c from Case ];
        caseList[0].Charge_Locked__c =false;
        update caseList[0];
        
        AddViewChargeController.currentCase = caseList[0];
        AddViewChargeController.currentCase.Charge_Locked__c = false;
        AddViewChargeController.unlock();
        AddViewChargeController.AddViewChargeLoad('',caseList[0].Id);
        AddViewChargeController.addnewLine1(JSON.serialize(response));
        AddViewChargeController.saveUpdates1(caseList[0].Id,JSON.serialize(response));
        AddViewChargeController.unlock11(caseList[0].Id,JSON.serialize(response));
        AddViewChargeController.lockCharges1(caseList[0].Id,JSON.serialize(response));
        AddViewChargeController.deleteItem1(caseList[0].Id,JSON.serialize(response));
        
        Charge__c charge = new Charge__c(Case__c = caseList[0].Id);
        insert charge;
        
        List<Charge__c> charges  = [Select ID from Charge__c ];
        
        AddViewChargeController.ChargeWrapper cw = new AddViewChargeController.ChargeWrapper(1, charges[0]);
        AddViewChargeController.chargeWrapperList = new List<AddViewChargeController.chargeWrapper>{cw};
        AddViewChargeController.updateSequence();
        AddViewChargeController.CRID = 0;
        AddViewChargeController.currentCase = caseList[0];
        AddViewChargeController.DeleteItem();
        
        charge = new Charge__c(Case__c = caseList[0].Id);
        insert charge;
        
        charges  = [Select ID,Case__c from Charge__c ];
        
        string chargs = json.serialize(charges);
        
        AddViewChargeController.SaveNewCharges(chargs);
        AddViewChargeController.lockCharges(charges[0].Case__c);
        AddViewChargeController.DeleteCharge(charges[0].id);
        
        Case testCase2 = new Case();
        testCase2.Subject = 'Support test 2';
        testCase2.Origin = 'Email';
        testCase2.Status = 'New';
        testCase2.Priority = 'High';
        insert testCase2;
        
        AddViewChargeController.getPickValues(testCase2, 'Status', 'notnull');
        AddViewChargeController.SaveUpdates();
        
        AddViewChargeController.getCaseCharge(testCase2.Id);
        
        Charge__c charge2 = new Charge__c(Case__c = testCase2.Id);
        insert charge2;
        AddViewChargeController.ChargeWrapper cw2 = new AddViewChargeController.ChargeWrapper(1, charge2);
        
        Test.stopTest();
    }
    
    @TestSetup
    public static void setupData() {
        
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
        insert con;
        Profile cscUserProfile = [select Name from Profile where Name = :'Standard User (CSC)'];
        
        User newUser = new User();
        newUser.Alias = 'test';
        newUser.Email = 'one@test.sbsa.co.za';
        newUser.Emailencodingkey = 'UTF-8';
        newUser.Lastname = 'UserTest';
        newUser.Languagelocalekey = 'en_US';
        newUser.City = 'Johannesburg';
        newUser.Country = 'South Africa';
        newUser.Division__c = 'CIB';
        newUser.BRID__c = String.valueOf(Math.random()).left(9);
        newUser.Localesidkey = 'en_US';
        newUser.Profileid = cscUserProfile.Id;
        newUser.Timezonesidkey = 'America/Los_Angeles';
        newUser.Username = 'username@testuser.com';
        insert newUser;
        
        System.runAs(newUser) {
            Case testCase = new Case();
            testCase.Subject = 'Support test';
            testCase.Origin = 'Email';
            testCase.Status = 'New';
            testCase.Priority = 'High';
            insert testCase;
        }
        
    }
}