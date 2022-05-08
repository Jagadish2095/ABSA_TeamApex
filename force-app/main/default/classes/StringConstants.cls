/**
* @description String Constants
*
*/

public class StringConstants {

    /**============================
* INTEGRATION CONSTANTS
============================**/

    /**==============================================================================================================================
*Integration Type String Values
Contains the a String values of the type of integration
==============================================================================================================================**/
    public static final String INBOUND_RECORD_TYPE = 'Inbound';
    public static final String OUTBOUND_RECORD_TYPE = 'Outbound';

    /**==============================================================================================================================
*Status String Values
Contains the a String values of a status
==============================================================================================================================**/
    public static final String INTEGRATION_STATUS_SUCCESS = 'Success';
    public static final String INTEGRATION_STATUS_FAILED = 'Failed';
    public static final String INTEGRATION_STATUS_SUCCESSFUL = 'Successful';
    public static final String INTEGRATION_STATUS_UNSUCCESSFUL = 'Unsuccessful';
    public static final String POSITIVE_STRING = 'Positive';
    public static final String NEGATIVE_STRING = 'Negative';
    public static final String ERROR_STRING = 'Error';
    public static final String ESP_STAGES = 'Rejected,Completed';
    public static final String NEGATIVE_STRING_Hold ='Hold Negative'; //added by Almas Aleem for W-002644
    public static final String MSG_CLIENT_LEAD_CREATE = 'successfully processed'; 
    public static final String ERROR_MSG_COULD_NOT_CREATE_LEAD = 'Failed - Could not create lead ';
    public static final String ERROR_MSG_COULD_NOT_EMPTY_LEAD_ERROR = 'Failed - Could not create - Lead object is empty ';

    /**==============================================================================================================================
*Service Name String Values
Contains the a String value of the name of a service
==============================================================================================================================**/
    public static final String INSERT_OR_UPDATE_LEAD_SSM = '/leadManagement/v1.0/InsertOrUpdateLeadSSM';
    public static final String GET_CLIENT_RISK_PROFILE = '/CASA/v1.0/riskProfileClient';
    public static final String RISK_PROFILE_JOINT_CLIENTV2 = 'Risk Profile Joint ClientV2';
    public static final String SVUPDATEACCOUNTOPENINGDETAILSV2 = 'SVupdateAccountOpeningDetailsV2';
    //public static final String GET_BANK_CLEARANCE_CODES = '/v1/retrieveListBankClearanceCodesV2';
    //public static final String CHECK_DIGIT_VERIFICATION = '/distribution/v1/checkDigitVerificationV1';
    //public static final String INSERT_OR_UPDATE_PRI = '/pri/commission-management-service/v1.0/InsertOrUpdatePRICASA';
    //public static final String WBIF_POLICY_CREATE = '/AMCDF/v2.0/webFormsService/Policy_Create';
    //public static final String WBIF_CALCULATE = '/AMCDF/v1.0/webFormsService/Calculate';
    //public static final String WBIF_POLICY_ADD_BENEFIT = '/AMCDF/v1.0/webFormsService/Policy_AddBenefit';
    //public static final String WBIF_POLICY_ADD_BENEFIT_V2 = '/AMCDF/v2.0/webFormsService/Policy_AddBenefit';
    //public static final String WBIF_POLICY_ADD_DEPENDENT = '/wbif-amcdf-service-policyadddependent/v1.1/Policy_AddDependent';
    //public static final String WBIF_POLICY_ADD_BENEFICIARY = '/wbif-addbeneficiary/AddBeneficiary';
    //public static final String WBIF_VALIDATE_POLICY = '/wbif-policyvalidate/v1.0/Policy_Validate';
    //public static final String WBIF_SUBMIT_POLICY = '/wbif-policysubmit/v1.0/Policy_Submit';
    //public static final String CASA_PRIMARY_CLIENT_SCREENING = '/casa/primaryClientScreening/v2/ScreenPrimaryClient';
    public static final String UPDATE_LEAD_STATUS_SIEBEL = 'Update Lead Status Siebel';
    public static final String INSERT_OR_UPDATE_PRI = 'Insert Or Update PRI Casa';
    public static final String WBIF_POLICY_CREATE = 'WBIF Policy Create';
    public static final String WBIF_CALCULATE = 'WBIF Policy Calculate';
    public static final String WBIF_CALCULATE_V2 = 'WBIF Policy Calculate V2';
    public static final String WBIF_POLICY_ADD_BENEFIT = 'WBIF Policy Add Benefit';
    public static final String WBIF_POLICY_ADD_BENEFIT_V2 = 'WBIF Policy Add Benefit V2';
    public static final String WBIF_POLICY_ADD_DEPENDENT = 'WBIF Policy Add Dependent';
    public static final String WBIF_POLICY_ADD_BENEFICIARY = 'WBIF Policy Add Beneficiary';
    public static final String WBIF_VALIDATE_POLICY = 'WBIF Policy Validate';
    public static final String WBIF_SUBMIT_POLICY = 'WBIF Policy Submit';
    public static final String VALIDATE_ADDRESS = 'Validate Address';
    public static final String ITOUCH_SUBMIT = 'iTouch SMS Submit - WILLS';
    public static final String ITOUCH_SUBMIT_CC = 'iTouch SMS Submit';
    public static final String REGULATORY_SERVICE_INVOLVED_PARTIES = 'Get Involved Parties';
    public static final String REGULATORY_SERVICE_COMPLIANCE_INFO = 'Get Regulatory Compliance';
    public static final String REFRESH_REGULATORY_SERVICE_COMPLIANCE_INFO = 'Refresh Regulatory Compliance';
    public static final String ADD_ACCOUNT_TO_PORTFOLIO = 'Add Account To Portfolio';
    public static final String CI_GET_ACCT_LINKED_TO_CLIENT_CODE = 'CI Get Acct Linked To Client Code';
    public static final String HLALLOCATE_STOCK_NUMBER = 'HL Allocate Stock Number';
    public static final String WBIF_AMCDF_PRODUCTGET = 'WBIF Product Get';
    public static final String UPDATE_CLIENT_DETAILS_CIF = 'Update Client Details CIF';
    public static final String GET_WILL_DETAILS = 'Get Will Details';
    public static final String ACCOUNT_VERIFICATION_DETAILS = 'AVS Account Verification Details';
    public static final String DOCFUSION_CREATE_DOCUMENT = 'DocFusion Create Document';
    public static final String UPDATE_WILL_DETAIL = 'Update Wills Details';
    public static final String VALIDATE_CLIENT_DETAILS = 'Validate Client Details CIF';
    public static final String VALIDATE_ACCT_LINKED_TO_CLIENT_CODE = 'Validate Acct Linked To Client Code CIF';
    public static final String API_MANAGER_ADAPT360 = 'Jitterbit2'; //'API Manager ADAPT360';
    public static final String CASA_PRIMARY_CLIENT_SCREENING = 'CASA Primary Client Screening';
    public static final String CASA_PRIMARY_CLIENT_SCREENING_V2 = 'CASA Primary Client Screening V2';
    public static final String CHECK_DIGIT_VERIFICATION = 'Check Digit Verification';
    public static final String CREATE_CLIENT_CIF = 'Create Client CIF';
    public static final String CI_Create_Client_V12 = 'CI Create Client V12';
    public static final String GET_BANK_CLEARANCE_CODES = 'Get Bank Clearance Codes';
    public static final String GET_CLIENT_DETAILS = 'Get Client Details';
    public static final String GET_JOINT_PARTICIPANT = 'Get Joint Participant';
    public static final String GET_RISK_PROFILE_CLIENT = 'Get Risk Profile Client';
    public static final String CREATE_INSTRUCTION = 'EPS Create Instruction';
    public static final String LIST_TRACKER_HISTORY = 'Retrieve Tracker Status Wills';
    public static final String CREATE_WILL_RECORD = 'Create Will Record';
    public static final String CREATE_TRACKER_RECORD = 'Create Tracker Record';
    public static final String UPDATE_WILL_BANKING_DETAILS = 'Update Will Banking Details';
    public static final String CREATE_WILL_BANKING_DETAILS = 'Create Will Banking Details';
    public static final String GET_WILL_BANKING_DETAILS = 'Get Will Banking Details';
    public static final String CREATE_ASSETS_LIABILITIES = 'Create Assets Liabilities';
    public static final String GET_ASSETS_LIABILITIES = 'Get Assets Liabilities';
    public static final String CASA_SCREEN_RELATED_PARTY = 'CASA Screen Related Party';
    public static final String CASA_SCREEN_RELATED_PARTY_V6 = 'CASA Screen Related Party V2';
    public static final String CASA_SCREEN_RELATED_PARTY_V7 = 'CASA Screen Related Party V3';
    public static final String RISK_PROFILE_JOINT_CLIENT = 'Risk Profile Joint Client';
    public static final String UPD_JNT_PART_BY_CLIENT_CODE = 'Update Joint Participant By Client Code';
    public static final String GET_FILING_ADDRESS = 'Get Filing Address';
    public static final String GET_XML_WILL_DRAFT = 'Get Xml Will Draft';
    public static final String SAVE_XML_WILL_DRAFT = 'Save Xml Will Draft';
    public static final String DEBIT_ORDER_INSTRUCTION = 'Debit Order Instruction';
    public static final String GET_ACCOUNT_DETAILS_VIA_REFERENCE = 'Get Account Details Via Reference';
    public static final String GET_SVAccount_BalanceDetailsV5='SVGetAccountBalanceDetailsV5';
    public static final String GET_CLIENT_HOLDS = 'Get Client Holds'; //Added by Almas Aleem for W-002644
    public static final String CMS_GET_ACCOUNTDEATILS = 'CMS Get AccountDeatils';//added by Diksha
    public static final String GET_CUSTOMER_VAPM_SUMMARY = 'GetCustomerVAPMSummary';//added by Muvhuso
    public static final String JITTERBIT_DEV = 'Jitterbit2';//added by Muvhuso
    public static final String GET_CQ_PaymentDueV1='CQgetPaymentDueV1'; // added by HarithaP :CQGetPaymentDue
    public static final String MLgetOnlineStatementDetailIF42V1_STRING = 'MLgetOnlineStatementDetailIF42V1IF42V1';
    public static final String CC_GET_DAILY_LIMITS = 'CC Get Daily Limits'; //PJAIN:20190911: CCgetDailyLimits
    public static final String MB_COMPL_EPS_PAYMENT = 'mBcomplEpSpaymentV4'; //Added by Lulu mBcomplEpSpaymentV4
    public static final String IBCANCELSERVICE = 'IBcancelServiceV1'; //Added by Lulu
    public static final String IBCANCELSERVICE_TRANSL = 'IBCANCELSERVICE'; //by lulu
    public static final String CA_GETCASSACCPAYOFF_V1 = 'CAGETCASSACCPAYOFFV1'; //by lulu

