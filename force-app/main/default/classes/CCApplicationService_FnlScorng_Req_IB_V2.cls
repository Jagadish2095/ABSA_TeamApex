/**
 * @description Request Integration Bean for CCApplicationService applyFinalScoring
 * @author Aaron Castelyn : Absa
 * @created 2020-11-12
 * @last modified on  : 08-17-2021
 * @last modified by  : Aaron Castelyn (ABSA)
 */

public without sharing class CCApplicationService_FnlScorng_Req_IB_v1 extends Base_IB {
    
	/**
	 * @description KnockOutQuestions
	 */
	public class KnockOutQuestions {
		public String registeredForeingTax;
	}
	
	/**
	 * @description apply property
	 */
	public Apply apply { get; set; }
	
	/**
	 * @description Address
	 */
	public class Address {
		public String addressLine1; 
		public String addressLine2; 
		public String city; 
		public String country; 
		public String postalCode; 
		public String suburb; 
	}
	
	/**
	 * @description Arg0
	 */
	public class Arg0 {
		public Application application; 
		public RequestCommons requestCommons; 
		public String validateDetails;
	}
	
	/**
    * @description CreditStatus
    */
	public class CreditStatus{
		public String id;
		public String description;
	}

	/**
	 * @description ExternalConsumerData
	 */
	public class ExternalConsumerData {
		public String customerId; 
		public String customerSourceCode; 
		public String customerSourceReferenceNumber;
	}
	
	/**
	 * @description Employer
	 */
	public class Employer {
		public Address address; 
		public String name;
	}
	
	/**
	 * @description Apply
	 */
	public class Apply {
		/**
		* @description arg0 property
		*/
		public Arg0 arg0 { get; set; }
	}
	
	/**
	 * @description Income
	 */
	public class Income {
		public String disposableMonthlyIncome; 
		public String grossMonthlyIncome; 
		public String grossMonthlySalary; 
		public String nettMonthlyIncome;
		public String rentalIncome; 
		public OtherIncome otherIncome;
	}
	
	/**
    * @description PreAssessed
    */
	public class PreAssessed{
		public String preAmrDisposableIncome;		
		public String preAssessedCreditLimit;
		public String preTmrNettIncome;
		public String preAssessedCreditLimitAccepted;
		public String preAssessedTotalLivingExpenses;
		public String preAssessedGrossIncome;
		public String preAssessedMaintanance;
		public String preAssessedGrossIncomeAccepted;		
	}

	/**
	 * @description PrimaryApplicant
	 */
	public class PrimaryApplicant {
		public String dateOfBirth;
		public String numberOfDependents; 
		public String financialInformationSuppliedCorrect; 
		public String incomeTaxNumber; 
		public String occupationStatus; 
		public String occupationCode; 
		public String occupationLevel; 
		public String employmentSector; 
		public String hasPostMatricQualification; 
		public Qualification qualification; 
		public Employer employer; 
		public WorkTelephoneNumber workTelephoneNumber; 
		public String sourceOfIncome; 
		//public String sourceOfFunds; 
		public List<String> sourceOfFunds; 
		public PreAssessed preAssessed; 
		public Income income; 
		public Expense expense;
		public String mayCheckCreditWorthiness;
	}
	
	/**
	 * @description OtherIncome
	 */
	public class OtherIncome {
		public String amount; 
		public String description;
	}
	
	/**
	 * @description Qualification
	 */
	public class Qualification {
		public String qualificationType;
	}
	
	/**
	 * @description RequestCommons
	 */
	public class RequestCommons {
		public String channelCode; 
		public String employeeNumber; 
		public String messageLanguage; 
		public String siteId; 
		public String systemName; 
		public String userId;
	}
	
	/**
	 * @description Expense
	 */
	public class Expense {
		public String bondInstalmentOrRent; 
		public String creditCardInstalment; 
		public String household; 
		public String insuranceOrFuneralPolicy; 
		public String maintenance; 
		public OtherIncome otherExpense; 
		public OtherIncome otherFixedDebtExpense; 
		public String personalLoanInstalment; 
		public String rent; 
		public String schoolOrUniversityFee; 
		public String totalFixedDebtExpense; 
		public String totalLivingExpense; 
		public String transport; 
		public String vehicleInstalment; 
		public String jointDebt;
	}
	
	/**
	 * @description WorkTelephoneNumber
	 */
	public class WorkTelephoneNumber {		
		public String number_Z; // in json: number
	}
	
	/**
	 * @description Application
	 */
	public class Application {
		public String applicationNumber; 
		public String applicationType; 
		public String channelCode; 
		public String corpCode; 
		public CreditStatus creditStatus; 
		public String customerType; 
		public ExternalConsumerData externalConsumerData;
		public String lockVersionId; 
		public String marketingSiteId; 
		public String productGroupId; 
		public String statusGroup; 
		public String transactionType; 
		public KnockOutQuestions knockOutQuestions; 
		public PrimaryApplicant primaryApplicant;
		public Consents consents;
    }
	
	/**
	 * @description Consents
	 */
	public class Consents {
        public String deaConsent;
	}
	
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"number_Z":');        
    }
    
	/**
	 * @description getNewInstance
	 * @return CCApplicationService_FnlScorng_Req_IB_v1
	 */
    public static CCApplicationService_FnlScorng_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_FnlScorng_Req_IB_v1 requestBean =  new CCApplicationService_FnlScorng_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_FnlScorng_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_FnlScorng_Req_IB_v1.Arg0();
        requestBean.apply.arg0.requestCommons = new CCApplicationService_FnlScorng_Req_IB_v1.RequestCommons();   
        
        requestBean.apply.arg0.application = new CCApplicationService_FnlScorng_Req_IB_v1.Application();
        
		requestBean.apply.arg0.application.creditStatus = new CCApplicationService_FnlScorng_Req_IB_v1.CreditStatus();

        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_FnlScorng_Req_IB_v1.ExternalConsumerData();
        
		requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_FnlScorng_Req_IB_v1.KnockOutQuestions();
		
		requestBean.apply.arg0.application.consents = new CCApplicationService_FnlScorng_Req_IB_v1.Consents();
        
        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_FnlScorng_Req_IB_v1.PrimaryApplicant();
        requestBean.apply.arg0.application.primaryApplicant.qualification = new CCApplicationService_FnlScorng_Req_IB_v1.Qualification();
        requestBean.apply.arg0.application.primaryApplicant.workTelephoneNumber = new CCApplicationService_FnlScorng_Req_IB_v1.WorkTelephoneNumber();

        requestBean.apply.arg0.application.primaryApplicant.income = new CCApplicationService_FnlScorng_Req_IB_v1.Income();
        requestBean.apply.arg0.application.primaryApplicant.income.otherIncome = new CCApplicationService_FnlScorng_Req_IB_v1.OtherIncome();
		requestBean.apply.arg0.application.primaryApplicant.preAssessed = new CCApplicationService_FnlScorng_Req_IB_v1.PreAssessed();
		requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds = new List<String>();

        requestBean.apply.arg0.application.primaryApplicant.expense = new CCApplicationService_FnlScorng_Req_IB_v1.Expense();
        requestBean.apply.arg0.application.primaryApplicant.expense.otherExpense = new CCApplicationService_FnlScorng_Req_IB_v1.OtherIncome();
        requestBean.apply.arg0.application.primaryApplicant.expense.otherFixedDebtExpense = new CCApplicationService_FnlScorng_Req_IB_v1.OtherIncome();
        requestBean.apply.arg0.application.primaryApplicant.employer = new CCApplicationService_FnlScorng_Req_IB_v1.Employer();
		requestBean.apply.arg0.application.primaryApplicant.employer.address = new CCApplicationService_FnlScorng_Req_IB_v1.Address();
        requestBean.apply.arg0.application.primaryApplicant.preAssessed.preAssessedCreditLimit= 
		return requestBean;
	}
	
	public override void setIntegrationTranslations()
	{
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.occupationStatus','CIFCodesList;Emplstatus' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.occupationLevel','CIFCodesList;Occulvl' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.occupationCode','CIFCodesList;Occucode' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.employer.address.country','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.qualification.qualificationType','CIFCodesList;Postmatq' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.employmentSector','CIFCodesList;Emplsector' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.sourceOfFunds','CIFCodesList;Sof' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.sourceOfIncome','CIFCodesList;Sofsoi' );
	}

	/**
	 * @description createDummyRequest
	 * @return CCApplicationService_FnlScorng_Req_IB_v1
	 */
	public static CCApplicationService_FnlScorng_Req_IB_v1 createDummyRequest(){
		CCApplicationService_FnlScorng_Req_IB_v1 requestBean = CCApplicationService_FnlScorng_Req_IB_v1.getNewInstance();

		requestBean.apply.arg0.application.applicationNumber = '';
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';        
        requestBean.apply.arg0.application.customerType = '001';
        requestBean.apply.arg0.application.lockVersionId = '';
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = '4592';
		requestBean.apply.arg0.application.productGroupId = '1';
		requestBean.apply.arg0.application.transactionType = '';
                		
		requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';
        
        requestBean.apply.arg0.application.knockOutQuestions.registeredForeingTax = 'false';
		
        requestBean.apply.arg0.application.primaryApplicant.dateOfBirth = '';
        requestBean.apply.arg0.application.primaryApplicant.occupationStatus = ''; 
        requestBean.apply.arg0.application.primaryApplicant.occupationCode = ''; 
        requestBean.apply.arg0.application.primaryApplicant.occupationLevel = '';
        requestBean.apply.arg0.application.primaryApplicant.employmentSector = ''; 

        requestBean.apply.arg0.application.primaryApplicant.hasPostMatricQualification = 'true';
        requestBean.apply.arg0.application.primaryApplicant.qualification.qualificationType = '';

        requestBean.apply.arg0.application.primaryApplicant.incomeTaxNumber = '';
        
        requestBean.apply.arg0.application.primaryApplicant.employer.name = '';

        requestBean.apply.arg0.application.primaryApplicant.employer.address.addressLine1 = '';
        requestBean.apply.arg0.application.primaryApplicant.employer.address.addressLine2 = '';
        requestBean.apply.arg0.application.primaryApplicant.employer.address.suburb = '';
        requestBean.apply.arg0.application.primaryApplicant.employer.address.city = '';
        requestBean.apply.arg0.application.primaryApplicant.employer.address.postalCode = '';
        requestBean.apply.arg0.application.primaryApplicant.employer.address.country = '';
        
        requestBean.apply.arg0.application.primaryApplicant.sourceOfIncome = '20';
		//requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds = '20';
        requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds = new List<String>();
		requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds.Add('20');
		        
        requestBean.apply.arg0.application.primaryApplicant.income.grossMonthlyIncome = '';
        requestBean.apply.arg0.application.primaryApplicant.income.grossMonthlySalary = '';
        requestBean.apply.arg0.application.primaryApplicant.income.nettMonthlyIncome = '';
        requestBean.apply.arg0.application.primaryApplicant.income.disposableMonthlyIncome = '';
        requestBean.apply.arg0.application.primaryApplicant.income.otherIncome.description = '';
        requestBean.apply.arg0.application.primaryApplicant.income.otherIncome.amount = '';       
        
        requestBean.apply.arg0.application.primaryApplicant.expense.vehicleInstalment = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.personalLoanInstalment = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.creditCardInstalment = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.bondInstalmentOrRent = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.jointDebt = 'N';

        requestBean.apply.arg0.application.primaryApplicant.expense.household = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.transport = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.schoolOrUniversityFee = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.insuranceOrFuneralPolicy = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.rent = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.maintenance = '';        
        requestBean.apply.arg0.application.primaryApplicant.expense.otherExpense.description = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.otherExpense.amount = '';
		requestBean.apply.arg0.application.primaryApplicant.expense.otherFixedDebtExpense.description = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.otherFixedDebtExpense.amount = '';
        
        requestBean.apply.arg0.application.primaryApplicant.expense.totalFixedDebtExpense = '';
        requestBean.apply.arg0.application.primaryApplicant.expense.totalLivingExpense = '';

        requestBean.apply.arg0.application.primaryApplicant.numberOfDependents = '';
        requestBean.apply.arg0.application.primaryApplicant.financialInformationSuppliedCorrect = 'true'; 
        requestBean.apply.arg0.application.primaryApplicant.preAssessed.preAssessedCreditLimit='';      

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