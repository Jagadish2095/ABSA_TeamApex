@isTest
public class MaterialDisclosuresControllerTest {

    @isTest
    static  void testMaterialDiscosures(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testClause.Clause_Type__c = 'Material Disclosure';
        testDataFactory.testClause.Text_Content__c = '{!clause.First Year Commission}';
        update testDataFactory.testClause;

        Clause__c clause1 = new Clause__c();
        clause1 = testDataFactory.testClause;
        clause1.Text_Content__c = '{!clause.Second Year Commission}';
        clause1.Id = null;
        insert clause1;
        
        
        Clause__c clause2 = new Clause__c();
        clause2 = testDataFactory.testClause;
        clause2.Text_Content__c = '{!clause.IsJointLife}';
        clause2.Id = null;
        insert clause2;
        
        Clause__c below65 = new Clause__c();
        below65 = testDataFactory.testClause;
        below65.Name = 'EPP Material Disclosure: Clause 6 - <= 64';
        below65.Text_Content__c = 'EPP Material Disclosure: Clause 6 - <= 64';
        below65.Id = null;
        insert below65;
        
        Clause__c above65 = new Clause__c();
        above65 = testDataFactory.testClause;
        above65.Name = 'EPP Material Disclosure: Clause 6 - >= 65';
        above65.Text_Content__c = 'EPP Material Disclosure: Clause 6 - >= 65';
        above65.Id = null;
        insert above65;
        
        Clause__c clause6 = new Clause__c();
        clause6 = testDataFactory.testClause;
        clause6.Name = 'EPP Material Disclosure: Clause 6';
        clause6.Text_Content__c = 'EPP Material Disclosure: Clause 6';
        clause6.Id = null;
        insert clause6;
        
        Date todaysDate = date.today();
        Date above65Date = todaysDate.addYears(-66);
        Date below65Date = todaysDate.addYears(-63);
        Account updateAccount = new Account();
        updateAccount = testDataFactory.testAccount;
        Opportunity_Party__c spouse = new Opportunity_Party__c();
        spouse = testDataFactory.testOpportunityPartyDependantSpouse;
        
        Test.startTest();
        
        updateAccount.PersonBirthdate = below65Date;
        update updateAccount;
        List<Clause__c> listOfClauses1 = MaterialDisclosuresController.getMaterialDisclosureData(testDataFactory.testOpportunity.id);
        spouse.Date_of_Birth__c = below65Date;
        update spouse;        
        List<Clause__c> listOfClauses2 = MaterialDisclosuresController.getMaterialDisclosureData(testDataFactory.testOpportunity.id);
        updateAccount.PersonBirthdate = above65Date;
        update updateAccount;
        List<Clause__c> listOfClauses3 = MaterialDisclosuresController.getMaterialDisclosureData(testDataFactory.testOpportunity.id);
        spouse.Date_of_Birth__c = above65Date;
        update spouse;        
        List<Clause__c> listOfClauses4 = MaterialDisclosuresController.getMaterialDisclosureData(testDataFactory.testOpportunity.id);
        
        MaterialDisclosuresController.checkInitValidity(testDataFactory.testOpportunity.id);
        List<Clause__c> lst = new List<Clause__c>();
        lst.add(testDataFactory.testClause);
        MaterialDisclosuresController.saveMaterialDisclosureData(testDataFactory.testOpportunity.id, lst);
        MaterialDisclosuresController.checkSelected(testDataFactory.testOpportunity.id); 

        
        Test.stopTest();
        System.assertEquals(above65Date, updateAccount.PersonBirthdate);
    }

