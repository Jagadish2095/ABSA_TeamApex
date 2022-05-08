/**
 * @description GenerateCreditDocuments Description
 * breaking up the huge generic generateDocuments class split into 2
 * @author Tinashe M Shoko
 * @date 28-Apr-2021
 */
public class GenerateCreditDocuments {
    /**
     * @description Method to generate Credit Documents for Security Offered and Store response in Document object
     *
     * @param securityOfferedId The Security Offered record Id
     * @param templateName The Document Template name
     * @return Map<string,String>
    **/
    Public static Map<String,String> generateCreditDocs(Id securityOfferedId, String templateName){
        System.debug('Generating new document for security offered : ' + securityOfferedId + ', templateName : ' + templateName);
        Map<String, String> result = new Map<String, String>();

        try{
            Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);

            DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
            DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();

            //Get Security Offered
            String SrtyshipLtdToAcc_crdt_agrmnt_type_amt = '';
            String SrtyshipLtdToAcc_crdt_agrmnt = '';
            List<Security_Offered__c> securityOfferedList = new securitiesOfferedSelector().selectById(securityOfferedId);
            Security_Offered__c securityOfferedRecord = securityOfferedList[0];
            securityOfferedRecord.Limited_Cession__c = securityOfferedRecord.Limited_Cession__c == 'Y' ? 'NO' : securityOfferedRecord.Limited_Cession__c == 'N' ? 'YES' : securityOfferedRecord.Limited_Cession__c;
            securityOfferedRecord.Specific_Security__c = securityOfferedRecord.Specific_Security__c == 'Yes' ? 'YES' : securityOfferedRecord.Specific_Security__c == 'No' ? 'NO' : securityOfferedRecord.Specific_Security__c;
            SrtyshipLtdToAcc_crdt_agrmnt = securityOfferedRecord.Specific_Security__c == 'Yes' && securityOfferedRecord.Security_Amount__c == null ? 'YES':'NO';
            SrtyshipLtdToAcc_crdt_agrmnt_type_amt = securityOfferedRecord.Specific_Security__c == 'Yes' && securityOfferedRecord.Security_Amount__c != null ? 'YES':'NO';
            contextBuilder.add('SrtyshipLtdToAcc_crdt_agrmnt_type_amt', SrtyshipLtdToAcc_crdt_agrmnt_type_amt);
            //securityOfferedRecord.SrtyshipLtdToAcc_crdt_agrmnt_type_amt__c = securityOfferedRecord.SrtyshipLtdToAcc_crdt_agrmnt_type_amt__c == 'Yes' ? 'YES' : securityOfferedRecord.SrtyshipLtdToAcc_crdt_agrmnt_type_amt__c == 'No' ? 'NO' : securityOfferedRecord.SrtyshipLtdToAcc_crdt_agrmnt_type_amt__c;
            securityOfferedRecord.IsSuretyLtdToAmtButServeAsSecurity__c = securityOfferedRecord.IsSuretyLtdToAmtButServeAsSecurity__c == 'Yes' ? 'YES' : securityOfferedRecord.IsSuretyLtdToAmtButServeAsSecurity__c == 'No' ? 'NO' : securityOfferedRecord.IsSuretyLtdToAmtButServeAsSecurity__c;
            contextBuilder.add('SecurityOffered', securityOfferedRecord);
            //Get Account Number based on New/Existing Accounts
            String accNumber = securityOfferedRecord.Securities_Offered_for_Facility__c == 'New' ? securityOfferedRecord.Unique_Identifier__c : securityOfferedRecord.Securities_Offered_for_Facility__c == 'Existing' ? securityOfferedRecord.Reference_Account_Number__c : '';
            contextBuilder.add('accNum', accNumber);

            // get the main account details
            system.debug('get main account');
            Account accountRecord = new AccountsSelector().selectAllByIdFOrDocs(securityOfferedRecord.Account__c);
            contextBuilder.add('Account', accountRecord);

            //Account Id string to generate address for either for main entity or related party
            String accId = '';

            // get the Entities details from Security Offered
            system.debug('get entity account');
            Contact relatedParty = new Contact();
            if(string.isNotBlank(securityOfferedRecord.Contact__c)){
                relatedParty = new ContactsSelector().selectCifFieldsByContactId(securityOfferedRecord.Contact__c);
                contextBuilder.add('RelatedPartyRecord', relatedParty);
                accId = relatedParty.AccountId;
            }
            else{
                accId = securityOfferedRecord.Account__c;
            }

            //Logic to populate data on Cedent section in XML based on Security Provider Type
            string securityProviderType = securityOfferedRecord.Security_Provider_Type__c;
            string firstName = '';
            string surname = '';
            string idNumber = '';
            string signOnBehalf = '';
            string emailOrFax = '';
            switch on securityProviderType {
                when 'SECURITY BY / IN FAVOUR OF A SOLE PROPRIETOR' , 'SECURITY BY AN INDIVIDUAL'{
                    firstName = relatedParty.LastName;
                    surname = relatedParty.firstName;
                    idNumber = relatedParty.ID_Number__c;
                    emailOrFax = relatedParty.Email;
                }
                when 'SECURITY BY A CLOSE CORPORATION BY VIRTUE OF A RESOLUTION', 'SECURITY BY A CLOSE CORPORATION WITHOUT A RESOLUTION',
                   'SECURITY BY A PARTNERSHIP BY VIRTUE OF A RESOLUTION', 'SECURITY BY A PARTNERSHIP WITHOUT A RESOLUTION',
                   'SECURITY BY A TRUST BY VIRTUE OF A RESOLUTION', 'SECURITY BY A TRUST WITHOUT A RESOLUTION',
                    'SECURITY BY INFORMAL BODIES / SCHOOLS / CHURCHES', 'SECURITY BY SECTIONAL TITLE PROPERTIES',
                    'SECURITY ON BEHALF OF INDIVIDUALS', 'SECURITY ON BEHALF OF A COMPANY BY VIRTUE OF A RESOLUTION', 'SECURITY ON BEHALF OF A COMPANY WITHOUT A RESOLUTION',
                    'SECURITY BY A CO-OPERATIVE'{
                        firstName = securityOfferedRecord.Mandated_Officials_List__c;
                        signOnBehalf = relatedParty.firstName + relatedParty.LastName;
                        emailOrFax = relatedParty.Email;
                }
                when 'SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION BY VIRTUE OF A RESOLUTION', 'SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION WITHOUT A RESOLUTION' {
                    firstName = securityOfferedRecord.Mandated_Officials_List__c;
                    emailOrFax = relatedParty.Email;
                }
            }

            contextBuilder.add('FirstName', firstName);
            contextBuilder.add('Surname', surname);
            contextBuilder.add('IDNumber', idNumber);
            contextBuilder.add('SignOnBehalf', signOnBehalf);
            contextBuilder.add('EmailOrFax', emailOrFax);

            //Get Banker selected Address based on Delivery Method Field
            if(String.isNotBlank(securityOfferedRecord.Delivery_Method__c) && securityOfferedRecord.Delivery_Method__c == 'Registered Mail'){
                Address__c regAddress = securityOfferedRecord.Address__c != null ? new AddressesSelector().selectByAddressId(securityOfferedRecord.Address__c).get(0) : new Address__c();
                contextBuilder.add('RegAddress', regAddress);
            }

            Id opportunityId;
            //Get Application Record
            Application__c applicationDetails = new ApplicationsSelector().selectByIdFromSecurityOffered(securityOfferedRecord.Application__c);
            if (applicationDetails != null){
                opportunityId = applicationDetails.Opportunity__c;
                contextBuilder.add('Application', applicationDetails);
            }

			// get the Opportunity se we can get the account as it seems the Application is not linked to Opportunity
			Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);

