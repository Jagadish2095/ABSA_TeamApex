@isTest
public class ADAPT360_IH_v1_Test {
    
    @isTest static void retrieveClientDetailsPositive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('cif', 'GSOFTWA002', 'CIB_VIEW', true);
        Test.stopTest();
    }
    
    @isTest static void retrieveClientDetailsNegative() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('cif', 'GSOFTWA002', 'CIB_VIEW', true);
        Test.stopTest();
    }
    
    @isTest static void retrieveClientDetailsNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('cif', 'GSOFTWA002', 'CIB_VIEW', true);
        Test.stopTest();
    }
    
    @isTest static void retrieveClientDetailsException() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();
        ADAPT360_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('cif', 'GSOFTWA002', 'CIB_VIEW', true);
        Test.stopTest();
    }
    
    @isTest static void retrieveClientDetailsCombineBeanPositive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();
        ADAPT360GetJointParticipant_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('identityDocument', '7509240062086', 'CIB_VIEW', 'RAMANS+001');
        Test.stopTest();
    }
    
    @isTest static void retrieveClientDetailsCombineBeanNegative() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();
        ADAPT360GetJointParticipant_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('identityDocument', '7509240062086', 'CIB_VIEW', 'RAMANS+001');
        Test.stopTest();
    }
    
    @isTest static void retrieveClientDetailsCombineBeanNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        ADAPT360GetJointParticipant_Resp_IB_v1 responseBean = ADAPT360_IH_v1.retrieveClientDetails('identityDocument', '7509240062086', 'CIB_VIEW', 'RAMANS+001');
        Test.stopTest();
    }
    
    /*@isTest static void createBean(){
        
        ADAPT360_Resp_IB_v1.attribute attribute = new ADAPT360_Resp_IB_v1.attribute();
        attribute.value = 'test';
        
        ADAPT360_Resp_IB_v1.keyvaluepair keyvaluepair = new ADAPT360_Resp_IB_v1.keyvaluepair();
        keyvaluepair.code = attribute;
        keyvaluepair.description = attribute;
        
        ADAPT360_Resp_IB_v1.entityreference entityreference = new ADAPT360_Resp_IB_v1.entityreference();
        entityreference.ref = 'test';
        
        ADAPT360_Resp_IB_v1.DocumentInfo DocumentInfo = new ADAPT360_Resp_IB_v1.DocumentInfo();
        DocumentInfo.allCorrectInOrder = attribute;
        DocumentInfo.allCorrectRecieved = attribute;
        DocumentInfo.casaReference = attribute;
        DocumentInfo.casaSequence = attribute;
        DocumentInfo.casaTier = attribute;
        DocumentInfo.documentInOrder = attribute;
        DocumentInfo.documentRecieved = attribute;
        DocumentInfo.documentStatusReason = keyvaluepair;
        DocumentInfo.documentType = keyvaluepair;
        DocumentInfo.imageId = attribute;
        DocumentInfo.qualityAssurance = attribute;
        
        
        ADAPT360_Resp_IB_v1.DocumentDetailsInfo DocumentDetailsInfo = new ADAPT360_Resp_IB_v1.DocumentDetailsInfo();
        DocumentDetailsInfo.idDoc = DocumentInfo;
        DocumentDetailsInfo.addDoc = DocumentInfo;
        
        ADAPT360_Resp_IB_v1.ProductInfo ProductInfo = new ADAPT360_Resp_IB_v1.ProductInfo();
        ProductInfo.accountNumber = attribute;
        
        ADAPT360_Resp_IB_v1.SignatoryDetailsInfo SignatoryDetailsInfo = new ADAPT360_Resp_IB_v1.SignatoryDetailsInfo();
        SignatoryDetailsInfo.product = ProductInfo;
        SignatoryDetailsInfo.dateIssued = attribute;
        SignatoryDetailsInfo.expiryDate = attribute;
        SignatoryDetailsInfo.maximumAmount = attribute;
        SignatoryDetailsInfo.entity = entityreference;
        
        List<ADAPT360_Resp_IB_v1.SignatoryDetailsInfo> SignatoryDetailsInfoList = new List<ADAPT360_Resp_IB_v1.SignatoryDetailsInfo>();
        SignatoryDetailsInfoList.add(SignatoryDetailsInfo);
        
        ADAPT360_Resp_IB_v1.AuthorityInfo AuthorityInfo = new ADAPT360_Resp_IB_v1.AuthorityInfo();
        AuthorityInfo.signatoryDetails = SignatoryDetailsInfoList;
        AuthorityInfo.authorityTypeCode = attribute;
        AuthorityInfo.customerCode = attribute;
        AuthorityInfo.accountNumber = attribute;
        AuthorityInfo.changeTrackingNumber = attribute;
        AuthorityInfo.courtAuthorityCode = attribute;
        AuthorityInfo.numberOfSignatures = attribute;
        AuthorityInfo.employeeNumber = attribute;
        AuthorityInfo.originalCourtAuthorityCode = attribute;
        AuthorityInfo.originalNumberOfSignatures = attribute;
        AuthorityInfo.originalSpecialConditions = attribute;
        AuthorityInfo.overrideEmployeeNumber = attribute;
        AuthorityInfo.specialConditions = attribute;
        AuthorityInfo.status = attribute;
        AuthorityInfo.changedSignatory = attribute;
        AuthorityInfo.authorityType = attribute;
        
        ADAPT360_Resp_IB_v1.FlagInfo FlagInfo = new ADAPT360_Resp_IB_v1.FlagInfo();
        FlagInfo.compliant = attribute;
        FlagInfo.reason = keyvaluepair;
        
        ADAPT360_Resp_IB_v1.IdentificationType IdentificationType = new ADAPT360_Resp_IB_v1.IdentificationType();
        IdentificationType.code = 'Test';
        IdentificationType.description = 'Test';
        
        ADAPT360_Resp_IB_v1.IdentificationsInfo IdentificationsInfo = new ADAPT360_Resp_IB_v1.IdentificationsInfo();
        IdentificationsInfo.identificationType = IdentificationType;
        IdentificationsInfo.numbers = 'Test';
        IdentificationsInfo.personalIdentificationFlag = true;
        IdentificationsInfo.systemIdentificationFlag = true;
        IdentificationsInfo.issueDate = 'Test';
        IdentificationsInfo.expiryDate = 'Test';
        IdentificationsInfo.country = 'Test';
        
        ADAPT360_Resp_IB_v1.QueryResultInfo QueryResultInfo = new ADAPT360_Resp_IB_v1.QueryResultInfo();
        QueryResultInfo.sourceSystem = 'Test';
        QueryResultInfo.queryResultInfoType = 'Test';
        
        ADAPT360_Resp_IB_v1.MetaInfo MetaInfo = new ADAPT360_Resp_IB_v1.MetaInfo();
        MetaInfo.queryResult = QueryResultInfo;
        
        ADAPT360_Resp_IB_v1.CustomerDetails CustomerDetails = new ADAPT360_Resp_IB_v1.CustomerDetails();
        CustomerDetails.CPAThreshold = attribute;
        
        ADAPT360_Resp_IB_v1.CustomerInfo CustomerInfo = new ADAPT360_Resp_IB_v1.CustomerInfo();
        CustomerInfo.Details = CustomerDetails;
        
        ADAPT360_Resp_IB_v1.CorporateEntityInfo CorporateEntityInfo = new ADAPT360_Resp_IB_v1.CorporateEntityInfo();
        CorporateEntityInfo.incorporatedCountry = keyvaluepair;
        CorporateEntityInfo.standardIndustryCode = keyvaluepair;
        
        ADAPT360_Resp_IB_v1.ContactInfo ContactInfo = new ADAPT360_Resp_IB_v1.ContactInfo();
        ContactInfo.cellPhoneNumber = attribute;
        ContactInfo.communicationChannelType = keyvaluepair;
        ContactInfo.workPhone = attribute;
        ContactInfo.homePhone = attribute;
        ContactInfo.telephoneNumber = attribute;
        ContactInfo.eMailUserId = attribute;
        ContactInfo.contactPerson = attribute;
        ContactInfo.designation = attribute;
        
        ADAPT360_Resp_IB_v1.Address Address = new ADAPT360_Resp_IB_v1.Address();
        Address.addressName1 = attribute;
        Address.addressName2 = attribute;
        Address.suburbName = attribute;
        Address.cityName = attribute;
        Address.postCodeArea = attribute;
        Address.addressTypeCode = attribute;
        Address.addressType = attribute;
        
        ADAPT360_Resp_IB_v1.LocationInfo LocationInfo = new ADAPT360_Resp_IB_v1.LocationInfo();
        LocationInfo.physicalAddress = Address;
        LocationInfo.postalAddress = Address;
        LocationInfo.businessAddress = Address;
        LocationInfo.headOfficeAddress = Address;
        
        ADAPT360_Resp_IB_v1.CustomerDetailsInfo CustomerDetailsInfo = new ADAPT360_Resp_IB_v1.CustomerDetailsInfo();
        CustomerDetailsInfo.identificationTypeId = keyvaluepair;
        CustomerDetailsInfo.individualId = attribute;
        CustomerDetailsInfo.universalResourceLocator = attribute;
        CustomerDetailsInfo.customerType = keyvaluepair;
        CustomerDetailsInfo.groupScheme = keyvaluepair;
        CustomerDetailsInfo.sourceOfFundsCode = keyvaluepair;
        CustomerDetailsInfo.sourceOfIncomeCode = keyvaluepair;
        CustomerDetailsInfo.corporateDivision = keyvaluepair;
        CustomerDetailsInfo.NCAThreshold = attribute;
        CustomerDetailsInfo.CPAThreshold = attribute;
        CustomerDetailsInfo.sbuSegment = keyvaluepair;
        CustomerDetailsInfo.forensicHold = attribute;
        CustomerDetailsInfo.inLiquidation = attribute;
        CustomerDetailsInfo.underJudicialManagement = attribute;
        CustomerDetailsInfo.financialCrime = attribute;
        CustomerDetailsInfo.inBusinessRescue = attribute;
        CustomerDetailsInfo.inBusinessRescueAffectedParty = attribute;
        CustomerDetailsInfo.placedInBusinessRescueBy = attribute;
        CustomerDetailsInfo.casaReference = attribute;
        
        ADAPT360_Resp_IB_v1.IndividualInfo IndividualInfo = new ADAPT360_Resp_IB_v1.IndividualInfo();
        IndividualInfo.givenName = attribute;
        IndividualInfo.nameInitials = attribute;
        IndividualInfo.surname = attribute;
        IndividualInfo.salutationType = keyvaluepair;
        IndividualInfo.countryPassport = keyvaluepair;
        IndividualInfo.countryOfBirth = keyvaluepair;
        IndividualInfo.gender = keyvaluepair;
        IndividualInfo.nationality = keyvaluepair;
        IndividualInfo.employmentStatusType = keyvaluepair;
        IndividualInfo.documentDetails = DocumentDetailsInfo;
        IndividualInfo.birthDate = attribute;
        IndividualInfo.countryOfOrigin = keyvaluepair;
        IndividualInfo.countryOfResidence = keyvaluepair;
        
        ADAPT360_Resp_IB_v1.AccountInfo AccountInfo = new ADAPT360_Resp_IB_v1.AccountInfo();
        AccountInfo.accountNumber = attribute;
        AccountInfo.product = attribute;
        AccountInfo.productType = attribute;
        AccountInfo.availableBalance = attribute;
        AccountInfo.availableBalanceSpecified = attribute;
        AccountInfo.balance = attribute;
        AccountInfo.balanceSpecified = attribute;
        AccountInfo.balanceTxt = attribute;
        AccountInfo.branch = attribute;
        AccountInfo.corporationCode = attribute;
        AccountInfo.dateClosed = attribute;
        AccountInfo.detail = attribute;
        AccountInfo.limits = attribute;
        AccountInfo.limitSpecified = attribute;
        AccountInfo.accountStatus = attribute;
        AccountInfo.entity = entityreference;
        
        List<ADAPT360_Resp_IB_v1.AccountInfo> AccountInfoList = new List<ADAPT360_Resp_IB_v1.AccountInfo>();
        AccountInfoList.add(AccountInfo);
        
        List<ADAPT360_Resp_IB_v1.IdentificationsInfo> IdentificationsInfoList = new List<ADAPT360_Resp_IB_v1.IdentificationsInfo>();
        IdentificationsInfoList.add(IdentificationsInfo);
        
        List<ADAPT360_Resp_IB_v1.AuthorityInfo> AuthorityInfoList = new List<ADAPT360_Resp_IB_v1.AuthorityInfo>();
        AuthorityInfoList.add(AuthorityInfo);
        
        ADAPT360_Resp_IB_v1.ClientDetails ClientDetails = new ADAPT360_Resp_IB_v1.ClientDetails();
        ClientDetails.account = AccountInfoList;
        ClientDetails.individual = IndividualInfo;
        ClientDetails.customerDetails = CustomerDetailsInfo;
        ClientDetails.location = LocationInfo;
        ClientDetails.contact = ContactInfo;
        ClientDetails.corporateEntity = CorporateEntityInfo;
        ClientDetails.customer = CustomerInfo;
        ClientDetails.meta = MetaInfo;
        ClientDetails.identifications = IdentificationsInfoList;
        ClientDetails.links = 'Test';
        ClientDetails.flags = FlagInfo;
        ClientDetails.authority = AuthorityInfoList;
        ClientDetails.clientDetailsId = 'Test';
        
        ADAPT360_Resp_IB_v1 bean = new ADAPT360_Resp_IB_v1();
        List<ADAPT360_Resp_IB_v1.ClientDetails> cdl = new List<ADAPT360_Resp_IB_v1.ClientDetails>();
        cdl.add(ClientDetails);
        bean.ClientDetails = cdl;
        bean.status = 'test';
        bean.statusCode = 200;
          
    }*/
}