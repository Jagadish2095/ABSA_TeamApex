/**
 * @description       :
 * @author            : Humbelani Denge 2021/01/28
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/

public class AccountRestructureCntr {
	/**
	 * @description get current contract details from external system
	 * @author Mradul Maheshwari | 30-08-2021
	 * @param  iAccount
	 * @return String
	 **/
	@AuraEnabled
	public static String getContractDetailsfromServer(String iAccount) {
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

		if (String.isBlank(currentUser.AB_Number__c)) {
			return 'Error: Blank value provided for currentUser AB_Number__c.';
		}

		if (String.isBlank(iAccount) || iAccount == null) {
			return 'Error: Blank value provided for Account Number';
		}
		BAPISFContrDetails_Resp_IB_v1 responseBean = BAPISFContrDetails_IH_v1.BAPISFContrDetails(iAccount, currentUser.AB_Number__c);

		if (responseBean == null) {
			return 'Error: Blank response received from service.';
		}
		if (responseBean.BAPI_SF_CONTR_DETAILS[0] != null) {
			if (responseBean.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.E_RESPONSE != 0) {
				return 'Error: ' + responseBean.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.E_RESPONSE_DESC;
			}
		}

		if (responseBean.BAPI_SF_CONTR_DETAILS.isEmpty()) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(responseBean);
		}

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		List<BAPISFContrDetails_Resp_IB_v1.BAPI_SF_CONTR_DETAILS> contractDetails = responseBean.BAPI_SF_CONTR_DETAILS;
		return JSON.serialize(contractDetails);
	}

	/**
	 * @description get information to validate before proceeding with adjustment options
	 * @author Mradul Maheshwari | 30-08-2021
	 * @param  accountNumber
	 * @return String
	 **/
	@AuraEnabled
	public static String getPrevalidationInfo(String accountNumber) {
		AccountPreValidationRequest_Resp_IB_v1 responseBean;
		if (accountNumber != null) {
			responseBean = AccountPreValidationRequest_IH_v1.accountPreValidationRequest(accountNumber);
		} else {
			return 'Error: Blank value provided for Account Number';
		}

		if (responseBean == null) {
			return 'Error: Blank response received from service.';
		}

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		if (responseBean.restructureResults == null || responseBean.restructureResults.result == null || responseBean.restructureResults.result.isEmpty()) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(responseBean);
		}

		List<AccountPreValidationRequest_Resp_IB_v1.Result> preValidationResult = responseBean.RestructureResults.result;
		for (AccountPreValidationRequest_Resp_IB_v1.Result res : preValidationResult) {
			res.type = res.type.capitalize();
		}
		return JSON.serialize(preValidationResult);
	}

	/**
	 * @description load adjustment options and update the restructure type
	 * @author Mradul Maheshwari | 30-08-2021
	 * @param  accountNumber
	 * @param  advanceAmount
	 * @return String
	 **/
	@AuraEnabled(cacheable=false)
	public static String loadTermOptionsfromServer(String accountNumber, String advanceAmount) {
		CalculatorRequest_Resp_IB_v1 responseBean;

		if (accountNumber != null && advanceAmount != null) {
			responseBean = CalculatorRequest_IH_v1.calculatorRequest(accountNumber, advanceAmount);
		} else {
			return 'Error: Blank value provided for Account Number or Advance Amount';
		}
		if (responseBean == null) {
			return 'Error: Blank response received from service.';
		}

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		if (
			responseBean.calculatorResults == null ||
			responseBean.calculatorResults.calculatorResult == null ||
			responseBean.calculatorResults.calculatorResult.isEmpty()
		) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(responseBean);
		}

		List<CalculatorRequest_Resp_IB_v1.CalculatorResult> termOptions = responseBean.calculatorResults.calculatorResult;

		// in response the reduce and removed isnt specified, becuase of which we are updating the restructureType accordingl
		// using residual amount for balloons
		for (CalculatorRequest_Resp_IB_v1.CalculatorResult option : termOptions) {
			if (option.restructureType.contains('term')) {
				option.restructureType = option.restructureType.replace('term', 'Reduce Term');
			}
			if (option.restructureType.contains('instalment')) {
				option.restructureType = option.restructureType.replace('instalment', 'Reduce Instalment');
			}
			if (option.restructureType.contains('balloon')) {
				if (option.newResidual == 0) {
					option.restructureType = option.restructureType.replace('balloon', 'Remove Balloon');
				} else {
					option.restructureType = option.restructureType.replace('balloon', 'Reduce Balloon');
				}
			}
		}

		return JSON.serialize(termOptions);
	}

	/**
	 * @description sends request after consent to adjust loan given by the client
	 * @author Mradul Maheshwari | 30-08-2021
	 * @param  accountNumber
	 * @param  advanceAmount
	 * @param  restructureOption
	 * @param  email
	 * @param  consent
	 * @param  newInstallment
	 * @param  newCalculatedInstallmentsNo
	 * @param  newTerm
	 * @param  newContractEndDate
	 * @param  newResidualAmount
	 * @return String
	 **/
	@AuraEnabled
	public static String confirmAdjustment(
		String accountNumber,
		String advanceAmount,
		String restructureOption,
		String email,
		String consent,
		String newInstallment,
		String newCalculatedInstallmentsNo,
		String newTerm,
		String newContractEndDate,
		String newResidualAmount
	) {
		AccountRestructureRequest_Resp_IB_v1 responseBean;
		if (accountNumber != null && advanceAmount != null && restructureOption != null) {
			// in response the reduce and removed isnt specified, becuase of which we are updating the restructureType accordingl
			// using residual amount for balloons
			restructureOption = restructureOption.remove('Reduce');
			restructureOption = restructureOption.remove('Remove');
			restructureOption = restructureOption.remove(' ');
			restructureOption = restructureOption.toLowerCase();

			responseBean = AccountRestructureRequest_IH_v1.accountRestructureRequest(
				accountNumber, //'75678237', //'75272427'
				advanceAmount, //'10000',
				restructureOption,
				email,
				consent,
				newInstallment,
				newCalculatedInstallmentsNo,
				newTerm,
				newContractEndDate,
				newResidualAmount
			);
		} else {
			return 'Error: Invalid Details Provided';
		}

		if (responseBean == null) {
			return 'Error: Blank response received from service.';
		}

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		if (responseBean.responseMessage == null || responseBean.restructureOption == null) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(responseBean);
		}

		AccountRestructureRequest_Resp_IB_v1 accountRestructureResponse = responseBean;

		return JSON.serialize(accountRestructureResponse);
	}

	/**
	 * @description notifies the client via email
	 * @author Mradul Maheshwari | 30-08-2021
	 * @param  emailAddress
	 * @param  caseId
	 * @param  selectedOption
	 * @param  corporateCode
	 * @return String
	 **/
	@AuraEnabled
	public static String sendEmail(String emailAddress, String caseId, String selectedOption, String corporateCode) {
		String emailTemplateName = System.Label.AVAF_Loan_Adjustment_Email_Template;
		OrgWideEmailAddress[] owea;
		if (corporateCode == 'Absa Vehicle Finance' || corporateCode == 'AVF') {
			owea = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :System.Label.AVAF_From_Email];
		} else {
			owea = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :System.Label.Ford_From_Email];
		}

		if (owea != null) {
			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
			List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseId, targetObjectId, emailAddress, emailTemplateName);

			if (constructEmail != null && constructEmail.size() > 0) {
				Messaging.SingleEmailMessage email = constructEmail[0];
				string[] toAddress = new List<string>{ emailAddress };
				String subject;
				String htmlGreeting;
				String htmlFooter;
				String absaFord = '';
				if (corporateCode == 'Absa Vehicle Finance' || corporateCode == 'AVF') {
					subject = ' Success Notification - AVAF';
					htmlGreeting = 'Absa';
					htmlfooter = 'Avaf Service ';
					absaFord = 'Absa vehicle finance';
				} else {
					absaFord = 'vehicle';
					subject = '	Success Notification –Ford ';
					htmlGreeting = 'Ford';
					htmlfooter = 'Ford Tribe Customer Service Consultants | Ford Credit South Africa ';
				}
				String emailBody = email.getHtmlBody();
				//List of comments
				String htmlBody = 'Please note that your ';

				String[] options = selectedOption.split(' and');

				String[] words = options[0].split(' ');

				htmlBody +=
					words[1].toLowerCase() +
					' for your ' +
					absaFord +
					' account has been requested to be ' +
					words[0].toLowerCase() +
					'd going forward ';
				if (options.size() > 1) {
					words = options[1].split(' ');
					htmlBody += 'and your ' + words[2].toLowerCase() + ' has been requested to be reduced with the surplus capital,';
				}
				String caseNumber = [SELECT caseNumber FROM case WHERE id = :caseId LIMIT 1][0].caseNumber;

				htmlBody += ' ,your case ' + caseNumber + ' will be closed.';

				emailBody = emailBody.replace('[apexData]', htmlBody);
				emailBody = emailBody.replace('[greeting]', htmlGreeting);
				emailBody = emailBody.replace('[footer]', htmlFooter);

				Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
				emailMessage.setOrgWideEmailAddressId(owea.get(0).Id);
				emailMessage.setToAddresses(toAddress);
				emailMessage.setSubject(subject);
				emailMessage.setHtmlBody(emailBody);
				emailMessage.saveAsActivity = false;

				//Send Email
				Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });

				//Attach Email to Case
				EmailMessage emailMsg = new EmailMessage();
				emailMsg.FromAddress = owea.get(0).Address;
				emailMsg.Subject = subject;
				emailMsg.HtmlBody = emailBody;
				emailMsg.ParentId = caseId;
				insert emailMsg;

				return 'Email sent Successfully ';
			} else {
				//Error - unable to construct Email
				return 'Error: Unable to construct email. EmailHandler.ComposeEmail(' +
					caseId +
					' ' +
					targetObjectId +
					' ' +
					emailAddress +
					' ' +
					emailTemplateName +
					')';
			}
		} else {
			//Error - No OrgWideEmailAddress found
			return 'Error: Unable to find a matching Org Wide Email Address from the Email Address specified on the Service_Group__c of this Case. ';
		}
	}
}