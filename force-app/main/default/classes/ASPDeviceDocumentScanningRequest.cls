/**
 * @description       : Response object for ASPDeviceDocumentScanningRequest
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2020-02-08
 * @last modified on  : 2021-08-26
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class ASPDeviceDocumentScanningRequest {
	public string IdNumber;
	public string CASAReference;
	public string Account;
	public string CIFCode;
	public boolean DEAConsent;
	/**
	 * @description       : ASPDocumentTypeName List
	 **/
	public List<ASPDocumentTypeName> ASPDocumentNameList { get; set; }
	/**
	 * @description       : DocumentToUpdateInEcm List
	 **/
	public List<DocumentToUpdateInEcm> DocumentsToUpdateInEcmList { get; set; }
	/**
	 * @description       : DEAConsentInformation
	 **/
	public DEAConsentInfo DEAConsentInformation { get; set; }

	/**
	 * @description       : DocumentToUpdateInEcm
	 * @return ASPDeviceDocumentScanningRequest
	 **/
	public static ASPDeviceDocumentScanningRequest getnewInstance() {
		ASPDeviceDocumentScanningRequest aspDeviceRequest = new ASPDeviceDocumentScanningRequest();
		aspDeviceRequest.ASPDocumentNameList = new List<ASPDocumentTypeName>();
		aspDeviceRequest.DocumentsToUpdateInEcmList = new List<DocumentToUpdateInEcm>();
		aspDeviceRequest.DEAConsentInformation = new DEAConsentInfo();
		return aspDeviceRequest;
	}

	/**
	 * @description       : DocumentToUpdateInEcm
	 **/
	public class DocumentToUpdateInEcm {
		public ASPDocumentTypeName ASPDocumentName;
		public string Pid;
		public string DocumentId;
	}
	/**
	 * @description       : DEAConsentInfo
	 **/
	public class DEAConsentInfo {
		public decimal AccountNumber;
		public string AccountType;
		public string BankName;
		public string BranchCode;
		public string IdTypeCode;
		public string IdentificationNumber;
		public string Initials;
		public string LastName;
	}

	/**
	 * @description       : DocumentToUpdateInEcm
	 **/
	public enum ASPDocumentTypeName {
		IDDocument,
		ProofOfResidentialAddress,
		ProofOfResidentialAndBusinessAddress,
		ProofOfResidence,
		IDPassport,
		AssetAndLiabilityStatement,
		IdOfAllPartners,
		ResolutionMandateAuthorisingMandate,
		ProofOfBusinessAddress,
		Ck1Ck2orCIPROCertificate,
		LatestFinacialStatementAvailable,
		LatestFinacialStatementExisting,
		CM1AndCM22OrCIPROCertificate,
		IDOf25PercentShareholders,
		IDOf10PercentShareholders,
		ResolutionAutMandateFromBoardOfDirectors,
		TrustDeedAndMastersAuth,
		IDOfFounderTrusteesBeneficiaries,
		ResolutionOrMandateToAuthorisedOfficial,
		ProofOfResidentialAddressForTrust,
		ProofOfResidentialAddressForTrusteesAndFounder,
		ProofOfBusinessOperationalAddessOfTrust,
		ConstitutionOrFoudningDocument,
		ProofOfBusinessOperationalAddess,
		ProofOfIncorporation,
		IDMandatedOfficialCEOMNG,
		AssetAndLiabilityStatementOfParticipants,
		IDPassportMaroonIDSection22Or24Permit,
		IdOfAllParticipants,
		ProofOfResidentialAddressOfAll,
		SourceOfIncFundsALStat,
		PassportMaroonIdSection22Or24PE,
		ProofOfResidentialAddressOfAllPa,
		SourceOfFundsALStatA,
		SourceOfIncomeAndFundsStatement,
		ConsultationDeclarationByMandate,
		IdOfMandatedOfficials,
		IdOfMembersAndMandatedOfficials,
		TrustDeedAndForeignAuthority,
		PartnershipAgreement,
		WorkPermit,
		LetterOfExecutorship,
		DeclarationForeignNational,
		IdRegNumber,
		ProofOfResidentialBusinessAddress,
		DoNotUse,
		WithdrawalOfInvestmentsPayInstructionsDoc,
		SigningIndemnitiesRelatedDocuments,
		ConsentManagement,
		CreditAgreement,
		SigningInstructions,
		PaymentInstruction,
		ClientInformationRelatedDocs,
		AccountApplication,
		PreAgreementQuote,
		NoticeOfIncorporation,
		MemorandumOfIncorporation,
		RegistrationCertificate,
		IDOfDeceasedIndividual,
		ProofOfDeath,
		RecordOfAdvice,
		BankStatement,
		ProofOfIncome,
		MarriageDeclaration,
		ProofOfStudentRegistration,
		StaffDeclaration,
		CostOfCourse,
		AcademicRecord,
		CIPCVerification,
		CompanyOrganogram,
		SourceOfFunds1,
		SourceOfIncome,
		Qualification,
		Indemnity,
		CustomerInstruction,
		SourceOfFunds2,
		SourceOfFunds3,
		SourceOfFunds4,
		SourceOfFunds5,
		PersonalClientAgreement,
		XdsConsumerTraceReport,
		CallReport,
		TaxFreeCertificate,
		TaxFreeContribution,
		SettlementLetter1,
		SettlementLetter2,
		SettlementLetter3,
		SettlementLetter4
	}
}