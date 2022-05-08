/**
 * @description GenerateDocument is the main engine for generating Docs in the system
 *
 */
public class GenerateDocument{
	/**
	 * @description generateNewDocument main method to generate Documents - used by most
	 *
	 * @param opportunityId (Id): ApplicationProductId
	 * @param templateName (String): templateName
	 * @param signatureRequests (List<SignatureRequest__c>): signatureRequests
	 * @return Map<String,String>: Return description
	 */
	@AuraEnabled
	public static Map<String, String> generateNewDocument(Id opportunityId, String templateName, List<SignatureRequest__c> signatureRequests){
		// added to generate documents for Case
        if(opportunityId.getSObjectType().getDescribe().getName() == 'Case'){
            return generateDocumentForCase(opportunityId, templateName);
        }
		Map<String, String> result = new Map<String, String>();
		result = generateNewDocument(opportunityId, templateName, signatureRequests, null);
		return result;
	}
    
	/**
	* @description 
	* @author muvhuso.nekhubvi@absa.africa | 2021-08-18 
	* @param opportunityId 
	* @param templateName 
	* @param signatureRequests 
	* @param documentId 
	* @return Map<String, String> 
	**/
    @AuraEnabled
	public static Map<String, String> generateNewDocument(Id opportunityId, String templateName, List<SignatureRequest__c> signatureRequests,string documentId){
		// added to generate documents for Case
        if(opportunityId.getSObjectType().getDescribe().getName() == 'Case'){
            return generateDocumentForCase(opportunityId, templateName);
        }
		Map<String, String> result = new Map<String, String>();
		try{
			Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);
			Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);

			// this is what masimba is pushing us to use ina new supposedly simplified way
			DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
			DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();

			// get Opportunity
			string itc = opp.Merchant_TransUnion_Inquiry_Passed__c == true ? 'Yes' : opp.Merchant_TransUnion_Inquiry_Passed__c == false ? 'No' : null;
			contextBuilder.add('itc', itc);
			string experian = opp.Merchant_Experian_Inquiry_Passed__c == true ? 'Yes' : opp.Merchant_Experian_Inquiry_Passed__c == false ? 'No' : null;
			contextBuilder.add('experian', experian);
			string match = opp.Merchant_Match_Inquiry_Passed__c == true ? 'Yes' : opp.Merchant_Match_Inquiry_Passed__c == false ? 'No' : null;
			contextBuilder.add('match', match);
			contextBuilder.add('Opportunity', opp);

