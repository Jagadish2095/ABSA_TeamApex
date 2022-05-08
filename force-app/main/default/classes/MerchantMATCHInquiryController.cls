public class MerchantMATCHInquiryController {

    // Method to get existing Merchant Risk Records
    // @Param : Opportunity Id
    // @return: List Merchant_Risk_Check__c
    @AuraEnabled
    public static List<Merchant_Risk_Check__c> getMerchantRiskCheckRecords (String oppId) {

        List<Merchant_Risk_Check__c> merchantCheckList = new MerchantRiskChecksSelector().selectByOpportunityId(oppId);

        if(merchantCheckList != null && merchantCheckList.size() > 0) {
            return merchantCheckList;
        } else {
            return null;
        }

    }

    // Method to format the data for View Match Inquiry Result
    // Tinashe M Shoko
    // 29-06-2020
    // @Param : unformatted MatchTerminationInquiry_Resp_IB_v1 json
    // @return: formatted MatchTerminationInquiry_Resp_IB_v1 json
    @AuraEnabled
    public static string getMatchTerminationInquiry_Resp_IB_v1List(string jsonStr) {
        List<MatchTerminationInquiry_Resp_IB_v1> mtirList = new List<MatchTerminationInquiry_Resp_IB_v1>();
        MatchTerminationInquiry_Resp_IB_v1 tmp = (MatchTerminationInquiry_Resp_IB_v1)JSON.deserialize(jsonStr, MatchTerminationInquiry_Resp_IB_v1.class);
        mtirList.add(tmp);
        return JSON.serialize(mtirList);
    }

    // Method to format the data for View Match Inquiry Result
    // Tinashe M Shoko
    // 29-06-2020
    // @Param : unformatted MatchTerminationInquiry_Req_IB_v1 json
    // @return: formatted MatchTerminationInquiry_Req_IB_v1 json
    @AuraEnabled
    public static string getMatchTerminationInquiry_Req_IB_v1List(string jsonStr) {
        List<MatchTerminationInquiry_Req_IB_v1> mtirList = new List<MatchTerminationInquiry_Req_IB_v1>();
        MatchTerminationInquiry_Req_IB_v1 tmp = (MatchTerminationInquiry_Req_IB_v1)JSON.deserialize(jsonStr, MatchTerminationInquiry_Req_IB_v1.class);
        mtirList.add(tmp);
        return JSON.serialize(mtirList);
    }

    //Commented by Himani as part of changes for #W-005294
    // Method to get Opportunity Record
    // @Param : Opportunity Id
    // @return: Opportunity
    // @AuraEnabled
    // public static Opportunity getOpportunityRecord (String oppId) {

    //     //Get Opportunity Record
    //     Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);

    //     return oppRecord;
    // }

    // Method to call Match Risk Service
    // @Param : Opportunity Id
    // @return: String of Match Termination response
    @AuraEnabled
    public static String callMatchTerminationService (String oppId,  List<Merchant_Risk_Check__c> existingMatchRiskRecords){

        Set<String> accountIds = new Set<String>();

        //Map format - <AccountId , Map<AddressType, Address_c>>
        Map<String, Map<String, Address__c>> accountAddressMap = new Map<String, Map<String, Address__c>>();

        //Get Opportunity Record
        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);

        //Get Merchant details
        Account merchantRecord = new AccountsSelector().selectByOpportunityId(oppId);
        accountIds.add(merchantRecord.id);

        //Get Principal details and add to Set
        List<AccountContactRelation> principalRecords = new AccountContactRelationSelector().selectRelationByAccountId(merchantRecord.Id);
        for (AccountContactRelation eachRelation : principalRecords) {
            accountIds.add(eachRelation.AccountId);
        }

        //Get all addresses for Merchant and Principals and add to Map
        List<Address__c> addressList = new AddressesSelector().selectByAccountIds(accountIds);
        for(Address__c eachAddress : addressList) {
            if(!accountAddressMap.containsKey(eachAddress.Account__c)) {
                accountAddressMap.put(eachAddress.Account__c, new Map<String, Address__c>());
            }
            accountAddressMap.get(eachAddress.Account__c).put(eachAddress.Address_Type__c, eachAddress);
        }

        //Call method to create the request bean
        MatchTerminationInquiry_Req_IB_v1 matchRequestBean = createMatchRequestBean(oppId, merchantRecord, principalRecords, accountAddressMap);

        //Call Match Service
        MatchTerminationInquiry_Resp_IB_v1 matchResponseBean = MatchTerminationInquiry_IH_v1.MatchTerminationInquiry(matchRequestBean);

        if(matchResponseBean != null) {

            List<Merchant_Risk_Check__c> merchantRiskCheckInsert = new List<Merchant_Risk_Check__c>();

            if(matchResponseBean.TerminationInquiry != null && matchResponseBean.TerminationInquiry.PossibleMerchantMatches != null && matchResponseBean.TerminationInquiry.PossibleMerchantMatches.size() > 0 && matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant != null) {

                Integer merchantCount = 0;

                for(MatchTerminationInquiry_Resp_IB_v1.TerminatedMerchant eachMerchantMatch : matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant) {

                    Merchant_Risk_Check__c merchantRiskCheck = new Merchant_Risk_Check__c();
                    //merchantRiskCheck.Account__c = '';

                    if(matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant != null) {
                        merchantRiskCheck.Business_Name__c = matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.Name;
                        merchantRiskCheck.City__c = matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.Address.City;
                        merchantRiskCheck.Country__c  = matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.Address.Country;

                        if(String.isBlank(matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.AddedOnDate) == false) {
                            List<String> dateSplit = matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.AddedOnDate.split('/');

                            if(dateSplit != null && dateSplit.size() > 1) {
                                merchantRiskCheck.Date_Added_On__c  = Date.newInstance(Integer.valueOf(dateSplit[2]),Integer.valueOf(dateSplit[0]),Integer.valueOf(dateSplit[1]));
                                matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.AddedOnDate = String.valueOf(merchantRiskCheck.Date_Added_On__c);
                            }
                        }

                        merchantRiskCheck.Match_Type__c  = 'Possible Merchant Match';
                        merchantRiskCheck.Opportunity__c  = oppId;

                        //Get translation for Termination Reason Code
                        String terminationReasonCodeValue = matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.TerminationReasonCode;
                        if(terminationReasonCodeValue != null) {
                            String terminationReasonCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('MATCH', 'Termination Reason Code', terminationReasonCodeValue, StringConstants.INBOUND_RECORD_TYPE);
                            merchantRiskCheck.Termination_Reason_Code__c  = terminationReasonCodeTranslated;
                            matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].Merchant.TerminationReasonCode = terminationReasonCodeTranslated;
                        }

                    }

                    if(matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].MerchantMatch != null) {
                        //Get translation for Response Code
                        String responseCodeValue = matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].MerchantMatch.Name;
                        if(responseCodeValue != null) {
                            String responseCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('MATCH', 'Response Code', responseCodeValue, StringConstants.INBOUND_RECORD_TYPE);
                            merchantRiskCheck.Response_Code__c  = responseCodeTranslated;
                            matchResponseBean.TerminationInquiry.PossibleMerchantMatches[0].TerminatedMerchant[merchantCount].MerchantMatch.Name = responseCodeTranslated;
                        }
                    }

                    merchantRiskCheck.JSON_Response__c = matchResponseBean.serialize(matchResponseBean);
                    //String.valueOf(matchResponseBean);
                    merchantRiskCheck.JSON_Request__c = matchRequestBean.serialize(matchRequestBean);
                    merchantRiskCheckInsert.add(merchantRiskCheck);

                    merchantCount = merchantCount + 1;

                }
            }

            if(matchResponseBean.TerminationInquiry != null && matchResponseBean.TerminationInquiry.PossibleInquiryMatches != null && matchResponseBean.TerminationInquiry.PossibleInquiryMatches.size() > 0 && matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant != null) {

                Integer merchantCount = 0;

                for(MatchTerminationInquiry_Resp_IB_v1.InquiredMerchant eachMerchantMatch : matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant) {

                    Merchant_Risk_Check__c merchantRiskCheck = new Merchant_Risk_Check__c();

                    if(matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant[0].Merchant != null) {
                        //merchantRiskCheck.Account__c = '';
                        merchantRiskCheck.Business_Name__c = matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant[0].Merchant.Name;
                        merchantRiskCheck.City__c = matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant[0].Merchant.Address.City;
                        merchantRiskCheck.Country__c  = matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant[0].Merchant.Address.Country;
                        merchantRiskCheck.Match_Type__c  = 'Possible Inquiry Match';
                        merchantRiskCheck.Opportunity__c  = oppId;

                        if(matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant[0].MerchantMatch != null) {
                            //Get translation for Response Code
                            String responseCodeValue = matchResponseBean.TerminationInquiry.PossibleInquiryMatches[0].InquiredMerchant[0].MerchantMatch.Name;
                            if(responseCodeValue != null) {
                                String responseCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('MATCH', 'Response Code', responseCodeValue, StringConstants.INBOUND_RECORD_TYPE);
                                merchantRiskCheck.Response_Code__c  = responseCodeTranslated;
                            }
                        }
                        merchantRiskCheck.JSON_Response__c = matchResponseBean.serialize(matchResponseBean);
                        //String.valueOf(matchResponseBean);
                        merchantRiskCheck.JSON_Request__c = matchRequestBean.serialize(matchRequestBean);
                        merchantRiskCheckInsert.add(merchantRiskCheck);
                    }

                    merchantCount = merchantCount + 1;

                }

            }

            if(merchantRiskCheckInsert != null && merchantRiskCheckInsert.size() > 0 ) {

                try {
                    //Insert new Merchant Match Check records
                    insert merchantRiskCheckInsert;

                    //Commented by Himani as part of changes for #W-005294
                    // //Set Match indicator on Opportunity
                    // oppRecord.Merchant_Match_Inquiry_Passed__c = false;
                    // //oppRecord.Approval_Required__c = true;
                    // oppRecord.Trigger_Approval_Process__c = 'Match Risk Check';
                    // update oppRecord;

                    //Delete old Merchant Match Check Records as we do not currently have a unique identifier to uodate existing records
                    //The latest records should be shown on UI
                    if(existingMatchRiskRecords != null && existingMatchRiskRecords.size() > 0) {
                        delete existingMatchRiskRecords;
                    }
                }  catch(Exception ex) {
                    //throw all other exception message
                    System.debug('Exception in MerchantMatcgInquiryController - ' + ex.getMessage());
                    throw new AuraHandledException(ex.getMessage());
                }
            } else {
                //Commented by Himani as part of changes for #W-005294
                //Set Match indicator on Opportunity
                // if(matchResponseBean.statusCode == 200) {
                //     oppRecord.Merchant_Match_Inquiry_Passed__c = true;
                //     update oppRecord;
                // }
            }
        }

        System.debug('se### ' + matchResponseBean.serialize(matchResponseBean));
        return matchResponseBean.serialize(matchResponseBean);
    }

    // Method to create the request bean for Match Service
    // @Param : Merchant (Account), Addresses and List of Principals (Accounts)
    // @return: MatchTerminationInquiry_Req_IB_v1
    public static MatchTerminationInquiry_Req_IB_v1 createMatchRequestBean (String OpportunityId, Account merchantDetails, List<AccountContactRelation> principalsDetails,  Map<String, Map<String, Address__c>> addressMap) {

        if(merchantDetails != null) {

            //Get salesforce instance
            Organization salesforceOrg = [SELECT IsSandbox FROM Organization LIMIT 1];
            String acquirerIdValue;

            //Set AcquiryId based on Sandbox or Production
            if(salesforceOrg.IsSandbox == true) {
                acquirerIdValue = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('MATCH', 'Acquirer Id', 'Sandbox', StringConstants.OUTBOUND_RECORD_TYPE);
            } else {
                acquirerIdValue = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('MATCH', 'Acquirer Id', 'Production', StringConstants.OUTBOUND_RECORD_TYPE);
            }

            MatchTerminationInquiry_Req_IB_v1 requestBean = new MatchTerminationInquiry_Req_IB_v1();
            requestBean.TerminationInquiryRequest = new MatchTerminationInquiry_Req_IB_v1.TerminationInquiryRequest();
            requestBean.TerminationInquiryRequest.Merchant = new MatchTerminationInquiry_Req_IB_v1.Merchant();
            requestBean.TerminationInquiryRequest.Merchant.Address = new MatchTerminationInquiry_Req_IB_v1.Address();
            requestBean.TerminationInquiryRequest.Merchant.Principal = new List<MatchTerminationInquiry_Req_IB_v1.Principal>();
            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria = new MatchTerminationInquiry_Req_IB_v1.SearchCriteria();
            //requestBean.TerminationInquiryRequest.Merchant.UrlGroup = new List<MatchTerminationInquiry_Req_IB_v1.UrlGroup>(); // removed for INC1908382 - Tinashe m Shoko
            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Region = new List<String>();
            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Country = new List<String>();

            requestBean.TerminationInquiryRequest.AcquirerId = acquirerIdValue;
            requestBean.TerminationInquiryRequest.TransactionReferenceNumber = OpportunityId.left(15);

            requestBean.TerminationInquiryRequest.Merchant.Name = merchantDetails.Name;
            requestBean.TerminationInquiryRequest.Merchant.DoingBusinessAsName = '';
            requestBean.TerminationInquiryRequest.Merchant.PhoneNumber = '';
            requestBean.TerminationInquiryRequest.Merchant.AltPhoneNumber = '';
            requestBean.TerminationInquiryRequest.Merchant.NationalTaxId = '';
            requestBean.TerminationInquiryRequest.Merchant.CountrySubdivisionTaxId = '';
            requestBean.TerminationInquiryRequest.Merchant.ServiceProvLegal = '';
            requestBean.TerminationInquiryRequest.Merchant.ServiceProvDBA = '';
            requestBean.TerminationInquiryRequest.Merchant.Url = '';
            requestBean.TerminationInquiryRequest.Merchant.AddedOnDate = '';
            requestBean.TerminationInquiryRequest.Merchant.TerminationReasonCode = '';
            requestBean.TerminationInquiryRequest.Merchant.AddedByAcquirerID = '';

            //Get Merchant Business Address for request mapping
            if(addressMap != null && addressMap.containsKey(merchantDetails.Id)) {

                if(addressMap.get(merchantDetails.Id).containsKey('Business Address')) {

                    requestBean.TerminationInquiryRequest.Merchant.Address.Line1 = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Street__c;
                    requestBean.TerminationInquiryRequest.Merchant.Address.Line2 = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Suburb__c;
                    requestBean.TerminationInquiryRequest.Merchant.Address.City = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_City__c;
                    requestBean.TerminationInquiryRequest.Merchant.Address.CountrySubdivision = '';
                    requestBean.TerminationInquiryRequest.Merchant.Address.Province = '';
                    requestBean.TerminationInquiryRequest.Merchant.Address.PostalCode = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Zip_Postal_Code__c;
                    requestBean.TerminationInquiryRequest.Merchant.Address.Country = 'ZAF';

                }
            }

            //Get Principals Business Address for request mapping
            if(principalsDetails != null && principalsDetails.size() > 0) {

                Integer principalCounter = 1;
                for(AccountContactRelation eachPrinicipal : principalsDetails) {

                    MatchTerminationInquiry_Req_IB_v1.Principal newPrincipal = new MatchTerminationInquiry_Req_IB_v1.Principal();
                    newPrincipal.FirstName = eachPrinicipal.Contact.FirstName;
                    newPrincipal.MiddleInitial = eachPrinicipal.Contact.MiddleName;
                    newPrincipal.LastName = eachPrinicipal.Contact.LastName;
                    newPrincipal.PhoneNumber = eachPrinicipal.Contact.MobilePhone;
                    newPrincipal.AltPhoneNumber = '';
                    newPrincipal.NationalId = eachPrinicipal.Contact.ID_Number__c;

                    newPrincipal.DriversLicense = new MatchTerminationInquiry_Req_IB_v1.DriversLicense();
                    newPrincipal.DriversLicense.Number_Z = '';
                    newPrincipal.DriversLicense.CountrySubdivision = '';
                    newPrincipal.DriversLicense.Country = '';

                    newPrincipal.SearchCriteria = new MatchTerminationInquiry_Req_IB_v1.SearchCriteria();
                    newPrincipal.SearchCriteria.SearchAll = 'Y';
                    newPrincipal.SearchCriteria.MinPossibleMatchCount = '3';
                    newPrincipal.SearchCriteria.Region = new List<String>();
                    newPrincipal.SearchCriteria.Country = new List<String>();
                    newPrincipal.SearchCriteria.Region.add('');
                    newPrincipal.SearchCriteria.Country.add('');


                    if(addressMap != null && addressMap.containsKey(eachPrinicipal.AccountId) && addressMap.get(eachPrinicipal.AccountId).containsKey('Business Address')) {
                        newPrincipal.Address = new MatchTerminationInquiry_Req_IB_v1.Address();
                        newPrincipal.Address.Line1 = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Street__c;
                        newPrincipal.Address.Line2 = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Suburb__c;
                        newPrincipal.Address.City = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_City__c;
                        newPrincipal.Address.CountrySubdivision = '';
                        newPrincipal.Address.Province = '';
                        newPrincipal.Address.PostalCode = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Zip_Postal_Code__c;
                        newPrincipal.Address.Country = 'ZAF';
                    }

                    requestBean.TerminationInquiryRequest.Merchant.Principal.add(newPrincipal);
                    principalCounter = principalCounter + 1;
                    System.debug('principalCounter : ' + principalCounter);
                    //Simplex onboarding limited to 3 principals for now
                    if(principalCounter == 3) {
                        break;
                    }
                }
            }

            //If there is no principals for Sole Trader then pass merchant details as Principal
            else {
                MatchTerminationInquiry_Req_IB_v1.Principal newPrincipal = new MatchTerminationInquiry_Req_IB_v1.Principal();
                newPrincipal.FirstName = merchantDetails.Name;
                newPrincipal.MiddleInitial = '';
                newPrincipal.LastName = merchantDetails.Name;
                newPrincipal.PhoneNumber = '';
                newPrincipal.AltPhoneNumber = '';
                newPrincipal.NationalId = '';

                newPrincipal.DriversLicense = new MatchTerminationInquiry_Req_IB_v1.DriversLicense();
                newPrincipal.DriversLicense.Number_Z = '';
                newPrincipal.DriversLicense.CountrySubdivision = '';
                newPrincipal.DriversLicense.Country = '';

                newPrincipal.SearchCriteria = new MatchTerminationInquiry_Req_IB_v1.SearchCriteria();
                newPrincipal.SearchCriteria.SearchAll = 'Y';
                newPrincipal.SearchCriteria.MinPossibleMatchCount = '3';
                newPrincipal.SearchCriteria.Region = new List<String>();
                newPrincipal.SearchCriteria.Country = new List<String>();
                newPrincipal.SearchCriteria.Region.add('');
                newPrincipal.SearchCriteria.Country.add('');

                //Get Merchant Business Address for request mapping
                if(addressMap != null && addressMap.containsKey(merchantDetails.Id)) {

                    if(addressMap.get(merchantDetails.Id).containsKey('Business Address')) {
                        newPrincipal.Address = new MatchTerminationInquiry_Req_IB_v1.Address();
                        newPrincipal.Address.Line1 = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Street__c;
                        newPrincipal.Address.Line2 = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Suburb__c;
                        newPrincipal.Address.City = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_City__c;
                        newPrincipal.Address.CountrySubdivision = '';
                        newPrincipal.Address.Province = '';
                        newPrincipal.Address.PostalCode = addressMap.get(merchantDetails.Id).get('Business Address').Shipping_Zip_Postal_Code__c;
                        newPrincipal.Address.Country = 'ZAF';

                    }
                }

                requestBean.TerminationInquiryRequest.Merchant.Principal.add(newPrincipal);
            }

            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.SearchAll = 'Y';
            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.MinPossibleMatchCount = '3';
            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Region.add('');
            requestBean.TerminationInquiryRequest.Merchant.SearchCriteria.Country.add('');

            /** removed for INC1908382 - Tinashe m Shoko - start
            MatchTerminationInquiry_Req_IB_v1.UrlGroup newUrlGroup = new MatchTerminationInquiry_Req_IB_v1.UrlGroup();
            newUrlGroup.NoMatchUrls = new MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls();
            newUrlGroup.NoMatchUrls.Url = new List<String>();
            newUrlGroup.ExactMatchUrls = new List<MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls>();
            newUrlGroup.CloseMatchUrls = new List<MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls>();

            newUrlGroup.NoMatchUrls.Url.add('');

            MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls newExactMatchUrl = new MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls();
            newExactMatchUrl.Url = new List<String>();
            newExactMatchUrl.Url.add('');
            newUrlGroup.ExactMatchUrls.add(newExactMatchUrl);

            newExactMatchUrl = new MatchTerminationInquiry_Req_IB_v1.ExactMatchUrls();
            newExactMatchUrl.Url = new List<String>();
            newExactMatchUrl.Url.add('');
            newUrlGroup.CloseMatchUrls.add(newExactMatchUrl);

            requestBean.TerminationInquiryRequest.Merchant.UrlGroup.add(newUrlGroup);
            removed for INC1908382 - Tinashe m Shoko - end **/

            return requestBean;

        }else {
            return null;
        }
    }

}