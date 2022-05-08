/**
 * @description Integration Request for Marble create account Service
 * @author Haritha Police
 * @created 2021-04-19
 * @param integration service
 *  marble create account class
 */
public class SPMMarbleCreateAccount_Req_IB_V1 extends Base_IB{
    /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
   public class Entity {
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer entityID {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */  
       public String crmName {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer partnerID {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer entityTypeID {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer titleID {get;set;}
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer crmStatusID {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String firstName {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String middleName {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String initials {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String lastName {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public date dateOfBirth {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string takeOnDate {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String appelation {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String terminationDate {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String terminationReason {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String company {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String registrationNumber {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String incomeTaxNumber {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String vatNumber {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String nationality {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String addressLine1 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String addressLine2 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String addressLine3 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String addressLine4 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String addressLine5 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String contactNumber1 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String contactNumber2 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String faxNumber {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String cellphoneNumber {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String emailAddress {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String financialYearEndMonth {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String financialYearEndDay {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean sendStatementsViaEmail {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String externalSystemReference1 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String externalSystemReference2 {get;set;} 
       /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public CrmEntityCustomData crmEntityCustomData {get;set;} 

	}
	/**
     * @description Method that maps request parameters based on Opportunity Id
    */
	public Entity entity {get;set;} 
    /**
     * @description Method that maps request parameters based on Opportunity Id
    */
	public Beneficiary beneficiary {get;set;} 
    /**
     * @description Method that maps request parameters based on Opportunity Id
    */
	public List<MarbleAccountTypeList> marbleAccountTypeList {get;set;} 
    /**
     * @description Method that maps request parameters based on Opportunity Id
    */
	public Integer partnerID {get;set;} 
	 /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
	public class Fund {
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer fundID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String fundCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String fundName {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer fundReportingCurrencyID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer partnerID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string inceptionDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer defaultSectorTreeID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer defaultPerformanceTemplateiD {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer defaultRiskTemplateID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer defaultModelPortfolioID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String externalSystemReference1 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String externalSystemReference2 {get;set;} 

	}
     /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
	public class MarbleAccountTypeList {
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Fund fund {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public MarblePortfolio marblePortfolio {get;set;} 
	}
     /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
	public class MarblePortfolio {
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String portfolioCode {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String portfolioName {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioBaseCurrencyID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioCapitaliseBrokerage {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer glSetupID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean useGeneratedCorporateActions {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean isUnitisedPortfolio {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer customSectorTreeID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer performanceTemplateID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer riskTemplateID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer modelPortfolioTemplateID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string inceptionDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer yearEndMonth {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer defaultCustodianAccountID {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer fundID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer defaultAccountingTypeID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean useFIFOBVCalculation {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String dayEndTime {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String defaultTXTime {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean requiresMTM {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public boolean postMTMAmortisation {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public date requiresMTMFromDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean requiresSettlements {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string requiresSettlementsFromDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean requiresMargins {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String requiresMarginsFromDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean requiresCorporateActions {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string requiresCorporateActionsFromDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean requiresAccruals {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string requiresAccrualsFromDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioTypeID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioProductTypeID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer investmentObjectiveID {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer riskAppetiteID {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer feeScaleID {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer monthlyIncomeRequired {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean isActive {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioManagerID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioReportingGroupID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean liableForDividendWithholdingTax {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean liableForInterestWithholdingTax {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioAdministratorID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioAdvisorID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioIntroducerID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioSalesRepID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer dividendPayoutOptionID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer dividendPayoutPercentage {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularInvestmentFrequencyID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularInvestmentValue {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularInvestmentAnnualIncreaseRate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string regularInvestmentStartDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularInvestmentDayOfMonth {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularWithdrawalFrequencyID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularWithdrawalValue {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularWithdrawalPercentageOfMV {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string regularWithdrawalStartDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer regularWithdrawalDayOfMonth {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string performanceCalculationStartDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String deactivatedDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Boolean useHistoricPerformanceData {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string historicPerformanceDataStartDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public string historicPerformanceDataEndDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String externalSystemReference1 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String externalSystemReference2 {get;set;} 

	}
     /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
	public class CrmEntityCustomData {
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer entityID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String sex {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String languageCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String staffIndicatorAbsaGroup {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String staffIndicatorAbsaSPM {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String settlementTypeCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String nonResidentIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String exchangeControl {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String countryCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String principalAgentIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String electionIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String electronicReportIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String mandateRecieveDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String negotiatedBrokerageScale {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String electronicPaymentMandateDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String beeIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String beeExpiryDate {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String postalAddressCareOfAddressIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String addressCareOfName {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String clientRiskRating {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String shareholderPercentage {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String contactPerson {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String powerOffAttorney {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String refferedBy {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String portfolioManagementCHGCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String safeCustodyChargeCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String nameOFPOA {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String sourceOfIncome {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String reasonForNoTaxNumber {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String tfsaIndicator {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String email2 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String idType {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String idNumber {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String countryOfIssue {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String ppExpiryDate {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String countryOfBirth {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String countryOfResForDWT {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String taxResidency1 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String taxResidency2 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String taxResidency3 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String taxResidency4 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String taxResidency5 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String foreignTaxNumbers1 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String foreignTaxNumbers2 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String foreignTaxNumbers3 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String foreignTaxNumbers4 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String foreignTaxNumbers5 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String nationality1 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String sicCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String ficaCompliant {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String dateOfFICACompliant {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String sanctionsOnPoliticalPeron {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String dwtExemption {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String iT3BExcl {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String iT3CExcl {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String dwtFormAorB {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String dividendPassThrough {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String reportingAccount {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String financialInstitutionsGIIN {get;set;}
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String countryOfJurisdiction1 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String countryOfJurisdiction2 {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String advisorCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String pfadv {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String portfolioIntroducerID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String newsletter {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String newsletterPER {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public boolean liableForInterestWithholdingTax {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String type {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String entConsolidation {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String ermCheck {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String mancoCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String reitsExemption {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String brokerTrusteeFee {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String feeSharing {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String upfrontStructuringFee {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String dividendTaxProvisionPercentage {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String cgtProvisionPercentage {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String incomeTaxProvisionPercentage {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String incomeAccount {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String beneficiaryID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String beneficiaryName {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String recordofAdvice {get;set;} 

	}
     /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
	public class Beneficiary {
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public Integer portfolioID {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String beneficiaryName {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String accountType {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String accountName {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String accountNumber {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String branchCode {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String beneficiaryReference {get;set;} 
        /**
     * @description Method that maps request parameters based on Opportunity Id
    */
		public String currency_Z {get;set;} // in json: currency
		
	}
     /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
    */
   public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"currency":', '"currency_Z":');
    }
     /**
     * @description Method that maps request parameters based on Opportunity Id
     * @param
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
    public static SPMMarbleCreateAccount_Req_IB_V1 createDummyRequest(){
        SPMMarbleCreateAccount_Req_IB_V1 requestBean = new SPMMarbleCreateAccount_Req_IB_V1();
        requestBean.Entity=new SPMMarbleCreateAccount_Req_IB_V1.Entity();
        requestBean.Entity.crmEntityCustomData = new SPMMarbleCreateAccount_Req_IB_V1.CrmEntityCustomData();
        requestBean.Beneficiary=new SPMMarbleCreateAccount_Req_IB_V1.Beneficiary();
        requestBean.MarbleAccountTypeList =new list<SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList>();
    	SPMMarbleCreateAccount_Req_IB_V1.Fund accFund= new SPMMarbleCreateAccount_Req_IB_V1.Fund();
    	SPMMarbleCreateAccount_Req_IB_V1.MarblePortfolio accMarblePortfolio= new SPMMarbleCreateAccount_Req_IB_V1.MarblePortfolio();
    	SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList marblelistaccType= new SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList();
    	list<SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList> listmarbleacctype=new list<SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList>();
           accFund.fundID=0;
        accFund.fundName=null;
        accFund.fundReportingCurrencyID=1;
        accFund.partnerID=49;//still need confirmation
        accFund.inceptionDate=string.valueOf(system.today());
        accFund.defaultSectorTreeID=8;
        accFund.defaultPerformanceTemplateiD=1;
        accFund.defaultRiskTemplateID=1;
        accFund.defaultModelPortfolioID=1;
        accFund.externalSystemReference1='test1';
        accFund.externalSystemReference2='test2';
    
    	accMarblePortfolio.portfolioID=0;
       
		accMarblePortfolio.portfolioBaseCurrencyID=1;
		accMarblePortfolio.portfolioCapitaliseBrokerage=1; 
		accMarblePortfolio.glSetupID=1;
		accMarblePortfolio.useGeneratedCorporateActions=true; 
		accMarblePortfolio.isUnitisedPortfolio=true;
		accMarblePortfolio.customSectorTreeID=8;
		accMarblePortfolio.performanceTemplateID =1;
		accMarblePortfolio.riskTemplateID=1;
		accMarblePortfolio.modelPortfolioTemplateID=1;
		accMarblePortfolio.inceptionDate=string.valueOf(system.today());
		accMarblePortfolio.yearEndMonth=2;
		accMarblePortfolio.defaultCustodianAccountID=49;
		accMarblePortfolio.fundID =486462; //TBC
		accMarblePortfolio.defaultAccountingTypeID=1; 
		accMarblePortfolio.useFIFOBVCalculation=false;
		accMarblePortfolio.dayEndTime='23:59:00.0000000'; 
		accMarblePortfolio.defaultTXTime='12:00:00.0000000'; 
		accMarblePortfolio.requiresMTM=true; 
		accMarblePortfolio.postMTMAmortisation=null;//needs clarity
		accMarblePortfolio.requiresMTMFromDate=system.today(); 
		accMarblePortfolio.requiresSettlements=true;
		accMarblePortfolio.requiresSettlementsFromDate=string.valueOf(system.today());
		accMarblePortfolio.requiresMargins=false;
		accMarblePortfolio.requiresMarginsFromDate=null; 
		accMarblePortfolio.requiresCorporateActions=true; 
		accMarblePortfolio.requiresCorporateActionsFromDate =string.valueOf(system.today());
		accMarblePortfolio.requiresAccruals=true;
		accMarblePortfolio.requiresAccrualsFromDate=string.valueOf(system.today());
		accMarblePortfolio.portfolioTypeID =1; 
		accMarblePortfolio.portfolioProductTypeID =1;//needs translation
		accMarblePortfolio.investmentObjectiveID =7; 
		accMarblePortfolio.riskAppetiteID=1;
		accMarblePortfolio.feeScaleID =null;
		accMarblePortfolio.monthlyIncomeRequired=0; 
		accMarblePortfolio.isActive=true; 
		accMarblePortfolio.portfolioManagerID=1;
		accMarblePortfolio.portfolioReportingGroupID =365; 
		accMarblePortfolio.liableForDividendWithholdingTax=true;//TBC
		accMarblePortfolio.liableForInterestWithholdingTax=true;//TBC
		accMarblePortfolio.portfolioAdministratorID=4; 
		accMarblePortfolio.portfolioAdvisorID =1; 
		accMarblePortfolio.portfolioIntroducerID =1; 
		accMarblePortfolio.portfolioSalesRepID=1;
		accMarblePortfolio.dividendPayoutOptionID=1;
		accMarblePortfolio.dividendPayoutPercentage=0;
		accMarblePortfolio.regularInvestmentFrequencyID=1; 
		accMarblePortfolio.regularInvestmentValue=0; 
		accMarblePortfolio.regularInvestmentAnnualIncreaseRate=0;
		accMarblePortfolio.regularInvestmentStartDate=string.valueOf(system.today()); 
		accMarblePortfolio.regularInvestmentDayOfMonth =1;
		accMarblePortfolio.regularWithdrawalFrequencyID =1; 
		accMarblePortfolio.regularWithdrawalValue=0;
		accMarblePortfolio.regularWithdrawalPercentageOfMV=0;
		accMarblePortfolio.regularWithdrawalStartDate=string.valueOf(system.today()); 
		accMarblePortfolio.regularWithdrawalDayOfMonth =1;
		accMarblePortfolio.performanceCalculationStartDate=string.valueOf(system.today()); 
		accMarblePortfolio.deactivatedDate ='2100-12-31 12:00:00.000'; 
		accMarblePortfolio.useHistoricPerformanceData =true; //needs clarity
		accMarblePortfolio.historicPerformanceDataStartDate =string.valueOf(system.today()); 
		accMarblePortfolio.historicPerformanceDataEndDate =string.valueOf(system.today()); 
		accMarblePortfolio.externalSystemReference1='marbletest1';
		accMarblePortfolio.externalSystemReference2 ='marbletest2';
    	
    	marblelistaccType.fund=accFund;
    	marblelistaccType.marblePortfolio=accMarblePortfolio;
        requestBean.MarbleAccountTypeList.add(marblelistaccType);
        //listmarbleacctype.add(marblelistaccType);
    
        requestBean.Beneficiary.portfolioID=null;
    	
            requestBean.Beneficiary.accountType='Cheque';
            requestBean.Beneficiary.accountName='absa bank';
            requestBean.Beneficiary.accountNumber='1234567890';
            requestBean.Beneficiary.branchCode='123456';
        
        requestBean.Beneficiary.currency_Z='ZAR';
        requestBean.Beneficiary.portfolioID=0;
    	requestBean.Entity.crmEntityCustomData.entityID=0;
        requestBean.Entity.crmEntityCustomData.languageCode='E';
    	requestBean.Entity.crmEntityCustomData.staffIndicatorAbsaGroup='N';//new field
    	requestBean.Entity.crmEntityCustomData.staffIndicatorAbsaSPM='N';//new field
    	requestBean.Entity.crmEntityCustomData.settlementTypeCode='C';
       requestBean.Entity.crmEntityCustomData.nonResidentIndicator='N';
    	requestBean.Entity.crmEntityCustomData.exchangeControl='N';
    	requestBean.Entity.crmEntityCustomData.countryCode='003';//TBC
    	requestBean.Entity.crmEntityCustomData.principalAgentIndicator='Y';
    	requestBean.Entity.crmEntityCustomData.electionIndicator='C';//TBC
    	requestBean.Entity.crmEntityCustomData.electronicReportIndicator='A';
        requestBean.Entity.crmEntityCustomData.beeIndicator=null;
        requestBean.Entity.crmEntityCustomData.beeExpiryDate=null;
        requestBean.Entity.crmEntityCustomData.postalAddressCareOfAddressIndicator='N';
        requestBean.Entity.crmEntityCustomData.addressCareOfName='N/A';
       requestBean.Entity.crmEntityCustomData.clientRiskRating='low';
        requestBean.Entity.crmEntityCustomData.shareholderPercentage=null;
        requestBean.Entity.crmEntityCustomData.contactPerson='test';
        requestBean.Entity.crmEntityCustomData.contactPerson='test';
        requestBean.Entity.crmEntityCustomData.powerOffAttorney='N'; //TBC
        requestBean.Entity.crmEntityCustomData.refferedBy=null;//new field
        requestBean.Entity.crmEntityCustomData.portfolioManagementCHGCode=null;
        requestBean.Entity.crmEntityCustomData.safeCustodyChargeCode='01';
        requestBean.Entity.crmEntityCustomData.nameOFPOA='test';//field still to be created by onboarding team
       requestBean.Entity.crmEntityCustomData.sourceOfIncome='Salary';
        requestBean.Entity.crmEntityCustomData.reasonForNoTaxNumber='654645';
        requestBean.Entity.crmEntityCustomData.tfsaIndicator='N';
        requestBean.Entity.crmEntityCustomData.email2='test@gmail.com';//TBC
        requestBean.Entity.crmEntityCustomData.idType='001';
       requestBean.Entity.crmEntityCustomData.idNumber='8012065434089';
        requestBean.Entity.crmEntityCustomData.countryOfIssue='South Africa';
        requestBean.Entity.crmEntityCustomData.ppExpiryDate=null;
        requestBean.Entity.crmEntityCustomData.countryOfBirth='South Africa';
        requestBean.Entity.crmEntityCustomData.countryOfResForDWT=null;//TBC
       requestBean.Entity.crmEntityCustomData.taxResidency1=null;
        requestBean.Entity.crmEntityCustomData.taxResidency1=null;//TBC
        requestBean.Entity.crmEntityCustomData.taxResidency2=null;//TBC
        requestBean.Entity.crmEntityCustomData.taxResidency3=null;//TBC
        requestBean.Entity.crmEntityCustomData.taxResidency4=null;//TBC
        requestBean.Entity.crmEntityCustomData.taxResidency5=null;//TBC
        requestBean.Entity.crmEntityCustomData.foreignTaxNumbers1=null;
        requestBean.Entity.crmEntityCustomData.foreignTaxNumbers2=null;//TBC
        requestBean.Entity.crmEntityCustomData.foreignTaxNumbers3=null;//TBC
        requestBean.Entity.crmEntityCustomData.foreignTaxNumbers4=null;//TBC
        requestBean.Entity.crmEntityCustomData.foreignTaxNumbers5=null;//TBC
        requestBean.Entity.crmEntityCustomData.nationality1=null;
       requestBean.Entity.crmEntityCustomData.sicCode='';
        requestBean.Entity.crmEntityCustomData.ficaCompliant=null;//TBC
        requestBean.Entity.crmEntityCustomData.dateOfFICACompliant=null;
        requestBean.Entity.crmEntityCustomData.sanctionsOnPoliticalPeron='N';//TBC
        requestBean.Entity.crmEntityCustomData.dwtExemption='Y';//TBC
        requestBean.Entity.crmEntityCustomData.iT3BExcl='N';
        requestBean.Entity.crmEntityCustomData.iT3CExcl='N';
        requestBean.Entity.crmEntityCustomData.dwtFormAorB=null;
        requestBean.Entity.crmEntityCustomData.dividendPassThrough='N';
        requestBean.Entity.crmEntityCustomData.reportingAccount='N';
        requestBean.Entity.crmEntityCustomData.financialInstitutionsGIIN='N/A';
        requestBean.Entity.crmEntityCustomData.countryOfJurisdiction1='N/A';
        requestBean.Entity.crmEntityCustomData.countryOfJurisdiction2='N/A';
        requestBean.Entity.crmEntityCustomData.advisorCode=null;
        requestBean.Entity.crmEntityCustomData.pfadv=null;
        requestBean.Entity.crmEntityCustomData.portfolioIntroducerID='1';
        requestBean.Entity.crmEntityCustomData.newsletter='E';
        requestBean.Entity.crmEntityCustomData.newsletterPER='E';
        requestBean.Entity.crmEntityCustomData.liableForInterestWithholdingTax=true;//TBC
        requestBean.Entity.crmEntityCustomData.type='C';
        requestBean.Entity.crmEntityCustomData.entConsolidation='N';
        requestBean.Entity.crmEntityCustomData.ermCheck='Y';
        requestBean.Entity.crmEntityCustomData.mancoCode='N/A';
        requestBean.Entity.crmEntityCustomData.reitsExemption=null;//TBC
        requestBean.Entity.crmEntityCustomData.brokerTrusteeFee='0';
        requestBean.Entity.crmEntityCustomData.feeSharing=null;//TBC
        requestBean.Entity.crmEntityCustomData.upfrontStructuringFee=null;
        requestBean.Entity.crmEntityCustomData.dividendTaxProvisionPercentage=null;
        requestBean.Entity.crmEntityCustomData.cgtProvisionPercentage=null;
        requestBean.Entity.crmEntityCustomData.incomeTaxProvisionPercentage=null;
        requestBean.Entity.crmEntityCustomData.incomeAccount=null;
        requestBean.Entity.crmEntityCustomData.beneficiaryID=null;
        requestBean.Entity.crmEntityCustomData.beneficiaryName=null;
        requestBean.Entity.crmEntityCustomData.recordofAdvice=null;
    	 requestBean.partnerID=49;
    	requestBean.Entity.entityID=0;
    	requestBean.Entity.partnerID=49;
       	requestBean.Entity.entityTypeID=1;//needstranslation
       requestBean.Entity.titleID=1;//needstranslation
    	requestBean.Entity.crmStatusID=1;
        requestBean.Entity.firstName='test';
        requestBean.Entity.middleName='test';
        requestBean.Entity.initials='test';
        requestBean.Entity.lastName='test';
    	requestBean.Entity.dateOfBirth=null;
    	requestBean.Entity.takeOnDate=string.valueOf(system.today());
    	requestBean.Entity.appelation='test';//still field need to be confirmed
    	requestBean.Entity.terminationDate=null;
    	requestBean.Entity.terminationReason=null;
    	requestBean.Entity.company=null;
        requestBean.Entity.registrationNumber=null;
    	requestBean.Entity.incomeTaxNumber='011211233';
        requestBean.Entity.vatNumber=null;
    	requestBean.Entity.nationality='South African';
    	requestBean.Entity.addressLine1='40 Smit Stree';
    	requestBean.Entity.addressLine2='Braamfontein';
    	requestBean.Entity.addressLine3='Johanesburg';
    	requestBean.Entity.addressLine4='011';
    	requestBean.Entity.addressLine5=null;
    	requestBean.Entity.contactNumber1='0812246607';
    	requestBean.Entity.contactNumber2=null;//TBC
    	requestBean.Entity.cellphoneNumber='0812246607';
        requestBean.Entity.emailAddress='test@gmail.com';
        requestBean.Entity.financialYearEndMonth=null;
    	requestBean.Entity.financialYearEndDay=null;//TBC
    	requestBean.Entity.sendStatementsViaEmail=true;
    	requestBean.Entity.externalSystemReference1='entitytest1';
    	requestBean.Entity.externalSystemReference2='entitytest2';
		return requestBean;
    }
}