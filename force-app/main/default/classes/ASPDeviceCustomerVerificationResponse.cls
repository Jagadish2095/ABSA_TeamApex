/**
* Response object for ASPDeviceCustomerVerification
* @description 
* @author  Paul du Randt
* @created 2021-02-01
*/
public without sharing class ASPDeviceCustomerVerificationResponse 
{
    public Boolean WasHANISCancelled;
    public string HANISCancelReason;
    public Boolean WasBioConsentGiven;
    public Boolean WasHANISServiceCallSuccessful;
    public HANISDetailsResponse HANISServiceResponse;
    public Boolean WasCPBServiceCallSuccessful;
    public CPBResponse CPBServiceResponse;
    public Boolean isCPBResidentialAddressCertificateStoredInEcm;
    public EcmUploadResponse CPBResidentialAddressCertECMdetails;
    public Boolean isHANISCertificateStoredInEcm;
    public EcmUploadResponse HANISCertECMdetails;
    public Boolean WasHANISAttestationSelected;
    public string HANISAttestationValue;

    /**
* Response object for HANISDetailsResponse
* @description 
*/
    public class HANISDetailsResponse {
        public string ErrorCode;
        public string maritalStatus;
        public string sCallCentreNoField;
        public string cert;
        public string hasSmartCard;
        public string dateIssued;
        public string image;
        public string surname;
        public string name;
        public string finger2Score;
        public string finger2Result;
        public string fpInd2;
        public string finger1Score;
        public string finger1Result;
        public string fpInd1;
        public string idNumber;
        public string transactionID;
        public string errorDescription;
        public string responseStatusDescription;
        public string responseStatusCode;
    }

    /**
* Response object for CPBResponse
* @description 
*/
    public class CPBResponse {
        public string ErrorMessage;
        public SearchInformation SearchInformation;    
        public Person Person; 
        public ErrorCore ErrorCore;
    }

    /**
* Response object for Person
* @description 
*/

    public class Person {
        PersonInformation PersonInformation;
        public ContactInformation ContactInformation;
        public FinancialInformation FinancialInformation;
        public AddressInformation AddressInformation;
    }

/**
* Response object for SearchInformation
* @description 
*/
    public class SearchInformation {
        public string SearchUserName;
        public string Reference;
        public string SearchToken;
        public string SearchTypeDescription;
        public string SearchDescription;
        public string CallerModule;
        string SearchID;
        public string DataSupplier;
        public string SearchType;
        public string ExtendedSections;
        public string ResponseType;
        public string ResponseObjectType;
    }

    /**
* Response object for PersonInformation
* @description 
*/
    public class PersonInformation {
        public string PersonID;
        public string CurrentEmployer;
        public string DeceasedStatus;
        public string Reference;
        public string MiddleName3;
        public string MiddleName2;
        public string MiddleName1;
        public string Gender;
        public string MaritalStatus;
        public string PassportNumber;
        public string DateOfBirth;
        public string IdNumber;
        public string Surname;
        public string FirstName;
        public string Initials;
        public string Title;
        public string HasPostMatricQual;
        public string WhatQual;
    }
    
    /**
* Response object for ContactInformation
* @description 
*/

    public class ContactInformation {
        public string FaxNumber;
        public string WorkTelephoneNumber;
        public string HomeTelephoneNumber;
        public string MobileNumber;
        public string EmailAddress;
    }

    /**
* Response object for FinancialInformation
* @description 
*/
    public class FinancialInformation {
        public string EverInsolvent;
        public string IncomeBracket;
    }

    /**
* Response object for AddressInformation
* @description 
*/
    public class AddressInformation {
        public ResidentialAddress ResidentialAddress;
        public Address PostalAddress;
    }
    
    /**
* Response object for ResidentialAddress
* @description 
*/

    public class ResidentialAddress  {
        public string FirstReportedDate;
        public string AddCert;
        public string AddressID;
        public string TypeDescription;
        public string TypeCode;
        public string Line1;
        public string Line2;
        public string Line3;
        public string Line4;
        public string PostalCode;
        public string FullAddress;
        public string LastUpdatedDate;
    }

    /**
* Response object for ResidentialAddress
* @description 
*/

    public class Address {
        public string AddressID;
        public string TypeDescription;
        public string TypeCode;
        public string Line1;
        public string Line2;
        public string Line3;
        public string Line4;
        public string PostalCode;
        public string FullAddress;
        public string LastUpdatedDate;
    }
  
    /**
* Response object for EcmUploadResponse
* @description 
*/
    public class EcmUploadResponse {
        public string AddStatus;
        public string Pid;
        public string DocumentId;
    }

    /**
* Response object for ErrorCore
* @description 
*/
    public class ErrorCore {
        public string ErrorCode;
        public string SessionId;
        public string Component;
        public string ErrorDesc;
    }
    
    /**
* Response object for Dummyresponse
* @description 
*@return ASPDeviceCustomerVerificationResponse
*/
     public ASPDeviceCustomerVerificationResponse Dummyresponse(){
        ASPDeviceCustomerVerificationResponse response = new ASPDeviceCustomerVerificationResponse();
        response.WasHANISCancelled = false;
        response.HANISCancelReason = '';
        response.WasBioConsentGiven = false;
        response.WasHANISServiceCallSuccessful = false;
        response.WasCPBServiceCallSuccessful = false;
        response.isHANISCertificateStoredInEcm = false;
        response.WasBioConsentGiven = false;
        response.WasCPBServiceCallSuccessful = false;
        response.WasHANISAttestationSelected = false;
        response.WasHANISCancelled = false;
        response.WasHANISServiceCallSuccessful = false;
        response.HANISAttestationValue = 'dsfsdf';
        response.HANISServiceResponse = new ASPDeviceCustomerVerificationResponse.HANISDetailsResponse();
        response.HANISServiceResponse.cert = 'test';
        response.HANISServiceResponse.dateIssued = '2012-12-15';
        response.HANISServiceResponse.ErrorCode = 'Error';
        response.HANISServiceResponse.errorDescription = 'Errors';
        response.HANISServiceResponse.finger1Result = 'G';
        response.HANISServiceResponse.finger1Score = 'F';
        response.HANISServiceResponse.finger2Result = 'G';
        response.HANISServiceResponse.finger2Score = 'F';
        response.HANISServiceResponse.fpInd1 = 'a';
        response.HANISServiceResponse.fpInd2 = 'a';
        response.HANISServiceResponse.hasSmartCard = 'Y';
        response.HANISServiceResponse.idNumber = '9308295015083';
        response.HANISServiceResponse.image = 'no';
        response.HANISServiceResponse.maritalStatus = 'N';
        response.HANISServiceResponse.name = 'N';
        response.HANISServiceResponse.responseStatusCode = 'rder';
        response.HANISServiceResponse.responseStatusDescription = 'Test';
        response.HANISServiceResponse.sCallCentreNoField = 'd';
        response.HANISServiceResponse.surname = 'qw';
        response.HANISServiceResponse.transactionID = '124547';
        response.CPBServiceResponse = new ASPDeviceCustomerVerificationResponse.CPBResponse();
        response.CPBServiceResponse.ErrorCore = new ASPDeviceCustomerVerificationResponse.ErrorCore();
        response.CPBServiceResponse.ErrorCore.Component = 'tester';
        response.CPBServiceResponse.ErrorCore.ErrorCode = 'tester';
        response.CPBServiceResponse.ErrorCore.ErrorDesc = 'tester';
         response.CPBServiceResponse.ErrorCore.SessionId = '{00000000-0000-0000-0000-000000000000}';//'{db955b43-a5fa-4826-afc3-76b7c58a662';
        response.CPBServiceResponse.ErrorMessage = 'testing';
        response.CPBServiceResponse.Person = new ASPDeviceCustomerVerificationResponse.person();
        response.CPBServiceResponse.Person.AddressInformation = new ASPDeviceCustomerVerificationResponse.AddressInformation();
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress = new ASPDeviceCustomerVerificationResponse.Address();
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.AddressID = 'test';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.FullAddress = 'test';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.LastUpdatedDate = '12-08-2012';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line1 = 'wqwewqeq';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line2 = 'wqq';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line3 = 'wqq';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line4 = 'wqq';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.PostalCode = '1449';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.TypeCode = 'a';
        response.CPBServiceResponse.Person.AddressInformation.PostalAddress.TypeDescription = 'test';  
        response.CPBServiceResponse.Person.ContactInformation = new ASPDeviceCustomerVerificationResponse.ContactInformation();
        response.CPBServiceResponse.Person.ContactInformation.EmailAddress = 'trest';
        response.CPBServiceResponse.Person.ContactInformation.FaxNumber = 'trest';
        response.CPBServiceResponse.Person.ContactInformation.HomeTelephoneNumber = 'trest';
        response.CPBServiceResponse.Person.ContactInformation.MobileNumber = 'trest';
        response.CPBServiceResponse.Person.ContactInformation.MobileNumber = 'bla';
        response.isCPBResidentialAddressCertificateStoredInEcm = false;
      
        response.CPBResidentialAddressCertECMdetails = new ASPDeviceCustomerVerificationResponse.EcmUploadResponse();
        response.CPBResidentialAddressCertECMdetails.AddStatus = 'add';
        response.CPBResidentialAddressCertECMdetails.DocumentId = '{00000000-0000-0000-0000-000000000000}';
        response.CPBResidentialAddressCertECMdetails.Pid = '312442';
        return response;
    }
}