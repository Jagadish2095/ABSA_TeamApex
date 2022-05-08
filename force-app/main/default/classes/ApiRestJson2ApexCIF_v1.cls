/**
* Test class for ClientFinderCIF
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-08-14
*
**/
public class ApiRestJson2ApexCIF_v1 {
    
	//public cls_meta meta {get;set;}
	public cls_individual individual {get;set;}
	public cls_customerDetails customerDetails {get;set;}
	public cls_location location {get;set;}
	public cls_contact contact {get;set;}
	//public cls_corporateEntity corporateEntity {get;set;}
	//public cls_identifications[] identifications {get;set;}
    public cls_individualId individualId {get;set;}
	public cls_links links {get;set;}
    //public cls_groupScheme groupScheme {get;set;}
    public cls_communicationChannelType communicationChannelType {get;set;}
    public cls_physicalAddress physicalAddress {get;set;}
    public cls_postalAddress postalAddress {get;set;}
    public cls_businessAddress businessAddress {get;set;}
    public cls_headOfficeAddress headOfficeAddress {get;set;}
    

	/*class cls_meta {
		public cls_queryResult queryResult {get;set;}
	}
	class cls_queryResult {
		public String type {get;set;}
		public String sourceSystem {get;set;}
	}*/
	public class cls_individual {
        