    public static final String ABSAOnlineStatementSearch_STRING = 'ABSAOnlineStatementSearch';
    public static final String ABSAOnlineStatementDownload_STRING = 'ABSAOnlineStatementDownload';
    public static final String DEBIT_RETRI_DETAILS_STRING ='RETRIEVEDEBITCREDITSINQ'; //Prasanna Patwardhan: DSretrieveDebitsCreditsInqV1
    public static final String DEBIT_RETRI_DETAILS_CARD_V1='DSretrieveDebitsCreditsInqV1'; //Prasanna Patwardhan: DSretrieveDebitsCreditsInqV1
    public static final String CASA_PRIMARY_CLIENT_SCREENINGV3_STRING ='CASAPRIMARYCLIENTSCREENINGV3'; //Prasanna Patwardhan: CASAPrimaryClientScreeningv3
    public static final String CASA_PRIMARY_CLIENT_SCREENING_V3 ='CASAPrimaryClientScreeningv3'; // Prasanna Patwardhan: CASAPrimaryClientScreeningv3
    public static final String EXPERIAN_BUSINESS_DETAILS_GET = 'Experian Business Details Get'; //PJAIN:20191205: ExperianBusinessDetailsGet
    public static final String CPB_VALIDATE = 'CPB Validate'; //PJAIN:20200206: CPBValidate
    public static final String HANIS_VALIDATE = 'Hanis Validate'; //PJAIN:20200212: HanisValidate
    public static final String CQ_CREATE_AND_LINK_ACCOUNT_V7 = 'CQ Create And Link Account V7'; //PJAIN:20200221: CQcreateAndLinkAccountV7
    public static final String SM_GET_ASV_BONDS_V1 = 'SM Get Asv Bonds V1'; //PJAIN:20200303: sMgetAsVbondsV1
    public static final String EI_maintain_ESD_DetailsV3 = 'EImaintainESDDetailsV3'; //MNEKHUBVI:20200407: EImaintainESDDetailsV3
    public static final String CI_UPD_SIGNING_INSTRUCTIONS_V5 = 'CI Upd Signing Instructions V5'; //PJAIN:20200225: CIupdSigningInstructionsV5
    public static final String CI_GET_SIGNING_INSTRUCTIONS_V4 = 'CI Get Signing Instructions V4'; //PJAIN:20200305: CIgetSigningInstructionsV4
    public static final String CI_GET_CLIENTDETAILS_BY_NAME_V2 = 'CI Get Client Details By Name V2'; //Rudolf Niehaus: 20200319 : CIgetClientDetailsByNameV2
    public static final String IB_GET_BENEFICIARY_V1 = 'IB Get Beneficiaries V1'; //Rudolf Niehaus: 20200319 : IBlistBeneficiariesV1
    public static final String MB_UPDATE_BENEFICIARIES_V1 = 'MB Update Beneficiaries V1'; //Rudolf Niehaus: 20200320 : MBupdateInstructionV1
    public static final String MB_DELETE_BENEFICIARIES_V2 = 'MB Delete Beneficiaries V2'; //Rudolf Niehaus: 20200320 : MBdeleteInstructionV2
    public static final String GET_TRANSACTION_HISTORY = 'nHlistAcctTransactionHistoryV5'; //added by Mashudu Raidimi
    public static final String CQ_GET_ACCOUNT_HOLDS = 'cqgetacctholdsmaintv4';
    public static final String CQ_GET_CHARGES_DETAILS_MAINT_V9 = 'CQgetChargesDetailsMaintV9';//Techmagic - Igor (Integration service)
    public static final String CQ_GET_VALUE_BUNDLE_OPTIONS_V3 = 'CQgetValueBundleOptionsV3';//Techmagic - Igor (Integration service)
    public static final String CQ_UPDATE_CHARGES_DETAILS_V12 = 'CQupdateChargesDetailsV12';//Techmagic - Igor (Integration service)
    public static final String CQ_VAL_ACCOUNT_HOLDS = 'cqvalacctholdsv4';
    public static final String CQ_UPDATE_ACCOUNT_HOLDS = 'cqupdacctholdsv4';
    public static final String SV_GET_ACCOUNT_HOLDS = 'svgetaccountholdsdetailv4';
    public static final String SV_UPDATE_ACCOUNT_HOLDS = 'svupdateaccountholdsv4';
    public static final String CC_GET_PORTFOLIO_DETAIL_V1 = 'CC Get Portfolio Detail V1'; //PJAIN:20200316: CCGetPortfolioDetailV1
    public static final String SM_GET_ASV_CESSION_OF_DEBTORS_V1 = 'SM Get Asv Cession Of Debtors V1'; //PJAIN:20200303: sMgetAsvCessionOfDebtorsV1
    public static final String SM_GET_ASV_CESSION_OF_PLEDGES_V1 = 'SM Get Asv Cession Of Pledges V1'; //PJAIN:20200303: sMgetAsvCessionOfPledgesV1
    public static final String SM_GET_ASV_CESSION_OF_INVSTMNT_V1 = 'SM Get Asv Cession Of Invstmnt V1'; //PJAIN:20200305: sMgetAsvCessionOfInvstmntV1
    public static final String SM_GET_ASV_CESSION_OF_L_P_LINKED_V1 = 'SM Get Asv Cession Of L P Linked V1'; //PJAIN:20200305: sMgetAsvCessionOfLPLinkedV1
    public static final String SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1 = 'SM Get Asv Cession Of L P No Link V1'; //PJAIN:20200305: sMgetAsvCessionOfLPNoLinkV1
    public static final String SM_GET_ASV_CESSION_OF_SCHEMES_V1 = 'SM Get Asv Cession Of Schemes V1'; //PJAIN:20200306: sMgetAsvCessionOfSchemesV1
    public static final String SM_GET_ASV_CESSION_OF_SHARES_V1 = 'SM Get Asv Cession Of Shares V1'; //PJAIN:20200306: sMgetAsvCessionOfSharesV1
    public static final String SM_GET_ASV_CREDIT_LIFE_POLICY_V1 = 'SM Get Asv Credit Life Policy V1'; //PJAIN:20200306: sMgetAsvCreditLifePolicyV1
    public static final String SM_GET_ASV_DEMAT_SHARES_V1 = 'SM Get Asv Demat Shares V1'; //PJAIN:20200309: sMgetAsvDematSharesV1
    public static final String SM_GET_ASV_LETTERS_V1 = 'SM Get Asv Letters V1'; //PJAIN:20200309: sMgetAsvLettersV1
    public static final String SM_GET_ASV_SECURITY_AND_HOLDS_V1 = 'SM Get Asv Security And Holds V1'; //PJAIN:20200310: sMgetAsvSecurityAndHoldsV1
    public static final String SM_GET_ASV_SURETYSHIPS_V1 = 'SM Get Asv Suretyships V1'; //PJAIN:20200303: sMgetAsvSuretyshipsV1
    public static final String SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1 = 'SMgetASVCessionOfExternalInvestmentsV1'; //NMUVHUSO:20200303: SMgetASVCessionOfExternalInvestmentsV1
    public static final String SM_GET_ASV_FIRESHORT_TERMINSURANCE_SESSION_V1 = 'SMgetASVCessionOfFireShortTermInsuranceV1'; //NMUVHUSO:20200303: SMgetASVCessionOfFireShortTermInsuranceV1
    public static final String SM_GET_ASV_OUTSTANDING_SECURITY_HOLDS_V1 = 'SMgetASVOutstandingSecurityAndHoldsV1'; //NMUVHUSO:20200303: SMgetASVOutstandingSecurityAndHoldsV1
    public static final String SM_GET_ASV_GENERAL_SESSION_V1 = 'SMgetASVGeneralCessionsV1'; //NMUVHUSO:20200303: SMgetASVGeneralCessionsV1
    public static final String CQ_UPDATEACC_DOMICILE_CHANGE = 'CQ  Update Domicile Change V2'; //Saurabh Pandey:20200407: CqUpdAcctDomicileChangev2
    public static final String MPS_CREATE_MASS_ACCOUNT_V2 = 'MPS Create MASS Account V2'; //PJAIN:20200508: MPScreateMASSAccountV2
    public static final String MPS_CREATE_MERCHANT_PLAN_V1 = 'MPS Create Merchant Plan V1'; //PJAIN:20200508: MpsCreateMerchantPlanv1
    public static final String MPS_CREATE_POSH_MERCHANT_V3 = 'MPS Create Posh Merchant V3'; //PJAIN:20200508: MpsCreatePoshMerchantv3
    public static final String GB_CREATE_CMS_CONTOFFLINK_V1 = 'GB Create CMS ContOffLink V1'; //Diksha Wasekar:20200415: GBcreateCmsContOffLinkV1
  public static final String NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING = 'NQLISTRECIPIENTSREGISTEREDFORCUSTV1'; //MNEKHUBVI:20200518: NQlistRecipientsRegisteredForCustV1
  public static final String NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING = 'NQREPLACERECIPIENTSACROSSALLACNTSV1'; //MNEKHUBVI:20200518: NQreplaceRecipientsAcrossAllAcntsV1
    public static final String MB_LIST_SOURCE_INSTRUCTIONS_V1 = 'MB List Source Instructions V1'; //Rudolf Niehaus: 20200513 : MBListSourceInstructionsV1
    public static final String NHENQUIRYPAUSECARDV1_STRING = 'NHENQUIRYPAUSECARDV1';
  public static final String NHUPDATEPAUSECARDV1_STRING = 'NHUPDATEPAUSECARDV1';
    public static final String PREDICTION_STRING = 'PREDICTION';
  public static final String CASA_CANCEL_RELATED_PARTY_V7 = 'CASACANCELRELATEDPARTYV7';
  public static final String CI_AUTH_RELATEDPARTY_V20 = 'CI_AUTH_RELATEDPARTY_V20';
    /**==============================================================================================================================
*System String Values
Contains the a String value of a system name
==============================================================================================================================**/
    public static final String SALESFORCE_STRING = 'Salesforce';
     public static final String CUSTOMER1_STRING = 'CUSTOMER1RB';
    public static final String SIEBEL_STRING = 'Siebel';
    public static final String CIF_STRING = 'CIF';
    public static final String CIF_LOWER = 'cif';
    public static final String ECASA_STRING = 'eCasa';
    public static final String ECASA_STRING_REF = 'eCasa Status Onboarding';
    public static final String NetReveal_STRING = 'NetReveal';
    public static final String CIB_STRING = 'CIB';
    public static final String WBIF_STRING = 'WBIF';
    public static final String ADAPT360_STRING = 'ADAPT360';
    public static final String ESP_STRING = 'ESPOnboarding';
    public static final String StopReplaceCard_STRING = 'StopReplaceCard';
    public static final String MLgetAcctBalanceIF42V1_STRING = 'MLgetAcctBalanceIF42V1';
    public static final String RESTEmailServiceIF42V1_STRING= 'RESTEmailServiceIF42V1';
    public static final String MBinitiatePaymentV10_STRING= 'MBinitiatePaymentV10IF42V1';
    public static final String nqcancelacctnotificationv1_STRING = 'nqcancelacctnotificationv1';
    public static final String SVcreateLinkSavingsDepAccount_STRING= 'SVcreateLinkSavingsDepAccountIF42V1';
    public static final String gPpaymReturnV1_STRING = 'gPpaymReturnV1';
    public static final String dSretrieveDebitsCreditsInqV2_STRING = 'dSretrieveDebitsCreditsInqV2';
    public static final String cclinkaccounttocombicardv3_STRING = 'cclinkaccounttocombicardv3';
    public static final String ccdelinkaccountsv1_STRING = 'ccdelinkaccountsv1';
    public static final String abfgetgeneraldetailsv2_STRING = 'abfgetgeneraldetailsv2';
    public static final String CIgetSpecialPowerOfAttorneyV4_STRING = 'CIgetSpecialPowerOfAttorneyV4';
    public static final String cigetgeneralpowerofattorneyv4_STRING = 'cigetgeneralpowerofattorneyv4';
    public static final String mlviewcomprehensivedetailsv1_STRING = 'mlviewcomprehensivedetailsv1';
    public static final String nqcreateneworaddrecipientv2_STRING = 'nqcreateneworaddrecipientv2';
    public static final String nqupdatenotificationsv1_STRING = 'nqupdatenotificationsv1';
    public static final String dSaddStopPaymentV2_STRING = 'dSaddStopPaymentV2';
    public static final String CAgetCassCacyEnqV1_STRING = 'CAgetCassCacyEnqV1';
    public static final String CAgetCassConsEnq_STRING = 'CAgetCassConsEnq';
    public static final String GET_BALANCE_STRING = 'GetAccountBalanceInformation';
    public static final String TOM_STRING = 'tom';
    public static final String Wqgetanalystcommentsv7_STRING = 'Wqgetanalystcommentsv7';// added by @Anka Ganta
    public static final String Generatedocumentsv7_STRING = 'Generatedocumentsv7';
    public static final String WQacknowledgedocumentsv1_STRING = 'WQacknowledgedocumentsv1';
    public static final String WQconfirmDocumentReceiptV2_STRING = 'WQconfirmDocumentReceiptV2';
    public static final String ESTPM_STRING = 'ESTPM GetBankerInfo ByCIF';  //added by @almas Aleem for ESTPM Service
    public static final String ITOUCH_STRING = 'iTouch';
    public static final String REGULATORYCOMPLIANCE_STRING = 'REGULATORYCOMPLIANCE';
    public static final String REFRESHREGULATORYCOMPLIANCE_STRING = 'REFRESHREGULATORYCOMPLIANCE';
    public static final String ADDACCOUNTTOPORTFOLIO_STRING = 'ADDACCOUNTTOPORTFOLIO';
    public static final String CIGETACCTLINKEDTOCLIENTCODE_STRING = 'CIGETACCTLINKEDTOCLIENTCODE';
    public static final String HLALLOCATESTOCKNUMBER_STRING = 'HLALLOCATESTOCKNUMBER';
    public static final String JOINTPARTICIPANT_STRING = 'JOINTPARTICIPANT';
    public static final String WBIF_AMCDF_PRODUCTGET_STRING = 'WBIF_AMCDF_PRODUCTGET';
    public static final String WILLS_SYSTEM = 'Wills';
    public static final String API_MANAGER = 'API Manager';
    public static final String EPS_STRING = 'EPS';
    public static final String ACCOUNT_TYPE = 'Account Type';
    public static final String AVS_STRING = 'AVS';
    public static final String VALIDATE_CLIENT_DETAILS_STRING = 'VALIDATECLIENTDETAILS';
    public static final String LISTTRACKERHISTORY_STRING = 'LISTTRACKERHISTORY';
    public static final String CREATEWILLRECORD_STRING = 'CREATEWILLRECORD';
    public static final String CREATETRACKERRECORD_STRING = 'CREATETRACKERRECORD';
    public static final String ASSETSLIABILITIES_STRING = 'ASSETSLIABILITIES';
    public static final String CASASCREENRELATEDPARTY_STRING = 'CASASCREENRELATEDPARTY';
    public static final String CASASCREENRELATEDPARTY_V6_STRING = 'CASASCREENRELATEDPARTY';
    public static final String JITTERBIT = 'Jitterbit';
    public static final String JITTERBIT2 = 'Jitterbit2';
    public static final String JITTERBIT_API = 'Jitterbit2';//MNEKHUBVI:20200220
    public static final String JITTERBIT_STRING = 'JitterbitTest';
    //public static final String JITTERBIT_STRING2 = 'Jitterbit3';
    public static final String API_MANAGER_ESTPM ='API Manager ESTPM'; //added by Almas Aleem for W-001774 estpm service
    public static final String XDS_Jitterbit ='Jitterbit Basic'; //added by Madhava Palla estpm service
    public static final String XDS_GetQuestions ='GetQuestions'; //added by Madhava Palla estpm service
    public static final String CMS_Get_AccountDeatils_STRING = 'CMS Get AccountDeatils';//added by Diksha
    public static final String XDS_SubmitQuestions ='SubmitXDSQuestions'; //added by Madhava Palla XDSSubmitQuestions service
    public static final String CQ_PAYMENT_DUE_STRING = 'CQGETPAYMENTDUE';// added by Haritha :CQGetPaymentDue
    public static final String GET_ACCOUNTBALANCE_DETAILS_STRING = 'GETSVACCOUNTBALANCEDETAILS';// added by HarithaP :SVGetAccountbalanceDetails
    public static final String CCISSUECOMBICARDV1_STRING = 'CCISSUECOMBICARDV1'; //Madhava Palla: CCissueCombiCardV1
    public static final String CASTPLOSTSTOLENCARDV2_STRING = 'CASTPLOSTSTOLENCARDV2'; //Madhava Palla: CAstpLostStolenCardV2
    public static final String CC_PREVALIDATION_STRING = 'CARDPREVALIDATION'; //Prasanna Patwardhan: CCpreValidationV2
    public static final String CAGETACCOUNTDETAILS_STRING = 'CAGETACCOUNTDETAILS'; //PJAIN:20190927: CAgetAccountDetails
    public static final String CA_GET_ACCOUNT_DETAILS = 'CA Get Account Details'; //PJAIN:20190927: CAgetAccountDetails
    public static final String CAGETCASSREPLACECARD_STRING = 'CAGETCASSREPLACECARD'; //PJAIN:20190927: CAgetCassReplaceCard
    public static final String CC_UPDATE_DAILY_LIMITS = 'CC Update Daily Limits'; //MNEKHUBVI:20191010: CCupdateDailyLimits
    public static final String CA_STP_LOSTSTOLENCARD_V2 = 'CAstpLostStolenCardV2'; //Madhava Palla: CAstpLostStolenCardV2
    public static final String CCGETDAILYLIMITS_STRING = 'CCGETDAILYLIMITS'; //PJAIN:20190911: CCgetDailyLimits
    public static final String JITTERBIT_API_WORKAROUND = 'JITTERBIT API RB';//MNEKHUBVI:20200220
    public static final String EXPERIANBUSINESSDETAILSGET_STRING = 'EXPERIANBUSINESSDETAILSGET'; //PJAIN:20191205: ExperianBusinessDetailsGet
    public static final String CPBVALIDATE_STRING = 'CPBVALIDATE'; //PJAIN:20200206: CPBValidate
    public static final String HANISVALIDATE_STRING = 'HANISVALIDATE'; //PJAIN:20200212: HanisValidate
    public static final String CQCREATEANDLINKACCOUNTV7_STRING = 'CQCREATEANDLINKACCOUNTV7'; //PJAIN:20200221: CQcreateAndLinkAccountV7
    public static final String SMGETASVBONDSV1_STRING = 'SMGETASVBONDSV1'; //PJAIN:20200303: sMgetAsVbondsV1
    public static final String JITTERBIT_API_RB_STRING = 'Jitterbit2'; //JITTERBIT API RB lulu
    public static final String VOICE_API_STRING = 'Voice Channel'; //ADDED BY MASHUDU RAIDIMI
    public static final String JITTERBIT_API_RB_STRING_TEST = 'JITTERBIT API RB'; //JITTERBIT API RB lulu
    public static final String CIUPDSIGNINGINSTRUCTIONSV5_STRING = 'CIUPDSIGNINGINSTRUCTIONSV5'; //PJAIN:20200225: CIupdSigningInstructionsV5
    public static final String CIGETSIGNINGINSTRUCTIONSV4_STRING = 'CIGETSIGNINGINSTRUCTIONSV4'; //PJAIN:20200305: CIgetSigningInstructionsV4
    public static final String IBGETBENEFICIARYV1_STRING = 'IBGETBENEFICIARYV1'; //Rudolf Niehaus: 20200319 : IBlistBeneficiariesV1
    public static final String MBUPDATEBENEFICIARIESV1_STRING = 'MBUPDATEBENEFICIARIESV1'; //Rudolf Niehaus: 20200320 : MBupdateInstructionV1
    public static final String CIGETCLIENTDETAILSBYNAMEV2_STRING = 'CIGETCLIENTDETAILSBYNAMEV2'; //Rudolf Niehaus: 20200319 : CIgetClientDetailsByNameV2
    public static final String MBDELETEBENEFICIARIESV2_STRING = 'MBDELETEBENEFICIARIESV2'; //Rudolf Niehaus: 20200320 : MBdeleteInstructionV2
    public static final String CCGETPORTFOLIODETAILV1_STRING = 'CCGetPortfolioDetailV1'; //PJAIN:20200316: CCGetPortfolioDetailV1
    public static final String SMGETASVCESSIONOFDEBTORSV1_STRING = 'SMGETASVCESSIONOFDEBTORSV1'; //PJAIN:20200303: sMgetAsvCessionOfDebtorsV1
    public static final String SMGETASVCESSIONOFPLEDGESV1_STRING = 'sMgetAsvCessionOfPledgesV1'; //PJAIN:20200303: sMgetAsvCessionOfPledgesV1
    public static final String SMGETASVCESSIONOFINVSTMNTV1_STRING = 'sMgetAsvCessionOfInvstmntV1'; //PJAIN:20200305: sMgetAsvCessionOfInvstmntV1
    public static final String SMGETASVCESSIONOFLPLINKEDV1_STRING = 'sMgetAsvCessionOfLPLinkedV1'; //PJAIN:20200305: sMgetAsvCessionOfLPLinkedV1
    public static final String SMGETASVCESSIONOFLPNOLINKV1_STRING = 'sMgetAsvCessionOfLPNoLinkV1'; //PJAIN:20200305: sMgetAsvCessionOfLPNoLinkV1
    public static final String SMGETASVCESSIONOFSCHEMESV1_STRING = 'sMgetAsvCessionOfSchemesV1'; //PJAIN:20200306: sMgetAsvCessionOfSchemesV1
    public static final String SMGETASVCESSIONOFSHARESV1_STRING = 'sMgetAsvCessionOfSharesV1'; //PJAIN:20200306: sMgetAsvCessionOfSharesV1
    public static final String SMGETASVCREDITLIFEPOLICYV1_STRING = 'sMgetAsvCreditLifePolicyV1'; //PJAIN:20200306: sMgetAsvCreditLifePolicyV1
    public static final String SMGETASVDEMATSHARESV1_STRING = 'sMgetAsvDematSharesV1'; //PJAIN:20200309: sMgetAsvDematSharesV1
    public static final String SMGETASVLETTERSV1_STRING = 'sMgetAsvLettersV1'; //PJAIN:20200309: sMgetAsvLettersV1
    public static final String SMGETASVSECURITYANDHOLDSV1_STRING = 'sMgetAsvSecurityAndHoldsV1'; //PJAIN:20200310: sMgetAsvSecurityAndHoldsV1
    public static final String SMGETASVSURETYSHIPSV1_STRING = 'SMGETASVSURETYSHIPSV1'; //PJAIN:20200303: sMgetAsvSuretyshipsV1
    public static final String CQ_UPDATEACC_DOMICILE_CHANGE_STRING = 'CqUpdAcctDomicileChangev2'; //Saurabh Pandey:20200407: CqUpdAcctDomicileChangev2
    public static final String MPSCREATEMASSACCOUNTV2_STRING = 'MPSCREATEMASSACCOUNTV2'; //PJAIN:20200508: MPScreateMASSAccountV2
    public static final String MPSCREATEMERCHANTPLANV1_STRING = 'MPSCREATEMERCHANTPLANV1'; //PJAIN:20200508: MpsCreateMerchantPlanv1
    public static final String MPSCREATEPOSHMERCHANTV3_STRING = 'MPSCREATEPOSHMERCHANTV3'; //PJAIN:20200508: MpsCreatePoshMerchantv3
    public static final String NHGETSENTPRODUCTNOTIFICATIONV1_STRING = 'NHgetSentProductNotificationV1'; //MNEKHUBVI:20200506: NHgetSentProductNotificationV1
    public static final String NHLISTSENTPRODUCTNOTIFICATIONSV1_STRING = 'NHlistSentProductNotificationsV1'; //MNEKHUBVI:20200506: nHlistSentProductNotificationsV1
    public static final String GBCREATECMSCONTOFFLINKV1_STRING = 'GbCreateCmsContOffLinkV1'; //Diksha Wasekar:20200415: GBcreateCmsContOffLinkV1
    public static final String CAMS_STRING = 'CAMS'; //Diksha Wasekar:20200415: GBcreateCmsContOffLinkV1

