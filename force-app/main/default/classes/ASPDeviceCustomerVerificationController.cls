/**
 * @description       : Controller for Customer Verification
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2021-02-08
 * @last modified on  : 2021-07-02
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-07-02   PaulJohn.duRand@absa.africa   Shipping_Street_2__c and PMD
 **/

public class ASPDeviceCustomerVerificationController {
	/**
	 * @description Function used to create Contract request
	 * @param accountID
	 * @param IDNumber
	 * @param cifCode
	 * @param lastName
	 * @param cellNumber
	 * @return String
	 */
	@AuraEnabled
	public static String GetCustomerVerificationRequestMetadata(string accountID, String IDNumber, String cifCode, String lastName, String cellNumber) {
		ASPDeviceCustomerVerificationRequest Request = new ASPDeviceCustomerVerificationRequest();
		if (accountID != null && accountID != '') {
			Account account = new AccountsSelector().selectAllById(accountID);
			lastName = account.LastName;
			cellNumber = account.PersonMobilePhone;
			cifCode = account.CIF__c;
			IDNumber = account.ID_Number__pc;
		}
		Request.Surname = lastName;
		if (cifCode == null || cifCode == '')
			Request.IsNewtoBank = true;
		else
			Request.IsNewtoBank = false;

		Request.Cellphone = cellNumber;
		Request.CIFcode = cifCode;
		Request.IDNumber = IDNumber;
		String RequestJson = JSON.serialize(Request);
		return RequestJson;
	}

	/**
	 * @description GetCustomerVerificationResponseMetadata
	 * @param ResponseJson
	 * @return String
	 */
	@AuraEnabled
	public static ASPDeviceCustomerVerificationResponse GetCustomerVerificationResponseMetadata(string ResponseJson) {
		ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = new ASPDeviceCustomerVerificationResponse();
		deviceCustomerVerificationResponse = (ASPDeviceCustomerVerificationResponse) JSON.deserialize(
			ResponseJson,
			ASPDeviceCustomerVerificationResponse.class
		);
		return deviceCustomerVerificationResponse;
	}

	/**
	 * @description SetDataFromDHACPB
	 * @param accountID
	 * @param ResponseJson
	 * @return Boolean
	 */
	@AuraEnabled
	public static Boolean SetDataFromDHACPB(string accountID, string ResponseJson) {
		Boolean isFromDHA = false;
		Account account = new AccountsSelector().selectAllById(accountID);
		ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = ASPDeviceCustomerVerificationController.GetCustomerVerificationResponseMetadata(
			ResponseJson
		);
		if (deviceCustomerVerificationResponse.HANISAttestationValue == 'YY') {
			ASPDeviceCustomerVerificationController.AddProofOfIdentification(account, deviceCustomerVerificationResponse);
			isFromDHA = true;
		}
		if ((account.CIF__c == null || account.CIF__c == '') && (deviceCustomerVerificationResponse.WasCPBServiceCallSuccessful)) {
			ASPDeviceCustomerVerificationController.AddCPBForNewtoBank(account, deviceCustomerVerificationResponse);
		}
		update account;
		return isFromDHA;
	}

	/**
	 * @description AddProofOfIdentification
	 * @param account
	 * @param deviceCustomerVerificationResponse
	 */
	public static void AddProofOfIdentification(Account account, ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse) {
		account.FirstName = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(deviceCustomerVerificationResponse.HANISServiceResponse.name);
		account.LastName = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(deviceCustomerVerificationResponse.HANISServiceResponse.surname);
		account.Date_Issued__pc = BranchCIFSalesforceSyncHelper.getDateForSalesforceYearFirst(
			deviceCustomerVerificationResponse.HANISServiceResponse.dateIssued
		);
	}

	/**
	 * @description AddProofOfIdentification
	 * @param account
	 * @param deviceCustomerVerificationResponse
	 */
	public static void AddCPBForNewtoBank(Account account, ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse) {
		Address__c PostalAddress = BranchCIFSalesforceSyncHelper.GetAddress(account.id, 'Postal');
		Address__c ResidentialAddress = BranchCIFSalesforceSyncHelper.GetAddress(account.id, 'Residential');
		PostalAddress.Shipping_Street__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line1
		);
		PostalAddress.Shipping_Street_2__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line2
		);
		PostalAddress.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line3
		);
		PostalAddress.Shipping_City__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.PostalAddress.Line4
		);
		PostalAddress.Shipping_Zip_Postal_Code__c = deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.PostalAddress.PostalCode.leftPad(
			4,
			'0'
		);
		ResidentialAddress.Shipping_Street__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line1
		);
		ResidentialAddress.Shipping_Street_2__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line2
		);
		ResidentialAddress.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line3
		);
		ResidentialAddress.Shipping_City__c = BranchCIFSalesforceSyncHelper.SetTextInNameFormat(
			deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line4
		);
		ResidentialAddress.Shipping_Zip_Postal_Code__c = deviceCustomerVerificationResponse.CPBServiceResponse.Person.AddressInformation.ResidentialAddress.PostalCode.leftPad(
			4,
			'0'
		);
		update PostalAddress;
		update ResidentialAddress;
		account.PersonEmail = deviceCustomerVerificationResponse.CPBServiceResponse.Person.ContactInformation.EmailAddress.toLowerCase();
	}
}