/*
 * Request Integration Bean for MatchTerminationInquiry Service
 * @author Prashant Jain
 * @created 2020-05-22
 */

public class MatchTerminationInquiry_Req_IB_v1 extends Base_IB {

	public class UrlGroup {
		public List<ExactMatchUrls> ExactMatchUrls;
		public List<ExactMatchUrls> CloseMatchUrls;
		public ExactMatchUrls NoMatchUrls;
	}

	public TerminationInquiryRequest TerminationInquiryRequest;

	public class Address {
		public String Line1;
		public String Line2;
		public String City;
		public String CountrySubdivision;
		public String Province;
		public String PostalCode;
		public String Country;
	}

	public class Merchant {
		public String Name;
		public String DoingBusinessAsName;
		public Address Address;
		public String PhoneNumber;
		public String AltPhoneNumber;
		public String NationalTaxId;
		public String CountrySubdivisionTaxId;
		public String ServiceProvLegal;
		public String ServiceProvDBA;
		public String Url;
		public List<Principal> Principal;
		public SearchCriteria SearchCriteria;
		public String AddedOnDate;
		public String TerminationReasonCode;
		public String AddedByAcquirerID;
		public List<UrlGroup> UrlGroup;
	}

	public class TerminationInquiryRequest {
		public String AcquirerId;
		public String TransactionReferenceNumber;
		public Merchant Merchant;
	}

	public class DriversLicense {
		public String Number_Z; // in json: Number
		public String CountrySubdivision;
		public String Country;
	}

	public class ExactMatchUrls {
		public List<String> Url;
	}

	public class SearchCriteria {
		public String SearchAll;
		public List<String> Region;
		public List<String> Country;
		public String MinPossibleMatchCount;
	}