     // Added by Ravi   
    public static final String INTEGRATION_ADJWORKINGCAPNEED_STRING = 'AdjustedWorkingCapitalNeed';
    public static final String INTEGRATION_AVGINVPROCESSPERIOD_STRING = 'AdjustedAverageInventoryProcesssingPeriod';
    public static final String INTEGRATION_AVGRECCOLLPERIOD_STRING = 'AdjustedAverageReceivableCollectionPeriod';
    public static final String INTEGRATION_AVGPAYABLEPAYPERIOD_STRING = 'AdjustedPayablesPaymentPeriod';
    // Added By Amit
    public static final String INTEGRATION_PROCESSDATA_STRING = 'ProcessData';
   
    /**==============================================================================================================================
*Status Code String Values
Contains the a String combination of status code and status
==============================================================================================================================**/
    public static final String STATUS_CODE_200 = '200 OK';
    public static final String STATUS_CODE_201 = '201 Created';
    public static final String STATUS_CODE_400 = '400 Bad Request';
    public static final String STATUS_CODE_406 = '406 Not Acceptable';
    public static final String STATUS_CODE_500 = '500 Internal Server Error';

    /**==============================================================================================================================
*Message String Values
Contains the String values of Error messages that is displayed or logged
Contains the String values of Positive Respone Messages that is displayed or logged
==============================================================================================================================**/

