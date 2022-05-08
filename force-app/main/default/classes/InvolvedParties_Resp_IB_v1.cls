/**
 * @description Response Integration Bean for InvolvedPartiesv1 Service
 * @author Humbelani Denge
 * @created 2021-06-16
 */
public class InvolvedParties_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;
	/**
	 * @description Errors Child class
	 */
	public class Errors {
		@AuraEnabled
		public String code;
		@AuraEnabled
		public String description;
	}

	@AuraEnabled
	public String code;
	@AuraEnabled
	public String description;
	@AuraEnabled
	public List<Errors> errors;
	/**
	 * @description Addresses_Z Child class
	 */
	public class Addresses_Z {
		@AuraEnabled
		public List<Addresses> addresses;
		@AuraEnabled
		public List<ElectronicAddresses> electronicAddresses;
	}
	/**
	 * @description Countries Child class
	 */
	public class Countries {
		@AuraEnabled
		public String name;
		@AuraEnabled
		public clsType type;
		@AuraEnabled
		public Type context;
	}
	/**
	 * @description ElectronicAddresses Child class
	 */
	public class ElectronicAddresses {
		@AuraEnabled
		public String address;
		@AuraEnabled
		public Type context;
		@AuraEnabled
		public clsType type;
		@AuraEnabled
		public Type subType;
	}
	/**
	 * @description Flags Child class
	 */
	public class Flags {
		@AuraEnabled
		public String effectiveDate;
		@AuraEnabled
		public Boolean yesNoFlag;
		@AuraEnabled
		public clsType type;
		@AuraEnabled
		public String status;
		@AuraEnabled
		public Type category;
		@AuraEnabled
		public Boolean isOperationalFlag;
		@AuraEnabled
		public String created;
		@AuraEnabled
		public String updated;
		@AuraEnabled
		public String reason;
		@AuraEnabled
		public String lastUpdatedExternalSystem;
	}
	/**
	 * @description Addresses Child class
	 */
	public class Addresses {
		@AuraEnabled
		public String addressName1;
		@AuraEnabled
		public String addressName2;
		@AuraEnabled
		public String suburbName;
		@AuraEnabled
		public String cityName;
		@AuraEnabled
		public String state;
		@AuraEnabled
		public String countryName;
		@AuraEnabled
		public String postalCode;
		@AuraEnabled
		public Type context;
		@AuraEnabled
		public Boolean primaryFlag;
		@AuraEnabled
		public Boolean activeFlag;
		@AuraEnabled
		public clsType type;
	}
	/**
	 * @description clsType Child class
	 */
	public class clsType {
		@AuraEnabled
		public String code;
		@AuraEnabled
		public String description;
	}
	/**
	 * @description Relationships Child class
	 */
	public class Relationships {
		@AuraEnabled
		public clsType type;
		@AuraEnabled
		public String suin;
		@AuraEnabled
		public String internalIdType;
		@AuraEnabled
		public String internalIdValue;
		@AuraEnabled
		public String relatedPartyType;
		@AuraEnabled
		public String relatedPartyName;
		@AuraEnabled
		public Type role;
		@AuraEnabled
		public String percentage;
		@AuraEnabled
		public String relatedPartySourceSystem;
		@AuraEnabled
		public Type status;
		@AuraEnabled
		public String created;
		@AuraEnabled
		public String updated;
	}
	/**
	 * @description FormalOrganisation Child class
	 */
	public class FormalOrganisation {
		@AuraEnabled
		public String registeredName;
		@AuraEnabled
		public String siteName;
		@AuraEnabled
		public String sarsLegalType;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public Type pepStatus;
		@AuraEnabled
		public Type subStatus;
		@AuraEnabled
		public Type status;
		@AuraEnabled
		public String ficaAddressUpdateDate;
		@AuraEnabled
		public String nextRefreshDate;
		@AuraEnabled
		public String identificationUpdateDate;
		@AuraEnabled
		public clsType type;
		@AuraEnabled
		public Type natureOfBusiness;
		@AuraEnabled
		public Type preferredLanguage;
		@AuraEnabled
		public String residentialStatus;
		@AuraEnabled
		public String trustDeedNumber;
		@AuraEnabled
		public String financialYearEnd;
	}
	/**
	 * @description Content Child class
	 */
	public class Content {
		@AuraEnabled
		public String suin;
		@AuraEnabled
		public PrimaryId primaryId;
		@AuraEnabled
		public String created;
		@AuraEnabled
		public String updated;
		@AuraEnabled
		public FormalOrganisation formalOrganisation;
		@AuraEnabled
		public List<Type> sourcesOfIncome;
		@AuraEnabled
		public List<Identifications> identifications;
		@AuraEnabled
		public Addresses_Z addresses;
		@AuraEnabled
		public List<Relationships> relationships;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String lastUpdatedExternalSystem;
	}
	/**
	 * @description Identifications Child class
	 */
	public class Identifications {
		@AuraEnabled
		public String number_Z; // in json: number
		@AuraEnabled
		public clsType type;
		@AuraEnabled
		public String lastUpdatedExternalSystem;
		@AuraEnabled
		public String category;
		@AuraEnabled
		public Boolean secondaryIdFlag;
		@AuraEnabled
		public String issuingCountry;
		@AuraEnabled
		public String attestationIndicator;
		@AuraEnabled
		public String created;
		@AuraEnabled
		public String updated;
	}
	/**
	 * @description Links Child class
	 */
	public class Links {
		@AuraEnabled
		public String rel;
		@AuraEnabled
		public String href;
	}
	/**
	 * @description PrimaryId Child class
	 */
	public class PrimaryId {
		@AuraEnabled
		public String number_Z; // in json: number
		@AuraEnabled
		public clsType type;
	}

	@AuraEnabled
	public Content content;
	@AuraEnabled
	public List<Links> links;

	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('Type', 'Type_cls');
	}
}