			Account accountRecord = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);

			// get addresses
			List<Address__c> addresses = new AddressesSelector().addressesRelatedToAcc(opp.AccountId);
			if (!addresses.isEmpty() && addresses.size() > 0 && addresses != null){
				List<Address__c> operatingAddress = new List<Address__c>();
				List<Address__c> postalAddress = new List<Address__c>();
				List<Address__c> physicalAddress = new List<Address__c>();
				List<Address__c> residentialAddress = new List<Address__c>();
				List<Address__c> employersAddress = new List<Address__c>();
				List<Address__c> registeredAddress = new List<Address__c>();
				List<Address__c> businessAddress = new List<Address__c>();
				List<Address__c> masterCourtAddress = new List<Address__c>();
				List<Address__c> headOfficeAddress = new List<Address__c>();

				for (Address__c address : addresses){
					switch on address.Address_Type__c{
						when 'OperatingAddress'{
							operatingAddress.add(address);
						}
						when 'Postal'{
							postalAddress.add(address);
						}
						when 'Physical Address'{
							physicalAddress.add(address);
						}
						when 'Residential'{
							residentialAddress.add(address);
						}
						when 'Employers'{
							employersAddress.add(address);
						}
						when 'Registered'{
							if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor'){
								registeredAddress.add(address);
							}
						}
						when 'Business Address'{
							businessAddress.add(address);
						}
						when 'Master of High Court'{
							if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor'){
								MasterCourtAddress.add(address);
							}
						}
						when 'Head Office'{
							if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor'){
								headOfficeAddress.add(address);
							}
						}
					}
				}
				if (!operatingAddress.isEmpty() && operatingAddress.size() > 0 && operatingAddress != null){
					contextBuilder.add('OperatingAddress', operatingAddress.get(0));
				}
				if (!postalAddress.isEmpty() && postalAddress.size() > 0 && postalAddress != null){
					contextBuilder.add('PostalAddress', postalAddress.get(0));
				}
				if (!physicalAddress.isEmpty() && physicalAddress.size() > 0 && physicalAddress != null){
					contextBuilder.add('PhysicalAddress', physicalAddress.get(0));
				}
				if (!residentialAddress.isEmpty() && residentialAddress.size() > 0 && residentialAddress != null){
					contextBuilder.add('ResidentialAddress', residentialAddress.get(0));
				}
				if (!employersAddress.isEmpty() && employersAddress.size() > 0 && employersAddress != null){
					contextBuilder.add('EmployersAddress', employersAddress.get(0));
				}
				if (!RegisteredAddress.isEmpty() && RegisteredAddress.size() > 0 && RegisteredAddress != null){
					contextBuilder.add('RegisteredAddress', RegisteredAddress.get(0));
				}
				if (!businessAddress.isEmpty() && businessAddress.size() > 0 && businessAddress != null){
					contextBuilder.add('BusinessAddress', businessAddress.get(0));
				}
				if (!masterCourtAddress.isEmpty() && masterCourtAddress.size() > 0 && masterCourtAddress != null){
					contextBuilder.add('MasterCourtAddress', masterCourtAddress.get(0));
				}
				if (!headOfficeAddress.isEmpty() && headOfficeAddress.size() > 0 && headOfficeAddress != null){
					contextBuilder.add('HeadOfficeAddress', headOfficeAddress.get(0));
				}
			}

			if (accountRecord.Client_Type__c == 'Sole Trader' || accountRecord.Client_Type__c == 'Sole Proprietor'){
				contextBuilder.add('soleTrader', 'YES');
			}

			if (!(accountRecord.Marital_Status__pc == 'Divorced' || accountRecord.Marital_Status__pc == 'Married' || accountRecord.Marital_Status__pc == 'Separated' ||
				accountRecord.Marital_Status__pc == 'Single' || accountRecord.Marital_Status__pc == 'Widowed' )){
				contextBuilder.add('otherMarital', 'YES');
			}
            if (accountRecord.Country_of_Foreign_tax__c != 'South Africa' ){
				contextBuilder.add('foreignCountry', 'YES');
			}

			if (!(accountRecord.PersonTitle == 'MR' || accountRecord.PersonTitle == 'MRS' || accountRecord.Marital_Status__pc == 'MISS')){
				contextBuilder.add('otherTitle', 'YES');
			}

			contextBuilder.add('myclientType',Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountRecord.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE));
            contextBuilder.add('mySicCode',Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', accountRecord.Standard_Industry_SIC_Code__c, StringConstants.OUTBOUND_RECORD_TYPE));
            
            //Communication prefence
            string commMethod = accountRecord.Preferred_Communication_Method__c == 'Mail'?'POST' : accountRecord.Preferred_Communication_Method__c == 'Phone'?'Telephone':accountRecord.Preferred_Communication_Method__c;
            contextBuilder.add('commMethod',commMethod);
            string comMethod = accountRecord.Preferred_Communication_Method__pc == 'Mail'?'POST' : accountRecord.Preferred_Communication_Method__pc == 'Phone'?'Telephone':accountRecord.Preferred_Communication_Method__pc;
            contextBuilder.add('comMethod',comMethod);
            String contactSMSPhone = (commMethod == 'SMS' || commMethod == 'Phone') || (comMethod == 'SMS' || comMethod == 'Phone') ? 'Phone' : '';
            String contactEmail = (commMethod == 'Email' || comMethod == 'Email') ? 'Email' : '';
            String preferredMethod = accountRecord.Preferred_Communication_Method__c == 'Mail' || accountRecord.Preferred_Communication_Method__c == 'Post' ? 'Mail' : accountRecord.Preferred_Communication_Method__c;
            String preferredMethodInd = accountRecord.Preferred_Communication_Method__pc == 'Mail' || accountRecord.Preferred_Communication_Method__pc == 'Post' ? 'Mail' : accountRecord.Preferred_Communication_Method__pc;
            
            contextBuilder.add('contactSMSPhone',contactSMSPhone);
            contextBuilder.add('contactEmail',contactEmail);
            contextBuilder.add('preferredMethod',preferredMethod);
            contextBuilder.add('preferredMethodInd',preferredMethodInd);
			//transform some of the data as required by Docfusion
			accountRecord.Financial_Year_End__c = accountRecord.Financial_Year_End__c == 'January' ? '01' : accountRecord.Financial_Year_End__c == 'February' ? '02' : accountRecord.Financial_Year_End__c == 'March' ? '03' : accountRecord.Financial_Year_End__c == 'April' ? '04' : accountRecord.Financial_Year_End__c == 'May' ? '05' : accountRecord.Financial_Year_End__c == 'June' ? '06' : accountRecord.Financial_Year_End__c == 'July' ? '07' : accountRecord.Financial_Year_End__c == 'August' ? '08' : accountRecord.Financial_Year_End__c == 'September' ? '09' : accountRecord.Financial_Year_End__c == 'October' ? '10' : accountRecord.Financial_Year_End__c == 'November' ? '11' : accountRecord.Financial_Year_End__c == 'December' ? '12' : '';
			accountRecord.ID_Type__c = accountRecord.ID_Type__c == 'SA Identity Document' ? 'ID Book' : accountRecord.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : accountRecord.ID_Type__c;
			accountRecord.ID_Type__pc = accountRecord.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : accountRecord.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : accountRecord.ID_Type__pc;
			accountRecord.Marital_Contract_Type__pc = accountRecord.Marital_Contract_Type__pc == 'Out Of Community Of Property With Accrual' ? 'Antenuptial contract (with accrual)' : accountRecord.Marital_Contract_Type__pc == 'Out Of Community Of Property Without Accrual' ? 'Antenuptial contract (without accrual)' : accountRecord.Marital_Contract_Type__pc == 'In Community Of Property' ? 'Community of property' : accountRecord.Marital_Contract_Type__pc == 'Community Of Property' ? 'Community of property' : accountRecord.Marital_Contract_Type__pc;
			accountRecord.Marital_Status__pc = accountRecord.Marital_Status__pc == 'Widowed' ? 'Widow/Widower' : accountRecord.Marital_Status__pc;
			accountRecord.Certified_Copy_of_the_Licence_Received__c = accountRecord.Certified_Copy_of_the_Licence_Received__c == 'Yes' ? 'YES' : accountRecord.Certified_Copy_of_the_Licence_Received__c == 'No' ? 'NO' : accountRecord.Certified_Copy_of_the_Licence_Received__c;
			accountRecord.Conditions_and_Restrictions__c = accountRecord.Conditions_and_Restrictions__c == 'Yes' ? 'YES' : accountRecord.Conditions_and_Restrictions__c == 'No' ? 'NO' : accountRecord.Conditions_and_Restrictions__c;
			accountRecord.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', accountRecord.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
			String occupationStatus = accountRecord.Occupation_Status__pc == 'Part Time Employed' ? 'Part-Time Employed/Contract' : accountRecord.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : accountRecord.Occupation_Status__pc == 'Self Employed Professional' ? 'Self Employed (Professional)' : accountRecord.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self Employed ( Non-Professional)' : accountRecord.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary Employed' : accountRecord.Occupation_Status__pc;
			contextBuilder.add('occupationStatus', occupationStatus);
            accountRecord.Occupation_Status__pc = accountRecord.Occupation_Status__pc == 'Part Time Employed' ? 'Part-time employed/Contract worker' : accountRecord.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : accountRecord.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : accountRecord.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : accountRecord.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : accountRecord.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : accountRecord.Occupation_Status__pc;
			
            String highRiskIndustry  = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'High Risk Industry', accountRecord.The_Client_is_involved_in_High_Risk_Indu__c, StringConstants.INBOUND_RECORD_TYPE);
			contextBuilder.add('highRiskIndustry', highRiskIndustry);
            
            if (accountRecord.Industry == 'Agriculture, Hunting, Forestry And Fishing'){
				contextBuilder.add('agriculture', 'YES');
			}
			//Check source of income
			if (!(accountRecord.Source_of_Income__c == 'Development Funding' || accountRecord.Source_of_Income__c == 'Donation' || accountRecord.Source_of_Income__c == 'Grant' || 
										  accountRecord.Source_of_Income__c == 'Money Service Business' || accountRecord.Source_of_Income__c == 'Pay Day Lenders' || accountRecord.Source_of_Income__c == 'Trade Finance' || 
										  accountRecord.Source_of_Income__c == 'Trading Income- Sales' || accountRecord.Source_of_Income__c == 'Investments')){
				contextBuilder.add('otherIncome', 'YES');
			}
            //Check occupation
			if (!(accountRecord.Occupation_Status__pc == 'Full-time employed' || accountRecord.Occupation_Status__pc == 'Unemployed' || accountRecord.Occupation_Status__pc == 'Retired' || 
										  accountRecord.Occupation_Status__pc == 'Self Employed' )){
                contextBuilder.add('otherOccupation', 'YES');
            }

            //Check other occupation level
            if (!(accountRecord.Occupation_Level__pc == 'Senior Management' || accountRecord.Occupation_Level__pc == 'Management' || accountRecord.Occupation_Level__pc == 'Supervisor' || 
										  accountRecord.Occupation_Level__pc == 'Supervisor' || accountRecord.Occupation_Level__pc == 'Semi-Skilled Worker' )){
                contextBuilder.add('otherOccLevel', 'YES');
            }
            //added by Mashudu for Absa 5847 Ex(a)
            if (!(accountRecord.Marital_Contract_Type__pc == 'Community of Property' || accountRecord.Marital_Contract_Type__pc == 'By ANC without accrual' || accountRecord.Marital_Contract_Type__pc == 'By ANC with accrual' )){
				contextBuilder.add('otherContract', 'YES');
			}
            
            //Absa 3593
            if(accountRecord.Post_Matric_Qualification__pc == 'Certificate 24 Months'){
                contextBuilder.add('certQual','YES');
            }
            
            if(accountRecord.Post_Matric_Qualification__pc == 'Diploma 1 year'){
                contextBuilder.add('diploma1','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Diploma 2 year'){
                contextBuilder.add('diploma2','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Diploma 3 year'){
                contextBuilder.add('diploma3','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Degree 3 and 3+ Years'){
                contextBuilder.add('degree','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Post Graduate Diploma 12 Months'){
                contextBuilder.add('postDiploma','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Honours'){
                contextBuilder.add('Honours','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Masters'){
                contextBuilder.add('Masters','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'Doctorate'){
                contextBuilder.add('Doctorate','YES');
            }
            if(accountRecord.Post_Matric_Qualification__pc == 'None of the above'){
                contextBuilder.add('noneQual','YES');
            }
			String insloventDebitReview = accountRecord.Currently_Insolvent_Debit_Review__pc != null && accountRecord.Currently_Insolvent_Debit_Review__pc.contains('Yes') ? 'Yes' : accountRecord.Currently_Insolvent_Debit_Review__pc;
			String currentlyInsloventDebitReview = accountRecord.Insolvent_Debit_Review__pc  != null && accountRecord.Insolvent_Debit_Review__pc .contains('Yes') ? 'Yes' : accountRecord.Insolvent_Debit_Review__pc ;
			contextBuilder.add('insloventDebitReview',insloventDebitReview);
            contextBuilder.add('currentlyInsloventDebitReview',currentlyInsloventDebitReview);
			///added by Manish for Absa 5847 Ex(b)
			String compCommunication = accountRecord.Want_to_receive_companyproxy_other_issue__c == null || accountRecord.Want_to_receive_companyproxy_other_issue__c == false ? '0' : '1';
			contextBuilder.add('CompCommunication', compCommunication);

			string thirdParty = accountRecord.share_information_to_third_party__c == True ? 'True' : null;
			contextBuilder.add('thirdParty', thirdParty);
			if (accountRecord.share_information_to_third_party__c == true){
				contextBuilder.add('Third_party_permission', 'I GIVE ABSA PERMISSION TO GIVE SUCH INFORMATION');
			}
			else{
				contextBuilder.add('Third_party_permission', 'I DO NOT GIVE ABSA PERMISSION TO GIVE SUCH INFORMATION');
			}
			string faisAct = accountRecord.FAIS_Act__c == true ? 'YES' : accountRecord.FAIS_Act__c == false ? 'NO' : null;
			contextBuilder.add('FAIS_Act', faisAct);
			contextBuilder.add('mainAccountNumber', accountRecord.AccountNumber);

			string marketingConsent = accountRecord.Credit_Marketing_Consent__pc == 'Yes' ? 'true' : accountRecord.Credit_Marketing_Consent__pc == 'No' ? 'false' : 'false';
			contextBuilder.add('marketingConsent', marketingConsent);
			string sms = accountRecord.Is_Marketing_Consent_SMS__c == True ? 'true' : accountRecord.Is_Marketing_Consent_SMS__c == False ? 'false' : 'false';
			contextBuilder.add('SMS', sms);
			string email = accountRecord.Is_Marketing_Consent_Email__c == True ? 'true' : accountRecord.Is_Marketing_Consent_Email__c == False ? 'false' : 'false';
			contextBuilder.add('email', email);
			string voiceRecording = accountRecord.Is_Marketing_Consent_voice_rec__c == True ? 'true' : accountRecord.Is_Marketing_Consent_voice_rec__c == False ? 'false' : 'false';
			contextBuilder.add('voiceRecording', voiceRecording);

			if (accountRecord.Is_Marketing_Consent_SMS__c == true){
				contextBuilder.add('contactVia', 'SMS');
			}
			if (accountRecord.Is_Marketing_Consent_Email__c == true){
				contextBuilder.add('contactVia', 'EMAIL');
			}
			if (accountRecord.Is_Marketing_Consent_voice_rec__c == true){
				contextBuilder.add('contactVia', 'VOICE RECORDING');
			}
			if (accountRecord.Is_Marketing_Consent_SMS__c == false && accountRecord.Is_Marketing_Consent_voice_rec__c == false && accountRecord.Is_Marketing_Consent_Email__c == false){
				contextBuilder.add('noThanks', 'YES');
				contextBuilder.add('contactVia', 'NO THANKS');
			}
			if (accountRecord.Registration_Number__c != '' && accountRecord.Registration_Number__c != null){
                contextBuilder.add('registrationNumber', accountRecord.Registration_Number__c);
				accountRecord.Registration_Number__c = accountRecord.Registration_Number__c.replace('/', '');
			}
			if (accountRecord.Credit_Worthiness_Consent__c == true){
				contextBuilder.add('riskManagementY', 'true');
				contextBuilder.add('riskManagementN', 'false');
			}
			if (accountRecord.Credit_Worthiness_Consent__c == false){
				contextBuilder.add('riskManagementY', 'false');
				contextBuilder.add('riskManagementN', 'true');
			}
            
			// Absa 5713
			switch on accountRecord.Reason_For_Not_Providing_SA_Tax_Number__c{
				when 'CUSTOMER UNABLE OR UNWILLING TO PROVIDE'{
					contextBuilder.add('Unable_to_provide', 'YES');
				}
				when 'COUNTRY OF TAX RESIDENCY DOESN\'T REQUIRE COLLECTION OF TAX NUMBER'{
					contextBuilder.add('Tax_Residency_not_required', 'YES');
				}
				when 'TAX NUMBER NOT ISSUED BY THE TAX AUTHORITY IN THE COUNTRY OF TAX RESIDENCY'{
					contextBuilder.add('Tax_Number_not_issued', 'YES');
				}
			}

			string enitytyTypeNonIndividuals = 'false';
			string enitityJointAndSeveral = 'false';
			string enitityIndividuals = 'false';
			string enityPartnership = 'false';
			string entitySoleTrader = 'false';
			string otherEntity = 'false';
			string otherEntityType = '';
            String customerType = '';
			switch on accountRecord.Client_Type__c{
				when 'Private Company', 'Company'{
					enitytyTypeNonIndividuals = 'true';
                    customerType = 'Company';
				}
				when 'Joint & Several'{
					enitityJointAndSeveral = 'true';
                    customerType = 'Joint & Several';
				}
				when 'Individual','Private Individual'{
					enitityIndividuals = enitityIndividuals;
                    customerType = 'Individual';
				}
				when 'Partnership', 'Trusts', 'Close Corporation'{
                    if(accountRecord.Client_Type__c =='Close Corporation'){
                        customerType = 'Close Corporation';
                    }
                    else if(accountRecord.Client_Type__c == 'Trusts'){
                       customerType = 'Trust'; 
                    }
                    else if(accountRecord.Client_Type__c == 'Partnership'){
                        customerType = 'Partnership';
                    }
					enityPartnership = 'true';
					contextBuilder.add('TrustPartnershiporCloseCorporation', 'YES');
				}
				when 'Sole Trader', 'Sole Proprietor'{
					entitySoleTrader = 'true';
                    customerType = 'Sole Proprietor';
				}
				when else{
					otherEntity = 'true';
                    customerType = 'Other';
					otherEntityType = accountRecord.Client_Type__c;
				}
			}

			contextBuilder.add('enitytyTypeNonIndividuals', enitytyTypeNonIndividuals);
			contextBuilder.add('enitityJointAndSeveral', enitityJointAndSeveral);
			contextBuilder.add('enitityIndividuals', enitityIndividuals);
			contextBuilder.add('enityPartnership', enityPartnership);
			contextBuilder.add('entitySoleTrader', entitySoleTrader);
			contextBuilder.add('otherEntity', otherEntity);
            contextBuilder.add('customerType', customerType);

            contextBuilder.add('accountHolder', accountRecord.Identify_the_account_holder_type__c);//added by Manish for W-010861
			String participatingFFI = accountRecord.Identify_the_account_holder_type__c == 'Financial Institution (FI)' ? '1' : '0';
			contextBuilder.add('participatingFFI', participatingFFI);
			accountRecord.Identify_the_account_holder_type__c = accountRecord.Identify_the_account_holder_type__c == 'Active Non Financial  Entity (ANFE)' ? 'Active Non Financial Entity' : accountRecord.Identify_the_account_holder_type__c;

			List<Account> accountList = new List<Account>();
			accountList.add(accountRecord);
			contextBuilder.add('AccountList', accountList);
			string consolidatedSignaturiesName;
			// get Individuals with Authority to Act
			if (!signatureRequests.isEmpty() && signatureRequests.size() > 0 && signatureRequests != null){
				contextBuilder.add('SignatureRequests', signatureRequests);
				for (SignatureRequest__c sign : signatureRequests)
					{
						if (consolidatedSignaturiesName == null){
							consolidatedSignaturiesName = sign.Fullname__c;
					} else{
						consolidatedSignaturiesName += ',' + sign.Fullname__c;
					}
				}
				contextBuilder.add('consolidatedSignaturiesName', consolidatedSignaturiesName);
			} else{
				List<AccountContactRelation> indWithAuthToAct = new AccountContactRelationSelector().selectbyAccountIdAndRoles(opp.AccountId, 'Individual with Authority to Act');
				if (!indWithAuthToAct.isEmpty() && indWithAuthToAct.size() > 0 && indWithAuthToAct != null){
					List<SignatureRequest__c> individualsWithAuthToAct = new List<SignatureRequest__c>();
					for (AccountContactRelation acr : indWithAuthToAct){
						SignatureRequest__c sigReq = new SignatureRequest__c(Fullname__c = acr.Contact.Name,Title__c = acr.Contact.Title,Role__c = acr.Designation__c,Email__c = acr.Contact.Email,Mobile__c = acr.Contact.MobilePhone,Phone__c = acr.Contact.Phone);
						if (acr.Contact.ID_Number__c != '' && acr.Contact.ID_Number__c != null){
							sigReq.ID_Passport_Number__c = acr.Contact.ID_Number__c;
						} else{
							sigReq.ID_Passport_Number__c = acr.Contact.Passport_Number__c;
						}
						individualsWithAuthToAct.add(sigReq);
					}
					if (!individualsWithAuthToAct.isEmpty() && individualsWithAuthToAct.size() > 0 && individualsWithAuthToAct != null){
						contextBuilder.add('SignatureRequests', individualsWithAuthToAct);
						for (SignatureRequest__c sign : individualsWithAuthToAct)
							{
								if (consolidatedSignaturiesName == null){
									consolidatedSignaturiesName = sign.Fullname__c;
							} else{
								consolidatedSignaturiesName += ',' + sign.Fullname__c;
							}
						}
						contextBuilder.add('consolidatedSignaturiesName', consolidatedSignaturiesName);
					}
				} else{
					// this would be where its a Sole Trader
					List<SignatureRequest__c> individualsWithAuthToAct = new List<SignatureRequest__c>();
					SignatureRequest__c sigReq = new SignatureRequest__c(Fullname__c = accountRecord.Name,Title__c = accountRecord.PersonTitle,Email__c = accountRecord.PersonEmail,Mobile__c = accountRecord.PersonMobilePhone,Phone__c = accountRecord.Phone);
					if (accountRecord.ID_Number__pc != '' && accountRecord.ID_Number__pc != null){
						sigReq.ID_Passport_Number__c = accountRecord.ID_Number__pc;
					} else{
						sigReq.ID_Passport_Number__c = accountRecord.Passport_Number__pc;
					}
					individualsWithAuthToAct.add(sigReq);
					if (!individualsWithAuthToAct.isEmpty() && individualsWithAuthToAct.size() > 0 && individualsWithAuthToAct != null){
						contextBuilder.add('SignatureRequests', individualsWithAuthToAct);
						contextBuilder.add('consolidatedSignaturiesName', sigReq.Fullname__c); // Added By Prateek Jangir for AW 012 and AW 042 form
					}
				}
			}
			// get current logged user (advisor) ddetails
			User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
			if (currentUser != null){
				contextBuilder.add('User', currentUser);
				// hopefully this is the branch
				if (currentUser.SiteCode__c != '' && currentUser.SiteCode__c != null){
					List<Site__c> siteData = new SitesSelector().selectBySiteCode(currentUser.SiteCode__c);
					if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null){
						contextBuilder.add('Site', siteData.get(0));
					}
				}
			}
			User consultant = new UsersSelector().selectById(opp.OwnerId);
			if (consultant != null){
				contextBuilder.add('consultant', consultant);
			}
			// Now push the values to the processor
			contextBuilder.add('Account', accountRecord);
            Application_Product__c appProduct = new Application_Product__c();
			Map<Id, Application_Product__c> productApplicationProduct = new Map<Id, Application_Product__c>();
            for(Application_Product__c appProd : new ApplicationProductSelector().selectApplicationProductByOpportunityId(opp.Id)){
                if(appProd.Internet_Banking__c == true){
                    contextBuilder.add('internetBanking', 'Yes');
                }
				if(appProd.Client_Under_Supervision__c != null || appProd.Advice_Given__c != null){
                    appProduct = appProd;
                }
                productApplicationProduct.put(appProd.Opportunity_Product_Id__c, appProd);
            }
            List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
            List<ProductWrapper> productWrappers = new List<ProductWrapper>();
			List<OpportunityLineItem> oppLineItems = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opp.Id, 10);
            if (!oppLineItems.isEmpty() && oppLineItems.size() > 0 && oppLineItems != null){
                for(OpportunityLineItem lineItem : oppLineItems){
                    if(lineItem.Product2.Family != 'Package'){
                        ProductWrapper wrap = new ProductWrapper();
                        lineItem.Product2.Family = lineItem.Product2.Family == 'Cheque' ? 'Current': lineItem.Product2.Family;
                        lineItem.price_scheme_code__c  = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Price Scheme Code', lineItem.price_scheme_code__c, StringConstants.INBOUND_RECORD_TYPE);
						wrap.opportunityProduct = lineItem;
                        wrap.applicationProduct = productApplicationProduct.get(lineItem.Id) != null ? productApplicationProduct.get(lineItem.Id) : new Application_Product__c();
                        productWrappers.add(wrap);
                    }
                }
                contextBuilder.add('productWrappers', productWrappers);
            }
			// get Opportunity Line Item
			List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opp.Id, 1);
			if (!oppLineItemList.isEmpty() && oppLineItemList.size() > 0 && oppLineItemList != null){
				if (oppLineItemList.get(0).Signing_Purpose__c != '' && oppLineItemList.get(0).Signing_Purpose__c != null){
					List<String> signingPurposeList = oppLineItemList.get(0).Signing_Purpose__c.split(';');
					if (!signingPurposeList.isEmpty() && signingPurposeList.size() > 0 && signingPurposeList != null){
						for (String signingPurpose : signingPurposeList){
							contextBuilder.add(signingPurpose, 'YES');
						}
					}
				}
                String signingInstruction = '';
                for(OpportunityLineItem lineItem : oppLineItemList){
                    if (lineItem.Signing_Instructions__c != '' && lineItem.Signing_Instructions__c != null){
                        if(lineItem.Signing_Instructions__c == 'Anyone to sign alone'){
                            signingInstruction = 'Any one alone';
                        }
                        else if(lineItem.Signing_Instructions__c == 'Any A and one B or any two As to sign together'){
                            signingInstruction = 'Any A and B or two A’s to sign';
                        }
                        else if(lineItem.Signing_Instructions__c == 'Any A and one B to sign together'){
                            signingInstruction = 'Any A or B together';
                        }
                    }
                }
                contextBuilder.add('signingInstruction', signingInstruction);
				contextBuilder.add('opportunityLineItem', oppLineItemList.get(0));
			}

			// get Related parties - merging the queries - Tinashe
			List<AccountContactRelation> shareHolders = new List<AccountContactRelation>();
			List<AccountContactRelation> contactPersonList = new List<AccountContactRelation>();
			List<AccountContactRelation> directorsList = new List<AccountContactRelation>();
			List<AccountContactRelation> activeDirectorsList = new List<AccountContactRelation>();
			List<AccountContactRelation> uboList = new List<AccountContactRelation>();
			List<AccountContactRelation> operatorsList = new List<AccountContactRelation>();
			List<AccountContactRelation> authToActList = new List<AccountContactRelation>();
			List<AccountContactRelation> getAlRelatedparties = new AccountContactRelationSelector().selectbyAccount(opp.AccountId);
			List<AccountContactRelation> ccMembersList = new List<AccountContactRelation>();
            AccountAccountRelationSelector selector = new AccountAccountRelationSelector();
            List<FinServ__AccountAccountRelation__c> getALLNonIndividualRelatedParties = selector.selectByPrimaryForDocuments(opp.AccountId);
			List<NonIndividualRelatedPartyWrapper> nonIndividualRelatedParties = new List<NonIndividualRelatedPartyWrapper>(); 
            if (!getALLNonIndividualRelatedParties.isEmpty() && getALLNonIndividualRelatedParties.size() > 0 && getALLNonIndividualRelatedParties != null){
                Set<Id> relatedAccountsIds = Sys_Utilities_General.extractListIds(getALLNonIndividualRelatedParties, 'FinServ__RelatedAccount__c', true);
                if (!relatedAccountsIds.isEmpty() && relatedAccountsIds.size() > 0 && relatedAccountsIds != null){
                    List<Account> nonIndividualRelatedPartiesRec = new AccountsSelector().selectRelatedPartiesByAddressType(relatedAccountsIds, opp.AccountId);
                    if (!nonIndividualRelatedPartiesRec.isEmpty() && nonIndividualRelatedPartiesRec.size() > 0 && nonIndividualRelatedPartiesRec != null){
                        for(Account acc : nonIndividualRelatedPartiesRec){
                            NonIndividualRelatedPartyWrapper wrap = new NonIndividualRelatedPartyWrapper();
                            wrap.accountName = acc.Name;
        					wrap.registrationNumber = acc.Registration_Number__c != null ? acc.Registration_Number__c : acc.Trust_Number__c != null ? acc.Trust_Number__c  : '-';
                            wrap.tradingName = '';
							List<Trading_as_Name__c> tradingNamesList = acc.Trading_as_Names__r;
                            if (!tradingNamesList.isEmpty() && tradingNamesList.size() > 0 && tradingNamesList != null){
                                List<String> tradingnNmes = Sys_Utilities_General.extractListValues(tradingNamesList, 'Name');
                                if (!tradingnNmes.isEmpty() && tradingnNmes.size() > 0 && tradingnNmes != null){
                                    wrap.tradingName = string.join(tradingnNmes, ';');
                                }
                            }
                            wrap.countryOfRegistration = acc.Country_of_Registration__c;
                            if(acc.FinServ__RelatedToAccounts__r.size() > 0){
                                wrap.sharingPercentage = String.valueOf(acc.FinServ__RelatedToAccounts__r[0].Shareholding_Percentage__c);
                                wrap.roles = acc.FinServ__RelatedToAccounts__r[0].Roles__c;
                            }
                            wrap.headOfficeAddress = new Address__c();
                            wrap.businesseAddress = new Address__c();
                            wrap.registeredAddress = new Address__c();
                            for(Address__c address : acc.Addresses__r){
                                if(address.Address_Type__c == 'Head Office'){
                                    wrap.headOfficeAddress = address;
                                }
                                else if(address.Address_Type__c == 'Business Address'){
                                    wrap.businesseAddress = address;
                                }
                                else if(address.Address_Type__c == 'Registered'){
                                    wrap.registeredAddress = address;
                                }
                            }
                            nonIndividualRelatedParties.add(wrap);
                        }
                        contextBuilder.add('nonIndividualRelatedParties', nonIndividualRelatedParties);
                    }
                }
            }
			if (!getAlRelatedparties.isEmpty() && getAlRelatedparties.size() > 0 && getAlRelatedparties != null){
				for (AccountContactRelation relatedParty : getAlRelatedparties){
					if (relatedParty.Roles != '' && relatedParty.Roles != null){
						string roles = relatedParty.Roles;
						if (roles.contains('Shareholder/Controller')){
							shareHolders.add(relatedParty);
						}
						if (roles.contains('Contact Person')){
							contactPersonList.add(relatedParty);
						}
						if (roles.contains('Director')){
							directorsList.add(relatedParty);
							if (relatedParty.IsActive == true){
								activeDirectorsList.add(relatedParty);
							}
						}
						if (accountRecord.Identify_the_account_holder_type__c != '' && accountRecord.Identify_the_account_holder_type__c != null && accountRecord.Identify_the_account_holder_type__c.contains('Passive') && relatedParty.UBO__c == 'Yes'){
							uboList.add(relatedParty);
						}
						if (roles.contains('Operators on primary accounts (Internet Main Users, Signatories, Card Users)') || roles.contains('Operators on primary accounts ( Internet Main Users, Signatories, Card Users)')){
							operatorsList.add(relatedParty);
						}
						if (roles.contains('Individual with Authority to Act')){
							authToActList.add(relatedParty);
						}
						if (roles.contains('Members/Controllers')){
							ccMembersList.add(relatedParty);
						}
					}

				}
				// end for loop relatedParty

				// get shareholders
				if (!shareHolders.isEmpty() && shareHolders.size() > 0 && shareHolders != null){
					Set<Id> shareHolderContactIds = Sys_Utilities_General.extractListIds(shareHolders, 'ContactId', true);
					if (!shareHolderContactIds.isEmpty() && shareHolderContactIds.size() > 0 && shareHolderContactIds != null){
						List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(shareHolderContactIds, opp.AccountId);
						if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
							for (Contact con : RelatedParties){
								con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
								con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
								con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
								if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
									con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
									con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
									con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
								}
							}
							contextBuilder.add('RelatedParties', RelatedParties);
						}
					}
				}
				// end if Shareholder/Controller

				// if 'Contact Person'
				if (!contactPersonList.isEmpty() && contactPersonList.size() > 0 && contactPersonList != null){
					contextBuilder.add('ContactRelationRole', contactPersonList[0].Designation__c);
					Contact ContactRelation = new ContactsSelector().selectCifFieldsByContactId(contactPersonList[0].ContactId);
					if (ContactRelation != null){
						ContactRelation.ID_Type__c = ContactRelation.ID_Type__c == 'SA Identity Document' ? 'ID Book' : ContactRelation.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : ContactRelation.ID_Type__c == 'Passport' ? 'Passport' : ContactRelation.ID_Type__c;
						ContactRelation.Occupation_Status__c = ContactRelation.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : ContactRelation.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : ContactRelation.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : ContactRelation.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : ContactRelation.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : ContactRelation.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : ContactRelation.Occupation_Status__c;
						ContactRelation.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', ContactRelation.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
						contextBuilder.add('ContactRelation', ContactRelation);
					}
				} else{
					// Fr mechant Opportunities we capture the contact person on the Opp Line Item
					// This needs clarity further
					if (!oppLineItemList.isEmpty() && oppLineItemList.size() > 0 && oppLineItemList != null){
						string contactPersonIdStr = oppLineItemList.get(0).Contact_Person__c;
						if (contactPersonIdStr != '' && contactPersonIdStr != null){
							id contactPersonId = (id)contactPersonIdStr;
							String sObjName = contactPersonId.getSObjectType().getDescribe().getName();
							if (sObjName == 'AccountContactRelation'){
								//Query the Contact_Person__c AccountContactRelation related to the Application Product - Merchant
								List<AccountContactRelation> accContactRelationList = new AccountContactRelationSelector().selectRelationById(contactPersonId);
								if (!accContactRelationList.isEmpty() && accContactRelationList.size() > 0 && accContactRelationList != null){
									contextBuilder.add('ContactRelationRole', accContactRelationList[0].Designation__c);
									Contact contactRelation = new ContactsSelector().selectCifFieldsByContactId(accContactRelationList[0].ContactId);
									if (contactRelation != null){
										contactRelation.ID_Type__c = contactRelation.ID_Type__c == 'SA Identity Document' ? 'ID Book' : contactRelation.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : contactRelation.ID_Type__c == 'Passport' ? 'Passport' : contactRelation.ID_Type__c;
										contactRelation.Occupation_Status__c = contactRelation.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : contactRelation.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : contactRelation.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : contactRelation.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : contactRelation.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : contactRelation.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : contactRelation.Occupation_Status__c;
										ContactRelation.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', ContactRelation.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
										contextBuilder.add('ContactRelation', contactRelation);
									}
								}
							} else{
								contextBuilder.add('ContactRelation', accountRecord);
							}
						}
					} else{
						contextBuilder.add('ContactRelation', accountRecord);
					}
				}
				// end if 'Contact Person'
				if (!directorsList.isEmpty() && directorsList.size() > 0 && directorsList != null){
					contextBuilder.add('Directors', directorsList);
				}
				// end if Director

				// get Active Directors
				if (!activeDirectorsList.isEmpty() && activeDirectorsList.size() > 0 && activeDirectorsList != null){
					Set<Id> activeDirectorsListIds = Sys_Utilities_General.extractListIds(activeDirectorsList, 'ContactId', true);
					if (!activeDirectorsListIds.isEmpty() && activeDirectorsListIds.size() > 0 && activeDirectorsListIds != null){
						List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(activeDirectorsListIds, opp.AccountId);
						if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
							for (Contact con : RelatedParties){
								con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
								con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
								con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
								if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
									con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
									con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
									con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
								}
							}
							contextBuilder.add('activeDirectors', RelatedParties);
						}
					}
				}
				// end if Active directors

				// get UBO List
				if (!uboList.isEmpty() && uboList.size() > 0 && uboList != null){
					Set<Id> uboListIds = Sys_Utilities_General.extractListIds(uboList, 'ContactId', true);
					if (!uboListIds.isEmpty() && uboListIds.size() > 0 && uboListIds != null){
						List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(uboListIds, opp.AccountId);
						if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
							for (Contact con : RelatedParties){
								con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
								con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
								con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
								if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
									con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
									con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
									con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
								}
							}
							contextBuilder.add('ubo', RelatedParties);
						}
					}
				}
				// end If UBO

				// get Operators
				if (!operatorsList.isEmpty() && operatorsList.size() > 0 && operatorsList != null){
					Set<Id> operatorListIds = Sys_Utilities_General.extractListIds(operatorsList, 'ContactId', true);
					if (!operatorListIds.isEmpty() && operatorListIds.size() > 0 && operatorListIds != null){
						List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(operatorListIds, opp.AccountId);
						if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
							for (Contact con : RelatedParties){
								con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
								con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
								con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
								if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
									con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
									con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
									con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
								}
							}
							contextBuilder.add('Operators', RelatedParties);
						}
					}
				}
				// end If Operators

				// start if 'Individual with Authority to Act'
				if (!authToActList.isEmpty() && authToActList.size() > 0 && authToActList != null){
					Set<Id> authToActListIds = Sys_Utilities_General.extractListIds(authToActList, 'ContactId', true);
					if (!authToActListIds.isEmpty() && authToActListIds.size() > 0 && authToActListIds != null){
						List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(authToActListIds, opp.AccountId);
						if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
							for (Contact con : RelatedParties){
								con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
								con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
								con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
								if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
									con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
									con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
									con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
								}
							}
							contextBuilder.add('IndividualwithAuthoritytoAct', RelatedParties);
							if (documentTemplate.Name.contains('5122')){
								documentTemplate.XML__c = mapRelatedPatiesToXML(documentTemplate.XML__c, RelatedParties);
							}
						}
					}
				} else{
					if (accountRecord.Client_Type__c == 'Sole Trader' || accountRecord.Client_Type__c == 'Sole Proprietor'){
						// this would be where its a Sole Trader
						List<SignatureRequest__c> individualsWithAuthToAct = new List<SignatureRequest__c>();
						SignatureRequest__c sigReq = new SignatureRequest__c(Fullname__c = accountRecord.Name,Title__c = accountRecord.PersonTitle,Role__c = 'Sole Trader');
						sigReq.ID_Passport_Number__c = accountRecord.Passport_Number__pc;
						if (accountRecord.ID_Number__pc != '' && accountRecord.ID_Number__pc != null){
							sigReq.ID_Passport_Number__c = accountRecord.ID_Number__pc;
						}
						individualsWithAuthToAct.add(sigReq);
						if (!individualsWithAuthToAct.isEmpty() && individualsWithAuthToAct.size() > 0 && individualsWithAuthToAct != null){
							contextBuilder.add('IndividualwithAuthoritytoAct', individualsWithAuthToAct);
						}
					}
				}
				// end 'Individual with Authority to Act'

				// get CC Members/Controllers List
				if (!ccMembersList.isEmpty() && ccMembersList.size() > 0 && ccMembersList != null){
					contextBuilder.add('ccMembersList', ccMembersList);
				}
				// end If Members/Controllers
				List<IndividualRelatedPartyWrapper> individualRelatedParties = new List<IndividualRelatedPartyWrapper>();
                Set<Id> relPartyPrimaryEntityIdSet = new Set<Id>();
                List<Controlling_Interest__c> controllingInstr = new ControllingInterestsSelector().getByPrimaryAndUBO(opp.AccountId, 'Yes');
                for (Controlling_Interest__c contrInt : controllingInstr){
                    relPartyPrimaryEntityIdSet.add(contrInt.Other_Primary_Entity_Id__c);
                }
                relPartyPrimaryEntityIdSet.add(opp.AccountId);
                Map<Id, ProductContactSignatoryRelationship__c> pcsrMap = new Map<Id, ProductContactSignatoryRelationship__c>();
                List<ProductContactSignatoryRelationship__c> pcsrList = new ProductContactSignatoryRelshipsSelector().selectByPrimaryAccountIds(relPartyPrimaryEntityIdSet);
                for(ProductContactSignatoryRelationship__c pcsr : pcsrList){
                    pcsrMap.put(pcsr.AccountContactRelationshipId__c ,pcsr);
                }
                if (!getAlRelatedparties.isEmpty() && getAlRelatedparties.size() > 0 && getAlRelatedparties != null){
                    Set<Id> getAlRelatedpartiesIds = Sys_Utilities_General.extractListIds(getAlRelatedparties, 'ContactId', true);
                    if (!getAlRelatedpartiesIds.isEmpty() && getAlRelatedpartiesIds.size() > 0 && getAlRelatedpartiesIds != null){
                        List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(getAlRelatedpartiesIds, opp.AccountId);
                        if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
                            for (Contact con : RelatedParties){
                                if(con.AccountContactRelations.size() > 0 &&con.AccountContactRelations[0].Primary_Entity_Id__c  != null){
                                    con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
                                    con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
                                    con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
                                }
                            }
                            contextBuilder.add('sectionEParties', RelatedParties);
                        }
                    }
                }
                
                Set<Id> accountIds = new Set<Id>();
                accountIds.add(opp.AccountId);
                Set<Id> participantIdsSet = new Set<Id>();
				List<AccountContactRelation> UBORelList = new List<AccountContactRelation>();
				String accountHierarchy = accountRecord.UBO_ParentAccountWrapper__c != null ? accountRecord.UBO_ParentAccountWrapper__c : null;
				//get list of recordIds acr ids from ubo structure
				participantIdsSet = OnboardingMainUtil.getParticipantsData(accountHierarchy);
				//get list of acr records from ubo structure
				UBORelList = AccountContactRelationUtil.getAccountContactRelation(participantIdsSet);
				//get list of acr records from AccountContactRelation
				List<AccountContactRelation> acrListRelatedParty = new AccountContactRelationSelector().selectByRelatedPartySection(opp.AccountId);
				UBORelList.addAll(acrListRelatedParty);

                List<Contact> allIndividualRelParties = new List<Contact>();
                if (!UBORelList.isEmpty() && UBORelList.size() > 0 && UBORelList != null){
                    Set<Id> uboRelConIds = Sys_Utilities_General.extractListIds(UBORelList, 'ContactId', true);
                    if (!uboRelConIds.isEmpty() && uboRelConIds.size() > 0 && uboRelConIds != null){
                        List<Contact> UBORelatedParties = new ContactsSelector().selectRelatedPartiesByConIds(uboRelConIds, accountIds);
                        if (!UBORelatedParties.isEmpty() && UBORelatedParties.size() > 0 && UBORelatedParties != null){
                            for (Contact con : UBORelatedParties){
                                con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
                                con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
                                con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
                                IndividualRelatedPartyWrapper wrap = new IndividualRelatedPartyWrapper();
                                wrap.contact = con; 
                                wrap.instructionType = con.Account.Type_of_Instruction__c;
                                wrap.instructionMethod = con.Account.Instruction_Method__c;
                                wrap.accountApplicable = con.Account.Account_Applicable__c ;
                                wrap.countryOfCitizenShip = con.Account.Country_of_Citizenship__c ;
                                wrap.language = con.Account.Communication_Language__pc;
                                wrap.authorizedSignatory = con.Account.Operating_Roles__c != null && con.Account.Operating_Roles__c.contains('Authorized Signatory') ? 'Yes' : 'No';
                                wrap.mandateOfficial = con.Account.Operating_Roles__c != null && con.Account.Operating_Roles__c.contains('Mandated Official') ? 'Yes' : 'No';
                                wrap.internetBankingUser = con.Account.Operating_Roles__c != null && con.Account.Operating_Roles__c.contains('Internet Banking User') ? 'Yes' : 'No';
                                wrap.mandateIndemnityUser = con.Account.Operating_Roles__c != null && con.Account.Operating_Roles__c.contains('Mandate & Indemnity User') ? 'Yes' : 'No';
                                wrap.wealthBankingMandate = con.Account.Operating_Roles__c != null && con.Account.Operating_Roles__c.contains('Authorized Banking Mandate User') ? 'Yes' : 'No';
                                
                                wrap.residentialAddress = new Address__c();
                                for(Address__c address : con.Addresses__r){
                                    if(address.Address_Type__c == 'Residential'){
                                        wrap.residentialAddress = address;
                                    }
                                }
                                if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
                                    con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
                                    con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
                                    con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                                    wrap.compulsorySignatory = pcsrMap.get(con.AccountContactRelations[0].Id) != null && pcsrMap.get(con.AccountContactRelations[0].Id).Compulsory_Signature__c != null ? pcsrMap.get(con.AccountContactRelations[0].Id).Compulsory_Signature__c : ''; 
                                    wrap.groupNo = pcsrMap.get(con.AccountContactRelations[0].Id) != null && pcsrMap.get(con.AccountContactRelations[0].Id).Group_No__c != null ? pcsrMap.get(con.AccountContactRelations[0].Id).Group_No__c : ''; 
                                    wrap.roles = con.AccountContactRelations[0].Roles;
                                    wrap.sharePercentage = con.AccountContactRelations[0].Share_Percentage__c;
                                }
                                individualRelatedParties.add(wrap);
                            }
                        }
                    }
                }
                contextBuilder.add('individualRelatedParties', individualRelatedParties);
                contextBuilder.add('allRelatedPaties', getAlRelatedparties);
			} else{
				if (accountRecord.Client_Type__c == 'Sole Trader' || accountRecord.Client_Type__c == 'Sole Proprietor'){
					// this would be where its a Sole Trader
					List<SignatureRequest__c> individualsWithAuthToAct = new List<SignatureRequest__c>();
					SignatureRequest__c sigReq = new SignatureRequest__c(Fullname__c = accountRecord.Name,Title__c = accountRecord.PersonTitle,Role__c = 'Sole Trader');
					sigReq.ID_Passport_Number__c = accountRecord.Passport_Number__pc;
					if (accountRecord.ID_Number__pc != '' && accountRecord.ID_Number__pc != null){
						sigReq.ID_Passport_Number__c = accountRecord.ID_Number__pc;
					}
					individualsWithAuthToAct.add(sigReq);
					if (!individualsWithAuthToAct.isEmpty() && individualsWithAuthToAct.size() > 0 && individualsWithAuthToAct != null)
						contextBuilder.add('IndividualwithAuthoritytoAct', individualsWithAuthToAct);
				}
			}

			// get the opsList
			if (!oppLineItemList.isEmpty() && oppLineItemList.size() > 0 && oppLineItemList != null){
				List<ProductContactSignatoryRelationship__c> pcsrList = new ProductContactSignatoryRelshipsSelector().selectByPrimaryAccountId(opp.AccountId);
				if (!pcsrList.isEmpty() && pcsrList.size() > 0 && pcsrList != null){
					contextBuilder.add('ProductContactSignatoryRelationship', pcsrList);
					List<String> operatorListIds = Sys_Utilities_General.extractListValues(pcsrList, 'AccountContactRelationshipId__c');
					if (!operatorListIds.isEmpty() && operatorListIds.size() > 0 && operatorListIds != null){
						Map<id, ProductContactSignatoryRelationship__c> prodConSigRelMap = new Map<id, ProductContactSignatoryRelationship__c>();
						for (ProductContactSignatoryRelationship__c prod : pcsrList){
							prodConSigRelMap.put((id)prod.AccountContactRelationshipId__c, prod);
						}
						Set<Id> ids = new Set<Id>();
						for (String id : operatorListIds){
							ids.add((id)id);
						}
						List<AccountContactRelation> opsList = new AccountContactRelationSelector().selectbyIdSet(ids);
						if (!opsList.isEmpty() && opsList.size() > 0 && opsList != null){
							Set<Id> operatorSetIds = Sys_Utilities_General.extractListIds(opsList, 'ContactId', true);
							if (!operatorSetIds.isEmpty() && operatorSetIds.size() > 0 && operatorSetIds != null){
								List<Contact> RelatedParties = new ContactsSelector().selectRelatedPartiesByAddressType(operatorSetIds, opp.AccountId);
								if (!RelatedParties.isEmpty() && RelatedParties.size() > 0 && RelatedParties != null){
									for (Contact con : RelatedParties){
										if (!con.AccountContactRelations.isEmpty() && con.AccountContactRelations.size() > 0 && con.AccountContactRelations != null){
											if (!prodConSigRelMap.keyset().isEmpty() && prodConSigRelMap.keyset().size() > 0 && prodConSigRelMap.keyset() != null){
												ProductContactSignatoryRelationship__c p = prodConSigRelMap.get(con.AccountContactRelations[0].Id);
												if (p != null){
													con.AccountContactRelations[0].Compulsory_Signature__c = p.Compulsory_Signature__c;
													con.AccountContactRelations[0].Group_No__c = p.Group_No__c;
												}
											}
											con.AccountContactRelations[0].Account.ID_Type__pc = con.AccountContactRelations[0].Account.ID_Type__pc == 'SA Identity Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Temporary ID Document' ? 'ID Book' : con.AccountContactRelations[0].Account.ID_Type__pc == 'Passport' ? 'Passport' : con.AccountContactRelations[0].Account.ID_Type__pc;
											con.AccountContactRelations[0].Account.Occupation_Status__pc = con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Part Time Employed' ? 'IPart-time employed/Contract worker' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed Professional' ? 'Self-employed (professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Temporary Employed' ? 'Temporary employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc == 'Full Time Employed' ? 'Full-time employed' : con.AccountContactRelations[0].Account.Occupation_Status__pc;
											con.AccountContactRelations[0].Account.Occupation_Category__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.AccountContactRelations[0].Account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
										}
										con.ID_Type__c = con.ID_Type__c == 'SA Identity Document' ? 'ID Book' : con.ID_Type__c == 'Temporary ID Document' ? 'ID Book' : con.ID_Type__c == 'Passport' ? 'Passport' : con.ID_Type__c;
										con.Occupation_Status__c = con.Occupation_Status__c == 'Part Time Employed' ? 'Part-time employed/Contract worker' : con.Occupation_Status__c == 'Pre-School /Scholar' ? 'Pre-school/Scholar' : con.Occupation_Status__c == 'Self Employed Professional' ? 'Self-employed (professional)' : con.Occupation_Status__c == 'Self Employed-Non-Professional' ? 'Self-employed (non-professional)' : con.Occupation_Status__c == 'Temporary Employed' ? 'Temporary employed' : con.Occupation_Status__c == 'Full Time Employed' ? 'Full-time employed' : con.Occupation_Status__c;
										con.Occupation_Category__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', con.Occupation_Category__c, StringConstants.OUTBOUND_RECORD_TYPE);
                                    }
                                    if(ids.contains(opp.AccountId)){
                                        Contact con = new Contact(LastName = accountRecord.LastName, FirstName = accountRecord.FirstName);
                                        RelatedParties.add(Con);
                                    }
									contextBuilder.add('OpsList', RelatedParties);
								}
							}
						}
					}
				}
			}

			//added by Manish for Absa 5847-Ex(e)
			List<Application_Product__c> applicationProducts = new ApplicationProductSelector().selectApplicationProductByOppId(opp.id);
			if (!applicationProducts.isEmpty() && applicationProducts.size() > 0 && applicationProducts != null){
				String discretionary = applicationProducts[0].Management_Type_Managed_Code__c != null && applicationProducts[0].Management_Type_Managed_Code__c == 'Discretionary account' ? '1' : '0';
				String nonDiscretionary = applicationProducts[0].Management_Type_Managed_Code__c != null && applicationProducts[0].Management_Type_Managed_Code__c == 'Non-Discretionary account' ? '1' : '0';
				contextBuilder.add('Discretionary', discretionary);
				contextBuilder.add('NonDiscretionary', nonDiscretionary);
				contextBuilder.add('ApplicationProduct', applicationProducts[0]);
			}

			//added by Manish for Absa 5847-Ex(b)
			Map<String, String> qaObject = new Map<String, String>();
			qaObject.put('Supervisor attended the client meeting with the supervisee?', '0');
			qaObject.put('Client accepted', '0');
			qaObject.put('Amount to be invested', '0.0');
			for (Questionnaire_Answer__c qaRecords : [SELECT Id, Name, Answer__c, Answer_Data_Type__c, Related_Opportunity__c, Question__c, Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c
			                                          FROM Questionnaire_Answer__c
			                                          where Related_Opportunity__r.Id = :opp.Id AND Questionnaire_Template__r.Name = 'SPM Record Of Advice']){
				if (qaRecords.Question__c.contains('Supervisor attended the client meeting with the supervisee?')){
					String answer = qaRecords.Answer__c == null || qaRecords.Answer__c == 'No' ? '0' : '1';
					qaObject.put(qaRecords.Question__c, answer);
				} else if (qaRecords.Question__c.contains('Client accepted/did not accept advice')){
					String answer = qaRecords.Answer__c == null || qaRecords.Answer__c != 'Accepted' ? '0' : '1';
					qaObject.put('Client accepted', answer);
				} else{
					qaObject.put(qaRecords.Question__c, qaRecords.Answer__c);
				}
			}
			contextBuilder.add('QuestionAnswer', qaObject);

			for (OpportunityTeamMember financialInvestmentAdvisor : [select Id, UserId, User.Name, User.phone, User.CompanyName, User.Advisor_Code__c, TeamMemberRole
			                                                         from OpportunityTeamMember
			                                                         where OpportunityId = :opp.Id and TeamMemberRole = 'Financial Investment Advisor'
			                                                         limit 1]){
				contextBuilder.add('financialInvestmentAdvisor', financialInvestmentAdvisor);
			}

			Map<String, String> productProfile = new Map<String, String>();
			Map<String, String> productNames = new Map<String, String>();
			List<Map<String, String>> spmProducts = new List<Map<String, String>>();
			ProductProductEntriesSelector productEntriesSelector = new ProductProductEntriesSelector();
			OpportunityLineItemsSelector oppLineItemSelector = new OpportunityLineItemsSelector();
			List<Product_Product_Entry__c> productEntries = productEntriesSelector.selectByParentProductName('SPM Equity Product');
			List<opportunityLineItem> lineItems = oppLineItemSelector.selectBySPMOpp(opp.Id, 'SPM Onboarding Bespoke', 'SPM Onboarding Cash Balance');

			for (Product_Product_Entry__c productEntry : productEntries){
				productProfile.put('SPM Onboarding ' + productEntry.Related_Product__r.Name, productEntry.Related_Product__r.Risk_Profile__c);
				productNames.put('SPM Onboarding ' + productEntry.Related_Product__r.Name, productEntry.Related_Product__r.Name);
			}
			for (opportunityLineItem lineItem : lineItems){
				Map<String, String> spmProduct = new Map<String, String>();
				spmProduct.put('profile', productProfile.get(lineItem.Name));
				if (productNames.get(lineItem.Name) != null && (productNames.get(lineItem.Name) == 'Quattro Portfolio' || productNames.get(lineItem.Name) == 'Quattro Plus Portfolio' || productNames.get(lineItem.Name) == 'Balanced Portfolio')){
					spmProduct.put('combination', productNames.get(lineItem.Name));
					spmProduct.put('combinationPerc', lineItem.Investment_Allocation__c);
				} else if (productNames.get(lineItem.Name) != null && (productNames.get(lineItem.Name) == 'Absa Preserver Personal Portfolio' || productNames.get(lineItem.Name) == 'Absa Accumulation Personal Portfolio' || productNames.get(lineItem.Name) == 'Absa Growth Personal Portfolio')){
					spmProduct.put('personalPortfolio', productNames.get(lineItem.Name));
					spmProduct.put('personalPortfolioPerc', lineItem.Investment_Allocation__c);
				} else if (productNames.get(lineItem.Name) != null && (productNames.get(lineItem.Name) == 'Local Equity Portfolio' || productNames.get(lineItem.Name) == 'Global Equity Portfolio')){
					spmProduct.put('capitalGrowth', productNames.get(lineItem.Name));
					spmProduct.put('capitalGrowthPerc', lineItem.Investment_Allocation__c);
				}
				spmProducts.add(spmProduct);
			}
			contextBuilder.add('spmProducts', spmProducts);

			// get Application Record
			List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(opp.id);
			if (!applicationDetails.isEmpty() && applicationDetails.size() > 0 && applicationDetails != null){
				applicationDetails.get(0).Replacing_an_Existing_Product__c = applicationDetails.get(0).Replacing_an_Existing_Product__c == 'Y' ? 'YES' : applicationDetails.get(0).Replacing_an_Existing_Product__c == 'N' ? 'NO' : applicationDetails.get(0).Replacing_an_Existing_Product__c;
				applicationDetails.get(0).Client_Under_Supervision__c = applicationDetails.get(0).Client_Under_Supervision__c == 'Y' ? 'YES' : applicationDetails.get(0).Client_Under_Supervision__c == 'N' ? 'NO' : applicationDetails.get(0).Client_Under_Supervision__c;
				applicationDetails.get(0).Advice_Given__c = applicationDetails.get(0).Advice_Given__c == 'Y' ? 'YES' : applicationDetails.get(0).Advice_Given__c == 'N' ? 'NO' : applicationDetails.get(0).Advice_Given__c;
				applicationDetails.get(0).Is_the_parent_also_a_guarantor__c = applicationDetails.get(0).Is_the_parent_also_a_guarantor__c == 'Yes' ? 'YES' : applicationDetails.get(0).Is_the_parent_also_a_guarantor__c == 'No' ? 'NO' : applicationDetails.get(0).Is_the_parent_also_a_guarantor__c;
				applicationDetails.get(0).Parent__c = applicationDetails.get(0).Parent__c == 'Yes' ? 'YES' : applicationDetails.get(0).Parent__c == 'No' ? 'NO' : applicationDetails.get(0).Parent__c;
				//applicationDetails.get(0).Address_type__c = applicationDetails.get(0).Address_type__c == 'BUSINESS' ? 'Business address' : applicationDetails.get(0).Address_type__c == 'RESIDENTIAL' ? 'Residential address' : applicationDetails.get(0).Address_type__c;
                string PCIDSS = applicationDetails.get(0).PCI_DSS_Checkbox_1__c == True ? 'true' : applicationDetails.get(0).PCI_DSS_Checkbox_1__c == False ? 'false' : 'false';
				contextBuilder.add('PCIDSS', PCIDSS);

				switch on applicationDetails.get(0).Medium__c{
					when 'Email'{
						contextBuilder.add('emailMedia', 'Yes');
					}
					when 'Scan and Email'{
						contextBuilder.add('scanAndEmailMedia', 'Yes');
					}
					when 'Fasimile'{
						contextBuilder.add('facsimileMedia', 'Yes');
					}
					when 'Telephone'{
						contextBuilder.add('telephoneMedia', 'Yes');
					}
				}

				contextBuilder.add('Application', applicationDetails.get(0));
				if (applicationDetails.get(0).Date_of_Completion__c != null){
					String day = applicationDetails.get(0).Date_of_Completion__c.day() < 10 ? 0+'' + applicationDetails.get(0).Date_of_Completion__c.day() : String.valueOf(applicationDetails.get(0).Date_of_Completion__c.day());
					String month = applicationDetails.get(0).Date_of_Completion__c.month() < 10 ? 0+'' + applicationDetails.get(0).Date_of_Completion__c.month() : String.valueOf(applicationDetails.get(0).Date_of_Completion__c.month());
					String year = String.valueOf(applicationDetails.get(0).Date_of_Completion__c.year());
					String dateOfCompletion = day + month + year;
					contextBuilder.add('DateOfCompletion', dateOfCompletion);
				}

				if (applicationDetails.get(0).For_whom_are_you_generating_the_document__c != null){
					User forWhom = new UsersSelector().selectById(applicationDetails.get(0).For_whom_are_you_generating_the_document__c);
					if (currentUser != null){
						contextBuilder.add('forWhom', forWhom);
					}
				}
                List<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
    			Map<String, String> roaQuestions = new Map<String, String>();
                Map<String, String> existingProduct = new Map<string,String>();
                Map<String, String> newlyProposedPorduct = new Map<string,String>();
                Map<String, String> productRecommended = new Map<string,String>();
                Map<String, String> reasonRecommended = new Map<string,String>();
                Map<String, String> achiveFfinancialObjectives = new Map<string,String>();
				String financialPosition = '';
                for(Questionnaire_Answer__c QAnswerRec : [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Questionnaire_Template__r.Name='Onboarding Record Of Advice']){
                    if(QAnswerRec.Question__c == 'Current Financial Product Experience change/Investment Risk Profile'){
                        roaQuestions.put('Current_Finacial_Product_Experience__c', QAnswerRec.Answer__c);
                    }
                    if(QAnswerRec.Question__c == 'The financial position was considered by completing a Financial Needs Analysis' && QAnswerRec.Answer__c == 'true'){
                        financialPosition = 'The client’s current financial position';
                    }
                    if(QAnswerRec.Question__c == 'The client opted not to provide the full facts in relation to his/her financial situation' && QAnswerRec.Answer__c == 'true'){
                        financialPosition = 'The client opted not to provide the full facts in relation';
                    }
                    roaQuestions.put(QAnswerRec.Question__c, QAnswerRec.Answer__c);
                }
                contextBuilder.add('financialPosition', financialPosition);
                appProduct.Client_Under_Supervision__c = appProduct.Client_Under_Supervision__c == 'Y' ? 'YES' : appProduct.Client_Under_Supervision__c == 'N' ? 'NO' : appProduct.Client_Under_Supervision__c;
				appProduct.Advice_Given__c = appProduct.Advice_Given__c == 'Y' ? 'YES' : appProduct.Advice_Given__c == 'N' ? 'NO' : appProduct.Advice_Given__c;
				contextBuilder.add('appProduct', appProduct);
                if(appProduct.ROA_SectionD_Table_Value__c != null && !String.isBlank(appProduct.ROA_SectionD_Table_Value__c)){
                    List<Object> roaSectionDTable = (List<Object>)Json.deserializeUntyped(appProduct.ROA_SectionD_Table_Value__c);
                    for(Object row : roaSectionDTable)
                    {
                        Map<String,Object> rec = (Map<string,Object>)row;
                        existingProduct.put(String.valueOf(rec.get('id')), String.valueOf(rec.get('existingProduct')));
                        newlyProposedPorduct.put(String.valueOf(rec.get('id')), String.valueOf(rec.get('newlyProposedPorduct')));
                    }
                }
                if(appProduct.ROA_SectionC_Table_Value__c != null && !String.isBlank(appProduct.ROA_SectionC_Table_Value__c)){
                    List<Object> roaSectionCTable = (List<Object>)Json.deserializeUntyped(appProduct.ROA_SectionC_Table_Value__c);
                    for(Object row : roaSectionCTable)
                    {
                        Map<String,Object> rec = (Map<string,Object>)row;
                        achiveFfinancialObjectives.put(String.valueOf(rec.get('id')), String.valueOf(rec.get('achiveFfinancialObjectives')));
                        productRecommended.put(String.valueOf(rec.get('id')), String.valueOf(rec.get('reommendedNotRecommended')));
                        reasonRecommended.put(String.valueOf(rec.get('id')), String.valueOf(rec.get('reason')));
                    }
                }
                contextBuilder.add('roaQuestions', roaQuestions);
                contextBuilder.add('existingProduct', existingProduct);
                contextBuilder.add('newlyProposedPorduct', newlyProposedPorduct);
                contextBuilder.add('productRecommended', productRecommended);
                contextBuilder.add('reasonRecommended', reasonRecommended);
                contextBuilder.add('achiveFfinancialObjectives', achiveFfinancialObjectives);

				List<Address__c> applicationAddress = new AddressesSelector().selectByAccountAndType(opp.AccountId, 'Business Address');

				if (!applicationAddress.isEmpty() && applicationAddress.size() > 0 && applicationAddress != null){
					contextBuilder.add('TradingAddress', applicationAddress.get(0));
				} else{
					applicationAddress = new AddressesSelector().selectByAccountAndType(opp.AccountId, 'Residential');
					if (!applicationAddress.isEmpty() && applicationAddress.size() > 0 && applicationAddress != null){
						contextBuilder.add('TradingAddress', applicationAddress.get(0));
					}
				}

				if (applicationDetails.get(0).Products_And_Services__c != '' && applicationDetails.get(0).Products_And_Services__c != null){
					List<String> productsServicesList = applicationDetails.get(0).Products_And_Services__c.split(';');
					if (!productsServicesList.isEmpty() && productsServicesList.size() > 0 && productsServicesList != null){
						for (String product : productsServicesList){
							contextBuilder.add(product, 'YES');
						}
					}
				}

				// get the Payment Plan (i.e. Banking Details)
				List<Payment_Plan__c> businessPaymentPlansList = new PaymentPlansSelector().selectByApplicationIdByTypeDetails(applicationDetails.get(0).Id, 'Business Bank', 1);
				if (!businessPaymentPlansList.isEmpty() && businessPaymentPlansList.size() > 0 && businessPaymentPlansList != null){
					contextBuilder.add('businessPaymentPlan', businessPaymentPlansList.get(0));
				}
				List<Payment_Plan__c> personalPaymentPlansList = new PaymentPlansSelector().selectByApplicationIdByTypeDetails(applicationDetails.get(0).Id, 'Business Bank', 1);
				if (!personalPaymentPlansList.isEmpty() && personalPaymentPlansList.size() > 0 && personalPaymentPlansList != null){
					contextBuilder.add('personalPaymentPlan', personalPaymentPlansList.get(0));
				}
				List<Payment_Plan__c> paymentPlansList = new PaymentPlansSelector().selectByApplicationIdByTypeDetails(applicationDetails.get(0).Id, '', 1);
				if (!paymentPlansList.isEmpty() && paymentPlansList.size() > 0 && paymentPlansList != null){
					contextBuilder.add('paymentPlan', paymentPlansList.get(0));
					if (paymentPlansList.get(0).Account_Type__c != 'Current'){
						contextBuilder.add('other', 'YES');
					}
				}

				//added by Manish to get the Priceschemes for account
				Map<String, Decimal> pricingFees = new Map<String, Decimal>();
				List<Price_Scheme_Entry__c> priceSchemeEntries = new PriceSchemeEntriesSelector().selectByPriceSchemeByAccountId(opp.AccountId);
				for (Price_Scheme_Entry__c priceSchemeEntry : priceSchemeEntries){
					if (!String.isBlank(priceSchemeEntry.Transaction_Group_Name__c) && priceSchemeEntry.Transaction_Group_Name__c.contains('Annual management fee')){
						pricingFees.put('Annual management fee', priceSchemeEntry.Fee_Amount_Percent__c == null ? 0.00 : priceSchemeEntry.Fee_Amount_Percent__c);
					} else if (!String.isBlank(priceSchemeEntry.Transaction_Group_Name__c) && priceSchemeEntry.Transaction_Group_Name__c.contains('Ongoing advisory fee')){
						pricingFees.put('Ongoing advisory fee', priceSchemeEntry.Fee_Amount_Percent__c == null ? 0.00 : priceSchemeEntry.Fee_Amount_Percent__c);
					} else if (!String.isBlank(priceSchemeEntry.Transaction_Group_Name__c) && priceSchemeEntry.Transaction_Group_Name__c.contains('Initial advice fee')){
						pricingFees.put('Initial advice fee', priceSchemeEntry.Fee_Amount_Percent__c == null ? 0.00 : priceSchemeEntry.Fee_Amount_Percent__c);
					} else if (!String.isBlank(priceSchemeEntry.Transaction_Group_Name__c) && priceSchemeEntry.Transaction_Group_Name__c.contains('Annual fee for foreign investments')){
						pricingFees.put('Annual fee for foreign investments', priceSchemeEntry.Fee_Amount_Percent__c == null ? 0.00 : priceSchemeEntry.Fee_Amount_Percent__c);
					}
				}
				contextBuilder.add('pricingFees', pricingFees);

				if (opp.RecordType.Name == 'Credit Onboarding'){
					List<Security_Offered__c> lstSecurityOffered = new securitiesOfferedSelector().selectByApplicationId(applicationDetails.get(0).Id);
					contextBuilder.add('SecurityOffered', lstSecurityOffered.get(0));
				}
			}

			// Get the Trading as names
			Set<Id> accIdSet = new Set<Id>();
			accIdSet.add(accountRecord.id);
			List<Trading_as_Name__c> tradingNamesList = new TradingAsNamesSelector().selectByAccountId(accIdSet);
			if (!tradingNamesList.isEmpty() && tradingNamesList.size() > 0 && tradingNamesList != null){
				List<String> tradingnNmes = Sys_Utilities_General.extractListValues(tradingNamesList, 'Name');
				if (!tradingnNmes.isEmpty() && tradingnNmes.size() > 0 && tradingnNmes != null){
					contextBuilder.add('tradingAsNames', string.join(tradingnNmes, ';'));
				}
			}

			// get the App Prod Merch
			if (!oppLineItemList.isEmpty() && oppLineItemList.size() > 0 && oppLineItemList != null){
				List<Application_Product_Merchant__c> appProdmerchList = new ApplicationProductMerchantsSelector().selectIdsByOpportunityLineItemId(oppLineItemList.get(0).Id);
				if (!appProdmerchList.isEmpty() && appProdmerchList.size() > 0 && appProdmerchList != null){
					if (appProdmerchList.get(0).Selected_Cards__c != '' && appProdmerchList.get(0).Selected_Cards__c != null){
						List<String> selectedCardsList = appProdmerchList.get(0).Selected_Cards__c.split(';');
						if (!selectedCardsList.isEmpty() && selectedCardsList.size() > 0 && selectedCardsList != null){
							for (String card : selectedCardsList){
								contextBuilder.add(card, 'true');
							}
						}
					}
					string cspName = [SELECT toLabel(CSP__c)
					                  FROM Application_Product_Merchant__c
					                  WHERE id = :appProdmerchList.get(0).Id].CSP__c;
					contextBuilder.add('cspName', cspName);

					contextBuilder.add('ApplicationProductMerchant', appProdmerchList.get(0));
					Map<String, Map<String, Double>> getFeesMap = getFees(opp.Id, appProdmerchList.get(0).Id);
					if (!getFeesMap.keyset().isEmpty() && getFeesMap.keyset().size() > 0 && getFeesMap.keyset() != null){
						Map<String, Double> feeCategoryMap = getFeesMap.get('feeCategoryMap');
						Map<String, Double> selectedCardsMap = getFeesMap.get('selectedCardsMap');
						if (!feeCategoryMap.keyset().isEmpty() && feeCategoryMap.keyset().size() > 0 && feeCategoryMap.keyset() != null){
							documentTemplate.XML__c = mapFeeCategoryToXML(documentTemplate.XML__c, feeCategoryMap);
						}
						if (!selectedCardsMap.keyset().isEmpty() && selectedCardsMap.keyset().size() > 0 && selectedCardsMap.keyset() != null){
							documentTemplate.XML__c = mapFeeCategoryToXML(documentTemplate.XML__c, selectedCardsMap);
						}
					}
				}
			}

			// get the Trustees
			List<AccountContactRelation> trusteesList = new AccountContactRelationSelector().selectbyAccountIdAndRoles(opp.AccountId, 'Trustees');
			if (!trusteesList.isEmpty() && trusteesList.size() > 0 && trusteesList != null){
				contextBuilder.add('Trustees', trusteesList);
			}

			// this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
			Datetime dt = Datetime.now();
			String day = dt.day() < 10 ? '0' + dt.day() : String.valueOf(dt.day());
			String month = dt.month() < 10 ? '0' + dt.month() : String.valueOf(dt.day());
			String year = String.valueOf(dt.year());
			contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
			contextBuilder.add('shorttoday', dt.format('yyyy-MM-dd'));
			contextBuilder.add('shorttodayddmmyyyy', day + month + year);
			contextBuilder.add('showUSCitizens', false);
			// end dirty fix
			String req = contextBuilder.serialize(documentTemplate.XML__c);

			Map<String, String> params = setECMParam(accountRecord, documentTemplate);
			string docFormat = documentTemplate.Generated_Document_Format__c;
			if (docFormat == null || docFormat == '') {
				docFormat = '.pdf';
			}
			String docName = documentTemplate.Name.left(75)+docFormat;
			if (documentTemplate.Name == 'ABSA 6171 EX - Commercial Property Finance Loan'){
				switch on opp.Form_Status__c{
					when 'Draft'{
						docName = 'ABSA 6171 EX - Internal Only Term Sheet' + docFormat;
					}
					when 'Pending Credit Approval'{
						docName = 'ABSA 6171 EX - Indicative Term Sheet' + docFormat;
					}
					when 'Credit Approved'{
						docName = 'ABSA 6171 EX - Commercial Terms' + docFormat;
					}
					when else{
						docName = documentTemplate.Name.left(62)+'-' + opp.Form_Status__c.left(23)+docFormat;
					}
				}
			}

			CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);

			Document__c doc = new Document__c(Id=documentId,Type__c = documentTemplate.Document_Type__c);

            if(response.contentStoreToken != null && response.contentStoreToken !=''){
                doc.Reference__c = response.contentStoreToken;
                doc.Generated_Uploaded__c = 'Generated';
            }
            else{
                throw new AuraHandledException('Failed to Insert Document');
            }
            if(documentId == null){
                doc.Account__c= accountRecord.Id;
                doc.Opportunity__c = opp.Id;
                doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
                doc.name = docName;
            }
            
			upsert doc;
			// did we win? - I pressume a failure would result in the catch running - unless of course it is some unhandled error no being thrown
			result.put('success', 'true');
			result.put('message', 'Successfully generated');
		} catch (Exception ex){
			result.put('success', 'false');
			result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
		}
		return result;
	}
    /**
	 * @description generateDocumentForCase  method to support documents for case
	 *
	 * @param caseId (Id): case id
	 * @param templateName (String): templateName
	 * @return Map<String,String>: Return description
	 */
	public static Map<String, String> generateDocumentForCase(Id caseId, String templateName){
        Map<String, String> result = new Map<String, String>();
        try{
            id opportunityId = null;

            Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);

            DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
            DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
            List<Map<String, String>> transactions = new List<Map<String, String>>();
            List<Case> caseRecord  = new CasesSelector().selectByCaseId(caseId);
			Account accountRecord = new AccountsSelector().selectAllByIdFOrDocs(caseRecord.get(0).AccountId);
            contextBuilder.add('case',caseRecord.get(0));
			// Added for AIP Case
            if(caseRecord.get(0).RecordType.Name == 'AIP Case'){
                contextBuilder.add('Account',accountRecord);
                contextBuilder.add('DateTimeCase',caseRecord.get(0).CreatedDate.format('yyyy-MM-dd')+'T00:00:00');
                Date incidentDt = caseRecord.get(0).Incident_Date__c;
                Datetime Incident_Raw = datetime.newInstance(incidentDt.year(), incidentDt.month(),incidentDt.day());
                contextBuilder.add('IncidentDate',Incident_Raw.format('yyyy-MM-dd')+'T00:00:00');
                contextBuilder.add('DeclarationInfo','True');
            }
            if(!String.isBlank(caseRecord.get(0).Extended_Request_Data__c)){
                for(String transactionRec : caseRecord.get(0).Extended_Request_Data__c.split('</line>')){
                    if(transactionRec != '</line>'){
						Map<String, String> transactionsMap = new Map<String, String>();
						transactionRec = transactionRec.contains('\t') ? transactionRec.replace('\t', ' ') : transactionRec;
						transactionRec = transactionRec.contains('<line>') ? transactionRec.replace('<line>', '') : transactionRec;
                    	transactionsMap.put('transaction', transactionRec);
                    	transactions.add(transactionsMap);
					}
                }
            }
            contextBuilder.add('transactions',transactions);
            // this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
            Datetime dt = Datetime.now();
            contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
            contextBuilder.add('shorttoday', dt.format('yyyy-MM-dd'));
            // end dirty fix
            String req = contextBuilder.serialize(documentTemplate.XML__c);

			Map<String, String> params = setECMParam(accountRecord, documentTemplate);
			CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
            Document__c doc = new Document__c(Name = documentTemplate.Name.left(75)+'.pdf',Type__c = documentTemplate.Document_Type__c,Reference__c = response.contentStoreToken,Case__c = caseId,ECM_Type__c = documentTemplate.ECM_Item_Type__c);
            insert doc;
            // did we win? - I pressume a failure would result in the catch running - unless of course it is some unhandled error no being thrown
            result.put('success', 'true');
            result.put('message', 'Successfully generated');
        } catch (Exception ex){
            result.put('success', 'false');
            result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
        }
        return result;
    }
	private static String mapRelatedPatiesToXML(String xmlMap, List<Contact> relatedParties){
		Integer count = 1;
		String closingTag = '</Signature_Details>';
		Integer scheduleLength = closingTag.length()+1;
		String xmlExtender = '';
		String xml = xmlMap;
		String section = '';
		if (xml.indexOf('<Signature_Details>')<>-1 && xml.indexOf('</Signature_Details>')<>-1){
			section = xml.substring(xml.indexOf('<Signature_Details>'), xml.indexOf('</Signature_Details>')+scheduleLength);
			String dataSection = '';
			for (Contact value : relatedParties){
				if (section.contains('<Signature_Details>')){
					dataSection += '<sigName' + count + '>{{' + value.Name + '}}</sigName' + count + '>';
					dataSection += '<positionHeld' + count + '>{{' + value.AccountContactRelations[0].Designation__c + '}}</positionHeld' + count + '>';
					dataSection += '<SigDate' + count + '>{{today}}</SigDate' + count + '>';
					count += 1;
					//xmlExtender += dataSection;
				}
			}
			dataSection += '<sigQ_x0026_A></sigQ_x0026_A>';
			dataSection += '<nameOfQ_x0026_A></nameOfQ_x0026_A>';
			dataSection += '<Q_x0026_ADate>{{today}}</Q_x0026_ADate>';
			dataSection += '<nameOfApprover></nameOfApprover>';
			dataSection += '<dateOfApproval>{{today}}</dateOfApproval>';
			dataSection += '</Signature_Details>';
			xmlExtender = '<Signature_Details>' + dataSection;
		}
		if (xmlExtender != ''){
			xml = xml.replace(section, xmlExtender);
		}
		return xml;
	}

	private static String mapFeeCategoryToXML(String xmlMap, Map<String, Double> productMap){
		Integer count = 0;
		String closingTagCredit = '</LocalCredit>';
		Integer scheduleLengthCredit = closingTagCredit.length()+1;
		String closingTagDebit = '</LocalDebit>';
		Integer scheduleLengthDebit = closingTagDebit.length()+1;
		String closingTagInt = '</International>';
		Integer scheduleLengthInt = closingTagInt.length()+1;
		String xmlExtender = '';
		String xml = xmlMap;

		if (xml.indexOf('<LocalCredit>')<>-1 && xml.indexOf('</LocalCredit>')<>-1){
			String sectionCredit = xml.substring(xml.indexOf('<LocalCredit>'), xml.indexOf('</LocalCredit>')+scheduleLengthCredit);

			for (String value : productMap.keySet()){
				if (sectionCredit.contains('<LocalCredit>') && value.contains('Credit')){
					String dataSection = sectionCredit;
					dataSection = dataSection.replace(('{{name}}'), value);
					dataSection = dataSection.replace(('{{rate}}'), String.valueOf(productMap.get(value)));
					xmlExtender += dataSection;
				}
			}
			if (xmlExtender != ''){
				xml = xml.replace(sectionCredit, xmlExtender);
			}
		}
		xmlExtender = '';
		if (xml.indexOf('<LocalDebit>')<>-1 && xml.indexOf('</LocalDebit>')<>-1){
			String sectionDebit = xml.substring(xml.indexOf('<LocalDebit>'), xml.indexOf('</LocalDebit>')+scheduleLengthDebit);

			for (String value : productMap.keySet()){
				if (sectionDebit.contains('<LocalDebit>') && value.contains('Debit') && !value.contains('Visa')){
					String dataSection = sectionDebit;
					dataSection = dataSection.replace(('{{name}}'), value);
					dataSection = dataSection.replace(('{{rate}}'), String.valueOf(productMap.get(value)));
					xmlExtender += dataSection;
				}
			}
			if (xmlExtender != ''){
				xml = xml.replace(sectionDebit, xmlExtender);
			}
		}
		xmlExtender = '';
		if (xml.indexOf('<International>')<>-1 && xml.indexOf('</International>')<>-1){
			String sectionInt = xml.substring(xml.indexOf('<International>'), xml.indexOf('</International>')+scheduleLengthInt);
			for (String value : productMap.keySet()){
				if (sectionInt.contains('<International>') && (value.contains('Visa') || value.contains('Union') || value.contains('Mastercard'))){
					String dataSection = sectionInt;
					dataSection = dataSection.replace(('{{name}}'), value);
					dataSection = dataSection.replace(('{{rate}}'), String.valueOf(productMap.get(value)));
					xmlExtender += dataSection;
				}
			}
			if (xmlExtender != ''){
				xml = xml.replace(sectionInt, xmlExtender);
			}
		}
		return xml;
	}

	// end Tinashe
	/**
	 * @description generateTheDocument description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param templateName (String): templateName
	 * @param signatureRequests (List<SignatureRequest__c>): signatureRequests
	 * @return Map<String,String>: Return description
	 *
	 */
	@AuraEnabled
	public static Map<String, String> generateTheDocument(Id opportunityId, String templateName, List<SignatureRequest__c> signatureRequests){

		Map<String, String> result = new Map<String, String>();
		try{
			Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);

			Account acc = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);
			Document_Template__c template = new DocumentTemplateSelector().selectTemplateByName(templateName);

			String state = generateContent(acc, opp, template, generateXmlData(acc, opp, template), signatureRequests);

			if (state == 'success'){
				result.put('success', 'true');
				result.put('message', 'Successfully generated');
			} else{
				result.put('success', 'false');
				result.put('message', state);
			}

		} catch (Exception ex){
			result.put('success', 'false');
			result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
		}
		return result;
	}

	/**
	 * @description autoGenerateDoc description
	 *
	 * @param templateName (String): templateName
	 * @param objMap (Map<StringString>): objMap
	 * @return String: Return description
	 */
	public static String autoGenerateDoc(String templateName, Map<String, String> objMap){

		String inputType = objMap.get('inputType');
		String state;
		if (inputType == 'fieldValues'){
			state = autoGenerateDocFieldValues(templateName, objMap);
		} else if (inputType == 'idValues'){
			state = autoGenerateDocIdValues(templateName, objMap);
		}

		return state;
	}

	/**
	 * @description autoGenerateDocFieldValues
	 * @author Thulani
	 *
	 * @param templateName (String): templateName
	 * @param objMap (Map<String, String>): objMap
	 * @return String: Return description
	 */
	public static String autoGenerateDocFieldValues(String templateName, Map<String, String> objMap){
		String opportunityId = objMap.get('opportunityId');
		Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);

		Account acc = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);
		Document_Template__c template = new DocumentTemplateSelector().selectTemplateByName(templateName);
		template.Name += '-' + objMap.get('quoteNumber');
		String xml = DocumentTemplateMapper.createXmlForAuto(objMap, resolveCustomVariables(template.XML__c));

		String state;
		if (!Test.isRunningTest()){
			state = generateContent(acc, opp, template, xml, null);
		}

		return state;
	}

	/**
	 * @description autoGenerateDocIdValues
	 *
	 * @param templateName (String): templateName
	 * @param objMap (Map<StringString>): objMap
	 * @return String: Return description
	 */
	public static String autoGenerateDocIdValues(String templateName, Map<String, String> objMap){
		// Example: PJAIN.objMap: {applicationNumber=009242, applicationId=a0u0E00000CkpObQAJ, applicationProductMerchantId=a1Q0E000000r8f2UAA, opportunityId=0060E00000T4jzuQAB, opportunityLineItemId=00k0E000005jY6JQAU}
		// Example: PJAIN.objMap.JSON: {"applicationProductMerchantId":"a1Q0E000000r8f2UAA","applicationId":"a0u0E00000CkpObQAJ","opportunityLineItemId":"00k0E000005jY6JQAU","opportunityId":"0060E00000T4jzuQAB"}
		Map<Id, sObject> listObject = new Map<Id, sObject>();
		Document_Template__c template = new DocumentTemplateSelector().selectTemplateByName(templateName);
		Opportunity opportunity = new Opportunity();
		Application__c application = new Application__c();
		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		Contact contact = new Contact();
		Application_Product_Merchant__c applicationProductMerc = new Application_Product_Merchant__c();
		List<Application_Product_Merchant__c> applicationProductMercList = new List<Application_Product_Merchant__c>();
		Id contactPersonId;

		for (String objectIdName : objMap.keySet()){
			if (objMap.get(objectIdName) != null){

				switch on objectIdName{
					when 'applicationId'{
						application = new ApplicationsSelector().selectById(objMap.get(objectIdName));
						if (application != null){
							listObject.put((Id)objMap.get(objectIdName), application);
						}
					}
					when 'applicationProductMerchantId'{
						applicationProductMercList = new ApplicationProductMerchantsSelector().selectById(objMap.get(objectIdName));
						if (applicationProductMercList != null && applicationProductMercList.size() > 0){
							applicationProductMerc = applicationProductMercList[0];
							listObject.put((Id)objMap.get(objectIdName), applicationProductMerc);
						}
					}
					when 'opportunityId'{
						opportunity = new OpportunitiesSelector().selectByOppId(objMap.get(objectIdName));
						if (opportunity != null){
							listObject.put((Id)objMap.get(objectIdName), opportunity);
						}
					}
					when 'opportunityLineItemId'{
						List<OpportunityLineItem> opportunityLineItemList = new OpportunityLineItemsSelector().selectById(objMap.get(objectIdName));
						if (opportunityLineItemList != null && opportunityLineItemList.size() > 0){
							oppLineItem = opportunityLineItemList[0];
							listObject.put((Id)objMap.get(objectIdName), oppLineItem);
							if (opportunityLineItemList[0].Contact_Person__c != null){
								contactPersonId = opportunityLineItemList[0].Contact_Person__c;
							}
						}
					}
					when 'applicationNumber'{
						template.Name += '-' + objMap.get(objectIdName);
					}
				}
			}
		}

		List<AccountContactRelation> accContactRelationList = new List<AccountContactRelation>();

		if (contactPersonId != null){
			String sObjName = contactPersonId.getSObjectType().getDescribe().getName();
			List<Contact> contactList = new List<Contact>();

			if (sObjName == 'Contact'){
				contactList = new ContactSelector().selectById(new Set<Id>{contactPersonId});
				if (contactList != null && contactList.size() > 0){
					contact = contactList[0];
					listObject.put(contact.Id, contact);
				} else{
					listObject.put('0', new Contact());
				}
			} else if (sObjName == 'AccountContactRelation'){
				accContactRelationList = new AccountContactRelationSelector().selectRelationById(contactPersonId);
				contactList = new ContactSelector().selectById(new Set<Id>{accContactRelationList[0].ContactId});
				if (contactList != null && contactList.size() > 0){
					listObject.put(contactList[0].Id, contactList[0]);
				} else{
					listObject.put('0', new Contact());
				}
			}
		}

		Account acc = new AccountsSelector().selectAllByIdFOrDocs(opportunity.AccountId);
		Payment_Plan__c paymentPlan = new Payment_Plan__c();
		listObject.put(acc.Id, acc);

		List<Payment_Plan__c> paymentPlanList = new PaymentPlansSelector().selectByApplicationIdByTypeDetails(objMap.get('applicationId'), 'Business Bank', 1);
		if (paymentPlanList != null && paymentPlanList.size() > 0){
			paymentPlan = paymentPlanList[0];
			listObject.put(paymentPlan.Id, paymentPlan);
		}

		Address__c address = new Address__c();
		List<Address__c> addressList = new AddressesSelector().selectByAccountIds(new Set<String>{String.valueOf(acc.Id)});
		if (addressList != null && addressList.size() > 0){
			address = addressList[0];
			listObject.put(address.Id, address);
		}

		String resolvedXML;
		String valuedXML;
		String state;

		switch on templateName{
			when 'Absa 1391: Merchant Agreement'{
				//state = setDocFields(template, opportunity, acc, address, paymentPlan, applicationProductMerc, oppLineItem, contact);
				Map<String, String> result = generate13911Doc(template, opportunity, acc, address, paymentPlan, applicationProductMerc, oppLineItem, contact);
				if (result.get('success') == 'true'){
					state = 'success';
				} else{
					state = 'fail';
				}
			}
			when else{
				String xml = template.XML__c;
				xml = xml.replaceAll('\\{Account.Name\\}', acc.Name); // added by Tinashe seems we have to do it like this for 5778
				acc.Registration_Number__c = acc.Registration_Number__c == null ? '' : acc.Registration_Number__c;
				acc.ID_Number__pc = acc.ID_Number__pc == null ? '' : acc.ID_Number__pc;
				xml = xml.replaceAll('\\{Account.Registration_Number__c\\}\\{Account.ID_Number__pc\\}', acc.Registration_Number__c + acc.ID_Number__pc);
				if (!addressList.isEmpty() && addressList.size() > 0 && addressList != null){
					xml = xml.replaceAll('\\{Address__c.Shipping_Street__c\\}', addressList.get(0).Shipping_Street__c);
					xml = xml.replaceAll('\\{Address__c.Shipping_City__c\\}', addressList.get(0).Shipping_City__c);
					xml = xml.replaceAll('\\{Address__c.Shipping_Zip_Postal_code__c\\}', addressList.get(0).Shipping_Zip_Postal_code__c);
					xml = xml.replaceAll('\\{Address__c.Shipping_Suburb__c\\}', addressList.get(0).Shipping_Suburb__c);
				} else{
					xml = xml.replaceAll('\\{Address__c.Shipping_Street__c\\}', '');
					xml = xml.replaceAll('\\{Address__c.Shipping_City__c\\}', '');
					xml = xml.replaceAll('\\{Address__c.Shipping_Zip_Postal_code__c\\}', '');
					xml = xml.replaceAll('\\{Address__c.Shipping_Suburb__c\\}', '');
				}
				if (paymentPlan != null){
					paymentPlan.Account_Number__c = paymentPlan.Account_Number__c == null ? '' : paymentPlan.Account_Number__c;
					paymentPlan.Branch_Name__c = paymentPlan.Branch_Name__c == null ? '' : paymentPlan.Branch_Name__c;
					paymentPlan.Bank_Name__c = paymentPlan.Bank_Name__c == null ? '' : paymentPlan.Bank_Name__c;
				} else{
					paymentPlan.Account_Number__c = '';
					paymentPlan.Branch_Name__c = '';
					paymentPlan.Bank_Name__c = '';
				}
				xml = xml.replaceAll('\\{Payment_Plan__c.Account_Number__c\\}', paymentPlan.Account_Number__c);
				xml = xml.replaceAll('\\{Payment_Plan__c.Branch_Name__c\\}', paymentPlan.Branch_Name__c);
				xml = xml.replaceAll('\\{Payment_Plan__c.Bank_Name__c\\}', paymentPlan.Bank_Name__c);
				template.XML__c = xml;

				String xmlNew = mapSelectedCardAndFeeCategory(template, applicationProductMerc, oppLineItem, new Map<string, String>());

				resolvedXML = DocumentTemplateMapper.createXml(listObject, resolveCustomVariables(xmlNew), null);

				if (!Test.isRunningTest()){
					state = generateContent(acc, opportunity, template, resolvedXML, null);
				}
			}
		}
		return state;
	}

		/**
	 * @description cards Description
	 *
	 */
	public class cards{
		/**
		 * @description cardName
		 */
		public String cardName{ get; set; }

		/**
		 * @description feeValue
		 */
		public Decimal feeValue{ get; set; }
	}

	/**
	 * @description generate13911Doc description
	 *
	 * @param template (Document_Template__c): template
	 * @param opp (Opportunity): opp
	 * @param acc (Account): acc
	 * @param address (Address__c): address
	 * @param paymentPlan (Payment_Plan__c): paymentPlan
	 * @param apm (Application_Product_Merchant__c): apm
	 * @param oppLineItem (OpportunityLineItem): oppLineItem
	 * @param contact (Contact): contact
	 * @return Map<String,String>: Return description
	 */
	public static Map<String, String> generate13911Doc(Document_Template__c template, Opportunity opp, Account acc, Address__c address, Payment_Plan__c paymentPlan, Application_Product_Merchant__c apm, OpportunityLineItem oppLineItem, Contact contact){		Map<String, String> result = new Map<String, String>();
		try{
			Document_Template__c documentTemplate = template;

			DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
			DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();

			contextBuilder.add('Opportunity', opp);
			contextBuilder.add('Account', acc);
			contextBuilder.add('address', address);
			contextBuilder.add('paymentPlan', paymentPlan);
			contextBuilder.add('apm', apm);
			contextBuilder.add('contact', contact);
			contextBuilder.add('oppLineItem', oppLineItem);
			contextBuilder.add('equipmentDescription', oppLineItem.Product_Name__c);
			contextBuilder.add('Quantity', String.valueOf(oppLineItem.Quantity.round()));
			contextBuilder.add('rentalAmount', String.valueOf(oppLineItem.UnitPrice));
			Map<String, Map<String, Double>> schedule = getFees(oppLineItem.OpportunityId, apm.Id);

			Map<String, Double> feeCategoryMap = schedule.get('feeCategoryMap');

			List<cards> feeCatListCredit = new List<cards>();
			List<cards> feeCatListDebit = new List<cards>();
			for (String key : feeCategoryMap.keySet()){
				cards c = new cards();
				c.cardName = key;
				c.feeValue = feeCategoryMap.get(key);
				if (feeCategoryMap.get(key) != null){
					if (key.contains('Debit')){
						feeCatListDebit.add(c);
					} else if (key.contains('Credit')){
						feeCatListCredit.add(c);
					}
				}
			}

			contextBuilder.add('feeCatListDebit', feeCatListDebit);
			contextBuilder.add('feeCatListCredit', feeCatListCredit);

			Map<String, Double> selectedCardsMap = schedule.get('selectedCardsMap');
			List<cards> feeCatList = new List<cards>();
			for (String key : selectedCardsMap.keySet()){
				cards c = new cards();
				c.cardName = key;
				c.feeValue = selectedCardsMap.get(key);
				feeCatList.add(c);
			}

			contextBuilder.add('selectedCardsMap', feeCatList);
			contextBuilder.add('internationalCard', Application_Product_Merchant__c.International_Card__c.getDescribe().getLabel());
			contextBuilder.add('internationalFeeRate', apm.International_Card__c == null ? '0.00' : String.valueOf(apm.International_Card__c));

			String req = contextBuilder.serialize(documentTemplate.XML__c);

			Map<String, String> params = GenerateDocument.setECMParam(acc, documentTemplate);

			CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);

			Document__c doc = new Document__c(Type__c=documentTemplate.Document_Type__c,Reference__c = response.contentStoreToken,Opportunity__c = opp.Id,ECM_Type__c = documentTemplate.ECM_Item_Type__c);
			string docFormat = documentTemplate.Generated_Document_Format__c;
			if (docFormat == null || docFormat == ''){
				docFormat = '.pdf';
			}
			doc.Name = documentTemplate.Name.left(75)+docFormat;
			insert doc;
			// did we win? - I pressume a failure would result in the catch running - unless of course it is some unhandled error no being thrown
			result.put('success', 'true');
			result.put('message', 'Successfully generated');
		} catch (Exception ex){
			result.put('success', 'false');
			result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
		}
		return result;
	}

	private static String mapSelectedCardAndFeeCategory(Document_Template__c template, Application_Product_Merchant__c apm, OpportunityLineItem oppLineItem, Map<String, String> docFields){
		Map<String, Map<String, Double>> schedule = getFees(oppLineItem.OpportunityId, apm.Id);
		String xml = template.XML__c;

		if (schedule != null){
			for (String key : schedule.keySet()){
				Map<String, Double> productMap = schedule.get(key);
				if (productMap != null){
					switch on key{
						when 'selectedCardsMap'{
							xml = mapSelectCardToXML(xml, productMap);
						}
						when 'feeCategoryMap'{
							docFields = addFeeCategory(docFields, productMap);
						}
					}
					xml = map4492SelectCardToXML(xml, productMap);
				}
			}
		}
		if (apm.Chargeback_Fee__c != null)
			xml = xml.replaceAll('\\{Application_Product_Merchant__c.Chargeback_Fee__c\\}', string.valueof(apm.Chargeback_Fee__c));
		// added by Tinashe to display charge back fee

		return DocumentTemplateMapper.createXmlForAuto(docFields, resolveCustomVariables(xml));
	}

	private static Map<String, String> addFeeCategory(Map<String, String> docFields, Map<String, Double> productMap){
		for (String value : productMap.keySet()){
			if (value.contains('Debit') && docFields.get('localDebit') == null){
				docFields.put('localDebit', value);
				docFields.put('localDebitFeeRate', String.valueOf(productMap.get(value)));
			} else if (value.contains('Credit') && docFields.get('localCredit') == null){
				docFields.put('localCredit', value);
				docFields.put('localCreditFeeRate', String.valueOf(productMap.get(value)));
			}
		}
		return docFields;
	}

	private static String mapSelectCardToXML(String xmlMap, Map<String, Double> productMap){
		//Integer count = 0;
		String closingTag = '</ScheduleA>';
		Integer scheduleLength = closingTag.length()+1;
		String xmlExtender = '';
		String xml = xmlMap;
		if (xml.contains('<ScheduleA>')){
			String section = xml.substring(xml.indexOf('<ScheduleA>'), xml.indexOf('</ScheduleA>')+scheduleLength); // removed -1 to SYNC with PROD
			for (String value : productMap.keySet()){
				if (section.contains('<ScheduleA>') && section.contains('<facilityType>{facilityType}</facilityType>')){
					String dataSection = section;
					dataSection = dataSection.replace(('{facilityType}'), value);
					dataSection = dataSection.replace(('{cardFixedService}'), String.valueOf(productMap.get(value)));
					xmlExtender += dataSection;
				}
			}
			return xmlMap.replace(section, xmlExtender);
		} else{
			return xml;
		}
	}

	private static String map4492SelectCardToXML(String xmlMap, Map<String, Double> productMap){
		//Integer count = 0;
		String closingTag = '</International>';
		Integer scheduleLength = closingTag.length()+1;
		String xmlExtender = '';
		String xml = xmlMap;
		if (xml.contains('<International>')){
			String section = xml.substring(xml.indexOf('<International>'), xml.indexOf('</International>')+scheduleLength); // removed a -1 to sync with PROD
			for (String value : productMap.keySet()){
				if (section.contains('<International>')){
					String dataSection = section;
					dataSection = dataSection.replace(('{internationalCard}'), value);
					dataSection = dataSection.replace(('{Application_Product_Merchant__c.International_Card__c}'), String.valueOf(productMap.get(value)));
					xmlExtender += dataSection;
				}
			}
			return xmlMap.replace(section, xmlExtender);
		} else{
			return xml;
		}
	}

	/**
	 * @description getFeeCategoryMap \
	 *
	 * @param oppId (Id): oppId
	 * @param apmId (Id): apmId
	 * @return Map<String,Double>: Return description
	 */
	public static Map<String, Double> getFeeCategoryMap(Id oppId, Id apmId){
		Map<String, Map<String, Double>> schedule = getFees(oppId, apmId);
		return schedule.get('feeCategoryMap');
	}

	/**
	 * @description getSelectedCardsMap
	 *
	 * @param oppId (Id): oppId
	 * @param apmId (Id): apmId
	 * @return Map<String,Double>: Return description
	 */
	public static Map<String, Double> getSelectedCardsMap(Id oppId, Id apmId){
		Map<String, Map<String, Double>> schedule = getFees(oppId, apmId);
		return schedule.get('selectedCardsMap');
	}

	/**
	 * @description getFees description
	 *
	 * @param oppId (Id): oppId
	 * @param apmId (Id): apmId
	 * @return Map<String,Map<String,Double>>: Return description
	 */
	public static Map<String, Map<String, Double>> getFees(Id oppId, Id apmId){
		Map<String, Map<String, Double>> results = new Map<String, Map<String, Double>>();

		//Id opportunityId = oppId; //'0060E00000UkhHQQAZ';
		//Id applicationProductMerchantId = apmId; //'a1Q0E000000rFGkUAM';

		Map<String, Double> selectedCardsMap = new Map<String, Double>();
		Map<String, Double> feeCategoryMap = new Map<String, Double>();
		List<Application_Product_Merchant__c> apmList = new ApplicationProductMerchantsSelector().selectById(apmId);
		String jsonString = MerchantQuoteBuilderController.getQuoteBuilderData(oppId);
		MerchantQuoteBuilderController.PricingBean pricingBean = (MerchantQuoteBuilderController.PricingBean)JSON.deserialize(jsonString, MerchantQuoteBuilderController.PricingBean.class);

		if (apmList != null && apmList.size() > 0){

			String selectedCards = apmList[0].Selected_Cards__c;

			if (String.isNotBlank(selectedCards)){
				//Set<String> selectedCardsSet = new Set<String>(selectedCards.split(';'));
				List<Accepted_Card__c> acceptedCardList = new AcceptedCardsSelector().selectByName(new Set<String>(selectedCards.split(';')), StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD);
				acceptedCardList.addAll(new AcceptedCardsSelector().selectByType(StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_FEE_CATEGORY));

				if (acceptedCardList != null && acceptedCardList.size() > 0){

					for (Accepted_Card__c acceptedCard : acceptedCardList){

						String mapKey;
						Double feeValue = 0;
						MerchantQuoteBuilderController.PriceSchemeEntryData priceSchemeEntryData;

						if (String.isNotBlank(acceptedCard.Transaction_Group__r.Name)){
							mapKey = String.format(StringConstants.MERCHANT_PRICE_SCHEME_ENTRY_MAP_KEY_TEMPLATE, new List<String>{acceptedCard.Transaction_Group__r.Name, 'All'});
							priceSchemeEntryData = pricingBean.priceSchemeEntryMap.get(mapKey);
						}

						if (priceSchemeEntryData != null){
							feeValue = priceSchemeEntryData.existingValue;
						} else if (acceptedCard.Price_Override__c != null){
							feeValue = acceptedCard.Price_Override__c;
						}

						if (acceptedCard.Type__c == StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD){
							selectedCardsMap.put(acceptedCard.Name, feeValue);
						} else{
							feeCategoryMap.put(acceptedCard.Name, feeValue);
						}
					}
				}
			}
		}
		results.put('selectedCardsMap', selectedCardsMap);
		results.put('feeCategoryMap', feeCategoryMap);
		return results;
	}

	/**
	 * @description generateContent description
	 *
	 * @param acc (Account): acc
	 * @param opp (Opportunity): opp
	 * @param template (Document_Template__c): template
	 * @param xml (String): xml
	 * @param signatureRequests (List<SignatureRequest__c>): signatureRequests
	 * @return String: Return description
	 */
	public static String generateContent(Account acc, Opportunity opp, Document_Template__c template, String xml, List<SignatureRequest__c> signatureRequests){
		CC_GenerateContentRequest request = setRequestParam(acc, template, xml);
		try{

			CC_GenerateContentResponse response = CC_ContentService_IH_v1.generateContent(request);
			if (response == null){
				if (signatureRequests != null){
					delete signatureRequests;
				}
				throw new AuraException('Error generating document response is null');
			}
			return createDocument(acc, opp.Id, template, request, response, signatureRequests);
		} catch (Exception ex){
			throw new AuraException('Error generating document: ' + ex.getMessage()+' StackTrace: ' + ex.getStackTraceString());
		}
	}

	/**
	 * @author Thulani Maseko
	 * @description Generates a document for the input type and links it to the input opportunity
	 *
	 * @param acc (Account): acc
	 * @param template (Document_Template__c): template
	 * @param xml (String): xml
	 * @return CC_GenerateContentRequest: Return description
	 */
	public static CC_GenerateContentRequest setRequestParam(Account acc, Document_Template__c template, String xml){
		CC_GenerateContentRequest request = new CC_GenerateContentRequest();

		request.TemplateID = template.Template_Id__c;
		request.fileName = template.Name + '.pdf';
		request.TemplateDataType = 'XML';
		request.LogLevel = 'Debug';
		request.ScheduleTimeStamp = String.valueOf(Date.today());
		request.RecordSystemFeedbackID = '123';
		request.ContentRequestType = 'PDF';
		request.ContentStoreType = 'ECM';
		request.ContentVersion = '1.0.0.0';
		request.encodingType = 'Base64';
		request.ReturnEmptyContent = false;
		Map<String, String> fields = setECMParam(acc, template);
		request.addParams(createEcmParams(fields));
		request.templateData = xml;

		return request;
	}

	/**
	 * @description setECMParam description
	 *
	 * @param acc (Account): acc
	 * @param template (Document_Template__c): template
	 * @return Map<String,String>: Return description
	 */
	public static Map<String, String> setECMParam(Account acc, Document_Template__c template){
		Map<String, String> fields = new Map<String, String>();

		fields.put('CIFNr', acc.CIF__c == null ? '0' : acc.CIF__c);
		string idnum = '0';
		if (acc.Registration_Number__c != null) {
			idnum = acc.Registration_Number__c;
		}
		if (acc.ID_Number__pc != null) {
			idnum = acc.ID_Number__pc;
		}
		fields.put('IdNr', idnum);
		fields.put('AcctNr', acc.AccountNumber == null ? '0' : acc.AccountNumber);
		fields.put('Origin', 'Salesforce B2C');
		fields.put('BusinessUnit', 'RBB');
		if(template.Name.contains('Merchant Settlements')){
			fields.put('password', idnum);
		}

		if (!Test.isRunningTest()){
			Map<String, String> credentials = ECM_IH_V1.getCredentials();
			fields.put('ECM_Account', credentials.get('username'));
			fields.put('ECM_Password', credentials.get('password'));
			fields.put('ECMItemType', template.ECM_Item_Type__c);
		}

		return fields;
	}

	/**
	 * @description createEcmParams description
	 *
	 * @param values (Map<StringString>): values
	 * @return List<CC_GenerateContentRequest.ContentStoreParams>: Return description
	 */
	public static List<CC_GenerateContentRequest.ContentStoreParams> createEcmParams(Map<String, String> values){
		List<CC_GenerateContentRequest.ContentStoreParams> params = new List<CC_GenerateContentRequest.ContentStoreParams>();
		for (String key : values.keySet()){
			params.add(new CC_GenerateContentRequest.ContentStoreParams(key, values.get(key)));
		}
		return params;
	}

	private static String generateXmlData(Account acc, Opportunity opp, Document_Template__c template){
		Map<String, String> lookupMappings = new Map<String, String>();
		List<AccountContactRelation> arc = new AccountContactRelationSelector().selectByAccount(acc.Id);

		lookupMappings.put('Account.Opportunity', 'AccountId');
		lookupMappings.put('Opportunity.Quote', 'OpportunityId');
		lookupMappings.put('Account.AccountContactRelation', 'AccountContactRelationId');
		lookupMappings.put('Account.SignatureRequest__c', 'AccountId');

		String temp = resolveCustomVariables(template.XML__c);
		Map<Id, sObject> objects = resolveObjects(acc, opp);
		if (Test.isRunningTest())
			return 'success';
		String xml = DocumentTemplateMapper.createXml(objects, temp, lookupMappings);
		return xml;
	}

	/**
	 * @description createDocument description
	 *
	 * @param acc (Account): acc
	 * @param opportunityId (Id): opportunityId
	 * @param template (Document_Template__c): template
	 * @param request (CC_GenerateContentRequest): request
	 * @param response (CC_GenerateContentResponse): response
	 * @param signatureRequests (List<SignatureRequest__c>): signatureRequests
	 * @return String: Return description
	 */
	public static String createDocument(Account acc, Id opportunityId, Document_Template__c template, CC_GenerateContentRequest request, CC_GenerateContentResponse response, List<SignatureRequest__c> signatureRequests){
		String result;
		Document__c doc = new Document__c(Name = request.fileName,Type__c = template.Document_Type__c,ECM_Type__c = template.ECM_Item_Type__c,Account__c = acc.Id,Opportunity__c = opportunityId,Reference__c = response.contentStoreToken);
		List<SignatureRequest__c> signatureRequestsUpdate = new List<SignatureRequest__c>();

		try{
			insert doc;
			//TdB - Update signatureRequests with DocumentId
			if (signatureRequests != null && signatureRequests.size() > 0){
				for (SignatureRequest__c eachSignature : signatureRequests){
					eachSignature.Document__c = doc.id;
					signatureRequestsUpdate.add(eachSignature);
				}
				update signatureRequestsUpdate;
			}
			result = 'success';
		} catch (Exception ex){
			result = 'Message ' + ex.getMessage()+' Cause ' + ex.getCause()+' StackTraceString ' + ex.getStackTraceString();
		}
		return result;
	}

	/**
	 * @description updateDocument description
	 *
	 * @param acc (Account): acc
	 * @param opportunityId (Id): opportunityId
	 * @param template (Document_Template__c): template
	 * @param existingDocId (Id): existingDocId
	 * @param request (CC_GenerateContentRequest): request
	 * @param response (CC_GenerateContentResponse): response
	 * @return String: Return description
	 */
	public static String updateDocument(Account acc, Id opportunityId, Document_Template__c template, Id existingDocId, CC_GenerateContentRequest request, CC_GenerateContentResponse response){
		String result;

		Document__c doc = new DocumentsSelector().selectById(existingDocId);
		doc.Name = request.fileName;
		doc.Type__c = template.Document_Type__c;
		doc.ECM_Type__c = template.ECM_Item_Type__c;
		doc.Account__c = acc.Id;
		doc.Opportunity__c = opportunityId;
		doc.Reference__c = response.contentStoreToken;
		try{
			update doc;
			result = 'success';
		} catch (Exception ex){
			result = 'Message ' + ex.getMessage()+' Cause ' + ex.getCause()+' StackTraceString ' + ex.getStackTraceString();
		}
		return result;
	}

	/**
	 * @description resolveObjects description
	 *
	 * @param acc (Account): acc
	 * @param opp (Opportunity): opp
	 * @return Map<Id,SObject>: Return description
	 */
	public static Map<Id, SObject> resolveObjects(Account acc, Opportunity opp){
		Map<Id, sObject> objects = new Map<Id, sObject>();
		List<Address__c> addresses = new AddressesSelector().addressesRelatedToAcc(acc.Id);
		List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectRelationByAccountId(acc.Id);
		ApplicationsSelector appSelect = new ApplicationsSelector();
		List<Application__c> applicationList = appSelect.selectByOpportunityId(opp.Id);
		Application__c application = new Application__c();

		if (applicationList.size() > 0 && applicationList != null){
			application = applicationList[0];
			objects.put(application.Id, application);
		}


		AccountContactRelation acr = new AccountContactRelation();

		if (acrList.size() > 0 && acrList != null){
			acr = acrList[0];
			objects.put(acr.Id, acr);
		}

		ContactsSelector contactSelect = new ContactsSelector();
		List<Contact> conList = contactSelect.selectCifFieldsByAccountId(acc.Id);
		Contact con = new Contact();

		if (conList.size() > 0 && conList != null){
			con = conList[0];
			objects.put(con.Id, con);
		}
		ApplicationProductMerchantsSelector apmSelector = new ApplicationProductMerchantsSelector();
		List<Application_Product_Merchant__c> apmList = apmSelector.selectIdsByOpportunityId(opp.Id);
		Application_Product_Merchant__c apm = new Application_Product_Merchant__c();

		if (apmList.size() > 0 && apmList != null){
			apm = apmList[0];
			objects.put(apm.Id, apm);

		} else{
			objects.put(null, apm);
		}

		User us = new UsersSelector().selectByOpportunityOwnerId(opp.OwnerId).get(0);
		if (acc.Id != null)
			objects.put(acc.Id, acc);
		if (addresses != null && addresses.size() > 0)
			objects.put(addresses.get(0).Id, addresses.get(0));
		if (us != null)
			objects.put(us.Id, us);
		return objects;
	}

	private static String resolveCustomVariables(String template){
		Map<String, String> context = new Map<String, String>();
		Datetime dt = Datetime.now();
		context.put('today', dt.format('yyyy-MM-dd')+'T00:00:00');
		for (String var : context.keySet()){
			template = template.replaceAll('\\{' + var + '\\}', context.get(var));
		}
		return template;
	}
	/**
	 * @description 
	 */
    Public Class NonIndividualRelatedPartyWrapper{
        public String accountName;
        public String registrationNumber;
        public String tradingName;
        public String countryOfRegistration;
        public String sharingPercentage;
        public String roles;
        Public Address__c headOfficeAddress;
        Public Address__c businesseAddress;
        Public Address__c registeredAddress;
    }
    /**
	 * @description 
	 */
    Public Class IndividualRelatedPartyWrapper{
        Public Contact contact;
        Public String authorizedSignatory ;
        Public String compulsorySignatory;
        Public String groupNo;
        Public String mandateOfficial;
        Public String internetBankingUser;
        Public String mandateIndemnityUser;
        Public String secondaryCardUser;
        Public String wealthBankingMandate;
        Public String roles;
        Public String instructionType;
        Public String instructionMethod;
        Public String accountApplicable;
        public String countryOfCitizenShip;
        public String language;
        Public Decimal sharePercentage;
        Public Address__c residentialAddress;
    }
    /**
	 * @description 
	 */
    Public Class ProductWrapper{
        Public OpportunityLineItem opportunityProduct;
        Public Application_Product__c applicationProduct;
    }
}