/**
* @description Test Data Factory for Absa Life Member 
* @author  Brian Maswanganyi
* @created 2021-10-17
*/
@isTest
public class BranchAbsaLifeTestDataFactory  {
    public static Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    //public static final String PolicyDataString  = '{"UnderwritingItems":null,"TotalPremium":"65","TotalCover":"400","TotalCommission":0,"SpousesString":null,"Spouses":null,"Spouse":{"GUID":"e320b2d9-3827-44df-be1a-f0ac2cee3fb6","Age":2020,"DateOfBirth":"0001-01-01T00:00:00","FirstName":"","FullName":",","Gender":"Unknown","Initials":"","MemberType":"Unknown","Name":",","Names":"","RsaIdNumber":"","ShortName":"","Surname":"","Title":"Unknown","Benefit":{"GUID":"5b32a3ec-1f77-40f7-9419-0669cd8d37d1","BenefitID":230120000,"Cover":15000,"CoverIncrease":5,"Loadings":0,"Option":0,"Premium":0,"PremiumIncrease":5,"PremiumLoadings":null,"TotalPremium":0},"BenefitOption":0,"Benefits":{"Benefit":[{"GUID":"5b32a3ec-1f77-40f7-9419-0669cd8d37d1","BenefitID":230120000,"Cover":15000,"CoverIncrease":5,"Loadings":0,"Option":0,"Premium":0,"PremiumIncrease":5,"PremiumLoadings":null,"TotalPremium":0}]},"Cover":15000,"Loadings":0,"Premium":0,"Relationship":"SPOUSE","Passport":""},"Signatories":null,"Premium":"65","PolicyInfo":{"State":"Draft","ProposalNumber":null,"PolicyNumber":null,"Name":"ABSA Health Assistance Cover","Issue":"2021-08-29T12:45:07.0705227+02:00","Inception":"2021-10-01T00:00:00","GUID":"42d19400-9973-4209-81ba-fa291b674053","ErrorReasons":null,"ErrorReason":null,"Disclosure":"false","ContractOptionID":"250000001","ContractID":"250000000","Application":"2021-08-29T12:30:00.5727821+02:00"},"PolicyBenefit":{"TotalPremium":"65","PremiumLoadingsString":null,"PremiumLoadings":null,"PremiumIncrease":"5","Premium":"65","Option":"0","Loadings":"0","GUID":"c9aaa285-709e-48b1-9f53-2117b42dd5b3","CoverIncrease":"5","Cover":"400","BenefitID":"250020000"},"ModuleID":"WIMAL00102","MainMember":{"Title":"Unknown","Surname":"Herceg","ShortName":"C Herceg","RsaIdNumber":"5111117093088","Names":"Cvitko, C","Name":"Herceg, Cvitko","MemberType":"Individual","Initials":"C","GUID":"7b0eede1-fc1f-434a-b573-a26f27067617","Gender":"Male","FullName":"Herceg, Cvitko","FirstName":"Cvitko","DateOfBirth":"1951-11-11T00:00:00","Age":"69","WillNumber":null,"SourceOfIncome":"20","SourceOfFunds":"20","Premium":"65","Occupation":null,"Nationality":"SOU01","MaritalStatus":"Single","Loadings":"0","Language":"Unknown","IsStaff":"false","IsSouthAfrican":"true","IsIndividual":"true","IncomeBand":"Unknown","EmailAddress":null,"Cover":"400","CountryOfResidence":"SO003","CountryOfBirth":"SO003","ContactDetails":{"WorkTelephone":null,"PostalAddress":{"SingleLine":"1738 PRESIDENT ST, JOHANNESBURG","PostalCode":"2090","Line4":null,"Line3":"JOHANNESBURG","Line2":null,"Line1":"1738 PRESIDENT ST","GUID":"bd10277d-d4cd-46af-b9aa-e9e09757c439"},"PhysicalAddress":{"SingleLine":"1738 PRESIDENT STREET, JOHANNESBURG","PostalCode":"2090","Line4":null,"Line3":"JOHANNESBURG","Line2":null,"Line1":"1738 PRESIDENT STREET","GUID":"dd179f81-0152-4002-83b8-ef8feb34615f"},"OptIn":"false","HomeTelephone":null,"GUID":"411e2ba3-5abd-4b40-8ff4-d17b0d59d7fd","EmailAddress":"cvitkoherceg@rhyta.com","CellTelephone":"0783452367"},"CifClientCode":"HERCEC 001","CasaReferenceNumber":"121267034","Benefits":{"BenefitObj":null,"Benefit":[{"TotalPremium":"65","PremiumLoadingsString":null,"PremiumLoadings":null,"PremiumIncrease":"5","Premium":"65","Option":"0","Loadings":"0","GUID":"c9aaa285-709e-48b1-9f53-2117b42dd5b3","CoverIncrease":"5","Cover":"400","BenefitID":"250020000"}]},"BenefitOption":"0","BenefitObj":null,"Benefit":{"TotalPremium":"65","PremiumLoadingsString":null,"PremiumLoadings":null,"PremiumIncrease":"5","Premium":"65","Option":"0","Loadings":"0","GUID":"c9aaa285-709e-48b1-9f53-2117b42dd5b3","CoverIncrease":"5","Cover":"400","BenefitID":"250020000"}},"Loadings":"0","GUID":"a687c5b0-7adb-4873-8cf1-ca808c1d0ae8","Flags":{"KeyValueOfstringstring":[{"Value":"False","Key":"IncludeParent"},{"Value":"False","Key":"IncludeSpouse"},{"Value":"False","Key":"IncludeChildren"},{"Value":"True","Key":"AnnualCoverPremiumIncrease"}]},"Dependents":null,"DebitDetails":{"ThirdParty":"false","SalaryDay":"0","GUID":"9e4b1a09-afa6-44d9-b425-b9da85ecfc74","DebitDay":"0","DebitDate":"0001-01-01T00:00:00","DebitAccountNumber":null,"BranchClearingCode":null,"Branch":null,"Bank":null,"AccountType":"Cheque","AccountHolder":null},"Cover":"400","Children":null,"Beneficiaries":null,"Application":{"Replacement":{"ReplacementDate":null,"PolicyNumber":null,"IsReplacement":"false","GUID":"e517d208-896f-4257-aa28-6d53faa53b33","Company":null},"IsClientPresent":"true","IsBranchSales":"true","GUID":"3811e0fd-c6a5-426a-8ba4-5c06b2571d97","DistributionChannel":"BranchSales","Declaration":{"Supervisor":null,"Name":null,"IsSupervised":"false","IsFit":"false","GUID":"af1ea367-d97e-453f-aef9-90109417e3f8","Advice":"false"},"Consultant":{"SiteCode":"8007","PRINumber":null,"Name":"Tumi Mokomane","IntermediaryCode":null,"GUID":"9192464f-cb25-4cbb-b7fb-d4d2eeb0221e","EmployeeNumber":"5035555","Branch":null,"ABNumber":"abbmago"},"Agent":{"SiteCode":null,"RsaIdNumber":null,"PRINumber":null,"Name":null,"GUID":"65c240af-8d46-45c3-b80a-70e7f49f3443","EmployeeNumber":null,"DistributionChannel":"BranchSales"}}}';
    public static final String PolicyDataString  = '{"UnderwritingItems":{"UnderwritingItem":[{"Value":"false","ID":"93","GUID":"99c16cd2-9cef-4964-a105-f12badad3c4b"},{"Value":"false","ID":"94","GUID":"2b6db034-200b-4b63-a251-c582aa09834f"},{"Value":"false","ID":"95","GUID":"974229d4-384d-4cfa-b768-ed3dc9238702"}]},"TotalPremium":"253","TotalCover":"120000","TotalCommission":8.2225,"Spouses":{"Dependent":[{"Title":"Unknown","Surname":"Woods","ShortName":"G Woods","RsaIdNumber":"8901270000000","Names":"Gilly, G","Name":"Woods, Gilly","MemberType":"Unknown","Initials":"G","GUID":"5ea7043e-fec2-403b-94d8-c1a564067688","Gender":"Unknown","FullName":"Woods, Gilly","FirstName":"Gilly","DateOfBirth":"1989-01-27T00:00:00","Age":"30","Relationship":"SPOUSE","Premium":"106","Loadings":"0","Cover":"60000","Benefits":{"Benefit":[{"TotalPremium":"73","PremiumIncrease":"0","Premium":"73","Option":"0","Loadings":"0","GUID":"7343bf88-b91b-4486-afa9-abeea81296e1","CoverIncrease":"0","Cover":"40000","BenefitID":"UEFS"},{"TotalPremium":"33","PremiumIncrease":"0","Premium":"33","Option":"0","Loadings":"0","GUID":"768465d5-bb1c-4f29-8865-325fb29a9009","CoverIncrease":"0","Cover":"20000","BenefitID":"UBRS"}]},"BenefitOption":"12","Benefit":{"TotalPremium":"73","PremiumIncrease":"0","Premium":"73","Option":"0","Loadings":"0","GUID":"7343bf88-b91b-4486-afa9-abeea81296e1","CoverIncrease":"0","Cover":"40000","BenefitID":"UEFS"}}]},"Spouse":{"Title":"Unknown","Surname":"Woods","ShortName":"G Woods","RsaIdNumber":"8901270000000","Names":"Gilly, G","Name":"Woods, Gilly","MemberType":"Unknown","Initials":"G","GUID":"5ea7043e-fec2-403b-94d8-c1a564067688","Gender":"Unknown","FullName":"Woods, Gilly","FirstName":"Gilly","DateOfBirth":"1989-01-27T00:00:00","Age":"30","Relationship":"SPOUSE","Premium":"106","Loadings":"0","Cover":"60000","Benefits":{"Benefit":[{"TotalPremium":"73","PremiumIncrease":"0","Premium":"73","Option":"0","Loadings":"0","GUID":"7343bf88-b91b-4486-afa9-abeea81296e1","CoverIncrease":"0","Cover":"40000","BenefitID":"UEFS"},{"TotalPremium":"33","PremiumIncrease":"0","Premium":"33","Option":"0","Loadings":"0","GUID":"768465d5-bb1c-4f29-8865-325fb29a9009","CoverIncrease":"0","Cover":"20000","BenefitID":"UBRS"}]},"BenefitOption":"12","Benefit":{"TotalPremium":"73","PremiumIncrease":"0","Premium":"73","Option":"0","Loadings":"0","GUID":"7343bf88-b91b-4486-afa9-abeea81296e1","CoverIncrease":"0","Cover":"40000","BenefitID":"UEFS"}},"Premium":"243","PolicyInfo":{"State":"Draft","Name":"Estate Provider Plan","Issue":"2019-10-22T10:34:58.6827109+02:00","Inception":"2019-11-01","GUID":"82ef5883-e766-46a0-956f-20989c2771ec","ErrorReasons":"","ErrorReason":{},"Disclosure":"false","ContractOptionID":"10000001","ContractID":"EPP","Application":"2019-10-22T10:34:55.385764+02:00"},"PolicyBenefit":{"TotalPremium":"0","PremiumIncrease":"0","Premium":"0","Option":"0","Loadings":"0","GUID":"9216b828-a4b8-4ed2-ac66-9504526116a6","CoverIncrease":"0","Cover":"0"},"ModuleID":"EPP","MainMember":{"Title":"Mr","Surname":"WOODS","ShortName":"M WOODS","RsaIdNumber":"7409146248089","Names":"EMILY, M","Name":"WOODS, EMILY","MemberType":"Individual","Initials":"M","GUID":"d61b4061-1635-4739-bf23-6f5317951684","Gender":"Male","FullName":"WOODS, EMILY","FirstName":"EMILY","DateOfBirth":"1974-09-14T00:00:00","Age":"45","WillNumber":"74091462480","SourceOfIncome":"27","SourceOfFunds":"27","Premium":"137","Nationality":"SOU01","MaritalStatus":"Married","Loadings":"0","Language":"Unknown","IsStaff":"false","IsSouthAfrican":"true","IsIndividual":"true","IncomeBand":"Unknown","Cover":"60000","CountryOfResidence":"SO003","CountryOfBirth":"SO003","ContactDetails":{"WorkTelephone":"234567890","PostalAddress":{"SingleLine":"109 KATHERINE STREET, SANDTON","PostalCode":"2196","Line3":"SANDTON","Line1":"109 KATHERINE STREET","GUID":"4dd76717-6a05-48ac-85fe-f27399e468cb"},"PhysicalAddress":{"SingleLine":"109 KATHERINE STREET, SANDTON","PostalCode":"2196","Line3":"SANDTON","Line1":"109 KATHERINE STREET","GUID":"eb23f738-d223-46cd-b3e7-a002c4a3e1f1"},"OptIn":"false","GUID":"0c860c44-25fc-4d09-b9c6-54cb30580b4a","EmailAddress":"jamie.muir@absa.africa","CellTelephone":"0839909967"},"CifClientCode":"WOODSM 004","CasaReferenceNumber":"121100885","Benefits":{"Benefit":[{"TotalPremium":"0","PremiumIncrease":"0","Premium":"0","Option":"0","Loadings":"0","GUID":"9216b828-a4b8-4ed2-ac66-9504526116a6","CoverIncrease":"0","Cover":"0"},{"TotalPremium":"95","PremiumIncrease":"0","Premium":"95","Option":"0","Loadings":"0","GUID":"3c24a732-68a0-43a5-a380-ebe88b73328e","CoverIncrease":"0","Cover":"40000","BenefitID":"UEF"},{"TotalPremium":"42","PremiumIncrease":"0","Premium":"42","Option":"0","Loadings":"0","GUID":"45805dd3-8194-4d91-a478-d658835a75a4","CoverIncrease":"0","Cover":"20000","BenefitID":"UBR"}]},"BenefitOption":"12","Benefit":{"TotalPremium":"0","PremiumIncrease":"0","Premium":"0","Option":"0","Loadings":"0","GUID":"9216b828-a4b8-4ed2-ac66-9504526116a6","CoverIncrease":"0","Cover":"0"}},"Loadings":"0","GUID":"bb3b7a63-9f49-418e-81dd-78f2bbc5ba32","Flags":{"KeyValueOfstringstring":[{"Value":"True","Key":"Underwritten"},{"Value":"True","Key":"MMEstateBridging"},{"Value":"True","Key":"MMExecutorsFee"},{"Value":"False","Key":"MMFamilyFuneral"},{"Value":"True","Key":"SpouseEstateBridging"},{"Value":"True","Key":"SpouseExecutorsFee"},{"Value":"False","Key":"SpouseFuneral"}]},"Dependents":{"Dependent":[{"Title":"Unknown","Surname":"Woods","ShortName":"G Woods","RsaIdNumber":"8901270000000","Names":"Gilly, G","Name":"Woods, Gilly","MemberType":"Unknown","Initials":"G","GUID":"5ea7043e-fec2-403b-94d8-c1a564067688","Gender":"Unknown","FullName":"Woods, Gilly","FirstName":"Gilly","DateOfBirth":"1989-01-27T00:00:00","Age":"30","Relationship":"SPOUSE","Premium":"106","Loadings":"0","Cover":"60000","Benefits":{"Benefit":[{"TotalPremium":"73","PremiumIncrease":"0","Premium":"73","Option":"0","Loadings":"0","GUID":"7343bf88-b91b-4486-afa9-abeea81296e1","CoverIncrease":"0","Cover":"40000","BenefitID":"UEFS"},{"TotalPremium":"33","PremiumIncrease":"0","Premium":"33","Option":"0","Loadings":"0","GUID":"768465d5-bb1c-4f29-8865-325fb29a9009","CoverIncrease":"0","Cover":"20000","BenefitID":"UBRS"}]},"BenefitOption":"12","Benefit":{"TotalPremium":"73","PremiumIncrease":"0","Premium":"73","Option":"0","Loadings":"0","GUID":"7343bf88-b91b-4486-afa9-abeea81296e1","CoverIncrease":"0","Cover":"40000","BenefitID":"UEFS"}}]},"DebitDetails":{"ThirdParty":"false","SalaryDay":"05","DebitDay":"22","DebitDate":"2019-10-22","DebitAccountNumber":"9050723102","BranchClearingCode":"632005","Branch":"ABSA ELECTRONIC SETTL (632005)","Bank":"ABSA BANK LIMITED","AccountType":"Savings","AccountHolder":"Mr.MWOODS"},"Cover":"120000","Beneficiaries":{"Beneficiary":[{"Title":"Unknown","Surname":"Von","ShortName":"B Von","RsaIdNumber":"8910210000000","Names":"Billy, B","Name":"Von, Billy","MemberType":"Unknown","Initials":"B","GUID":"26aec83c-3d61-4593-a27f-09a5c52a673b","Gender":"Unknown","FullName":"Von, Billy","FirstName":"Billy","DateOfBirth":"1989-10-21T00:00:00","Age":"30","Relationship":"COUSIN","BenefitSplit":"100"}]},"Application":{"Replacement":{"Date":"2019-10-22T10:34:58.6827109+02:00","IsReplacement":"false","GUID":"bcce532b-b6cc-46f7-a4a6-0888fc1d1fc3"},"IsClientPresent":"true","IsBranchSales":"true","GUID":"446a0d6b-8c81-4dd4-95f7-225f571c50e0","DistributionChannel":"BranchSales","Declaration":{"IsSupervised":"false","IsFit":"false","GUID":"3bd3da78-6d86-4573-8199-4228a0df4b0d","Advice":"true"},"Consultant":{"PRINumber":"900028005904","Name":"Gaurav Rangnekar","IntermediaryCode":"900028","GUID":"d9f73921-5ba8-4a39-88b4-73c45ac6d74a","ABNumber":"ABGR262"},"Agent":{"GUID":"b4b46565-4304-4550-945c-96619ae32839","A":"BranchSales"}}}';
    public static final String MemberDataString = '{"PartyId":"1dd47148-9966-46ba-aca7-0eb00f2e3cea","Name":"Maria","Surname":"Teague","Relationship":"Main Member","IDNumber":"7210190384089","IdType":"01","Gender":"Female","DateOfBirth":"1972-10-19","CoverOption":"800","Premium":0,"MemberType":"Main Member"}';
	public static final String DependentDataString = '{"PartyId":"1dd47148-9966-46ba-aca7-0eb00f2e3cea","Name":"Maria","Surname":"Teague","Relationship":"Son","IDNumber":"7210190384089","IdType":"01","Gender":"Female","DateOfBirth":"1972-10-19","CoverOption":"800","Premium":0,"MemberType":"Child"}';
    public static final String SpouseDataString = '{"PartyId":"1dd47148-9966-46ba-aca7-0eb00f2e3cea","Name":"Maria","Surname":"Teague","Relationship":"Spouse","IDNumber":"7210190384089","IdType":"01","Gender":"Female","DateOfBirth":"1972-10-19","CoverOption":"800","Premium":0,"MemberType":"Child"}';
    public static final String PaymentDataString = '{"ThirdParty":"false","SalaryDay":"1","DebitDay":"11","DebitDate":"2021-10-18T00:00:00","DebitAccountNumber":"98059586960","BranchClearingCode":"23475","Branch":"","Bank":"ABSABANK","AccountType":"Cheque","AccountHolder":"BMAPPINGS"}';
    public static final String SessionDataString  = '{"ProductDetails":{"ProductName":"ABSA Health Assistance Cover","ProductIdentifier":"250000000","MemberTypes":[{"MemberTypeValue":"Main","MemberTypeName":"Main Member","CoverOptions":[{"value":"400","label":"R 400"},{"value":"600","label":"R 600"},{"value":"800","label":"R 800"},{"value":"1000","label":"R 1000"},{"value":"1500","label":"R 1500"},{"value":"2000","label":"R 2000"}],"BenefitId":"250020000"},{"MemberTypeValue":"Spouse","MemberTypeName":"Spouse","CoverOptions":[{"value":"400","label":"R 400"},{"value":"600","label":"R 600"},{"value":"800","label":"R 800"},{"value":"1000","label":"R 1000"},{"value":"1500","label":"R 1500"},{"value":"2000","label":"R 2000"}],"BenefitId":"250021000"},{"MemberTypeValue":"Child","MemberTypeName":"Child","CoverOptions":[{"value":"400","label":"R 400"},{"value":"600","label":"R 600"},{"value":"800","label":"R 800"},{"value":"1000","label":"R 1000"}],"BenefitId":"250022000"},{"MemberTypeValue":"Other","MemberTypeName":"Parent","CoverOptions":[{"value":"400","label":"R 400"},{"value":"600","label":"R 600"},{"value":"800","label":"R 800"},{"value":"1000","label":"R 1000"}],"BenefitId":"250023000"}],"ContractOptions":[{"value":"400","Name":"Option 01: R 400","Key":"250000001"},{"value":"600","Name":"Option 02: R 600","Key":"250000002"},{"value":"800","Name":"Option 03: R 800","Key":"250000003"},{"value":"1000","Name":"Option 04: R 1000","Key":"250000004"},{"value":"1500","Name":"Option 05: R 1500","Key":"250000005"},{"value":"2000","Name":"Option 06: R 2000","Key":"250000006"}]},"ProductCode":"WIMAL00103","Policy":"","MemberId":null,"MainMember":[],"CurrentCoverOption":null,"CalculatedPremium":null,"Beneficiaries":[],"AdditionalMembers":[]}';
   