		public cls_givenName givenName {get;set;}
		public cls_nameInitials nameInitials {get;set;}
		public cls_surname surname {get;set;}
		public cls_salutationType salutationType {get;set;}
		//public cls_countryPassport countryPassport {get;set;}
		//public cls_countryOfBirth countryOfBirth {get;set;}
		//public cls_gender gender {get;set;}
		//public cls_nationality nationality {get;set;}
		//public cls_employmentStatusType employmentStatusType {get;set;}
        
	}
	public class cls_givenName {
        public String value {get;set;}
	}
	public class cls_nameInitials {
		public String value {get;set;}
	}
	public class cls_surname {
		public String value {get;set;}
	}
	public class cls_salutationType {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	public class cls_code {
		public String value {get;set;}
	}
	public class cls_description {
        public String value {get;set;}
	}
	class cls_value {
	}
	/*class cls_countryPassport {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_countryOfBirth {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_gender {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_nationality {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_employmentStatusType {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}*/
	public class cls_customerDetails {
		public cls_identificationTypeId identificationTypeId {get;set;}
		public cls_individualId individualId {get;set;}
		/*public cls_universalResourceLocator universalResourceLocator {get;set;}
		public cls_customerType customerType {get;set;}
		public cls_groupScheme groupScheme {get;set;}
		public cls_sourceOfFundsCode sourceOfFundsCode {get;set;}
		public cls_sourceOfIncomeCode sourceOfIncomeCode {get;set;}
		public cls_corporateDivision corporateDivision {get;set;}
		public cls_inLiquidation inLiquidation {get;set;}
		public cls_underJudicialManagement underJudicialManagement {get;set;}
		public cls_financialCrime financialCrime {get;set;}
		public cls_NCAThreshold NCAThreshold {get;set;}
		public cls_CPAThreshold CPAThreshold {get;set;}
		public cls_sbuSegment sbuSegment {get;set;}
		public cls_inBusinessRescue inBusinessRescue {get;set;}
		public cls_inBusinessRescueAffectedParty inBusinessRescueAffectedParty {get;set;}
		public cls_placedInBusinessRescueBy placedInBusinessRescueBy {get;set;}
		public cls_forensicHold forensicHold {get;set;}*/
		public cls_businessRescueIssueDate businessRescueIssueDate {get;set;}
	}
	class cls_identificationTypeId {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	public class cls_individualId {
		public String value {get;set;}
	}
	/*class cls_universalResourceLocator {
		public String value {get;set;}
	}
	class cls_customerType {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	public class cls_groupScheme {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_sourceOfFundsCode {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_sourceOfIncomeCode {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_corporateDivision {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_inLiquidation {
		public String value {get;set;}
	}
	class cls_underJudicialManagement {
		public String value {get;set;}
	}
	class cls_financialCrime {
		public String value {get;set;}
	}
	class cls_NCAThreshold {
		public String value {get;set;}
	}
	class cls_CPAThreshold {
		public String value {get;set;}
	}
	class cls_sbuSegment {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_inBusinessRescue {
		public String value {get;set;}
	}
	class cls_inBusinessRescueAffectedParty {
		public String value {get;set;}
	}
	class cls_placedInBusinessRescueBy {
		public String value {get;set;}
	}
	class cls_forensicHold {
		public String value {get;set;}
	}*/
	class cls_businessRescueIssueDate {
	}
	public class cls_location {
		public cls_physicalAddress physicalAddress {get;set;}
		public cls_postalAddress postalAddress {get;set;}
		public cls_businessAddress businessAddress {get;set;}
		public cls_headOfficeAddress headOfficeAddress {get;set;}
	}
	public class cls_physicalAddress {
		public cls_addressName1 addressName1 {get;set;}
		public cls_addressName2 addressName2 {get;set;}
		public cls_suburbName suburbName {get;set;}
		public cls_cityName cityName {get;set;}
		public cls_postCodeArea postCodeArea {get;set;}
	}
	public class cls_addressName1 {
		public String value {get;set;}
	}
	public class cls_addressName2 {
		public String value {get;set;}
	}
	public class cls_suburbName {
		public String value {get;set;}
	}
	public class cls_cityName {
		public String value {get;set;}
	}
	public class cls_postCodeArea {
		public String value {get;set;}
	}
	public class cls_postalAddress {
		public cls_addressName1 addressName1 {get;set;}
		public cls_addressName2 addressName2 {get;set;}
		public cls_suburbName suburbName {get;set;}
		public cls_cityName cityName {get;set;}
		public cls_postCodeArea postCodeArea {get;set;}
		public cls_addressTypeCode addressTypeCode {get;set;}
	}
	public class cls_addressTypeCode {
		public String value {get;set;}
	}
	public class cls_businessAddress {
		public cls_addressName1 addressName1 {get;set;}
		public cls_addressName2 addressName2 {get;set;}
		public cls_suburbName suburbName {get;set;}
		public cls_cityName cityName {get;set;}
		public cls_postCodeArea postCodeArea {get;set;}
		public cls_addressType addressType {get;set;}
	}
	public class cls_addressType {
		public String value {get;set;}
	}
	public class cls_headOfficeAddress {
		public cls_addressName1 addressName1 {get;set;}
		public cls_addressName2 addressName2 {get;set;}
		public cls_suburbName suburbName {get;set;}
		public cls_cityName cityName {get;set;}
		public cls_postCodeArea postCodeArea {get;set;}
		public cls_addressType addressType {get;set;}
	}
	public class cls_contact {
		public cls_cellPhoneNumber cellPhoneNumber {get;set;}
		public cls_communicationChannelType communicationChannelType {get;set;}
		public cls_workPhone workPhone {get;set;}
		public cls_homePhone homePhone {get;set;}
		public cls_eMailUserId eMailUserId {get;set;}
		//public cls_contactPerson contactPerson {get;set;}
		//public cls_designation designation {get;set;}
	}
	public class cls_cellPhoneNumber {
		public String value {get;set;}
	}
	public class cls_communicationChannelType {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	public class cls_workPhone {
		public String value {get;set;}
	}
	public class cls_homePhone {
		public String value {get;set;}
	}
	public class cls_eMailUserId {
		public String value {get;set;}
	}
	/*public class cls_contactPerson {
		public String value {get;set;}
	}
	class cls_designation {
		public String value {get;set;}
	}
	class cls_corporateEntity {
		public cls_incorporatedCountry incorporatedCountry {get;set;}
		public cls_standardIndustryCode standardIndustryCode {get;set;}
	}
	class cls_incorporatedCountry {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	class cls_standardIndustryCode {
		public cls_code code {get;set;}
		public cls_description description {get;set;}
	}
	public class cls_identifications {
		public cls_type type;
		public String cifnumber {get;set;}
		public boolean personalIdentificationFlag {get;set;}
		public boolean systemIdentificationFlag {get;set;}
		public String issueDate {get;set;}
		public String expiryDate {get;set;}	
		public cls_country country {get;set;}
	}
	class cls_type {
		public String code {get;set;}
		public cls_description description {get;set;}
	}*/
	class cls_country {
	}
	class cls_links {
	}
	public static ApiRestJson2ApexCIF_v1 parse(String json){
		return (ApiRestJson2ApexCIF_v1) System.JSON.deserialize(json, ApiRestJson2ApexCIF_v1.class);
	}
}