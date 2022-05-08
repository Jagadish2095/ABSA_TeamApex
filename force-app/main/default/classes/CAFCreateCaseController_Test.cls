/**
 *
 * @description Method to CAFCreateCaseController_Test
 * @author  Jaco de Lange 
 * @date: 08/01/2021
 * @param  
 *
 */
@isTest
public class CAFCreateCaseController_Test {
    /**
 *
 * @description Method to CAFCreateCaseController_Test
 * @author  
 * @date: 
 * @param  
 *
 */
    @testSetup
    static void dataCreation(){
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'test';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        sysAdminUser.EmployeeNumber = '12345';
        insert sysAdminUser; 
        
        Service_Group__c sg = new Service_Group__c (
        Name = 'CAF Onboarding',
        Queue__c = 'Sales Support Consultants'    
        );
		insert sg;
        
        Service_Group_Type__c sgt = new Service_Group_Type__c (
        Service_Group__c = sg.Id
        );
        insert sgt;
        
        CAF_site_code__c cafsc = new CAF_site_code__c (
        Name='sitecode');//Region__c = 'AF Kzn Corporate'
        insert cafsc;
        
        Vehicle_Make_Model__c vmm = new Vehicle_Make_Model__c (
        MM_Code__c = '123',
        Name = 'vehiclemakemodel',
        Make__c = 'testmake',
        Model__c = 'testmodel');
        insert vmm;
        
		Integration_Translation__c it_clientType = new Integration_Translation__c (
        External_Value__c = 'test external client',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Client Type',
        Internal_Value__c = 'Individual',
        Direction__c = 'Outbound');
        insert it_clientType;
        
        Integration_Translation__c it_identityType = new Integration_Translation__c (
        External_Value__c = 'test external id',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Identity Type',
        Internal_Value__c = 'SA Identity Document',
        Direction__c = 'Outbound');
        insert it_identityType;
        
        Integration_Translation__c it_language = new Integration_Translation__c (
        External_Value__c = 'test external language',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Language',
        Internal_Value__c = 'Afrikaans',
        Direction__c = 'Outbound');
        insert it_language;
        
        Integration_Translation__c it_fyEnd = new Integration_Translation__c (
        External_Value__c = 'test external fyend',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Financial Year End',
        Internal_Value__c = 'June',
        Direction__c = 'Outbound');
        insert it_fyEnd;
        
        Integration_Translation__c it_pcm = new Integration_Translation__c (
        External_Value__c = 'test external pcm',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Preferred Communication Method',
        Internal_Value__c = 'SMS',
        Direction__c = 'Outbound');
        insert it_pcm;
        
        Integration_Translation__c it_at = new Integration_Translation__c (
        External_Value__c = 'test external at',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Account Type',
        Internal_Value__c = 'Cheque',
        Direction__c = 'Outbound');
        insert it_at;
        
        Integration_Translation__c it_coo = new Integration_Translation__c (
        External_Value__c = 'test external coo',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Country',
        Internal_Value__c = 'South Africa',
        Direction__c = 'Outbound');
        insert it_coo;
        
        Integration_Translation__c it_ft = new Integration_Translation__c (
        External_Value__c = 'test external ft',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Finance Type',
        Internal_Value__c = 'Lease',
        Direction__c = 'Outbound');
        insert it_ft;
        
        Integration_Translation__c it_pf = new Integration_Translation__c (
        External_Value__c = 'test external pf',
        System_Name__c = 'CIF', 
        Value_Type__c = 'Payment Frequency',
        Internal_Value__c = 'Monthly',
        Direction__c = 'Outbound');
        insert it_pf;
        
        Integration_Translation__c it_assettype = new Integration_Translation__c (
        External_Value__c = 'test external at',
        System_Name__c = 'CIF', 
        Value_Type__c = 'CAF Asset Type',
        Internal_Value__c = 'Light Duty Vehicle',
        Direction__c = 'Outbound');
        insert it_assettype;
        
        Account acc = new Account();
        acc.CIF__c= 'ZUMA123';
        acc.Language__c = 'Afrikaans';
        acc.Preferred_Communication_Method__c = 'SMS';
        acc.Income_Tax_Number__c = '123456';
        acc.Financial_Year_End__c = 'June';
        acc.PersonMobilePhone= '0478956208';
        acc.Initials__pc= 'S';
        acc.PersonTitle= 'Mr';
        acc.Registration_Number__c = '1111';
        acc.ID_Type__c = 'SA Identity Document';
        acc.LastName= 'Mathe';
        acc.BillingStreet= '15 Johhanesburg';
        acc.BillingCity= 'Sandton';
        acc.BillingPostalCode= '2001';
        acc.ID_Type__pc= 'SA Identity Document';
        acc.ID_Number__pc= '9202031586089';
        acc.PersonBirthdate = Date.newInstance(1992, 2, 3);
        acc.Client_Type__c= 'Individual';
        acc.Gender__pc= 'Male';
        acc.Number_Of_Dependents__c = 2.00;
        acc.Occupation_Category__pc= 'Actuary';
        acc.Client_ever_been_declared_Insolvent__c = false;
        acc.Marital_Contract_Type__pc= 'In Community Of Property';
        acc.Home_Language__pc= 'English';
        acc.Income_Tax_Number__pc = '1.00';
        acc.FirstName= 'ABSA';
        acc.Occupation_Status__pc= 'Full Time Employed';
        acc.PersonEmail= 'test@test.com';
        acc.Preferred_Communication_Method__pc= 'Email';
        acc.Sic= '0000';
        acc.Client_Group__c = 'SOLE TRADER CLIENT';
        acc.Source_of_Income__c= 'PENSION';
        acc.Date_Identified__c  = Date.newInstance(2020, 12, 9);
        acc.Nationality__pc= 'South Africa';
        acc.Date_Issued__pc  = Date.newInstance(2016, 11, 9);
        acc.CASA_Reference_Number__pc= '7877';
        acc.Marital_Status__pc= 'Married';
        acc.Communication_Language__pc= 'English';
        acc.Monthly_Income__pc= 'R15000 - 19999';
        acc.SIC_Classification_1__c = 'Almond Nuts';
        acc.SIC_Classification_2__c = 'Apples';
        acc.SIC_Classification_3__c = 'Avocados' ;
        acc.PersonHomePhone = '0115896543'; 
        acc.Non_Credit_Marketing_Consent__pc = 'Yes';
        acc.Credit_Marketing_Consent__pc = 'Yes';
        acc.Phone = '0784512964';
        acc.Country_of_Operation__c = 'South Africa';
        acc.Foreign_Tax_Number__c = 0;
        acc.Credit_Marketing_Indicator__pc = 'Email;Mail;Phone;SMS;Voice Recording';
        insert acc; 
        
        Id personaccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();

        Account persacc = new Account (
        ID_Number__pc = '6803037015089',
        ID_Type__pc = 'SA Identity Document',
        Initials__pc = 'I',
        PersonTitle = 'Mr',
        Client_Type__c = 'Individual Client',
        CASA_Reference_Number__pc = '12454' ,
        CASA_Screening_Status__pc = 'Matched',    
        FirstName='firstname',
        LastName='lastname',  
        RecordTypeId = personaccRecordTypeId, 
        Phone='321654789',    
        Fax='45678941');
        insert persacc;
        
        Account pacc = [SELECT PersonContactId FROM Account WHERE Id =: persacc.Id];
        Id personContactId = pacc.PersonContactId;
        
        AccountContactRelation acr = new AccountContactRelation (
        AccountId=acc.Id,
        ContactId=personContactId,
        Roles='Contact Person',
        Share_Percentage__c = 50);
        insert acr;
       
        Address__c businessAdd = new Address__c();
        businessAdd.Account__c = acc.Id;    
        businessAdd.Shipping_City__c = '';
        businessAdd.Shipping_Country__c = 'South Africa';
        businessAdd.Shipping_Zip_Postal_Code__c = '0850';
        businessAdd.Shipping_Street__c = 'PLAAS JAFFRAY';
        businessAdd.Shipping_Street_2__c = 'TZANEEN';
        businessAdd.Shipping_Suburb__c = '';
        businessAdd.Client_Entity_Type__c  = 'Sole Trader';
        businessAdd.Address_Type__c = 'Business Address';
        insert businessAdd;
          
        Address__c postalAdd = new Address__c();
        postalAdd.Account__c = acc.Id;    
        postalAdd.Shipping_City__c = '';
        postalAdd.Shipping_Country__c = 'South Africa';
        postalAdd.Shipping_Zip_Postal_Code__c = '0850';
        postalAdd.Shipping_Street__c = 'PLAAS JAFFRAY';
        postalAdd.Shipping_Street_2__c = 'TZANEEN';
        postalAdd.Shipping_Suburb__c = '';
        postalAdd.Client_Entity_Type__c = 'Sole Trader';
        postalAdd.Address_Type__c = 'Postal';
        insert postalAdd;
          
        Address__c physicalAdd = new Address__c();
        physicalAdd.Account__c = acc.Id;   
        physicalAdd.Shipping_City__c = '';
        physicalAdd.Shipping_Country__c = 'South Africa';
        physicalAdd.Shipping_Zip_Postal_Code__c = '0850';
        physicalAdd.Shipping_Street__c = 'PLAAS JAFFRAY';
        physicalAdd.Shipping_Street_2__c = 'TZANEEN';
        physicalAdd.Shipping_Suburb__c = '';
        physicalAdd.Client_Entity_Type__c = 'Sole Trader';
        physicalAdd.Address_Type__c = 'Physical Address';
        insert physicalAdd;
        
        //Oportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'MerchantDeviceControllerTest';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        opp.Annual_turnover__c = 500;
        Insert opp;  
        
        Case fulfilmentcase = new Case(
        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId(),
        Status ='Review Context',
        Opportunity__c = opp.Id,
        Product__c ='CAF',
        Subject='CAF Case',
        Bypass_Validation_Rules__c = true,
        Relationship_Banker__c = opp.OwnerId,
        AccountId = acc.id,
        Type ='CAF Fulfilment',
        //Application_Product_Id__c = application.Id,
        External_Reference_Type__c = 'BCMS',
        //External_Reference_Number__c = '0d7b9d05-a783-4c2d-b7fc-36f2396dd040',
        Get_SAP_Ref_No__c = true
        );
        insert fulfilmentCase;
                
        //Application Product CAF
        Application_Product_CAF__c application = new Application_Product_CAF__c();
        application.Client_Details__c = acc.id;
        application.Case__c = fulfilmentCase.Id;
        application.Landlord_Full_Name__c = 'landlordfullname';
        application.Landlord_Address__c = 'address';
        application.Vehicle_Make_Model_Id__c = vmm.Id;
        application.Insurance_Policy_Number__c = '123456';
        application.Insurance_Company_Name__c = 'ABSA';
        application.Bank_name__c = 'ABSA';
        application.Sales_branch__c = 'ABSAB';
        application.Account_type__c = 'Cheque';
        application.Account_number__c = 123456789;
        application.Account_holder__c = 'accholder';
        application.Contract_Email__c = 'test@test.co.za';
        application.Dealer_Code__c = '32165';
        application.Sales_person_full_name__c = 'salesperson';
        application.Contact_number__c = '0828596325';
		application.Marketer_BDO_User__c = sysAdminUser.Id;
		application.CAF_sitecode__c = cafsc.Id;
        application.Do_you_have_short_term_insurance__c = true;
        application.Asset_Type__c = 'Light Duty Vehicle';
        application.Article_Type__c= 'Demo';
        application.Year_First_Registered__c= 2018;
        application.Mileage__c= 12;
        application.Registration_Number__c= 'SNYTUU67';
        application.VIN_Chassis_Number__c= 'VIN67755';
        application.Serial_Number__c = 'SN7GGT77';
        application.Description__c= 'My BMW';
        application.Contract_Type__c= 'Lease';
        application.Purchase_price_amount_excl_VAT__c= 12;
        application.VAT_amount__c= 12;   
        application.Commercial_document_fee__c= 12; 
        application.Commercial_asset_finance__c = 'ANI00 - LIVESTOCK';
        application.Service_fee_incl_VAT__c= 12;
        application.Initiation_fee__c= 12;
        application.Deposit_amount__c= 12;
        application.Dealer_Trade_in_amount__c= 12;
        application.Dealer_Cash_deposit_amount__c= 12;
        application.Residual_Value__c= 12;
        application.Payment_frequency__c= 'Monthly';
        application.Term_in_months__c= 6;
        application.Interest_rate__c= 12;
        application.Fixed_or_linked__c= '';
        application.Commencement_Date__c= Date.today();
        application.X1st_payment_date__c= Date.today();
        application.Joint_venture_alliance_code__c= '';
        application.Pay_DIC_to_dealer__c= false;
        application.Statement_delivery_method__c= 'Email';
        application.Landlord_Waiver__c= 'Yes';
        application.Dealer_Trading_name_or_code__c= 'John Car Dealer - DWX2020';
        application.VAT_Pay_Back__c= 'MONTH 3';
        application.Credit_Line__c= ' No';
        application.Type_of_request__c= 'New';
        application.CAF_site_code__c= '1255';
        //application.Region__c= 'SME Centre';
        application.Absa_site_code__c= '1234';
        //application.Sanctioner_work_queue_regions__c= 'SME Centre';
        application.Sales_branch__c= 'ABSAB';
        application.Mandate_holder__c= 'CAF';
        application.Additional_comments__c= 'Testing';
        insert application;

		fulfilmentCase.Application_Product_Id__c = application.Id;
        fulfilmentCase.External_Reference_Number__c = '0d7b9d05-a783-4c2d-b7fc-36f2396dd040';
        update fulfilmentCase;    
        
        Document__c docOpp1 = new Document__c (
        Name = 'docname',
        Reference__c = 'ref',
        Opportunity__c = opp.Id,
        Application_Product_CAF__c = application.Id    
        );
        insert docOpp1;
        
        Document__c docOpp2 = new Document__c (
        Name = 'docname',
        Reference__c = 'ref',
        Opportunity__c = opp.Id 
        );
        insert docOpp2;
                  
        Product2 product = new Product2();
        product.Name = 'Business Evolve';
        product.Product_Classification__c = 'Package';
        insert product;
          
        Id pricebookId = Test.getStandardPricebookId(); 
        
        Pricebook2 standardPricebook = new Pricebook2(Id = pricebookId,IsActive = true);
        update standardPricebook;

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = product.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
 
        OpportunityLineItem oliEx = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 5,
        Type__c='Extras',    
        PricebookEntryId = standardPrice.Id,
        TotalPrice = 5 * standardPrice.UnitPrice,
        Application_Product_CAF__c = application.id);
        insert oliEx;
    }
    /**
 *
 * @description Method to CAFCreateCaseController_Test
 * @author  
 * @date: 
 * @param 
 *
 */
      @isTest static void getSourceOfIncomeTest() {       
          Application_Product_CAF__c application = [SELECT Id from Application_Product_CAF__c LIMIT 1];
          system.assert(application!=null);
          Case c = [SELECT Id, CaseNumber, External_Reference_Number__c, Get_SAP_Ref_No__c from Case LIMIT 1];
          system.assert(c!=null);

          Test.startTest();
          	CAFCreateCasecontroller.sendCaseToBCMS(application.Id, c.CaseNumber);
            CAFCreateCasecontroller.caseUpdateInBCMS(application.Id);
          	CAFCreateCasecontroller.createCase(application.Id);
          	CAFCreateCaseController.updateCase(c.CaseNumber, c.External_Reference_Number__c, application.Id);
          Test.stopTest();     
    } 
}