            // get current logged user (advisor) ddetails
            system.debug('get current user');
            User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
            if (currentUser != null){
                contextBuilder.add('User', currentUser);
                // hopefully this is the branch
                List<Site__c> siteData = new SitesSelector().selectBySiteCode(currentUser.SiteCode__c);
                if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null)
                    contextBuilder.add('Site', siteData.get(0));
            }

            // get addresses
            List<Address__c> addresses = new AddressesSelector().addressesRelatedToAcc(accId);
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

                for (Address__c address : addresses) {
                    switch on address.Address_Type__c {
                        when 'OperatingAddress' {
                            operatingAddress.add(address);
                        }
                        when 'Postal' {
                            postalAddress.add(address);
                        }
                        when 'Physical Address' {
                            physicalAddress.add(address);
                        }
                        when 'Residential' {
                            residentialAddress.add(address);
                        }
                        when 'Employers' {
                            employersAddress.add(address);
                        }
                        when 'Registered' {
                            if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
                                registeredAddress.add(address);
                        }
                        when 'Business Address' {
                            businessAddress.add(address);
                        }
                        when 'Master of High Court' {
                            if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
                                masterCourtAddress.add(address);
                        }
                        when 'Head Office' {
                            if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
                                headOfficeAddress.add(address);
                        }
                    }
                }
                if (!operatingAddress.isEmpty() && operatingAddress.size() > 0 && operatingAddress != null)
                    contextBuilder.add('OperatingAddress', operatingAddress.get(0));

                if (!postalAddress.isEmpty() && postalAddress.size() > 0 && postalAddress != null)
                    contextBuilder.add('PostalAddress', postalAddress.get(0));

                if (!physicalAddress.isEmpty() && physicalAddress.size() > 0 && physicalAddress != null)
                    contextBuilder.add('PhysicalAddress', physicalAddress.get(0));

                if (!residentialAddress.isEmpty() && residentialAddress.size() > 0 && residentialAddress != null)
                    contextBuilder.add('ResidentialAddress', residentialAddress.get(0));

                if (!employersAddress.isEmpty() && employersAddress.size() > 0 && employersAddress != null)
                    contextBuilder.add('EmployersAddress', employersAddress.get(0));

                if (!registeredAddress.isEmpty() && registeredAddress.size() > 0 && registeredAddress != null)
                    contextBuilder.add('RegisteredAddress', registeredAddress.get(0));

                if (!businessAddress.isEmpty() && businessAddress.size() > 0 && businessAddress != null)
                    contextBuilder.add('BusinessAddress', businessAddress.get(0));

                if (!masterCourtAddress.isEmpty() && masterCourtAddress.size() > 0 && masterCourtAddress != null)
                    contextBuilder.add('MasterCourtAddress', masterCourtAddress.get(0));

                if (!headOfficeAddress.isEmpty() && headOfficeAddress.size() > 0 && headOfficeAddress != null)
                    contextBuilder.add('HeadOfficeAddress', headOfficeAddress.get(0));
            }

            // this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
            Datetime dt = Datetime.now();
            contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
            contextBuilder.add('shorttoday', dt.format('yyyy-MM-dd'));
            System.debug('>>>>Done with building data>>>');
            String req = contextBuilder.serialize(documentTemplate.XML__c);
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
            System.debug(req);
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
            Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

            CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
            System.debug('serialise response ' + JSON.serialize(response));
            Document__c doc = new Document__c();
            doc.Name = documentTemplate.Name.left(75)+'.pdf';
            doc.Type__c = documentTemplate.Document_Type__c;
            doc.Reference__c = response.contentStoreToken;
            if(opportunityId != null) {
                doc.Opportunity__c = opportunityId;
            }
            doc.Security_Offered__c = securityOfferedId;
            doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
            insert doc;
            // did we win? - I pressume a failure would result in the catch running - unless of course it is some unhandled error no being thrown
            result.put('success', 'true');
            result.put('message', 'Successfully generated');
        }
        catch (Exception ex) {
            result.put('success', 'false');
            result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
            system.debug(ex.getMessage());
            system.debug(ex.getLineNumber());
        }
        return result;
    }

    private static DocumentTemplateProcessor.ContextBuilder existingSecurities(DocumentTemplateProcessor.ContextBuilder contextBuilder, String appId) {
        List<Application_Security__c> appSecs = new ApplicationSecuritySelector().selectByApplicationId(appId);
        if (!appSecs.isEmpty() && appSecs.size() > 0 && appSecs != null) {
            // get Securities Offered
			List<Application_Security__c> existingSuretyships = new List<Application_Security__c>();
			List<Application_Security__c> existingGeneralCessions = new List<Application_Security__c>();
			List<Application_Security__c> existingMortgageBonds = new List<Application_Security__c>();
			List<Application_Security__c> existingGeneralNotarialBonds = new List<Application_Security__c>();
			List<Application_Security__c> existingSpecialNotarialBonds = new List<Application_Security__c>();
			for (Application_Security__c sec : appSecs) {
				sec.Limited_pledge__c = sec.Limited_pledge__c == 'Y' ? 'Limited' : sec.Limited_pledge__c == 'N' ? 'Unlimited' : sec.Limited_pledge__c;
                sec.Limited_Surety__c = sec.Limited_Surety__c == 'Y' ? 'Limited' : sec.Limited_Surety__c == 'N' ? 'Unlimited' : sec.Limited_Surety__c;
				switch on sec.Security_Type__c {
					when 'Suretyship' {
						existingSuretyships.add(sec);
						contextBuilder.add('existingSuretyshipIndicator', 'YES');
					}
					when 'Bonds and 99-year Leasehold' {
						if (sec.Bond_type__c == 'MBOND - MORTGAGE BOND') {
							existingMortgageBonds.add(sec);
							contextBuilder.add('existingMBIndicator', 'YES');
						}
						if (sec.Bond_type__c == 'GNBOND - GENERAL NOTARIAL BOND'){
							existingGeneralNotarialBonds.add(sec);
							contextBuilder.add('existingGNBIndicator', 'YES');
						}
						if (sec.Bond_type__c == 'SNBOND - SPECIAL NOTARIAL BOND'){
							existingSpecialNotarialBonds.add(sec);
							contextBuilder.add('existingSNBIndicator', 'YES');
						}
					}
					when 'General Pledge' {
						existingGeneralCessions.add(sec);
						contextBuilder.add('existingCessionPledgeIndicator', 'YES');
					}
					when 'Cession of Internal Investments', 'Cession of External Investments', 'Cession of Life Policy (Link) (Sanlam)', 'Cession of Life Policy (Not Link)' {
						existingGeneralCessions.add(sec);
						contextBuilder.add('existingCessionPledgeIndicator', 'YES');
					}
					when else {
						contextBuilder.add('existingOtherIndicator', 'YES');
					}
				}
			}
			contextBuilder.add('existingSuretyships', existingSuretyships);
			contextBuilder.add('existingMortgageBonds', existingMortgageBonds);
			contextBuilder.add('existingGeneralNotarialBonds', existingGeneralNotarialBonds);
			contextBuilder.add('existingSpecialNotarialBonds', existingSpecialNotarialBonds);
			contextBuilder.add('existingGeneralCessions', existingGeneralCessions);
			contextBuilder.add('existingSecurities', 'YES');
        }
        return contextBuilder;
    }

