/**
* @description Response Integration Bean for policyLoadByRefNo Service
* @author chandra Bhushan Singh
* @created 2021-02-08
* @updated Koketso Mpshane 07-06-2021 
* @W-007776
*/

public class PolicyLoadByRefNo_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public String status;
    /**
    * @description BeneficiaryDetail
    */
    public class BeneficiaryDetail {
        @AuraEnabled public String ClientGID;
        @AuraEnabled public String DateofBirth;
        @AuraEnabled public String Initials;
        @AuraEnabled public String Name;
        @AuraEnabled public String Percentage;
        @AuraEnabled public String Surname;
    }
    /**
    * @description BankContract
    */
    public class BankContract {
        @AuraEnabled public String AccountName;
        @AuraEnabled public String AccountNo;
        @AuraEnabled public String AccountTypeID;
        @AuraEnabled public String BankBranchID;
        @AuraEnabled public String BankBranchName;
        @AuraEnabled public String BankID;
        @AuraEnabled public String BankName;
        @AuraEnabled public String Changed;
        @AuraEnabled public String ClientGID;
        @AuraEnabled public String ContractStatusID;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String DateNextDue;
        @AuraEnabled public String GID;
        @AuraEnabled public String IsNew;
        @AuraEnabled public String IsValidAccountNo;
        @AuraEnabled public String PaymentFrequency;
        @AuraEnabled public String PaymentFrequencyID;
        @AuraEnabled public String UpdatedBy;
        @AuraEnabled public String UpdatedDate;
    }

    @AuraEnabled public Policy_LoadByRefNoResponse Policy_LoadByRefNoResponse;
    /**
    * @description V3_DC2Component
    */
    public class V3_DC2Component {
        @AuraEnabled public String BenefitTerm;
        @AuraEnabled public String CGPerc;
        @AuraEnabled public String CommenceDate;
        @AuraEnabled public String ContractGID;
        @AuraEnabled public String Cover;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String Description;
        @AuraEnabled public String GID;
        @AuraEnabled public String HasInvestmentProduct;
        @AuraEnabled public String IChanged;
        @AuraEnabled public String IsBilling;
        @AuraEnabled public String IsIncreaseComponent;
        @AuraEnabled public String IsNew;
        @AuraEnabled public String IsReassured;
        @AuraEnabled public String LifeAssuredGID;
        @AuraEnabled public String NewComponent;
        @AuraEnabled public String NoChangedEvent;
        @AuraEnabled public String OccupationClassID;
        @AuraEnabled public String PGPerc;
        @AuraEnabled public String PGPercID;
        @AuraEnabled public String Premium;
        @AuraEnabled public String PremiumExcludingLoadings;
        @AuraEnabled public String PremiumTerm;
        @AuraEnabled public String ProductID;
        @AuraEnabled public String RateClassID;
        @AuraEnabled public String RateDate;
        @AuraEnabled public String RatedAge;
        @AuraEnabled public String ReasCover;
        @AuraEnabled public String ReasProductID;
        @AuraEnabled public String RecalcComponentsForSelectedClient;
        @AuraEnabled public String RecalculateOccupationClass;
        @AuraEnabled public String StatusID;
        @AuraEnabled public String UpdatedBy;
        @AuraEnabled public String UpdatedDate;
    }
    /**
    * @description ClientRoles
    */
    public class ClientRoles {
        @AuraEnabled public List<V3_DC2ClientRole> V3_DC2ClientRole;
    }
    /**
    * @description Policy_LoadByRefNoResponse
    */
    public class Policy_LoadByRefNoResponse {
        @AuraEnabled public Policy_LoadByRefNoResult Policy_LoadByRefNoResult;
    }
    /**
    * @description FinTransactions
    */
    public class FinTransactions {
        @AuraEnabled public List<V3_DC2FinTransaction> V3_DC2FinTransaction;
    }
    /**
    * @description Clients
    */
    public class Clients {
        @AuraEnabled public List<V3_DC2Client> V3_DC2Client;
    }
    /**
    * @description DC2Identifier
    */
    public class DC2Identifier {
        @AuraEnabled public String ClientGID;
        @AuraEnabled public String Description;
        @AuraEnabled public String GID;
        @AuraEnabled public String IdentifierTypeID;
    }
    /**
    * @description V3_DC2Contract
    */
    public class V3_DC2Contract {
        @AuraEnabled public String AdjustedPremium;
        @AuraEnabled public String AlterationDate;
        @AuraEnabled public String AlterationType;
        @AuraEnabled public String ApplicationPremium;
        @AuraEnabled public String ApplicationSignDate;
        @AuraEnabled public String BankAccountGID;
        @AuraEnabled public BankContract BankContract;
        @AuraEnabled public Object ClaimGID;
        @AuraEnabled public ClientRoles ClientRoles;
        @AuraEnabled public String CommenceDate;
        @AuraEnabled public Components Components;
        @AuraEnabled public String ContractTypeDescription;
        @AuraEnabled public String ContractTypeID;
        @AuraEnabled public String DateNextDue;
        @AuraEnabled public String DayOfPayment;
        @AuraEnabled public FinTransactions FinTransactions;
        @AuraEnabled public String FundEntryDate;
        @AuraEnabled public String GID;
        @AuraEnabled public String HasCustomParameters;
        @AuraEnabled public String IncreaseMonth;
        @AuraEnabled public String IsActiveRecord;
        @AuraEnabled public String IsAdminAlteration;
        @AuraEnabled public String IsBilling;
        @AuraEnabled public String IsCommencedateFixed;
        @AuraEnabled public String IsFeesBilling;
        @AuraEnabled public String IsInAlteration;
        @AuraEnabled public String IsPaidUp;
        @AuraEnabled public String IsValidated;
        @AuraEnabled public String LastBillDate;
        @AuraEnabled public String LastRenewDate;
        @AuraEnabled public String MaturityDate;
        @AuraEnabled public String MovementCount;
        @AuraEnabled public String MovementDate;
        @AuraEnabled public String MovementDescription;
        @AuraEnabled public String MovementID;
        @AuraEnabled public String NextBillDate;
        @AuraEnabled public String NextRenewDate;
        @AuraEnabled public String PaymentFrequency;
        @AuraEnabled public String PaymentFrequencyID;
        @AuraEnabled public String PaymentTypeDescription;
        @AuraEnabled public String PaymentTypeID;
        @AuraEnabled public String PolicyGID;
        @AuraEnabled public String PremHolidayMonths;
        @AuraEnabled public String PremiumBalance;
        @AuraEnabled public String RateDate;
        @AuraEnabled public String ReadAsAtDate;
        @AuraEnabled public String RefNo;
        @AuraEnabled public String ReservationNo;
        @AuraEnabled public String SchemeTypeID;
        @AuraEnabled public String SourceOfFunds1;
        @AuraEnabled public String SourceOfFunds2;
        @AuraEnabled public String SourceOfFunds3;
        @AuraEnabled public String SourceOfFunds4;
        @AuraEnabled public String SourceOfFunds5;
        @AuraEnabled public String StatusDescription;
        @AuraEnabled public String StatusID;
        @AuraEnabled public String ValidatedOK;
    }
    /**
    * @description Addresses
    */
    public class Addresses {
        @AuraEnabled public List<V3_DC2Address> V3_DC2Address;
    }
    /**
    * @description V3_DC2ClientRole
    */
    public class V3_DC2ClientRole {
        @AuraEnabled public BeneficiaryDetail BeneficiaryDetail;
        @AuraEnabled public String ClientGID;
        @AuraEnabled public String CommisionLevelGID;
        @AuraEnabled public String ContractGID;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String Description;
        @AuraEnabled public String GID;
        @AuraEnabled public String IsCorrespondent;
        @AuraEnabled public String IsNew;
        @AuraEnabled public String ReleationShipDescription;
        @AuraEnabled public String ReleationShipID;
        @AuraEnabled public String RoleDescription;
        @AuraEnabled public String RoleID;
        @AuraEnabled public String UpdatedBy;
        @AuraEnabled public String UpdatedDate;
    }
    /**
    * @description Components
    */
    public class Components {
        @AuraEnabled public List<V3_DC2Component> V3_DC2Component;
    }
    /**
    * @description DC2Telephone
    */
    public class DC2Telephone {
        @AuraEnabled public String AreaCode;
        @AuraEnabled public String ClientGID;
        @AuraEnabled public String CommunicationTypeTelephoneID;
        @AuraEnabled public String CountryCode;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String GID;
        @AuraEnabled public String TelLocal;
        @AuraEnabled public String UpdatedBy;
        @AuraEnabled public String UpdatedDate;
    }
    /**
    * @description LstLifeAssureds
    */
    public class LstLifeAssureds {
        @AuraEnabled public List<DC2LookUp> DC2LookUp;
    }
	/**
    * @description V3_DC2Client
    */
    public class V3_DC2Client {	
        @AuraEnabled public Activities_cls Activities;
    }
    /**
    * @description Activities_cls
    */
    public class Activities_cls {
        @AuraEnabled public Addresses Addresses;
        @AuraEnabled public String CommunicationLanguageID;
        @AuraEnabled public String CountryOfBirthID;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String DateOfBirth;
        @AuraEnabled public String DrinkingID;
        @AuraEnabled public String Firstname;
        @AuraEnabled public String GID;
        @AuraEnabled public String GenderID;
        @AuraEnabled public String Height;
        @AuraEnabled public String HighestQualificationTypeID;
        @AuraEnabled public String HomeLanguageID;
        @AuraEnabled public Identifiers Identifiers;
        @AuraEnabled public String IncomeGroupID;
        @AuraEnabled public String Initials;
        @AuraEnabled public String InsolventDate;
        @AuraEnabled public String InsolventRehabDate;
        @AuraEnabled public String IsBreadwinner;
        @AuraEnabled public String IsHomeOwner;
        @AuraEnabled public String IsLimitedAccess;
        @AuraEnabled public String IsNew;
        @AuraEnabled public String MaritalStatusID;
        @AuraEnabled public String MiddleName;
        @AuraEnabled public String NationalityID;
        @AuraEnabled public String Nickname;
        @AuraEnabled public String NoOfDependants;
        @AuraEnabled public String OccupationID;
        @AuraEnabled public String PlaceOfBirth;
        @AuraEnabled public String RetirementAge;
        @AuraEnabled public String SmokingID;
        @AuraEnabled public String SocioEconomicGroupID;
        @AuraEnabled public String StatusID;
        @AuraEnabled public String Surname;
        @AuraEnabled public String TaxNumber;
        @AuraEnabled public String TaxOffice;
        @AuraEnabled public String TaxPercent;
        @AuraEnabled public String TaxTypeID;
        @AuraEnabled public Telephones Telephones;
        @AuraEnabled public String TitleDescription;
        @AuraEnabled public String TitleID;
        @AuraEnabled public String TypeID;
        @AuraEnabled public String UpdatedBy;
        @AuraEnabled public String UpdatedDate;
        @AuraEnabled public String Weight;
        @AuraEnabled public String YearsAtAddress;
    }
    /**
    * @description Telephones
    */
    public class Telephones {
        @AuraEnabled public List<DC2Telephone> DC2Telephone;
    }
    /**
    * @description DC2LookUp
    */
    public class DC2LookUp {
        @AuraEnabled public String Description;
        @AuraEnabled public String ID;
        @AuraEnabled public String IsActive;
        @AuraEnabled public String Key;
        @AuraEnabled public String Value1;
        @AuraEnabled public String Value2;
        @AuraEnabled public String Value3;
        @AuraEnabled public String Value4;
    }
    /**
    * @description Identifiers
    */
    public class Identifiers {
        @AuraEnabled public List<DC2Identifier> DC2Identifier;
    }
    /**
    * @description Contracts
    */
    public class Contracts {
        @AuraEnabled public V3_DC2Contract V3_DC2Contract; 
    }
    /**
    * @description Policy_LoadByRefNoResult
    */
    public class Policy_LoadByRefNoResult {
        @AuraEnabled public String ApplicantGID;
        @AuraEnabled public String ApplicationSignDate;
        @AuraEnabled public Clients Clients;
        @AuraEnabled public Contracts Contracts;
        @AuraEnabled public String GUID;
        @AuraEnabled public String RefNo;
        @AuraEnabled public LstLifeAssureds lstLifeAssureds;
    }
    /**
    * @description V3_DC2Address
    */
    public class V3_DC2Address {
        @AuraEnabled public String Address;
        @AuraEnabled public String AddressAreaID;
        @AuraEnabled public String AddressLine1;
        @AuraEnabled public String AddressLine2;
        @AuraEnabled public String ClientGID;
        @AuraEnabled public String CommunicationTypeAddressID;
        @AuraEnabled public String Country;
        @AuraEnabled public String CountryCode;
        @AuraEnabled public String CountryID;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String GID;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String StateProvinceID;
        @AuraEnabled public String Suburb;
        @AuraEnabled public String Town;
        @AuraEnabled public String UpdatedBy;
        @AuraEnabled public String UpdatedDate;
        @AuraEnabled public String Zip_PostalCode;
    }
    /**
    * @description V3_DC2FinTransaction
    */
    public class V3_DC2FinTransaction {
        @AuraEnabled public String AccountingPeriodID;
        @AuraEnabled public String Amount;
        @AuraEnabled public String Balance;
        @AuraEnabled public String Changed;
        @AuraEnabled public String ContractGID;
        @AuraEnabled public String ContractMovementCount;
        @AuraEnabled public String ContractMovementID;
        @AuraEnabled public String Counter;
        @AuraEnabled public String CreatedBy;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String ExportBatchID;
        @AuraEnabled public String GID;
        @AuraEnabled public String IsBillingTrx;
        @AuraEnabled public String MovementDate;
        @AuraEnabled public String Note;
        @AuraEnabled public String ReconID;
        @AuraEnabled public String ReferenceGID;
        @AuraEnabled public String ReversedIndicator;
        @AuraEnabled public String TransTypeDesc;
        @AuraEnabled public String TransactionGroupID;
        @AuraEnabled public String TransactionTypeID;
    }
    /**
    * @description setIntegrationTranslations
    */
    public override void setIntegrationTranslations(){

        integrationTranslationsMap = new Map<String,String>();
        integrationTranslationsMap.put('Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles.V3_DC2ClientRole.ReleationShipID', 'Exergy;Policy Relationship');
        integrationTranslationsMap.put('Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Clients.V3_DC2Client.Activities.Identifiers.DC2Identifier.IdentifierTypeID', 'Exergy;Policy ID Type');
        integrationTranslationsMap.put('Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Clients.V3_DC2Client.Activities.TitleID', 'Exergy;Title');
        integrationTranslationsMap.put('Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.AccountTypeID', 'Exergy;Account Type');

    }
}