    //Error Message Strings
    public static final String ERROR_MSG_INVALID_HEADER = 'Invalid header values sent';
    public static final String ERROR_MSG_INVALID_PARAMETER = 'Invalid parameters sent';
    public static final String ERROR_MSG_COULD_NOT_CREATE_RECORD = 'Failed - Could not create a new record: ';
    public static final String ERROR_MSG_COULD_NOT_UPDATE_RECORD = 'Failed - Could not update/found a case record: ';
    public static final String ERROR_MSG_COULD_NOT_FIND_OPPORTUNITY = 'Failed - Could not find opportunity: ';
    public static final String ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_NONE = 'Could not create a new account as an Advisor on Salesforce could not be found with BRID Number: ';
    public static final String ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_MULTIPLE = 'Could not create a new account as an Advisor on Salesforce. Found multiple users with BRID Number: ';
    public static final String ERROR_MSG_COULD_NOT_FIND_ASSET_FROM_Will_NUMBER_NONE = 'Could not find a existing asset on Salesforce with Will Number: ';
    public static final String ERROR_MSG_FIND_ASSET_FROM_Will_NUMBER_MULTIPLE = 'Found multiple existing asset on Salesforce with Will Number: ';
    public static final String ERROR_MSG_COULD_NOT_CREATE_OPP_MULTIPLE_ACC_FOUND = 'Could not create a new opportunity as multiple accounts were found with ID Number: ';
    public static final String ERROR_MSG_MULTIPLE_MAPPING_MDT_FOUND = 'Multiple Siebel_Integration_Setting__mdt Found: ';
    public static final String ERROR_MSG_NO_INTEGRATION_SETTINGS_MDT_FOUND = 'No Integration_Setting__mdt Found. ';
    public static final String ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND = 'No Integration_API__c / Integration_Service__c Records Found For This Service. ';
    public static final String ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND = 'No General_Virtual_Advisor_Rules__mdt Found. ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_OPP = 'Unable to find Opportunity: ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_ACCOUNT = 'Unable to find Account: ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_CONTACT = 'Unable to find Contact: ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_USER = 'Unable to find User: ';
    public static final String ERROR_MSG_COULD_NOT_UPDATE_OPP_MULTIPLE_OPPS_FOUND = 'Cloud not update the opportunity as multiple Opportunities were found: ';
    public static final String ERROR_MSG_MULTIPLE_ENVIRONMENTS_FOUND = 'Multiple Environments Found';
    public static final String ERROR_MSG_NO_ENVIRONMENT_FOUND = 'No Environment Found';
    public static final String ERROR_MSG_UNABLE_TO_MAP_SIEBEL_STAGE_NAME_VALUE = 'Unable to map resonWonLost parameter to Stage Name Siebel value: ';
    public static final String ERROR_MSG_UNEXPECTED_STATUS_CODE = 'The status code returned was not expected: ';
    public static final String UNHANDLED_EXCEPTION_STATUS = 'Exception';
    public static final String UNHANDLED_EXCEPTION_MESSAGE = 'Exception: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_SIEBEL_OPP_PRODUCT_VALUE = 'Unable to map Opportuntity Product to Siebel value: ';
    public static final String ERROR_MSG_READ_TIMED_OUT = 'Read timed out';
    public static final String ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_STATUS = 'Unable to map Occupation_Status__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION = 'Unable to map Occupation__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_CATEGORY = 'Unable to map Occupation_Category__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE = 'Unable to map Income_Source__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_NATIONALITY = 'Unable to map Nationality__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_MARITAL_STATUS = 'Unable to map Marital_Status__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_MARITAL_CONTRACT_TYPE = 'Unable to map Marital_Contract_Type__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE = 'Unable to map Country_of_Residence__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_COUNTRY_REGISTRATION = 'Unable to map Country_of_Registration__c from Account to the external value: ';
  public static final String ERROR_MSG_UNABLE_TO_MAP_COUNTRY_INCORPORATION = 'Unable to map Country_of_Incorporation__c from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE_BUSINESS = 'Unable to map Country_of_Residence__c from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_COUNTRY_BIRTH = 'Unable to map Country_of_Birth__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_IDENTITY_TYPE = 'Unable to map ID_Type__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_QUOTE_LINE_ITEMS = 'There are no QuoteLineItems for this Opportunity: ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_OPPORTUNITY_LINE_ITEMS = 'There are no OpportunityLineItems for this Opportunity: ';
    public static final String ERROR_MSG_UNABLE_TO_FIND_OPPORTUNITY_PARTIES = 'There are no Opportunity Parties for this Opportunity: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_WBIF_PERSON_TITLE = 'Unable to map PersonTitle from Account to the external value WBIF: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_EMAIL_OPTED_OUT = 'Unable to map PersonHasOptedOutOfEmail from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_HOME_LANGUAGE = 'Unable to map Home_Language__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_COMMUNICATION_LANGUAGE = 'Unable to map Communication_Language__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_OCCUPATION = 'Unable to map Occupation__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_OCCUPATION_STATUS = 'Unable to map Occupation_Status__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_INCOME_SOURCE = 'Unable to map Income_Source__pc from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_TITLE = 'Unable to map PersonTitle from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_TITLE_CONTACT = 'Unable to map Title from Contact to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_CLIENT_TYPE = 'Unable to map Client_Type__c from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_CLIENT_GROUP = 'Unable to map Client_Group__c from Account to the external value: ';//Anka Ganta
    public static final String ERROR_MSG_UNABLE_TO_MAP_GENDER = 'Unable to map Gender__c from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_COMMUNICATION_METHOD = 'Unable to map Communication_Method__c from Account to the external value: ';
    public static final String ERROR_MSG_UNABLE_TO_MAP_MARKETING_OPT_OUT = 'Unable to map FinServ__MarketingOptOut__pc from Account to the external value: ';
    public static final String ERROR_MSG_REQUEST_BODY_BLANK = 'The request body is blank/null';
    public static final String ERROR_MSG_REQUIRED_FIELD_MISSING = 'The following required field is missing: ';
    public static final String ERROR_MSG_CANT_FIND_TASK_REF_ID = 'Unable to find Task by Reference ID: ';
    public static final String ERROR_MSG_NO_WILL_NUMBER = 'Will number is null or empty';
    public static final String ERROR_MSG_NO_LEAD_NUMBER = 'Lead Number not found';
    public static final String ERROR_MSG_LEAD_NUMBER_AND_OPPSTAGE_REQUIRED = 'Lead Number or opportunity stage required';
    public static final String ERROR_MSG_INVALID_OPP_STAGE = 'Invalid opportunity stage! Valid opportunity stages(Rejected or Completed)';
    public static final String ERROR_MSG_CLASSIFY_FINDCLIENT = 'Please classify and link this case to an Account before closing the Case'; //added by Haritha for close case issue used in EmailmessageTriggerFunction.cls
    public static final String ERROR_MSG_SLAOVERDUE = 'Please select and Out of SLA Reason and provide Out of SLA Comments before closing the Case'; //added by Haritha for close case issue used in EmailmessageTriggerFunction.cls
    public static final String ERROR_MSG_XDS_NO_ID_FOUND = 'Authentication not available for this client , proceed with manual authentication and manual creation of verication code. ';
    //Positive Message Response Strings
    public static final String MSG_CLIENT_EXISTS_OPP_CREATED = 'Client already exists; successfully created new opportunity';
    public static final String MSG_CLIENT_CREATED_OPP_CREATED = 'Client does not exist and was created successfully; successfully created new opportunity';
    public static final String MSG_ASSET_EXISTS_DOC_REF_CREATED = 'Asset already exists; successfully created new document record';
    public static final String MSG_CLIENT_OPP_ALREADY_UPDATE = 'Opportunity already update';
    public static final String MSG_CLIENT_OPP_UPDATE = 'successfully updated opportunity';

    //Positive Message Response Strings TOM
    public static final String MSG_CASE_UPDATE_FROM_TOM = 'successfully updated tom Feedback to case';
    public static final String METHOD_MLgetOnlineStatementDetailIF42V1_GET_STATUS = 'MLgetOnlineStatementDetail_IH_v1.callToMLgetOnlineStatementDetail';

    // Messages displaying during Stop and Replace Card job
    public static final String Sevice500InternalErrorMessage ='We cannot complete the request now, please try again if error persist contact administrator.';//Added by Madhava
    public static final String NoCIFKeyPresentForAccount ='CIF not found for the Account';// Added by Madhava
    public static final String NoActiveCardsPresentForClient ='There is currently no active cards to display';// Added by Madhava
    public static final String ACCOUNT_STRING ='Account';// Added by Anka Ganta

