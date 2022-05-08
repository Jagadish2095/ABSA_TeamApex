public class CCApplicationService_CltUpdate_Req_IB_v1 extends Base_IB {

     public Apply apply {get;set;} 
	
    public class CellPhoneNumber {
		public String areaCode {get;set;} 
		public String countryCode {get;set;} 
		public String extension {get;set;} 
		public String number_Z {get;set;} // in json: number
	}
	
	public class CasaInformation {
		public String countryOfResidence {get;set;} 
		public String nationality {get;set;} 
	}
	
	public class FamilyStatus {
		public String maritalStatus {get;set;} 
		public String numberOfDependents {get;set;} 
	}
	
	public class HomeTelephoneNumber {
		public String areaCode {get;set;} 
		public String number_Z {get;set;} // in json: number
	}
	
	public class Arg0 {
		public Application application {get;set;} 
		public RequestCommons requestCommons {get;set;} 
		public String validateDetails {get;set;} 

	
	}
	
	public class ExternalConsumerData {
		public String customerId {get;set;} 
		public String customerSourceCode {get;set;} 
		public String customerSourceReferenceNumber {get;set;} 
	}
	
	public class Apply {
		public Arg0 arg0 {get;set;} 
	}
	
	public class PrimaryApplicant {
		public String customerType {get;set;} 
		public String emailAddress {get;set;} 
		public FamilyStatus familyStatus {get;set;} 
		public String gender {get;set;} 
		public String communicationLanguage {get;set;} 
		public String homeLanguage {get;set;} 
		public String countryOfBirth {get;set;} 
		public String electronicStatementDeliveryAllowed {get;set;} 
		public String electronicStatementEmailAddress1 {get;set;} 
		public String preferredCommunicationChannel {get;set;} 
		public HomeTelephoneNumber homeTelephoneNumber {get;set;} 
		public ResidentialAddress residentialAddress {get;set;} 
		public ResidentialAddress postalAddress {get;set;} 
		public NextOfKin nextOfKin {get;set;} 
		public CasaInformation casaInformation {get;set;} 	
	}
	
	public class NextOfKin {
		public CellPhoneNumber cellPhoneNumber {get;set;} 
		public String emailAddress {get;set;} 
		public String fullNames {get;set;} 
		public String relationship {get;set;} 
		public String surname {get;set;} 
		public String workTelephoneNumber {get;set;} 
	}
	
	public class RequestCommons {
		public String channelCode {get;set;} 
		public String employeeNumber {get;set;} 
		public String messageLanguage {get;set;} 
		public String siteId {get;set;} 
		public String systemName {get;set;} 
		public String userId {get;set;} 
	}
	
	public class ResidentialAddress {
		public String addressLine1 {get;set;} 
		public String addressLine2 {get;set;} 
		public String city {get;set;} 
		public String country {get;set;} 
		public String postalCode {get;set;} 
		public String suburb {get;set;} 
	}
	
	public class Application {
		public String applicationNumber {get;set;} 
		public String applicationType {get;set;} 
		public String campaignId {get;set;} 
		public String channelCode {get;set;} 
		public String corpCode {get;set;} 
		public String creditStatus {get;set;} 		
		public ExternalConsumerData externalConsumerData {get;set;} 
		public String marketingSiteId {get;set;} 
		public String productGroupId {get;set;} 
		public String packageId {get;set;} 
		public String pricingSchemeCode {get;set;} 
		public StatementDeliveryMethodSelected statementDeliveryMethodSelected {get;set;} 
		public String statusGroup {get;set;} 
		public String transactionType {get;set;} 
		public PrimaryApplicant primaryApplicant {get;set;} 	
	}
	public class StatementDeliveryMethodSelected{
		public String code {get;set;} 	
		public String description {get;set;} 	
	}

   public static CCApplicationService_CltUpdate_Req_IB_v1 getNewInstance()
   {
        CCApplicationService_CltUpdate_Req_IB_v1 requestBean =  new CCApplicationService_CltUpdate_Req_IB_v1();
        requestBean.apply = new CCApplicationService_CltUpdate_Req_IB_v1.apply();
        requestBean.apply.arg0 = new CCApplicationService_CltUpdate_Req_IB_v1.Arg0();
        requestBean.apply.arg0.application = new CCApplicationService_CltUpdate_Req_IB_v1.Application();
        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_CltUpdate_Req_IB_v1.ExternalConsumerData();
        requestBean.apply.arg0.application.statementDeliveryMethodSelected = new CCApplicationService_CltUpdate_Req_IB_v1.StatementDeliveryMethodSelected();
        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_CltUpdate_Req_IB_v1.PrimaryApplicant();
        requestBean.apply.arg0.application.primaryApplicant.familyStatus = new CCApplicationService_CltUpdate_Req_IB_v1.FamilyStatus();
        requestBean.apply.arg0.application.primaryApplicant.homeTelephoneNumber = new CCApplicationService_CltUpdate_Req_IB_v1.HomeTelephoneNumber();
		requestBean.apply.arg0.application.primaryApplicant.residentialAddress = new CCApplicationService_CltUpdate_Req_IB_v1.ResidentialAddress();
        requestBean.apply.arg0.application.primaryApplicant.postalAddress = new CCApplicationService_CltUpdate_Req_IB_v1.ResidentialAddress();
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin = new CCApplicationService_CltUpdate_Req_IB_v1.NextOfKin();
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.cellPhoneNumber = new CCApplicationService_CltUpdate_Req_IB_v1.CellPhoneNumber();
        requestBean.apply.arg0.application.primaryApplicant.casaInformation = new CCApplicationService_CltUpdate_Req_IB_v1.CasaInformation();
        requestBean.apply.arg0.requestCommons = new CCApplicationService_CltUpdate_Req_IB_v1.RequestCommons();   
		return requestBean;
   }

   public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"number_Z":');        
	}
   
   public override void setIntegrationTranslations()
   {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.preferredCommunicationChannel','CIFCodesList;Prefcomms' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.countryOfBirth','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.casaInformation.nationality','CIFCodesList;Nationality' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.casaInformation.countryOfResidence','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.communicationLanguage','CIFCodesList;Lang' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.homeLanguage','CIFCodesList;Lang' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.gender','CIFCodesList;Gender' ); 
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.identificationType','CIFCodesList;Idtype' ); 
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.familyStatus.maritalStatus','CIFCodesList;Maritstat' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.familyStatus.maritalContractType','CIFCodesList;Marrcontype' ); 
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.nextOfKin.relationship','CIFCodesList;Nextofkinrelationship' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.postalAddress.country','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.residentialAddress.country','CIFCodesList;Casa Country' );
   }

   public static CCApplicationService_CltUpdate_Req_IB_v1 createDummyRequest(){
	CCApplicationService_CltUpdate_Req_IB_v1 requestBean = CCApplicationService_CltUpdate_Req_IB_v1.getNewInstance();
		
		requestBean.apply.arg0.application.marketingSiteId = '4592';
        requestBean.apply.arg0.application.creditStatus = '';
         
        requestBean.apply.arg0.validateDetails ='true';
        requestBean.apply.arg0.application.applicationNumber = '';
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.campaignId = '';	
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';

        requestBean.apply.arg0.application.productGroupId = '1';        
        requestBean.apply.arg0.application.transactionType = '';
		
		requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';

		requestBean.apply.arg0.application.packageId = '';
        requestBean.apply.arg0.application.pricingSchemeCode = '';

        requestBean.apply.arg0.application.externalConsumerData.customerId = '';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = '';

        requestBean.apply.arg0.application.statementDeliveryMethodSelected.code = 'EML';
        requestBean.apply.arg0.application.statementDeliveryMethodSelected.description = 'eMail';
       
        requestBean.apply.arg0.application.primaryApplicant.customerType = '001';
        requestBean.apply.arg0.application.primaryApplicant.gender = '';
        requestBean.apply.arg0.application.primaryApplicant.countryOfBirth = '';
        requestBean.apply.arg0.application.primaryApplicant.homeLanguage = '';
        requestBean.apply.arg0.application.primaryApplicant.familyStatus.maritalStatus = '';
        requestBean.apply.arg0.application.primaryApplicant.emailAddress = '';
        requestBean.apply.arg0.application.primaryApplicant.communicationLanguage = '';
        requestBean.apply.arg0.application.primaryApplicant.preferredCommunicationChannel = '';

        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.fullNames = '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.surname = '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.relationship = '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.cellPhoneNumber.number_Z = '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.emailAddress = '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.relationship =  '';
        
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.countryOfResidence =  '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.nationality = '';
       
       	requestBean.apply.arg0.application.primaryApplicant.residentialAddress.addressLine1 = '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.addressLine2 = '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.suburb = '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.city = '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.postalCode = '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.country = '';
		
       	requestBean.apply.arg0.application.primaryApplicant.postalAddress.addressLine1 = '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.addressLine2 = '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.suburb = '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.city = '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.postalCode = '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.country = '';
       
		requestBean.apply.arg0.requestCommons.channelCode = 'B';
		requestBean.apply.arg0.requestCommons.employeeNumber = '9019050';
		requestBean.apply.arg0.requestCommons.messageLanguage ='E';
		requestBean.apply.arg0.requestCommons.siteId = '4592';
		requestBean.apply.arg0.requestCommons.systemName = 'BSF';
		requestBean.apply.arg0.requestCommons.userId ='ABAJ013';

		requestBean.apply.arg0.validateDetails ='true';

		return requestBean;
	}
}