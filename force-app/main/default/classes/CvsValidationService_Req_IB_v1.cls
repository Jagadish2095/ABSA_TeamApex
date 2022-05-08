public class CvsValidationService_Req_IB_v1 extends Base_IB 
{    
    public cls_Header header;
    public cls_Client client;
    public cls_ContactInfo contactInfo;
    public cls_MarketingInfo marketingInfo;
    public cls_EmploymentInfo employmentInfo;
    public cls_BusinessInfo businessInfo;   
    public cls_Holds holds; 
    public cls_Fica fica;
    public cls_AccountAddress accountAddress;
    public cls_ExecutorAddress executorAddress; 
    public String designationCode;
    public String contactPerson;
    public String contactPersonIdNo;
    public String affectedPersonReg;
    public String noOfParticipants;
    public String recipientName1;
    public String recipientName2;
    public String subClassificationCode;
    public String detailedClassification;
    public String detailedClassificationPcent;   
    public cls_NextOfKin nextOfKin;
    public cls_JointParticipants[] jointParticipants;
    public String[] validatorSet;
    
    public class cls_Header 
    {
        public String applicationId;
        public String clientType;
        public String clientTypeGroup;
        public String errorMessagesLanguage;
        public String version;
        public String subClassificationCode; //Newly added by Rajesh @ 26/08/2020
    }
    
    public class cls_Client
    {
        public String surname;
        public String firstname;
        public String initials;
        public String dateOfBirth;
        public String gender;
        public cls_IdNumber idNumber;    
        public String titleCode;
        public String homeLanguage;
        public String correspondenceLanguage;
        public String maritalStatus;
        public String maritalContractType;
        public String nationalityCode;
        public String numberOfDependants;
        public String incomeTaxNo;
        public String universityCode;
        public String postMatricIndicator;
        public String postMatricQualification;
        public String residentialStatus;
        public String socialGrant;
        public String creditWorthinessConsent;
        public String countryOfBirthCode;
        public String clientCode;
        public String practiceOrTrustNo;
    }
    
    public class cls_IdNumber
    {
        public String documentType;
        public String valNumber;
        public String dateIssued;
        public String expiryDate;
        public String countryOfIssueCode;
        public String tempResidentPerNo;
        public String permitExpiryDate;
    }
    
    public class cls_ContactInfo 
    {
        public String cellPhoneNo;
        public String emailAddress;
        public cls_HomePhone homePhone;
        public cls_HomeFax homeFax;
        public cls_WorkPhone workPhone;
        public cls_WorkFax workFax;
        public cls_HomeAddress homeAddress;
        public cls_PostalAddress postalAddress;
    }
    
    public class cls_HomePhone extends cls_PnStruct {}    
    public class cls_homeFax extends cls_PnStruct {}    
    public class cls_workPhone extends cls_PnStruct {}    
    public class cls_workFax extends cls_PnStruct {}    
    public class cls_HomeAddress extends cls_AddressStruct{}    
    public class cls_PostalAddress extends cls_NoSurburbAddress {}
    
    public abstract class cls_PnStruct
    {
        public String dialCode;
        public String valNumber;
    }
    
    public abstract class cls_AddressStruct
    {
        public String line1;
        public String line2;
        public String suburb;
        public String city;
        public String postalCode;
        public String countryCode;
    }
    
    public class cls_MarketingInfo 
    {
        public String email;
        public String mail;
        public String sms;
        public String telephone;
        public String massMarketing;
        public String marketingMailIndicator;
        public String preferredCommunicationChannel;
    }
    
    public class cls_EmploymentInfo 
    {
        public cls_WorkAddress workAddress;
        public String employerName;
        public String employmentSector;
        public String occupationCode;
        public String occupationLevel;
        public String occupationStatus;
        public String monthlyIncome;
        public String sourceOfFunds;
        public String groupSchemeCode;
        public String groupSchemeEmployeeNumber;
    }
    
    public class cls_WorkAddress extends cls_AddressStruct {}
    
    public class cls_BusinessInfo 
    {
        public String sicCode;
        public String registrationNumber;
        public String practiceOrTrustNo;
        public String countryIncorporated;
        public String internetWebSite;
        public String vatRegistrationNo;
        public String vatRegistrationNoAccount;
        public String yearEnd;
        public cls_Address address ;
        public String cpaThreshold;
        public String ncaThreshold;
        public String exconExpiryDate;
        public String site;
        public cls_CountryEntityOperates countryEntityOperates;
        public cls_RegisteredAddress registeredAddress;
        public cls_HeadOfficeAddress headOfficeAddress;
    }
    
    public class cls_Address extends cls_AddressStruct {}
    
    public class cls_CountryEntityOperates
    {
        public String countyCode;
    }
    
    public class cls_RegisteredAddress  extends cls_AddressStruct{}
    public class cls_HeadOfficeAddress  extends cls_AddressStruct{}
    
    public class cls_Holds 
    {
        public String appliedDebtCounselling;
        public String businessAddressIndicator;
        public String businessRescueAffectedPartyIndicator;
        public String curatorshipIndicator;
        public String dateAppliedDebtCounselling;
        public String dateBusinessRescueIssued;
        public String dateDebtCounsellingOrderIssued;
        public String debtCounsellingOrderIssued;
        public String deceasedEstateIndicator;
        public String employerAddressIndicator;
        public String executorsAddressIndicator;
        public String fraudRiskIndicator;
        public String identificationIndicator;
        public String indicatorDeclaredInsolvent;
        public String inBusinessRescueIndicator;
        public String insolventEstateIndicator;
        public String inLiquidityIndicator;
        public String judicialManagementIndicator;
        public String placedInBusinessRescueBy;
        public String postalAddressIndicator;
        public String regNumberIndicator;
        public String residentialAddressIndicator;
        public String spouseDeceasedIndicator;
        public String voluntaryCrtConsolidationIndicator;
        public String finCrimeHoldIndicator;
        public String clientAgreementIssuedIndicator;
    }
    
    public class cls_Fica 
    {
        public String dateExempted;
        public String dateIdentified;
        public String dateVerified;
        public String empNoDateExempted;
        public String empOrAttorneyNo;
        public String empOrAttorneyNoDateVerified;
        public String exempted;
        public String exemptionIndicator;
    }
    
    public class cls_AccountAddress extends cls_AddressStruct {}
    public class cls_ExecutorAddress extends cls_AddressStruct {}
    
    public class cls_NextOfKin 
    {
        public String relationshipCode;
        public String surname;
        public String firstname;
        public String relatedToPartSurname;
        public String relatedToPartInitials;
        public String relatedToPartTitleCode;
        public cls_ContactDetail contactDetail;
    }
    
    public class cls_ContactDetail 
    {
        public String cellPhoneNo;
        public String emailAddress;
        public cls_HomePhone homePhone;
        public cls_HomeFax homeFax;
        public cls_WorkPhone workPhone;
        public cls_WorkFax workFax;
        public cls_HomeAddress homeAddress;
        public cls_PostalAddressNk postalAddress;    
    }
    
    public abstract class cls_NoSurburbAddress
    {
        public String line1;
        public String line2;
        public String city;
        public String postalCode;
        public String countryCode;
    }
    
    public class cls_PostalAddressNk
    {
        public String line1;
        public String line2;
        public String city;
        public String postalCode;
    }
    
    public class cls_JointParticipants 
    {
        public String clientType;
        public String clientTypeGroup;
        public cls_Client client;
        public cls_ContactInfo contactInfo;
        public cls_MarketingInfo marketingInfo;
        public cls_EmploymentInfo employmentInfo; 
        public cls_Holds holds; 
        public cls_Fica fica;
    }
    
    public CvsValidationService_Req_IB_v1 createDummyRequest()
    {    
        cls_Header header = new cls_Header();
        header.applicationId = 'SIEBEL';
        header.clientType = '00101';
        header.clientTypeGroup = 'I';
        header.errorMessagesLanguage = 'EN';
        header.version = '1.0';
        
        cls_IdNumber cIdNumber = new cls_IdNumber();
        cIdNumber.documentType = '3';
        cIdNumber.valNumber = 'P595959';
        cIdNumber.dateIssued = '?';
        cIdNumber.expiryDate = '?';
        cIdNumber.countryOfIssueCode = 'SO003';
        cIdNumber.tempResidentPerNo = '?';
        cIdNumber.permitExpiryDate = '?';
        
        cls_Client client = new cls_Client();
        client.surname = 'TestP-surname';
        client.firstname = 'TestP-firstname';
        client.initials = 'T';
        client.dateOfBirth = '15111999';
        client.gender = '1';
        client.IdNumber = cIdNumber;
        client.titleCode = '1';
        client.homeLanguage = '?';
        client.correspondenceLanguage = 'E';
        client.maritalStatus = '1';
        client.maritalContractType = '2';
        client.nationalityCode = 'SOU01';
        client.numberOfDependants = '?';
        client.incomeTaxNo = '?';
        client.universityCode = '?';
        client.postMatricIndicator = 'N';
        client.postMatricQualification = '?';
        client.residentialStatus = '?';
        client.socialGrant = 'N';
        client.creditWorthinessConsent = 'N';
        client.countryOfBirthCode = 'SO003';
        client.clientCode = '?';
        
        cls_HomeAddress ciHomeAddress = new cls_HomeAddress();
        ciHomeAddress.line1 = '1 RUBGY ST';
        ciHomeAddress.line2 = 'POSTALADDRESSLINE2';
        ciHomeAddress.city = 'AALWYNFLEUR';
        ciHomeAddress.suburb = '?';
        ciHomeAddress.postalCode = '6670';
        ciHomeAddress.countryCode = 'SO003';
        
        cls_PostalAddress ciPostalAdress = new cls_PostalAddress();
        ciPostalAdress.line1 = '1 RUBGY ST';
        ciPostalAdress.line2 = 'POSTALADDRESSLINE2';
        ciPostalAdress.city = 'AALWYNFLEUR';
        ciPostalAdress.postalCode = '6670';
        ciPostalAdress.countryCode = 'SO003';
        
        cls_HomePhone ciHomePhone = new cls_HomePhone();
        ciHomePhone.dialCode = '011';
        ciHomePhone.valNumber = '0115077000';
        
        cls_HomeFax ciHomeFax = new cls_HomeFax();
        ciHomeFax.dialCode = '011';
        ciHomeFax.valNumber = '0115077000';
        
        cls_WorkPhone ciWorkPhone = new cls_WorkPhone();
        ciWorkPhone.dialCode = '011';
        ciWorkPhone.valNumber = '0115077000';
        
        cls_WorkFax ciWorkFax = new cls_WorkFax();
        ciWorkFax.dialCode = '011';
        ciWorkFax.valNumber = '0115077000';        
        
        cls_ContactInfo contactInfo = new cls_ContactInfo();
        contactInfo.cellPhoneNo = '0845560989';
        contactInfo.emailAddress = 'testp@gmail.com';
        contactInfo.homePhone = ciHomePhone;
        contactInfo.homeFax = ciHomeFax;
        contactInfo.workPhone = ciWorkPhone;
        contactInfo.workFax = ciWorkFax;
        contactInfo.HomeAddress = ciHomeAddress;
        contactInfo.PostalAddress = ciPostalAdress;
        
        cls_MarketingInfo marketingInfo = new cls_MarketingInfo();
        marketingInfo.email = 'N';
        marketingInfo.mail = 'N';
        marketingInfo.sms = 'N';
        marketingInfo.telephone = 'Y';
        marketingInfo.massMarketing = 'Y';
        marketingInfo.marketingMailIndicator = 'Y';
        marketingInfo.preferredCommunicationChannel = '3';        
        
        cls_WorkAddress eiWorkAddress = new cls_WorkAddress();
        eiWorkAddress.line1 = '?';
        eiWorkAddress.line2 = '?';
        eiWorkAddress.suburb = '?';
        eiWorkAddress.city = '?';
        eiWorkAddress.postalCode = '?';
        eiWorkAddress.countryCode = '?';
        
        cls_EmploymentInfo employmentInfo = new cls_EmploymentInfo();
        employmentInfo.workAddress = eiWorkAddress;
        employmentInfo.employerName = '?';
        employmentInfo.employmentSector = '?';
        employmentInfo.occupationCode = '?';
        employmentInfo.occupationLevel = '?';
        employmentInfo.occupationStatus = '06';
        employmentInfo.monthlyIncome = '?';
        employmentInfo.sourceOfFunds = '?';
        employmentInfo.groupSchemeCode = '?';
        employmentInfo.groupSchemeEmployeeNumber = '?';
        
        cls_Address biAddress = new cls_Address();
        biAddress.line1 = '?';
        biAddress.line2 = '?';
        biAddress.suburb = '?';
        biAddress.city = '?';
        biAddress.postalCode = '?';
        biAddress.countryCode = '?';
        
        cls_CountryEntityOperates biCountryEntityOperates = new cls_CountryEntityOperates();
        biCountryEntityOperates.countyCode = '?';
        
        cls_RegisteredAddress biRegisteredAddress = new cls_RegisteredAddress();
        biRegisteredAddress.line1 = '?';
        biRegisteredAddress.line2 = '?';
        biRegisteredAddress.suburb = '?';
        biRegisteredAddress.city = '?';
        biRegisteredAddress.postalCode = '?';
        biRegisteredAddress.countryCode = '?';
        
        cls_HeadOfficeAddress biHeadOfficeAddress = new cls_HeadOfficeAddress();
        biHeadOfficeAddress.line1 = '?';
        biHeadOfficeAddress.line2 = '?';
        biHeadOfficeAddress.suburb = '?';
        biHeadOfficeAddress.city = '?';
        biHeadOfficeAddress.postalCode = '?';
        biHeadOfficeAddress.countryCode = '?';
        
        cls_BusinessInfo businessInfo = new cls_BusinessInfo();
        businessInfo.sicCode = '?';
        businessInfo.registrationNumber = '?';
        businessInfo.practiceOrTrustNo = '?';
        businessInfo.countryIncorporated = '?';
        businessInfo.internetWebSite = '?';
        businessInfo.vatRegistrationNo = '?';
        businessInfo.vatRegistrationNoAccount = '?';
        businessInfo.yearEnd = '?';
        businessInfo.address = biAddress;
        businessInfo.cpaThreshold = '?';
        businessInfo.ncaThreshold = '?';
        businessInfo.exconExpiryDate = '?';
        businessInfo.site = '?';
        businessInfo.countryEntityOperates = biCountryEntityOperates;
        businessInfo.registeredAddress =  biRegisteredAddress;
        businessInfo.headOfficeAddress = biHeadOfficeAddress;
        
        cls_Holds holds = new cls_Holds(); 
        holds.appliedDebtCounselling = '?';
        holds.businessAddressIndicator = '?';
        holds.businessRescueAffectedPartyIndicator = '?';
        holds.curatorshipIndicator = '?';
        holds.dateAppliedDebtCounselling = '?';
        holds.dateBusinessRescueIssued = '?';
        holds.dateDebtCounsellingOrderIssued = '?';
        holds.debtCounsellingOrderIssued = '?';
        holds.deceasedEstateIndicator = '?';
        holds.employerAddressIndicator = '?';
        holds.executorsAddressIndicator = '?';
        holds.fraudRiskIndicator = '?';
        holds.identificationIndicator = '?';
        holds.indicatorDeclaredInsolvent = '?';
        holds.inBusinessRescueIndicator = '?';
        holds.insolventEstateIndicator = '?';
        holds.inLiquidityIndicator = '?';
        holds.judicialManagementIndicator = '?';
        holds.placedInBusinessRescueBy = '?';
        holds.postalAddressIndicator = '?';
        holds.regNumberIndicator = '?';
        holds.residentialAddressIndicator = '?';
        holds.spouseDeceasedIndicator = '?';
        holds.voluntaryCrtConsolidationIndicator = '?';
        holds.finCrimeHoldIndicator = '?';
        holds.clientAgreementIssuedIndicator = '?';
        
        cls_Fica fica = new cls_Fica();
        fica.dateExempted = '?';
        fica.dateIdentified = '?';
        fica.dateVerified = '?';
        fica.empNoDateExempted = '?';
        fica.empOrAttorneyNo = '?';
        fica.empOrAttorneyNoDateVerified = '?';
        fica.exempted = '?';
        fica.exemptionIndicator = '?';
        
        cls_AccountAddress accountAddress = new cls_AccountAddress();
        accountAddress.line1 = '?';
        accountAddress.line2 = '?';
        accountAddress.suburb = '?';
        accountAddress.city = '?';
        accountAddress.postalCode = '?';
        accountAddress.countryCode = '?';
            
        cls_ExecutorAddress executorAddress = new cls_ExecutorAddress();
        executorAddress.line1 = '?';
        executorAddress.line2 = '?';
        executorAddress.suburb = '?';
        executorAddress.city = '?';
        executorAddress.postalCode = '?';
        executorAddress.countryCode = '?';
        
        cls_HomePhone nokCdHomePhone = new cls_HomePhone();
        nokCdHomePhone.dialCode = '?';
        nokCdHomePhone.valNumber = '?';
        
        cls_HomeFax nokCdHomeFax = new cls_HomeFax();
        nokCdHomeFax.dialCode = '?';
        nokCdHomeFax.valNumber = '?';
        
        cls_WorkPhone nokCdWorkPhone = new cls_WorkPhone();
        nokCdWorkPhone.dialCode = '?';
        nokCdWorkPhone.valNumber = '?';
        
        cls_WorkFax nokCdWorkFax = new cls_WorkFax();
        nokCdWorkFax.dialCode = '?';
        nokCdWorkFax.valNumber = '?';
        
        cls_HomeAddress nokCdHomeAddress = new cls_HomeAddress();
        nokCdHomeAddress.line1 = '?';
        nokCdHomeAddress.line2 = '?';
        nokCdHomeAddress.city = '?';
        nokCdHomeAddress.suburb = '?';
        nokCdHomeAddress.postalCode = '?';
        nokCdHomeAddress.countryCode = '?';
        
        cls_PostalAddressNk nokCdPostalAddressNk = new cls_PostalAddressNk();
        nokCdPostalAddressNk.line1 = '?';
        nokCdPostalAddressNk.line2 = '?';
        nokCdPostalAddressNk.city = '?';
        nokCdPostalAddressNk.postalCode = '?';

        cls_ContactDetail nokContactDetail = new cls_ContactDetail();
        nokContactDetail.cellPhoneNo = '?';
        nokContactDetail.emailAddress = '?';
        nokContactDetail.homePhone = nokCdHomePhone;
        nokContactDetail.homeFax = nokCdHomeFax;
        nokContactDetail.workPhone = nokCdWorkPhone;
        nokContactDetail.workFax = nokCdWorkFax;
        nokContactDetail.homeAddress = nokCdHomeAddress;
        nokContactDetail.postalAddress = nokCdPostalAddressNk;
        
        cls_NextOfKin nextOfKin = new cls_NextOfKin();
        nextOfKin.relationshipCode = '?';
        nextOfKin.surname = '?';
        nextOfKin.firstname = '?';
        nextOfKin.relatedToPartSurname = '?';
        nextOfKin.relatedToPartInitials = '?';
        nextOfKin.relatedToPartTitleCode = '?';
        nextOfKin.contactDetail = nokContactDetail;
        
        cls_IdNumber jpCIdNumber = new cls_IdNumber();
        jpCIdNumber.documentType = '?';
        jpCIdNumber.valNumber = '?';
        jpCIdNumber.dateIssued = '?';
        jpCIdNumber.expiryDate = '?';
        jpCIdNumber.countryOfIssueCode = '?';
        jpCIdNumber.tempResidentPerNo = '?';
        jpCIdNumber.permitExpiryDate = '?';
        
        cls_Client jpClient = new cls_Client();
        jpClient.surname = '?';
        jpClient.firstname = '?';
        jpClient.initials = '?';
        jpClient.dateOfBirth = '?';
        jpClient.gender = '?';
        jpClient.IdNumber = jpCIdNumber;
        jpClient.titleCode = '?';
        jpClient.homeLanguage = '?';
        jpClient.correspondenceLanguage = '?';
        jpClient.maritalStatus = '?';
        jpClient.maritalContractType = '?';
        jpClient.nationalityCode = '?';
        jpClient.numberOfDependants = '?';
        jpClient.incomeTaxNo = '?';
        jpClient.universityCode = '?';
        jpClient.postMatricIndicator = '?';
        jpClient.postMatricQualification = '?';
        jpClient.residentialStatus = '?';
        jpClient.socialGrant = '?';
        jpClient.creditWorthinessConsent = '?';
        jpClient.countryOfBirthCode = '?';
        jpClient.clientCode = '?';
        
        cls_PostalAddress jpCiPostalAddress = new cls_PostalAddress();
        jpCiPostalAddress.line1 = '?';
        jpCiPostalAddress.line2 = '?';
        jpCiPostalAddress.city = '?';
        jpCiPostalAddress.postalCode = '?';
        jpCiPostalAddress.countryCode = '?';
        
        cls_ContactInfo jpContactInfo = new cls_ContactInfo();
        jpContactInfo.cellPhoneNo = '?';
        jpContactInfo.emailAddress = '?';
        jpContactInfo.homePhone = nokCdHomePhone;
        jpContactInfo.homeFax = nokCdHomeFax;
        jpContactInfo.workPhone = nokCdWorkPhone;
        jpContactInfo.workFax = nokCdWorkFax;
        jpContactInfo.homeAddress = nokCdHomeAddress;
        jpContactInfo.postalAddress = jpCiPostalAddress;
        
        cls_MarketingInfo jpMarketingInfo = new cls_MarketingInfo();
        jpMarketingInfo.email = '?';
        jpMarketingInfo.mail = '?';
        jpMarketingInfo.sms = '?';
        jpMarketingInfo.telephone = '?';
        jpMarketingInfo.massMarketing = '?';
        jpMarketingInfo.marketingMailIndicator = '?';
        jpMarketingInfo.preferredCommunicationChannel = '?';        
        
        //EmployeeInfo
        employmentInfo.occupationStatus = '?';
        
        cls_JointParticipants jointParticipants = new cls_JointParticipants(); 
        List<cls_JointParticipants> jointParticipantsList = new List<cls_JointParticipants>();
        jointParticipants.clientType = '?';
        jointParticipants.clientTypeGroup = '?';
        jointParticipants.client = jpClient;
        jointParticipants.contactInfo = jpContactInfo;
        jointParticipants.marketingInfo = jpMarketingInfo;
        jointParticipants.employmentInfo = employmentInfo;
        jointParticipants.holds = holds; 
        jointParticipants.fica = fica;
        jointParticipantsList.add(jointParticipants);
        
        CvsValidationService_Req_IB_v1 request = new CvsValidationService_Req_IB_v1();
        request.header = header;
        request.client = client;
        request.contactInfo = contactInfo;
        request.marketingInfo = marketingInfo;
        request.employmentInfo = employmentInfo;
        request.businessInfo = businessInfo;
        request.holds = holds; 
        request.fica = fica;
        request.accountAddress = accountAddress;
        request.executorAddress = executorAddress; 
        request.designationCode = '?';
        request.contactPerson = '?';
        request.contactPersonIdNo = '?';
        request.affectedPersonReg = '?';
        request.noOfParticipants = '?';
        request.recipientName1 = '?';
        request.recipientName2 = '?';
        request.subClassificationCode = '?';
        request.detailedClassification = '?';
        request.detailedClassificationPcent = '?';   
        request.nextOfKin = nextOfKin; 
        request.jointParticipants = jointParticipantsList; 
        List<String> str = new List<String>();
        str.add('personalData_set');
        str.add('contactDetails_set');
        str.add('address_set');
        str.add('marketingConsent_set');
        request.validatorSet = str;
        
        CvsValidationService_Req_IB_v1 bean = new CvsValidationService_Req_IB_v1();
        bean = request;
        
        System.debug('RequestBean: ' + bean);
        return bean;
    }
    
    
    //This is NTB Client Onboarding By Anka Ganta : 2020-02-06
    public CvsValidationService_Req_IB_v1 createDummyRequest1()
    {    
       
       System.debug('inside');
       cls_Header header = new cls_Header();
        header.applicationId = 'SIEBEL';
        header.clientType = '00101';
        header.clientTypeGroup = 'N';
        header.errorMessagesLanguage = 'EN';
        header.version = '1.0';
        
        System.debug('client++'+header.clientTypeGroup);
        cls_IdNumber cIdNumber = new cls_IdNumber();
        cIdNumber.documentType = '05';
        cIdNumber.valNumber = '201930633006';
        cIdNumber.dateIssued = '?';
        cIdNumber.expiryDate = '?';
        cIdNumber.countryOfIssueCode = 'SO003';
        cIdNumber.tempResidentPerNo = '?';
        cIdNumber.permitExpiryDate = '?';
        
        cls_Client client = new cls_Client();
        client.surname = 'TestP-surname';
        client.firstname = 'TestP-firstname';
        client.initials = 'T';
        client.dateOfBirth = '15111999';
        client.gender = '1';
        client.IdNumber = cIdNumber;
        client.titleCode = '1';
        client.homeLanguage = '?';
        client.correspondenceLanguage = 'E';
        client.maritalStatus = '1';
        client.maritalContractType = '2';
        client.nationalityCode = 'SOU01';
        client.numberOfDependants = '?';
        client.incomeTaxNo = '?';
        client.universityCode = '?';
        client.postMatricIndicator = 'N';
        client.postMatricQualification = '?';
        client.residentialStatus = '?';
        client.socialGrant = 'N';
        client.creditWorthinessConsent = 'N';
        client.countryOfBirthCode = 'SO003';
        client.clientCode = '?';
        
        cls_HomeAddress ciHomeAddress = new cls_HomeAddress();
        ciHomeAddress.line1 = '1 RUBGY ST';
        ciHomeAddress.line2 = 'POSTALADDRESSLINE2';
        ciHomeAddress.city = 'AALWYNFLEUR';
        ciHomeAddress.suburb = '?';
        ciHomeAddress.postalCode = '6670';
        ciHomeAddress.countryCode = 'SO003';
        
        cls_PostalAddress ciPostalAdress = new cls_PostalAddress();
        ciPostalAdress.line1 = '1 RUBGY ST';
        ciPostalAdress.line2 = 'POSTALADDRESSLINE2';
        ciPostalAdress.city = 'AALWYNFLEUR';
        ciPostalAdress.postalCode = '6670';
        ciPostalAdress.countryCode = 'SO003';
        
        cls_HomePhone ciHomePhone = new cls_HomePhone();
        ciHomePhone.dialCode = '011';
        ciHomePhone.valNumber = '0115077000';
        
        cls_HomeFax ciHomeFax = new cls_HomeFax();
        ciHomeFax.dialCode = '011';
        ciHomeFax.valNumber = '0115077000';
        
        cls_WorkPhone ciWorkPhone = new cls_WorkPhone();
        ciWorkPhone.dialCode = '011';
        ciWorkPhone.valNumber = '0115077000';
        
        cls_WorkFax ciWorkFax = new cls_WorkFax();
        ciWorkFax.dialCode = '011';
        ciWorkFax.valNumber = '0115077000';        
        
        cls_ContactInfo contactInfo = new cls_ContactInfo();
        contactInfo.cellPhoneNo = '0845560989';
        contactInfo.emailAddress = 'testp@gmail.com';
        contactInfo.homePhone = ciHomePhone;
        contactInfo.homeFax = ciHomeFax;
        contactInfo.workPhone = ciWorkPhone;
        contactInfo.workFax = ciWorkFax;
        contactInfo.HomeAddress = ciHomeAddress;
        contactInfo.PostalAddress = ciPostalAdress;
        
        cls_MarketingInfo marketingInfo = new cls_MarketingInfo();
        marketingInfo.email = 'N';
        marketingInfo.mail = 'N';
        marketingInfo.sms = 'N';
        marketingInfo.telephone = 'Y';
        marketingInfo.massMarketing = 'Y';
        marketingInfo.marketingMailIndicator = 'Y';
        marketingInfo.preferredCommunicationChannel = '3';        
        
        cls_WorkAddress eiWorkAddress = new cls_WorkAddress();
        eiWorkAddress.line1 = '270 REPUBILE ave';
        eiWorkAddress.line2 = '?';
        eiWorkAddress.suburb = '?';
        eiWorkAddress.city = '?';
        eiWorkAddress.postalCode = '?';
        eiWorkAddress.countryCode = 'SO003';
        
        cls_EmploymentInfo employmentInfo = new cls_EmploymentInfo();
        employmentInfo.workAddress = eiWorkAddress;
        employmentInfo.employerName = '?';
        employmentInfo.employmentSector = '?';
        employmentInfo.occupationCode = '?';
        employmentInfo.occupationLevel = '?';
        employmentInfo.occupationStatus = '06';
        employmentInfo.monthlyIncome = '?';
        employmentInfo.sourceOfFunds = '?';
        employmentInfo.groupSchemeCode = '?';
        employmentInfo.groupSchemeEmployeeNumber = '?';
        
        cls_Address biAddress = new cls_Address();
        biAddress.line1 = '?';
        biAddress.line2 = '?';
        biAddress.suburb = '?';
        biAddress.city = '?';
        biAddress.postalCode = '?';
        biAddress.countryCode = '?';
        
        cls_CountryEntityOperates biCountryEntityOperates = new cls_CountryEntityOperates();
        biCountryEntityOperates.countyCode = '?';
        
        cls_RegisteredAddress biRegisteredAddress = new cls_RegisteredAddress();
        biRegisteredAddress.line1 = '270 REPUBILE ave';
        biRegisteredAddress.line2 = '?';
        biRegisteredAddress.suburb = '?';
        biRegisteredAddress.city = 'JOHANNESBURG';
        biRegisteredAddress.postalCode = '?';
        biRegisteredAddress.countryCode = 'SO003';
        
        cls_HeadOfficeAddress biHeadOfficeAddress = new cls_HeadOfficeAddress();
        biHeadOfficeAddress.line1 = '270 REPUBILE ave';
        biHeadOfficeAddress.line2 = '?';
        biHeadOfficeAddress.suburb = '?';
        biHeadOfficeAddress.city = 'JOHANNESBURG';
        biHeadOfficeAddress.postalCode = '?';
        biHeadOfficeAddress.countryCode = 'SO003';
        
        cls_BusinessInfo businessInfo = new cls_BusinessInfo();
        businessInfo.sicCode = '?';
        businessInfo.registrationNumber = '?';
        businessInfo.practiceOrTrustNo = '?';
        businessInfo.countryIncorporated = '?';
        businessInfo.internetWebSite = '?';
        businessInfo.vatRegistrationNo = '?';
        businessInfo.vatRegistrationNoAccount = '?';
        businessInfo.yearEnd = '?';
        businessInfo.address = biAddress;
        businessInfo.cpaThreshold = '?';
        businessInfo.ncaThreshold = '?';
        businessInfo.exconExpiryDate = '?';
        businessInfo.site = '?';
        businessInfo.countryEntityOperates = biCountryEntityOperates;
        businessInfo.registeredAddress =  biRegisteredAddress;
        businessInfo.headOfficeAddress = biHeadOfficeAddress;
        
        cls_Holds holds = new cls_Holds(); 
        holds.appliedDebtCounselling = '?';
        holds.businessAddressIndicator = '?';
        holds.businessRescueAffectedPartyIndicator = '?';
        holds.curatorshipIndicator = '?';
        holds.dateAppliedDebtCounselling = '?';
        holds.dateBusinessRescueIssued = '?';
        holds.dateDebtCounsellingOrderIssued = '?';
        holds.debtCounsellingOrderIssued = '?';
        holds.deceasedEstateIndicator = '?';
        holds.employerAddressIndicator = '?';
        holds.executorsAddressIndicator = '?';
        holds.fraudRiskIndicator = '?';
        holds.identificationIndicator = '?';
        holds.indicatorDeclaredInsolvent = '?';
        holds.inBusinessRescueIndicator = '?';
        holds.insolventEstateIndicator = '?';
        holds.inLiquidityIndicator = '?';
        holds.judicialManagementIndicator = '?';
        holds.placedInBusinessRescueBy = '?';
        holds.postalAddressIndicator = '?';
        holds.regNumberIndicator = '?';
        holds.residentialAddressIndicator = '?';
        holds.spouseDeceasedIndicator = '?';
        holds.voluntaryCrtConsolidationIndicator = '?';
        holds.finCrimeHoldIndicator = '?';
        holds.clientAgreementIssuedIndicator = '?';
        
        /*    cls_Fica fica = new cls_Fica();
        fica.dateExempted = '?';
        fica.dateIdentified = '?';
        fica.dateVerified = '?';
        fica.empNoDateExempted = '?';
        fica.empOrAttorneyNo = '?';
        fica.empOrAttorneyNoDateVerified = '?';
        fica.exempted = '?';
        fica.exemptionIndicator = '?';
        
    cls_AccountAddress accountAddress = new cls_AccountAddress();
        accountAddress.line1 = '?';
        accountAddress.line2 = '?';
        accountAddress.suburb = '?';
        accountAddress.city = '?';
        accountAddress.postalCode = '?';
        accountAddress.countryCode = '?'; 
            
        cls_ExecutorAddress executorAddress = new cls_ExecutorAddress();
        executorAddress.line1 = '?';
        executorAddress.line2 = '?';
        executorAddress.suburb = '?';
        executorAddress.city = '?';
        executorAddress.postalCode = '?';
        executorAddress.countryCode = '?'; */
        
        cls_HomePhone nokCdHomePhone = new cls_HomePhone();
        nokCdHomePhone.dialCode = '?';
        nokCdHomePhone.valNumber = '?';
        
        cls_HomeFax nokCdHomeFax = new cls_HomeFax();
        nokCdHomeFax.dialCode = '?';
        nokCdHomeFax.valNumber = '?';
        
        cls_WorkPhone nokCdWorkPhone = new cls_WorkPhone();
        nokCdWorkPhone.dialCode = '?';
        nokCdWorkPhone.valNumber = '?';
        
        cls_WorkFax nokCdWorkFax = new cls_WorkFax();
        nokCdWorkFax.dialCode = '?';
        nokCdWorkFax.valNumber = '?';
        
        cls_HomeAddress nokCdHomeAddress = new cls_HomeAddress();
        nokCdHomeAddress.line1 = '?';
        nokCdHomeAddress.line2 = '?';
        nokCdHomeAddress.city = '?';
        nokCdHomeAddress.suburb = '?';
        nokCdHomeAddress.postalCode = '?';
        nokCdHomeAddress.countryCode = '?';
        
        cls_PostalAddressNk nokCdPostalAddressNk = new cls_PostalAddressNk();
        nokCdPostalAddressNk.line1 = '?';
        nokCdPostalAddressNk.line2 = '?';
        nokCdPostalAddressNk.city = '?';
        nokCdPostalAddressNk.postalCode = '?';

        cls_ContactDetail nokContactDetail = new cls_ContactDetail();
        nokContactDetail.cellPhoneNo = '?';
        nokContactDetail.emailAddress = '?';
        nokContactDetail.homePhone = nokCdHomePhone;
        nokContactDetail.homeFax = nokCdHomeFax;
        nokContactDetail.workPhone = nokCdWorkPhone;
        nokContactDetail.workFax = nokCdWorkFax;
        nokContactDetail.homeAddress = nokCdHomeAddress;
        nokContactDetail.postalAddress = nokCdPostalAddressNk;
        
        cls_NextOfKin nextOfKin = new cls_NextOfKin();
        nextOfKin.relationshipCode = '?';
        nextOfKin.surname = '?';
        nextOfKin.firstname = '?';
        nextOfKin.relatedToPartSurname = '?';
        nextOfKin.relatedToPartInitials = '?';
        nextOfKin.relatedToPartTitleCode = '?';
        nextOfKin.contactDetail = nokContactDetail;
        
        cls_IdNumber jpCIdNumber = new cls_IdNumber();
        jpCIdNumber.documentType = '?';
        jpCIdNumber.valNumber = '?';
        jpCIdNumber.dateIssued = '?';
        jpCIdNumber.expiryDate = '?';
        jpCIdNumber.countryOfIssueCode = '?';
        jpCIdNumber.tempResidentPerNo = '?';
        jpCIdNumber.permitExpiryDate = '?';
        
        cls_Client jpClient = new cls_Client();
        jpClient.surname = '?';
        jpClient.firstname = '?';
        jpClient.initials = '?';
        jpClient.dateOfBirth = '?';
        jpClient.gender = '?';
        jpClient.IdNumber = jpCIdNumber;
        jpClient.titleCode = '?';
        jpClient.homeLanguage = '?';
        jpClient.correspondenceLanguage = '?';
        jpClient.maritalStatus = '?';
        jpClient.maritalContractType = '?';
        jpClient.nationalityCode = '?';
        jpClient.numberOfDependants = '?';
        jpClient.incomeTaxNo = '?';
        jpClient.universityCode = '?';
        jpClient.postMatricIndicator = '?';
        jpClient.postMatricQualification = '?';
        jpClient.residentialStatus = '?';
        jpClient.socialGrant = '?';
        jpClient.creditWorthinessConsent = '?';
        jpClient.countryOfBirthCode = '?';
        jpClient.clientCode = '?';
        
        cls_PostalAddress jpCiPostalAddress = new cls_PostalAddress();
        jpCiPostalAddress.line1 = '?';
        jpCiPostalAddress.line2 = '?';
        jpCiPostalAddress.city = '?';
        jpCiPostalAddress.postalCode = '?';
        jpCiPostalAddress.countryCode = '?';
        
        cls_ContactInfo jpContactInfo = new cls_ContactInfo();
        jpContactInfo.cellPhoneNo = '?';
        jpContactInfo.emailAddress = '?';
        jpContactInfo.homePhone = nokCdHomePhone;
        jpContactInfo.homeFax = nokCdHomeFax;
        jpContactInfo.workPhone = nokCdWorkPhone;
        jpContactInfo.workFax = nokCdWorkFax;
        jpContactInfo.homeAddress = nokCdHomeAddress;
        jpContactInfo.postalAddress = jpCiPostalAddress;
        
        cls_MarketingInfo jpMarketingInfo = new cls_MarketingInfo();
        jpMarketingInfo.email = '?';
        jpMarketingInfo.mail = '?';
        jpMarketingInfo.sms = '?';
        jpMarketingInfo.telephone = '?';
        jpMarketingInfo.massMarketing = '?';
        jpMarketingInfo.marketingMailIndicator = '?';
        jpMarketingInfo.preferredCommunicationChannel = '?';        
        
        //EmployeeInfo
        employmentInfo.occupationStatus = '?';
        
        cls_JointParticipants jointParticipants = new cls_JointParticipants(); 
        List<cls_JointParticipants> jointParticipantsList = new List<cls_JointParticipants>();
        jointParticipants.clientType = '?';
        jointParticipants.clientTypeGroup = '?';
        jointParticipants.client = jpClient;
        jointParticipants.contactInfo = jpContactInfo;
        jointParticipants.marketingInfo = jpMarketingInfo;
        jointParticipants.employmentInfo = employmentInfo;
        jointParticipants.holds = holds; 
        jointParticipants.fica = fica;
        jointParticipantsList.add(jointParticipants);
        
        CvsValidationService_Req_IB_v1 request = new CvsValidationService_Req_IB_v1();
        request.header = header;
        request.client = client;
        request.contactInfo = contactInfo;
        request.marketingInfo = marketingInfo;
        request.employmentInfo = employmentInfo;
        request.businessInfo = businessInfo;
        request.holds = holds; 
        request.fica = fica;
        request.accountAddress = accountAddress;
        request.executorAddress = executorAddress; 
        request.designationCode = '?';
        request.contactPerson = '?';
        request.contactPersonIdNo = '?';
        request.affectedPersonReg = '?';
        request.noOfParticipants = '?';
        request.recipientName1 = '?';
        request.recipientName2 = '?';
        request.subClassificationCode = '?';
        request.detailedClassification = '?';
        request.detailedClassificationPcent = '?';   
        request.nextOfKin = nextOfKin; 
        request.jointParticipants = jointParticipantsList; 
        List<String> str = new List<String>();
        str.add('personalData_set');
        str.add('contactDetails_set');
        str.add('address_set');
        str.add('marketingConsent_set');
        request.validatorSet = str;
        
        CvsValidationService_Req_IB_v1 bean = new CvsValidationService_Req_IB_v1();
        bean = request;
        
        System.debug('RequestBean: ' + request);
        //return bean;
        return request;
    }
    
    public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"valNumber":');
    }
}