    public static final String NON_INDIVIDUAL_STRING ='Non Individual';// Added by Anka Ganta
    public static final String RESIDENTIAL_STRING ='Residential';// Added by Anka Ganta
    public static final String PHYSICAL_ADDR_STRING ='Physical Address';// Added by Anka Ganta
    public static final String POSTAL_STRING ='Postal';// Added by Anka Ganta
   public static final String REGISTERED_ADDR_STRING ='Registered'; //TdB - For new Non Individual CIF nad CVS Mappings
    public static final String HEAD_OFFICE_ADDR_STRING ='Head Office'; //TdB - For new Non Individual CIF nad CVS Mappings
    public static final String BUSINESS_ADDR_STRING ='Business Address'; //TdB - For new Non Individual CIF nad CVS Mappings
    public static final String EMPLOYER_ADDR_STRING = 'Employers'; //Added for CVS Validation Address
    public static final String EDD_level_ll_report_STRING = 'Adverse Media Report'; //Anka Ganta - W-005017
    public static final String Management_sign_off_STRING = 'Senior Management Sign off'; //Anka Ganta - W-005017
    public static final String POS_of_Income_funds_STRING = 'Source of Funds/Wealth'; //Anka Ganta - W-005017
    public static final String FSP_Licence_STRING = 'FSP Licence';
    /**==============================================================================================================================
*Class.Method Decleration String Values
Contains the string value of a Class.Method decleration for tracing from where it's called
==============================================================================================================================**/
    public static final String METHOD_INTEGRATION_UTILITIES_SERVICE_CALLOUT = 'IntegrationUtilities.serviceCallout';
    public static final String METHOD_CREATE_OPP_REST = 'CreateOpportunity_ApiRest_v1.createOpportunity';
    public static final String METHOD_UPDATE_CASE_REST = 'UpdateComplaint_ApiRest_v1.updateComplaint';
    public static final String METHOD_UPDATE_OPP_REST = 'UpdateOpportunity_ApiRest_v1.updateOpportunity';
    public static final String METHOD_CREATE_ECM_DOC_REF_REST = 'CreateDocument_ApiRest_v1.createDocument';
    public static final String METHOD_UPDATE_LEAD_STATUS_SIEBEL = 'UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel';
    public static final String METHOD_GET_RISK_PROFILE = 'GetRiskProfileClient_IH_v1.getRiskProfileClient';
    public static final String METHOD_GET_RISK_PROFILE_V2 = 'GetRiskProfileClient_IH_v2.getRiskProfileClient';
    public static final String METHOD_GET_BANK_CLEARANCE_CODES = 'GetBankClearanceCodes_IH_v1.getBankClearanceCodes';
    public static final String METHOD_CHECK_DIGIT_VERIFICATION = 'CheckDigitVerification_IH_v1.checkDigitVerification';
    public static final String METHOD_INSERT_UPDATE_PRI = 'InsertOrUpdatePRICASA_IH_v1.insertOrUpdatePRICASA';
    public static final String METHOD_WBIF_ORCHESTRATION = 'WBIF_IH_v1.executeWBIFOrchestration';
    public static final String METHOD_WBIF_POLICY_CREATE = 'WBIF_IH_v1.policyCreate';
    public static final String METHOD_WBIF_CALCULATE = 'WBIF_IH_v1.calculate';
    public static final String METHOD_WBIF_ADD_BENEFIT = 'WBIF_IH_v1.addBenefit';
    public static final String METHOD_WBIF_ADD_DEPENDENT_SPOUSE = 'WBIF_IH_v1.addDependent SPOUSE';
    public static final String METHOD_WBIF_ADD_DEPENDENT_CHILD = 'WBIF_IH_v1.addDependent CHILD';
    public static final String METHOD_WBIF_ADD_BENEFICIARY = 'WBIF_IH_v1.addBeneficiary';
    public static final String METHOD_WBIF_VALIDATE_POLICY = 'WBIF_IH_v1.validatePolicy';
    public static final String METHOD_WBIF_SUBMIT_POLICY = 'WBIF_IH_v1.submitPolicy';
    public static final String METHOD_CASA_PRIMARY_CLIENT_SCREENING = 'CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreening';
    public static final String METHOD_CASA_PRIMARY_CLIENT_SCREENING_V2 = 'CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening';
    public static final String METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3 = 'CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc';
    public static final String METHOD_CASA_PRIMARY_CLIENT_SCREENING_JOINT = 'CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient';
    public static final String METHOD_ADAPT360_RETRIEVE_CLIENT_DETAILS = 'ADAPT360_IH_v1.retrieveClientDetails';
    public static final String METHOD_ESP_GET_ESP_STATUS = 'ESPOnboarding_IH_v1.callToESPOnboarding';
    public static final String METHOD_SVcreateLinkSavingsDepAccount_GET_STATUS = 'SVcreateLinkSavingsDepAccount_IH_v1.callToSVcreateLinkSavingsDepAccount';
    public static final String METHOD_MLgetAcctBalanceIF42V1_GET_STATUS = 'MLgetAcctBalance_IH_v1.callToMLgetAcctBalance';
    public static final String METHOD_ABSAOnlineStatementSearch_GET_STATUS = 'ABSAOnlineStatementSearch_IH_v1.callToABSAOnlineStatementSearch';
    public static final String METHOD_MBinitiatePaymentV10_GET_STATUS = 'MBinitiatePaymentV10_IH_v1.callToMBinitiatePaymentV10';
    public static final String METHOD_nqcancelacctnotificationv1_GET_STATUS = 'nqcancelacctnotificationv1_IH_v1.callTonqcancelacctnotificationv1';
    public static final String METHOD_dSretrieveDebitsCreditsInqV2_GET_STATUS = 'dSretrieveDebitsCreditsInqV2_IH_v1.callTodSretrieveDebitsCreditsInqV2';
    public static final String METHOD_dSaddStopPaymentV2_GET_STATUS = 'dSaddStopPaymentV2_IH_v1.callTodSaddStopPaymentV2';
    public static final String METHOD_cclinkaccounttocombicardv3 = 'cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3';
    public static final String METHOD_ccdelinkaccountsv1 = 'ccdelinkaccountsv1_IH_v1.getccdelinkaccountsv1';
    public static final String METHOD_abfgetgeneraldetailsv2 = 'abfgetgeneraldetailsv2_IH_v1.getabfgetgeneraldetailsv2';
    public static final String METHOD_CIgetSpecialPowerOfAttorneyV4 = 'CIgetSpecialPowerOfAttorneyV4_IH_v1.getCIgetSpecialPowerOfAttorneyV4';
    public static final String METHOD_cigetgeneralpowerofattorneyv4 = 'cigetgeneralpowerofattorneyv4_IH_v1.getcigetgeneralpowerofattorneyv4';
    public static final String METHOD_mlviewcomprehensivedetailsv1 = 'mlviewcomprehensivedetailsv1_IH_v1.getmlviewcomprehensivedetailsv1';
    public static final String METHOD_gPpaymReturnV1_GET_STATUS = 'gPpaymReturnV1_IH_v1.callTogPpaymReturnV1';
    public static final String METHOD_nqcreateneworaddrecipientv2_GET_STATUS = 'nqcreateneworaddrecipientv2_IH_v1.callTonqcreateneworaddrecipientv2';
    public static final String METHOD_nqupdatenotificationsv1_GET_STATUS = 'nqupdatenotificationsv1_IH_v1.callTonqupdatenotificationsv1';
    public static final String METHOD_ABSAOnlineStatementDownload_GET_STATUS = 'ABSAOnlineStatementDownload_IH_v1.callToABSAOnlineStatementDownload';
    public static final String METHOD_RESTEmailServiceIF42V1_GET_STATUS = 'RESTEmailService_IH_v1.callToRESTEmailService';
    public static final String METHOD_CAgetCassCacyEnqV1_GET_STATUS = 'CAgetCassCacyEnqV1.callToCAgetCassCacyEnqV1';
    public static final String METHOD_CAgetCassConsEnq_GET_STATUS = 'CAgetCassConsEnq.callToCAgetCassConsEnq';
    public static final String METHOD_TOM_GET_TOM_STATUS = 'TOMComplaint_IH_v1.callToTOMComplaint';
    public static final String METHOD_Wqgetanalystcommentsv7 = 'Wqgetanalystcommentsv7_IH_v1.getCasaAnalystComments';
    public static final String METHOD_Generatedocumentsv7 = 'Generatedocumentsv7_IH_v1.generateDocuments';
    public static final String METHOD_WQacknowledgedocumentsv1 = 'WQacknowledgedocumentsv1_IH_v1.acknowledgeDocuments';
    public static final String METHOD_WQconfirmDocumentReceiptV2 = 'WQconfirmDocumentReceiptV2.confirmDocumentReceipt';
    public static final String METHOD_GET_CLIENT_DETAILS = 'GetClientDetails_IH_v1.getClientDetails';
    public static final String METHOD_SMS_SUBMIT = 'SMSGateway_IH_v1.submit';
    public static final String METHOD_REG_SER_INVOLVED_PARTIES = 'RegSer_InvolvedParties_IH_v1.getInvlovedParties';
    public static final String METHOD_REGULATORY_COMPLIANCE_GET_INFO = 'GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo';
    public static final String METHOD_UPDATE_CIF_INFO = 'getUpdateCIF_IH_v1.getCIFResponse'; //Added by Mohammed for Attestation
    public static final String CIFUPDATE_STRING = 'UPDATECIF'; //Added by Mohammed for Attestion
    public static final String METHOD_REGULATORY_COMPLIANCE_REFRESH_INFO = 'RefreshRegulatoryCompliance_IH_v1.refreshRegulatoryComplianceInfo';
    public static final String METHOD_ADD_ACCOUNT_TO_PORTFOLIO = 'AddAccountToPortfolio_IH_v1.AddAccountToPortfolio';
    public static final String METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE = 'CIgetAcctLinkedToClientCode_IH_v1.CIgetAcctLinkedToClientCode';
    public static final String METHOD_HLALLOCATE_STOCK_NUMBER = 'HLallocateStockNumber_IH_v1.hlAllocateStockNumber';
    public static final String METHOD_JOINT_PARTICIPANT_GET = 'GetJointParticipant_IH_v1.getJointParticipant';
    public static final String METHOD_SMS_NOTIFICATION = 'SMSGateway_Notification_ApiRest_v1.smsNotification';
    public static final String METHOD_SMS_REPLY = 'SMSGateway_Reply_ApiRest_v1.smsReply';
    public static final String METHOD_WBIF_AMCDF_PRODUCTGET = 'WBIF_AMCDF_ProductGet_IH_v1.getProduct';
    public static final String METHOD_CREATE_CLIENT_CIF = 'CreateClientCIF_IH_v1.createClient';
    public static final String METHOD_UPDATE_CLIENT_DETAILS_CIF = 'UpdateClientDetailsCIF_IH_v1.updateClientDetails';
    public static final String METHOD_GET_WILL_DETAILS = 'GetWillDetails_IH_v1.getWillDetails';
    public static final String METHOD_ACCOUNT_VERIFICATION = 'AccountVerification_IH_v1.accountVerification';
    public static final String METHOD_CREATE_INSTRUCTION = 'CreateInstruction_IH_v1.CreateInstruction';
    public static final String METHOD_MBCREATE_INSTRUCTION = 'CreateInstruction_IH_v1.MBcreateInstruction';
    public static final String METHOD_BENEFICIARY_DETAILS = 'GetBeneficiaryDetails_IH_v1.beneficiaryDetails';//added by Mashudu Raidimi
    public static final String METHOD_CQ_GET_ACCOUNT_HOLDS = 'CQgetAcctHoldsMaintV4_IH_v1.callTocqgetacctholdsmaintv4';//added by Mashudu Raidimi
    public static final String METHOD_CQ_VAL_ACCOUNT_HOLDS = 'CQvalAcctHoldsV4_IH_v1.callTocqvalacctholdsv4';//added by Mashudu Raidimi
    public static final String METHOD_CQ_UPDATE_ACCOUNT_HOLDS = 'CQupdAcctHoldsV4_IH_v1.callTocqupdacctholdsv4';//added by Mashudu Raidimi
    public static final String METHOD_SV_UPDATE_ACCOUNT_HOLDS = 'SVupdateAccountHoldsV4_IH_v1 .callTosvupdateaccountholdsV4';//added by Mashudu Raidimi
    public static final String METHOD_ACCOUNT_HOLDS_DETAILS = 'SVgetAccountHoldsDetailV4_IH_v1.callTosvgetaccountholdsdetailv4';//added by Mashudu Raidimi
    public static final String METHOD_CMS_GET_BANKERINFO = 'CMSGetBankerInfo_IH_v1.getBankerDeatils'; // added by Diksha
    public static final String METHOD_DOCFUSION_CREATE_DOCUMENT = 'DocFusion_CreateDocument_IH_v1.createDocFusionDocument';
    public static final String METHOD_UPDATE_WILL_DETAIL = 'UpdateWillsDetails_IH_v1.updateWillsDetails';
    public static final String METHOD_VALIDATE_CLIENT_DETAILS = 'CvsValidationService_IH_v1.validateClient';
    public static final String METHOD_LIST_TRACKER_HISTORY = 'RetrieveTrackerStatus_IH_v1.getRetrieveTrackerStatus';
    public static final String METHOD_CREATE_WILL_RECORD = 'CreateWillRecord_IH_v1.createRecord';
    public static final String METHOD_CREATE_TRACKER_RECORD = 'CreateTracker_IH_v1.createTracker';
    public static final String METHOD_CREATE_WILL_BANKING = 'CreateWillBankingDetails_IH_v1.createWillBankingDetails';
    public static final String METHOD_GET_WILL_BANKING = 'GetWillBankingDetails_IH_v1.getWillBankingDetails';
    public static final String METHOD_UPDATE_WILL_BANKING = 'UpdateWillBankingDetails_IH_v1.updateWillBankingDetails';
    public static final String METHOD_CREATE_ASSETS_LIABILITIES = 'CreateAssetsLiabilities_IH_v1.createAssetsLiability';
    public static final String METHOD_GET_ASSETS_LIABILITIES = 'GetAssetsLiabilities_IH_v1.getAssetsLiability';
    public static final String METHOD_CASA_SCREEN_RELATED_PARTY = 'CASAScreenRelatedParty_IH_v1.screenRelatedParty';
    public static final String METHOD_CASA_SCREEN_RELATED_PARTY_V6 = 'CASAScreenRelatedParty_IH_v2.screenRelatedParty';
    public static final String METHOD_RISK_PROFILE_JNT_CLIENT = 'RiskProfileJointClient_IH_v1.riskProfileJntClient';
    public static final String METHOD_UPD_JNT_PART_BY_CLIENT_CODE = 'UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCode';
    public static final String METHOD_GET_FILING_ADDRESS = 'GetFilingAddress_IH_v1.getFilingAddress';
    public static final String METHOD_GET_XML_WILL_DRAFT = 'GetXmlWillDraft_IH_v1.getXmlWillDraft';
    public static final String METHOD_SAVE_XML_WILL_DRAFT = 'SaveXmlWillDraft_IH_v1.saveXmlWillDraft';
    public static final String METHOD_DEBIT_ORDER_INSTRUCTION = 'DebitOrderInstruction_IH_v1.debitOrderInstruction';
    public static final String METHOD_GET_ACCOUNT_DETAILS_VIA_REFERENCE = 'GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef';
    public static final String METHOD_GET_CLIENT_HOLDS = 'GetClientHolds_IH_v1.getClientHolds'; // W-002572 Added by Almas Aleem
    public static final String METHOD_ESTPM_GET_BANKERINFO_STATUS = 'ESTPMGetBankerInfo_IH_v1.getBankerInfoByCIFNumber'; // W-001774 Added By Almas Aleem For estpm service
    public static final String METHOD_XDS_GET_QUESTIONS_STATUS = 'XDSGetQuestions_IH_v1.callToXDSGetQuetionsService';// Added by Madhava Palla for XDS Intigration Service
    public static final String METHOD_GET_CQ_ACCOUNT_DETAILS = 'CQgetAcctBalanceDetailV4_IU_v1.getCQAccountDetails';// Added by Muvhuso for Get CQ Account Details
    public static final String METHOD_SV_GET_ACCOUNT_HOLDS = 'SVgetAccountHoldsDetailV4_IH_v1.callTosvgetaccountholdsdetailv4';//added by Mashudu Raidimi
    public static final String METHOD_EI_MAINTAIN_ESD_DETAILSV3 = 'EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3'; //MNEKHUBVI:20200407: sImaintainESDDetailsV3
    public static final String METHOD_VAPM_GET_CUSTOMER_SUMMARY = 'GetCustomerVAPMSummary_IU_v1.getCustomerVAPMSummary'; // added by Muvhuso
    public static final String METHOD_XDS_SUBMIT_QUESTIONS_STATUS = 'XDSSubmitQuestions_IH_v1.callToXDSSubmitQuetionsService';// Added by Madhava Palla for XDS Intigration Service
    public static final String METHOD_GET_CQ_PAYMENT_DUE = 'CQgetPaymentDue_IH_V1.getCQPaymentDueResponseDetails';//Added by HarithaP :CQGetPaymentDue
    public static final String METHOD_SM_GET_ASV_BONDS_V1 = 'sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1'; //PJAIN:20200303: sMgetAsVbondsV1
    public static final String METHOD_CA_GET_ACCOUNT_DETAILS = 'CAgetAccountDetails_IH_v1.CAgetAccountDetails'; //PJAIN:20190927: CAgetAccountDetails
    public static final String METHOD_CA_STP_LOSTSTOLENCARD_V2 = 'CAstpLostStolenCardV2_IH_v5.CAstpLostStolenCardV2'; //Madhava Palla: CAstpLostStolenCardV2
    public static final String METHOD_CC_GET_DAILY_LIMITS = 'CCupdDailyTransactionLimitsV2_IH_v1.CCupdateDailyLimits'; //MNEKHUBVI:20191010: CCgetDailyLimits
    //public static final String MB_COMPL_EPS_PAYMENT = 'mbcomplepspaymentv4'; //Added by Lulu mBcomplEpSpaymentV4
    public static final String VALIDATE_CARD_REPLACEMENT = 'Validate Card Replacement'; //Added by Lulu mBcomplEpSpaymentV4
    public static final String CCCLOSE = 'CCcloseV2'; //Added by Lulu
    public static final String CCISSUECOMBICARD = 'CCissue Combi CardV1'; //Added by Lulu
    public static final String METHOD_IB_CANCEL_SERVICE= 'IBCancelService_IH_v1.cancelService';//Added by Lulu
    public static final String METHOD_CA_GETCASSACCPAYOFF_V1= 'CAGetCassaccPayoffv1_IH_v1.cagetCassaccPayoffv1';//Added by Lulu
    public static final String METHOD_CC_UPDATE_DAILY_LIMITS = 'CCgetDailyLimits_IH_v1.CCgetDailyLimits'; //PJAIN:20190911: CCupdateDailyLimits
    public static final String METHOD_RETRI_DEBIT_CARD_V1 = 'DSretrieveDebitsCreditsInqV1_IH_v1.DSretrieveDebitsCreditsInqV1Details'; //Prasanna Patwardhan: DSretrieveDebitsCreditsInqV1
    public static final String METHOD_EXPERIAN_BUSINESS_DETAILS_GET = 'ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet'; //PJAIN:20191205: ExperianBusinessDetailsGet
    public static final String METHOD_CPB_VALIDATE = 'CPBValidate_IH_v1.CPBValidate'; //PJAIN:20200206: CPBValidate
    public static final String METHOD_HANIS_VALIDATE = 'HanisValidate_IH_v1.HanisValidate'; //PJAIN:20200212: HanisValidate
    public static final String METHOD_CQ_CREATE_AND_LINK_ACCOUNT_V7 = 'CQcreateAndLinkAccountV7_IH_v1.CQcreateAndLinkAccountV7'; //PJAIN:20200221: CQcreateAndLinkAccountV7
    public static final String METHOD_CI_UPD_SIGNING_INSTRUCTIONS_V5 = 'CIupdSigningInstructionsV5_IH_v1.CIupdSigningInstructionsV5'; //PJAIN:20200225: CIupdSigningInstructionsV5
    public static final String METHOD_CI_GET_SIGNING_INSTRUCTIONS_V4 = 'CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4'; //PJAIN:20200305: CIgetSigningInstructionsV4
    public static final String METHOD_IB_GET_BENEFICIARY_V1 = 'IBlistBeneficiariesV1_Req_IB_v1.IBlistBeneficiariesV1'; //Rudolf Niehaus: 20200319 : IBlistBeneficiariesV1
    public static final String METHOD_MB_UPDATE_BENEFICIARIES_V1 = 'MBupdateInstructionV1_Req_IB_v1.MBupdateInstructionV1'; //Rudolf Niehaus: 20200320 : MBupdateInstructionV1
    public static final String METHOD_MB_DELETE_BENEFICIARIES_V2 = 'MBdeleteInstructionV2_Req_IB_v1.MBdeleteInstructionV2'; //Rudolf Niehaus: 20200320 : MBdeleteInstructionV2
    public static final String METHOD_GET_TRANSACTION_HISTORY = 'CIgetTransactionHistory_IH_v1.transactionHistory';//added by Mashudu Raidimi
    public static final String METHOD_CC_GET_PORTFOLIO_DETAIL_V1 = 'CCGetPortfolioDetailV1_IH_v1.CCGetPortfolioDetailV1'; //PJAIN:20200316: CCGetPortfolioDetailV1
    public static final String METHOD_MB_COMPL_EPS_PAYMENT = 'MBcomplEpSpaymentV4_IH_v1.mbcomplepspaymentv4'; // added by Lulu
    public static final String METHOD_VALIDATE_CARD_REPLACEMENT = 'ValidateCardReplacementV1_IH_v1.validateCardReplacement';
    public static final String METHOD_CCCLOSE = 'CCcloseV2_IH_v1.closeCombiCard';
    public static final String METHOD_CC_ISSUE_COMBI_CARD = 'CCissueCombiCard_IH_v1.issueCombiCard';
    public static final String METHOD_SM_GET_ASV_CESSION_OF_DEBTORS_V1 = 'sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1'; //PJAIN:20200303: sMgetAsvCessionOfDebtorsV1
    public static final String METHOD_SM_GET_ASV_CESSION_OF_PLEDGES_V1 = 'sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1'; //PJAIN:20200303: sMgetAsvCessionOfPledgesV1
    public static final String METHOD_SM_GET_ASV_CESSION_OF_INVSTMNT_V1 = 'sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1'; //PJAIN:20200305: sMgetAsvCessionOfInvstmntV1
    public static final String METHOD_SM_GET_ASV_CESSION_OF_L_P_LINKED_V1 = 'sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1'; //PJAIN:20200305: sMgetAsvCessionOfLPLinkedV1
    public static final String METHOD_SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1 = 'sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1'; //PJAIN:20200305: sMgetAsvCessionOfLPNoLinkV1
    public static final String METHOD_SM_GET_ASV_CESSION_OF_SCHEMES_V1 = 'sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1'; //PJAIN:20200306: sMgetAsvCessionOfSchemesV1
    public static final String METHOD_SM_GET_ASV_CESSION_OF_SHARES_V1 = 'sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1'; //PJAIN:20200306: sMgetAsvCessionOfSharesV1
    public static final String METHOD_CI_GET_CLIENTDETAILS_BY_NAME_V2 = 'CIgetClientDetailsByNameV2_Req_IB_v1.CIgetClientDetailsByNameV2'; //Rudolf Niehaus: 20200319 : CIgetClientDetailsByNameV2
    public static final String METHOD_SM_GET_ASV_CREDIT_LIFE_POLICY_V1 = 'sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1'; //PJAIN:20200306: sMgetAsvCreditLifePolicyV1
    public static final String METHOD_SM_GET_ASV_DEMAT_SHARES_V1 = 'sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1'; //PJAIN:20200309: sMgetAsvDematSharesV1
    public static final String METHOD_SM_GET_ASV_LETTERS_V1 = 'sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1'; //PJAIN:20200309: sMgetAsvLettersV1
    public static final String METHOD_SM_GET_ASV_SECURITY_AND_HOLDS_V1 = 'sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1'; //PJAIN:20200310: sMgetAsvSecurityAndHoldsV1
    public static final String METHOD_SM_GET_ASV_SURETYSHIPS_V1 = 'sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1'; //PJAIN:20200303: sMgetAsvSuretyshipsV1
    public static final String METHOD_SM_GET_ASV_EXTERNAL_INVESTMENTS_V1 = 'sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment'; //NMUVHUSO:20200309: SMgetASVCessionOfExternalInvestmentsV1
    public static final String METHOD_SM_GET_ASV_SHORT_TERM_INSURANCE_V1 = 'SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortTermInsuranceV1'; //NMUVHUSO:20200309: SMgetASVCessionOfFireShortTermInsuranceV1
    public static final String METHOD_SM_GET_ASV_OUTSTANDINGS_SECURITY_HOLDS_V1 = 'SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortTermInsuranceV1'; //NMUVHUSO:20200309: SMgetASVCessionOfFireShortTermInsuranceV1
    public static final String METHOD_SM_GET_ASV_GENERAL_SESSION_V1 = 'sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1'; //NMUVHUSO:20200309: sMgetAsvGeneralCessionsV1
    public static final String METHOD_CQ_UPDATEACC_DOMICILE_CHANGE = 'CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2'; //Saurabh Pandey:20200407: CqUpdAcctDomicileChangev2
    public static final String METHOD_MPS_CREATE_MASS_ACCOUNT_V2 = 'MPScreateMASSAccountV2_IH_v1.MPScreateMASSAccountV2'; //PJAIN:20200508: MPScreateMASSAccountV2
    public static final String METHOD_MPS_CREATE_MERCHANT_PLAN_V1 = 'MpsCreateMerchantPlanv1_IH_v1.MpsCreateMerchantPlanv1'; //PJAIN:20200508: MpsCreateMerchantPlanv1
    public static final String METHOD_MPS_CREATE_POSH_MERCHANT_V3 = 'MpsCreatePoshMerchantv3_IH_v1.MpsCreatePoshMerchantv3'; //PJAIN:20200508: MpsCreatePoshMerchantv3
    public static final String METHOD_NHGETSENTPRODUCTNOTIFICATIONV1 = 'nHgetSentProductNotificationV1_IH_v1.nHgetSentProductNotificationV1'; //Muvhuso Nekhubvi: 20200506 : nHgetSentProductNotificationV1
    public static final String METHOD_NHLISTSENTPRODUCTNOTIFICATIONSV1 = 'nHlistSentProductNotificV1_IH_v1.nHlistSentProductNotificationsV1';// Added by Muvhuso for nHlistSentProductNotificationsV1
    public static final String METHOD_GB_CREATE_CMS_CONTOFFLINK_V1 = 'GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1'; //Diksha Wasekar:20200415: GBcreateCmsContOffLinkV1
  public static final String METHOD_NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING = 'nQlistRecipientsRegisteredV1_IH_v1.getRecipientsRegisteredDetails';
   public static final String METHOD_NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING = 'nQreplaceRecipientsV1_IH_v1.updateRecipients';
  public static final String METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1 = 'MBListSourceInstructionsV1_Req_IB_v1.MBListSourceInstructionsV1'; //Rudolf Niehaus: 20200513 : MBListSourceInstructionsV1
    public static final String METHOD_NHENQUIRYPAUSECARDV1 = 'nHenquiryPauseCardV1_IH_v1.getNHenquiryPauseCardV1';
  public static final String METHOD_NHUPDATEPAUSECARDV1 = 'nHupdatePauseCardV1_IH_v1.nHupdatePauseardv1';
    public static final String METHOD_PREDICTION_V1 = 'Prediction_IH_v1.Prediction';
    public static final String METHOD_CQ_GET_CHARGES_DETAILS_V1 = 'CQgetChargesDetailsMaintV9_IH_v1.callToCQgetChargesDetailsMaintV9';//Techmagic - Igor


