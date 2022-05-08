/**
 * @description       : FraudMetadataHelper
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-25
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-07-05   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-07-05   André Pietersen (IQ Business)   Marital Status conversion
 **/
public without sharing class FraudMetadataHelper {
	public enum AccountType {
		CHEQUE,
		SAVINGS
	}

	/**
	 * @description
	 * @author André Pietersen (IQ Business) | 2021-07-05
	 * @param oppId
	 * @param accountType
	 * @return Map<String, String>
	 **/
	@AuraEnabled
	public static Map<String, String> getFraudIndicator(string oppId, AccountType accountType) {
		Opportunity opp = [SELECT Id, AccountId, CIF_Number__c, CBPIndicator__c FROM Opportunity WHERE Id = :oppId WITH SECURITY_ENFORCED];

		Account acc = [
			SELECT
				Id,
				Name,
				FirstName,
				LastName,
				Income_Source__pc,
				CASA_Risk_Status__c,
				PersonBirthdate,
				Employer_Name__pc,
				Employer_Sector__pc,
				Occupation_Level__pc,
				Occupation_Status__pc,
				Employer_Phone__c,
				Gender__pc,
				ID_Number__pc,
				ID_Type__pc,
				Nationality__pc,
				Language__c,
				Marital_Status__pc,
				Number_Of_Dependents__c,
				Highest_Qualification__pc,
				Residential_Status__pc,
				PersonEmail,
				PersonMobilePhone
			FROM Account
			WHERE Id = :opp.AccountId
			WITH SECURITY_ENFORCED];

		USER userRec = [
			SELECT Id, SiteCode__c, SiteType__c, Teller_Operator_Code__c, AB_Number__c, EmployeeNumber
			FROM USER
			WHERE Id = :UserInfo.getUserId()
			WITH SECURITY_ENFORCED
		];

		Address__c addr = [
			SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :acc.Id AND Address_TYpe__c = 'Residential'
			WITH SECURITY_ENFORCED
		];

		Map<String, String> fraudResponseMap = new Map<String, String>();
		FraudSyncApplication_Req_IB_V1 requestBean = new FraudSyncApplication_Req_IB_V1();
		DateTime dt = Datetime.now();
		requestBean.applicationDateTime = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');

		requestBean.header = new FraudSyncApplication_Req_IB_V1.Header();
		requestBean.header.channelReference = '0986532222';

		requestBean.header.channel = new FraudSyncApplication_Req_IB_V1.Channel();
		requestBean.header.channel.channelDetails = new List<FraudSyncApplication_Req_IB_V1.ChannelDetails>();
		FraudSyncApplication_Req_IB_V1.ChannelDetails a = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		a.fieldName = 'SITE_CODE';
		a.value = userRec.SiteCode__c;
		requestBean.header.channel.channelDetails.add(a);

		FraudSyncApplication_Req_IB_V1.ChannelDetails b = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		b.fieldName = 'USER_ID';
		b.value = userRec.AB_Number__c;
		requestBean.header.channel.channelDetails.add(b);

		FraudSyncApplication_Req_IB_V1.ChannelDetails c = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		c.fieldName = 'USER_TYPE';
		c.value = 'Employee';
		requestBean.header.channel.channelDetails.add(c);

		FraudSyncApplication_Req_IB_V1.ChannelDetails d = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		d.fieldName = 'BRANCH_NAME';
		d.value = userRec.SiteType__c;
		requestBean.header.channel.channelDetails.add(d);

		FraudSyncApplication_Req_IB_V1.ChannelDetails e = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		e.fieldName = 'IP_ADDRESS';
		e.value = '190.90.92'; //ApexPages.currentPage().getHeaders().get('True-Client-IP');
		requestBean.header.channel.channelDetails.add(e);

		FraudSyncApplication_Req_IB_V1.ChannelDetails f = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		f.fieldName = 'TERMINAL_ID';
		f.value = userRec.Teller_Operator_Code__c;
		requestBean.header.channel.channelDetails.add(f);

		FraudSyncApplication_Req_IB_V1.ChannelDetails g = new FraudSyncApplication_Req_IB_V1.ChannelDetails();
		g.fieldName = 'OS';
		g.value = 'windows';
		requestBean.header.channel.channelDetails.add(g);

		requestBean.header.channel.channelType = 'BRANCH';
		requestBean.header.channel.channelName = 'SalesForce';

		requestBean.productDetails = new FraudSyncApplication_Req_IB_V1.ProductDetails();
		requestBean.productDetails.campaignReference = 0;
		requestBean.productDetails.limitAmount = 0;
		requestBean.productDetails.productSubType = accountType.name().toLowerCase();
		requestBean.productDetails.productType = accountType.name();

		requestBean.customerDetails = new List<FraudSyncApplication_Req_IB_V1.CustomerDetails>();
		FraudSyncApplication_Req_IB_V1.CustomerDetails customerDetail = new FraudSyncApplication_Req_IB_V1.CustomerDetails();

		customerDetail.addressDetails = new List<FraudSyncApplication_Req_IB_V1.AddressDetails>();

		FraudSyncApplication_Req_IB_V1.AddressDetails addressDetail = new FraudSyncApplication_Req_IB_V1.AddressDetails();
		addressDetail.addressDateSince = 0;
		addressDetail.addressType = 'HOME_ADDRESS';
		addressDetail.buildingName = '';
		addressDetail.postalCode = Integer.valueOf(addr.Shipping_Zip_Postal_Code__c);
		addressDetail.streetName = addr.Shipping_Street__c;
		addressDetail.streetNumber = 0;
		addressDetail.suburbOrTown = addr.Shipping_City__c;

		customerDetail.addressDetails.add(addressDetail);

		customerDetail.creditDetails = new FraudSyncApplication_Req_IB_V1.CreditDetails();
		customerDetail.creditDetails.grossIncome = 0;
		customerDetail.creditDetails.totalExpenses = 0;

		customerDetail.customerIndicator = 'PRIMARY';
		customerDetail.customerType = 'NEW_TO_BANK';
		customerDetail.dateOfBirth = string.valueOf(acc.PersonBirthdate);

		customerDetail.employmentDetails = new FraudSyncApplication_Req_IB_V1.EmploymentDetails();
		customerDetail.employmentDetails.companyName = acc.Employer_Name__pc == null ? '': acc.Employer_Name__pc;
		customerDetail.employmentDetails.employmentSector = acc.Employer_Sector__pc == null ? '': acc.Employer_Sector__pc;
		customerDetail.employmentDetails.occupationLevel = acc.Occupation_Level__pc == null ? '': acc.Occupation_Level__pc;
		customerDetail.employmentDetails.occupationStatus = acc.Occupation_Status__pc == null ? '': acc.Occupation_Status__pc;
		customerDetail.employmentDetails.companyPhoneNumber = acc.Employer_Phone__c == null ? '': acc.Employer_Phone__c;
		customerDetail.employmentDetails.companyEmailAddress = '';
		customerDetail.employmentDetails.occupationalStatusCode = 0;

		customerDetail.firstName = acc.FirstName;
		customerDetail.gender = acc.Gender__pc.toUpperCase();

		customerDetail.identity = new FraudSyncApplication_Req_IB_V1.Identity();
		customerDetail.identity.idNumber = Long.valueOf(acc.ID_Number__pc);
		customerDetail.identity.idType = acc.ID_Type__pc == 'SA Identity Document' ? 'ID_NUMBER' : 'PASSPORT';
		customerDetail.identity.passportNationality = acc.Nationality__pc;

		customerDetail.language = acc.Language__c;
		customerDetail.lastName = acc.LastName;
		customerDetail.maritalStatus = convertMaritalStatus(acc.Marital_Status__pc);
		customerDetail.noOfDependants = Integer.valueOf(acc.Number_Of_Dependents__c);
		customerDetail.qualification = acc.Highest_Qualification__pc;
		customerDetail.residentialStatus = acc.Residential_Status__pc;
		customerDetail.tempPermitNo = '';

		customerDetail.contactDetails = new List<FraudSyncApplication_Req_IB_V1.ContactDetails>();
		FraudSyncApplication_Req_IB_V1.ContactDetails emailContactDetail = new FraudSyncApplication_Req_IB_V1.ContactDetails();

		emailContactDetail.contactDetailsType = 'EMAIL_ADDRESS';
		emailContactDetail.preferenceOrder = 0;
		emailContactDetail.contactDetailsDescription = 'PERSONAL_EMAIL';
		emailContactDetail.correspondence = acc.PersonEmail == null ? 'noemail@noemail.co.za' : acc.PersonEmail;
		customerDetail.contactDetails.add(emailContactDetail);

		FraudSyncApplication_Req_IB_V1.ContactDetails mobileContactDetail = new FraudSyncApplication_Req_IB_V1.ContactDetails();

		mobileContactDetail.contactDetailsType = 'PHONE_NUMBER';
		mobileContactDetail.preferenceOrder = 0;
		mobileContactDetail.contactDetailsDescription = 'MOBILE_NUMBER';
		mobileContactDetail.correspondence = acc.PersonMobilePhone == null ? '0000000000' : acc.PersonMobilePhone;
		customerDetail.contactDetails.add(mobileContactDetail);

		requestBean.customerDetails.add(customerDetail);

		String errorMessage = '';

		try {
			FraudSyncApplication_Resp_IB_V1 responseBean = FraudSyncApplication_IH_V1.syncFraudApplication(requestBean);
			if (responseBean.errors != null) {
				for (FraudSyncApplication_Resp_IB_V1.Error error : responseBean.errors) {
					errorMessage = errorMessage + ' ' + error.message + ',';
				}
				throw new AuraHandledException(errorMessage);
			} else if (responseBean.content.fraudStatus != null) {
				fraudResponseMap.put('indicator', responseBean.content.fraudStatus == 'CLEAN' ? 'N' : 'Y');
				fraudResponseMap.put('fraudStatus', responseBean.content.fraudStatus);
				fraudResponseMap.put('applicationNbr', responseBean.content.applicationNumber);
				return fraudResponseMap;
			} else {
				return fraudResponseMap;
			}
		} catch (Exception ex) {
			return fraudResponseMap;
		}
	}

	/**
	 * @description submitAccountMetadata
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param oppId
	 * @param accountType
	 * @return string
	 **/
	@AuraEnabled
	public static string submitAccountMetadata(string oppId, AccountType accountType) {
		Opportunity opp = [SELECT Id, AccountId, CIF_Number__c, CBPIndicator__c FROM Opportunity WHERE Id = :oppId WITH SECURITY_ENFORCED];

		Account acc = [SELECT Id, CASA_Risk_Status__c FROM Account WHERE Id = :opp.AccountId WITH SECURITY_ENFORCED];

		USER userRec = [
			SELECT Id, SiteCode__c, SiteType__c, Teller_Operator_Code__c, AB_Number__c, EmployeeNumber
			FROM USER
			WHERE Id = :UserInfo.getUserId()
			WITH SECURITY_ENFORCED
		];

		List<OpportunityLineItem> oppproducts = [
			SELECT
				Id,
				Product_Family__c,
				ProductCode,
				Product2.Price_Scheme_Code__c,
				Policy_Number__c,
				FraudIndicator__c,
				FraudSyncStatus__c,
				Fraud_Application_Number__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :oppId
			WITH SECURITY_ENFORCED
		];

		OpportunityLineItem oppProduct = new OpportunityLineItem();

		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == accountType.name().toLowerCase()) {
				oppProduct = o;
				break;
			}
		}

		String errorMessage = '';
		try {
			//If no Fraud status was return service must be skipped or it will break
			if (string.isBlank(oppProduct.FraudSyncStatus__c) || string.isEmpty(oppProduct.FraudSyncStatus__c)) {
				return 'SKIPPED';
			}

			AccountsMetadata_Req_IB_v1 requestBean = new AccountsMetadata_Req_IB_v1();
			requestBean.channel = new AccountsMetadata_Req_IB_v1.Channel();
			requestBean.channel.channelDetails = new AccountsMetadata_Req_IB_v1.ChannelDetails();
			requestBean.holddetails = new AccountsMetadata_Req_IB_v1.HoldDetails();

			DateTime dt = Datetime.now();
			requestBean.applicationDateTime = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
			requestBean.applicationNumber = oppProduct.Fraud_Application_Number__c;

			requestBean.channel.channelDetails.branchcode = userRec.SiteCode__c;
			requestBean.channel.channelDetails.branchsitetype = userRec.SiteType__c;
			requestBean.channel.channelDetails.sitetypeagency = '0';
			requestBean.channel.channelDetails.agencycode = '0';
			requestBean.channel.channelDetails.tellernumber = userRec.Teller_Operator_Code__c;
			requestBean.channel.channelDetails.supervisorcode = '0';
			requestBean.channel.channelDetails.channelname = 'F';

			requestBean.crpCode = 'ABS';
			requestBean.cifcode = opp.CIF_Number__c;
			requestBean.accountnumber = oppProduct.Policy_Number__c;

			requestBean.holddetails.FRAUD = oppProduct.FraudSyncStatus__c == 'HIGH_FRAUD_POTENTIAL' ? 'HFP' : oppProduct.FraudSyncStatus__c;
			requestBean.holddetails.RBA = CQcreateAndLinkAccountController.determineEddLevel(acc.CASA_Risk_Status__c);
			requestBean.holddetails.CASA = 'PROCEED';

			AccountsMetadata_Resp_IB_v1 responseBean = AccountsMetadata_IH_v1.submitAccountMetadata(requestBean);
			if (responseBean.message != null) {
				errorMessage = responseBean.error + ' ' + responseBean.message;
				throw new AuraHandledException(errorMessage);
			} else if (responseBean.status == 'FAILED') {
				if (responseBean.errors.size() > 0) {
					for (AccountsMetadata_Resp_IB_v1.Error error : responseBean.errors) {
						errorMessage = errorMessage + ' ' + error.message + ',';
					}
				}
				throw new AuraHandledException(responseBean.message);
			} else if (responseBean.status == 'SUCCESSFUL') {
				return responseBean.data;
			}
			return 'ERROR';
		} catch (Exception ex) {
			throw new AuraHandledException('Error Message: ' + ex.getMessage() + ' ' + 'Error Cause: ' + ex.getCause() + ' ' + errorMessage);
		}
	}

	/**
	 * @description convertMaritalStatus
	 * @author André Pietersen (IQ Business) | 2021-08-27
	 * @param status
	 * @return string
	 **/
	private static string convertMaritalStatus(string status) {
		status = status.toUpperCase();
		switch on status {
			when 'MARRIED', 'SINGLE', 'DIVORCED', 'WIDOWED' {
				return status;
			}
			when 'SEPARATED' {
				return 'DIVORCED';
			}
			when else {
				return 'SINGLE';
			}
		}
	}
}