    @IsTest
    static  void testMaterialDiscosuresDirectDeliveryOpp(){

        Financial_Product__c finProduct = new Financial_Product__c();
        finProduct.Name = 'Flexi Funeralt';
        finProduct.Product_Type__c = 'Retail Banking';
        finProduct.Business_Unit__c = 'Retail Banking';
        finProduct.Product__c = 'Flexi Funeral';
        insert finProduct;

        Clause__c ddClause = new Clause__c();
        ddClause.Name = 'Test';
        ddClause.Text_Content__c = 'Test';
        ddClause.Financial_Product__c = finProduct.Id;
        ddClause.Clause_Type__c = 'Material Disclosure';

        insert ddClause;

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Account acc = new Account();
        Opportunity opp = new Opportunity();
        acc = testDataFactory.testAccount;
        acc.PersonMobilePhone = '0832792842';
        acc.Alternative_Email__c = 'fake@email.co.za';
        acc.PersonEmail = 'fake@email1.co.za';

        update acc;

        opp = testDataFactory.testOpportunity;
        opp.AccountId = acc.Id;
        opp.Product_Interest__c = finProduct.Id;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Opportunity').getRecordTypeId();
        update opp;

        Quote q = testDataFactory.testQuote;
        q.OpportunityId = opp.Id;
        q.Product_Name__c = 'Flexi Funeral';
        q.Description = 'Flexi Funeral';
        update q;

        QuickText qt = new QuickText();
        qt.Name = 'Flexi Funeral';
        qt.Message = 'This is a test message';
        insert qt;

        Test.startTest();
        MaterialDisclosuresController.getDirectDeliveryMaterialDisclosureData(opp.Id,'Flexi Funeral');
        MaterialDisclosuresController.checkInitValidityOnQuote(opp.Id,'Flexi Funeral');
        MaterialDisclosuresController.saveDirectDeliveryMaterialDisclosureData(opp.Id,new List<Clause__c>{ddClause},'Flexi Funeral');
        Test.stopTest();

        Opportunity updatedOpp = [SELECT Id, Material_Disclosures__c FROM Opportunity WHERE Id =: opp.Id];
        Quote updatedQupte = [SELECT Id, Material_Disclosure_Status__c FROM Quote WHERE Id =: q.Id];

        //System.debug('opp.Material_Disclosures__c >>>' + updatedOpp.Material_Disclosures__c);
        System.assertEquals(true, updatedOpp.Material_Disclosures__c.contains(ddClause.Id));
        System.assertEquals('Valid',updatedQupte.Material_Disclosure_Status__c);


    }
    @IsTest
    static  void testMaterialDiscosuresDirectDeliveryLead(){
        Financial_Product__c finProduct = new Financial_Product__c();
        finProduct.Name = 'Flexi Funeral';
        finProduct.Product_Type__c = 'Retail Banking';
        finProduct.Business_Unit__c = 'Retail Banking';
        finProduct.Product__c = 'Flexi Funeral';
        insert finProduct;

        Clause__c ddClause = new Clause__c();
        ddClause.Name = 'Test';
        ddClause.Text_Content__c = 'Test';
        ddClause.Financial_Product__c = finProduct.Id;
        ddClause.Clause_Type__c = 'Material Disclosure';

        insert ddClause;

        Id directDeliveryRecType =  Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();

        Lead newLead = new Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'Lead';
        newLead.Status = 'Allocated';
        newLead.MobilePhone = '0832792842';
        newLead.Email = 'fake@mail.co.za';
        newLead.Hot_Deal__c = false;
        newLead.RecordTypeId = directDeliveryRecType;
        newLead.LeadSource = 'Web';
        newLead.Financial_Product__c = finProduct.Id;
        newLead.Product_Interest_1__c = finProduct.Id;
        newLead.Product_Offer_Status_1__c = 'Offer Taken Up';

        insert newLead;

        QuickText qt = new QuickText();
        qt.Name = 'Flexi Funeral';
        qt.Message = 'This is a test message';
        insert qt;

        Test.startTest();
        MaterialDisclosuresController.getDirectDeliveryMaterialDisclosureData(newLead.Id,'Flexi Funeral');
        MaterialDisclosuresController.checkInitValidityOnQuote(newLead.Id,'Flexi Funeral');
        MaterialDisclosuresController.saveDirectDeliveryMaterialDisclosureData(newLead.Id,new List<Clause__c>{ddClause},'Flexi Funeral');
        Test.stopTest();

        Lead updatedLead = [SELECT Id, Material_Disclosure_Status__c FROM Lead WHERE Id =: newLead.Id];
        System.assertEquals('Valid',updatedLead.Material_Disclosure_Status__c);
    }

}