    /**==============================================================================================================================
*Field Name String Values
Contains String values of Http Headers
Contains the String values of field names
==============================================================================================================================**/

    //Header Value Strings
    public static final String FIELD_TRANSACTION_ID = 'transactionId';
    public static final String FIELD_INITIATOR = 'initiator';
    public static final String FIELD_SENDER = 'sender';

    //Header Value Strings, UpdateComplaint_ApiRest_v1
    public static final String CASE_NUMBER = 'caseNumber';

    //Field Label Strings
    public static final String FIELD_STAGE_NAME_STRING = 'Stage Name';
    public static final String FIELD_PRODUCT_NAME_STRING = 'Product';
    public static final String FIELD_DEVELOPERNAME_STRING = 'DeveloperName';
    public static final String FIELD_OCCUPATION_CODE_STRING = 'Occupation Code';
    public static final String FIELD_OCCUPATION_STATUS_STRING = 'Occupation Status';
    public static final String FIELD_OCCUPATION_STRING = 'Occupation';
    public static final String FIELD_OCCUPATION_CATEGORY_STRING = 'Occupation Category';
    public static final String FIELD_SOURCE_OF_INCOME_STRING = 'Source of Income';
    public static final String FIELD_COUNTRY_STRING = 'Country';
    public static final String Risk_ProductCode_STRING = 'Risk ProductCode';
    public static final String Risk_SubProductCode_STRING = 'Risk SubProductCode';
    public static final String FIELD_REASON_STRING = 'Reason';
    public static final String FIELD_MARITAL_STATUS_STRING = 'Marital Status';
    public static final String FIELD_NATIONALITY_STRING = 'Nationality';
    public static final String FIELD_IDENTITY_TYPE_STRING = 'Identity Type';
    public static final String FIELD_RISK_RATING_STRING = 'Risk Rating';
    public static final String FIELD_TITLE_STRING = 'Title';
    public static final String FIELD_RELATIONSHIP_STRING = 'Relationship';
    public static final String FIELD_NAME_STRING = 'Name';
    public static final String FIELD_COUNTRY_OF_BIRTH_STRING = 'Country of Birth';
    public static final String FIELD_OPTED_OUT = 'Opted Out';
    public static final String FIELD_LANGUAGE = 'Language';

