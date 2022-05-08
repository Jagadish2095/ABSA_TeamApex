/**
* @description Response Bean class for the ClientSearch
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 2021-08-13
*/
public class ClientSearch_Resp_IB_v1 extends Base_IB{
	/**
	* @description wrapper class Addresses
	*/
	public class Addresses {
		public List<DC2Address> DC2Address;
	}
	/**
	* @description wrapper class DC2Telephone
	*/
	public class DC2Telephone {
		public Object AreaCode;
		public String ClientGID;
		public Integer CommunicationTypeTelephoneID;
		public Object CountryCode;
		public Integer CreatedBy;
		public String CreatedDate;
		public String GID;
		public String TelLocal;
		public Integer UpdatedBy;
		public String UpdatedDate;
	}

	public Client_SearchResponse Client_SearchResponse;
	/**
	* @description wrapper class DC2Client
	*/
	public class DC2Client {
		public Addresses Addresses;
		public Integer CommunicationLanguageID;
		public Integer CountryOfBirthID;
		public Integer CreatedBy;
		public String CreatedDate;
		public String DateOfBirth;
		public Integer DrinkingID;
		public String Firstname;
		public String GID;
		public Integer GenderID;
		public Integer Height;
		public Integer HighestQualificationTypeID;
		public Integer HomeLanguageID;
		public Identifiers Identifiers;
		public Integer IncomeGroupID;
		public String Initials;
		public Object InsolventDate;
		public Object InsolventRehabDate;
		public Boolean IsBreadwinner;
		public Boolean IsHomeOwner;
		public Boolean IsLimitedAccess;
		public Boolean IsNew;
		public Integer MaritalStatusID;
		public Object MiddleName;
		public Integer NationalityID;
		public Object Nickname;
		public Integer NoOfDependants;
		public Integer OccupationID;
		public Object PlaceOfBirth;
		public Integer RetirementAge;
		public Integer SmokingID;
		public Integer SocioEconomicGroupID;
		public Integer StatusID;
		public String Surname;
		public String TaxNumber;
		public Object TaxOffice;
		public Integer TaxPercent;
		public Integer TaxTypeID;
		public Telephones Telephones;
		public String TitleDescription;
		public Integer TitleID;
		public Integer TypeID;
		public Integer UpdatedBy;
		public String UpdatedDate;
		public Integer Weight;
		public Integer YearsAtAddress;
	}
	/**
	* @description wrapper class Telephones
	*/
	public class Telephones {
		public List<DC2Telephone> DC2Telephone;
	}
	/**
	* @description wrapper class DC2Address
	*/
	public class DC2Address {
		public String Address;
		public Integer AddressAreaID;
		public String ClientGID;
		public Integer CommunicationTypeAddressID;
		public Integer CountryID;
		public Integer CreatedBy;
		public String CreatedDate;
		public String GID;
		public Integer StateProvinceID;
		public Integer UpdatedBy;
		public String UpdatedDate;
		public String Zip_PostalCode;
	}
	/**
	* @description wrapper class Client_SearchResult
	*/
	public class Client_SearchResult {
		public DC2Client DC2Client;
	}
	/**
	* @description wrapper class Client_SearchResponse
	*/
	public class Client_SearchResponse {
		public Client_SearchResult Client_SearchResult;
		public Object pstrValidationMessage;
	}
	/**
	* @description wrapper class Identifiers
	*/
	public class Identifiers {
		public List<DC2Identifier> DC2Identifier;
	}
	/**
	* @description wrapper class DC2Identifier
	*/
	public class DC2Identifier {
		public String ClientGID;
		public String Description;
		public String GID;
		public Integer IdentifierTypeID;
	}

}