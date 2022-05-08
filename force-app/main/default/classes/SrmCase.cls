/**
* @description getRelatedPartyDetails
* @author  Thomas Dry
* @created 2021-02-04
*/

public without sharing class SrmCase
{
/**
* @description BasicCaseInfo
*/
 public SrmBasicCaseInfo BasicCaseInfo { get; set; }
 /**
* @description AbsaAgreements
*/
    public List<SrmAbsaAgreement> AbsaAgreements { get; set; }
    /**
* @description SupportingMaterials
*/
    public ASPDeviceDocumentScanningResponse SupportingMaterials { get; set; }
    /**
* @description CommunicationInfo
*/
    public SrmCommunicationInfo CommunicationInfo { get; set; }
    /**
* @description Customer
*/
    public SrmCustomer Customer { get; set; }
    /**
* @description DHACPBResult
*/
    public ASPDeviceCustomerVerificationResponse DHACPBResult { get; set; }
    /**
* @description SrmCaseInfoFields
*/
    public List<SrmCaseInfoField> SrmCaseInfoFields { get; set; }
    /**
* @description RelatedParties
*/
    public List<RelatedParty> RelatedParties { get; set; }

    /**
* @description SrmAbsaAgreement
*/

    public class SrmAbsaAgreement
    {
        /**
* @description AbsaReferenceNumber
*/
        public String AbsaReferenceNumber { get; set; }
        /**
* @description AbsaReferenceSourceApplCode
*/
        public String AbsaReferenceSourceApplCode { get; set; }
        /**
* @description AgreementType
*/
        public String AgreementType { get; set; }
        /**
* @description ProductCode
*/
        public String ProductCode { get; set; }
    }

    /**
* @description SrmBasicCaseInfo
*/
    public class SrmBasicCaseInfo
    {
        /**
* @description CaseDescription
*/
        public String CaseDescription { get; set; }
        /**
* @description OriginatingChannel
*/
        public String OriginatingChannel { get; set; }
        /**
* @description OriginatingSiteCode
*/
        public String OriginatingSiteCode { get; set; }
        /**
* @description ResolutionAreaCode
*/
        public String ResolutionAreaCode { get; set; }
        /**
* @description ResolutionWorkCategory
*/
        public String ResolutionWorkCategory { get; set; }
        /**
* @description CaseCategoryCode
*/
        public String CaseCategoryCode { get; set; }
        /**
* @description CaseClassificationType
*/
        public String CaseClassificationType { get; set; }
        /**
* @description CaseClassificationSubType
*/
        public String CaseClassificationSubType { get; set; }
        /**
* @description CaseResolutionSiteCode
*/
        public String CaseResolutionSiteCode { get; set; }
        /**
* @description PriorityCode
*/
        public String PriorityCode { get; set; }
        /**
* @description ProductOrServiceArea
*/
        public String ProductOrServiceArea { get; set; }
        /**
* @description ProductCode
*/
        public String ProductCode { get; set; }
        /**
* @description SensitivityCode
*/
        public String SensitivityCode { get; set; }
        /**
* @description CaseStatusCode
*/
        public String CaseStatusCode { get; set; }
        /**
* @description CaseResolutionChannel
*/
        public String CaseResolutionChannel { get; set; }
        /**
* @description CaseResolutionPointCode
*/
        public String CaseResolutionPointCode { get; set; }
        /**
* @description CasaRefNumber
*/
        public String CasaRefNumber { get; set; }
        /**
* @description CasaSequenceNumber
*/
        public string CasaSequenceNumber { get; set; }
        /**
* @description FicCaseType
*/
        public String FicCaseType { get; set; }
        /**
* @description SbuCode
*/
        public String SbuCode { get; set; }
        /**
* @description TellerAbNumber
*/
        public String TellerAbNumber { get; set; }
        /**
* @description TransactionType
*/
        public String TransactionType { get; set; }
        /**
* @description CaseClientType
*/
        public String CaseClientType { get; set; }    
    }
    /**
* @description SrmCaseInfoField
*/
    public class SrmCaseInfoField
    {
         /**
* @description CaseInfoFieldDescription
*/
        public String CaseInfoFieldDescription { get; set; }
         /**
* @description CaseInfoFieldValue
*/
        public String CaseInfoFieldValue { get; set; }
    }
    /**
* @description SrmCommunicationInfo
*/
    public class SrmCommunicationInfo
    {
        /**
* @description ContactMethod
*/
        public String ContactMethod { get; set; }
        /**
* @description CommunicationType
*/
        public String CommunicationType { get; set; }
        /**
* @description TelephoneCode
*/
        public string TelephoneCode { get; set; }
        /**
* @description TelephoneNumber
*/
        public string TelephoneNumber { get; set; }
        /**
* @description EmailAddress
*/
        public String EmailAddress { get; set; }
        /**
* @description AddressLine1
*/
        public String AddressLine1 { get; set; }
        /**
* @description AddressLine2
*/
        public String AddressLine2 { get; set; }
        /**
* @description AddressLine3
*/
        public String AddressLine3 { get; set; }
        /**
* @description Suburb
*/
        public String Suburb { get; set; }
        /**
* @description City
*/
        public String City { get; set; }
        /**
* @description PostalCode
*/
        public String PostalCode { get; set; }
        /**
* @description FaxCode
*/
        public string FaxCode { get; set; }
        /**
* @description FaxNumber
*/
        public string FaxNumber { get; set; }    
    }
    /**
* @description SrmCustomer
*/
    public class SrmCustomer
    {
        /**
* @description CustomerID
*/
        public String CustomerID { get; set; }
        /**
* @description CustomerSourceCode
*/
        public String CustomerSourceCode { get; set; }
        /**
* @description IdType
*/
        public String IdType { get; set; }
        /**
* @description IdNumber
*/
        public String IdNumber { get; set; }
        /**
* @description CaseCustomerID
*/
        public String CaseCustomerID { get; set; }
        
    }
    /**
* @description ChargeResponsible
*/
    public class ChargeResponsible
    {
        /**
* @description ChargeResponsibleCode
*/
        public String ChargeResponsibleCode { get; set; }
        /**
* @description AdditionalChargeInfo
*/
        public String AdditionalChargeInfo { get; set; }
    }
    /**
* @description RelatedParty
*/
    public class RelatedParty
    {
        /**
* @description IndividualCasaReferenceNumber
*/
        public String IndividualCasaReferenceNumber { get; set; }
        /**
* @description IndividualCasaSequenceNumber
*/
        public String IndividualCasaSequenceNumber { get; set; }
        /**
* @description RelatedPartyCasaReferenceNumber
*/
        public String RelatedPartyCasaReferenceNumber { get; set; }
        /**
* @description RelatedPartyCasaSequenceNumber
*/
        public String RelatedPartyCasaSequenceNumber { get; set; }
        /**
* @description NonConforming
*/
        public boolean NonConforming { get; set; }
        /**
* @description RelatedPartyId
*/
        public String RelatedPartyId { get; set; }
        /**
* @description RelatedCustomer
*/
        public RelatedCustomer RelatedCustomer { get; set; }
    }
    /**
* @description RelatedCustomer
*/
	public class RelatedCustomer
    {
        /**
* @description CustomerId
*/
        public String CustomerId { get; set; }
        /**
* @description IdType
*/
        public String IdType { get; set; }
        /**
* @description IdNumber
*/
        public String IdNumber { get; set; }
    }
    
}