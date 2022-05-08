/**
 * ** Tinashe m Shoko
 otherTransactionalCovenants * @description method for generating CPF document generateCPFDocuments
 *
 */
public class generateCPFDocuments{
	/**
	 * @description updateOppFormStatus description
	 *
	 * @param formStatus (string): formStatus
	 * @param oppId (Id): oppId
	 * @param templatename (string): templatename
	 * @return string: Return description
	 */
	@AuraEnabled
	public static string updateOppFormStatus(string formStatus, Id oppId, string templatename){
		string result;
		Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
		opp.Form_Status__c = formStatus;
		try{
			update opp;
			result = 'success';
		} catch (Exception ex){
			result = 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString();
			system.debug(ex.getMessage());
			system.debug(ex.getLineNumber());
		}
		return result;
	}

	/**
	 * @description getSingleOrMulytiPhase description
	 *
	 * @param oppId (Id): oppId
	 * @return string: Return description
	 */
	@AuraEnabled
	public static string getSingleOrMultiPhase(Id oppId){
		try{
			List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(oppId);
			if (!applicationDetails.isEmpty() && applicationDetails.size() > 0 && applicationDetails != null){
				List<Application_Product_CPF__c> appPrdctCpfList = new ApplicationProductCPFSelector().selectListByAppId(applicationDetails.get(0).Id);
				if (!appPrdctCpfList.isEmpty() && appPrdctCpfList.size() > 0 && appPrdctCpfList != null){
					if (appPrdctCpfList.get(0).Multiple_phases_applicable__c == 'Yes'){
						return 'Multi';
					} else{
						return 'Single';
					}
				}
			}
			return 'Single';
		} catch (Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description generateDoc description
	 *
	 * @param oppId (Id): oppId
	 * @param templatename (string): templatename
	 * @return Map<String,String>: Return description
	 */
	@AuraEnabled
	public static Map<String, String> generateDoc(Id oppId, string templatename){
		system.debug('Generating document type  ' + templatename + ' for Opportunity record id ' + oppId);
		Map<String, String> result = new Map<String, String>();
		List<SignatureRequest__c> signatureRequests = new List<SignatureRequest__c>();
		try{
			Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);
			Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);

			DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
			DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();

			contextBuilder.add('Opportunity', opp);
			List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opp.Id, 1);

			Account accountRecord = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);
			contextBuilder.add('Account', accountRecord);

			List<Address__c> addresses = new AddressesSelector().addressesRelatedToAcc(opp.AccountId);
			if (!addresses.isEmpty() && addresses.size() > 0 && addresses != null){
				List<Address__c> businessAddress = new List<Address__c>();
				for (Address__c address : addresses){
					switch on address.Address_Type__c{
						when 'Business Address'{
							businessAddress.add(address);
						}
					}
				}
				if (!businessAddress.isEmpty() && businessAddress.size() > 0 && businessAddress != null){
					contextBuilder.add('BusinessAddress', businessAddress.get(0));
				}
			}

