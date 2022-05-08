public class WBIF_IB_String_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public cls_PolicyCreate Policy_Create;
    public cls_Policy_CreateResponse Policy_CreateResponse;
    
    public cls_Policy_AddBenefit Policy_AddBenefit;
    public cls_Policy_AddBenefitResponse Policy_AddBenefitResponse;
    
    public cls_Calculate Calculate;//Policy_Calculate
    public cls_CalculateResponse CalculateResponse;//Policy_CalculateResponse
   	
    public cls_Policy_AddBeneficiary Policy_AddBeneficiary;
    public cls_Policy_AddBeneficiaryResponse Policy_AddBeneficiaryResponse;
    
    public cls_Policy_AddDependent Policy_AddDependent;
    public cls_Policy_AddDependentResponse Policy_AddDependentResponse;
    
    public cls_ValidatePolicy ValidatePolicy;
    public cls_ValidatePolicyResponse ValidatePolicyResponse;
    
    public cls_SubmitPolicy SubmitPolicy;
    public cls_SubmitPolicyResponse SubmitPolicyResponse;
    
    public cls_Envelope Envelope;
    public cls_Fault Fault;
    
    public class cls_PolicyCreate{
        public String module;
        public cls_Application appinfo;
        public cls_member member;
        public cls_debit debit;
    }
    
    public class cls_Policy_CreateResponse{
        public cls_policy Policy_CreateResult;
    }
    
    public class cls_Calculate{
        public cls_policy policy;
    }
    
    public class cls_CalculateResponse{
        public cls_policy CalculateResult;//Policy_CalculateResult
    }
    
    public class cls_Policy_AddBenefit{
        public cls_policy policy;
        public String memberid;
        public String benefitid;
    }
    
    public class cls_Policy_AddBenefitResponse{
        public cls_policy Policy_AddBenefitResult;
    }
    
    public class cls_Policy_AddBeneficiary{
        public cls_policy policy;
        public cls_beneficiary_member member;
    }
    
    public class cls_Policy_AddBeneficiaryResponse{
        public cls_policy Policy_AddBeneficiaryResult;
    }
    
    public class cls_Policy_AddDependent{
        public cls_policy policy;
        public cls_beneficiary_member member;
    }
    
    public class cls_Policy_AddDependentResponse{
        public cls_policy Policy_AddDependentResult;
    }
    
    public class cls_ValidatePolicy{
        public cls_policy policy;
    }
    
    public class cls_ValidatePolicyResponse{
        public cls_policy ValidatePolicyResult;
    }
    
    public class cls_SubmitPolicy{
        public cls_policy policy;
    }
    
    public class cls_SubmitPolicyResponse{
        public cls_policy SubmitPolicyResult;
    }
    
    public class cls_policy{
        public String GUID;
        public cls_Application Application;
        public cls_Beneficiaries Beneficiaries;
        public cls_Children Children;
        public String Cover;
        public cls_debit DebitDetails;
        public cls_Dependents Dependents;
        public String Loadings;
        public cls_member MainMember;
        public cls_Benefit PolicyBenefit;
        public cls_PolicyInfo PolicyInfo;
        public String Premium;
        public cls_Spouse Spouse;
        public cls_Spouses Spouses;
        public String SpousesString;
        public Double TotalCommission;
        public String TotalCover;
        public String TotalPremium;
        public cls_UnderwritingItems UnderwritingItems;
        public cls_Signatories Signatories;
        public cls_Flags Flags;
        public String ModuleID;
    }
    
    public class cls_Envelope{
        public cls_Body Body;
    }
    
    public class cls_Body{
        public cls_Fault Fault;
    }
    
    public class cls_Fault{
        public String faultcode;
        public String faultstring;
        public cls_detail detail;
    }
    
    public class cls_detail{
        public cls_ExceptionDetail ExceptionDetail;
    }
    
    public class cls_ExceptionDetail extends cls_ExceptionBase{
        public cls_InnerExceptionCls InnerException;
        public cls_HelpLink HelpLink;
    }
    
    public class cls_HelpLink{}
    
    public class cls_InnerExceptionCls extends cls_ExceptionBase{
        public cls_InnerExceptionCls InnerException;
        public cls_HelpLink HelpLink;
    }
    
    public abstract class cls_ExceptionBase{
        public String innerExceptionType; //Type
        public String StackTrace;
        public String Message;
    }
    public class cls_Application{
        public String GUID;
        public String DistributionChannel;
        public String IsBranchSales;
        public String IsClientPresent;
        public cls_Agent Agent;
        public cls_Consultant Consultant;
        public cls_Declaration Declaration;
        public cls_Replacement Replacement;
    }
    
    public class cls_Agent{
        public String GUID;
        public String DistributionChannel;
        public String EmployeeNumber;
        public String Name;
        public String PRINumber;
        public String RsaIdNumber;
        public String SiteCode;
    }
    
    public class cls_Consultant{
        public String GUID;
        public String ABNumber;
        public String Branch;
        public String EmployeeNumber;
        public String Name;
        public String SiteCode;
        public String IntermediaryCode;
        public String PRINumber;
    }
    
    public class cls_Declaration{
        public String GUID;
        public String IsFit;
        public String IsSupervised;
        public String Supervisor;
        public String Advice;
        public String Name;
    }
    
    public class cls_Replacement{
        public String GUID;
        public String Company;
        public String ReplacementDate;//real name is 'Date' but that cannot be a variable in SF. Might need to manually map this field after serialization 
        public String IsReplacement;
        public String PolicyNumber;
    }
    
    public class cls_Beneficiaries{
        public cls_Beneficiary[] Beneficiary;
        public cls_Beneficiary BeneficiaryObj;
    }
    
    public class cls_Beneficiary extends cls_Person{
        public String EmailAddress;
        public String BenefitSplit;
        public String Relationship;
    }
    
    public class cls_Children extends cls_Person{
        public String Cover;
        public String Loadings;
        public String Premium;
        public String Relationship;
        public cls_Dependent[] Dependent;
        public cls_Dependent DependentObj;
    }
    
    public class cls_Dependents{
        public cls_Dependent[] Dependent;
        public cls_Dependent DependentObj;
    }
    
    public class cls_Dependent extends cls_Person{
        public String BenefitOption;
        public cls_Benefit Benefit;
        public cls_Benefit BenefitObj;
        public cls_Benefits Benefits;
        public String EmailAddress;
        public String Cover;
        public String Loadings;
        public String Premium;
        public String Relationship;
    }
    
    
    
    /*public class cls_Appinfo{
public String GUID;
public cls_Agent Agent;
public cls_Consultant Consultant;
public cls_Declaration Declaration;
public String DistributionChannel;
public String IsBranchSales;
public String IsClientPresent;
public cls_Replacement Replacement;
}*/
    
    public class cls_member extends cls_Person{
        public String EmailAddress;
        public cls_Benefit Benefit;
        public cls_Benefit BenefitObj;
        public cls_Benefits Benefits;
        public String BenefitOption;
        public String Cover;
        public String Loadings;
        public String Premium;
        public String CasaReferenceNumber;
        public String CifClientCode;
        public cls_ContactDetails ContactDetails;
        public String CountryOfBirth;
        public String CountryOfResidence;
        public String IncomeBand;
        public String IsIndividual;
        public String IsSouthAfrican;
        public String Language;
        public String MaritalStatus;
        public String Nationality;
        public String Occupation;
        public String SourceOfFunds;
        public String SourceOfIncome;
        public String IsStaff;
        public String WillNumber;
    }
    
    public class cls_beneficiary_member extends cls_Person{
        public String BenefitSplit;
        public String Relationship;
    }
    
    public class cls_Benefits{
        public cls_Benefit[] Benefit;
        public cls_Benefit BenefitObj;
    }
    public class cls_Benefit{
        public String GUID;
        public String BenefitID;
        public String Cover;
        public String CoverIncrease;
        public String Loadings;
        public String Option;
        public String Premium;
        public String PremiumIncrease;
        public cls_PremiumLoadings PremiumLoadings;
        public String PremiumLoadingsString;
        public String TotalPremium;
    }
    
    public class cls_ContactDetails{
        public String GUID;
        public String CellTelephone;
        public String EmailAddress;
        public String HomeTelephone;
        public String OptIn;
        public cls_Address PhysicalAddress;
        public cls_Address PostalAddress;
        public String WorkTelephone;
    }
    
    public class cls_Address{
        public String GUID;
        public String Line1;
        public String Line2;
        public String Line3;
        public String Line4;
        public String PostalCode;
        public String SingleLine;
    }
    
    public class cls_debit{
        public String GUID;
        public String AccountHolder;
        public String AccountType;
        public String Bank;
        public String Branch;
        public String BranchClearingCode;
        public String DebitAccountNumber;
        public String DebitDate;
        public String DebitDay;
        public String SalaryDay;
        public String ThirdParty;
    }
    
    public class cls_PremiumLoadings{
        public cls_PremiumLoading[] PremiumLoading;
    }
    
    public class cls_PremiumLoading{
        public String GUID;
        public String Amount;
        public String ID;
        public String Percentage;
        public String Rate;
        public String Term;
        public String PremiumLoadingType;//real name is 'Type' but that cannot be a variable in SF. Might need to manually map this field after serialization 
    }
    
    public class cls_PolicyInfo{
        public String GUID;
        public String Application;
        public String ContractID;
        public String ContractOptionID;
        public String Disclosure;
        public cls_ErrorReason ErrorReason;
        public String ErrorReasons;
        public String Inception;
        public String Issue;
        public String Name;
        public String PolicyNumber;
        public String ProposalNumber;
        public String State;
    }
    
    public class cls_ErrorReason{
        public List<String> errorString;//string
    }
    
    public class cls_Spouse extends cls_Person{
        public String BenefitOption;
        public String Cover;
        public String Loadings;
        public String Premium;
        public String Relationship;
        public cls_Benefit Benefit;
        public cls_Benefits Benefits;
    }
    
    public class cls_Spouses{
        public cls_Dependent[] Dependent;
    }
    
    public class cls_UnderwritingItems{
        public cls_UnderwritingItem[] UnderwritingItem;
    }
    
    public class cls_UnderwritingItem{
        public String GUID;
        public String ID;
        public String Value;
    }
    
    public class cls_Signatories{
        
    }
    
    public class cls_Flags{
        public cls_KeyValueOfstringstring[] KeyValueOfstringstring;
    }
    
    public class cls_KeyValueOfstringstring{
        public String Key;
        public String Value;
    }
    
    public abstract class cls_Person{
        public String GUID;
        public String Age;
        public String DateOfBirth;
        public String FirstName;
        public String FullName;
        public String Gender;
        public String Initials;
        public String MemberType;
        public String Name;
        public String Names;
        public String RsaIdNumber;
        public String ShortName;
        public String Surname;
        public String Title;
    }
     
}