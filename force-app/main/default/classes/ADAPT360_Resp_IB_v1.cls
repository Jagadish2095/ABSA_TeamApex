public class ADAPT360_Resp_IB_v1 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message;
    public List<ClientDetails> ClientDetails;
    
    public class ClientDetails implements Comparable{
        // Class which defines the Client details returned in Adapt360 Service
        public AccountInfo[] account{get;set;}
        public IndividualInfo individual{get;set;}
        public CustomerDetailsInfo customerDetails{get;set;}
        public LocationInfo location{get;set;}
        public ContactInfo contact{get;set;}
        public CorporateEntityInfo corporateEntity{get;set;}
        public CustomerInfo customer{get;set;}
        public MetaInfo meta{get;set;}
        public IdentificationsInfo[] identifications{get;set;}
        public String links{get;set;}
        public FlagInfo flags{get;set;}
        public AuthorityInfo[] authority{get;set;}
        public String clientDetailsId{get;set;}	//original - id
        
        // we order clients alphabetically by AuthorityType, then Name
        public Integer compareTo(Object compareTo) {
            String thisCombined;
            if (individual.salutationType.description.value != null) thisCombined = thisCombined + individual.salutationType.description.value.trim();
            if (individual.nameInitials.value != null) thisCombined = thisCombined + individual.nameInitials.value.trim();
            if (individual.surname.value != null) thisCombined = thisCombined + individual.surname.value.trim();
            if (authority.size() > 0 && authority[0].authorityType.value != null) thisCombined = authority[0].authorityType.value + thisCombined;
            ADAPT360_Resp_IB_v1.ClientDetails compareToclient = (ADAPT360_Resp_IB_v1.ClientDetails)compareTo;
            String compareTocombined;
            if (compareToclient.individual.salutationType.description.value != null) compareTocombined = compareTocombined + compareToclient.individual.salutationType.description.value.trim();
            if (compareToclient.individual.nameInitials.value != null) compareTocombined = compareTocombined + compareToclient.individual.nameInitials.value.trim();
            if (compareToclient.individual.surname.value != null) compareTocombined = compareTocombined + compareToclient.individual.surname.value.trim();
            if (compareToclient.authority.size() > 0 && compareToclient.authority[0].authorityType.value != null) compareTocombined = compareToclient.authority[0].authorityType.value.trim() + compareTocombined;
            return thisCombined.compareTo(compareTocombined);
        }
    }
    
    public class AccountInfo implements Comparable {
        public attribute accountNumber{get;set;}
        public attribute product{get;set;}
        public attribute productType{get;set;}
        public attribute availableBalance{get;set;}
        public Decimal availableBalanceFormatted {
            get {
                if (availableBalance!=null && availableBalance.value!=null) return Decimal.valueOf(availableBalance.value); else return null;
            }
        }
        public attribute availableBalanceSpecified{get;set;}
        public attribute balance{get;set;}
        public Decimal balanceFormatted {
            get {
                if (balance!=null && balance.value!=null) return Decimal.valueOf(balance.value); else return null;
            }
        }
        public attribute balanceSpecified{get;set;}
        public attribute balanceTxt{get;set;}
        public attribute branch{get;set;}
        public attribute corporationCode{get;set;}
        public attribute dateClosed{get;set;}
        public attribute detail{get;set;}
        public attribute limits{get;set;}
        public attribute limitSpecified{get;set;}
        public attribute accountStatus{get;set;}
        public entityreference entity{get;set;}
        
        // we order accounts alphabetically by Status then Account Number
        public Integer compareTo(Object compareTo) {
            String thisCombined;
            if (accountStatus.value != null) thisCombined = thisCombined + accountStatus.value.trim();
            if (accountNumber.value != null) thisCombined = thisCombined + accountNumber.value.trim();
            String compareTocombined;
            if (((AccountInfo)compareTo).accountStatus.value != null) compareTocombined = compareTocombined + ((AccountInfo)compareTo).accountStatus.value;
            if (((AccountInfo)compareTo).accountNumber.value != null) compareTocombined = compareTocombined + ((AccountInfo)compareTo).accountNumber.value;
            return thisCombined.compareTo(compareTocombined);
        }
    }
    
    public class IndividualInfo {
        public attribute givenName{get;set;}
        public attribute nameInitials{get;set;}
        public attribute surname{get;set;}
        public keyvaluepair salutationType{get;set;}
        public keyvaluepair countryPassport{get;set;}
        public keyvaluepair countryOfBirth{get;set;}
        public keyvaluepair gender{get;set;}
        public keyvaluepair nationality{get;set;}
        public keyvaluepair employmentStatusType{get;set;}
        public DocumentDetailsInfo documentDetails{get;set;}
        public attribute birthDate{get;set;}
        public keyvaluepair countryOfOrigin{get;set;}
        public keyvaluepair countryOfResidence{get;set;}
    }
    
    public class CustomerDetailsInfo {
        public keyvaluepair identificationTypeId{get;set;}
        public attribute individualId{get;set;}
        public attribute universalResourceLocator{get;set;}
        public keyvaluepair customerType{get;set;}
        public keyvaluepair groupScheme{get;set;}
        public keyvaluepair sourceOfFundsCode{get;set;}
        public keyvaluepair sourceOfIncomeCode{get;set;}
        public keyvaluepair corporateDivision{get;set;}
        public attribute NCAThreshold{get;set;}
        public attribute CPAThreshold{get;set;}
        public keyvaluepair sbuSegment{get;set;}
        public attribute forensicHold{get;set;}
        public attribute inLiquidation{get;set;}
        public attribute underJudicialManagement{get;set;}
        public attribute financialCrime{get;set;}
        public attribute inBusinessRescue{get;set;}
        public attribute inBusinessRescueAffectedParty{get;set;}
        public attribute placedInBusinessRescueBy{get;set;}
        public attribute businessRescueIssueDate{get;set;}
        public attribute casaReference{get;set;}
    }
    
    public class LocationInfo {
        public Address physicalAddress{get;set;}
        public Address postalAddress{get;set;}
        public Address businessAddress{get;set;}
        public Address headOfficeAddress{get;set;}
    }
    
    public class Address {
        public attribute addressName1{get;set;}
        public attribute addressName2{get;set;}
        public attribute suburbName{get;set;}
        public attribute cityName{get;set;}
        public attribute postCodeArea{get;set;}
        public attribute addressTypeCode{get;set;}
        public attribute addressType{get;set;}
    }
    
    public class ContactInfo {
        public attribute cellPhoneNumber{get;set;}
        public keyvaluepair communicationChannelType{get;set;}
        public attribute workPhone{get;set;}
        public attribute homePhone{get;set;}
        public attribute telephoneNumber{get;set;}
        public attribute eMailUserId{get;set;}
        public attribute contactPerson{get;set;}
        public attribute designation{get;set;}
    }
    
    public class CorporateEntityInfo {
        public keyvaluepair incorporatedCountry{get;set;}
        public keyvaluepair standardIndustryCode{get;set;}
    }
    
    public class CustomerInfo {
        public CustomerDetails Details;
    }
    
    public class CustomerDetails {
        public attribute CPAThreshold{get;set;}
    }
    
    public class MetaInfo {
        public QueryResultInfo queryResult;
    }
    
    public class QueryResultInfo {
        public String sourceSystem{get;set;}
        public String queryResultInfoType{get;set;}	//Original - Type
    }
    
    public class IdentificationsInfo {
        public IdentificationType identificationType{get;set;} //Original - Type
        public String numbers{get;set;}
        public Boolean personalIdentificationFlag{get;set;}
        public Boolean systemIdentificationFlag{get;set;}
        public String issueDate{get;set;}
        public String expiryDate{get;set;}
        public String country{get;set;}
    }
    
    public class IdentificationType {
        public String code;
        public String description;
    }
    
    public class FlagInfo {
        public attribute compliant{get;set;}
        public keyvaluepair reason{get;set;}
    }
    
    public class AuthorityInfo {
        public SignatoryDetailsInfo[] signatoryDetails{get;set;}
        public attribute authorityTypeCode{get;set;}
        public attribute customerCode{get;set;}
        public attribute accountNumber{get;set;}
        public attribute changeTrackingNumber{get;set;}
        public attribute courtAuthorityCode{get;set;}
        public attribute numberOfSignatures{get;set;}
        public attribute employeeNumber{get;set;}
        public attribute originalCourtAuthorityCode{get;set;}
        public attribute originalNumberOfSignatures{get;set;}
        public attribute originalSpecialConditions{get;set;}
        public attribute overrideEmployeeNumber{get;set;}
        public attribute specialConditions{get;set;}
        public attribute status{get;set;}
        public attribute changedSignatory{get;set;}
        public attribute authorityType{get;set;}
    }
    
    public class SignatoryDetailsInfo {
        public ProductInfo product;
        public attribute dateIssued{get;set;}
        public attribute expiryDate{get;set;}
        public attribute maximumAmount{get;set;}
        public Decimal maximumAmountFormatted {
            get {
                if (maximumAmount!=null && maximumAmount.value!=null) return Decimal.valueOf(maximumAmount.value); else return null;
            }
        }
        public entityreference entity{get;set;}
    }
    
    public class ProductInfo {
        public attribute accountNumber{get;set;}
    }
    
    public class DocumentDetailsInfo {
        public DocumentInfo idDoc{get;set;}
        public DocumentInfo addDoc{get;set;}
    }
    
    public class DocumentInfo {
        public attribute casaTier{get;set;}
        public keyvaluepair documentType{get;set;}
        public keyvaluepair documentStatusReason{get;set;}
        public attribute casaSequence{get;set;}
        public attribute imageId{get;set;}
        public attribute casaReference{get;set;}
        public attribute documentRecieved{get;set;}
        public attribute documentInOrder{get;set;}
        public attribute qualityAssurance{get;set;}
        public attribute allCorrectRecieved{get;set;}
        public attribute allCorrectInOrder{get;set;}
    }
    
    public class attribute { 
        public String value{get;set;} 
    }
    
    public class entityreference { 
        public String ref{get;set;} 
    }
    
    public class keyvaluepair {
        public attribute code{get;set;}
        public attribute description{get;set;}    
    }
    
    public override void setFieldNameSubstitutions(){
        
        fieldNameSubstitutionMap = new Map<String, String>();
        //fieldNameSubstitutionMap.put('Type', 'innerExceptionType');
        fieldNameSubstitutionMap.put('"type":"', '"queryResultInfoType":"');
        fieldNameSubstitutionMap.put('"type":{', '"identificationType":{');
        fieldNameSubstitutionMap.put('limit', 'limits');
        fieldNameSubstitutionMap.put('$ref', 'ref');
        fieldNameSubstitutionMap.put('number', 'numbers');
        fieldNameSubstitutionMap.put('_links', 'links');
        fieldNameSubstitutionMap.put('$id', 'clientDetailsId');
    }
}