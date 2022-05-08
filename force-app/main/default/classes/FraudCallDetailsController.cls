/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-18
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/

 public without sharing class FraudCallDetailsController {
	public static Opportunity opportunity;
	public static OpportunityLineItem opportunityLineItem;
	/**
	 * @description FraudCallDetails
	 * @return Map<String, String>
	 * @param opportunityId
	 *  
	**/
	@AuraEnabled
	public static Map<String, String> FraudCallDetails(String opportunityId)
    {

		opportunity = [SELECT CIF_Number__c, AccountId, Risk_Rating__c FROM opportunity WHERE id = :opportunityId LIMIT 1];

		Map<String, String> fraudResponseMap = new Map<String, String>();

		String accountTypeName = 'SAVINGS';
		String errorMessage = '';
			USER userRec = [
				SELECT Id, SiteCode__c, SiteType__c, Teller_Operator_Code__c, AB_Number__c, EmployeeNumber
				FROM USER
				WHERE Id = :UserInfo.getUserId()
				WITH SECURITY_ENFORCED
			];

			FraudService_Req_IB_v1 requestBean = new FraudService_Req_IB_v1();
			DateTime dt = Datetime.now();
			string tempDate = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');

			tempDate = tempDate.removeEnd('Z');

			requestBean.applicationDateTime = tempDate;
			requestBean.header = new FraudService_Req_IB_v1.Header();
			requestBean.header.channelReference = '0986532222';
			requestBean.header.channel = new FraudService_Req_IB_v1.Channel();
			requestBean.header.channel.channelDetails = new List<FraudService_Req_IB_v1.ChannelDetails>();
			FraudService_Req_IB_v1.ChannelDetails a = new FraudService_Req_IB_v1.ChannelDetails();
			a.fieldName = 'SITE_CODE';
			a.value = userRec.SiteCode__c;
			requestBean.header.channel.channelDetails.add(a);
			FraudService_Req_IB_v1.ChannelDetails b = new FraudService_Req_IB_v1.ChannelDetails();
			b.fieldName = 'USER_ID';
			b.value = userRec.AB_Number__c;
			requestBean.header.channel.channelDetails.add(b);
			FraudService_Req_IB_v1.ChannelDetails c = new FraudService_Req_IB_v1.ChannelDetails();
			c.fieldName = 'USER_TYPE';
			c.value = 'Employee';
			requestBean.header.channel.channelDetails.add(c);
			FraudService_Req_IB_v1.ChannelDetails d = new FraudService_Req_IB_v1.ChannelDetails();
			d.fieldName = 'BRANCH_NAME';
			d.value = userRec.SiteType__c;
			requestBean.header.channel.channelDetails.add(d);


			requestBean.header.channel.channelType = 'BRANCH';
			requestBean.header.channel.channelName = 'SalesForce';

			requestBean.productDetails = new FraudService_Req_IB_v1.ProductDetails();
			requestBean.productDetails.campaignReference = 0;
			requestBean.productDetails.limitAmount = 0;
			requestBean.productDetails.productSubType = accountTypeName.toLowerCase();
			requestBean.productDetails.productType = accountTypeName;


			requestBean.customerDetails = new List<FraudService_Req_IB_v1.CustomerDetails>();


			List<AccountContactRelation> relatedParty = AccountContactController.getRelatedAccounts(opportunity.accountId);
			List<Id> ids = new List<Id>();

			for (AccountContactRelation accountstokvel : relatedParty) {
				ids.Add(accountstokvel.Contact.Id);
			}
			List<Account> relatedPartyDetails = AccountContactController.GetAccountRelatedpartyDetails(ids);

			for(Account acc: relatedPartyDetails )
			{
			Address__c residentialAddress = StokvelEntityCasaCIFController.getAddessByType(acc.Id, 'Residential');
			FraudService_Req_IB_v1.CustomerDetails customerDetail = new FraudService_Req_IB_v1.CustomerDetails();
			customerDetail.addressDetails = new List<FraudService_Req_IB_v1.AddressDetails>();

			 FraudService_Req_IB_v1.AddressDetails addressDetail = new FraudService_Req_IB_v1.AddressDetails();
			addressDetail.addressDateSince = 0;
			addressDetail.addressType = 'HOME_ADDRESS';
			addressDetail.buildingName = '';
			addressDetail.postalCode = Integer.valueOf(residentialAddress.Shipping_Zip_Postal_Code__c);


			addressDetail.streetName = residentialAddress.Shipping_Street__c;
			addressDetail.streetNumber = 0;
			addressDetail.suburbOrTown = residentialAddress.Shipping_City__c;

			customerDetail.addressDetails.add(addressDetail);

			customerDetail.creditDetails = new FraudService_Req_IB_v1.CreditDetails();
			customerDetail.creditDetails.grossIncome = 0;
			customerDetail.creditDetails.totalExpenses = 0;

			customerDetail.customerIndicator = 'PRIMARY';
			customerDetail.customerType = 'NEW_TO_BANK';
			customerDetail.dateOfBirth = string.valueOf(acc.PersonBirthdate);

			customerDetail.employmentDetails = new FraudService_Req_IB_v1.EmploymentDetails();
			customerDetail.employmentDetails.companyName = acc.Employer_Name__pc;
			customerDetail.employmentDetails.employmentSector = acc.Employer_Sector__pc;
			customerDetail.employmentDetails.occupationLevel = acc.Occupation_Level__pc;
			customerDetail.employmentDetails.occupationStatus = acc.Occupation_Status__pc;
			customerDetail.employmentDetails.companyPhoneNumber = acc.Employer_Phone__c;
			customerDetail.employmentDetails.companyEmailAddress = '';
			customerDetail.employmentDetails.occupationalStatusCode = 0;

			customerDetail.firstName = acc.FirstName;
			customerDetail.gender = acc.Gender__pc.toUpperCase();
			customerDetail.identity = new FraudService_Req_IB_v1.Identity();
			customerDetail.identity.idNumber = Long.valueOf(acc.ID_Number__pc);
			customerDetail.identity.idType = acc.ID_Type__pc = 'ID_NUMBER';
			customerDetail.identity.passportNationality = acc.Nationality__pc;

			customerDetail.lastName = acc.LastName;
 			customerDetail.language = acc.Language__c;

			customerDetail.maritalStatus = convertMaritalStatus(acc.Marital_Status__pc);
			customerDetail.noOfDependants = Integer.valueOf(acc.Number_Of_Dependents__c);
			customerDetail.qualification = acc.Highest_Qualification__pc;
			customerDetail.residentialStatus = 'Owner';//acc.Residential_Status__pc;
			customerDetail.tempPermitNo = '';

			customerDetail.contactDetails = new List<FraudService_Req_IB_v1.ContactDetails>();
			FraudService_Req_IB_v1.ContactDetails emailContactDetail = new FraudService_Req_IB_v1.ContactDetails();

			emailContactDetail.contactDetailsType = 'EMAIL_ADDRESS';
			emailContactDetail.preferenceOrder = 0;
			emailContactDetail.contactDetailsDescription = 'PERSONAL_EMAIL';
			emailContactDetail.correspondence = acc.PersonEmail == null ? 'noemail@noemail.co.za' : acc.PersonEmail;
			customerDetail.contactDetails.add(emailContactDetail);

			FraudService_Req_IB_v1.ContactDetails mobileContactDetail = new FraudService_Req_IB_v1.ContactDetails();

			mobileContactDetail.contactDetailsType = 'PHONE_NUMBER';
			mobileContactDetail.preferenceOrder = 0;
			mobileContactDetail.contactDetailsDescription = 'MOBILE_NUMBER';
			mobileContactDetail.correspondence = acc.PersonMobilePhone == null ? '0000000000' : acc.PersonMobilePhone;
			customerDetail.contactDetails.add(mobileContactDetail);
			requestBean.customerDetails.add(customerDetail);
		}

				try {
					FraudService_Resp_IB_V1 responseBean = FraudService_IH_V1.FraudService(requestBean);

					errorMessage =  JSON.serializePretty(responseBean);

					if (responseBean.errors != null) {
						for (FraudService_Resp_IB_V1.Error error : responseBean.errors) {
							errorMessage = errorMessage + ' ' + error.message + ',';

						}
						throw new AuraHandledException(errorMessage);
					} else if (responseBean.content.fraudStatus != null) {

						if(responseBean.content.fraudStatus  == 'SUSPICIOUS' || responseBean.content.fraudStatus  == 'SUSPECT' ||  responseBean.content.fraudStatus  ==  'HIGH FRAUD POTENTIAL')
						{
							fraudResponseMap.put('indicator','Y');
						}
						else{
							fraudResponseMap.put('indicator', 'N');
						}

						fraudResponseMap.put('fraudStatus', responseBean.content.fraudStatus);
						fraudResponseMap.put('applicationNbr', responseBean.content.applicationNumber);


						opportunityLineItem = [SELECT FraudSyncStatus__c,ProductCode, Product2Id, Price_Scheme_Code__c, Policy_Number__c
						FROM OpportunityLineItem
						WHERE OpportunityId = :opportunityId AND Product_Family__c = 'Savings'];

						OpportunityLineItem.Fraud_Application_Number__c = responseBean.content.applicationNumber;

						OpportunityLineItem.FraudIndicator__c = responseBean.content.fraudStatus == 'CLEAN' ? 'N' : 'Y';
						OpportunityLineItem.FraudSyncStatus__c = responseBean.content.fraudStatus;

						update OpportunityLineItem;


					return fraudResponseMap;

					} else {
						return Null;
					}
				} catch (Exception ex) {
					return Null;
				}

		}

		/**
	 * @description convertMaritalStatus
	 * @author NK| 2021-10-08
	 * @param status
	 * @return string
	 **/
	public static string convertMaritalStatus(string status) {
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