			if (opp.Regional_Manager__c != null){
				User regionalManager = new UsersSelector().selectById(opp.Regional_Manager__c);
				if (regionalManager != null){
					contextBuilder.add('regionalManagerPhone', regionalManager.Phone);
					contextBuilder.add('regionalManagerName', regionalManager.Name);
				}
			}
			if (opp.Adviser__c != null){
				User adviser = new UsersSelector().selectById(opp.Adviser__c);
				if (adviser != null){
					contextBuilder.add('adviserPhone', adviser.Phone);
					contextBuilder.add('adviserName', adviser.Name);
				}
			}
			List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(opp.id);
			if (!applicationDetails.isEmpty() && applicationDetails.size() > 0 && applicationDetails != null){
				applicationDetails.get(0).Parent__c = applicationDetails.get(0).Parent__c == 'Yes' ? 'YES' : applicationDetails.get(0).Parent__c == 'No' ? 'NO' : applicationDetails.get(0).Parent__c;
				applicationDetails.get(0).Is_the_parent_also_a_guarantor__c = applicationDetails.get(0).Is_the_parent_also_a_guarantor__c == 'Yes' ? 'YES' : applicationDetails.get(0).Is_the_parent_also_a_guarantor__c == 'No' ? 'NO' : applicationDetails.get(0).Is_the_parent_also_a_guarantor__c;

				Integer borrowerNumberOfDaysToAccept;
				if (applicationDetails.get(0).Number_of_days_for_Borrower_to_accept_of__c != null){
					borrowerNumberOfDaysToAccept = Integer.valueOf(applicationDetails.get(0).Number_of_days_for_Borrower_to_accept_of__c.mid(0, applicationDetails.get(0).Number_of_days_for_Borrower_to_accept_of__c.length()-5));
					contextBuilder.add('borrowerNumberOfDaysToAccept', borrowerNumberOfDaysToAccept);
				}

				contextBuilder.add('Application', applicationDetails.get(0));

				if (opp.RecordType.Name == 'CPF Onboarding'){
					List<Application_Product_CPF__c> appPrdctCpfList = new ApplicationProductCPFSelector().selectListByAppId(applicationDetails.get(0).Id);
					if (!appPrdctCpfList.isEmpty() && appPrdctCpfList.size() > 0 && appPrdctCpfList != null){
						Application_Product_CPF__c appPrdctCpf = appPrdctCpfList.get(0);
						appPrdctCpf.Facility_purpose__c = appPrdctCpf.Facility_purpose__c == 'PURPOSE AS APPROVED BY CREDIT' ? 'Other' : appPrdctCpf.Facility_purpose__c == 'To finance in whole or in part the acquisition of the Property' ? 'To finance in whole or in part the acquisition of' : appPrdctCpf.Facility_purpose__c;
						appPrdctCpf.Late_bond_registration_penalty__c = appPrdctCpf.Late_bond_registration_penalty__c == 'Yes' ? 'true' : appPrdctCpf.Late_bond_registration_penalty__c == 'No' ? 'false' : appPrdctCpf.Late_bond_registration_penalty__c;
						appPrdctCpf.Include_guarantor_s__c = appPrdctCpf.Include_guarantor_s__c == 'Yes' ? 'true' : appPrdctCpf.Include_guarantor_s__c == 'No' ? 'false' : appPrdctCpf.Include_guarantor_s__c;
						appPrdctCpf.Obligor_incorporated_outside_of_SA__c = appPrdctCpf.Obligor_incorporated_outside_of_SA__c == 'Yes' ? 'YES' : appPrdctCpf.Obligor_incorporated_outside_of_SA__c == 'No' ? 'NO' : appPrdctCpf.Obligor_incorporated_outside_of_SA__c;
						appPrdctCpf.Payment_Requirements__c = appPrdctCpf.Payment_Requirements__c == 'By debit to current account' ? 'By debit to the Current Account' : appPrdctCpf.Payment_Requirements__c;

						appPrdctCpf.Other_fees_applicable__c = appPrdctCpf.Other_fees_applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Other_fees_applicable__c == 'No' ? 'NO' : appPrdctCpf.Other_fees_applicable__c;
						appPrdctCpf.Include_admin_fee_in_total_facility__c = appPrdctCpf.Include_admin_fee_in_total_facility__c == 'Yes' ? 'YES' : appPrdctCpf.Include_admin_fee_in_total_facility__c == 'No' ? 'NO' : appPrdctCpf.Include_admin_fee_in_total_facility__c;
						appPrdctCpf.Include_admin_fee_in_total_facility2__c = appPrdctCpf.Include_admin_fee_in_total_facility2__c == 'Yes' ? 'YES' : appPrdctCpf.Include_admin_fee_in_total_facility2__c == 'No' ? 'NO' : appPrdctCpf.Include_admin_fee_in_total_facility2__c;
						appPrdctCpf.Is_VAT_facility_applicable__c = appPrdctCpf.Is_VAT_facility_applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Is_VAT_facility_applicable__c == 'No' ? 'NO' : appPrdctCpf.Is_VAT_facility_applicable__c;
						appPrdctCpf.Admin_fee__c = appPrdctCpf.Admin_fee__c == 'Yes' ? 'YES' : appPrdctCpf.Admin_fee__c == 'No' ? 'NO' : appPrdctCpf.Admin_fee__c;
						appPrdctCpf.Early_termination_fee__c = appPrdctCpf.Early_termination_fee__c == 'Yes' ? 'YES' : appPrdctCpf.Early_termination_fee__c == 'No' ? 'NO' : appPrdctCpf.Early_termination_fee__c;
						appPrdctCpf.Include_VAT_on_charges__c = appPrdctCpf.Include_VAT_on_charges__c == 'Yes' ? 'YES' : appPrdctCpf.Include_VAT_on_charges__c == 'No' ? 'NO' : appPrdctCpf.Include_VAT_on_charges__c;
						appPrdctCpf.Secondary_Account_Applicable__c = appPrdctCpf.Secondary_Account_Applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Secondary_Account_Applicable__c == 'No' ? 'NO' : appPrdctCpf.Secondary_Account_Applicable__c;
						appPrdctCpf.Owner_Occupied__c = appPrdctCpf.Owner_Occupied__c == 'Yes' ? 'YES' : appPrdctCpf.Owner_Occupied__c == 'No' ? 'NO' : appPrdctCpf.Owner_Occupied__c;
						appPrdctCpf.Transactional_covenants_applicable__c = appPrdctCpf.Transactional_covenants_applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Transactional_covenants_applicable__c == 'No' ? 'NO' : appPrdctCpf.Transactional_covenants_applicable__c;
						appPrdctCpf.Corporate_covenants_applicable__c = appPrdctCpf.Corporate_covenants_applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Corporate_covenants_applicable__c == 'No' ? 'NO' : appPrdctCpf.Corporate_covenants_applicable__c;
						appPrdctCpf.Security_Provider_Consent__c = appPrdctCpf.Security_Provider_Consent__c == 'Yes' ? 'YES' : appPrdctCpf.Security_Provider_Consent__c == 'No' ? 'NO' : appPrdctCpf.Security_Provider_Consent__c;
						appPrdctCpf.Amendment_and_restatement_clause_app__c = appPrdctCpf.Amendment_and_restatement_clause_app__c == 'Yes' ? 'YES' : appPrdctCpf.Amendment_and_restatement_clause_app__c == 'No' ? 'NO' : appPrdctCpf.Amendment_and_restatement_clause_app__c;
						appPrdctCpf.Transactional_banking_accounts__c = appPrdctCpf.Transactional_banking_accounts__c == 'Yes' ? 'YES' : appPrdctCpf.Transactional_banking_accounts__c == 'No' ? 'NO' : appPrdctCpf.Transactional_banking_accounts__c;
						appPrdctCpf.Undertakings_threshold__c = appPrdctCpf.Undertakings_threshold__c == 'Yes' ? 'YES' : appPrdctCpf.Undertakings_threshold__c == 'No' ? 'NO' : appPrdctCpf.Undertakings_threshold__c;
						appPrdctCpf.Was_a_desktop_valuation_done__c = appPrdctCpf.Was_a_desktop_valuation_done__c == 'Yes' ? 'YES' : appPrdctCpf.Was_a_desktop_valuation_done__c == 'No' ? 'NO' : appPrdctCpf.Was_a_desktop_valuation_done__c;
						appPrdctCpf.Prepayment_fee__c = appPrdctCpf.Prepayment_fee__c == 'Yes' ? 'YES' : appPrdctCpf.Prepayment_fee__c == 'No' ? 'NO' : appPrdctCpf.Prepayment_fee__c;
						appPrdctCpf.Pre_let__c = appPrdctCpf.Pre_let__c == 'Yes' ? 'YES' : appPrdctCpf.Pre_let__c == 'No' ? 'NO' : appPrdctCpf.Pre_let__c;
						appPrdctCpf.Pre_let_review__c = appPrdctCpf.Pre_let_review__c == 'Yes' ? 'YES' : appPrdctCpf.Pre_let_review__c == 'No' ? 'NO' : appPrdctCpf.Pre_let_review__c;
						appPrdctCpf.Include_repayment_schedule__c = appPrdctCpf.Include_repayment_schedule__c == 'Yes' ? 'YES' : appPrdctCpf.Include_repayment_schedule__c == 'No' ? 'NO' : appPrdctCpf.Include_repayment_schedule__c;
						appPrdctCpf.Financial_assistance__c = appPrdctCpf.Financial_assistance__c == 'Yes' ? 'YES' : appPrdctCpf.Financial_assistance__c == 'No' ? 'NO' : appPrdctCpf.Financial_assistance__c;
						appPrdctCpf.Other_amounts_included_in_total_facility__c = appPrdctCpf.Other_amounts_included_in_total_facility__c == 'Yes' ? 'YES' : appPrdctCpf.Other_amounts_included_in_total_facility__c == 'No' ? 'NO' : appPrdctCpf.Other_amounts_included_in_total_facility__c;
						appPrdctCpf.Electrical_compliance_certificate__c = appPrdctCpf.Electrical_compliance_certificate__c == 'Yes' ? 'YES' : appPrdctCpf.Electrical_compliance_certificate__c == 'No' ? 'NO' : appPrdctCpf.Electrical_compliance_certificate__c;
						appPrdctCpf.Environmental_permits__c = appPrdctCpf.Environmental_permits__c == 'Yes' ? 'YES' : appPrdctCpf.Environmental_permits__c == 'No' ? 'NO' : appPrdctCpf.Environmental_permits__c;
						appPrdctCpf.Newly_formed_company__c = appPrdctCpf.Newly_formed_company__c == 'Yes' ? 'YES' : appPrdctCpf.Newly_formed_company__c == 'No' ? 'NO' : appPrdctCpf.Newly_formed_company__c;
						appPrdctCpf.Restraint_against_free_alienation_notari__c = appPrdctCpf.Restraint_against_free_alienation_notari__c == 'Yes' ? 'YES' : appPrdctCpf.Restraint_against_free_alienation_notari__c == 'No' ? 'NO' : appPrdctCpf.Restraint_against_free_alienation_notari__c;
						appPrdctCpf.Valuation_fee__c = appPrdctCpf.Valuation_fee__c == 'Yes' ? 'YES' : appPrdctCpf.Valuation_fee__c == 'No' ? 'NO' : appPrdctCpf.Valuation_fee__c == 'Yes exluding VAT' ? 'YES, EXCLUDING VAT' : appPrdctCpf.Valuation_fee__c;
						appPrdctCpf.Performance_guarantees__c = appPrdctCpf.Performance_guarantees__c == 'Yes' ? 'YES' : appPrdctCpf.Performance_guarantees__c == 'No' ? 'NO' : appPrdctCpf.Performance_guarantees__c;
						appPrdctCpf.Section_82_Certificate__c = appPrdctCpf.Section_82_Certificate__c == 'Yes' ? 'YES' : appPrdctCpf.Section_82_Certificate__c == 'No' ? 'NO' : appPrdctCpf.Section_82_Certificate__c;
						appPrdctCpf.Withdrawal__c = appPrdctCpf.Withdrawal__c == '    withdraw the Facility' ? '    withdraw the facility' : appPrdctCpf.Withdrawal__c == 'review pricing of the Facility' ? 'review the pricing of the facility' : appPrdctCpf.Withdrawal__c;
						appPrdctCpf.Additional_finance_documents_required__c = appPrdctCpf.Additional_finance_documents_required__c == 'Yes' ? 'YES' : appPrdctCpf.Additional_finance_documents_required__c == 'No' ? 'NO' : appPrdctCpf.Additional_finance_documents_required__c;
						appPrdctCpf.Additional_finance_documents__c = appPrdctCpf.Additional_finance_documents__c == 'Yes' ? 'YES' : appPrdctCpf.Additional_finance_documents__c == 'No' ? 'NO' : appPrdctCpf.Additional_finance_documents__c;

						if (appPrdctCpf.Development_loan_Final_Repayment_Date__c == '4 (four) months after the expiry of the Development Period'){
							contextBuilder.add('4Months', '4 (four) months after the expiry of the Development Period');
						} else if (appPrdctCpf.Development_loan_Final_Repayment_Date__c == 'Date'){
							contextBuilder.add('4MonthsDate', appPrdctCpf.Date_of_final_repayment__c);
						}

						switch on appPrdctCpf.Final_repayment_date__c{
							when 'Date'{
								contextBuilder.add('appPrdctCpfDate', 'YES');
							}
							when 'after the date of first drawdown'{
								contextBuilder.add('appPrdctCpfafterDateOfFirstDrawDown', 'YES');
								appPrdctCpf.Final_repayment_date__c = 'Date after first drawdown';
							}
							when 'after the Signature Date'{
								contextBuilder.add('appPrdctCpfafterSignatureDate', 'YES');
								appPrdctCpf.Final_repayment_date__c = 'Date after Signature';
							}
						}

						if (appPrdctCpf.Difference_clause_applicable__c == 'Payout In Tranches'){
							contextBuilder.add('tranches', 'YES');
						}
						if (appPrdctCpf.Multiple_phases_applicable__c == 'Yes'){
							contextBuilder.add('Singlemultiplephase', 'MULTIPLE PHASES');
						} else{
							contextBuilder.add('Singlemultiplephase', 'SINGLE PHASE');
						}

						// financials
						if (appPrdctCpf.Including_financial_statements_of_guaran__c == 'other entity'){
							contextBuilder.add('financialsOtherentity', 'YES');
						}
						appPrdctCpf.Financial_statements__c = appPrdctCpf.Financial_statements__c == 'Financial statements of the Borrower' ? 'FINANCIAL STATEMENTS OF THE BORROWER' : appPrdctCpf.Financial_statements__c == 'Consolidated financial statements of the Parent and each of its Subsidiaries' ? 'CONSOLIDATED FINANCIAL STATEMENTS OF THE PARENT AND EACH OF ITS SUBSIDIARIES' : appPrdctCpf.Financial_statements__c == 'Consolidated financial statements of other entitles and each of its Subsidiaries' ? 'CONSOLIDATED FINANCIAL STATEMENTS OF OTHER ENTITIES AND EACH OF ITS SUBSIDIARIES' : appPrdctCpf.Financial_statements__c == 'other entity' ? 'OTHER ENTITY' : appPrdctCpf.Financial_statements__c == 'Financial statements of the Borrower and the Guarantor(s)' ? 'FINANCIAL STATEMENTS OF THE BORROWER AND THE GUARANTOR(S)' : appPrdctCpf.Financial_statements__c;

						if (appPrdctCpf.Including_financial_statements_of_guaran__c == 'Yes'){
							appPrdctCpf.Financial_statements__c = appPrdctCpf.Financial_statements__c + ' AND THE GUARANTOR(S)';
						}
						appPrdctCpf.Borrower_has_subsidiaries__c = appPrdctCpf.Borrower_has_subsidiaries__c == 'Yes' ? 'YES' : appPrdctCpf.Borrower_has_subsidiaries__c == 'No' ? 'NO' : appPrdctCpf.Borrower_has_subsidiaries__c;
						appPrdctCpf.Guarantor_s_to_provide_the_bank_with_fi__c = appPrdctCpf.Guarantor_s_to_provide_the_bank_with_fi__c == 'Yes' ? 'YES' : appPrdctCpf.Guarantor_s_to_provide_the_bank_with_fi__c == 'No' ? 'NO' : appPrdctCpf.Guarantor_s_to_provide_the_bank_with_fi__c;
						appPrdctCpf.Guarantor_s_has_have_subsidiaries__c = appPrdctCpf.Guarantor_s_has_have_subsidiaries__c == 'Yes' ? 'YES' : appPrdctCpf.Guarantor_s_has_have_subsidiaries__c == 'No' ? 'NO' : appPrdctCpf.Guarantor_s_has_have_subsidiaries__c;
						appPrdctCpf.Parent_to_provide_the_bank_with_financia__c = appPrdctCpf.Parent_to_provide_the_bank_with_financia__c == 'Yes' ? 'YES' : appPrdctCpf.Parent_to_provide_the_bank_with_financia__c == 'No' ? 'NO' : appPrdctCpf.Parent_to_provide_the_bank_with_financia__c;
						appPrdctCpf.Unaudited_interim_statements_required__c = appPrdctCpf.Unaudited_interim_statements_required__c == 'Yes' ? 'YES' : appPrdctCpf.Unaudited_interim_statements_required__c == 'No' ? 'NO' : appPrdctCpf.Unaudited_interim_statements_required__c;
						appPrdctCpf.The_bank_reserves_the_right_to__c = appPrdctCpf.The_bank_reserves_the_right_to__c == 'Yes' ? 'YES' : appPrdctCpf.The_bank_reserves_the_right_to__c == 'No' ? 'NO' : appPrdctCpf.The_bank_reserves_the_right_to__c;
						string theBankreservesTheRightTo = appPrdctCpf.The_bank_reserves_the_right_to__c == 'Yes' ? 'true' : appPrdctCpf.The_bank_reserves_the_right_to__c == 'No' ? 'false' : appPrdctCpf.The_bank_reserves_the_right_to__c;
						appPrdctCpf.Include_guarantor_s__c = appPrdctCpf.Include_guarantor_s__c == 'Yes' ? 'YES' : appPrdctCpf.Include_guarantor_s__c == 'No' ? 'NO' : appPrdctCpf.Include_guarantor_s__c;
						appPrdctCpf.Financial_covenants_applicable__c = appPrdctCpf.Financial_covenants_applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Financial_covenants_applicable__c == 'No' ? 'NO' : appPrdctCpf.Financial_covenants_applicable__c;
						string alreadyHeld = appPrdctCpf.Already_Held__c == 'Yes' ? 'true' : appPrdctCpf.Already_Held__c == 'No' ? 'false' : appPrdctCpf.Already_Held__c;
						appPrdctCpf.Bank_contractors_or_insurance_companies__c = appPrdctCpf.Bank_contractors_or_insurance_companies__c == 'Yes' ? 'true' : appPrdctCpf.Bank_contractors_or_insurance_companies__c == 'No' ? 'false' : appPrdctCpf.Bank_contractors_or_insurance_companies__c;
						appPrdctCpf.Structural_integrity_certificate__c = appPrdctCpf.Structural_integrity_certificate__c == 'Yes' ? 'true' : appPrdctCpf.Structural_integrity_certificate__c == 'No' ? 'false' : appPrdctCpf.Structural_integrity_certificate__c;
						appPrdctCpf.Fire_design__c = appPrdctCpf.Fire_design__c == 'Yes' ? 'true' : appPrdctCpf.Fire_design__c == 'No' ? 'false' : appPrdctCpf.Fire_design__c;
						appPrdctCpf.Including_financial_statements_of_guaran__c = appPrdctCpf.Including_financial_statements_of_guaran__c == 'Yes' ? 'YES' : appPrdctCpf.Including_financial_statements_of_guaran__c == 'No' ? 'NO' : appPrdctCpf.Including_financial_statements_of_guaran__c;
						appPrdctCpf.Financial_information_required__c = appPrdctCpf.Financial_information_required__c == 'copies of its audited financial statements year' ? 'Copies of its audited financial statements' : appPrdctCpf.Financial_information_required__c == 'copies of its unaudited  management accounts' ? 'Copies of its unaudited management accounts' : appPrdctCpf.Financial_information_required__c == 'copies of its unaudited management accounts' ? 'Copies of its unaudited management accounts' : appPrdctCpf.Financial_information_required__c == 'other financial information required' ? 'Other financial information required' : appPrdctCpf.Financial_information_required__c;
						appPrdctCpf.Financial_information_required__c = appPrdctCpf.Financial_information_required__c == 'Copies of its audited financial statements' ? 'COPIES OF ITS AUDITED FINANCIAL STATEMENTS' : appPrdctCpf.Financial_information_required__c == 'Copies of its unaudited  management accounts' ? 'COPIES OF ITS UNAUDITED MANAGEMENT ACCOUNTS' : appPrdctCpf.Financial_information_required__c == 'Other financial information required' ? 'OTHER FINANCIAL INFORMATION REQUIRED' : appPrdctCpf.Financial_information_required__c;
						appPrdctCpf.Borrower_under_CPA__c = appPrdctCpf.Borrower_under_CPA__c == 'Yes' ? 'YES' : appPrdctCpf.Borrower_under_CPA__c == 'No' ? 'NO' : appPrdctCpf.Borrower_under_CPA__c;
						appPrdctCpf.Environmental_permits__c = appPrdctCpf.Environmental_permits__c == 'Yes' ? 'YES' : appPrdctCpf.Environmental_permits__c == 'No' ? 'NO' : appPrdctCpf.Environmental_permits__c;
						appPrdctCpf.Confirmation_from_architect__c = appPrdctCpf.Confirmation_from_architect__c == 'Yes' ? 'true' : appPrdctCpf.Confirmation_from_architect__c == 'No' ? 'false' : appPrdctCpf.Confirmation_from_architect__c;
						appPrdctCpf.Confirmation_of_mechanical_electrical_de__c = appPrdctCpf.Confirmation_of_mechanical_electrical_de__c == 'Yes' ? 'true' : appPrdctCpf.Confirmation_of_mechanical_electrical_de__c == 'No' ? 'false' : appPrdctCpf.Confirmation_of_mechanical_electrical_de__c;
						appPrdctCpf.Is_Sufficient_Budget__c = appPrdctCpf.Is_Sufficient_Budget__c == 'Yes' ? 'true' : appPrdctCpf.Is_Sufficient_Budget__c == 'No' ? 'false' : appPrdctCpf.Is_Sufficient_Budget__c;
						appPrdctCpf.Approved_sectional_title_plans__c = appPrdctCpf.Approved_sectional_title_plans__c == 'Yes' ? 'YES' : appPrdctCpf.Approved_sectional_title_plans__c == 'No' ? 'NO' : appPrdctCpf.Approved_sectional_title_plans__c;
						appPrdctCpf.Is_Sectional_Title_Plan_Approved__c = appPrdctCpf.Is_Sectional_Title_Plan_Approved__c == 'Yes' ? 'YES' : appPrdctCpf.Is_Sectional_Title_Plan_Approved__c == 'No' ? 'NO' : appPrdctCpf.Is_Sectional_Title_Plan_Approved__c;
						appPrdctCpf.Upon_completion_of_the_Development__c = appPrdctCpf.Upon_completion_of_the_Development__c == 'Yes' ? 'YES' : appPrdctCpf.Upon_completion_of_the_Development__c == 'No' ? 'NO' : appPrdctCpf.Upon_completion_of_the_Development__c;
						appPrdctCpf.Is_Upon_Completion_Of_Development__c = appPrdctCpf.Is_Upon_Completion_Of_Development__c == 'Yes' ? 'YES' : appPrdctCpf.Is_Upon_Completion_Of_Development__c == 'No' ? 'NO' : appPrdctCpf.Is_Upon_Completion_Of_Development__c;

						if (templatename == 'ABSA 6171 EX - Commercial Property Finance Loan'){
							appPrdctCpf.Lease_options__c = appPrdctCpf.Lease_options__c == 'Yes' ? 'YES' : appPrdctCpf.Lease_options__c == 'No' ? 'NO' : appPrdctCpf.Lease_options__c;
						} else{
							appPrdctCpf.Lease_options__c = appPrdctCpf.Lease_options__c == 'Yes' ? 'NETT LEASES AS PER SCHEDULE 4' : appPrdctCpf.Lease_options__c == 'No' ? 'NO' : appPrdctCpf.Lease_options__c;
						}
						appPrdctCpf.Other_Leases__c = appPrdctCpf.Other_Leases__c == 'Yes' ? 'YES' : appPrdctCpf.Other_Leases__c == 'No' ? 'NO' : appPrdctCpf.Other_Leases__c;
						appPrdctCpf.Copy_of_standard_sales_agreement__c = appPrdctCpf.Copy_of_standard_sales_agreement__c == 'Yes' ? 'YES' : appPrdctCpf.Copy_of_standard_sales_agreement__c == 'No' ? 'NO' : appPrdctCpf.Copy_of_standard_sales_agreement__c;
						appPrdctCpf.Financial_covenants_by_reference__c = appPrdctCpf.Financial_covenants_by_reference__c == 'Yes' ? 'YES' : appPrdctCpf.Financial_covenants_by_reference__c == 'No' ? 'NO' : appPrdctCpf.Financial_covenants_by_reference__c;
						appPrdctCpf.Other_Entity__c = appPrdctCpf.Other_Entity__c == 'Yes' ? 'YES' : appPrdctCpf.Other_Entity__c == 'No' ? 'NO' : appPrdctCpf.Other_Entity__c;
						appPrdctCpf.Pre_sales__c = appPrdctCpf.Pre_sales__c == 'Yes' ? 'YES' : appPrdctCpf.Pre_sales__c == 'No' ? 'NO' : appPrdctCpf.Pre_sales__c;
						appPrdctCpf.Copies_of_all_sale_agreements__c = appPrdctCpf.Copies_of_all_sale_agreements__c == 'Yes' ? 'YES' : appPrdctCpf.Copies_of_all_sale_agreements__c == 'No' ? 'NO' : appPrdctCpf.Copies_of_all_sale_agreements__c;
						appPrdctCpf.Copy_of_standard_sales_agreement__c = appPrdctCpf.Copy_of_standard_sales_agreement__c == 'Yes' ? 'YES' : appPrdctCpf.Copy_of_standard_sales_agreement__c == 'No' ? 'NO' : appPrdctCpf.Copy_of_standard_sales_agreement__c;
						appPrdctCpf.Schedule_of_sales__c = appPrdctCpf.Schedule_of_sales__c == 'Yes' ? 'YES' : appPrdctCpf.Schedule_of_sales__c == 'No' ? 'NO' : appPrdctCpf.Schedule_of_sales__c;
						appPrdctCpf.Schedule_of_net_sale__c = appPrdctCpf.Schedule_of_net_sale__c == 'Yes' ? 'YES' : appPrdctCpf.Schedule_of_net_sale__c == 'No' ? 'NO' : appPrdctCpf.Schedule_of_net_sale__c;
						appPrdctCpf.Undertakings_threshold__c = appPrdctCpf.Undertakings_threshold__c == 'Yes' ? 'YES' : appPrdctCpf.Undertakings_threshold__c == 'No' ? 'THERE IS NO UNDERTAKINGS THRESHOLD' : appPrdctCpf.Undertakings_threshold__c;
						appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c = appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c == 'Yes' ? 'YES' : appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c == 'No' ? 'NO' : appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c;
						string vatfacilityinterestmargin = appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c == 'YES' ? 'NO VARIANCE' : appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c == 'NO' ? null : null;
						contextBuilder.add('vatfacilityinterestmargin', vatfacilityinterestmargin);

						appPrdctCpf.Include_balance_on_existing_account__c = appPrdctCpf.Include_balance_on_existing_account__c == 'Yes' ? 'YES' : appPrdctCpf.Include_balance_on_existing_account__c == 'No' ? 'NO' : appPrdctCpf.Include_balance_on_existing_account__c;
						string finalrepaymentdateafterconversion = appPrdctCpf.Final_repayment_date_after_conversion__c != null ? 'YES' : 'NO';
						contextBuilder.add('Finalrepaymentdateafterconversion', finalrepaymentdateafterconversion);
						appPrdctCpf.Multiple_purchase__c = appPrdctCpf.Multiple_purchase__c == 'Amount' ? 'AMOUNT' : appPrdctCpf.Multiple_purchase__c == 'Percentage' ? 'PERCENTAGE' : appPrdctCpf.Multiple_purchase__c;
						appPrdctCpf.Non_refundable_deposit__c = appPrdctCpf.Non_refundable_deposit__c == 'Amount' ? 'AMOUNT' : appPrdctCpf.Non_refundable_deposit__c == 'Percentage' ? 'PERCENTAGE' : appPrdctCpf.Non_refundable_deposit__c;
						appPrdctCpf.Final_repayment_date_after_conversion__c = appPrdctCpf.Final_repayment_date_after_conversion__c == 'day(s)' ? 'DAY(S)' : appPrdctCpf.Final_repayment_date_after_conversion__c == 'month(s)' ? 'MONTH(S)' : appPrdctCpf.Final_repayment_date_after_conversion__c == 'year(s)' ? 'YEAR(S)' : appPrdctCpf.Final_repayment_date_after_conversion__c;
						contextBuilder.add('indebtednessLower', appPrdctCpf.Indebtedness__c);
						appPrdctCpf.Indebtedness__c = appPrdctCpf.Indebtedness__c == 'the Loan and any other indebtedness' ? 'THE LOAN AND ANY OTHER INDEBTEDNESS' : appPrdctCpf.Indebtedness__c == 'the Loan' ? 'THE LOAN' : appPrdctCpf.Indebtedness__c;
						string indebtedness = appPrdctCpf.Indebtedness__c == 'THE LOAN AND ANY OTHER INDEBTEDNESS' ? 'YES' : null;
						contextBuilder.add('indebtedness', indebtedness);
						appPrdctCpf.Cancellation_after_acceptance_clause__c = appPrdctCpf.Cancellation_after_acceptance_clause__c == 'Yes' ? 'YES' : appPrdctCpf.Cancellation_after_acceptance_clause__c == 'No' ? 'NO' : appPrdctCpf.Cancellation_after_acceptance_clause__c;
						appPrdctCpf.Are_breakage_costs_applicable__c = appPrdctCpf.Are_breakage_costs_applicable__c == 'Yes' ? 'YES' : appPrdctCpf.Are_breakage_costs_applicable__c == 'No' ? 'NO' : appPrdctCpf.Are_breakage_costs_applicable__c;
						appPrdctCpf.Threshold_periods__c = appPrdctCpf.Threshold_periods__c == 'in aggregate' ? 'AMOUNT IN AGGREGATE AT ANY TIME DURING THE TERM OF THE FACILITY AGREEMENT' : appPrdctCpf.Threshold_periods__c == 'in every 12(twelve) months from Final Date for Drawdown' ? 'EVERY 12 MONTH(S) FROM FINAL DATE FOR DRAW DOWN' : appPrdctCpf.Threshold_periods__c;

						appPrdctCpf.Instruct_independent_Valuer__c = appPrdctCpf.Instruct_independent_Valuer__c == 'Yes' ? 'true' : appPrdctCpf.Instruct_independent_Valuer__c == 'No' ? 'false' : appPrdctCpf.Instruct_independent_Valuer__c;
						appPrdctCpf.Provide_a_full_analysis__c = appPrdctCpf.Provide_a_full_analysis__c == 'Yes' ? 'true' : appPrdctCpf.Provide_a_full_analysis__c == 'No' ? 'false' : appPrdctCpf.Provide_a_full_analysis__c;
						appPrdctCpf.Confirmation__c = appPrdctCpf.Confirmation__c == 'Yes' ? 'true' : appPrdctCpf.Confirmation__c == 'No' ? 'false' : appPrdctCpf.Confirmation__c;
						appPrdctCpf.Should_there_be_a_material_variance__c = appPrdctCpf.Should_there_be_a_material_variance__c == 'Yes' ? 'true' : appPrdctCpf.Should_there_be_a_material_variance__c == 'No' ? 'false' : appPrdctCpf.Should_there_be_a_material_variance__c;
						appPrdctCpf.Deviation_clause__c = appPrdctCpf.Deviation_clause__c == 'Yes' ? 'true' : appPrdctCpf.Deviation_clause__c == 'No' ? 'false' : appPrdctCpf.Deviation_clause__c;
						appPrdctCpf.Period__c = appPrdctCpf.Period__c == 'For each Measurement Period' ? 'FOR EACH MEASUREMENT PERIOD' : appPrdctCpf.Period__c == 'at any time' ? 'AT ANY TIME' : appPrdctCpf.Period__c;
						appPrdctCpf.Body_corporate_insurance__c = appPrdctCpf.Body_corporate_insurance__c == 'Yes' ? 'YES' : appPrdctCpf.Body_corporate_insurance__c == 'No' ? 'NO' : appPrdctCpf.Body_corporate_insurance__c;
						appPrdctCpf.Gap_insurance__c = appPrdctCpf.Gap_insurance__c == 'Yes' ? 'YES' : appPrdctCpf.Gap_insurance__c == 'No' ? 'NO' : appPrdctCpf.Gap_insurance__c;

						string interestratebasis = appPrdctCpf.Interest_rate_basis__c == 'Fixed rate with all in risk margin' ? 'FIXED RATE WITH ALL IN RISK MARGIN' : appPrdctCpf.Interest_rate_basis__c == 'Prime Rate' ? 'PRIME RATE' : appPrdctCpf.Interest_rate_basis__c == 'Fixed rate with net margin' ? 'FIXED RATE WITH NET MARGIN' : appPrdctCpf.Interest_rate_basis__c;
						contextBuilder.add('interestratebasis', interestratebasis);
						switch on appPrdctCpf.Interest_rate_basis__c{
							when 'Fixed rate with all in risk margin'{
								contextBuilder.add('interestratebasisRisk', 'YES');
							}
							when 'Prime Rate'{
								contextBuilder.add('interestratebasisPrime', 'YES');
							}
							when 'Fixed rate with net margin'{
								contextBuilder.add('interestratebasisNet', 'YES');
							}
						}

						if (appPrdctCpf.Final_date_for_drawdown__c == 'month(s) after the Signature Date'){
							//appPrdctCpf.Final_Date_For_DrawdownDate__c = null;
							appPrdctCpf.Final_date_for_drawdown__c = 'MONTH(S) AFTER THE SIGNATURE DATE';
							contextBuilder.add('monthsAfterSignatureDate', 'YES');
							contextBuilder.add('Finaldatefordrawdown', '1 calendar month from fulfilment of all conditions precedent');
						}
						if (appPrdctCpf.Final_date_for_drawdown__c == 'The last date on which the Facility may be first drawn down'){
							//appPrdctCpf.Number_of_periods_after_first_drawdown__c = null;
							appPrdctCpf.Final_date_for_drawdown__c = 'THE LAST DATE ON WHICH THE FACILITY MAY BE FIRST DRAWN DOWN';
							contextBuilder.add('lastdate', 'YES');
							contextBuilder.add('Finaldatefordrawdown', 'Date');
						}

						appPrdctCpf.When__c = appPrdctCpf.When__c == 'registration of the Mortgage Bond' ? 'REGISTRATION OF THE MORTGAGE BOND' : appPrdctCpf.When__c == 'the Signature Date' ? 'THE SIGNATURE DATE' : appPrdctCpf.When__c;
						string instalmentperiods = appPrdctCpf.Instalment_periods__c == 'month(s)' ? 'MONTHS(S)' : appPrdctCpf.Instalment_periods__c == 'days' ? 'DAYS' : appPrdctCpf.Instalment_periods__c == 'years' ? 'YEARS' : appPrdctCpf.Instalment_periods__c;
						contextBuilder.add('instalmentperiods', instalmentperiods);

						if (appPrdctCpf.Proof_of_Pre_sales__c == 'Yes'){
							contextBuilder.add('proofOfPreSalesYes', 'YES');
						}
						if (appPrdctCpf.Proof_of_Pre_sales__c == 'No'){
							contextBuilder.add('proofOfPreSalesNo', 'YES');
						}
						if (appPrdctCpf.Proof_of_Pre_sales__c == 'Per Phase'){
							contextBuilder.add('proofOfPreSalesPerPhase', 'YES');
						}
						appPrdctCpf.Prime_rate_margin__c = appPrdctCpf.Prime_rate_margin__c == 'Plus per annum' ? 'PLUS PER ANNUM' : appPrdctCpf.Prime_rate_margin__c == 'Minus per annum' ? 'MINUS PER ANNUM' : appPrdctCpf.Prime_rate_margin__c == 'No variance' ? 'NO VARIANCE' : appPrdctCpf.Prime_rate_margin__c;

						contextBuilder.add('Application_Product_CPF__c', appPrdctCpf);
						contextBuilder.add('alreadyHeld', alreadyHeld);
						contextBuilder.add('theBankreservesTheRightTo', theBankreservesTheRightTo);

						string fcb = appPrdctCpf.Covenants_applicable_to_the_Borrower__c == 'the Borrower' ? 'YES' : 'NO';
						string fcbSub = appPrdctCpf.Covenants_applicable_to_the_Borrower__c == 'the Borrower and its subsidiaries' ? 'YES' : 'NO';
						if (appPrdctCpf.Covenants_applicable_to_the_Borrower__c == 'the Borrower and its subsidiaries'){
							fcb = 'YES';
						}
						contextBuilder.add('FinancialCovenantsBorrower', fcb);
						contextBuilder.add('FinancialCovenantsBorrowerSub', fcbSub);

						string fcp = appPrdctCpf.Covenants_applicable_to_the_Parent__c == 'the Parent' ? 'YES' : 'NO';
						string fcpSub = appPrdctCpf.Covenants_applicable_to_the_Parent__c == 'the Parent and its subsidiaries' ? 'YES' : 'NO';
						if (appPrdctCpf.Covenants_applicable_to_the_Parent__c == 'the Parent and its subsidiaries'){
							fcp = 'YES';
						}
						contextBuilder.add('FinancialCovenantsParent', fcp);
						contextBuilder.add('FinancialCovenantsParentSub', fcpSub);

						string fcg = appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c == 'the Guarantor(s)' ? 'YES' : 'NO';
						string fcgSub = appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c == 'the Guarantor(s) and its subsidiaries' ? 'YES' : 'NO';
						if (appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c == 'the Guarantor(s) and its subsidiaries'){
							fcg = 'YES';
						}
						contextBuilder.add('FinancialCovenantsGuarantor', fcg);
						contextBuilder.add('FinancialCovenantsGuarantorSub', fcgSub);

						string fcsp = appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c == 'the Security Provider(s)' ? 'YES' : 'NO';
						string fcspSub = appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c == 'the Security Provider(s) and its subsidiaries' ? 'YES' : 'NO';
						if (appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c == 'the Security Provider(s) and its subsidiaries'){
							fcsp = 'YES';
						}
						contextBuilder.add('FinancialCovenantsSP', fcsp);
						contextBuilder.add('FinancialCovenantsSPSub', fcspSub);

						switch on appPrdctCpf.Measurement_period__c{
							when 'each consecutive period'{
								contextBuilder.add('IL_MeasurementPeriodConsecutive', 'YES');
								contextBuilder.add('mp', 'YES');
							}
							when 'each period of six months ending on the last day of each financial half year'{
								contextBuilder.add('IL_MeasurementPeriodHalfYear', 'YES');
								contextBuilder.add('mp', 'YES');
							}
							//when 'each period of twelve months commencing on the anniversary of the first drawdown of the facility'{
							//}
							when 'each period of twelve months ending on the last day of a financial quarter'{
								contextBuilder.add('IL_MeasurementPeriodQuater', 'YES');
								contextBuilder.add('mp', 'YES');
							}
							when 'each period of twelve months ending on the last day of a financial year'{
								contextBuilder.add('IL_MeasurementPeriodYear', 'YES');
								contextBuilder.add('mp', 'YES');
							}
						}

						switch on appPrdctCpf.Loan_To_Value_Covenant__c{
							when 'Ratcheting'{
								contextBuilder.add('LoanToValueCovenantRacheting', 'YES');
								contextBuilder.add('LoanToValueCovenantYESRatcheting', 'YES');
							}
							when 'No Ratcheting'{
								contextBuilder.add('LoanToValueCovenantRacheting', 'NO');
								contextBuilder.add('LoanToValueCovenantNORatcheting', 'YES');
							}
						}

						switch on appPrdctCpf.Debt_service_cover_ratio__c{
							when 'Ratcheting'{
								contextBuilder.add('LoanToValueCovenantDebtRatcheting', 'YES');
							}
							when 'No Ratcheting'{
								contextBuilder.add('LoanToValueCovenantDebtRatcheting', 'NO');
								contextBuilder.add('LoanToValueCovenantDebtNORatcheting', 'YES');
							}
						}

						switch on appPrdctCpf.Interest_Cover_Ratio__c{
							when 'Ratcheting'{
								contextBuilder.add('InterestServiceCoverRationRatcheting', 'YES');
							}
							when 'No Ratcheting'{
								contextBuilder.add('InterestServiceCoverRationRatcheting', 'NO');
							}
						}

						if (appPrdctCpf.Secondary_Account_Applicable__c == 'NO' || appPrdctCpf.Secondary_Account_Applicable__c == 'No'){
							switch on appPrdctCpf.Repayment_options__c{
								when 'Equal Instalment'{
									contextBuilder.add('equalInstalment', 'YES');
								}
								when 'Equal instalment (Bullet)'{
									contextBuilder.add('equalInstalmentBullet', 'YES');
								}
								when 'Interest only (Bullet)'{
									contextBuilder.add('interestOnlyBullet', 'YES');
								}
								when 'Capitalised interest (Bullet)'{
									contextBuilder.add('capitalisedInterestBullet', 'YES');
								}
								when 'Interest only period with equal instalment period thereafter (Amortising)'{
									contextBuilder.add('interestOnlyEqualInstalmentAmortising', 'YES');
								}
								when 'Interest only period with equal instalment period thereafter (Bullet)'{
									contextBuilder.add('interestOnlyEqualInstalmentBullet', 'YES');
								}
								when 'Interest only period with stepped instalment period thereafter (Amortising)'{
									contextBuilder.add('interestOnlySteppedInstalmentAmortising', 'YES');
								}
								when 'Interest only period with stepped instalment period thereafter (Bullet)'{
									contextBuilder.add('interestOnlySteppedInstalmentBullet', 'YES');
								}
								when 'Interest only period with stepped capital period thereafter (Amortising)'{
									contextBuilder.add('interestOnlySteppedCapitalAmortising', 'YES');
								}
								when 'Interest only period with stepped capital period thereafter (Bullet)'{
									contextBuilder.add('interestOnlySteppedCapitalBullet', 'YES');
								}
								when 'Stepped capital (Amortising)'{
									contextBuilder.add('steppedCapitalAmortising', 'YES');
								}
								when 'Stepped capital (Bullet)'{
									contextBuilder.add('steppedCapitalBullet', 'YES');
								}
								when 'Stepped instalment (Amortising)'{
									contextBuilder.add('steppedInstalmentAmortising', 'YES');
								}
								when 'Stepped instalment (Bullet)'{
									contextBuilder.add('steppedInstalmentBullet', 'YES');
								}
							}
						}

						LIST<Application_Security_CPF__c> existingSecurities = new ApplicationSecurityCPFSelector().selectByAppPrdctwithClass(appPrdctCpf.Id, 'Existing');
						if (!existingSecurities.isEmpty() && existingSecurities.size() > 0 && existingSecurities != null){
							contextBuilder.add('existingSecurities', 'YES');
							string suretyExists = 'NO';
							LIST<Application_Security_CPF__c> existingSecuritiesLimitedtGuarantee = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecuritiesUnlimitedSuretyship = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecuritiesLimitedSuretyship = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecuritiesUnlimitedGuarantee = new LIST<Application_Security_CPF__c>();
							for (Application_Security_CPF__c asCPF : existingSecurities){
								asCPF.To_be_released__c = asCPF.To_be_released__c == 'Yes' ? 'YES' : asCPF.To_be_released__c == 'No' ? 'NO' : asCPF.To_be_released__c;
								asCPF.Include_address__c = asCPF.Include_address__c == 'Yes' ? 'YES' : asCPF.Include_address__c == 'No' ? 'NO' : asCPF.Include_address__c;

								switch on asCPF.Category__c{
									when 'Limited Guarantee'{
										existingSecuritiesLimitedtGuarantee.add(asCPF);
									}
									when 'UnLimited Suretyship'{
										existingSecuritiesUnlimitedSuretyship.add(asCPF);
									}
									when 'Limited Suretyship'{
										existingSecuritiesLimitedSuretyship.add(asCPF);
									}
									when 'Unlimited Guarantee'{
										existingSecuritiesUnlimitedGuarantee.add(asCPF);
									}
								}
							}
							if (!existingSecuritiesLimitedtGuarantee.isEmpty() && existingSecuritiesLimitedtGuarantee.size() > 0 && existingSecuritiesLimitedtGuarantee != null){
								contextBuilder.add('existingSecuritiesLimitedtGuarantee', existingSecuritiesLimitedtGuarantee);
								//contextBuilder.add('existingSecuritiesLimitedtGuaranteeYES', 'YES');
							}
							if (!existingSecuritiesUnlimitedSuretyship.isEmpty() && existingSecuritiesUnlimitedSuretyship.size() > 0 && existingSecuritiesUnlimitedSuretyship != null){
								contextBuilder.add('existingSecuritiesUnlimitedSuretyship', existingSecuritiesUnlimitedSuretyship);
								suretyExists = 'YES';
								//contextBuilder.add('UnlimitedSuretyExisting', 'YES');
							}
							if (!existingSecuritiesLimitedSuretyship.isEmpty() && existingSecuritiesLimitedSuretyship.size() > 0 && existingSecuritiesLimitedSuretyship != null){
								contextBuilder.add('existingSecuritiesLimitedSuretyship', existingSecuritiesLimitedSuretyship);
								suretyExists = 'YES';
								//contextBuilder.add('LimitedSuretyExisting', 'YES');
							}
							if (!existingSecuritiesUnlimitedGuarantee.isEmpty() && existingSecuritiesUnlimitedGuarantee.size() > 0 && existingSecuritiesUnlimitedGuarantee != null){
								contextBuilder.add('existingSecuritiesUnlimitedGuarantee', existingSecuritiesUnlimitedGuarantee);
								//contextBuilder.add('existingSecuritiesUnlimitedGuaranteeYES', 'YES');
							}
							contextBuilder.add('suretyExists', suretyExists);
						} else{
							contextBuilder.add('existingSecurities', 'NO');
						}

						LIST<Application_Security_CPF__c> newSecurities = new ApplicationSecurityCPFSelector().selectByAppPrdctwithClass(appPrdctCpf.Id, 'New');
						if (!newSecurities.isEmpty() && newSecurities.size() > 0 && newSecurities != null){
							contextBuilder.add('newSecurities', 'YES');
							LIST<Application_Security_CPF__c> newSecuritiesLimitedSuretyship = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> newSecuritiesLimitedtGuarantee = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> newSecuritiesUnlimitedGuarantee = new LIST<Application_Security_CPF__c>();
							for (Application_Security_CPF__c asCPF : newSecurities){
								asCPF.To_be_released__c = asCPF.To_be_released__c == 'Yes' ? 'YES' : asCPF.To_be_released__c == 'No' ? 'NO' : asCPF.To_be_released__c;
								asCPF.Include_address__c = asCPF.Include_address__c == 'Yes' ? 'YES' : asCPF.Include_address__c == 'No' ? 'NO' : asCPF.Include_address__c;
								switch on asCPF.Category__c{
									when 'Limited Guarantee'{
										newSecuritiesLimitedtGuarantee.add(asCPF);
									}
									when 'Limited Suretyship'{
										newSecuritiesLimitedSuretyship.add(asCPF);
									}
									when 'Unlimited Guarantee'{
										newSecuritiesUnlimitedGuarantee.add(asCPF);
									}
								}
							}
							if (!newSecuritiesLimitedSuretyship.isEmpty() && newSecuritiesLimitedSuretyship.size() > 0 && newSecuritiesLimitedSuretyship != null){
								contextBuilder.add('newSecuritiesLimitedSuretyship', newSecuritiesLimitedSuretyship);
								//contextBuilder.add('newSecuritiesLimitedSuretyshipYES', 'YES');
							}
						} else{
							contextBuilder.add('newSecurities', 'NO');
						}

						LIST<Application_Security_CPF__c> newMortgageBonds = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'New Mortgage Bond', 'New');
						if (!newMortgageBonds.isEmpty() && newMortgageBonds.size() > 0 && newMortgageBonds != null){
							contextBuilder.add('newMortgageBondsList', newMortgageBonds);
							contextBuilder.add('newMortgageBonds', 'YES');
						}
						LIST<Application_Security_CPF__c> existingMortgageBonds = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Existing Mortgage Bond', 'Existing');
						if (!existingMortgageBonds.isEmpty() && existingMortgageBonds.size() > 0 && existingMortgageBonds != null){
							contextBuilder.add('existingMortgageBondsList', existingMortgageBonds);
							contextBuilder.add('existingMortgageBonds', 'YES');
						} else{
							contextBuilder.add('existingMortgageBonds', 'NO');
						}

						contextBuilder.add('newMortgageBondsAddtional', 'NO');
						for (Application_Security_CPF__c appSec : newMortgageBonds){
							if (appSec.Mortgage_bond_type__c == 'Additional bonds'){
								contextBuilder.add('newMortgageBondsAddtional', 'YES');
							}
						}
						contextBuilder.add('existingMortgageBondsAddtional', 'NO');
						for (Application_Security_CPF__c appSec : existingMortgageBonds){
							if (appSec.Mortgage_bond_type__c == 'Additional bonds'){
								contextBuilder.add('existingMortgageBondsAddtional', 'YES');
							}
						}

						contextBuilder.add('existingMortgageBondsThirdParty', 'NO');
						for (Application_Security_CPF__c appSec : existingMortgageBonds){
							if (appSec.Mortgage_bond_type__c == 'Registration of mortgage bond by third party'){
								contextBuilder.add('existingMortgageBondsThirdParty', 'YES');
							}
						}

						LIST<Application_Security_CPF__c> limitedGuarateesNew = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Limited Guarantee', 'New');
						if (!limitedGuarateesNew.isEmpty() && limitedGuarateesNew.size() > 0 && limitedGuarateesNew != null){
							for (Application_Security_CPF__c asCPF : limitedGuarateesNew){
								asCPF.To_be_released__c = asCPF.To_be_released__c == 'Yes' ? 'YES' : asCPF.To_be_released__c == 'No' ? 'NO' : asCPF.To_be_released__c;
								asCPF.Include_address__c = asCPF.Include_address__c == 'Yes' ? 'YES' : asCPF.Include_address__c == 'No' ? 'NO' : asCPF.Include_address__c;
							}
							contextBuilder.add('LimitedGuaranteesNew', limitedGuarateesNew);
							//contextBuilder.add('newLimitedGuarantees', 'YES');
						}

						LIST<Application_Security_CPF__c> limitedGuarateesExisting = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Limited Guarantee', 'Existing');
						if (!limitedGuarateesExisting.isEmpty() && limitedGuarateesExisting.size() > 0 && limitedGuarateesExisting != null){
							for (Application_Security_CPF__c asCPF : limitedGuarateesExisting){
								asCPF.To_be_released__c = asCPF.To_be_released__c == 'Yes' ? 'YES' : asCPF.To_be_released__c == 'No' ? 'NO' : asCPF.To_be_released__c;
								asCPF.Include_address__c = asCPF.Include_address__c == 'Yes' ? 'YES' : asCPF.Include_address__c == 'No' ? 'NO' : asCPF.Include_address__c;
							}
							contextBuilder.add('limitedGuarateesExisting', limitedGuarateesExisting);
						}

						LIST<Application_Security_CPF__c> unlimitedGuarateesNew = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Unlimited Guarantee', 'New');
						if (!unlimitedGuarateesNew.isEmpty() && unlimitedGuarateesNew.size() > 0 && unlimitedGuarateesNew != null){
							for (Application_Security_CPF__c asCPF : unlimitedGuarateesNew){
								asCPF.To_be_released__c = asCPF.To_be_released__c == 'Yes' ? 'YES' : asCPF.To_be_released__c == 'No' ? 'NO' : asCPF.To_be_released__c;
							}
							contextBuilder.add('UnlimitedGuaranteesNew', unlimitedGuarateesNew);
							//contextBuilder.add('newUnLimitedGuarantees', 'YES');
						}

						LIST<Application_Security_CPF__c> unlimitedGuarateesExisting = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Unlimited Guarantee', 'Existing');
						if (!unlimitedGuarateesExisting.isEmpty() && unlimitedGuarateesExisting.size() > 0 && unlimitedGuarateesExisting != null){
							for (Application_Security_CPF__c asCPF : unlimitedGuarateesExisting){
								asCPF.To_be_released__c = asCPF.To_be_released__c == 'Yes' ? 'YES' : asCPF.To_be_released__c == 'No' ? 'NO' : asCPF.To_be_released__c;
							}
							contextBuilder.add('unlimitedGuarateesExisting', unlimitedGuarateesExisting);
						}

						LIST<Application_Security_CPF__c> securityCessionNew = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Security Cession', 'New');
						if (!securityCessionNew.isEmpty() && securityCessionNew.size() > 0 && securityCessionNew != null){
							//contextBuilder.add('securityCessionNew', securityCessionNew);
							contextBuilder.add('securityCessionNewYES', 'YES');
							LIST<Application_Security_CPF__c> newSecurityCessionOtherCedant = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> newSecurityCessionOther = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> newSecurityCessionPledges = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> newSecurityCessionSM = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> newSecurityCessionBorrower = new LIST<Application_Security_CPF__c>();
							for (Application_Security_CPF__c asCPF : securityCessionNew){
								asCPF.Lease_and_rentals_of_property__c = asCPF.Lease_and_rentals_of_property__c == 'Yes' ? 'YES' : asCPF.Lease_and_rentals_of_property__c == 'No' ? 'NO' : asCPF.Lease_and_rentals_of_property__c;
								asCPF.Proceeds_in_respect_of_sale_or_transfer__c = asCPF.Proceeds_in_respect_of_sale_or_transfer__c == 'Yes' ? 'YES' : asCPF.Proceeds_in_respect_of_sale_or_transfer__c == 'No' ? 'NO' : asCPF.Proceeds_in_respect_of_sale_or_transfer__c;
								asCPF.Revenues_in_respect_of_property__c = asCPF.Revenues_in_respect_of_property__c == 'Yes' ? 'YES' : asCPF.Revenues_in_respect_of_property__c == 'No' ? 'NO' : asCPF.Revenues_in_respect_of_property__c;
								asCPF.Claims_in_respect_of_insurance__c = asCPF.Claims_in_respect_of_insurance__c == 'Yes' ? 'YES' : asCPF.Claims_in_respect_of_insurance__c == 'No' ? 'NO' : asCPF.Claims_in_respect_of_insurance__c;
								asCPF.Book_debts_and_other_debt_claims__c = asCPF.Book_debts_and_other_debt_claims__c == 'Yes' ? 'YES' : asCPF.Book_debts_and_other_debt_claims__c == 'No' ? 'NO' : asCPF.Book_debts_and_other_debt_claims__c;
								asCPF.VAT_reimbursement_and_payments__c = asCPF.VAT_reimbursement_and_payments__c == 'Yes' ? 'YES' : asCPF.VAT_reimbursement_and_payments__c == 'No' ? 'NO' : asCPF.VAT_reimbursement_and_payments__c;
								asCPF.Investments_and_or_other_deposits__c = asCPF.Investments_and_or_other_deposits__c == 'Yes' ? 'YES' : asCPF.Investments_and_or_other_deposits__c == 'No' ? 'NO' : asCPF.Investments_and_or_other_deposits__c;
								switch on asCPF.Type__c{
									when 'Other cedent cession'{
										newSecurityCessionOtherCedant.add(asCPF);
									}
									when 'Other cession'{
										newSecurityCessionOther.add(asCPF);
									}
									when 'Pledges and cession'{
										newSecurityCessionPledges.add(asCPF);
									}
									when 'Shareholders / members cessions'{
										newSecurityCessionSM.add(asCPF);
									}
									when 'Borrower cession'{
										newSecurityCessionBorrower.add(asCPF);
									}
								}
							}
							if (!newSecurityCessionOtherCedant.isEmpty() && newSecurityCessionOtherCedant.size() > 0 && newSecurityCessionOtherCedant != null){
								contextBuilder.add('newSecurityCessionOtherCedant', newSecurityCessionOtherCedant);
								//contextBuilder.add('newSecurityCessionOtherCedantYES', 'YES');
							}
							if (!newSecurityCessionOther.isEmpty() && newSecurityCessionOther.size() > 0 && newSecurityCessionOther != null){
								contextBuilder.add('newSecurityCessionOther', newSecurityCessionOther);
								contextBuilder.add('newSecurityCessionOtherYES', 'YES');
							}
							if (!newSecurityCessionPledges.isEmpty() && newSecurityCessionPledges.size() > 0 && newSecurityCessionPledges != null){
								contextBuilder.add('newSecurityCessionPledges', newSecurityCessionPledges);
								//contextBuilder.add('newSecurityCessionPledgesYES', 'YES');
							}
							if (!newSecurityCessionSM.isEmpty() && newSecurityCessionSM.size() > 0 && newSecurityCessionSM != null){
								contextBuilder.add('newSecurityCessionSM', newSecurityCessionSM);
							}
							if (!newSecurityCessionBorrower.isEmpty() && newSecurityCessionBorrower.size() > 0 && newSecurityCessionBorrower != null){
								contextBuilder.add('newSecurityCessionBorrower', newSecurityCessionBorrower);
								//contextBuilder.add('newSecurityCessionBorrowerYES', 'YES');
							}
						}

						LIST<Application_Security_CPF__c> otherSecurityDocsNew = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Other', 'New');
						if (!otherSecurityDocsNew.isEmpty() && otherSecurityDocsNew.size() > 0 && otherSecurityDocsNew != null){
							contextBuilder.add('otherSecurityDocsNewYES', 'YES');
							LIST<Application_Security_CPF__c> otherSecsNew = new LIST<Application_Security_CPF__c>();
							for (Application_Security_CPF__c asCPF : otherSecurityDocsNew){
								switch on asCPF.Type__c{
									when 'Other security'{
										otherSecsNew.add(asCPF);
									}
								}
							}
							if (!otherSecsNew.isEmpty() && otherSecsNew.size() > 0 && otherSecsNew != null){
								contextBuilder.add('otherSecsNew', otherSecsNew);
								//contextBuilder.add('otherSecsNewYES', 'YES');
							}
						}

						LIST<Application_Security_CPF__c> otherSecurityOtherExisting = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Other', 'Existing');
						if (!otherSecurityOtherExisting.isEmpty() && otherSecurityOtherExisting.size() > 0 && otherSecurityOtherExisting != null){
							//contextBuilder.add('otherSecurityOtherExisting', otherSecurityOtherExisting);
							contextBuilder.add('otherSecurityOtherExistingYES', 'YES');
							LIST<Application_Security_CPF__c> otherSecuritySubordExisting = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> otherSecurityCrossCollateralsExisting = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> otherSecurityCrossDefaultClauseExisting = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> otherSecurityCrossGuaranteeExisting = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> otherSecurityUndertakingExisting = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> otherSecsExisting = new LIST<Application_Security_CPF__c>();
							for (Application_Security_CPF__c asCPF : otherSecurityOtherExisting){
								asCPF.Undertaking_to_inject_cost_overrun_funds__c = asCPF.Undertaking_to_inject_cost_overrun_funds__c == 'Yes' ? 'YES' : asCPF.Undertaking_to_inject_cost_overrun_funds__c == 'No' ? 'NO' : asCPF.Undertaking_to_inject_cost_overrun_funds__c;
								switch on asCPF.Type__c{
									when 'Subordination Agreement of Loan Accounts'{
										otherSecuritySubordExisting.add(asCPF);
									}
									when 'Cross Collateralisation'{
										otherSecurityCrossCollateralsExisting.add(asCPF);
									}
									when 'Cross Default Clause'{
										otherSecurityCrossDefaultClauseExisting.add(asCPF);
									}
									when 'Cross Guarantee'{
										otherSecurityCrossGuaranteeExisting.add(asCPF);
									}
									when 'Undertaking to Inject Cost Overrun Funds'{
										otherSecurityUndertakingExisting.add(asCPF);
									}
									when 'Other security'{
										otherSecsExisting.add(asCPF);
									}
								}
							}
							if (!otherSecuritySubordExisting.isEmpty() && otherSecuritySubordExisting.size() > 0 && otherSecuritySubordExisting != null){
								contextBuilder.add('otherSecuritySubordExisting', otherSecuritySubordExisting);
								switch on otherSecuritySubordExisting.get(0).Claims_By__c{
									when 'Guarantor'{
										contextBuilder.add('otherSecuritySubordExistingClaimsonguarantors', 'YES');
										contextBuilder.add('otherSecuritySubordExistingClaimsonborrower', 'NO');
									}
									when 'Borrower'{
										contextBuilder.add('otherSecuritySubordExistingClaimsonborrower', 'YES');
										contextBuilder.add('otherSecuritySubordExistingClaimsonguarantors', 'NO');
									}
									when 'Borrower and Guarantor'{
										contextBuilder.add('otherSecuritySubordExistingClaimsonguarantors', 'YES');
										contextBuilder.add('otherSecuritySubordExistingClaimsonborrower', 'YES');
									}
								}
							}
							if (!otherSecurityCrossCollateralsExisting.isEmpty() && otherSecurityCrossCollateralsExisting.size() > 0 && otherSecurityCrossCollateralsExisting != null){
								contextBuilder.add('otherSecurityCrossCollateralsExisting', otherSecurityCrossCollateralsExisting);
							}
							if (!otherSecurityCrossDefaultClauseExisting.isEmpty() && otherSecurityCrossDefaultClauseExisting.size() > 0 && otherSecurityCrossDefaultClauseExisting != null){
								contextBuilder.add('otherSecurityCrossDefaultClauseExisting', otherSecurityCrossDefaultClauseExisting);
							}
							if (!otherSecurityCrossGuaranteeExisting.isEmpty() && otherSecurityCrossGuaranteeExisting.size() > 0 && otherSecurityCrossGuaranteeExisting != null){
								contextBuilder.add('otherSecurityCrossGuaranteeExisting', otherSecurityCrossGuaranteeExisting);
							}
							if (!otherSecurityUndertakingExisting.isEmpty() && otherSecurityUndertakingExisting.size() > 0 && otherSecurityUndertakingExisting != null){
								contextBuilder.add('otherSecurityUndertakingExisting', otherSecurityUndertakingExisting);
								//contextBuilder.add('otherSecurityUndertakingExistingYES', 'YES');
							}
							if (!otherSecsExisting.isEmpty() && otherSecsExisting.size() > 0 && otherSecsExisting != null){
								contextBuilder.add('otherSecsExisting', otherSecsExisting);
								//contextBuilder.add('otherSecsExistingYES', 'YES');
							}
						}

						LIST<Application_Security_CPF__c> securityCessionExisting = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id, 'Security Cession Existing', 'Existing');
						if (!securityCessionExisting.isEmpty() && securityCessionExisting.size() > 0 && securityCessionExisting != null){
							//contextBuilder.add('securityCessionExisting', securityCessionExisting);
							contextBuilder.add('securityCessionExistingYES', 'YES');
							LIST<Application_Security_CPF__c> existingSecurityOtherCedantCessionMulti = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecurityOtherCedantCessionSingleDate = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecurityCedantCessionMulti = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecurityCedantCessionSingleDate = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecurityPledgesAndCession = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecurityCessionLoanAcc = new LIST<Application_Security_CPF__c>();
							LIST<Application_Security_CPF__c> existingSecurityCessionOther = new LIST<Application_Security_CPF__c>();
							string existingSecurityOtherCedantCessionDates = 'NO';
							string existingSecurityCedantCessionDatesSingle = 'NO';
							string existingSecurityCedantCessionDatesMulti = 'NO';
							for (Application_Security_CPF__c asCPF : securityCessionExisting){
								asCPF.Lease_and_rentals_of_property__c = asCPF.Lease_and_rentals_of_property__c == 'Yes' ? 'YES' : asCPF.Lease_and_rentals_of_property__c == 'No' ? 'NO' : asCPF.Lease_and_rentals_of_property__c;
								asCPF.Proceeds_in_respect_of_sale_or_transfer__c = asCPF.Proceeds_in_respect_of_sale_or_transfer__c == 'Yes' ? 'YES' : asCPF.Proceeds_in_respect_of_sale_or_transfer__c == 'No' ? 'NO' : asCPF.Proceeds_in_respect_of_sale_or_transfer__c;
								asCPF.Revenues_in_respect_of_property__c = asCPF.Revenues_in_respect_of_property__c == 'Yes' ? 'YES' : asCPF.Revenues_in_respect_of_property__c == 'No' ? 'NO' : asCPF.Revenues_in_respect_of_property__c;
								asCPF.Claims_in_respect_of_insurance__c = asCPF.Claims_in_respect_of_insurance__c == 'Yes' ? 'YES' : asCPF.Claims_in_respect_of_insurance__c == 'No' ? 'NO' : asCPF.Claims_in_respect_of_insurance__c;
								asCPF.Book_debts_and_other_debt_claims__c = asCPF.Book_debts_and_other_debt_claims__c == 'Yes' ? 'YES' : asCPF.Book_debts_and_other_debt_claims__c == 'No' ? 'NO' : asCPF.Book_debts_and_other_debt_claims__c;
								asCPF.VAT_reimbursement_and_payments__c = asCPF.VAT_reimbursement_and_payments__c == 'Yes' ? 'YES' : asCPF.VAT_reimbursement_and_payments__c == 'No' ? 'NO' : asCPF.VAT_reimbursement_and_payments__c;
								asCPF.Investments_and_or_other_deposits__c = asCPF.Investments_and_or_other_deposits__c == 'Yes' ? 'YES' : asCPF.Investments_and_or_other_deposits__c == 'No' ? 'NO' : asCPF.Investments_and_or_other_deposits__c;
								asCPF.Subordination_Agreement_of_Loan_Accounts__c = asCPF.Subordination_Agreement_of_Loan_Accounts__c == 'Yes' ? 'YES' : asCPF.Subordination_Agreement_of_Loan_Accounts__c == 'No' ? 'NO' : asCPF.Subordination_Agreement_of_Loan_Accounts__c;

								switch on asCPF.Type__c{
									when 'Multiple dates other cedent cession'{
										existingSecurityOtherCedantCessionMulti.add(asCPF);
										existingSecurityOtherCedantCessionDates = 'Multiple Cession Date';
									}
									when 'Single date other cedent cession'{
										existingSecurityOtherCedantCessionSingleDate.add(asCPF);
										existingSecurityOtherCedantCessionDates = 'Single Cession Date';
									}
									when 'Single date Borrower cession'{
										asCPF.Type__c = 'Single date Borrower cession';
										existingSecurityCedantCessionSingleDate.add(asCPF);
										existingSecurityCedantCessionDatesSingle = 'SINGLE CESSION DATE';
									}
									when 'Multiple dates Borrower cession'{
										asCPF.Type__c = 'Multiple dates Borrower cession';
										existingSecurityCedantCessionMulti.add(asCPF);
										existingSecurityCedantCessionDatesMulti = 'MULTIPLE CESSION DATE';
									}
									when 'Pledges and cession'{
										asCPF.Type__c = 'Pledges and cession';
										existingSecurityPledgesAndCession.add(asCPF);
									}
									when 'shareholder(s)/member(s) cession'{
										asCPF.Type__c = 'Pledges and cession';
										existingSecurityCessionLoanAcc.add(asCPF);
									}
									when 'Other cession'{
										asCPF.Type__c = 'Other cession';
										existingSecurityCessionOther.add(asCPF);
									}
								}
							}
							contextBuilder.add('ExistingSecurityOtherCedantCessionDates', existingSecurityOtherCedantCessionDates);
							contextBuilder.add('ExistingSecurityCedantCessionDatesSingle', existingSecurityCedantCessionDatesSingle);
							contextBuilder.add('ExistingSecurityCedantCessionDatesMulti', existingSecurityCedantCessionDatesMulti);
							if (!existingSecurityCedantCessionSingleDate.isEmpty() && existingSecurityCedantCessionSingleDate.size() > 0 && existingSecurityCedantCessionSingleDate != null){
								contextBuilder.add('existingSecurityCedantCessionSingleDate', existingSecurityCedantCessionSingleDate);
							}
							if (!existingSecurityCedantCessionMulti.isEmpty() && existingSecurityCedantCessionMulti.size() > 0 && existingSecurityCedantCessionMulti != null){
								contextBuilder.add('existingSecurityCedantCessionMulti', existingSecurityCedantCessionMulti);
								//contextBuilder.add('existingSecurityCedantCessionMultiYES', 'YES');
							}
							if (!existingSecurityOtherCedantCessionMulti.isEmpty() && existingSecurityOtherCedantCessionMulti.size() > 0 && existingSecurityOtherCedantCessionMulti != null){
								contextBuilder.add('existingSecurityOtherCedantCessionMulti', existingSecurityOtherCedantCessionMulti);
							}
							if (!existingSecurityOtherCedantCessionSingleDate.isEmpty() && existingSecurityOtherCedantCessionSingleDate.size() > 0 && existingSecurityOtherCedantCessionSingleDate != null){
								contextBuilder.add('existingSecurityOtherCedantCessionSingleDate', existingSecurityOtherCedantCessionSingleDate);
								//contextBuilder.add('existingSecurityOtherCedantCessionSingleDateYES', 'YES');
							}
							if (!existingSecurityPledgesAndCession.isEmpty() && existingSecurityPledgesAndCession.size() > 0 && existingSecurityPledgesAndCession != null){
								contextBuilder.add('existingSecurityPledgesAndCession', existingSecurityPledgesAndCession);
								//contextBuilder.add('existingSecurityPledgesAndCessionYES', 'YES');
							}
							if (!existingSecurityCessionLoanAcc.isEmpty() && existingSecurityCessionLoanAcc.size() > 0 && existingSecurityCessionLoanAcc != null){
								contextBuilder.add('existingSecurityCessionLoanAcc', existingSecurityCessionLoanAcc);
							}
							if (!existingSecurityCessionOther.isEmpty() && existingSecurityCessionOther.size() > 0 && existingSecurityCessionOther != null){
								contextBuilder.add('existingSecurityCessionOther', existingSecurityCessionOther);
								//contextBuilder.add('existingSecurityCessionOtherYES', existingSecurityCessionOther);
							}
						}

						LIST<Application_Security_CPF__c> newSecurityMortgageBondBorrowers = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'New Mortgage Bond', 'Registration of mortgage bond by borrower', 'New');
						if (!newSecurityMortgageBondBorrowers.isEmpty() && newSecurityMortgageBondBorrowers.size() > 0 && newSecurityMortgageBondBorrowers != null){
							contextBuilder.add('newSecurityMortgageBondBorrowers', newSecurityMortgageBondBorrowers);
							//contextBuilder.add('newSecurityMortgageBondBorrowersYES', 'YES');
						}
						LIST<Application_Security_CPF__c> newSecurityMortgageBondThirdParty = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'New Mortgage Bond', 'Registration of mortgage bond by third party', 'New');
						if (!newSecurityMortgageBondThirdParty.isEmpty() && newSecurityMortgageBondThirdParty.size() > 0 && newSecurityMortgageBondThirdParty != null){
							contextBuilder.add('newSecurityMortgageBondThirdParty', newSecurityMortgageBondThirdParty);
							//contextBuilder.add('newSecurityMortgageBondThirdPartyYES', 'YES');
						}
						LIST<Application_Security_CPF__c> newSecurityMortgageBondNotarialLease = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'New Mortgage Bond', 'Registration over notarial lease', 'New');
						if (!newSecurityMortgageBondNotarialLease.isEmpty() && newSecurityMortgageBondNotarialLease.size() > 0 && newSecurityMortgageBondNotarialLease != null){
							contextBuilder.add('newSecurityMortgageBondNotarialLease', newSecurityMortgageBondNotarialLease);
							//contextBuilder.add('newSecurityMortgageBondNotarialLeaseYES', 'YES');
						}
						LIST<Application_Security_CPF__c> newSecurityMortgageBondAdditional = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'New Mortgage Bond', 'Additional bond', 'New');
						if (!newSecurityMortgageBondAdditional.isEmpty() && newSecurityMortgageBondAdditional.size() > 0 && newSecurityMortgageBondAdditional != null){
							contextBuilder.add('newSecurityMortgageBondAdditional', newSecurityMortgageBondAdditional);
							//contextBuilder.add('newSecurityMortgageBondAdditionalYES', 'YES');
						}
						LIST<Application_Security_CPF__c> existingSecurityMortgageBondBorrowers = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'Existing Mortgage Bond', 'Registration of mortgage bond by borrower', 'Existing');
						if (!existingSecurityMortgageBondBorrowers.isEmpty() && existingSecurityMortgageBondBorrowers.size() > 0 && existingSecurityMortgageBondBorrowers != null){
							contextBuilder.add('existingSecurityMortgageBondBorrowers', existingSecurityMortgageBondBorrowers);
						}
						LIST<Application_Security_CPF__c> existingSecurityMortgageBondThirdParty = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'Existing Mortgage Bond', 'Registration of mortgage bond by third party', 'Existing');
						if (!existingSecurityMortgageBondThirdParty.isEmpty() && existingSecurityMortgageBondThirdParty.size() > 0 && existingSecurityMortgageBondThirdParty != null){
							contextBuilder.add('existingSecurityMortgageBondThirdParty', existingSecurityMortgageBondThirdParty);
						}
						LIST<Application_Security_CPF__c> existingSecurityMortgageBondOverNotarialLease = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'Existing Mortgage Bond', 'Registration over notarial lease', 'Existing');
						if (!existingSecurityMortgageBondOverNotarialLease.isEmpty() && existingSecurityMortgageBondOverNotarialLease.size() > 0 && existingSecurityMortgageBondOverNotarialLease != null){
							contextBuilder.add('existingSecurityMortgageBondOverNotarialLease', existingSecurityMortgageBondOverNotarialLease);
						}
						LIST<Application_Security_CPF__c> existingSecurityMortgageBondAdditional = new ApplicationSecurityCPFSelector().selectByAppPrdctMortgageBondType(appPrdctCpf.Id, 'Existing Mortgage Bond', 'Additional bond', 'Existing');
						if (!existingSecurityMortgageBondAdditional.isEmpty() && existingSecurityMortgageBondAdditional.size() > 0 && existingSecurityMortgageBondAdditional != null){
							contextBuilder.add('existingSecurityMortgageBondAdditional', existingSecurityMortgageBondAdditional);
						}

						List<Application_Security_CPF__c> newSubAgreeLoanAcc = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other', 'Subordination Agreement of Loan Accounts', 'New');
						if (!newSubAgreeLoanAcc.isEmpty() && newSubAgreeLoanAcc.size() > 0 && newSubAgreeLoanAcc != null){
							contextBuilder.add('newSubAgreeLoanAcc', newSubAgreeLoanAcc);
							//contextBuilder.add('newSubAgreeLoanAccYES', 'YES');
							switch on newSubAgreeLoanAcc.get(0).Claims_By__c{
								when 'member(s) of the Borrower'{
									contextBuilder.add('NewSecuritySubordinationBorrower', 'YES');
									contextBuilder.add('NewSecuritySubordinationGuarantor', 'NO');
								}
								when 'Borrower'{
									contextBuilder.add('NewSecuritySubordinationBorrower', 'YES');
									contextBuilder.add('NewSecuritySubordinationGuarantor', 'NO');
								}
								when 'Borrower and Guarantor'{
									contextBuilder.add('NewSecuritySubordinationBorrower', 'YES');
									contextBuilder.add('NewSecuritySubordinationGuarantor', 'YES');
								}
								when 'member(s) of the Guarantor(s)'{
									contextBuilder.add('NewSecuritySubordinationBorrower', 'NO');
									contextBuilder.add('NewSecuritySubordinationGuarantor', 'YES');
								}
								when 'Guarantor'{
									contextBuilder.add('NewSecuritySubordinationBorrower', 'NO');
									contextBuilder.add('NewSecuritySubordinationGuarantor', 'YES');
								}
								when else{
									contextBuilder.add('NewSecuritySubordinationBorrower', 'NO');
									contextBuilder.add('NewSecuritySubordinationGuarantor', 'NO');
								}
							}
						}

						List<Application_Security_CPF__c> newUndertakeInjectCostOverRun = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other', 'Undertaking to inject cost overrun funds', 'New');
						if (!newUndertakeInjectCostOverRun.isEmpty() && newUndertakeInjectCostOverRun.size() > 0 && newUndertakeInjectCostOverRun != null){
							newUndertakeInjectCostOverRun.get(0).Undertaking_to_inject_cost_overrun_funds__c = newUndertakeInjectCostOverRun.get(0).Undertaking_to_inject_cost_overrun_funds__c == 'Yes' ? 'YES' : newUndertakeInjectCostOverRun.get(0).Undertaking_to_inject_cost_overrun_funds__c == 'No' ? 'NO' : newUndertakeInjectCostOverRun.get(0).Undertaking_to_inject_cost_overrun_funds__c;
							contextBuilder.add('newUndertakeInjectCostOverRun', newUndertakeInjectCostOverRun.get(0));
						}

						List<Application_Security_CPF__c> newCrossdefaultClause = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other', 'Cross Default Clause', 'New');
						if (!newCrossdefaultClause.isEmpty() && newCrossdefaultClause.size() > 0 && newCrossdefaultClause != null){
							contextBuilder.add('newCrossdefaultClause', newCrossdefaultClause);
							//contextBuilder.add('newCrossdefaultClauseYES', 'YES');
						}
						List<Application_Security_CPF__c> newCrossGuarantee = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other', 'Cross Guarantee', 'New');
						List<Application_Security_CPF__c> newLimitedCrossGuarantee = new List<Application_Security_CPF__c>();
						List<Application_Security_CPF__c> newUnlimitedCrossGuarantee = new List<Application_Security_CPF__c>();
						if (!newCrossGuarantee.isEmpty() && newCrossGuarantee.size() > 0 && newCrossGuarantee != null){
							for (Application_Security_CPF__c ascpf : newCrossGuarantee){
								ascpf.To_be_released__c = ascpf.To_be_released__c == 'Yes' ? 'YES' : ascpf.To_be_released__c == 'No' ? 'NO' : ascpf.To_be_released__c;
								switch on ascpf.Cross_guarantee__c{
									when 'Limited'{
										newLimitedCrossGuarantee.add(ascpf);
									}
									when 'Unlimited'{
										newUnlimitedCrossGuarantee.add(ascpf);
									}
									when 'Not applicable'{
										contextBuilder.add('newNACrossGuarantee', 'YES');
									}
								}
							}
							if (!newCrossGuarantee.isEmpty() && newCrossGuarantee.size() > 0 && newCrossGuarantee != null){
								contextBuilder.add('newCrossGuarantee', newCrossGuarantee);
							}
							if (!newLimitedCrossGuarantee.isEmpty() && newLimitedCrossGuarantee.size() > 0 && newLimitedCrossGuarantee != null){
								contextBuilder.add('newLimitedCrossGuarantee', newLimitedCrossGuarantee);
								//contextBuilder.add('newLimitedCrossGuaranteeYES', 'YES');
							}
							if (!newUnlimitedCrossGuarantee.isEmpty() && newUnlimitedCrossGuarantee.size() > 0 && newUnlimitedCrossGuarantee != null){
								contextBuilder.add('newUnlimitedCrossGuarantee', newUnlimitedCrossGuarantee);
							}
						}

						List<Application_Security_CPF__c> newCrossCollateralisation = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id, 'Other', 'Cross Collateralisation', 'New');
						if (!newCrossCollateralisation.isEmpty() && newCrossCollateralisation.size() > 0 && newCrossCollateralisation != null){
							contextBuilder.add('newCrossCollateralisation', newCrossCollateralisation);
							//contextBuilder.add('newCrossCollateralisationYES', 'YES');
						}
						if (!oppLineItemList.isEmpty() && oppLineItemList.size() > 0 && oppLineItemList != null){
							if (oppLineItemList.get(0).Product2.Name == 'CPF Below R5 Million'){
								contextBuilder.add('MBBLStatus', 'YES');
							} else{
								contextBuilder.add('MBBLStatus', 'NO');
							}
						}

						if (appPrdctCpf.Security_Provider_Consent__c == 'YES' || newUndertakeInjectCostOverRun.size() > 0 || newCrossdefaultClause.size() > 0 || newCrossGuarantee.size() > 0 || newCrossCollateralisation.size() > 0){
							contextBuilder.add('newSecurityOtherYN', 'YES');
						} else{
							contextBuilder.add('newSecurityOtherYN', 'YES');
						}
						if (appPrdctCpf.Notarially_Tied_Consolidation__c == 'Notarially Tied' || appPrdctCpf.Notarially_Tied_Consolidation__c == 'Consolidated'){
							contextBuilder.add('notariallyApplicable', 'YES');
						}

						List<Application_Contract_Clause__c> covenants = new ApplicationContractClauseCPFSelector().selectByAppPrdctIdAndType(appPrdctCpf.Id, 'CPF Application');
						if (!covenants.isEmpty() && covenants.size() > 0 && covenants != null){
							//contextBuilder.add('covenants', covenants);
							List<Application_Contract_Clause__c> otherTransactionalCovenants = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> otherCorporateCovenants = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> loanToValueCovenants = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> debtServiceCoverRatioCovenants = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> interestServiceCoverRatioCovenants = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> otherEntityCovenants = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> furtherConditions = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> furtherConditionsPrecedent = new List<Application_Contract_Clause__c>();
							List<Application_Contract_Clause__c> appContractClause = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> specialConditions = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> otherPreLodgementConditions = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> otherFinalDrawdownConditions = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> otherDrawdownConditions = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> otherEntities = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> otherPreDisbursementConditions = new List<Application_Contract_Clause__c>();
							LIST<Application_Contract_Clause__c> otherConversionConditions = new List<Application_Contract_Clause__c>();
							for (Application_Contract_Clause__c acc : covenants){
								switch on acc.Type__c{
									when 'Other Transactional Covenants'{
										otherTransactionalCovenants.add(acc);
									}
									when 'Loan and Value Covenants'{
										loanToValueCovenants.add(acc);
									}
									when 'Debit Service Cover Ratio'{
										debtServiceCoverRatioCovenants.add(acc);
									}
									when 'Interest Service Cover Ratio'{
										interestServiceCoverRatioCovenants.add(acc);
									}
									when 'Other Entity'{
										otherEntityCovenants.add(acc);
									}
									when 'Further Condition Precedent'{
										furtherConditions.add(acc);
										furtherConditionsPrecedent.add(acc);
									}
									when 'Special Condition'{
										specialConditions.add(acc);
									}
									when 'Lease'{
										appContractClause.add(acc);
									}
									when 'Other Corporate Covenants'{
										otherCorporateCovenants.add(acc);
									}
									when 'Other Pre-Lodgement Conditions'{
										otherPreLodgementConditions.add(acc);
									}
									when 'Other Final Drawdown Conditions'{
										otherFinalDrawdownConditions.add(acc);
									}
									when 'Other Drawdown conditions'{
										otherDrawdownConditions.add(acc);
									}
									when 'other entities'{
										otherEntities.add(acc);
									}
									when 'Other Pre-Disbursement Conditions'{
										otherPreDisbursementConditions.add(acc);
									}
									when 'Conversion'{
										otherConversionConditions.add(acc);
									}
								}
							}
							if (!otherTransactionalCovenants.isEmpty() && otherTransactionalCovenants.size() > 0 && otherTransactionalCovenants != null){
								contextBuilder.add('otherTransactionalCovenants', otherTransactionalCovenants);
							}
							if (!otherCorporateCovenants.isEmpty() && otherCorporateCovenants.size() > 0 && otherCorporateCovenants != null){
								contextBuilder.add('otherCorporateCovenants', otherCorporateCovenants);
							}
							if (!loanToValueCovenants.isEmpty() && loanToValueCovenants.size() > 0 && loanToValueCovenants != null){
								contextBuilder.add('loanToValueCovenants', loanToValueCovenants);
							}
							if (!debtServiceCoverRatioCovenants.isEmpty() && debtServiceCoverRatioCovenants.size() > 0 && debtServiceCoverRatioCovenants != null){
								contextBuilder.add('debtServiceCoverRatioCovenants', debtServiceCoverRatioCovenants);
							}
							if (!interestServiceCoverRatioCovenants.isEmpty() && interestServiceCoverRatioCovenants.size() > 0 && interestServiceCoverRatioCovenants != null){
								contextBuilder.add('interestServiceCoverRatioCovenants', interestServiceCoverRatioCovenants);
							}
							if (!otherEntityCovenants.isEmpty() && otherEntityCovenants.size() > 0 && otherEntityCovenants != null){
								contextBuilder.add('otherEntityCovenants', otherEntityCovenants);
							}
							if (!furtherConditions.isEmpty() && furtherConditions.size() > 0 && furtherConditions != null){
								contextBuilder.add('furtherConditions', furtherConditions);
							}
							if (!otherPreLodgementConditions.isEmpty() && otherPreLodgementConditions.size() > 0 && otherPreLodgementConditions != null){
								contextBuilder.add('otherPreLodgementConditions', otherPreLodgementConditions);
							}
							if (!otherFinalDrawdownConditions.isEmpty() && otherFinalDrawdownConditions.size() > 0 && otherFinalDrawdownConditions != null){
								contextBuilder.add('otherFinalDrawdownConditions', otherFinalDrawdownConditions);
							}
							if (!otherDrawdownConditions.isEmpty() && otherDrawdownConditions.size() > 0 && otherDrawdownConditions != null){
								contextBuilder.add('otherDrawdownConditions', otherDrawdownConditions);
							}
							if (!otherEntities.isEmpty() && otherEntities.size() > 0 && otherEntities != null){
								contextBuilder.add('otherEntities', otherEntities);
							}
							if (!otherPreDisbursementConditions.isEmpty() && otherPreDisbursementConditions.size() > 0 && otherPreDisbursementConditions != null){
								contextBuilder.add('otherPreDisbursementConditions', otherPreDisbursementConditions);
							}
							if (!otherConversionConditions.isEmpty() && otherConversionConditions.size() > 0 && otherConversionConditions != null){
								contextBuilder.add('otherConversionConditions', otherConversionConditions);
								contextBuilder.add('otherConversionConditionsYES', 'YES');
							}
							if (!furtherConditionsPrecedent.isEmpty() && furtherConditionsPrecedent.size() > 0 && furtherConditionsPrecedent != null){
								contextBuilder.add('furtherConditionsPrecedentDetails', furtherConditionsPrecedent);
							}
							if (!specialConditions.isEmpty() && specialConditions.size() > 0 && specialConditions != null){
								contextBuilder.add('specialConditionsDetails', specialConditions);
								contextBuilder.add('specialConditionYESNO', 'YES');
							}
							if (!appContractClause.isEmpty() && appContractClause.size() > 0 && appContractClause != null){
								contextBuilder.add('appContractClauseDetails', appContractClause);
							}
						}

						LIST<Application_Lease_CPF__c> financialsLeaseRecordList = new ApplicationLeaseCPFSelector().selectByAppId(appPrdctCpf.Id);
						if (!financialsLeaseRecordList.isEmpty() && financialsLeaseRecordList.size() > 0 && financialsLeaseRecordList != null){
							LIST<Application_Lease_CPF__c> tenantList = new LIST<Application_Lease_CPF__c>();
							LIST<Application_Lease_CPF__c> otherList = new LIST<Application_Lease_CPF__c>();
							for (Application_Lease_CPF__c alcpf : financialsLeaseRecordList){
								if (alcpf.Other_Lease__c == null || alcpf.Other_Lease__c == ''){
									tenantList.add(alcpf);
								} else{
									otherList.add(alcpf);
								}
							}
							if (!tenantList.isEmpty() && tenantList.size() > 0 && tenantList != null){
								contextBuilder.add('tenantList', tenantList);
							}
							if (!otherList.isEmpty() && otherList.size() > 0 && otherList != null){
								contextBuilder.add('otherList', otherList);
							}
						}

						List<Application_Fees__c> facilityOtherAmountsList = new ApplicationFeesSelector().selectAllAppFees(appPrdctCpf.Id);
						List<Application_Fees__c> facilityAmounts = new List<Application_Fees__c>();
						List<Application_Fees__c> feesAmounts = new List<Application_Fees__c>();
						List<Application_Fees__c> conversionOtherFees = new List<Application_Fees__c>();
						if (!facilityOtherAmountsList.isEmpty() && facilityOtherAmountsList.size() > 0 && facilityOtherAmountsList != null){
							for (Application_Fees__c appFee : facilityOtherAmountsList){
								switch on appFee.Type__c{
									when 'Facility'{
										facilityAmounts.add(appFee);
									}
									when 'Fees Details'{
										feesAmounts.add(appFee);
									}
									when 'Conversion'{
										conversionOtherFees.add(appFee);
									}
								}
							}
							if (!facilityAmounts.isEmpty() && facilityAmounts.size() > 0 && facilityAmounts != null){
								contextBuilder.add('facilityAmounts', facilityAmounts);
							}
							if (!feesAmounts.isEmpty() && feesAmounts.size() > 0 && feesAmounts != null){
								contextBuilder.add('feesAmounts', feesAmounts);
							}
							if (!conversionOtherFees.isEmpty() && conversionOtherFees.size() > 0 && conversionOtherFees != null){
								contextBuilder.add('conversionOtherFees', conversionOtherFees);
								contextBuilder.add('conversionOtherFeesYES', 'YES');
							}
						}

						if (!templatename.contains('6094')){
							LIST<Application_Financial_Account__c> facilityExistingAccounts = new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctCpf.Id);
							if (!facilityExistingAccounts.isEmpty() && facilityExistingAccounts.size() > 0 && facilityExistingAccounts != null){
								for (Application_Financial_Account__c afa : facilityExistingAccounts){
									afa.Account_to_be_closed__c = afa.Account_to_be_closed__c == 'Yes' ? 'YES' : afa.Account_to_be_closed__c == 'No' ? 'NO' : afa.Account_to_be_closed__c;
								}
								contextBuilder.add('facilityExistingAccounts', facilityExistingAccounts);
							}

							if (appPrdctCpf.Secondary_Account_Applicable__c == 'YES' || appPrdctCpf.Secondary_Account_Applicable__c == 'Yes'){
								contextBuilder.add('primaryAcc', 'YES');
								contextBuilder.add('secondaryAccountApplicable', 'YES');
								List<Application_Repayment_Account_CPF__c> araList = new ApplicationRepaymentAccountCPFSelector().selectAraByAppPrdctId(appPrdctCpf.Id);
								List<Application_Repayment_Account_CPF__c> secequalInstalment = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secequalInstalmentBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlyBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> seccapitalisedInterestBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlyEqualInstalmentAmortising = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlyEqualInstalmentBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlySteppedInstalmentAmortising = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlySteppedInstalmentBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlySteppedCapitalAmortising = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secinterestOnlySteppedCapitalBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secsteppedCapitalAmortising = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secsteppedCapitalBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secsteppedInstalmentAmortising = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secsteppedInstalmentBullet = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secPrimary = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secSecondaryDate = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secSecondaryFirst = new List<Application_Repayment_Account_CPF__c>();
								List<Application_Repayment_Account_CPF__c> secSecondarySignature = new List<Application_Repayment_Account_CPF__c>();

								for (Application_Repayment_Account_CPF__c ara : araList){
									ara.Instalment_periods__c = ara.Instalment_periods__c == 'month(s)' ? 'MONTHS(S)' : ara.Instalment_periods__c == 'days' ? 'DAYS' : ara.Instalment_periods__c == 'years' ? 'YEARS' : ara.Instalment_periods__c;
									ara.Interest_service_frequency__c = ara.Interest_service_frequency__c == 'quarterly' ? 'QUARTERLY' : ara.Interest_service_frequency__c == 'monthly' ? 'MONTHLY' : ara.Interest_service_frequency__c == 'annually' ? 'ANNUALLY' : ara.Interest_service_frequency__c == 'bi-annually' ? 'BI-ANNUALLY' : ara.Interest_service_frequency__c;
									ara.Prime_rate_margin__c = ara.Prime_rate_margin__c == 'Plus per annum' ? 'PLUS PER ANNUM' : ara.Prime_rate_margin__c == 'Minus per annum' ? 'MINUS PER ANNUM' : ara.Prime_rate_margin__c == 'No variance' ? 'NO VARIANCE' : ara.Prime_rate_margin__c;

									switch on ara.Type__c{
										when 'primary'{
											switch on ara.Final_repayment_date__c{
												when 'Date'{
													contextBuilder.add('secPrimaryDate', 'YES');
												}
												when 'after the date of first drawdown'{
													contextBuilder.add('secPrimaryFirstDrawDown', 'YES');
													ara.Final_repayment_date__c = 'Date after first drawdown';
												}
												when 'after the Signature Date'{
													contextBuilder.add('secPrimaryafterSignatureDate', 'YES');
													ara.Final_repayment_date__c = 'Date after Signature';
												}
											}
											secPrimary.add(ara);

											switch on ara.Repayment_options__c{
												when 'Equal Instalment'{
													contextBuilder.add('secPrimEqualInst', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsEqualInstalment');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsEqualInstalment');
												}
												when 'Equal instalment (Bullet)'{
													contextBuilder.add('secPrimEqualInstBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsEqualInstalmentBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsEqualInstalmentBullet');
												}
												when 'Interest only (Bullet)'{
													contextBuilder.add('secPrimIntOnlyBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyBullet');
												}
												when 'Capitalised interest (Bullet)'{
													contextBuilder.add('secPrimCapIntBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsCapitalisedInterestBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsEqualInstalment');
												}
												when 'Interest only period with equal instalment period thereafter (Amortising)'{
													contextBuilder.add('secPrimEqualIntOnlyEqPeriodAmort', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithEqualInstalmentPeriodThereafter');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithEqualInstalmentPeriodThereafter');
												}
												when 'Interest only period with equal instalment period thereafter (Bullet)'{
													contextBuilder.add('secPrimEqualIntOnlyEqPeriodBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithEqualInstalmentPeriodThereafterBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithEqualInstalmentPeriodThereafterBullet');
												}
												when 'Interest only period with stepped instalment period thereafter (Amortising)'{
													contextBuilder.add('secPrimIntOnlyStepPeriodAmort', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedInstalmentPeriodThereafter');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedInstalmentPeriodThereafter');
												}
												when 'Interest only period with stepped instalment period thereafter (Bullet)'{
													contextBuilder.add('secPrimIntOnlyStepPeriodBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedInstalmentPeriodThereafterBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedInstalmentPeriodThereafterBullet');
												}
												when 'Interest only period with stepped capital period thereafter (Amortising)'{
													contextBuilder.add('secPrimIntOnlyStepCapPeriodAmort', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedCapitalPeriodThereafter');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedCapitalPeriodThereafter');
												}
												when 'Interest only period with stepped capital period thereafter (Bullet)'{
													contextBuilder.add('secPrimIntOnlyStepCapPeriodBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedCapitalPeriodThereafterBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsInterestOnlyPeriodWithSteppedCapitalPeriodThereafterBullet');
												}
												when 'Stepped capital (Amortising)'{
													contextBuilder.add('secPrimStepCapAmort', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsSteppedCapital');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsSteppedCapital');
												}
												when 'Stepped capital (Bullet)'{
													contextBuilder.add('secPrimStepCapBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsSteppedCapitalBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsSteppedCapitalBullet');
												}
												when 'Stepped instalment (Amortising)'{
													contextBuilder.add('secPrimStepInstAmort', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsSteppedInstalment');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsSteppedInstalment');
												}
												when 'Stepped instalment (Bullet)'{
													contextBuilder.add('secPrimStepInstBullet', 'YES');
													contextBuilder.add('secPrimHead', 'PRD_DL_PrimaryAccountRepaymentOptionsSteppedInstalmentBullet');
													contextBuilder.add('secPrimTail', '/PRD_DL_PrimaryAccountRepaymentOptionsSteppedInstalmentBullet');
												}
											}
										}
										when 'secondary'{
											switch on ara.Repayment_options__c{
												when 'Equal Instalment'{
													secequalInstalment.add(ara);
												}
												when 'Equal instalment (Bullet)'{
													secequalInstalmentBullet.add(ara);
												}
												when 'Interest only (Bullet)'{
													secinterestOnlyBullet.add(ara);
												}
												when 'Capitalised interest (Bullet)'{
													seccapitalisedInterestBullet.add(ara);
												}
												when 'Interest only period with equal instalment period thereafter (Amortising)'{
													secinterestOnlyEqualInstalmentAmortising.add(ara);
												}
												when 'Interest only period with equal instalment period thereafter (Bullet)'{
													secinterestOnlyEqualInstalmentBullet.add(ara);
												}
												when 'Interest only period with stepped instalment period thereafter (Amortising)'{
													secinterestOnlySteppedInstalmentAmortising.add(ara);
												}
												when 'Interest only period with stepped instalment period thereafter (Bullet)'{
													secinterestOnlySteppedInstalmentBullet.add(ara);
												}
												when 'Interest only period with stepped capital period thereafter (Amortising)'{
													secinterestOnlySteppedCapitalAmortising.add(ara);
												}
												when 'Interest only period with stepped capital period thereafter (Bullet)'{
													secinterestOnlySteppedCapitalBullet.add(ara);
												}
												when 'Stepped capital (Amortising)'{
													secsteppedCapitalAmortising.add(ara);
												}
												when 'Stepped capital (Bullet)'{
													secsteppedCapitalBullet.add(ara);
												}
												when 'Stepped instalment (Amortising)'{
													secsteppedInstalmentAmortising.add(ara);
												}
												when 'Stepped instalment (Bullet)'{
													secsteppedInstalmentBullet.add(ara);
												}
											}
											switch on ara.Final_repayment_date__c{
												when 'Date'{
													secSecondaryDate.add(ara);
												}
												when 'after the date of first drawdown'{
													ara.Final_repayment_date__c = 'Date after first drawdown';
													secSecondaryFirst.add(ara);
												}
												when 'after the Signature Date'{
													ara.Final_repayment_date__c = 'Date after Signature';
													secSecondarySignature.add(ara);
												}
											}
										}
									}
								}
								if (!secsteppedInstalmentBullet.isEmpty() && secsteppedInstalmentBullet.size() > 0 && secsteppedInstalmentBullet != null){
									contextBuilder.add('secsteppedInstalmentBullet', secsteppedInstalmentBullet);
								}
								if (!secsteppedInstalmentAmortising.isEmpty() && secsteppedInstalmentAmortising.size() > 0 && secsteppedInstalmentAmortising != null){
									contextBuilder.add('secsteppedInstalmentAmortising', secsteppedInstalmentAmortising);
								}
								if (!secsteppedCapitalBullet.isEmpty() && secsteppedCapitalBullet.size() > 0 && secsteppedCapitalBullet != null){
									contextBuilder.add('secsteppedCapitalBullet', secsteppedCapitalBullet);
								}
								if (!secsteppedCapitalAmortising.isEmpty() && secsteppedCapitalAmortising.size() > 0 && secsteppedCapitalAmortising != null){
									contextBuilder.add('secsteppedCapitalAmortising', secsteppedCapitalAmortising);
								}
								if (!secinterestOnlySteppedCapitalBullet.isEmpty() && secinterestOnlySteppedCapitalBullet.size() > 0 && secinterestOnlySteppedCapitalBullet != null){
									contextBuilder.add('secinterestOnlySteppedCapitalBullet', secinterestOnlySteppedCapitalBullet);
								}
								if (!secinterestOnlySteppedCapitalAmortising.isEmpty() && secinterestOnlySteppedCapitalAmortising.size() > 0 && secinterestOnlySteppedCapitalAmortising != null){
									contextBuilder.add('secinterestOnlySteppedCapitalAmortising', secinterestOnlySteppedCapitalAmortising);
								}
								if (!secinterestOnlySteppedInstalmentBullet.isEmpty() && secinterestOnlySteppedInstalmentBullet.size() > 0 && secinterestOnlySteppedInstalmentBullet != null){
									contextBuilder.add('secinterestOnlySteppedInstalmentBullet', secinterestOnlySteppedInstalmentBullet);
								}
								if (!secinterestOnlySteppedInstalmentAmortising.isEmpty() && secinterestOnlySteppedInstalmentAmortising.size() > 0 && secinterestOnlySteppedInstalmentAmortising != null){
									contextBuilder.add('secinterestOnlySteppedInstalmentAmortising', secinterestOnlySteppedInstalmentAmortising);
								}
								if (!secinterestOnlyEqualInstalmentBullet.isEmpty() && secinterestOnlyEqualInstalmentBullet.size() > 0 && secinterestOnlyEqualInstalmentBullet != null){
									contextBuilder.add('secinterestOnlyEqualInstalmentBullet', secinterestOnlyEqualInstalmentBullet);
								}
								if (!secinterestOnlyEqualInstalmentAmortising.isEmpty() && secinterestOnlyEqualInstalmentAmortising.size() > 0 && secinterestOnlyEqualInstalmentAmortising != null){
									contextBuilder.add('secinterestOnlyEqualInstalmentAmortising', secinterestOnlyEqualInstalmentAmortising);
								}
								if (!seccapitalisedInterestBullet.isEmpty() && seccapitalisedInterestBullet.size() > 0 && seccapitalisedInterestBullet != null){
									contextBuilder.add('seccapitalisedInterestBullet', seccapitalisedInterestBullet);
								}
								if (!secinterestOnlyBullet.isEmpty() && secinterestOnlyBullet.size() > 0 && secinterestOnlyBullet != null){
									contextBuilder.add('secinterestOnlyBullet', secinterestOnlyBullet);
								}
								if (!secequalInstalmentBullet.isEmpty() && secequalInstalmentBullet.size() > 0 && secequalInstalmentBullet != null){
									contextBuilder.add('secequalInstalmentBullet', secequalInstalmentBullet);
								}
								if (!secequalInstalment.isEmpty() && secequalInstalment.size() > 0 && secequalInstalment != null){
									contextBuilder.add('secequalInstalment', secequalInstalment);
								}
								if (!secSecondarySignature.isEmpty() && secSecondarySignature.size() > 0 && secSecondarySignature != null){
									contextBuilder.add('secSecondarySignature', secSecondarySignature);
								}
								if (!secSecondaryFirst.isEmpty() && secSecondaryFirst.size() > 0 && secSecondaryFirst != null){
									contextBuilder.add('secSecondaryFirst', secSecondaryFirst);
								}
								if (!secSecondaryDate.isEmpty() && secSecondaryDate.size() > 0 && secSecondaryDate != null){
									contextBuilder.add('secSecondaryDate', secSecondaryDate);
								}
								if (!secPrimary.isEmpty() && secPrimary.size() > 0 && secPrimary != null){
									contextBuilder.add('secPrimary', secPrimary);
								}
							} else{
								contextBuilder.add('facilityReq', 'YES');
								contextBuilder.add('primaryAccountApplicable', 'YES');
							}

							LIST<Application_Portfolio__c> appPortfolioList = [select id, name, Portfolio_Description__c, Application_Product_CPF__c
							                                                   from Application_Portfolio__c
							                                                   where Application_Product_CPF__c = :appPrdctCpf.Id];
							if (!appPortfolioList.isEmpty() && appPortfolioList.size() > 0 && appPortfolioList != null){
								contextBuilder.add('appPortfolioList', appPortfolioList);
							}
						}

						List<Application_Phase_CPF__c> appPhaseCPF = new ApplicationPhasesCPFSelector().selectAllAppPhaseFees(appPrdctCpf.Id);
						List<Application_Phase_CPF__c> singlePhaseFees = new List<Application_Phase_CPF__c>();
						List<Application_Phase_CPF__c> multiplePhaseFees = new List<Application_Phase_CPF__c>();
						List<Application_Phase_CPF__c> perPhaseRecs = new List<Application_Phase_CPF__c>();
						string phaseDate;
						string phaseafterSignatureDate;
						string phaseafterDateOfFirstDrawDown;
						string includebalanceonexistingaccount;
						if (!appPhaseCPF.isEmpty() && appPhaseCPF.size() > 0 && appPhaseCPF != null){
							for (Application_Phase_CPF__c appPhaseFees : appPhaseCPF){
								appPhaseFees.Include_admin_fee_in_total_facility__c = appPhaseFees.Include_admin_fee_in_total_facility__c == 'Yes' ? 'YES' : appPhaseFees.Include_admin_fee_in_total_facility__c == 'No' ? 'NO' : appPhaseFees.Include_admin_fee_in_total_facility__c;
								appPhaseFees.Include_admin_fee_in_total_facility2__c = appPhaseFees.Include_admin_fee_in_total_facility2__c == 'Yes' ? 'YES' : appPhaseFees.Include_admin_fee_in_total_facility2__c == 'No' ? 'NO' : appPhaseFees.Include_admin_fee_in_total_facility2__c;
								appPhaseFees.Valuation_fee__c = appPhaseFees.Valuation_fee__c == 'Yes' ? 'YES' : appPhaseFees.Valuation_fee__c == 'No' ? 'NO' : appPhaseFees.Valuation_fee__c;
								appPhaseFees.Drawdown_inspection_fee__c = appPhaseFees.Drawdown_inspection_fee__c == 'Yes' ? 'YES' : appPhaseFees.Drawdown_inspection_fee__c == 'No' ? 'NO' : appPhaseFees.Drawdown_inspection_fee__c;
								appPhaseFees.Other_fees_applicable__c = appPhaseFees.Other_fees_applicable__c == 'Yes' ? 'YES' : appPhaseFees.Other_fees_applicable__c == 'No' ? 'NO' : appPhaseFees.Other_fees_applicable__c;
								appPhaseFees.Include_balance_on_existing_account__c = appPhaseFees.Include_balance_on_existing_account__c == 'Yes' ? 'YES' : appPhaseFees.Include_balance_on_existing_account__c == 'No' ? 'NO' : appPhaseFees.Include_balance_on_existing_account__c;
								appPhaseFees.Include_VAT_on_charges__c = appPhaseFees.Include_VAT_on_charges__c == 'Yes' ? 'YES' : appPhaseFees.Include_VAT_on_charges__c == 'No' ? 'NO' : appPhaseFees.Include_VAT_on_charges__c;
								appPhaseFees.Other_amounts_included_in_total_facility__c = appPhaseFees.Other_amounts_included_in_total_facility__c == 'Yes' ? 'YES' : appPhaseFees.Other_amounts_included_in_total_facility__c == 'No' ? 'NO' : appPhaseFees.Other_amounts_included_in_total_facility__c;
								appPhaseFees.Interest_service_frequency__c = appPhaseFees.Interest_service_frequency__c == 'quarterly' ? 'QUARTERLY' : appPhaseFees.Interest_service_frequency__c == 'monthly' ? 'MONTHLY' : appPhaseFees.Interest_service_frequency__c == 'annually' ? 'ANNUALLY' : appPhaseFees.Interest_service_frequency__c == 'bi-annually' ? 'BI-ANNUALLY' : appPhaseFees.Interest_service_frequency__c;
								appPhaseFees.Interest_only_period__c = appPhaseFees.Interest_only_period__c == 'day(s)' ? 'DAY(S)' : appPhaseFees.Interest_only_period__c == 'month(s)' ? 'MONTH(S)' : appPhaseFees.Interest_only_period__c == 'year(s)' ? 'YEAR(S)' : appPhaseFees.Interest_only_period__c;
								appPhaseFees.Prepayment_fee__c = appPhaseFees.Prepayment_fee__c == 'Yes' ? 'YES' : appPhaseFees.Prepayment_fee__c == 'No' ? 'NO' : appPhaseFees.Prepayment_fee__c;
								appPhaseFees.Interest_rate_basis__c = appPhaseFees.Interest_rate_basis__c == 'Fixed rate with all in risk margin' ? 'FIXED RATE WITH ALL IN RISK MARGIN' : appPhaseFees.Interest_rate_basis__c == 'Prime Rate' ? 'PRIME RATE' : appPhaseFees.Interest_rate_basis__c == 'Fixed rate with net margin' ? 'FIXED RATE WITH NET MARGIN' : appPhaseFees.Interest_rate_basis__c;
								appPhaseFees.Account_type__c = appPhaseFees.Account_type__c == 'Current Account' ? 'CURRENT ACCOUNT' : appPhaseFees.Account_type__c == 'Loan Account' ? 'LOAN ACCOUNT' : appPhaseFees.Account_type__c;
								appPhaseFees.Payable__c = appPhaseFees.Payable__c == 'on first drawdown of the Facility' ? 'ON FIRST DRAW DOWN' : appPhaseFees.Payable__c == 'on Signature Date' ? 'ON SIGNATURE DATE' : appPhaseFees.Payable__c;
								appPhaseFees.Prime_rate_margin__c = appPhaseFees.Prime_rate_margin__c == 'Plus per annum' ? 'PLUS PER ANNUM' : appPhaseFees.Prime_rate_margin__c == 'Minus per annum' ? 'MINUS PER ANNUM' : appPhaseFees.Prime_rate_margin__c == 'No variance' ? 'NO VARIANCE' : appPhaseFees.Prime_rate_margin__c;

								switch on appPhaseFees.Final_repayment_date__c{
									when 'Date'{
										phaseDate = 'YES';
										appPhaseFees.Final_repayment_date__c = 'DATE';
									}
									when 'after the date of first drawdown'{
										phaseafterDateOfFirstDrawDown = 'YES';
										appPhaseFees.Final_repayment_date__c = 'DATE AFTER FIRST DRAWDOWN';
									}
									when 'after the Signature Date'{
										phaseafterSignatureDate = 'YES';
										appPhaseFees.Final_repayment_date__c = 'DATE AFTER SIGNATURE';
									}
								}

								switch on appPhaseFees.Repayment_options_during_development__c{
									when 'Capital and interest repayments'{
										appPhaseFees.Final_instalment_amount__c = null;
										appPhaseFees.Interest_service_frequency__c = null;
										appPhaseFees.Interest_only_period__c = null;
										appPhaseFees.Free_flow_option__c = null;
									}
									when 'A period of interest only with capital and interest periods for the remaining term of the Facility'{
										appPhaseFees.Interest_service_frequency__c = null;
										appPhaseFees.Free_flow_option__c = null;
									}
									when 'Capitalised Interest with Bullet (No Conversion)', 'Capitalised Interest with Bullet (Converting)', 'Interest only with a bullet capital repayment'{
										appPhaseFees.Interest_only_period__c = null;
										appPhaseFees.Free_flow_option__c = null;
									}
									when 'Free flow'{
										appPhaseFees.Final_instalment_amount__c = null;
										appPhaseFees.Interest_service_frequency__c = null;
										appPhaseFees.Interest_only_period__c = null;
									}
								}

								switch on appPhaseFees.Type__c{
									when 'Single Phase'{
										singlePhaseFees.add(appPhaseFees);
									}
									when 'Multiple Phase'{
										if (appPhaseFees.Include_balance_on_existing_account__c == 'YES'){
											includebalanceonexistingaccount = 'YES';
										}
										if (!feesAmounts.isEmpty() && feesAmounts.size() > 0 && feesAmounts != null){
											for (Application_Fees__c af : feesAmounts){
												if (af.Phase_Number__c == appPhaseFees.Phase_Number__c){
													appPhaseFees.Other_Fees_Description__c = af.Fees_description__c;
													appPhaseFees.Other_Fees_Value__c = af.Fees_value__c;
													break;
												}
											}
										}
										multiplePhaseFees.add(appPhaseFees);
									}
									when 'Per Phase'{
										perPhaseRecs.add(appPhaseFees);
									}
								}
							}

							if (!singlePhaseFees.isEmpty() && singlePhaseFees.size() > 0 && singlePhaseFees != null && appPrdctCpf.Multiple_phases_applicable__c == 'No'){
								contextBuilder.add('singlePhaseFees', singlePhaseFees);
								contextBuilder.add('singlePhaseFeesYES', 'YES');
							}
							if (!multiplePhaseFees.isEmpty() && multiplePhaseFees.size() > 0 && multiplePhaseFees != null && appPrdctCpf.Multiple_phases_applicable__c == 'Yes'){
								contextBuilder.add('multiplePhaseFees', multiplePhaseFees);
								contextBuilder.add('multiplePhaseFeesYES', 'YES');
								contextBuilder.add('multiplePhaseFeesIRB', multiplePhaseFees.get(0).Interest_rate_basis__c);
							}
							if (!perPhaseRecs.isEmpty() && perPhaseRecs.size() > 0 && perPhaseRecs != null && appPrdctCpf.Proof_of_Pre_sales__c == 'Per Phase'){
								contextBuilder.add('perPhaseRecs', perPhaseRecs);
								contextBuilder.add('MaxPer', appPrdctCpf.Max_by_single_investor__c);
								contextBuilder.add('Multiplepurchaseoptions', appPrdctCpf.Multiple_purchase__c);
								contextBuilder.add('Nonrefundabledeposit', appPrdctCpf.Non_refundable_deposit__c);
								contextBuilder.add('Standardsalesagreement', appPrdctCpf.Copy_of_standard_sales_agreement__c);
								contextBuilder.add('Scheduleofnetsale', appPrdctCpf.Schedule_of_net_sale__c);
								contextBuilder.add('Scheduleofsales', appPrdctCpf.Schedule_of_sales__c);
								contextBuilder.add('Copiesofallsaleagreements', appPrdctCpf.Copies_of_all_sale_agreements__c);
							}
							if (phaseDate == 'YES'){
								contextBuilder.add('phaseDate', 'YES');
							}
							if (phaseafterDateOfFirstDrawDown == 'YES'){
								contextBuilder.add('phaseafterDateOfFirstDrawDown', 'YES');
							}
							if (phaseafterSignatureDate == 'YES'){
								contextBuilder.add('phaseafterSignatureDate', 'YES');
							}
							contextBuilder.add('includebalanceonexistingaccount', includebalanceonexistingaccount);
						}

						List<Application_Team_Member__c> appTeamMemberlist = new ApplicationTeamMembersSelector().selectteamMemberwithtypeandCategory(appPrdctCpf.Id, 'Profession', 'CPF');
						if (!appTeamMemberlist.isEmpty() && appTeamMemberlist.size() > 0 && appTeamMemberlist != null){
							contextBuilder.add('otherProsessionalTeamMember', appTeamMemberlist);
							//contextBuilder.add('otherProsessionalTeamMemberYES', 'YES');
						}

						LIST<Application_Financial_Account__c> appfinAccList = new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctCpf.Id);
						if (!appfinAccList.isEmpty() && appfinAccList.size() > 0 && appfinAccList != null){
							for (Application_Financial_Account__c afa : appfinAccList){
								afa.Account_to_be_closed__c = afa.Account_to_be_closed__c == 'Yes' ? 'true' : afa.Account_to_be_closed__c == 'No' ? 'false' : afa.Account_to_be_closed__c;
							}
							contextBuilder.add('appfinAccList', appfinAccList);
						}

					} else{
						result.put('success', 'false');
						result.put('message', 'Error generating document - There is no associated Application Product CPF record created');
						return result;
					}
				}
			}
			Datetime dt = Datetime.now();
			String day = dt.day() < 10 ? '0' + dt.day() : String.valueOf(dt.day());
			String month = dt.month() < 10 ? '0' + dt.month() : String.valueOf(dt.day());
			String year = String.valueOf(dt.year());
			contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
			contextBuilder.add('shorttoday', dt.format('yyyy-MM-dd'));
			contextBuilder.add('shorttodayddmmyyyy', day + month + year);
			System.debug('>>>>Done with building data>>>');
			String req = contextBuilder.serialize(documentTemplate.XML__c);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			System.debug(req);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

			string docFormat = documentTemplate.Generated_Document_Format__c;
			if (docFormat == null || docFormat == ''){
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
			System.debug('serialise response ' + JSON.serialize(response));
			Document__c doc = new Document__c();

			doc.Type__c = documentTemplate.Document_Type__c;
			doc.Reference__c = response.contentStoreToken;
			doc.Opportunity__c = opp.Id;
			doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
			doc.name = docName;
			insert doc;
			// did we win? - I pressume a failure would result in the catch running - unless of course it is some unhandled error no being thrown
			result.put('success', 'true');
			result.put('message', 'Successfully generated');
		} catch (Exception ex){
			result.put('success', 'false');
			result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
			system.debug(ex.getMessage());
			system.debug(ex.getLineNumber());
		}
		return result;
		//return GenerateDocument.generateNewDocument(oppId, templatename, signatureRequests);
	}

	/**
	 * @author Tinashe M Shoko
	 * @description Method that gets a list of all documents for Opportunity
	 *
	 * @param opportunityId
	 * @return List<Document__c> : a list of documents linked to the opportunityId parameter
	 */
	@AuraEnabled
	public static List<Document__c> getDocumentList(Id opportunityId){
		List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(opportunityId);
		return docList;
	}

	/**
	 * @author Tinashe Shoko
	 * @description Method that downloads a document to the desktop
	 *
	 * @param documentId
	 * @return string : ECM_GetResult_IB_V1.Content.data
	 */
	@AuraEnabled
	public static String getDocumentContent(Id documentId){
		return DocumentManagementControler.getDocumentContent(documentId);
	}

	/**
	 * @description A method to append to and existing file or save a file to the Attachment object. Once the file is save or updated it is then sent to ECM.
	 * @param parentId parent object Id the docs are linked to.
	 * @param fileName name of the file.
	 * @param base64Data body of the file.
	 * @param contentType type of file being uploaded.
	 * @param fileId Id of existing file that has already been saved to Attachment object.
	 * @param done indidcator to continu to ECM
	 * @param documentType the type of document beind uploaded.
	 * @param signedManually the type of document beind uploaded.
	 * @param relatedPartyId the type of document beind uploaded.
	 * @return Id : of file updated or saved.
	 *
	 * @modified 2019-06-14 by Robert McLean.
	 * @Change description Added document type to parameters to be used with the completeUpload method.
	 **/
	@AuraEnabled
	public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType, Boolean signedManually, String relatedPartyId){
		return DocumentController.saveChunk(parentId, fileName, base64Data, contentType, fileId, done, documentType, signedManually, relatedPartyId);
	}

	/**
	 * @description Method to get CPF Product Name
	 * @author  | 2021-06-07 Diksha Wasekar
	 * @param oppId
	 * @return List<OpportunityLineItem>
	 **/
	@AuraEnabled
	public static List<OpportunityLineItem> getprodName(Id oppId){
		List<OpportunityLineItem> opplineitemlst = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
		return opplineitemlst;
	}

	/**
	 * @description enableWordDocGen description
	 *
	 * @return boolean: Return description
	 */
	@AuraEnabled
	public static boolean enableWordDocGen(){
		Set<String> permissionSetNames = new Set<String>{'CPF_Legal_Consultant', 'CPF_SME'};
		return (new PermissionSetAssignmentsSelector().selectByNameAndUserId(permissionSetNames, UserInfo.getUserId())).size() > 0 ? true : false;
	}
}