/**
 * @description generateFacilityLetter Credit Docs
 *
 * @param ApplicationProductId (Id): ApplicationProductId
 * @param templateName (String): templateName
 * @return Map<String,String>: Return description
 */
	public static Map<String, String> generateFacilityLetter(Id ApplicationProductId, String templateName) {
		Map<String, String> result = new Map<String, String>();
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
		try{
			id opportunityId = null;
			Application_Product__c appProdRec = new Application_Product__c();

			if (DocumentController.getParentObjectName(ApplicationProductId) == 'Application_Product__c') {
				appProdRec = new ApplicationProductSelector().selectApplicationProductById(ApplicationProductId);
				opportunityId = appProdRec?.Opportunity__c;
			}
			Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);
            Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);
			Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
            Account accountRecord = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);

            // this is what masimba is pushing us to use ina new supposedly simplified way
			DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
            DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();

			// get Securities Offered
			List<Security_Offered__c> secList = new securitiesOfferedSelector().selectByApplicationId(application.Id);
			List<Security_Offered__c> newSuretyships = new List<Security_Offered__c>();
			List<Security_Offered__c> newGeneralCessions = new List<Security_Offered__c>();
			List<Security_Offered__c> newMortgageBonds = new List<Security_Offered__c>();
			List<Security_Offered__c> newGeneralNotarialBonds = new List<Security_Offered__c>();
			List<Security_Offered__c> newSpecialNotarialBonds = new List<Security_Offered__c>();
			for (Security_Offered__c sec : secList) {
				sec.Limited_Cession__c = sec.Limited_Cession__c == 'Y' ? 'Limited' : sec.Limited_Cession__c == 'N' ? 'Unlimited' : sec.Limited_Cession__c;
				switch on sec.Security_Type__c {
					when 'Suretyship' {
						sec.Cession_of_Loan_Account_limited__c = sec.Cession_of_Loan_Account_limited__c == 'Yes' ? 'Limited' : sec.Cession_of_Loan_Account_limited__c == 'No' ? 'Unlimited' : sec.Cession_of_Loan_Account_limited__c;
						sec.Cession_of_Loan_Account_included__c = sec.Cession_of_Loan_Account_included__c == 'Yes' ? 'YES' : sec.Cession_of_Loan_Account_included__c == 'No' ? 'NO' : sec.Cession_of_Loan_Account_included__c;
						sec.Client_Name__c = sec.External_Entity_Linked__c == true ? '' : sec.External_Entity_Linked__c == false ? sec.Client_Name__c : sec.Client_Name__c;
						newSuretyships.add(sec);
						contextBuilder.add('newSuretyshipIndicator', 'YES');
					}
					when 'Bonds and 99-year Leasehold' {
						if (sec.Bond_type__c == 'MBOND - MORTGAGE BOND') {
							newMortgageBonds.add(sec);
							contextBuilder.add('newMBIndicator', 'YES');
						}
						if (sec.Bond_type__c == 'GNBOND - GENERAL NOTARIAL BOND'){
							newGeneralNotarialBonds.add(sec);
							contextBuilder.add('newGNBIndicator', 'YES');
						}
						if (sec.Bond_type__c == 'SNBOND - SPECIAL NOTARIAL BOND'){
							newSpecialNotarialBonds.add(sec);
							contextBuilder.add('newSNBIndicator', 'YES');
						}
					}
					when 'General Pledge' {
						newGeneralCessions.add(sec);
						contextBuilder.add('newCessionPledgeIndicator', 'YES');
					}
					when 'Cession of Internal Investments', 'Cession of External Investments', 'Cession of Life Policy (Link) (Sanlam)', 'Cession of Life Policy (Not Link)' {
						newGeneralCessions.add(sec);
						contextBuilder.add('newCessionPledgeIndicator', 'YES');
					}
					when else {
						contextBuilder.add('newOtherIndicator', 'YES');
					}
				}
			}
			contextBuilder.add('newSuretyships', newSuretyships);
			contextBuilder.add('newMortgageBonds', newMortgageBonds);
			contextBuilder.add('newGeneralNotarialBonds', newGeneralNotarialBonds);
			contextBuilder.add('newSpecialNotarialBonds', newSpecialNotarialBonds);
			contextBuilder.add('newGeneralCessions', newGeneralCessions);

            // do existing securities here
            contextBuilder = existingSecurities(contextBuilder, application.Id);

			// get addresses

            List<Address__c> addresses = new AddressesSelector().addressesRelatedToAcc(opp.AccountId);
            if (!addresses.isEmpty() && addresses.size() > 0 && addresses != null){
                List<Address__c> physicalAddress = new List<Address__c>();
				List<Address__c> businessAddress = new List<Address__c>();

                for (Address__c address : addresses) {
                    switch on address.Address_Type__c {
                        when 'Physical Address' {
                            physicalAddress.add(address);
                        }
						when 'Business Address' {
                            businessAddress.add(address);
                        }
                    }
                }
				if (accountRecord.Client_Type__c == 'Sole Trader' || accountRecord.Client_Type__c == 'Sole Proprietor (Foreign Nationals)'
				|| accountRecord.Client_Type__c == 'Sole Proprietor' || accountRecord.Client_Type__c == 'Private Individual'
				|| accountRecord.Client_Type__c == 'Individual - Minor' || accountRecord.Client_Type__c == 'Individual') {
					if (!physicalAddress.isEmpty() && physicalAddress.size() > 0 && physicalAddress != null)
						contextBuilder.add('Address', physicalAddress.get(0));
				} else {
					if (!businessAddress.isEmpty() && businessAddress.size() > 0 && businessAddress != null)
						contextBuilder.add('Address', businessAddress.get(0));
				}
            }

			//GenerateQuoteController gqc = new GenerateQuoteController();
			//GenerateQuoteController.FacilityWrapper prWrapper = new GenerateQuoteController.FacilityWrapper();
			if (appProdRec.Product_Facility_Json__c != '' && appProdRec.Product_Facility_Json__c != null){
				GenerateQuoteController.FacilityWrapper prWrapper  = (GenerateQuoteController.FacilityWrapper) System.JSON.deserialize(appProdRec.Product_Facility_Json__c, GenerateQuoteController.FacilityWrapper.class);

				//prWrapper = (GenerateQuoteController.FacilityWrapper) System.JSON.deserialize(appProdRec.Product_Facility_Json__c, GenerateQuoteController.FacilityWrapper.Class);
				prWrapper.isGeneralFacilitySelected = prWrapper.isGeneralFacilitySelected == 'Yes' ? 'YES' : prWrapper.isGeneralFacilitySelected == 'No' ? 'NO' : prWrapper.isGeneralFacilitySelected;
				prWrapper.ReviewType = prWrapper.ReviewType == 'Amount' ? 'RAND' : prWrapper.ReviewType == 'Percentage' ? 'PERCENTAGE' : prWrapper.ReviewType;
				if (prWrapper.facilityTypeSelected != null) {
					if (prWrapper.facilityTypeSelected.contains('Overdraft Facility')) {
						contextBuilder.add('GBFFacilityODIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Local Guarantees Facility')) {
						contextBuilder.add('GBFFacilityLGIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Revolving Loan Facility')) {
						contextBuilder.add('GBFFacilityRLIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Overnight Facility')) {
						contextBuilder.add('GBFFacilityONIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Foreign Guarantees Facility')) {
						contextBuilder.add('GBFFacilityFGIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Letters of Credit Facility (sight or usance)')) {
						contextBuilder.add('GBFFacilityLOCIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Business Credit Card Facility')) {
						contextBuilder.add('GBFFacilityBCCIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Offshore Loans')) {
						contextBuilder.add('GBFFacilityOLIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Fleet Card Facility')) {
						contextBuilder.add('GBFFacilityFCIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Daylight Limit')) {
						contextBuilder.add('GBFFacilityDLIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('ACB Facility')) {
						contextBuilder.add('GBFFacilityACBIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Forward Exchange Contracts Facility')) {
						contextBuilder.add('GBFFacilityFECIndicator', 'YES');
					}
					if (prWrapper.facilityTypeSelected.contains('Customer Foreign Currency Account')) {
						contextBuilder.add('GBFFacilityCFCIndicator', 'YES');
					}
				}

				if (prWrapper.facilitiesSelected != null){
					if (prWrapper.facilitiesSelected.contains('This Agreement signed by both parties.')) {
						contextBuilder.add('ThisAgmtIndicator', 'YES');
					}
					if (prWrapper.facilitiesSelected.contains('A copy of your board resolution and constitutional documents.')) {
						contextBuilder.add('BoardResIndicator', 'YES');
					}
					if (prWrapper.facilitiesSelected.contains('A signed copy of the electronic communication indemnity.')) {
						contextBuilder.add('ElectCommsIndicator', 'YES');
					}
					if (prWrapper.facilitiesSelected.contains('In a form acceptable to us, the Security.')) {
						contextBuilder.add('SecurityIndicator', 'YES');
					}
					if (prWrapper.facilitiesSelected.contains('Certified copies of any resolutions required in terms of applicable laws to make the Security effective.')) {
						contextBuilder.add('CertCopiesIndicator', 'YES');
					}
					if (prWrapper.facilitiesSelected.contains('Any information or documentation as required by us, including any Financial Intelligence Centre Act, 2001 ("FICA") information.')) {
						contextBuilder.add('InfoDocIndicator', 'YES');
					}
					if (prWrapper.facilitiesSelected.contains('There are no Conditions Precedent.')) {
						contextBuilder.add('NoCondIndicator', 'YES');
					}
				}
				if (prWrapper.specialConditionsSelected != null){
					if (prWrapper.specialConditionsSelected.contains('Subordination Agreement in terms of which all claims by your shareholder(s)/director(s) [INSERT NAME OF SHAREHOLDER OR DIRECTOR(S)] are subordinated in favour of any claims by us.')) {
						contextBuilder.add('SubOrdInd', 'YES');
					}
					if (prWrapper.specialConditionsSelected.contains('Negative Pledge: You shall not create or agree to create or permit to subsist (other than in our favour) any Security over assets that have been secured to us.')) {
						contextBuilder.add('NegPledgeInd', 'YES');
					}
					if (prWrapper.specialConditionsSelected.contains('[There are no Special Conditions].')) {
						contextBuilder.add('NoSpecialCondIndicator', 'YES');
					}
					if (prWrapper.specialConditionsSelected.contains('Other.')) {
						contextBuilder.add('OtherInd', 'YES');
					}
				}

				contextBuilder.add('FacilityWrapper', prWrapper);
				contextBuilder.add('ApplicationProduct', appProdRec);
			}

			if (currentUser != null){
				contextBuilder.add('User', currentUser);
				// hopefully this is the branch
				if (currentUser.SiteCode__c != '' && currentUser.SiteCode__c != null){
					List<Site__c> siteData = new SitesSelector().selectBySiteCode(currentUser.SiteCode__c);
					if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null)
						contextBuilder.add('Site', siteData.get(0));
				}
			}

						// this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
			Datetime dt = Datetime.now();
			contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
			contextBuilder.add('shorttoday', dt.format('yyyy-MM-dd'));
			contextBuilder.add('showUSCitizens', false);
			// end dirty fix
			System.debug('>>>>Done with building data>>>');
			String req = contextBuilder.serialize(documentTemplate.XML__c);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			System.debug(req);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

			CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
			System.debug('serialise response ' + JSON.serialize(response));
			Document__c doc = new Document__c();
			doc.Name = documentTemplate.Name.left(75)+'.pdf';
			doc.Type__c = documentTemplate.Document_Type__c;
			doc.Reference__c = response.contentStoreToken;
			doc.Opportunity__c = opp.Id;
			doc.Application_Product__c = ApplicationProductId;
			doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
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
	}

