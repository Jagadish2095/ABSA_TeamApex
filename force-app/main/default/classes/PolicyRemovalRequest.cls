/**
 * @description PolicyRemovalRequest Description
 *
 */
public class PolicyRemovalRequest extends Base_IB{
    
    public DeleteBenefit Policy_DeleteBenefit;
    
    public DeleteBeneficiary Policy_DeleteBeneficiary;
    
    public DeleteDependent Policy_DeleteDependent;  

	public PolicyDetails DetailsPolicy;
    
	/**
	 * @description DeleteBenefit Description
	 *
	 */
    public class DeleteBenefit{     
        public String memberid;
        public String benefitid;
          public PolicyDetails policy; 
    }

	/**
	 * @description DeleteDependent Description
	 *
	 */
    public class DeleteDependent{     
        
        public String dependentId;
        
        public PolicyDetails policy; 
    }
	/**
	 * @description DeleteBenefit Description
	 *
	 */
    public class DeleteBeneficiary{     
        
        public String beneficiaryId;
          public PolicyDetails policy; 
    }
	/**
	 * @description DeleteBenefit Description
	 *
	 */
    public class PolicyDetails extends Base_IB{
		public String GUID;
		public Application Application;
		public Beneficiaries Beneficiaries;
		public Children Children;
		public String Cover;
		public Debit DebitDetails;
		public Dependents Dependents;
		public String Loadings;
		public Member MainMember;
		public Benefit PolicyBenefit;
		public String BenefitOption;
		public PolicyInfo PolicyInfo;
		public String Premium;
		public Spouse Spouse;
		public Spouses Spouses;
		// public String SpousesString;
		public Double TotalCommission;
		public String TotalCover;
		public String TotalPremium;
		public UnderwritingItems UnderwritingItems;
		public Flags Flags;
		public String ModuleID;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Application{
		public String GUID;
		public String DistributionChannel;
		public String IsBranchSales;
		public String IsClientPresent;
		public Agent Agent;
		public Consultant Consultant;
		public Declaration Declaration;
		public Replacement Replacement;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Agent{
		public String GUID;
		public String DistributionChannel;
		public String EmployeeNumber;
		public String Name;
		public String PRINumber;
		public String RsaIdNumber;
		public String SiteCode;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Consultant{
		public String GUID;
		public String ABNumber;
		public String Branch;
		public String EmployeeNumber;
		public String Name;
		public String SiteCode;
		public String IntermediaryCode;
		public String PRINumber;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Declaration{
		public String GUID;
		public String IsFit;
		public String IsSupervised;
		public String Supervisor;
		public String Advice;
		public String Name;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Replacement{
		public String GUID;
		public String Company;
		public String ReplacementDate;
		public String IsReplacement;
		public String PolicyNumber;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Beneficiaries{
		public Beneficiary[] Beneficiary;
		public Beneficiary BeneficiaryObj;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Beneficiary extends Person{
		public String EmailAddress;
		public String BenefitSplit;
		public String Relationship;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Children extends Person{
		public String Cover;
		public String Loadings;
		public String Premium;
		public String Relationship;
		public Dependent[] Dependent;
		public Dependent DependentObj;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Dependents{
		public Dependent[] Dependent;
		public Dependent DependentObj;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Dependent extends Person{
		public String BenefitOption;
		public Benefit Benefit;
		public Benefit BenefitObj;
		public Benefits Benefits;
		public String EmailAddress;
		public String Cover;
		public String Loadings;
		public String Premium;
		public String Relationship;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Member extends Person{
		public String EmailAddress;
		public Benefit Benefit;
		public Benefits Benefits;
		public String BenefitOption;
		public String Cover;
		public String Loadings;
		public String Premium;
		public String CasaReferenceNumber;
		public String CifClientCode;
		public ContactDetails ContactDetails;
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
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class cls_beneficiary_member extends Person{
		public String BenefitSplit;
		public String Relationship;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Benefits{
		public Benefit[] Benefit;
		public Benefit BenefitObj;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Benefit{
		public String GUID;
		public String BenefitID;
		public String Cover;
		public String CoverIncrease;
		public String Loadings;
		public String Option;
		public String Premium;
		public String PremiumIncrease;
		public PremiumLoadings PremiumLoadings;
		public String PremiumLoadingsString;
		public String TotalPremium;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class ContactDetails{
		public String GUID;
		public String CellTelephone;
		public String EmailAddress;
		public String HomeTelephone;
		public String OptIn;
		public Address PhysicalAddress;
		public Address PostalAddress;
		public String WorkTelephone;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Address{
		public String GUID;
		public String Line1;
		public String Line2;
		public String Line3;
		public String Line4;
		public String PostalCode;
		public String SingleLine;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class debit{
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
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class PremiumLoadings{
		public PremiumLoading[] PremiumLoading;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class PremiumLoading{
		public String GUID;
		public String Amount;
		public String ID;
		public String Percentage;
		public String Rate;
		public String Term;
		public String PremiumLoadingType;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class PolicyInfo{
		public String GUID;
		public String Application;
		public String ContractID;
		public String ContractOptionID;
		public String Disclosure;
		public ErrorReason ErrorReason;
		public String ErrorReasons;
		public String Inception;
		public String Issue;
		public String Name;
		public String PolicyNumber;
		public String ProposalNumber;
		//public String State;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class ErrorReason{
		public List<String> errorString;//string
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Spouse extends Person{
		public String BenefitOption;
		public String Cover;
		public String Loadings;
		public String Premium;
		public String Relationship;
		public Benefit Benefit;
		public Benefits Benefits;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Spouses{
		public Dependent[] Dependent;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class UnderwritingItems{
		public UnderwritingItem[] UnderwritingItem;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class UnderwritingItem{
		public String GUID;
		public String ID;
		public String Value;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class Flags{
		public KeyValueOfstringstring[] KeyValueOfstringstring;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public class KeyValueOfstringstring{
		public String Key;
		public String Value;
	}
	/**
	 * @description DeleteBenefit Description
	 *
	 */
	public abstract class Person{
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