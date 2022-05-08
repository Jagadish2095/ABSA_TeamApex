@isTest
public class ASPDeviceCaseControllerTest{
    @testSetup
    static void makeData() {
        
        Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User au = new User(
            Alias = 'standt',
            Email = aemail,
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = auniqueUserName,
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;
        System.runAs(au) {
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11021');
        insert prod; 
       
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
            
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Account acc = new Account();
        acc.FirstName='First test';
        acc.LastName='last test';
        acc.CIF__c='LTD 933';       
        acc.Language__c='english';
        acc.Number_Of_Dependents__c=0;
        acc.PersonEmail='test@absa.africa';
        acc.Phone='0819908786';
        acc.Contact_Method__pc = 'Email';
        insert acc;
        RecordType  recordType  = [SELECT Id FROM RecordType WHERE Name = 'Business Prospect' LIMIT 1];
             Account acc1 = new Account();
           acc1.Name='last test1';   
            acc1.Language__c='english';
            acc1.Number_Of_Dependents__c=0;
            acc1.Phone='0819908786';
            acc1.RecordTypeId = recordType.Id;
            insert acc1;
            
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id=pb.id;
        opp.AccountId=acc.id;
        opp.Site__c=siteRec.id;
        insert opp;
        
        Application__c app= new Application__c();
        app.Opportunity__c=opp.id;  
        app.Source_of_Funds_Savings__c='27	ALLOWANCE';
        app.Account_Number__c = '123';
        insert app;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c='4048272164';
        insert oppLineItem;  
            
        Address__c residentialAddress = new Address__c(
        Account__c=acc.Id,
        Address_Type__c='Residential');
            
           
            
            Document__c document = new Document__c();
            document.ECM_Type__c = 'UAT';
            document.Case_External_Reference__c = 'C-09475447';
            document.Document_Sub_Type__c = '1';
            document.Account__c = acc1.Id;
            document.Reference__c= acc1.Id;
            insert document; 
            
        }
    }

    @isTest 
    public static void TestGetCaseData()
    {
        string customerVerificationData = '{"WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"c5b9ef69-be1d-4013-a213-5c51f084a54f","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1613831222.1455107","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"c5b9ef69-be1d-4013-a213-5c51f084a54f","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"0833813505","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-02-20"},"PostalAddress":{"AddressID":"25067940852","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-02-20"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"Branch Save","Pid":"","DocumentId":"5485265a-089a-4db7-8994-32ecd0574881"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"Branch Save","Pid":"","DocumentId":"55cb1bfc-c5fb-4dd5-8195-9365c4d333c3"},"WasHANISAttestationSelected":true,"HANISAttestationValue":"Yes – Certificate detail is correct.","OverrideResponse":null}';
        string documentScanningData = '{"DocumentList":[{"UploadMSG":"fdvsdf","ECMPID":"test","DocumentType":"test","DocumentSubType":"test1","DocumentGUID":"123456","DocumentCode":"01"}]}';
        string customerContractData = '{"DocumentList":[{"UploadMSG":"contract","ECMPID":"test2","DocumentType":"test2","DocumentSubType":"test2","DocumentGUID":"789","DocumentCode":"000058"}]}';
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity where Name = 'Test Opp Onboarding' LIMIT 1];
        ASPDeviceCaseController.GetCaseDataString(opp.Id, customerVerificationData, documentScanningData, customerContractData);
        System.assertNotEquals('', 'Test Working');
        Test.stopTest();
		}
    }
    @isTest 
    public static void TestGetCaseDataforStokvel()
    {
        string customerVerificationData = '{"WasHANISCancelled":false,"HANISCancelReason":null,"WasBioConsentGiven":false,"WasHANISServiceCallSuccessful":true,"HANISServiceResponse":{"ErrorCode":"0","errorDescription":null,"transactionID":null,"idNumber":"9308295015083","fpInd1":null,"finger1Result":"G","finger1Score":"0","fpInd2":null,"finger2Result":null,"finger2Score":"0","name":"PAUL JOHN","surname":"DU RANDT","maritalStatus":null,"image":"Y","dateIssued":"20180719","hasSmartCard":"Y","cert":"Y","sCallCentreNoField":null,"responseStatusDescription":null,"responseStatusCode":null,"sessionID":null},"WasCPBServiceCallSuccessful":true,"CPBServiceResponse":{"ErrorCode":null,"ErrorMessage":null,"SearchInformation":{"SearchUserName":"T_3000090001","Reference":"","SearchToken":"c5b9ef69-be1d-4013-a213-5c51f084a54f","SearchTypeDescription":"","SearchDescription":"9308295015083 DU RANDT","CallerModule":"BureauHouseAPI","SearchID":"1613831222.1455107","DataSupplier":"Consumer Profile Bureau","SearchType":"ProofOfResidence","ExtendedSections":"","ResponseType":"ProofOfResidence","ResponseObjectType":"Person"},"Person":{"PersonInformation":{"PersonID":"a58137f74f27718f37ec18e0eaf8bf2d","Title":"","Initials":"PJ","FirstName":"PAUL","Surname":"DU RANDT","IdNumber":"9308295015083","PassportNumber":"","MaritalStatus":"SINGLE","Gender":"Male","MiddleName1":"JOHN","MiddleName2":"","MiddleName3":"","Reference":"c5b9ef69-be1d-4013-a213-5c51f084a54f","DeceasedStatus":"NO","CurrentEmployer":"","HasPostMatricQual":"UNKNOWN","WhatQual":"UNKNOWN","DateOfBirth":"29/08/1993"},"ContactInformation":{"FaxNumber":"","WorkTelephoneNumber":"","HomeTelephoneNumber":"","MobileNumber":"0833813505","EmailAddress":""},"FinancialInformation":{"EverInsolvent":"UNKNOWN","IncomeBracket":"UNKNOWN"},"AddressInformation":{"ResidentialAddress":{"FirstReportedDate":"2017-04-10","AddCert":"Y","AddressID":"12819810292","TypeDescription":"RESIDENTIAL","TypeCode":"R","Line1":"30 COLLETT STREET","Line2":"","Line3":"RACEVIEW","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"30 COLLETT STREET, RACEVIEW, ALBERTON, 1449","LastUpdatedDate":"2021-02-20"},"PostalAddress":{"AddressID":"25067940852","TypeDescription":"POSTAL","TypeCode":"P","Line1":"PO BOX 17030","Line2":"","Line3":"RANDHART","Line4":"ALBERTON","PostalCode":"1449","FullAddress":"PO BOX 17030, RANDHART, ALBERTON, 1449","LastUpdatedDate":"2021-02-20"}}},"ErrorCore":{"ErrorCode":null,"SessionId":"00000000-0000-0000-0000-000000000000","Component":null,"ErrorDesc":null},"responseStatusDescription":"Success","responseStatusCode":"0","sessionID":null},"isCPBResidentialAddressCertificateStoredInEcm":true,"CPBResidentialAddressCertECMdetails":{"AddStatus":"Branch Save","Pid":"","DocumentId":"5485265a-089a-4db7-8994-32ecd0574881"},"isHANISCertificateStoredInEcm":true,"HANISCertECMdetails":{"AddStatus":"Branch Save","Pid":"","DocumentId":"55cb1bfc-c5fb-4dd5-8195-9365c4d333c3"},"WasHANISAttestationSelected":true,"HANISAttestationValue":"Yes – Certificate detail is correct.","OverrideResponse":null}';
        string documentScanningData = '{"DocumentList":[{"UploadMSG":"fdvsdf","ECMPID":"test","DocumentType":"test","DocumentSubType":"test1","DocumentGUID":"123456","DocumentCode":"01"}]}';
        string customerContractData = '{"DocumentList":[{"UploadMSG":"contract","ECMPID":"test2","DocumentType":"test2","DocumentSubType":"test2","DocumentGUID":"789","DocumentCode":"000058"}]}';
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
        Test.startTest();
        Account acc = [SELECT Id FROM Account where Name = 'last test1' LIMIT 1];
        ASPDeviceCaseController.GetSupportingMaterial(null, customerContractData,acc);
        System.assertNotEquals('', 'Test Working');
        Test.stopTest();
		}
    }
    
    @isTest
    public static void TestGetCaseRiskRating()
    {
        System.assertEquals(ASPDeviceCaseController.GetCaseRiskRating('Very Low'), 'VL');
        System.assertEquals(ASPDeviceCaseController.GetCaseRiskRating('Low'),'L');
        System.assertEquals(ASPDeviceCaseController.GetCaseRiskRating('Medium'),'M');
        System.assertEquals(ASPDeviceCaseController.GetCaseRiskRating('High'),'H');
        System.assertEquals(ASPDeviceCaseController.GetCaseRiskRating('Very High'),'VH');
        System.assertEquals(ASPDeviceCaseController.GetCaseRiskRating('Should not return anything'),'');
    }
}