/**
 * @description generateOverdraftQuoteAgreement description
 *
 * @param appProdId (Id): appProdId
 * @param templateName (String): templateName
 * @return Map<String,String>: Return description
 */
	public static Map<String, String> generateOverdraftQuoteAgreement(Id appProdId, String templateName) {
        Map<String, String> result = new Map<String, String>();
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
		// this is what masimba is pushing us to use ina new supposedly simplified way
		DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new Document_Template__c();
		Opportunity opp = new Opportunity();
		Account accountRecord = new Account();
		Application_Product__c appProdRec = new Application_Product__c();
		try{
            // get app prod
            appProdRec = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            if (appProdRec != null){
                GenerateQuoteController gqc = new GenerateQuoteController();
                GenerateQuoteController.QuoteWrapper prWrapper = new GenerateQuoteController.QuoteWrapper();

				system.debug('appProdRec.Product_Quote_Json__c ' + appProdRec.Product_Quote_Json__c);
				if (appProdRec.Product_Quote_Json__c != '' && appProdRec.Product_Quote_Json__c != null){
					prWrapper = (GenerateQuoteController.QuoteWrapper) System.JSON.deserialize(appProdRec.Product_Quote_Json__c, GenerateQuoteController.QuoteWrapper.Class);
					if (prWrapper.Commision.toUpperCase() == 'NO')
						prWrapper.Commision = '0.00';
					if (prWrapper.additionalCharges.toUpperCase() == 'NO')
						prWrapper.additionalCharges = '0.00';
					contextBuilder.add('QuoteWrapper', prWrapper);
					contextBuilder.add('ApplicationProduct', appProdRec);
				}

				opp = new OpportunitiesSelector().selectByOpportunityId(appProdRec.Opportunity__c).get(0);
				accountRecord = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);

				contextBuilder.add('Opportunity', opp);
				contextBuilder.add('Account', accountRecord);

				// get addresses
				List<Address__c> addresses = new AddressesSelector().addressesRelatedToAcc(opp.AccountId);
				if (!addresses.isEmpty() && addresses.size() > 0 && addresses != null){
					List<Address__c> OperatingAddress = new List<Address__c>();
					List<Address__c> PostalAddress = new List<Address__c>();
					List<Address__c> PhysicalAddress = new List<Address__c>();
					List<Address__c> ResidentialAddress = new List<Address__c>();
					List<Address__c> employersAddress = new List<Address__c>();
					List<Address__c> RegisteredAddress = new List<Address__c>();
					List<Address__c> BusinessAddress = new List<Address__c>();
					List<Address__c> MasterCourtAddress = new List<Address__c>();
					List<Address__c> HeadOfficeAddress = new List<Address__c>();

					for (Address__c address : addresses) {
						switch on address.Address_Type__c {
							when 'OperatingAddress' {
								OperatingAddress.add(address);
							}
							when 'Postal' {
								PostalAddress.add(address);
							}
							when 'Physical Address' {
								PhysicalAddress.add(address);
							}
							when 'Residential' {
								ResidentialAddress.add(address);
							}
							when 'Employers' {
								employersAddress.add(address);
							}
							when 'Registered' {
								if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
									RegisteredAddress.add(address);
							}
							when 'Business Address' {
								if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
									BusinessAddress.add(address);
							}
							when 'Master of High Court' {
								if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
									MasterCourtAddress.add(address);
							}
							when 'Head Office' {
								if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor')
									HeadOfficeAddress.add(address);
							}
						}
					}
					if (!OperatingAddress.isEmpty() && OperatingAddress.size() > 0 && OperatingAddress != null)
						contextBuilder.add('OperatingAddress', OperatingAddress.get(0));

					if (!PostalAddress.isEmpty() && PostalAddress.size() > 0 && PostalAddress != null)
						contextBuilder.add('PostalAddress', PostalAddress.get(0));

					if (!PhysicalAddress.isEmpty() && PhysicalAddress.size() > 0 && PhysicalAddress != null)
						contextBuilder.add('PhysicalAddress', PhysicalAddress.get(0));

					if (!ResidentialAddress.isEmpty() && ResidentialAddress.size() > 0 && ResidentialAddress != null)
						contextBuilder.add('ResidentialAddress', ResidentialAddress.get(0));

					if (!employersAddress.isEmpty() && employersAddress.size() > 0 && employersAddress != null)
						contextBuilder.add('EmployersAddress', employersAddress.get(0));

					if (!RegisteredAddress.isEmpty() && RegisteredAddress.size() > 0 && RegisteredAddress != null)
						contextBuilder.add('RegisteredAddress', RegisteredAddress.get(0));

					if (!BusinessAddress.isEmpty() && BusinessAddress.size() > 0 && BusinessAddress != null)
						contextBuilder.add('BusinessAddress', BusinessAddress.get(0));

					if (!MasterCourtAddress.isEmpty() && MasterCourtAddress.size() > 0 && MasterCourtAddress != null)
						contextBuilder.add('MasterCourtAddress', MasterCourtAddress.get(0));

					if (!HeadOfficeAddress.isEmpty() && HeadOfficeAddress.size() > 0 && HeadOfficeAddress != null)
						contextBuilder.add('HeadOfficeAddress', HeadOfficeAddress.get(0));
				}

				if (accountRecord.Client_Type__c == 'Sole Trader' || accountRecord.Client_Type__c == 'Sole Proprietor'){
					contextBuilder.add('soleTrader', 'YES');
				}

                //if (appProdRec.Agreement_Category__c == '' || appProdRec.Agreement_Category__c == null){
                    /*result.put('success', 'false');
                    result.put('message', 'Error generating document - There is no assocoiated Agreement_Category__c');
                    system.debug('Error generating document - There is no assocoiated Agreement_Category__c');
                    return result;*/
                //}
                switch on appProdRec.Agreement_Category__c{
                    when 'I', 'L' {
                        documentTemplate = new DocumentTemplateSelector().selectTemplateByName('ABSA 5701 - Overdraft Quotation and Agreement (Intermediate and Large)');
                    }
                    when 'S' {
                        documentTemplate = new DocumentTemplateSelector().selectTemplateByName('ABSA 5702 - Overdraft Quotation and Agreement (Small)');
                    }
                    when else {
						documentTemplate = new DocumentTemplateSelector().selectTemplateByName('ABSA 5701 - Overdraft Quotation and Agreement (Intermediate and Large)');
                        /*result.put('success', 'false');
                        result.put('message', 'Error generating document - There is no assocoiated valid Agreement Type/Category');
                        system.debug('Error generating document - There is no assocoiated valid Agreement Type/Category');
                        return result;*/
                    }
                }
            } else {
                result.put('success', 'false');
                result.put('message', 'Error generating document - There is no assocoiated Application_Product__c');
                system.debug('Error generating document - There is no assocoiated Application_Product__c');
                return result;
            }

            system.debug('done with app prod');

            if (currentUser != null){
                contextBuilder.add('User', currentUser);
                // hopefully this is the branch
                if (currentUser.SiteCode__c != '' && currentUser.SiteCode__c != null){
                    List<Site__c> siteData = new SitesSelector().selectBySiteCode(currentUser.SiteCode__c);
                    if (!siteData.isEmpty() && siteData.size() > 0 && siteData != null)
                        contextBuilder.add('Site', siteData.get(0));
                }
            }

            			// this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
			Datetime dt = Datetime.now();
			contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
			contextBuilder.add('shorttoday', dt.format('yyyy-MM-dd'));
			contextBuilder.add('showUSCitizens', false);
			// end dirty fix
			System.debug('>>>>Done with building data>>>');
			String req = contextBuilder.serialize(documentTemplate.XML__c);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			System.debug(req);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

			CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
			System.debug('serialise response ' + JSON.serialize(response));
			Document__c doc = new Document__c();
			doc.Name = documentTemplate.Name.left(75)+'.pdf';
			doc.Type__c = documentTemplate.Document_Type__c;
			doc.Reference__c = response.contentStoreToken;
			doc.Opportunity__c = opp.Id;
			doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
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
	}
}