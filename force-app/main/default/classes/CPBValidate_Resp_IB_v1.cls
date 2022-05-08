/**
 * @description Response Integration Bean for CPBValidate Service
 * @author Prashant Jain
 * @created 2020-02-06
 * @modified by Jason Q
 */

public class CPBValidate_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;
	@AuraEnabled
	public String responseStatusCode;
	@AuraEnabled
	public String responseStatusDescription;

	@AuraEnabled
	public SearchInformation SearchInformation;

	/**
	 * @description inner class
	 */
	public class SearchInformation {
		@AuraEnabled
		public String SearchUserName;
		@AuraEnabled
		public String ReportDate;
		@AuraEnabled
		public String Reference;
		@AuraEnabled
		public String SearchToken;
		@AuraEnabled
		public String SearchTypeDescription;
		@AuraEnabled
		public String SearchDescription;
		@AuraEnabled
		public String CallerModule;
		@AuraEnabled
		public String SearchID;
		@AuraEnabled
		public String DataSupplier;
		@AuraEnabled
		public String SearchType;
		@AuraEnabled
		public String ExtendedSections;
		@AuraEnabled
		public String ResponseType;
		@AuraEnabled
		public String ResponseObjectType;
	}

	@AuraEnabled
	public Person Person;

	/**
	 * @description inner class
	 */
	public class Person {
		@AuraEnabled
		public PersonInformation PersonInformation;
		@AuraEnabled
		public ContactInformation ContactInformation;
		@AuraEnabled
		public FinancialInformation FinancialInformation;
		@AuraEnabled
		public AddressInformation AddressInformation;
	}

	/**
	 * @description inner class
	 */
	public class PersonInformation {
		@AuraEnabled
		public String PersonID;
		@AuraEnabled
		public String Title;
		@AuraEnabled
		public String DateOfBirth;
		@AuraEnabled
		public String Initials;
		@AuraEnabled
		public String FirstName;
		@AuraEnabled
		public String Surname;
		@AuraEnabled
		public String IDNumber;
		@AuraEnabled
		public String PassportNumber;
		@AuraEnabled
		public String MaritalStatus;
		@AuraEnabled
		public String Gender;
		@AuraEnabled
		public String MiddleName1;
		@AuraEnabled
		public String MiddleName2;
		@AuraEnabled
		public String MiddleName3;
		@AuraEnabled
		public String Reference;
		@AuraEnabled
		public String DeceasedStatus;
		@AuraEnabled
		public String DeceasedDate;
		@AuraEnabled
		public String CurrentEmployer;
		@AuraEnabled
		public String HasPostMatricQual;
		@AuraEnabled
		public String WhatQual;
	}

	/**
	 * @description inner class
	 */
	public class ContactInformation {
		@AuraEnabled
		public String EmailAddress;
		@AuraEnabled
		public String MobileNumber;
		@AuraEnabled
		public String HomeTelephoneNumber;
		@AuraEnabled
		public String WorkTelephoneNumber;
		@AuraEnabled
		public String FaxNumber;
	}

	/**
	 * @description inner class
	 */
	public class FinancialInformation {
		@AuraEnabled
		public String EverInsolvent;
		@AuraEnabled
		public String IncomeBracket;
	}

	/**
	 * @description inner class
	 */
	public class AddressInformation {
		@AuraEnabled
		public ResidentialAddress ResidentialAddress;
		@AuraEnabled
		public PostalAddress PostalAddress;
	}

	/**
	 * @description inner class
	 */
	public class ResidentialAddress {
		@AuraEnabled
		public String FirstReportedDate;
		@AuraEnabled
		public String AddCert;
		@AuraEnabled
		public String AddressID;
		@AuraEnabled
		public String TypeDescription;
		@AuraEnabled
		public String TypeCode;
		@AuraEnabled
		public String Line1;
		@AuraEnabled
		public String Line2;
		@AuraEnabled
		public String Line3;
		@AuraEnabled
		public String Line4;
		@AuraEnabled
		public String PostalCode;
		@AuraEnabled
		public String FullAddress;
		@AuraEnabled
		public String LastUpdatedDate;
	}

	/**
	 * @description inner class
	 */
	public class PostalAddress {
		@AuraEnabled
		public String AddressID;
		@AuraEnabled
		public String TypeDescription;
		@AuraEnabled
		public String TypeCode;
		@AuraEnabled
		public String Line1;
		@AuraEnabled
		public String Line2;
		@AuraEnabled
		public String Line3;
		@AuraEnabled
		public String Line4;
		@AuraEnabled
		public String PostalCode;
		@AuraEnabled
		public String FullAddress;
		@AuraEnabled
		public String LastUpdatedDate;
	}
}