    /**==============================================================================================================================
*Debug String Values
Contains the String values used in System debug statements
==============================================================================================================================**/
    public static final String DEBUG_HTTP_REQUEST_STRING = 'httpRequest: ';
    public static final String DEBUG_HTTP_RESPONSE_STRING = 'httpResponse: ';

    /**==============================================================================================================================
*General String Values
Contains string values for general use in all classes
==============================================================================================================================**/
    public static final String MASK_STRING = 'xxxxxx: ';
    public static final String UNKNOWN_STRING = 'Unknown';
    public static final String SYS_LOGGER_OBJ_NAME = 'Sys_Log_Integration__c';
    public static final String REQUEST_FIELD_NAME = 'Request__c';
    public static final String RESPONSE_FIELD_NAME = 'Response__c';
    public static final String SPACE_STRING = ' ';

    public static final String SYSTEM_NAME_LIKE = 'System_Name__c LIKE \'';
    public static final String SYSTEM_NAME_EQUALS = 'System_Name__c = \'';
    public static final String ENVIRONMENT_EQUALS = 'Environment__c = \'';
    public static final String BUSINESS_BANKING = 'Business Banking';//Added by chandra against W-002766 dated 29/09/2019
    public static final String UBO_YES = 'Yes';//Added by chandra against W-004945 dated 2020-15-07
    public static final String UBO_NO = 'No';//Added by chandra against W-004945 dated 2020-15-07

    /**==============================================================================================================================
*Metadata Type String Values
Contains the API value of the metadata type
==============================================================================================================================**/
    public static final String INTEGRATION_SETTINGS_MDT = 'Integration_Settings__mdt';
    public static final String FIELD_VISIBILITY_PER_PRODUCT_MDT = 'Field_Visibility_Per_Product__mdt'; //JQUEV
    public static final String GENERAL_VIRTUAL_ADVISOR_RULE_MDT = 'General_Virtual_Advisor_Rules__mdt';
  public static final String MANDATORY_DOC_MDT = 'Mandatory_Doc__mdt'; //Added By Himani as part of changes for #W-005298
    public static final String HIGH_RISK_MCC_MDT = 'High_Risk_MCC__mdt';

    /**==============================================================================================================================
*HTTP Request String Values
Contains strings used for setting a request
==============================================================================================================================**/
    public static final String POST_STRING = 'POST';
    public static final String GET_STRING = 'GET';
    public static final String CONTENT_TYPE_STRING = 'Content-Type';//Accept
    public static final String HTTP_ACCEPT_HEADER_STRING = 'Accept';
    public static final String APPLICATION_JSON_CHARSET_UTF8_STRING = 'application/json;charset=UTF-8';
    public static final String APPLICATION_JSON_STRING = 'application/json';
    public static final String APPLICATION_URLENCODED = 'application/x-www-form-urlencoded';
    public static final String X_IBM_CLIENT_ID_STRING = 'X-IBM-Client-Id';
    public static final String X_IBM_CLIENT_SECRET_STRING = 'X-IBM-Client-Secret';
    public static final String INVOLVED_PARTY_ID_TYPE = 'involved-party-id-type';
    public static final String INVOLVED_PARTY_ID = 'involved-party-id';
    public static final String INVOLVED_PARTY_VERSION = 'involved-party-version';
    public static final String COMPLIANCE_VIEW_VERSION = 'compliance-view-version';

    public static final String HTTP_PUT_STRING = 'PUT';
    public static final String HTTP_GET_STRING = 'GET';
    public static final String HTTP_POST_STRING = 'POST';

    /**==============================================================================================================================
*Environment Type String Values
Contains the strings used to define the environment type
==============================================================================================================================**/
    public static final String UAT_LOWERCASE_STRING = 'uat';
    public static final String UAT_UPPERCASE_STRING = 'UAT';
    public static final String DEVELOPMENT_STRING = 'Development';
    public static final String PRODUCTION_STRING = 'Production';

    /**==============================================================================================================================
*Record Type String Values
Contains the DeveloperName Strings for a record type in Salesforce
==============================================================================================================================**/
    public static final String ACCOUNT_RECORD_TYPE_INDIVIDUAL_CLIENT = 'Individual_Client';
    public static final String TASK_RECORD_TYPE_SMS = 'SMS';
    public static final String APPLICATION_RECORD_TYPE_ONBOARDING = 'Onboarding'; // PJAIN: 20200531
    public static final String APPLICATION_RECORD_TYPE_MERCHANT_ONBOARDING = 'Merchant_Onboarding'; // JQUEV: 20200623 - lined added by Tinashe from a2dev2a as my deployment is failing

    /**==============================================================================================================================
*Metadata Records String Values
Contains the DeveloperName of the metadata record
==============================================================================================================================**/
    public static final String CUSTOMER_TYPE_CODE = 'Customer_Type_Code';
    public static final String CLIENT_TYPE_GROUP = 'Client Type Group';
    public static final String CLIENT_TYPE = 'Client Type';//Added By Anka Ganta
    public static final String SCREENING_STATUS = 'Screening Status';//Added By Anka Ganta
    public static final String CUSTOMER_STATUS_CODE = 'Customer_Status_Code';
    public static final String CUSTOMER_SOURCE_UNIQUE_ID = 'Customer_Source_Unique_ID';
    public static final String BRANCH_CODE = 'Branch_Code';
    public static final String CHANNEL = 'Channel';
    public static final String SBU = 'SBU';
    public static final String ORIGINATING_SYSTEM = 'Originating_System';
    public static final String ORIGINATING_SYSTEM_CASA = 'Originating_System_CASA';
    public static final String CIF = 'CIF';
    public static final String PRODUCT = 'Product';
    public static final String SUB_PRODUCT = 'Sub_Product';
    public static final String DISTRIBUTION_CHANNEL = 'Distribution_Channel';
    public static final String MEMBER_TYPE = 'Member_Type';
    public static final String IS_BRANCH_SALES = 'Workspace_Add_web_service_IsBranchSales';
    public static final String IS_CLIENT_PRESENT = 'Workspace_Add_web_service_IsClientPresen';
    public static final String IS_REPLACEMENT = 'Workspace_Add_web_service_IsReplacement';
    public static final String IS_INDIVIDUAL = 'Workspace_Add_web_service_IsIndividual';
    public static final String IS_SOUTH_AFRICAN = 'Workspace_Add_web_service_IsSouthAfrican';
    public static final String IS_STAFF = 'Workspace_Add_web_service_IsStaff';
    public static final String MODULE = 'Module';
    public static final String MEMBER_INCOME_BAND_UNKNOWN = 'Policy_Create_member_IncomeBand';
    public static final String DECLARATION_STATUS_VALID = 'Declaration_Status_Valid';
    public static final String COMPANY_FORM = 'companyForm';