	public class Principal {
		public String FirstName;
		public String MiddleInitial;
		public String LastName;
		public Address Address;
		public String PhoneNumber;
		public String AltPhoneNumber;
		public String NationalId;
		public DriversLicense DriversLicense;
		public SearchCriteria SearchCriteria;
	}

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"Number":', '"Number_Z":');
    }

    public static MatchTerminationInquiry_Req_IB_v1 createDummyRequest() {
		MatchTerminationInquiry_Req_IB_v1 requestBean = new MatchTerminationInquiry_Req_IB_v1();
		requestBean.TerminationInquiryRequest = new MatchTerminationInquiry_Req_IB_v1.TerminationInquiryRequest();
		requestBean.TerminationInquiryRequest.Merchant = new MatchTerminationInquiry_Req_IB_v1.Merchant();
		requestBean.TerminationInquiryRequest.Merchant.Address = new MatchTerminationInquiry_Req_IB_v1.Address();
		requestBean.TerminationInquiryRequest.Merchant.Principal = new List<MatchTerminationInquiry_Req_IB_v1.Principal>();
		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria = new MatchTerminationInquiry_Req_IB_v1.SearchCriteria();
		requestBean.TerminationInquiryRequest.Merchant.UrlGroup = new List<MatchTerminationInquiry_Req_IB_v1.UrlGroup>();
		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Region = new List<String>();
		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Country = new List<String>();

		requestBean.TerminationInquiryRequest.AcquirerId = '1996';
		requestBean.TerminationInquiryRequest.TransactionReferenceNumber = '12345';

		requestBean.TerminationInquiryRequest.Merchant.Name = 'THE BAIT SHOP';
		requestBean.TerminationInquiryRequest.Merchant.DoingBusinessAsName = 'BAIT R US';
		requestBean.TerminationInquiryRequest.Merchant.PhoneNumber = '3165557625';
		requestBean.TerminationInquiryRequest.Merchant.AltPhoneNumber = '3165557625';
		requestBean.TerminationInquiryRequest.Merchant.NationalTaxId = '888596927';
		requestBean.TerminationInquiryRequest.Merchant.CountrySubdivisionTaxId = '492321030';
		requestBean.TerminationInquiryRequest.Merchant.ServiceProvLegal = 'XYZ FINANCIAL SERVICE INCORPORATED';
		requestBean.TerminationInquiryRequest.Merchant.ServiceProvDBA = 'XYZ FINANCIAL SERVICE';
		requestBean.TerminationInquiryRequest.Merchant.Url = 'WWW.TESTMERCHANT.COM';
		requestBean.TerminationInquiryRequest.Merchant.AddedOnDate = '10/13/2015';
		requestBean.TerminationInquiryRequest.Merchant.TerminationReasonCode = '13';
		requestBean.TerminationInquiryRequest.Merchant.AddedByAcquirerID = '1234';

		requestBean.TerminationInquiryRequest.Merchant.Address.Line1 = '42 ELM AVENUE';
		requestBean.TerminationInquiryRequest.Merchant.Address.Line2 = 'SUITE 201';
		requestBean.TerminationInquiryRequest.Merchant.Address.City = 'DALLAS';
		requestBean.TerminationInquiryRequest.Merchant.Address.CountrySubdivision = 'IL';
		requestBean.TerminationInquiryRequest.Merchant.Address.Province = '';
		requestBean.TerminationInquiryRequest.Merchant.Address.PostalCode = '66579';
		requestBean.TerminationInquiryRequest.Merchant.Address.Country = 'USA';

		MatchTerminationInquiry_Req_IB_v1.Principal newPrincipal = new MatchTerminationInquiry_Req_IB_v1.Principal();
		newPrincipal.FirstName = 'DAVID';
		newPrincipal.MiddleInitial = 'P';
		newPrincipal.LastName = 'SMITH';
		newPrincipal.PhoneNumber = '3165557625';
		newPrincipal.AltPhoneNumber = '3165557625';
		newPrincipal.NationalId = '541022104';

		newPrincipal.Address = new MatchTerminationInquiry_Req_IB_v1.Address();
		newPrincipal.Address.Line1 = '42 ELM AVENUE';
		newPrincipal.Address.Line2 = 'SUITE 201';
		newPrincipal.Address.City = 'DALLAS';
		newPrincipal.Address.CountrySubdivision = 'IL';
		newPrincipal.Address.Province = '';
		newPrincipal.Address.PostalCode = '66579';
		newPrincipal.Address.Country = 'USA';

		newPrincipal.DriversLicense = new MatchTerminationInquiry_Req_IB_v1.DriversLicense();
		newPrincipal.DriversLicense.Number_Z = 'M15698025';
		newPrincipal.DriversLicense.CountrySubdivision = 'IL';
		newPrincipal.DriversLicense.Country = 'USA';

		newPrincipal.SearchCriteria = new MatchTerminationInquiry_Req_IB_v1.SearchCriteria();
		newPrincipal.SearchCriteria.SearchAll = 'N';
		newPrincipal.SearchCriteria.MinPossibleMatchCount = '3';
		newPrincipal.SearchCriteria.Region = new List<String>();
		newPrincipal.SearchCriteria.Country = new List<String>();
		newPrincipal.SearchCriteria.Region.add('A');
		newPrincipal.SearchCriteria.Country.add('USA');

		requestBean.TerminationInquiryRequest.Merchant.Principal.add(newPrincipal);

		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.SearchAll = 'N';
		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.MinPossibleMatchCount = '3';
		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Region.add('A');
		requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Country.add('USA');

		MatchTerminationInquiry_Req_IB_v1.UrlGroup newUrlGroup = new MatchTerminationInquiry_Req_IB_v1.UrlGroup();
		newUrlGroup.NoMatchUrls = new MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls();
		newUrlGroup.NoMatchUrls.Url = new List<String>();
		newUrlGroup.ExactMatchUrls = new List<MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls>();
		newUrlGroup.CloseMatchUrls = new List<MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls>();

		newUrlGroup.NoMatchUrls.Url.add('WWW.SHOESHOP.COM');

		MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls newExactMatchUrl = new MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls();
		newExactMatchUrl.Url = new List<String>();
		newExactMatchUrl.Url.add('WWW.SHOESHOP.COM');
		newUrlGroup.ExactMatchUrls.add(newExactMatchUrl);

		newExactMatchUrl = new MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls();
		newExactMatchUrl.Url = new List<String>();
		newExactMatchUrl.Url.add('WWW.SHOESHOP.COM');
		newUrlGroup.CloseMatchUrls.add(newExactMatchUrl);

		requestBean.TerminationInquiryRequest.Merchant.UrlGroup.add(newUrlGroup);

        return requestBean;
    }
}