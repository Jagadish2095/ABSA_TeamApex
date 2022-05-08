@isTest
public class BranchPolicyRemovalServiceTest {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_PolicyDependent_SERVICE_NAME';
    
    @testSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{BranchPolicyRemovalService.PolicyDependent_SERVICE_NAME});
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
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
            Advisor_Code__c = '112233',
            AB_Number__c = '',
            SiteCode__c = '',
            Teller_Operator_Code__c =''
        );
        insert au;
    } 
    
    @isTest
    static void testDeletePolicyDependent(){
        
        List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        insert usersList;
        
        String policy = '{"Policy_CreateResponse":{"Policy_CreateResult":{"GUID":"eadf8b9e-3df8-4858-b429-1dce5a294078","Application":{"GUID":"b0f6e622-b6d1-4a6f-9c9d-b3156d354600","Agent":{"GUID":"11061b56-17de-43c2-b3b8-769fa2b68e52","DistributionChannel":"BranchSales"},"Consultant":{"GUID":"a99cde03-cefa-4b8c-a907-fd112625e7b3","ABNumber":"ABNMAYW","Branch":"NOT USING ARAS","EmployeeNumber":"9563284","Name":"BDP DEVELOPER","SiteCode":"8392"},"Declaration":{"GUID":"8b154aa6-976f-4967-9ef7-72a4a359b35f","IsFit":"true","IsSupervised":"true","Advice":"false"},"DistributionChannel":"BranchSales","IsBranchSales":"true","IsClientPresent":"true","Replacement":{"GUID":"0059bea9-bfa7-410c-af4e-ee1e6a09287c","Date":"2019-10-07T13:24:48.4937319+02:00","IsReplacement":"false"}},"Cover":"0","Loadings":"0","MainMember":{"GUID":"f2b94e4b-eaa7-4938-82f8-b91485a59a02","Age":"49","DateOfBirth":"1970-06-12T00:00:00","FirstName":"BRIAN","FullName":"PICASSO, BRIAN","Gender":"Male","Initials":"B","MemberType":"Individual","Name":"PICASSO, BRIAN","Names":"BRIAN, B","RsaIdNumber":"7006129667134","ShortName":"B PICASSO","Surname":"PICASSO","Title":"Mr","Benefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"BenefitOption":"0","Benefits":{"Benefit":[{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"}]},"Cover":"0","Loadings":"0","Premium":"0","CasaReferenceNumber":"1629135","CifClientCode":"PICASB 001","ContactDetails":{"GUID":"2e3603c6-360d-4ce0-8d38-0969342169ac","CellTelephone":"0791818451","HomeTelephone":"(011) 1245789","OptIn":"false","PhysicalAddress":{"GUID":"d5abed63-c7cd-4e3f-84e8-c5445c59766c","Line1":"233 LUPHONDWANA STREET","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"233 LUPHONDWANA STREET, KING WILLIAMS TOWN"},"PostalAddress":{"GUID":"6e3c1dd5-d9e6-410f-8a14-d0889f8d83a3","Line1":"34 LUPHONDWENI LOCATION STREE","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"34 LUPHONDWENI LOCATION STREE, KING WILLIAMS TOWN"}},"CountryOfBirth":"SO003","CountryOfResidence":"SO003","IncomeBand":"Band1","IsIndividual":"true","IsSouthAfrican":"true","Language":"English","MaritalStatus":"Single","Nationality":"SOU01","SourceOfFunds":"20","SourceOfIncome":"20","IsStaff":"false"},"PolicyBenefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"PolicyInfo":{"GUID":"b18a0292-c4a4-4d34-bec4-d3101e749134","Application":"2019-10-07T13:24:48.4937319+02:00","ContractID":"UL01","ContractOptionID":"10000001","Disclosure":"false"},"Premium":"0","TotalCommission":"0","TotalCover":"0","TotalPremium":"0","ModuleID":"WIMAL00500"}}}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        PolicyRemovalRequest policyCreateReq = new PolicyRemovalRequest();
        policyCreateReq = (PolicyRemovalRequest)policyCreateReq.deserialize( policy, PolicyRemovalRequest.class );
        
        string dependentId = '3f90e045-1c0a-497e-bc24-7a41d0d16372';
        
        PolicyRemovalResponse response = BranchPolicyRemovalService.DeleteDependent(dependentId,policyCreateReq.DetailsPolicy); 
        system.assertNotEquals(200, response.statusCode, 'Assert Failed');        
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testDeletePolicyBenefit(){
        List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        insert usersList;
        String policy = '{"Policy_CreateResponse":{"Policy_CreateResult":{"GUID":"eadf8b9e-3df8-4858-b429-1dce5a294078","Application":{"GUID":"b0f6e622-b6d1-4a6f-9c9d-b3156d354600","Agent":{"GUID":"11061b56-17de-43c2-b3b8-769fa2b68e52","DistributionChannel":"BranchSales"},"Consultant":{"GUID":"a99cde03-cefa-4b8c-a907-fd112625e7b3","ABNumber":"ABNMAYW","Branch":"NOT USING ARAS","EmployeeNumber":"9563284","Name":"BDP DEVELOPER","SiteCode":"8392"},"Declaration":{"GUID":"8b154aa6-976f-4967-9ef7-72a4a359b35f","IsFit":"true","IsSupervised":"true","Advice":"false"},"DistributionChannel":"BranchSales","IsBranchSales":"true","IsClientPresent":"true","Replacement":{"GUID":"0059bea9-bfa7-410c-af4e-ee1e6a09287c","Date":"2019-10-07T13:24:48.4937319+02:00","IsReplacement":"false"}},"Cover":"0","Loadings":"0","MainMember":{"GUID":"f2b94e4b-eaa7-4938-82f8-b91485a59a02","Age":"49","DateOfBirth":"1970-06-12T00:00:00","FirstName":"BRIAN","FullName":"PICASSO, BRIAN","Gender":"Male","Initials":"B","MemberType":"Individual","Name":"PICASSO, BRIAN","Names":"BRIAN, B","RsaIdNumber":"7006129667134","ShortName":"B PICASSO","Surname":"PICASSO","Title":"Mr","Benefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"BenefitOption":"0","Benefits":{"Benefit":[{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"}]},"Cover":"0","Loadings":"0","Premium":"0","CasaReferenceNumber":"1629135","CifClientCode":"PICASB 001","ContactDetails":{"GUID":"2e3603c6-360d-4ce0-8d38-0969342169ac","CellTelephone":"0791818451","HomeTelephone":"(011) 1245789","OptIn":"false","PhysicalAddress":{"GUID":"d5abed63-c7cd-4e3f-84e8-c5445c59766c","Line1":"233 LUPHONDWANA STREET","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"233 LUPHONDWANA STREET, KING WILLIAMS TOWN"},"PostalAddress":{"GUID":"6e3c1dd5-d9e6-410f-8a14-d0889f8d83a3","Line1":"34 LUPHONDWENI LOCATION STREE","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"34 LUPHONDWENI LOCATION STREE, KING WILLIAMS TOWN"}},"CountryOfBirth":"SO003","CountryOfResidence":"SO003","IncomeBand":"Band1","IsIndividual":"true","IsSouthAfrican":"true","Language":"English","MaritalStatus":"Single","Nationality":"SOU01","SourceOfFunds":"20","SourceOfIncome":"20","IsStaff":"false"},"PolicyBenefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"PolicyInfo":{"GUID":"b18a0292-c4a4-4d34-bec4-d3101e749134","Application":"2019-10-07T13:24:48.4937319+02:00","ContractID":"UL01","ContractOptionID":"10000001","Disclosure":"false"},"Premium":"0","TotalCommission":"0","TotalCover":"0","TotalPremium":"0","ModuleID":"WIMAL00500"}}}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        string benefitId = 'f1675c6f-f835-4938-8d15-7edf8814555d';
        string memberId = '10310025-eda9-418e-ad11-5fcb1612af55';
        
        PolicyRemovalRequest policyCreateReq = new PolicyRemovalRequest();
        policyCreateReq = (PolicyRemovalRequest)policyCreateReq.deserialize( policy, PolicyRemovalRequest.class );
        
        
        PolicyRemovalResponse response = BranchPolicyRemovalService.DeleteBenefit(benefitId,memberId,policyCreateReq.DetailsPolicy);
        system.assertNotEquals(200, response.statusCode, 'Assert Failed');        
        
        Test.stopTest();   	
    }
    
    @isTest
    static void testDeletePolicyBeneficiary(){
        List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        insert usersList;
        
        String policy = '{"Policy_CreateResponse":{"Policy_CreateResult":{"GUID":"eadf8b9e-3df8-4858-b429-1dce5a294078","Application":{"GUID":"b0f6e622-b6d1-4a6f-9c9d-b3156d354600","Agent":{"GUID":"11061b56-17de-43c2-b3b8-769fa2b68e52","DistributionChannel":"BranchSales"},"Consultant":{"GUID":"a99cde03-cefa-4b8c-a907-fd112625e7b3","ABNumber":"ABNMAYW","Branch":"NOT USING ARAS","EmployeeNumber":"9563284","Name":"BDP DEVELOPER","SiteCode":"8392"},"Declaration":{"GUID":"8b154aa6-976f-4967-9ef7-72a4a359b35f","IsFit":"true","IsSupervised":"true","Advice":"false"},"DistributionChannel":"BranchSales","IsBranchSales":"true","IsClientPresent":"true","Replacement":{"GUID":"0059bea9-bfa7-410c-af4e-ee1e6a09287c","Date":"2019-10-07T13:24:48.4937319+02:00","IsReplacement":"false"}},"Cover":"0","Loadings":"0","MainMember":{"GUID":"f2b94e4b-eaa7-4938-82f8-b91485a59a02","Age":"49","DateOfBirth":"1970-06-12T00:00:00","FirstName":"BRIAN","FullName":"PICASSO, BRIAN","Gender":"Male","Initials":"B","MemberType":"Individual","Name":"PICASSO, BRIAN","Names":"BRIAN, B","RsaIdNumber":"7006129667134","ShortName":"B PICASSO","Surname":"PICASSO","Title":"Mr","Benefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"BenefitOption":"0","Benefits":{"Benefit":[{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"}]},"Cover":"0","Loadings":"0","Premium":"0","CasaReferenceNumber":"1629135","CifClientCode":"PICASB 001","ContactDetails":{"GUID":"2e3603c6-360d-4ce0-8d38-0969342169ac","CellTelephone":"0791818451","HomeTelephone":"(011) 1245789","OptIn":"false","PhysicalAddress":{"GUID":"d5abed63-c7cd-4e3f-84e8-c5445c59766c","Line1":"233 LUPHONDWANA STREET","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"233 LUPHONDWANA STREET, KING WILLIAMS TOWN"},"PostalAddress":{"GUID":"6e3c1dd5-d9e6-410f-8a14-d0889f8d83a3","Line1":"34 LUPHONDWENI LOCATION STREE","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"34 LUPHONDWENI LOCATION STREE, KING WILLIAMS TOWN"}},"CountryOfBirth":"SO003","CountryOfResidence":"SO003","IncomeBand":"Band1","IsIndividual":"true","IsSouthAfrican":"true","Language":"English","MaritalStatus":"Single","Nationality":"SOU01","SourceOfFunds":"20","SourceOfIncome":"20","IsStaff":"false"},"PolicyBenefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"PolicyInfo":{"GUID":"b18a0292-c4a4-4d34-bec4-d3101e749134","Application":"2019-10-07T13:24:48.4937319+02:00","ContractID":"UL01","ContractOptionID":"10000001","Disclosure":"false"},"Premium":"0","TotalCommission":"0","TotalCover":"0","TotalPremium":"0","ModuleID":"WIMAL00500"}}}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        string benefitId = '3f90e045-1c0a-497e-bc24-7a41d0d16382';
        PolicyRemovalRequest policyCreateReq = new PolicyRemovalRequest();
        policyCreateReq = (PolicyRemovalRequest)policyCreateReq.deserialize( policy, PolicyRemovalRequest.class );
        
        
        PolicyRemovalResponse response = BranchPolicyRemovalService.DeleteBeneficiary(benefitId,policyCreateReq.DetailsPolicy);           
        system.assertNotEquals(200, response.statusCode, 'Assert Failed');
        
        Test.stopTest();
        
    }
}