    /**==============================================================================================================================
*Party Type / Relationship String Values
Contains string values the Party Types or Relationship types
==============================================================================================================================**/
    public static final String DEPENDANT_PARTY_TYPE = 'Dependant';
    public static final String SPOUSE_PARTY_TYPE = 'Spouse';
    public static final String BENEFICIARY_PARTY_TYPE = 'Beneficiary';
    public static final String CHILD_RELATIONSHIP = 'Child';

    /**==============================================================================================================================
*Product Names
==============================================================================================================================**/

    public static final String POLICY_FEE_STRING = 'Policy Fee';
    public static final String VAPM_ITEM_DESCRIPTION = 'VAPM'; //added  by muvhuso
    public static final String CHEQUE_SERVICE_OR_SAVINGS = 'Cheque Service / Savings'; //added  by chandra dated 25/06/2020
    public static final String DIRECTION_OUTBOUND = 'Outbound'; //added  by chandra dated 25/06/2020

    /**==============================================================================================================================
*Opperation Values
==============================================================================================================================**/
    public static final String OPERATION_GET_CLIENTS = 'clients/GetClients';
    public static final String CIB_VIEW = 'CIB_VIEW';

    /**==============================================================================================================================
*Quick Templates Names
==============================================================================================================================**/
    public static final String CLIENT_EPP_SUCCESSFUL_SALE_SMS = 'Client EPP Successful Sale SMS';
    public static final String ADVISER_WILL_REGISTERED_SMS_ENGLISH = 'Adviser Will Registered SMS - English';
    public static final String CLIENT_WILL_REGISTERED_SMS_AFRIKAANS = 'Client Will Registered SMS - Afrikaans';
    public static final String CLIENT_WILL_REGISTERED_SMS_ENGLISH = 'Client Will Registered SMS - English';

    /**==============================================================================================================================
*Integration Services Names
==============================================================================================================================**/
    public static final String EPP_ITOUCH_SMS_INTEGRATION_SERVICE = 'iTouch SMS Submit - EPP';
    public static final String DD_ITOUCH_SMS_INTEGRATION_SERVICE = 'iTouch SMS Submit - DD';
    public static final String VA_ITOUCH_SMS_INTEGRATION_SERVICE = 'iTouch SMS Submit - VA';
    public static final String WILLS_ITOUCH_SMS_INTEGRATION_SERVICE = 'iTouch SMS Submit - WILLS';

    /**==============================================================================================================================
*Pricing Related Strings
==============================================================================================================================**/
    public static final String PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED = 'Fixed';
    public static final String PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE = 'Percentage';
    public static final String PRICE_SCHEME_TYPE_STANDARD = 'Standard';
    public static final String PRICE_SCHEME_TYPE_FRANCHISE = 'Franchise';
    public static final String PRICE_SCHEME_TYPE_NEGOTIATED = 'Negotiated';
    public static final String PRICE_SCHEME_NAME_PATTERN = 'Merchant Negotiated Price Scheme for ';
    public static final String PRICE_SCHEME_ENTRY_PRICING_TEMPLATE_FIXED = 'Fixed Fee per Item';
    public static final String PRICE_SCHEME_ENTRY_PRICING_TEMPLATE_VARIABLE_PERCENTAGE = 'Transaction Amount, Percentage';
    /**==============================================================================================================================
*Merchant Related Strings
==============================================================================================================================**/
    public static final String OPPORTUNITY_STAGE_APPLY_PRODUCT = 'Apply Product';
    public static final String OPPORTUNITY_STAGE_ACCEPT_QUOTE = 'Accept Quote';
    public static final String MERCHANT_PRICE_SCHEME_ENTRY_MAP_KEY_TEMPLATE = '[{0}]:[{1}]'; // PJAIN: 20200525
    public static final String MERCHANT_ERROR_USER_SITE_CODE_NOT_FOUND = 'Your user does not have a SiteCode__c associated with it.';
    public static final String MERCHANT_ERROR_OPPORTUNITY_SITE_CODE_NOT_FOUND = 'There is no SiteCode__c associated with this Opportunity.';
    public static final String MERCHANT_ERROR_APPLICATION_ALREADY_EXISTS = 'An existing application already exists for this Opportunity. Cannot approve Quote. Please contact administrator.';
    public static final String MERCHANT_ERROR_APPLICATION_PRODUCT_MERCHANT_NOT_FOUND = 'Accepted Cards: Application Product Merchant record not found.'; // PJAIN: 20200525
    public static final String MERCHANT_ERROR_ACCEPTED_CARDS_MERCHANT_CLASS_BLANK = 'Accepted Cards: Merchant Class is not populated.'; // PJAIN: 20200525
    public static final String MERCHANT_AMERICAN_EXPRESS_CARD = 'American Express'; // PJAIN: 20200525
    public static final String MERCHANT_ACCEPTED_CARD_TYPE_CARD = 'Card'; // PJAIN: 20200525
    public static final String MERCHANT_ACCEPTED_CARD_TYPE_FEE_CATEGORY = 'Merchant Fee Category'; // PJAIN: 20200525
    public static final String MERCHANT_APPLICATION_QA_STATUS_APPROVED = 'Approved'; // PJAIN: 2020604
  public static final String OPPORTUNITY_STAGE_COMPLETE_PRODUCT_DETAILS = 'Complete Product Details';
    public static final String MERCHANT_PRODUCT_NAME_E_COMMERCE = 'E-Commerce'; //EMokgopanyane 20201005

    /**==============================================================================================================================
    *Credit Related Strings
    ==============================================================================================================================**/
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ASSET_FINANCE = 'Asset Finance';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_CLIENT_PRODUCT_CATEGORY = 'Client Product Category';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_CLIENT_PRODUCT_CATEGORY_TOTAL = 'Client Product Category Total';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_CLIENT_PROFILE_PRODUCT_TOTAL = 'Client Profile Product Total';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_MORTGAGE_AGRI = 'Mortgage Agriculture';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_MORTGAGE_CPF = 'Mortgage CPF';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_MORTGAGE_RESIDENTIAL = 'Mortgage Residential';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_MORTGAGE_TOTAL = 'Mortgage Total';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT = 'Ordinary Credit';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT_TOTAL = 'Ordinary Credit - Total';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT = 'Product';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_RECOVERY_EXPOSURE = 'Recovery Exposure';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_TOTAL_EXPOSURE = 'Total Exposure';
        public static final String APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_TOTAL_ORDINARY_CREDIT_EXPOSURE = 'Total Ordinary Credit Exposure  ';

    /**==============================================================================================================================
*Email Template Names
==============================================================================================================================**/
    public static final String WIMI_DOCUMENTS_SHARE_EMAIL = 'WIMI_Documents_Share_Email';
    
    /**=================================================================================================================================
* String Constants for Direct Delivery Outbound Sales
===================================================================================================================================**/
    public static final String PARTY_TYPE_MAIN_MEMBER = 'Main Member';
    public static final String PARTY_TYPE_DEPENDANT = 'Dependant';
    public static final String PARTY_TYPE_SPOUSE = 'Spouse';
    public static final String PRODUCT_CROSS_SELL = 'Cross Sell';
    public static final String PRODUCT_FLEXI_FUNERAL = 'Flexi Funeral';
    public static final String PRODUCT_ROAD_COVER = 'Road Cover';
    public static final String PRODUCT_HEALTH_ASSISTANCE = 'Health Assistance';
    public static final String PRODUCT_LAW_FOR_U = 'Law 4 u';
    public static final String PRODUCT_ULTIMATE_PROTECTOR = 'Ultimate Protector';
    public static final String PRODUCT_AVAF_CREDIT_LIFE = 'AVAF Credit Life';
    public static final String PRODUCT_EXTENDED_COVER = 'Extended Cover';
    public static final String PRODUCT_CARD_LIFE = 'Card Life';
    public static final String QUOTE_DOCUMENT_TYPE = 'Absa 5778 EX - Merchant Payment Pricing Proposal';
    public static final String RELATIONSHIP_TYPE_DEPENDANT = 'Dependant';
    public static final String RELATIONSHIP_TYPE_CHILD = 'Child';
    public static final String RELATIONSHIP_TYPE_EXTENDED_FAMILY_MEMBER = 'Extended Family Member';
    public static final String RELATIONSHIP_TYPE_MAIN_MEMBER = 'Main Member';
    public static final String RELATIONSHIP_TYPE_SPOUSE = 'Spouse';
    
    public static final String BENEFIT_TYPE_DEATH_AND_ACCIDENTAL_DISABILITY = 'Death and Accidental Disability';
    public static final String BENEFIT_TYPE_ACCIDENTAL_DEATH_BENEFIT = 'Accidental Death Benefit and Accidental Disability';
    
    public static final String BENEFIT_TYPE_DEATH_AND_ACCIDENTAL_DISABILITY_CODE = 'U01_U03';
    public static final String BENEFIT_TYPE_ACCIDENTAL_DEATH_BENEFIT_CODE = 'U02_U03';
    
    public static final String BLANK_SPACE = ' ';
    
    public static final Integer MAX_ROW_COUNT = 50;
    
    /**=================================================================================================================================
* String Constants for Virtual Advisor STI Record Type
===================================================================================================================================**/
    public static final String OPPORTUNITY_STAGE_CLOSED_LOST = 'Closed Lost (Customer Not Interested)';
    public static final String OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL = 'Referred - Internal';
    public static final String OPPORTUNITY_STI_SUB_STATUS_REFERRED_EXTERNAL = 'Referred - External';
    public static final String OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_AIFA = 'Referred - Internal AIFA';
    public static final String OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_VA_LIFE = 'Referred - Internal VA Life';
    public static final String OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_IDIRECT = 'Referred - Internal iDirect';
    public static final String OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_DIRECT_DELIVERY = 'Referred - Internal Direct Delivery';
    
    public static final String VIRTUAL_ADVISOR_OWD_EMAIL = 'virtualshortterm@absa.co.za';
    public static final String VIRTUAL_ADVISOR_PSG_ADDRESS_1 = 'Marieta.Wessesl@psg.co.za';
    public static final String VIRTUAL_ADVISOR_PSG_ADDRESS_2 = 'Judith.Claassens@psg.co.za';
    public static final String VIRTUAL_ADVISOR_AIFA_ADDRESS_1 = 'virtualservice@absa.co.za';
    public static final String VIRTUAL_ADVISOR_IDIRECT_ADDRESS_1 = 'idirectcoach@absa.africa';
    public static final String VIRTUAL_ADVISOR_DD_ADDRESS_1 = 'eNewBusiness@absa.co.za';
    public static final String VIRTUAL_ADVISOR_VA_LIFE_ADDRESS_1 = 'adviceguru@absa.co.za';    
    public static final String VIRTUAL_ADVISOR_TEST_EMAIL_1 = 'minal.doongarwal@absa.africa';
    public static final String VIRTUAL_ADVISOR_TEST_EMAIL_2 = 'FaithTshepo.Baloyi@absa.africa';
    public static final String VIRTUAL_ADVISOR_ABSA_EMAIL = 'virtualadviser@absa.co.za';
    
    public static final String CASE_STATUS_CLOSED = 'Closed';
    public static final String CASE_STATUS_ASSIGNED = 'Assigned';
    public static final String CASE_SUB_STATUS_REFERRED = 'Client Referred';    
    public static final String CASE_REFERRAL_TYPE_VA = 'VA';
    public static final String CASE_REFERRAL_TYPE_F2F = 'F2F';    
    public static final String CASE_RECORD_TYPE_CLIENT_REVIEW = 'VA_Client_Review';
    public static final String CASE_RECORD_TYPE_MATURITY = 'VA_Maturity';
    public static final String INV_F2F_QUICK_TEXT = 'ABSA INV F2F Referral';
    public static final String INV_Refer_Email_to_Customer_Subject='Absa Insurance and Financial Advisers: Adviser Details [securemail]';
}