    /**
     * @description GetOpportunityId Description
     *
     * @return string: Write the return description
     */
    public string GetOpportunityId(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name LIKE '%-ABSA LIFE'];
        return opp.Id;
    }

    /**
     * @description GetOpportunityProductId Description
     *
     * @param productCode (String): Write the parameter description
     * @return String: Write the return description
     */
    public String GetOpportunityProductId (String productCode){
        
        Account acc = [SELECT Id, Name FROM Account WHERE ID_Number__pc = '8107115017084'];
        String oppId = GetOpportunityId();
        
        OpportunityLineItem opportunityProduct = [SELECT Id FROM OpportunityLineItem WHERE  OpportunityId =: oppId AND ProductCode =: productCode ];
        
        return opportunityProduct.Id;
    }
    
    /**
     * @description GetAccountId Description
     *
     * @return String: Write the return description
     */
    public String GetAccountId (){
        Account acc = [SELECT Id, Name FROM Account WHERE ID_Number__pc = '8107115017084'];
        return acc.Id;
    }
    
    /**
     * @description CreateAccount Description
     *
     * @return Account: Write the return description
     */
    public Account CreateAccount(){
        
        Account testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        testAccount.CASA_Reference_Number__c = '1712994';
        testAccount.CASA_Risk_Status__c = 'Low';
        testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testAccount.CASA_Screening_Status__c = 'Approved';
        testAccount.CASA_Analyst_Comments__c = '30406';
        testAccount.PersonMobilePhone = '0747003747';
        // testAccount.Country_of_Residence__c = 'South Africa';
        testAccount.Country_of_Residence__pc='South Africa';
        testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
        testAccount.FirstName = 'Tony';
        testAccount.External_Siebel_ID__c = '1-1IV9MC';
        testAccount.ID_Number__pc = '8107115017084';
        testAccount.ID_Type__pc = 'SA Identity Document';
        testAccount.LastName = 'Stark';
        testAccount.Nationality__pc = 'South Africa';
        testAccount.Occupation__pc = 'Engineer';
        testAccount.Onboarding_Channel__c = 'Test';
        testAccount.Communication_Language__pc = 'Afrikaans';
        testAccount.PersonTitle = 'Mr.';
        testAccount.Client_Type__c = 'Individual Client';
        testAccount.Phone = '0114453322';
        testAccount.Gender__pc = 'Male';
        testAccount.Initials__pc = 'T';
        testAccount.Country_of_Birth__pc = 'South Africa';
        testAccount.Marital_Status__pc = 'Married';
        testAccount.Marital_Contract_Type__pc = 'Community of Property';
        testAccount.Income_Source__pc = 'Bonus';
        testAccount.Occupation_Status__pc = 'Full Time Employed';
        testAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        testAccount.Occupation_Category__pc = 'Advertising';
        testAccount.ShippingCity = 'CAPE TOWN';
        testAccount.ShippingCountry = 'South Africa';
        testAccount.ShippingStreet = '01 PUERTA DEL SOL';
        testAccount.ShippingPostalCode = '8001';
        testAccount.BillingCity = 'GROBLERSDAL';
        testAccount.BillingCountry = 'South Africa';
        testAccount.BillingStreet = '01 MABOPANE SECTION';
        testAccount.BillingPostalCode = '1060';
        testAccount.CIF__c = 'AFIFTAP001';
        testAccount.Alternative_Email__c = 'test@test.com';
        testAccount.Alternative_Email_1__c = 'test@test.com';
        testAccount.Alternative_Email_2__c = 'test@test.com';
        testAccount.Alternative_Email_3__c = 'test@test.com';
        testAccount.Alternative_Email_4__c = 'test@test.com';
        testAccount.Active_Email__c = 'test@test.com';
        testAccount.PersonEmail = 'test@test.com';
        testAccount.PersonAssistantPhone = '0114453322';
        testAccount.PersonAssistantName = 'Test Name';
        testAccount.PersonHomePhone = '0114453322';
        testAccount.PersonOtherPhone = '0114453322';
        testAccount.Phone = '0114453322';
        testAccount.Fax = '0114453322';
        testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
        testAccount.AccountNumber = '1234567890';//previous value: 0011j00000WkXuGAAV
        testAccount.Identify_the_account_holder_type__c = 'Active Non Financial  Entity (ANFE)';
        testAccount.Date_Established__c = system.today();
        testAccount.registration_number__c = '123456789';
        insert testAccount;
        
        return testAccount;
    }
    
    /**
     * @description AddAddress Description
     *
     * @param accountId (String): Write the parameter description
     * @param country (String): Write the parameter description
     * @param line2 (String): Write the parameter description
     * @param line1 (String): Write the parameter description
     * @param code (String): Write the parameter description
     * @param addressType (String): Write the parameter description
     */
    public void AddAddress(String accountId, String country, String line2, String line1, String code, String addressType){
        Address__c address = new Address__c();
        address.Account__c = accountId;
        address.Shipping_Street__c = line1; 
        address.Shipping_Street_2__c = line1;
        address.Shipping_Suburb__c = line2;
        address.Shipping_City__c = line2;
        address.Shipping_Country__c = country;
        address.Shipping_Zip_Postal_Code__c = code;
        address.Address_TYpe__c = addressType;
        
        insert address;
    }
    
    /**
     * @description CreateAbsaLifeOpportunity Description
     *
     * @param accountName (String): Write the parameter description
     * @param accountId (String): Write the parameter description
     * @return Opportunity: Write the return description
     */
    public Opportunity CreateAbsaLifeOpportunity(String accountName, String accountId)
    {
        Opportunity testOpp = new Opportunity();
        testOpp.Name = accountName + '-' + 'ABSA LIFE';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
        testOpp.AccountId = accountId;
        insert testOpp;
        
        return testOpp;
    }
    
    /**
     * @description CreateWimiProduct Description
     *
     * @param productName (String): Write the parameter description
     * @param productCode (String): Write the parameter description
     * @return PricebookEntry: Write the return description
     */
    public PricebookEntry CreateWimiProduct(String productName, String productCode)
    {
        Product2 product = new Product2(Name = productName, Family = 'WIMI', ProductCode = productCode , IsActive = TRUE);
        insert product;
        
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        
        return pricebookEntry;
    }
    
    /**
     * @description CreateApplicationForOpportunity Description
     *
     * @param OpportunityId (String): Write the parameter description
     * @return Application__c: Write the return description
     **/
    public Application__c  CreateApplicationForOpportunity(String OpportunityId){
        Application__c application = new Application__c();
        application.Opportunity__c = OpportunityId;
        application.ROAQuestionnaire__c = '[{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"Do you have a regular income?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"No"},{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"Do you have a regular income?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"Yes"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"Do you already have any other financial products at other institutions?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"No"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"Do you already have any other financial products at other institutions?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Yes"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Both"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Graduate"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"None"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Student"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"How much is your monthly income?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"R0 - R3000+"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"Can you afford the financial product?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"Can you afford the financial product?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"},{"sequenceNumber":8,"RecommendedProducts":null,"QuestionId":"Do you understand the financial product you want to buy?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":8,"RecommendedProducts":null,"QuestionId":"Do you understand the financial product you want to buy?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"},{"sequenceNumber":9,"RecommendedProducts":null,"QuestionId":"I understand that the Sales Representative is:","IsSelected":true,"AnswerType":"radio","AnswerId":"Fit and Proper"},{"sequenceNumber":9,"RecommendedProducts":null,"QuestionId":"I understand that the Sales Representative is:","IsSelected":false,"AnswerType":"radio","AnswerId":"Working under supervision"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":true,"AnswerType":"checkbox","AnswerId":"Long-term Deposits"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Long-term Insurance subcategory B1-A"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Participatory interest in a collective investment scheme"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Short-term Deposits"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Short-term Insurance Personal Lines"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Structured Deposits"},{"sequenceNumber":11,"RecommendedProducts":null,"QuestionId":"Are you interested in an Absa Life product?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":11,"RecommendedProducts":null,"QuestionId":"Are you interested in an Absa Life product?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"}]';
        application.Preferred_Communication_Method__c = 'Email';
        application.Fees_Waived__c = true;
        application.Application_Status__c = 'Pending';
        
        insert application;
        
        return application;
    }
    
    /**
     * @description CreateOpportunityLineItem Description
     *
     * @param OpportunityId (String): Write the parameter description
     * @param pricebook (PricebookEntry): Write the parameter description
     * @return OpportunityLineItem: Write the return description
     */
    public OpportunityLineItem  CreateOpportunityLineItem(String OpportunityId, PricebookEntry pricebook){
        
        OpportunityLineItem opportunityProduct = new OpportunityLineItem();
        opportunityProduct.OpportunityId = OpportunityId;
        opportunityProduct.Product2Id = pricebook.Product2Id;
        opportunityProduct.PricebookEntryId = pricebook.Id;
        opportunityProduct.Quantity = 1;
        opportunityProduct.TotalPrice = 100;
        opportunityProduct.Other_Extra_Description__c = 'Completed';

        insert opportunityProduct;
        
        return opportunityProduct;
    }

    /**
     * @description GetPolicyDataString Description
     * 
     * @return String: Write the return description
     */
    public String GetPolicyDataString(){

        BranchPolicyDetails existingPolicy = (BranchPolicyDetails)JSON.deserialize(SessionDataString, BranchPolicyDetails.class );
        existingPolicy.Policy = PolicyDataString;
        return JSON.serialize(existingPolicy);
    }

    /**
     * @description AddPartyMembers Description
     *
     * @param partyType (String): Write the parameter description
     * @param OpportunityId (String): Write the parameter description
     * @param product (String): Write the parameter description
     */
    public void AddPartyMembers(String partyType, String OpportunityId, string product)
    {
        Opportunity_Party__c opportunityParty = new Opportunity_Party__c();
        opportunityParty.First_Name__c = 'memberDetails Name';
        opportunityParty.Last_Name__c = 'memberDetails Surname';
        opportunityParty.RSA_ID_Number__c = '8706113456098';
        opportunityParty.ID_Type__c =  Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF', 'Identity Type', '01', 'Outbound');
        opportunityParty.Gender__c = 'Male';
        opportunityParty.Date_of_Birth__c =  Date.valueOf('1981-07-11');
        opportunityParty.Relationship__c =  'Child';
        opportunityParty.Beneficiary_Product__c = product;
        opportunityParty.Party_Type__c = partyType;
        opportunityParty.Dependant_Cover__c = 800;
        opportunityParty.Benefit_Split__c =  0;
        opportunityParty.Opportunity__c = OpportunityId;

        insert opportunityParty;
    }
}