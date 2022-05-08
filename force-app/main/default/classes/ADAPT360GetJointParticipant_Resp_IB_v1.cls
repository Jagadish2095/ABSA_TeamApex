public class ADAPT360GetJointParticipant_Resp_IB_v1 extends Base_IB{
	
	public String status;
    public Integer statusCode;
    public String message;
    
    public cls_ClientDetails[] clientDetails;
    
    public class cls_ClientDetails{
        public cls_AccountInfo[] account;
        public cls_IndividualInfo individual;
        public cls_CustomerDetailsInfo customerDetails;
        public cls_LocationInfo location;
        public cls_ContactInfo contact;
        public cls_CorporateEntityInfo corporateEntity;
        public cls_CustomerInfo customer;
        public cls_MetaInfo meta;
        public cls_IdentificationsInfo[] identifications;
        public cls_FlagInfo flags;
        public cls_AuthorityInfo[] authority;
        public String nbrRetrv;
        public cls_JntEntry[] jntEntry;
        public String clientDetailsId;	//original - id
        public String links;
    }
    
    public class cls_AccountInfo{
        public String accountNumber;
        public String product;
        public String productType;
        public String availableBalance;
        public Decimal availableBalanceFormatted ;
        public String availableBalanceSpecified;
        public String balance;
        public Decimal balanceFormatted ;
        public String balanceSpecified;
        public String balanceTxt;
        public String branch;
        public String corporationCode;
        public String dateClosed;
        public String detail;
        public String limits;
        public String limitSpecified;
        public String accountStatus;
        public String ref;//AccountInfo.entityreference.ref
    }
    
    public class cls_IndividualInfo{
        public String givenName;
        public String nameInitials;
        public String surname;
        public String salutationType;//cls_keyvaluepair
        public String countryPassport;//cls_keyvaluepair
        public String countryOfBirth;//cls_keyvaluepair
        public String gender;//cls_keyvaluepair
        public String nationality;//cls_keyvaluepair
        public String employmentStatusType;//cls_keyvaluepair
        public cls_DocumentDetailsInfo documentDetails;
        public String birthDate;
        public String countryOfOrigin;//cls_keyvaluepair
        public String countryOfResidence;//cls_keyvaluepair
    }
    
    public class cls_CustomerDetailsInfo{
        public String identificationTypeId;//cls_keyvaluepair
        public String individualId;
        public String universalResourceLocator;
        public String customerType;//cls_keyvaluepair
        public String groupScheme;//cls_keyvaluepair
        public String sourceOfFundsCode;//cls_keyvaluepair
        public String sourceOfIncomeCode;//cls_keyvaluepair
        public String corporateDivision;//cls_keyvaluepair
        public String NCAThreshold;
        public String CPAThreshold;
        public String sbuSegment;//cls_keyvaluepair
        public String forensicHold;
        public String inLiquidation;
        public String underJudicialManagement;
        public String financialCrime;
        public String inBusinessRescue;
        public String inBusinessRescueAffectedParty;
        public String placedInBusinessRescueBy;
        public String casaReference;
        public String businessRescueIssueDate;
    }
    
    public class cls_LocationInfo {
        public cls_Address physicalAddress;
        public cls_Address postalAddress;
        public cls_Address businessAddress;
        public cls_Address headOfficeAddress;
    }
    
    public class cls_Address {
        public String addressName1;
        public String addressName2;
        public String suburbName;
        public String cityName;
        public String postCodeArea;
        public String addressTypeCode;
        public String addressType;
    }
    
    public class cls_ContactInfo {
        public String cellPhoneNumber;
        public String communicationChannelType;//cls_keyvaluepair
        public String workPhone;
        public String homePhone;
        public String telephoneNumber;
        public String eMailUserId;
        public String contactPerson;
        public String designation;
    }
    
    public class cls_CorporateEntityInfo {
        public String incorporatedCountry;//cls_keyvaluepair
        public String standardIndustryCode;//cls_keyvaluepair
    }
    
    public class cls_CustomerInfo {
        public cls_CustomerDetails Details;
    }
    
    public class cls_MetaInfo {
        public cls_QueryResultInfo queryResult;
    }
    
    public class cls_QueryResultInfo {
        public String sourceSystem;
        public String queryResultInfoType;	//Original - Type
    }
    
    public class cls_IdentificationsInfo {
        public String identificationType; //Original - Type //cls_keyvaluepair
        public String numbers;
        public Boolean personalIdentificationFlag;
        public Boolean systemIdentificationFlag;
        public String issueDate;
        public String expiryDate;
        public String country;
    }
    
    public class cls_FlagInfo {
        public String compliant;
        public String reason;//cls_keyvaluepair
    }
    
    public class cls_AuthorityInfo {
        public cls_SignatoryDetailsInfo[] signatoryDetails;
        public String authorityTypeCode;
        public String customerCode;
        public String accountNumber;
        public String changeTrackingNumber;
        public String courtAuthorityCode;
        public String numberOfSignatures;
        public String employeeNumber;
        public String originalCourtAuthorityCode;
        public String originalNumberOfSignatures;
        public String originalSpecialConditions;
        public String overrideEmployeeNumber;
        public String specialConditions;
        public String status;
        public String changedSignatory;
        public String authorityType;
    }
    
    public class cls_SignatoryDetailsInfo {
        public String accountNumber;
        public String dateIssued;
        public String expiryDate;
        public String maximumAmount;
        public Decimal maximumAmountFormatted ;
        public String ref;//entityreference.ref
    }
    
    public class cls_CustomerDetails {
        public String CPAThreshold;
    }
    
    public class cls_DocumentDetailsInfo {
        public cls_DocumentInfo idDoc;
        public cls_DocumentInfo addDoc;
    }
    
    public class cls_DocumentInfo {
        public String casaTier;
        public String documentType;//cls_keyvaluepair
        public String documentStatusReason;//cls_keyvaluepair
        public String casaSequence;
        public String imageId;
        public String casaReference;
        public String documentRecieved;
        public String documentInOrder;
        public String qualityAssurance;
        public String allCorrectRecieved;
        public String allCorrectInOrder;
    }
    
    public class cls_JntEntry{
        public String idDocType;
        public String idNumber;
        public String initials;
        public String titleCode;
        public String surname;
        public String resAddrLine1;
        public String resAddrLine2;
        public String resSuburb;
        public String resTown;
        public String resPosCde;
        public String firstNames;
        public String homeTelCode;
        public String homeTelephone;
        public String workTelCode;
        public String workTelephone;
        public String cellphone;
        public String practiceNumber;
        public String birthDate;
        public String sourceOfIncome;
        public String dateIdentified;
        public String dateVerified;
        public String employeeIdentified;
        public String employeeVerified;
        public String taxNumber;
        public String clientNationality;
        public String countryOfOrigin;
        public String tempPermitNumber;
        public String permitExpiryDate;
        public String homeTcodex;
        public String workTcodex;
        public String cellx;
        public String groupScheme;
        public String groupSchemeEmp;
        public String dateIssued;
        public String dateExempted;
        public String empExempted;
        public String statusOfExempt;
        public String exemptionInd;
        public String countryOfRes;
        public String countryOfBirth;
        public String occupationStatus;
        public String occupationCode;
        public String saTaxRegis;
        public String rsonSaTaxNotGiven;
        public String foreignTaxRegis;
        public cls_ForeignTaxData[] foreignTaxData;        
    }
    
    public class cls_ForeignTaxData{
        public String foreignTaxCtry;
        public String foreignTaxNo;
        public String rsonFtaxNotGiven;
    }
}