/*
 * Response Integration Bean for MatchTerminationInquiry Service
 * @author Prashant Jain
 * @created 2020-06-05
 */

public class MatchTerminationInquiry_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class TerminatedMerchant {
		public Merchant Merchant;
		public MerchantMatch MerchantMatch;
	}

	public Errors Errors;
	public TerminationInquiry TerminationInquiry;

	public class Address {
		public String Line1;
		public String Line2;
		public String City;
		public String PostalCode;
		public String Country;
	}

	public class Principal_Y {
		public String FirstName;
		public String LastName;
		public String NationalId;
		public String PhoneNumber;
		public String AltPhoneNumber;
		public Address Address;
		public DriversLicense DriversLicense;
	}

	public class Principal_Z {
		public String FirstName;
		public String LastName;
		public Address Address;
		public DriversLicense DriversLicense;
	}

	public class Error {
		public String Description;
		public String ReasonCode;
		public String Source;
		public Boolean Recoverable;
	}

	public class Merchant_Y {
		public String Name;
		public String PhoneNumber;
		public String AltPhoneNumber;
		public Address Address;
		public String NationalTaxId;
		public List<Principal_Y> Principal;
	}

	public class Merchant_Z {
		public String Name;
		public Address Address;
		public List<Principal_Z> Principal;
	}

	public class PrincipalMatch {
		public String Name;
		public String Address;
		public String PhoneNumber;
		public String AltPhoneNumber;
		public String NationalId;
		public String DriversLicense;
	}

	public class Errors {
		public Error Error_Z; // in json: Error
		public List<Error> Error;
	}

	public class TerminationInquiry {
		public Integer PageOffset;
		public String Ref;
		public String TransactionReferenceNumber;
		public List<PossibleMerchantMatches> PossibleMerchantMatches;
		public List<PossibleInquiryMatches> PossibleInquiryMatches;
	}

	public class Merchant {
		public String Name;
		public String AddedByAcquirerID;
		public String AddedOnDate;
		public String PhoneNumber;
		public Address Address;
		public List<Principal> Principal;
		public String TerminationReasonCode;
	}

	public class InquiredMerchant {
		public Merchant_Z Merchant;
		public MerchantMatch MerchantMatch;
	}

	public class PossibleInquiryMatches {
		public Integer TotalLength;
		public List<InquiredMerchant> InquiredMerchant;
	}

	public class MerchantMatch {
		public String Name;
		public String DoingBusinessAsName;
		public String Address;
		public String PhoneNumber;
		public String AltPhoneNumber;
		public String CountrySubdivisionTaxId;
		public String NationalTaxId;
		public String ServiceProvLegal;
		public String ServiceProvDBA;
		public List<PrincipalMatch> PrincipalMatch;
	}

	public class DriversLicense {
	}

	public class Principal {
		public String FirstName;
		public String LastName;
		public String PhoneNumber;
		public Address Address;
		public DriversLicense DriversLicense;
	}

	public class PossibleMerchantMatches {
		public Integer TotalLength;
		public List<TerminatedMerchant> TerminatedMerchant;
	}

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"Error":{', '"Error_Z":{');
    }
}