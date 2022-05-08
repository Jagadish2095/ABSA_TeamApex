/**
 *
 * @description Service class for bcmscreatecase Service
 * @param
 * @author  Sandile Mathe
 *
 */

public class CAFCreateCasecontroller {
    /**
 *
 * @description Service class for sendCaseToBCMS Service
 * @param applicationId
 * @param sfCaseNumber
 * @author  Sandile Mathe
 * @return caseid
 *
 */
    @AuraEnabled
    public static CAFCreateCase_Resp_IB_v1 sendCaseToBCMS(String applicationId, String sfCaseNumber) {

        Application_Product_CAF__c apps = new ApplicationProductCAFSelector().selectByAppProdCAFId(applicationId);
        if (apps == null ) {
            throw new AuraHandledException('Application Product CAF record not found with Id: ' + applicationId);
        }
 
        Id clientId = apps.Client_Details__c;
        Boolean isUpdateNeeded = false;
        Long bussOriginatorRefNo;

        if (apps.Business_Originator_Reference_Number__c == null) {
            isUpdateNeeded = true;
            bussOriginatorRefNo = DateTime.now().getTime();
        } else {
            bussOriginatorRefNo = Long.valueOf(String.valueOf(apps.Business_Originator_Reference_Number__c));
        }

        Account accountRecord = new AccountsSelector().selectAccountFieldsCIFById(clientId);
        List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(clientId);
        List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(clientId);
        OpportunityLineItem oppProduct = new OpportunityLineItemsSelector().byApplicationProductCAF(applicationId);
        List<OpportunityLineItem> oppProductExtras = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oppProduct.Id, 'Extras');
        List<OpportunityLineItem> oppProductVaps = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oppProduct.Id, 'VAPs');
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppProduct.OpportunityId);

        Address__c addressHeadOffice;
        Address__c addressBusinessAddress;
        Address__c addressPostal;
        Address__c addressRegistered;
        String countryHeadOfficeTranslated;
        String countryBusinessAddressTranslated;
        String countryPostalTranslated;
        String countryRegisteredTranslated;

        for (Address__c address : addressList) {
            if (addressHeadOffice == null && address.Address_Type__c == 'Head Office') {
                addressHeadOffice = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryHeadOfficeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressHeadOffice.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            } else if (addressBusinessAddress == null && address.Address_Type__c == 'Business Address') {
                addressBusinessAddress = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryBusinessAddressTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressBusinessAddress.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            } else if (addressPostal == null && address.Address_Type__c == 'Postal') {
                addressPostal = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryPostalTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressPostal.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            } else if (addressRegistered == null && address.Address_Type__c == 'Registered') {
                addressRegistered = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryRegisteredTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressRegistered.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            }
        }

        //Translations
        String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accountRecord.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String comLanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountRecord.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountRecord.ShippingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String CountryOfRegTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountRecord.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountRecord.Country_of_Operation__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', accountRecord.Preferred_Communication_Method__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountRecord.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String financialYearEndTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Financial Year End', accountRecord.Financial_Year_End__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String section129NoticeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Section 129 Delivery', accountRecord.Preferred_delivery_method_Legal_Notices__c, StringConstants.OUTBOUND_RECORD_TYPE);

        string nodes = 'xmlns:xsd = http://www.w3.org/2001/XMLSchema';
        String node1 = 'http://www.w3.org/2001/XMLSchema-instance';

        //Build xml Structure
        Dom.Document doc = new Dom.Document();
        Dom.XmlNode xmlNodeRoot = doc.createRootElement('CreateAVAFApplication', null, null);
        xmlNodeRoot.setNamespace('xsi ', 'http://www.w3.org/2001/XMLSchema-instance');
        xmlNodeRoot.setNamespace('xsd ', 'http://www.w3.org/2001/XMLSchema');
        Integer SFDCLineID = 0;

        String accountTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Account Type', apps.Account_type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String paymentFrequencyTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Payment Frequency', apps.Payment_frequency__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String allianceCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Alliance Code', apps.Joint_venture_alliance_code__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String financeTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Finance Type', apps.Contract_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String assetTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'CAF Asset Type', apps.Asset_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);

        String equipmentType;
        String equipmentDesc;
        String make;
        String model;
        String mmCode;
        
        if (String.isNotBlank(assetTypeTranslated)) {
            equipmentType = assetTypeTranslated;
            equipmentDesc = '';
            Id vehicleMakeModel = apps.Vehicle_Make_Model_Id__c;
            if (String.isBlank(vehicleMakeModel)) {throw new AuraHandledException('Vehicle details are required, when Asset Type is not \'OTHER\'');}
            Vehicle_Make_Model__c vehicle = [SELECT Id, Make__c, Model__c, MM_Code__c FROM Vehicle_Make_Model__c WHERE Id =: apps.Vehicle_Make_Model_Id__c];
            make = vehicle.Make__c;
            model = vehicle.Model__c;
            mmCode = vehicle.MM_Code__c;
        } else {
            equipmentType = apps.Commercial_asset_finance__c;
            if (String.isBlank(equipmentType)) {throw new AuraHandledException('Commercial Asset Finance value is mandatory.');}
            equipmentDesc = apps.Description__c;
            if (String.isBlank(equipmentDesc)) {throw new AuraHandledException('Vehicle Description is required, when Asset Type is not \'OTHER\'');}
            make = '';
            model = '';
            mmCode = '';
        }
		String SFcaseNo = sfCaseNumber!=null ? sfCaseNumber.removeStart('C-') : '';
        
        xmlNodeRoot.addChildElement('originatorUserId', null, null).addTextNode('ESP');
        xmlNodeRoot.addChildElement('bcmsCaseId', null, null).addTextNode('00000000-0000-0000-0000-000000000000');
        //xmlNodeRoot.addChildElement('bussOriginatorRefNo', null, null)
        xmlNodeRoot.addChildElement('bussOriginatorRefNo', null, null).addTextNode(SFcaseNo != null ? SFcaseNo : '');
        xmlNodeRoot.addChildElement('espGuidReference', null, null).addTextNode(String.valueOf(bussOriginatorRefNo));
           
        //Populate the SF case number here
        //String SFcaseNo = sfCaseNumber!=null ? sfCaseNumber.removeStart('C-') : '';
        xmlNodeRoot.addChildElement('originRef', null, null).addTextNode(String.valueOf(bussOriginatorRefNo));
        
        if (String.isBlank(accountRecord.CIF__c)) {throw new AuraHandledException('CIF Code is mandatory.');}
        xmlNodeRoot.addChildElement('cifCode', null, null).addTextNode(accountRecord.CIF__c);
        if (String.isBlank(clientTypeTranslated)) {throw new AuraHandledException('Client Type is mandatory.');}
        xmlNodeRoot.addChildElement('clientType', null, null).addTextNode(clientTypeTranslated);
        if (String.isBlank(accountRecord.Name)) {throw new AuraHandledException('Account Name is mandatory.');}
            xmlNodeRoot.addChildElement('businessName', null, null).addTextNode(accountRecord.Name);
            xmlNodeRoot.addChildElement('tradingName', null, null).addTextNode(accountRecord.Trading_Name__c!=null ? accountRecord.Trading_Name__c : '');
        if (String.isBlank(idTypeTranslated)) {throw new AuraHandledException('ID Type is mandatory.');}
        xmlNodeRoot.addChildElement('identificationType', null, null).addTextNode(idTypeTranslated);

        if (String.isBlank(accountRecord.Registration_Number__c)) {throw new AuraHandledException('Company Registration Number is mandatory.');}
            xmlNodeRoot.addChildElement('businessRegNo', null, null).addTextNode(accountRecord.Registration_Number__c.replace('/',''));
   
        xmlNodeRoot.addChildElement('indicatorExistingAbsaClient', null, null).addTextNode('Y');
        if (String.isBlank(comLanguageTranslated)) {throw new AuraHandledException('Correspondence Language is mandatory.');}
        xmlNodeRoot.addChildElement('languageCorrespondence', null, null).addTextNode(comLanguageTranslated);

        //Head Office Address
        xmlNodeRoot.addChildElement('addressLine1HeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_Street__c!=null && addressHeadOffice?.Shipping_Street__c.length() <= 60 ? addressHeadOffice?.Shipping_Street__c : 
                                                                                      addressHeadOffice?.Shipping_Street__c!=null && addressHeadOffice?.Shipping_Street__c.length() > 60 ? addressHeadOffice?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressLine2HeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_State_Province__c != null ? addressHeadOffice?.Shipping_State_Province__c : '');
        xmlNodeRoot.addChildElement('addressLine3HeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_Suburb__c!=null && addressHeadOffice?.Shipping_Suburb__c.length() <= 40 ? addressHeadOffice?.Shipping_Suburb__c : 
                                                                                      addressHeadOffice?.Shipping_Suburb__c!=null && addressHeadOffice?.Shipping_Suburb__c.length() > 40 ? addressHeadOffice?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityHeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_City__c!=null && addressHeadOffice?.Shipping_City__c.length() <= 40 ? addressHeadOffice?.Shipping_City__c : 
                                                                                     addressHeadOffice?.Shipping_City__c!=null && addressHeadOffice?.Shipping_City__c.length() > 40 ? addressHeadOffice?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryHeadOffice', null, null).addTextNode(countryHeadOfficeTranslated != null ? countryHeadOfficeTranslated : '');
        xmlNodeRoot.addChildElement('postalCodeHeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_Zip_Postal_Code__c != null ? addressHeadOffice?.Shipping_Zip_Postal_Code__c : '');

        //Business Address
        xmlNodeRoot.addChildElement('addressLine1Business', null, null).addTextNode(addressBusinessAddress?.Shipping_Street__c!=null && addressBusinessAddress?.Shipping_Street__c.length() <= 60 ? addressBusinessAddress?.Shipping_Street__c : 
                                                                                    addressBusinessAddress?.Shipping_Street__c!=null && addressBusinessAddress?.Shipping_Street__c.length() > 60 ? addressBusinessAddress?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressLine2Business', null, null).addTextNode(addressBusinessAddress?.Shipping_State_Province__c != null ? addressBusinessAddress?.Shipping_State_Province__c : '');
        xmlNodeRoot.addChildElement('addressSubBusiness', null, null).addTextNode(addressBusinessAddress?.Shipping_Suburb__c!=null && addressBusinessAddress?.Shipping_Suburb__c.length() <= 40 ? addressBusinessAddress?.Shipping_Suburb__c : 
                                                                                  addressBusinessAddress?.Shipping_Suburb__c!=null && addressBusinessAddress?.Shipping_Suburb__c.length() > 40 ? addressBusinessAddress?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityBusiness', null, null).addTextNode(addressBusinessAddress?.Shipping_City__c!=null && addressBusinessAddress?.Shipping_City__c.length() <= 40 ? addressBusinessAddress?.Shipping_City__c : 
                                                                                   addressBusinessAddress?.Shipping_City__c!=null && addressBusinessAddress?.Shipping_City__c.length() > 40 ? addressBusinessAddress?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryBusiness', null, null).addTextNode(countryBusinessAddressTranslated != null ? countryBusinessAddressTranslated : '');
        xmlNodeRoot.addChildElement('postalCodeBusiness', null, null).addTextNode(addressBusinessAddress?.Shipping_Zip_Postal_Code__c != null ? addressBusinessAddress?.Shipping_Zip_Postal_Code__c : '');

        xmlNodeRoot.addChildElement('addressLine1Postal', null, null).addTextNode(addressPostal?.Shipping_Street__c!=null && addressPostal?.Shipping_Street__c.length() <= 60 ? addressPostal?.Shipping_Street__c : 
                                                                                  addressPostal?.Shipping_Street__c!=null && addressPostal?.Shipping_Street__c.length() > 60 ? addressPostal?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressSubPostal', null, null).addTextNode(addressPostal?.Shipping_Suburb__c!=null && addressPostal?.Shipping_Suburb__c.length() <= 40 ? addressPostal?.Shipping_Suburb__c : 
                                                                                addressPostal?.Shipping_Suburb__c!=null && addressPostal?.Shipping_Suburb__c.length() > 40 ? addressPostal?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityPostal', null, null).addTextNode(addressPostal?.Shipping_City__c!=null && addressPostal?.Shipping_City__c.length() <= 40 ? addressPostal?.Shipping_City__c : 
                                                                                 addressPostal?.Shipping_City__c!=null && addressPostal?.Shipping_City__c.length() > 40 ? addressPostal?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryPostal', null, null).addTextNode(countryPostalTranslated != null ? countryPostalTranslated : '');
        xmlNodeRoot.addChildElement('postalCodePostal', null, null).addTextNode(addressPostal?.Shipping_Zip_Postal_Code__c != null ? addressPostal?.Shipping_Zip_Postal_Code__c : '');

        //Registered Address
        xmlNodeRoot.addChildElement('addressLine1Registered', null, null).addTextNode(addressRegistered?.Shipping_Street__c!=null && addressRegistered?.Shipping_Street__c.length() <= 60 ? addressRegistered?.Shipping_Street__c : 
                                                                                      addressRegistered?.Shipping_Street__c!=null && addressRegistered?.Shipping_Street__c.length() > 60 ? addressRegistered?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressLine2Registered', null, null).addTextNode(addressRegistered?.Shipping_State_Province__c != null ? addressRegistered?.Shipping_State_Province__c : '');
        xmlNodeRoot.addChildElement('addressSubRegistered', null, null).addTextNode(addressRegistered?.Shipping_Suburb__c!=null && addressRegistered?.Shipping_Suburb__c.length() <= 40 ? addressRegistered?.Shipping_Suburb__c : 
                                                                                    addressRegistered?.Shipping_Suburb__c!=null && addressRegistered?.Shipping_Suburb__c.length() > 40 ? addressRegistered?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityRegistered', null, null).addTextNode(addressRegistered?.Shipping_City__c!=null && addressRegistered?.Shipping_City__c.length() <= 40 ? addressRegistered?.Shipping_City__c : 
                                                                                     addressRegistered?.Shipping_City__c!=null && addressRegistered?.Shipping_City__c.length() > 40 ? addressRegistered?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryRegistered', null, null).addTextNode(countryRegisteredTranslated != null ? countryRegisteredTranslated : '');
        xmlNodeRoot.addChildElement('postalCodeRegistered', null, null).addTextNode(addressRegistered?.Shipping_Zip_Postal_Code__c != null ? addressRegistered?.Shipping_Zip_Postal_Code__c : '');

        xmlNodeRoot.addChildElement('eMailAddress', null, null).addTextNode(accountRecord.Active_Email__c != null ? accountRecord.Active_Email__c : '');
        if (accountRecord.Income_Tax_Number__c == null ) {throw new AuraHandledException('Income Tax Number should be greater than zero.');}
        xmlNodeRoot.addChildElement('incomeTaxNo', null, null).addTextNode(accountRecord.Income_Tax_Number__c);
        xmlNodeRoot.addChildElement('indicatorVatVendor', null, null).addTextNode(apps.VAT_Indicator__c == 'Yes' ? 'Y' : 'N');
        if (apps.VAT_Indicator__c == 'Yes' && (accountRecord.VAT_Registration_Number__c == null || accountRecord.VAT_Registration_Number__c <= 0)) {throw new AuraHandledException('VAT Registration Number is mandatory.');}
        xmlNodeRoot.addChildElement('vatNo', null, null).addTextNode(apps.VAT_Indicator__c == 'Yes' ? String.valueOf(accountRecord.VAT_Registration_Number__c) : '');

        xmlNodeRoot.addChildElement('businessSNKCode', null, null).addTextNode(accountRecord.Sic.length() <=5 ? accountRecord.Sic : accountRecord.Sic.length() > 5 ? accountRecord.Sic.left(5) : '');

        xmlNodeRoot.addChildElement('companyYearEnd', null, null).addTextNode(financialYearEndTranslated);
        xmlNodeRoot.addChildElement('indicatorInsolvent', null, null).addTextNode(accountRecord.Client_ever_been_declared_Insolvent__c == true ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('indicatorShortTermIns', null, null).addTextNode(apps.Do_you_have_short_term_insurance__c == true ? 'Y' : 'N');
        if (apps.Do_you_have_short_term_insurance__c == true && (String.isBlank(apps.Insurance_Policy_Number__c) || String.isBlank(apps.Insurance_Company_Name__c))) {throw new AuraHandledException('Insurance Policy Number or Insurance Company Name is mandatory.');}
        xmlNodeRoot.addChildElement('stiPolicyNumber', null, null).addTextNode(apps.Insurance_Policy_Number__c);
        xmlNodeRoot.addChildElement('stiCompany', null, null).addTextNode(apps.Insurance_Company_Name__c);
        xmlNodeRoot.addChildElement('articleSecureInd', null, null).addTextNode(apps.Article_secure__c == 'Yes' ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('preferredCommMethod', null, null).addTextNode(comMethodTranslated);

        xmlNodeRoot.addChildElement('indicatorConsentMarketing', null, null).addTextNode(accountRecord.Credit_Marketing_Consent__pc == 'Yes' ? 'Y' : 'N');
        if (String.isNotBlank(accountRecord.Credit_Marketing_Indicator__pc)) {
            List<String> creditMarketingIndicatorSplit = accountRecord.Credit_Marketing_Indicator__pc.split(';');
            xmlNodeRoot.addChildElement('marketingMethodMail', null, null).addTextNode(creditMarketingIndicatorSplit.contains('Mail') ? 'Y' : 'N');
            xmlNodeRoot.addChildElement('marketingMethodEmail', null, null).addTextNode(creditMarketingIndicatorSplit.contains('Email') ? 'Y' : 'N');
            xmlNodeRoot.addChildElement('marketingMethodTelephone', null, null).addTextNode(creditMarketingIndicatorSplit.contains('Phone') ? 'Y' : 'N');
            xmlNodeRoot.addChildElement('marketingMethodSMS', null, null).addTextNode(creditMarketingIndicatorSplit.contains('SMS') ? 'Y' : 'N');
        } else {
            xmlNodeRoot.addChildElement('marketingMethodMail', null, null).addTextNode('N');
            xmlNodeRoot.addChildElement('marketingMethodEmail', null, null).addTextNode('N');
            xmlNodeRoot.addChildElement('marketingMethodTelephone', null, null).addTextNode('N');
            xmlNodeRoot.addChildElement('marketingMethodSMS', null, null).addTextNode('N');
        }

        xmlNodeRoot.addChildElement('indicatorITCConsent', null, null).addTextNode(apps.Indicator_ITC_Consent__c == 'Yes' ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('indicatorDebitOrder', null, null).addTextNode(apps.Debit_order__c == 'Yes' ? 'Y' : 'N');
        if (apps.Debit_order__c == 'Yes' && (String.isBlank(apps.Bank_name__c) || String.isBlank(apps.Sales_branch__c) || String.isBlank(accountTypeTranslated) || apps.Account_number__c == null || apps.Account_number__c <= 0 || String.isBlank(apps.Account_holder__c))) {throw new AuraHandledException('All Debit Order related details are mandatory.');}
        xmlNodeRoot.addChildElement('currentBankName', null, null).addTextNode(apps.Bank_name__c);
        xmlNodeRoot.addChildElement('currentBankBranch', null, null).addTextNode(apps.Sales_branch__c);
        xmlNodeRoot.addChildElement('currentBankAccType', null, null).addTextNode(accountTypeTranslated);
        xmlNodeRoot.addChildElement('currentBankAccNo', null, null).addTextNode(apps.Account_number__c != null ? String.valueOf(apps.Account_number__c) : '');
        xmlNodeRoot.addChildElement('currentBankAccountHolder', null, null).addTextNode(apps.Account_holder__c);

        xmlNodeRoot.addChildElement('statementIndicator', null, null).addTextNode(apps.Statement_delivery_method__c == 'Email' ? 'E' : 'G');
        if (apps.Statement_delivery_method__c == 'Email' && String.isBlank(apps.Contract_Email__c)) {throw new AuraHandledException('Statement Email is mandatory.');}
        xmlNodeRoot.addChildElement('statementEmail1', null, null).addTextNode(apps.Contract_Email__c != null ? apps.Contract_Email__c : '');
        xmlNodeRoot.addChildElement('statementEmail2', null, null).addTextNode(apps.Another_Contract_Email__c != null ? apps.Another_Contract_Email__c : '');
        xmlNodeRoot.addChildElement('section129Notice', null, null).addTextNode(section129NoticeTranslated != null ? section129NoticeTranslated : '2');
        if (opp.Annual_turnover__c == null || opp.Annual_turnover__c <= 0) {throw new AuraHandledException('Turnover value should be greater than zero.');}
        xmlNodeRoot.addChildElement('turnoverValue', null, null).addTextNode(String.valueOf(opp.Annual_turnover__c));
        xmlNodeRoot.addChildElement('financialTurnover', null, null).addTextNode(String.valueOf(opp.Annual_turnover__c));
        xmlNodeRoot.addChildElement('cpaRegulated', null, null).addTextNode(accountRecord.Does_the_Client_fall_under_the_CPA__c == true ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('mortgageSecured', null, null).addTextNode(opp.Secured_by_mortgage__c == 'Yes' ? 'Y' : 'N');

        // CountryOfOperation
        xmlNodeRoot.addChildElement('countryEntityOperatesIn1', null, null).addTextNode(countryOfOperationTranslated);

        if (String.isBlank(apps.Dealer_Code__c) || String.isBlank(apps.Sales_person_full_name__c) || String.isBlank(apps.Contact_number__c)) {throw new AuraHandledException('Dealer details are mandatory.');}
        xmlNodeRoot.addChildElement('dealerCode', null, null).addTextNode(apps.Dealer_Code__c);
        xmlNodeRoot.addChildElement('salesPersonName', null, null).addTextNode(apps.Sales_person_full_name__c);
        xmlNodeRoot.addChildElement('salesPersonSurname', null, null).addTextNode(apps.Sales_person_full_name__c);

        String cellNoSMS = apps.Contact_number__c;
        cellNoSMS = cellNoSMS.replaceAll('\\D','');
        if (String.isBlank(cellNoSMS)) {throw new AuraHandledException('Dealer Cell Number is mandatory.');}
        if (!cellNoSMS.startsWith('0')) {
            cellNoSMS = '0' + cellNoSMS;
        }
        xmlNodeRoot.addChildElement('cellNoSMS', null, null).addTextNode(cellNoSMS);

        if (String.isBlank(apps.Marketer_BDO_Employee_Number__c) || String.isBlank(apps.Marketer_BDO_Email_address__c)) {throw new AuraHandledException('Marketer BDO details are mandatory.');}
        xmlNodeRoot.addChildElement('marketerPersNo', null, null).addTextNode(apps.Marketer_BDO_Employee_Number__c.length() <= 10 ? apps.Marketer_BDO_Employee_Number__c : apps.Marketer_BDO_Employee_Number__c.left(10));
        xmlNodeRoot.addChildElement('marketerEmailAddress', null, null).addTextNode(apps.Marketer_BDO_Email_address__c);
        if (String.isBlank(financeTypeTranslated)) {throw new AuraHandledException('Finance Type is mandatory.');}
        xmlNodeRoot.addChildElement('financeType', null, null).addTextNode(financeTypeTranslated);
        xmlNodeRoot.addChildElement('equipmentType', null, null).addTextNode(equipmentType);
        xmlNodeRoot.addChildElement('equipmentDesc', null, null).addTextNode(equipmentDesc);
        xmlNodeRoot.addChildElement('make', null, null).addTextNode(make);
        xmlNodeRoot.addChildElement('model', null, null).addTextNode(model);
        xmlNodeRoot.addChildElement('mmCode', null, null).addTextNode(mmCode);
        if (apps.Purchase_price_amount_excl_VAT__c == null || apps.Purchase_price_amount_excl_VAT__c <= 0) {throw new AuraHandledException('Purchase Price should be greater than zero.');}
        xmlNodeRoot.addChildElement('purchasePrice', null, null).addTextNode(String.valueOf(apps.Purchase_price_amount_excl_VAT__c));

        xmlNodeRoot.addChildElement('vatAmount', null, null).addTextNode(String.valueOf(apps.VAT_amount__c != null ? apps.VAT_amount__c : 0));
        xmlNodeRoot.addChildElement('serviceFee', null, null).addTextNode(String.valueOf(apps.Service_fee_incl_VAT__c != null ? apps.Service_fee_incl_VAT__c : 0));
        xmlNodeRoot.addChildElement('commDocFee', null, null).addTextNode(String.valueOf(apps.Commercial_document_fee__c != null ? apps.Commercial_document_fee__c : 0));
        xmlNodeRoot.addChildElement('initiationFee', null, null).addTextNode(String.valueOf(apps.Initiation_fee__c != null ? apps.Initiation_fee__c : 0));
        xmlNodeRoot.addChildElement('depositAmt', null, null).addTextNode(String.valueOf(apps.Deposit_amount__c != null ? apps.Deposit_amount__c : 0));
        xmlNodeRoot.addChildElement('dealerTradeInAmt', null, null).addTextNode(String.valueOf(apps.Dealer_Trade_in_amount__c != null ? apps.Dealer_Trade_in_amount__c : 0));
        xmlNodeRoot.addChildElement('dealerCashDepositAmt', null, null).addTextNode(String.valueOf(apps.Dealer_Cash_deposit_amount__c != null ? apps.Dealer_Cash_deposit_amount__c : 0));
        xmlNodeRoot.addChildElement('residualValue', null, null).addTextNode(String.valueOf(apps.Residual_Value__c != null ? apps.Residual_Value__c : 0));
        xmlNodeRoot.addChildElement('allianceCode', null, null).addTextNode(allianceCodeTranslated != null ? allianceCodeTranslated : '1');

        if (String.isBlank(paymentFrequencyTranslated)) {throw new AuraHandledException('Payment Frequency is mandatory.');}
        xmlNodeRoot.addChildElement('paymentFrequency', null, null).addTextNode(paymentFrequencyTranslated);
        if (apps.Term_in_months__c == null || apps.Term_in_months__c <= 0) {throw new AuraHandledException('Term in Months should be greater than zero.');}
        xmlNodeRoot.addChildElement('periodRepayment', null, null).addTextNode(String.valueOf(apps.Term_in_months__c));
        xmlNodeRoot.addChildElement('rateType', null, null).addTextNode(apps.Fixed_or_linked__c == 'Fixed' ? 'F' : 'L');
        if (apps.Interest_rate__c == null || apps.Interest_rate__c <= 0) {throw new AuraHandledException('Interest Rate should be greater than zero.');}
        xmlNodeRoot.addChildElement('interestRatePreferred', null, null).addTextNode(String.valueOf(apps.Interest_rate__c));

        xmlNodeRoot.addChildElement('creditLine', null, null).addTextNode(apps.Credit_Line__c == 'Yes' ? 'Y' : 'N');

        if (String.isBlank(apps.Sales_branch__c)) {throw new AuraHandledException('Sales Branch is mandatory.');}
        xmlNodeRoot.addChildElement('salesBranch', null, null).addTextNode(apps.Sales_branch__c);
        xmlNodeRoot.addChildElement('clientOnBoarded', null, null).addTextNode('Y');
        xmlNodeRoot.addChildElement('updateApplicationInd', null, null).addTextNode('Y');

        if (String.isBlank(apps.Site_code_CAF__c)) {throw new AuraHandledException('CAF Site Code is mandatory.');}
        xmlNodeRoot.addChildElement('cafSiteCode', null, null).addTextNode(apps.Site_code_CAF__c.length() <=4 ? apps.Site_code_CAF__c : apps.Site_code_CAF__c.left(4));
        if (String.isBlank(apps.Absa_site_code__c)) {throw new AuraHandledException('Absa Site Code is mandatory.');}
        xmlNodeRoot.addChildElement('absaSiteCode', null, null).addTextNode(apps.Absa_site_code__c);
        xmlNodeRoot.addChildElement('ncaRegulated', null, null).addTextNode(apps.Account_NCA_Status__c == 'Yes' ? 'Y' : 'N');
        if (apps.Financed_amount__c == null || apps.Financed_amount__c <= 0) {throw new AuraHandledException('Financed Amount should be greater than zero.');}
        xmlNodeRoot.addChildElement('assetValue', null, null).addTextNode(String.valueOf(apps.Financed_amount__c)); // TO BE FIXED: Need to be verified by business

        if (apps.Year_First_Registered__c == null || apps.Year_First_Registered__c <= 0) {throw new AuraHandledException('Year First Registered should be greater than zero.');}
        xmlNodeRoot.addChildElement('vehicleRegistrationYear', null, null).addTextNode(String.valueOf(apps.Year_First_Registered__c));
        xmlNodeRoot.addChildElement('registrationNo', null, null).addTextNode(apps.Registration_Number__c != null ? apps.Registration_Number__c : '');
        xmlNodeRoot.addChildElement('chassisNo', null, null).addTextNode(apps.VIN_Chassis_Number__c != null ? apps.VIN_Chassis_Number__c : '');
        xmlNodeRoot.addChildElement('vehSerialNo', null, null).addTextNode(apps.Serial_Number__c != null ? apps.Serial_Number__c : '');

        xmlNodeRoot.addChildElement('landLordWaiverInd', null, null).addTextNode(apps.Landlord_Waiver__c == 'Yes' ? 'Y' : 'N');
        if (apps.Landlord_Waiver__c == 'Yes') {
            if (String.isBlank(apps.Landlord_Full_Name__c)) {throw new AuraHandledException('Landlord Full Name is mandatory.');}
            xmlNodeRoot.addChildElement('landLordWaiverNameSurname', null, null).addTextNode(apps.Landlord_Full_Name__c);
            if (String.isBlank(apps.Landlord_Address__c)) {throw new AuraHandledException('Landlord Address is mandatory.');}
            xmlNodeRoot.addChildElement('landLordWaiverAddress', null, null).addTextNode(apps.Landlord_Address__c);
        }

        xmlNodeRoot.addChildElement('mandateHolder', null, null).addTextNode(apps.Mandate_holder__c != null ? apps.Mandate_holder__c : '');

        // RelatedParty
        Boolean isContactPersonFound = false;
        for (AccountContactRelation rp : accnRelList) {
            if (!isContactPersonFound && rp.Roles != null && rp.Roles.split(';').contains('Contact Person')) {
                isContactPersonFound = true;
                String designationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Designation', accnRelList[0].Designation__c, StringConstants.OUTBOUND_RECORD_TYPE);

                xmlNodeRoot.addChildElement('contactPersonName', null, null).addTextNode(accnRelList[0].Contact.Name != null ? accnRelList[0].Contact.Name : '');
                xmlNodeRoot.addChildElement('contactDesignation', null, null).addTextNode(designationTranslated != null ? designationTranslated : '');
                xmlNodeRoot.addChildElement('contactPersonCellNo', null, null).addTextNode(accnRelList[0].Contact.MobilePhone != null ? accnRelList[0].Contact.MobilePhone : '');
                xmlNodeRoot.addChildElement('contactPersonTelephoneDialCode', null, null).addTextNode(accnRelList[0].Contact.Phone != null ? accnRelList[0].Contact.Phone.left(3) : '');
                xmlNodeRoot.addChildElement('contactPersonTelephone', null, null).addTextNode(accnRelList[0].Contact.Phone != null && accnRelList[0].Contact.Phone.length() > 3 ? accnRelList[0].Contact.Phone.substring(3) : '');
                xmlNodeRoot.addChildElement('contactPersonFaxDialCode', null, null).addTextNode(accnRelList[0].Contact.Fax != null ? accnRelList[0].Contact.Fax.left(3) : '');
                xmlNodeRoot.addChildElement('contactPersonFax', null, null).addTextNode(accnRelList[0].Contact.Fax != null && accnRelList[0].Contact.Fax.length() > 3 ? accnRelList[0].Contact.Fax.substring(3) : '');
            }

            Dom.XmlNode xmlNodeRelatedParty = xmlNodeRoot.addChildElement('relatedParty', null, null);

            String idTypeTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accnRelList[0].Contact.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String genderTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Gender', accnRelList[0].Contact.Gender__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String personTitleTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Title', accnRelList[0].Contact.Title, StringConstants.OUTBOUND_RECORD_TYPE);
            String nationalityTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Nationality', accnRelList[0].Contact.Nationality__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfbirthTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accnRelList[0].Contact.Country_of_Birth__c, StringConstants.OUTBOUND_RECORD_TYPE);

            xmlNodeRelatedParty.addChildElement('rpIDType', null, null).addTextNode(idTypeTranslatedRp != null ? idTypeTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpIDNo', null, null).addTextNode(accnRelList[0].Contact.ID_Number__c != null ? accnRelList[0].Contact.ID_Number__c : '');
            xmlNodeRelatedParty.addChildElement('rpTitle', null, null).addTextNode(personTitleTranslatedRp != null ? personTitleTranslatedRp : ''); //T
            xmlNodeRelatedParty.addChildElement('rpName', null, null).addTextNode(accnRelList[0].Contact.FirstName != null ? accnRelList[0].Contact.FirstName : '');
            xmlNodeRelatedParty.addChildElement('rpSurname', null, null).addTextNode(accnRelList[0].Contact.LastName != null ? accnRelList[0].Contact.LastName : '');

            xmlNodeRelatedParty.addChildElement('rpNationality', null, null).addTextNode(nationalityTranslatedRp != null ? nationalityTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpCountryOfBirth', null, null).addTextNode(countryOfbirthTranslatedRp != null ? countryOfbirthTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpPassportValidFrom', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpDOB', null, null).addTextNode(accnRelList[0].Contact.Birthdate != null ? String.valueOf(accnRelList[0].Contact.Birthdate) : '');

            xmlNodeRelatedParty.addChildElement('rpGender', null, null).addTextNode(genderTranslatedRp != null ? genderTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpCellNo', null, null).addTextNode(accnRelList[0].Contact.MobilePhone != null ? accnRelList[0].Contact.MobilePhone : '');
            xmlNodeRelatedParty.addChildElement('rpEmail', null, null).addTextNode(accnRelList[0].Contact.Email != null ? accnRelList[0].Contact.Email : '');

            xmlNodeRelatedParty.addChildElement('rpResidentialAddressLine1', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressLine2', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressSuburb', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressPostalCode', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressCity', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressCountry', null, null).addTextNode(''); // TO BE FIXED: Not mapped
        }
        // end Related

        // sourceOfFund
        if (String.isBlank(accountRecord.Source_of_Income__c)) {
            throw new AuraHandledException('Source of Income is blank on the Account');
        }
        Dom.XmlNode xmlNodeSourceOfFunds = xmlNodeRoot.addChildElement('sourceOfFunds', null, null);

        Boolean isSourceOfIncomeFound = false;
        for (String sourceOfIncome : accountRecord.Source_of_Income__c.split(';')) {
            Dom.XmlNode xmlNodeSourceOfFund = xmlNodeSourceOfFunds.addChildElement('sourceOfFund', null, null);
            String sourceOfIncomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, sourceOfIncome, StringConstants.OUTBOUND_RECORD_TYPE);
            xmlNodeSourceOfFund.addChildElement('desc', null, null).addTextNode(sourceOfIncomeTranslated != null ? sourceOfIncomeTranslated : '');
            if (!isSourceOfIncomeFound && String.isNotBlank(sourceOfIncomeTranslated)) {
                isSourceOfIncomeFound = true;
                xmlNodeRoot.addChildElement('sourceOfIncome', null, null).addTextNode(sourceOfIncomeTranslated != null ? sourceOfIncomeTranslated : '');
            }
        }
        // End - Source Of Funds

        // Extras - Start
        if (oppProductExtras != null && oppProductExtras.size() > 0) {
            Dom.XmlNode xmlNodeExtras = xmlNodeRoot.addChildElement('extras', null, null);

            for (OpportunityLineItem extra : oppProductExtras) {
                Dom.XmlNode xmlNodeExtra = xmlNodeExtras.addChildElement('extra', null, null);
                String typeExtraTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF, 'Type of Extra', extra.Type_Extra__c, StringConstants.OUTBOUND_RECORD_TYPE);
                xmlNodeExtra.addChildElement('desc', null, null).addTextNode(typeExtraTranslated != null ? typeExtraTranslated : '');
                xmlNodeExtra.addChildElement('price', null, null).addTextNode(extra.Additional_Fee_Amount__c != null ? extra.Additional_Fee_Amount__c : '');
            }
        }
        // Extras - End

        // Vaps - Start
        if (oppProductVaps != null && oppProductVaps.size() > 0) {
            Dom.XmlNode xmlNodeVaps = xmlNodeRoot.addChildElement('vaps', null, null);

            for (OpportunityLineItem vap : oppProductVaps) {
                Dom.XmlNode xmlNodeVap = xmlNodeVaps.addChildElement('vap', null, null);

                xmlNodeVap.addChildElement('vapCode', null, null).addTextNode(vap.Product_name_Product_code__c != null && vap.Product_name_Product_code__c.contains('-') ? vap.Product_name_Product_code__c.substringAfterLast('-') : '');
                xmlNodeVap.addChildElement('vapVendor', null, null).addTextNode(vap.Scheme_Code__c != null ? vap.Scheme_Code__c : '');
                xmlNodeVap.addChildElement('vapPrem', null, null).addTextNode(String.valueOf(vap.VAP_Premium__c != null ? vap.VAP_Premium__c : 0));
            }
        }
        // Vaps - End

        // Encode Data
        String xmlString = doc.toXmlString();
        String xmlValue = xmlString.remove('<?xml version="1.0" encoding="UTF-8"?>');
        String xmlvalue1 = xmlValue.remove('ns0:');
        system.debug ('XML String : ' + xmlString);

        String encodedString = EncodingUtil.base64Encode(blob.valueof(xmlvalue1));

            CAFCreateCase_Resp_IB_v1 responseBean = CAFCreateCase_IH_v1.createCaseInBCMS(encodedString);
            Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(xmlvalue1, 'XML for bcmscreatecase', StringConstants.SALESFORCE_STRING, 'bcmscreatecase');
            SystemLogger.insertLog(log);

        if (isUpdateNeeded) {
            Application_Product_CAF__c appsUpdate = new Application_Product_CAF__c(Id = apps.Id, Business_Originator_Reference_Number__c = bussOriginatorRefNo);
            update appsUpdate;
        }
        return responseBean;
    }

    /**
 *
 * @description Service class for caseUpdateInBCMS Service
 * @param applicationId
 * @author  
 * @return caseid
 */
    @AuraEnabled
    public static String caseUpdateInBCMS(String applicationId) {

		Application_Product_CAF__c apps = new ApplicationProductCAFSelector().selectByAppProdCAFId(applicationId);

        if (apps == null ) {
            throw new AuraHandledException('Application Product CAF record not found with Id: ' + applicationId);
        }

        Id clientId = apps.Client_Details__c;
        Boolean isUpdateNeeded = false;
        Long bussOriginatorRefNo;

        if (apps.Business_Originator_Reference_Number__c == null) {
            isUpdateNeeded = true;
            bussOriginatorRefNo = DateTime.now().getTime();
        } else {
            bussOriginatorRefNo = Long.valueOf(String.valueOf(apps.Business_Originator_Reference_Number__c));
        }

        Account accountRecord = new AccountsSelector().selectAccountFieldsCIFById(clientId);
        List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(clientId);
        List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(clientId);
        OpportunityLineItem oppProduct = new OpportunityLineItemsSelector().byApplicationProductCAF(applicationId);
        List<OpportunityLineItem> oppProductExtras = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oppProduct.Id, 'Extras');
        List<OpportunityLineItem> oppProductVaps = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oppProduct.Id, 'VAPs');
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppProduct.OpportunityId);

        Address__c addressHeadOffice;
        Address__c addressBusinessAddress;
        Address__c addressPostal;
        Address__c addressRegistered;
        String countryHeadOfficeTranslated;
        String countryBusinessAddressTranslated;
        String countryPostalTranslated;
        String countryRegisteredTranslated;

        for (Address__c address : addressList) {
            if (addressHeadOffice == null && address.Address_Type__c == 'Head Office') {
                addressHeadOffice = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryHeadOfficeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressHeadOffice.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            } else if (addressBusinessAddress == null && address.Address_Type__c == 'Business Address') {
                addressBusinessAddress = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryBusinessAddressTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressBusinessAddress.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            } else if (addressPostal == null && address.Address_Type__c == 'Postal') {
                addressPostal = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryPostalTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressPostal.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            } else if (addressRegistered == null && address.Address_Type__c == 'Registered') {
                addressRegistered = address;
                if (String.isNotBlank(address.Shipping_Country__c)) {
                    countryRegisteredTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', addressRegistered.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
            }
        }
        //Translations
        String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accountRecord.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String comLanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountRecord.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountRecord.ShippingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String CountryOfRegTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountRecord.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountRecord.Country_of_Operation__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', accountRecord.Preferred_Communication_Method__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountRecord.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String financialYearEndTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Financial Year End', accountRecord.Financial_Year_End__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String section129NoticeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Section 129 Delivery', accountRecord.Preferred_delivery_method_Legal_Notices__c, StringConstants.OUTBOUND_RECORD_TYPE);

        string nodes = 'xmlns:xsd = http://www.w3.org/2001/XMLSchema';
        String node1 = 'http://www.w3.org/2001/XMLSchema-instance';

        //Build xml Structure
        Dom.Document doc = new Dom.Document();
        Dom.XmlNode xmlNodeRoot = doc.createRootElement('CreateAVAFApplication', null, null);
        xmlNodeRoot.setNamespace('xsi ', 'http://www.w3.org/2001/XMLSchema-instance');
        xmlNodeRoot.setNamespace('xsd ', 'http://www.w3.org/2001/XMLSchema');
        Integer SFDCLineID = 0;

        String accountTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Account Type', apps.Account_type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String paymentFrequencyTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Payment Frequency', apps.Payment_frequency__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String allianceCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Alliance Code', apps.Joint_venture_alliance_code__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String financeTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Finance Type', apps.Contract_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String assetTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'CAF Asset Type', apps.Asset_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);

        String equipmentType;
        String equipmentDesc;
        String make;
        String model;
        String mmCode;
        
        if (String.isNotBlank(assetTypeTranslated)) {
            equipmentType = assetTypeTranslated;
            equipmentDesc = '';
            Id vehicleMakeModel = apps.Vehicle_Make_Model_Id__c;
            if (String.isBlank(vehicleMakeModel)) {throw new AuraHandledException('Vehicle details are required, when Asset Type is not \'OTHER\'');}
            Vehicle_Make_Model__c vehicle = [SELECT Id, Make__c, Model__c, MM_Code__c FROM Vehicle_Make_Model__c WHERE Id =: apps.Vehicle_Make_Model_Id__c];
            make = vehicle.Make__c;
            model = vehicle.Model__c;
            mmCode = vehicle.MM_Code__c;
        } else {
            equipmentType = apps.Commercial_asset_finance__c;
            if (String.isBlank(equipmentType)) {throw new AuraHandledException('Commercial Asset Finance value is mandatory.');}
            equipmentDesc = apps.Description__c;
            if (String.isBlank(equipmentDesc)) {throw new AuraHandledException('Vehicle Description is required, when Asset Type is not \'OTHER\'');}
            make = '';
            model = '';
            mmCode = '';
        }

        xmlNodeRoot.addChildElement('originatorUserId', null, null).addTextNode('ESP');
        xmlNodeRoot.addChildElement('bcmsCaseId', null, null).addTextNode('00000000-0000-0000-0000-000000000000');
               
        //xmlNodeRoot.addChildElement('bussOriginatorRefNo', null, null).addTextNode(String.valueOf(bussOriginatorRefNo));
        //xmlNodeRoot.addChildElement('bussOriginatorRefNo', null, null).addTextNode(SFcaseNo != null ? SFcaseNo : '');
        xmlNodeRoot.addChildElement('espGuidReference', null, null).addTextNode(String.valueOf(bussOriginatorRefNo));
           
        if (String.isBlank(accountRecord.CIF__c)) {throw new AuraHandledException('CIF Code is mandatory.');}
        xmlNodeRoot.addChildElement('cifCode', null, null).addTextNode(accountRecord.CIF__c);
        if (String.isBlank(clientTypeTranslated)) {throw new AuraHandledException('Client Type is mandatory.');}
        xmlNodeRoot.addChildElement('clientType', null, null).addTextNode(clientTypeTranslated);
        if (String.isBlank(accountRecord.Name)) {throw new AuraHandledException('Account Name is mandatory.');}
            xmlNodeRoot.addChildElement('businessName', null, null).addTextNode(accountRecord.Name);
            xmlNodeRoot.addChildElement('tradingName', null, null).addTextNode(accountRecord.Trading_Name__c!=null ? accountRecord.Trading_Name__c : '');
        if (String.isBlank(idTypeTranslated)) {throw new AuraHandledException('ID Type is mandatory.');}
        xmlNodeRoot.addChildElement('identificationType', null, null).addTextNode(idTypeTranslated);

        if (String.isBlank(accountRecord.Registration_Number__c)) {throw new AuraHandledException('Company Registration Number is mandatory.');}
            xmlNodeRoot.addChildElement('businessRegNo', null, null).addTextNode(accountRecord.Registration_Number__c.replace('/',''));
   
        xmlNodeRoot.addChildElement('indicatorExistingAbsaClient', null, null).addTextNode('Y');
        if (String.isBlank(comLanguageTranslated)) {throw new AuraHandledException('Correspondence Language is mandatory.');}
        xmlNodeRoot.addChildElement('languageCorrespondence', null, null).addTextNode(comLanguageTranslated);

        //Head Office Address
        xmlNodeRoot.addChildElement('addressLine1HeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_Street__c!=null && addressHeadOffice?.Shipping_Street__c.length() <= 60 ? addressHeadOffice?.Shipping_Street__c : 
                                                                                      addressHeadOffice?.Shipping_Street__c!=null && addressHeadOffice?.Shipping_Street__c.length() > 60 ? addressHeadOffice?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressLine2HeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_State_Province__c != null ? addressHeadOffice?.Shipping_State_Province__c : '');
        xmlNodeRoot.addChildElement('addressLine3HeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_Suburb__c!=null && addressHeadOffice?.Shipping_Suburb__c.length() <= 40 ? addressHeadOffice?.Shipping_Suburb__c : 
                                                                                      addressHeadOffice?.Shipping_Suburb__c!=null && addressHeadOffice?.Shipping_Suburb__c.length() > 40 ? addressHeadOffice?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityHeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_City__c!=null && addressHeadOffice?.Shipping_City__c.length() <= 40 ? addressHeadOffice?.Shipping_City__c : 
                                                                                     addressHeadOffice?.Shipping_City__c!=null && addressHeadOffice?.Shipping_City__c.length() > 40 ? addressHeadOffice?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryHeadOffice', null, null).addTextNode(countryHeadOfficeTranslated != null ? countryHeadOfficeTranslated : '');
        xmlNodeRoot.addChildElement('postalCodeHeadOffice', null, null).addTextNode(addressHeadOffice?.Shipping_Zip_Postal_Code__c != null ? addressHeadOffice?.Shipping_Zip_Postal_Code__c : '');

        //Business Address
        xmlNodeRoot.addChildElement('addressLine1Business', null, null).addTextNode(addressBusinessAddress?.Shipping_Street__c!=null && addressBusinessAddress?.Shipping_Street__c.length() <= 60 ? addressBusinessAddress?.Shipping_Street__c : 
                                                                                    addressBusinessAddress?.Shipping_Street__c!=null && addressBusinessAddress?.Shipping_Street__c.length() > 60 ? addressBusinessAddress?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressLine2Business', null, null).addTextNode(addressBusinessAddress?.Shipping_State_Province__c != null ? addressBusinessAddress?.Shipping_State_Province__c : '');
        xmlNodeRoot.addChildElement('addressSubBusiness', null, null).addTextNode(addressBusinessAddress?.Shipping_Suburb__c!=null && addressBusinessAddress?.Shipping_Suburb__c.length() <= 40 ? addressBusinessAddress?.Shipping_Suburb__c : 
                                                                                  addressBusinessAddress?.Shipping_Suburb__c!=null && addressBusinessAddress?.Shipping_Suburb__c.length() > 40 ? addressBusinessAddress?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityBusiness', null, null).addTextNode(addressBusinessAddress?.Shipping_City__c!=null && addressBusinessAddress?.Shipping_City__c.length() <= 40 ? addressBusinessAddress?.Shipping_City__c : 
                                                                                   addressBusinessAddress?.Shipping_City__c!=null && addressBusinessAddress?.Shipping_City__c.length() > 40 ? addressBusinessAddress?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryBusiness', null, null).addTextNode(countryBusinessAddressTranslated != null ? countryBusinessAddressTranslated : '');
        xmlNodeRoot.addChildElement('postalCodeBusiness', null, null).addTextNode(addressBusinessAddress?.Shipping_Zip_Postal_Code__c != null ? addressBusinessAddress?.Shipping_Zip_Postal_Code__c : '');

        xmlNodeRoot.addChildElement('addressLine1Postal', null, null).addTextNode(addressPostal?.Shipping_Street__c!=null && addressPostal?.Shipping_Street__c.length() <= 60 ? addressPostal?.Shipping_Street__c : 
                                                                                  addressPostal?.Shipping_Street__c!=null && addressPostal?.Shipping_Street__c.length() > 60 ? addressPostal?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressSubPostal', null, null).addTextNode(addressPostal?.Shipping_Suburb__c!=null && addressPostal?.Shipping_Suburb__c.length() <= 40 ? addressPostal?.Shipping_Suburb__c : 
                                                                                addressPostal?.Shipping_Suburb__c!=null && addressPostal?.Shipping_Suburb__c.length() > 40 ? addressPostal?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityPostal', null, null).addTextNode(addressPostal?.Shipping_City__c!=null && addressPostal?.Shipping_City__c.length() <= 40 ? addressPostal?.Shipping_City__c : 
                                                                                 addressPostal?.Shipping_City__c!=null && addressPostal?.Shipping_City__c.length() > 40 ? addressPostal?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryPostal', null, null).addTextNode(countryPostalTranslated != null ? countryPostalTranslated : '');
        xmlNodeRoot.addChildElement('postalCodePostal', null, null).addTextNode(addressPostal?.Shipping_Zip_Postal_Code__c != null ? addressPostal?.Shipping_Zip_Postal_Code__c : '');

        //Registered Address
        xmlNodeRoot.addChildElement('addressLine1Registered', null, null).addTextNode(addressRegistered?.Shipping_Street__c!=null && addressRegistered?.Shipping_Street__c.length() <= 60 ? addressRegistered?.Shipping_Street__c : 
                                                                                      addressRegistered?.Shipping_Street__c!=null && addressRegistered?.Shipping_Street__c.length() > 60 ? addressRegistered?.Shipping_Street__c.left(60) : '');

        xmlNodeRoot.addChildElement('addressLine2Registered', null, null).addTextNode(addressRegistered?.Shipping_State_Province__c != null ? addressRegistered?.Shipping_State_Province__c : '');
        xmlNodeRoot.addChildElement('addressSubRegistered', null, null).addTextNode(addressRegistered?.Shipping_Suburb__c!=null && addressRegistered?.Shipping_Suburb__c.length() <= 40 ? addressRegistered?.Shipping_Suburb__c : 
                                                                                    addressRegistered?.Shipping_Suburb__c!=null && addressRegistered?.Shipping_Suburb__c.length() > 40 ? addressRegistered?.Shipping_Suburb__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCityRegistered', null, null).addTextNode(addressRegistered?.Shipping_City__c!=null && addressRegistered?.Shipping_City__c.length() <= 40 ? addressRegistered?.Shipping_City__c : 
                                                                                     addressRegistered?.Shipping_City__c!=null && addressRegistered?.Shipping_City__c.length() > 40 ? addressRegistered?.Shipping_City__c.left(40) : '');

        xmlNodeRoot.addChildElement('addressCountryRegistered', null, null).addTextNode(countryRegisteredTranslated != null ? countryRegisteredTranslated : '');
        xmlNodeRoot.addChildElement('postalCodeRegistered', null, null).addTextNode(addressRegistered?.Shipping_Zip_Postal_Code__c != null ? addressRegistered?.Shipping_Zip_Postal_Code__c : '');

        xmlNodeRoot.addChildElement('eMailAddress', null, null).addTextNode(accountRecord.Active_Email__c != null ? accountRecord.Active_Email__c : '');
        if (accountRecord.Income_Tax_Number__c == null) {throw new AuraHandledException('Income Tax Number should be greater than zero.');}
        xmlNodeRoot.addChildElement('incomeTaxNo', null, null).addTextNode(String.valueOf(accountRecord.Income_Tax_Number__c));
        xmlNodeRoot.addChildElement('indicatorVatVendor', null, null).addTextNode(apps.VAT_Indicator__c == 'Yes' ? 'Y' : 'N');
        if (apps.VAT_Indicator__c == 'Yes' && (accountRecord.VAT_Registration_Number__c == null || accountRecord.VAT_Registration_Number__c <= 0)) {throw new AuraHandledException('VAT Registration Number is mandatory.');}
        xmlNodeRoot.addChildElement('vatNo', null, null).addTextNode(apps.VAT_Indicator__c == 'Yes' ? String.valueOf(accountRecord.VAT_Registration_Number__c) : '');

        xmlNodeRoot.addChildElement('businessSNKCode', null, null).addTextNode(accountRecord.Sic.length() <=5 ? accountRecord.Sic : accountRecord.Sic.length() > 5 ? accountRecord.Sic.left(5) : '');

        xmlNodeRoot.addChildElement('companyYearEnd', null, null).addTextNode(financialYearEndTranslated);
        xmlNodeRoot.addChildElement('indicatorInsolvent', null, null).addTextNode(accountRecord.Client_ever_been_declared_Insolvent__c == true ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('indicatorShortTermIns', null, null).addTextNode(apps.Do_you_have_short_term_insurance__c == true ? 'Y' : 'N');
        if (apps.Do_you_have_short_term_insurance__c == true && (String.isBlank(apps.Insurance_Policy_Number__c) || String.isBlank(apps.Insurance_Company_Name__c))) {throw new AuraHandledException('Insurance Policy Number or Insurance Company Name is mandatory.');}
        xmlNodeRoot.addChildElement('stiPolicyNumber', null, null).addTextNode(apps.Insurance_Policy_Number__c);
        xmlNodeRoot.addChildElement('stiCompany', null, null).addTextNode(apps.Insurance_Company_Name__c);
        xmlNodeRoot.addChildElement('articleSecureInd', null, null).addTextNode(apps.Article_secure__c == 'Yes' ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('preferredCommMethod', null, null).addTextNode(comMethodTranslated);

        xmlNodeRoot.addChildElement('indicatorConsentMarketing', null, null).addTextNode(accountRecord.Credit_Marketing_Consent__pc == 'Yes' ? 'Y' : 'N');
        if (String.isNotBlank(accountRecord.Credit_Marketing_Indicator__pc)) {
            List<String> creditMarketingIndicatorSplit = accountRecord.Credit_Marketing_Indicator__pc.split(';');
            xmlNodeRoot.addChildElement('marketingMethodMail', null, null).addTextNode(creditMarketingIndicatorSplit.contains('Mail') ? 'Y' : 'N');
            xmlNodeRoot.addChildElement('marketingMethodEmail', null, null).addTextNode(creditMarketingIndicatorSplit.contains('Email') ? 'Y' : 'N');
            xmlNodeRoot.addChildElement('marketingMethodTelephone', null, null).addTextNode(creditMarketingIndicatorSplit.contains('Phone') ? 'Y' : 'N');
            xmlNodeRoot.addChildElement('marketingMethodSMS', null, null).addTextNode(creditMarketingIndicatorSplit.contains('SMS') ? 'Y' : 'N');
        } else {
            xmlNodeRoot.addChildElement('marketingMethodMail', null, null).addTextNode('N');
            xmlNodeRoot.addChildElement('marketingMethodEmail', null, null).addTextNode('N');
            xmlNodeRoot.addChildElement('marketingMethodTelephone', null, null).addTextNode('N');
            xmlNodeRoot.addChildElement('marketingMethodSMS', null, null).addTextNode('N');
        }

        xmlNodeRoot.addChildElement('indicatorITCConsent', null, null).addTextNode(apps.Indicator_ITC_Consent__c == 'Yes' ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('indicatorDebitOrder', null, null).addTextNode(apps.Debit_order__c == 'Yes' ? 'Y' : 'N');
        if (apps.Debit_order__c == 'Yes' && (String.isBlank(apps.Bank_name__c) || String.isBlank(apps.Sales_branch__c) || String.isBlank(accountTypeTranslated) || apps.Account_number__c == null || apps.Account_number__c <= 0 || String.isBlank(apps.Account_holder__c))) {throw new AuraHandledException('All Debit Order related details are mandatory.');}
        xmlNodeRoot.addChildElement('currentBankName', null, null).addTextNode(apps.Bank_name__c);
        xmlNodeRoot.addChildElement('currentBankBranch', null, null).addTextNode(apps.Sales_branch__c);
        xmlNodeRoot.addChildElement('currentBankAccType', null, null).addTextNode(accountTypeTranslated);
        xmlNodeRoot.addChildElement('currentBankAccNo', null, null).addTextNode(apps.Account_number__c != null ? String.valueOf(apps.Account_number__c) : '');
        xmlNodeRoot.addChildElement('currentBankAccountHolder', null, null).addTextNode(apps.Account_holder__c);

        xmlNodeRoot.addChildElement('statementIndicator', null, null).addTextNode(apps.Statement_delivery_method__c == 'Email' ? 'E' : 'G');
        if (apps.Statement_delivery_method__c == 'Email' && String.isBlank(apps.Contract_Email__c)) {throw new AuraHandledException('Statement Email is mandatory.');}
        xmlNodeRoot.addChildElement('statementEmail1', null, null).addTextNode(apps.Contract_Email__c != null ? apps.Contract_Email__c : '');
        xmlNodeRoot.addChildElement('statementEmail2', null, null).addTextNode(apps.Another_Contract_Email__c != null ? apps.Another_Contract_Email__c : '');
        xmlNodeRoot.addChildElement('section129Notice', null, null).addTextNode(section129NoticeTranslated != null ? section129NoticeTranslated : '2');
        if (opp.Annual_turnover__c == null || opp.Annual_turnover__c <= 0) {throw new AuraHandledException('Turnover value should be greater than zero.');}
        xmlNodeRoot.addChildElement('turnoverValue', null, null).addTextNode(String.valueOf(opp.Annual_turnover__c));
        xmlNodeRoot.addChildElement('financialTurnover', null, null).addTextNode(String.valueOf(opp.Annual_turnover__c));
        xmlNodeRoot.addChildElement('cpaRegulated', null, null).addTextNode(accountRecord.Does_the_Client_fall_under_the_CPA__c == true ? 'Y' : 'N');
        xmlNodeRoot.addChildElement('mortgageSecured', null, null).addTextNode(opp.Secured_by_mortgage__c == 'Yes' ? 'Y' : 'N');

        // CountryOfOperation
        xmlNodeRoot.addChildElement('countryEntityOperatesIn1', null, null).addTextNode(countryOfOperationTranslated);

        if (String.isBlank(apps.Dealer_Code__c) || String.isBlank(apps.Sales_person_full_name__c) || String.isBlank(apps.Contact_number__c)) {throw new AuraHandledException('Dealer details are mandatory.');}
        xmlNodeRoot.addChildElement('dealerCode', null, null).addTextNode(apps.Dealer_Code__c);
        xmlNodeRoot.addChildElement('salesPersonName', null, null).addTextNode(apps.Sales_person_full_name__c);
        xmlNodeRoot.addChildElement('salesPersonSurname', null, null).addTextNode(apps.Sales_person_full_name__c);

        String cellNoSMS = apps.Contact_number__c;
        cellNoSMS = cellNoSMS.replaceAll('\\D','');
        if (String.isBlank(cellNoSMS)) {throw new AuraHandledException('Dealer Cell Number is mandatory.');}
        if (!cellNoSMS.startsWith('0')) {
            cellNoSMS = '0' + cellNoSMS;
        }
        xmlNodeRoot.addChildElement('cellNoSMS', null, null).addTextNode(cellNoSMS);

        if (String.isBlank(apps.Marketer_BDO_Employee_Number__c) || String.isBlank(apps.Marketer_BDO_Email_address__c)) {throw new AuraHandledException('Marketer BDO details are mandatory.');}
        xmlNodeRoot.addChildElement('marketerPersNo', null, null).addTextNode(apps.Marketer_BDO_Employee_Number__c.length() <= 10 ? apps.Marketer_BDO_Employee_Number__c : apps.Marketer_BDO_Employee_Number__c.left(10));
        xmlNodeRoot.addChildElement('marketerEmailAddress', null, null).addTextNode(apps.Marketer_BDO_Email_address__c);
        if (String.isBlank(financeTypeTranslated)) {throw new AuraHandledException('Finance Type is mandatory.');}
        xmlNodeRoot.addChildElement('financeType', null, null).addTextNode(financeTypeTranslated);
        xmlNodeRoot.addChildElement('equipmentType', null, null).addTextNode(equipmentType);
        xmlNodeRoot.addChildElement('equipmentDesc', null, null).addTextNode(equipmentDesc);
        xmlNodeRoot.addChildElement('make', null, null).addTextNode(make);
        xmlNodeRoot.addChildElement('model', null, null).addTextNode(model);
        xmlNodeRoot.addChildElement('mmCode', null, null).addTextNode(mmCode);
        if (apps.Purchase_price_amount_excl_VAT__c == null || apps.Purchase_price_amount_excl_VAT__c <= 0) {throw new AuraHandledException('Purchase Price should be greater than zero.');}
        xmlNodeRoot.addChildElement('purchasePrice', null, null).addTextNode(String.valueOf(apps.Purchase_price_amount_excl_VAT__c));

        xmlNodeRoot.addChildElement('vatAmount', null, null).addTextNode(String.valueOf(apps.VAT_amount__c != null ? apps.VAT_amount__c : 0));
        xmlNodeRoot.addChildElement('serviceFee', null, null).addTextNode(String.valueOf(apps.Service_fee_incl_VAT__c != null ? apps.Service_fee_incl_VAT__c : 0));
        xmlNodeRoot.addChildElement('commDocFee', null, null).addTextNode(String.valueOf(apps.Commercial_document_fee__c != null ? apps.Commercial_document_fee__c : 0));
        xmlNodeRoot.addChildElement('initiationFee', null, null).addTextNode(String.valueOf(apps.Initiation_fee__c != null ? apps.Initiation_fee__c : 0));
        xmlNodeRoot.addChildElement('depositAmt', null, null).addTextNode(String.valueOf(apps.Deposit_amount__c != null ? apps.Deposit_amount__c : 0));
        xmlNodeRoot.addChildElement('dealerTradeInAmt', null, null).addTextNode(String.valueOf(apps.Dealer_Trade_in_amount__c != null ? apps.Dealer_Trade_in_amount__c : 0));
        xmlNodeRoot.addChildElement('dealerCashDepositAmt', null, null).addTextNode(String.valueOf(apps.Dealer_Cash_deposit_amount__c != null ? apps.Dealer_Cash_deposit_amount__c : 0));
        xmlNodeRoot.addChildElement('residualValue', null, null).addTextNode(String.valueOf(apps.Residual_Value__c != null ? apps.Residual_Value__c : 0));
        xmlNodeRoot.addChildElement('allianceCode', null, null).addTextNode(allianceCodeTranslated != null ? allianceCodeTranslated : '1');

        if (String.isBlank(paymentFrequencyTranslated)) {throw new AuraHandledException('Payment Frequency is mandatory.');}
        xmlNodeRoot.addChildElement('paymentFrequency', null, null).addTextNode(paymentFrequencyTranslated);
        if (apps.Term_in_months__c == null || apps.Term_in_months__c <= 0) {throw new AuraHandledException('Term in Months should be greater than zero.');}
        xmlNodeRoot.addChildElement('periodRepayment', null, null).addTextNode(String.valueOf(apps.Term_in_months__c));
        xmlNodeRoot.addChildElement('rateType', null, null).addTextNode(apps.Fixed_or_linked__c == 'Fixed' ? 'F' : 'L');
        if (apps.Interest_rate__c == null || apps.Interest_rate__c <= 0) {throw new AuraHandledException('Interest Rate should be greater than zero.');}
        xmlNodeRoot.addChildElement('interestRatePreferred', null, null).addTextNode(String.valueOf(apps.Interest_rate__c));

        xmlNodeRoot.addChildElement('creditLine', null, null).addTextNode(apps.Credit_Line__c == 'Yes' ? 'Y' : 'N');

        if (String.isBlank(apps.Sales_branch__c)) {throw new AuraHandledException('Sales Branch is mandatory.');}
        xmlNodeRoot.addChildElement('salesBranch', null, null).addTextNode(apps.Sales_branch__c);
        xmlNodeRoot.addChildElement('clientOnBoarded', null, null).addTextNode('Y');
        xmlNodeRoot.addChildElement('updateApplicationInd', null, null).addTextNode('Y');

        if (String.isBlank(apps.Site_code_CAF__c)) {throw new AuraHandledException('CAF Site Code is mandatory.');}
        xmlNodeRoot.addChildElement('cafSiteCode', null, null).addTextNode(apps.Site_code_CAF__c.length() <=4 ? apps.Site_code_CAF__c : apps.Site_code_CAF__c.left(4));
        if (String.isBlank(apps.Absa_site_code__c)) {throw new AuraHandledException('Absa Site Code is mandatory.');}
        xmlNodeRoot.addChildElement('absaSiteCode', null, null).addTextNode(apps.Absa_site_code__c);
        xmlNodeRoot.addChildElement('ncaRegulated', null, null).addTextNode(apps.Account_NCA_Status__c == 'Yes' ? 'Y' : 'N');
        if (apps.Financed_amount__c == null || apps.Financed_amount__c <= 0) {throw new AuraHandledException('Financed Amount should be greater than zero.');}
        xmlNodeRoot.addChildElement('assetValue', null, null).addTextNode(String.valueOf(apps.Financed_amount__c)); // TO BE FIXED: Need to be verified by business

        if (apps.Year_First_Registered__c == null || apps.Year_First_Registered__c <= 0) {throw new AuraHandledException('Year First Registered should be greater than zero.');}
        xmlNodeRoot.addChildElement('vehicleRegistrationYear', null, null).addTextNode(String.valueOf(apps.Year_First_Registered__c));
        xmlNodeRoot.addChildElement('registrationNo', null, null).addTextNode(apps.Registration_Number__c != null ? apps.Registration_Number__c : '');
        xmlNodeRoot.addChildElement('chassisNo', null, null).addTextNode(apps.VIN_Chassis_Number__c != null ? apps.VIN_Chassis_Number__c : '');
        xmlNodeRoot.addChildElement('vehSerialNo', null, null).addTextNode(apps.Serial_Number__c != null ? apps.Serial_Number__c : '');

        xmlNodeRoot.addChildElement('landLordWaiverInd', null, null).addTextNode(apps.Landlord_Waiver__c == 'Yes' ? 'Y' : 'N');
        if (apps.Landlord_Waiver__c == 'Yes') {
            if (String.isBlank(apps.Landlord_Full_Name__c)) {throw new AuraHandledException('Landlord Full Name is mandatory.');}
            xmlNodeRoot.addChildElement('landLordWaiverNameSurname', null, null).addTextNode(apps.Landlord_Full_Name__c);
            if (String.isBlank(apps.Landlord_Address__c)) {throw new AuraHandledException('Landlord Address is mandatory.');}
            xmlNodeRoot.addChildElement('landLordWaiverAddress', null, null).addTextNode(apps.Landlord_Address__c);
        }

        xmlNodeRoot.addChildElement('mandateHolder', null, null).addTextNode(apps.Mandate_holder__c != null ? apps.Mandate_holder__c : '');

        // RelatedParty
        Boolean isContactPersonFound = false;
        for (AccountContactRelation rp : accnRelList) {
            if (!isContactPersonFound && rp.Roles != null && rp.Roles.split(';').contains('Contact Person')) {
                isContactPersonFound = true;
                String designationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Designation', accnRelList[0].Designation__c, StringConstants.OUTBOUND_RECORD_TYPE);

                xmlNodeRoot.addChildElement('contactPersonName', null, null).addTextNode(accnRelList[0].Contact.Name != null ? accnRelList[0].Contact.Name : '');
                xmlNodeRoot.addChildElement('contactDesignation', null, null).addTextNode(designationTranslated != null ? designationTranslated : '');
                xmlNodeRoot.addChildElement('contactPersonCellNo', null, null).addTextNode(accnRelList[0].Contact.MobilePhone != null ? accnRelList[0].Contact.MobilePhone : '');
                xmlNodeRoot.addChildElement('contactPersonTelephoneDialCode', null, null).addTextNode(accnRelList[0].Contact.Phone != null ? accnRelList[0].Contact.Phone.left(3) : '');
                xmlNodeRoot.addChildElement('contactPersonTelephone', null, null).addTextNode(accnRelList[0].Contact.Phone != null && accnRelList[0].Contact.Phone.length() > 3 ? accnRelList[0].Contact.Phone.substring(3) : '');
                xmlNodeRoot.addChildElement('contactPersonFaxDialCode', null, null).addTextNode(accnRelList[0].Contact.Fax != null ? accnRelList[0].Contact.Fax.left(3) : '');
                xmlNodeRoot.addChildElement('contactPersonFax', null, null).addTextNode(accnRelList[0].Contact.Fax != null && accnRelList[0].Contact.Fax.length() > 3 ? accnRelList[0].Contact.Fax.substring(3) : '');
            }

            Dom.XmlNode xmlNodeRelatedParty = xmlNodeRoot.addChildElement('relatedParty', null, null);

            String idTypeTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accnRelList[0].Contact.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String genderTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Gender', accnRelList[0].Contact.Gender__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String personTitleTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Title', accnRelList[0].Contact.Title, StringConstants.OUTBOUND_RECORD_TYPE);
            String nationalityTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Nationality', accnRelList[0].Contact.Nationality__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfbirthTranslatedRp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accnRelList[0].Contact.Country_of_Birth__c, StringConstants.OUTBOUND_RECORD_TYPE);

            xmlNodeRelatedParty.addChildElement('rpIDType', null, null).addTextNode(idTypeTranslatedRp != null ? idTypeTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpIDNo', null, null).addTextNode(accnRelList[0].Contact.ID_Number__c != null ? accnRelList[0].Contact.ID_Number__c : '');
            xmlNodeRelatedParty.addChildElement('rpTitle', null, null).addTextNode(personTitleTranslatedRp != null ? personTitleTranslatedRp : ''); //T
            xmlNodeRelatedParty.addChildElement('rpName', null, null).addTextNode(accnRelList[0].Contact.FirstName != null ? accnRelList[0].Contact.FirstName : '');
            xmlNodeRelatedParty.addChildElement('rpSurname', null, null).addTextNode(accnRelList[0].Contact.LastName != null ? accnRelList[0].Contact.LastName : '');

            xmlNodeRelatedParty.addChildElement('rpNationality', null, null).addTextNode(nationalityTranslatedRp != null ? nationalityTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpCountryOfBirth', null, null).addTextNode(countryOfbirthTranslatedRp != null ? countryOfbirthTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpPassportValidFrom', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpDOB', null, null).addTextNode(accnRelList[0].Contact.Birthdate != null ? String.valueOf(accnRelList[0].Contact.Birthdate) : '');

            xmlNodeRelatedParty.addChildElement('rpGender', null, null).addTextNode(genderTranslatedRp != null ? genderTranslatedRp : '');
            xmlNodeRelatedParty.addChildElement('rpCellNo', null, null).addTextNode(accnRelList[0].Contact.MobilePhone != null ? accnRelList[0].Contact.MobilePhone : '');
            xmlNodeRelatedParty.addChildElement('rpEmail', null, null).addTextNode(accnRelList[0].Contact.Email != null ? accnRelList[0].Contact.Email : '');

            xmlNodeRelatedParty.addChildElement('rpResidentialAddressLine1', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressLine2', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressSuburb', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressPostalCode', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressCity', null, null).addTextNode(''); // TO BE FIXED: Not mapped
            xmlNodeRelatedParty.addChildElement('rpResidentialAddressCountry', null, null).addTextNode(''); // TO BE FIXED: Not mapped
        }
        // end Related

        // sourceOfFund
        if (String.isBlank(accountRecord.Source_of_Income__c)) {
            throw new AuraHandledException('Source of Income is blank on the Account');
        }
        Dom.XmlNode xmlNodeSourceOfFunds = xmlNodeRoot.addChildElement('sourceOfFunds', null, null);

        Boolean isSourceOfIncomeFound = false;
        for (String sourceOfIncome : accountRecord.Source_of_Income__c.split(';')) {
            Dom.XmlNode xmlNodeSourceOfFund = xmlNodeSourceOfFunds.addChildElement('sourceOfFund', null, null);
            String sourceOfIncomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, sourceOfIncome, StringConstants.OUTBOUND_RECORD_TYPE);
            xmlNodeSourceOfFund.addChildElement('desc', null, null).addTextNode(sourceOfIncomeTranslated != null ? sourceOfIncomeTranslated : '');
            if (!isSourceOfIncomeFound && String.isNotBlank(sourceOfIncomeTranslated)) {
                isSourceOfIncomeFound = true;
                xmlNodeRoot.addChildElement('sourceOfIncome', null, null).addTextNode(sourceOfIncomeTranslated != null ? sourceOfIncomeTranslated : '');
            }
        }
        // End - Source Of Funds

        // Extras - Start
        if (oppProductExtras != null && oppProductExtras.size() > 0) {
            Dom.XmlNode xmlNodeExtras = xmlNodeRoot.addChildElement('extras', null, null);

            for (OpportunityLineItem extra : oppProductExtras) {
                Dom.XmlNode xmlNodeExtra = xmlNodeExtras.addChildElement('extra', null, null);
                String typeExtraTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF, 'Type of Extra', extra.Type_Extra__c, StringConstants.OUTBOUND_RECORD_TYPE);
                xmlNodeExtra.addChildElement('desc', null, null).addTextNode(typeExtraTranslated != null ? typeExtraTranslated : '');
                xmlNodeExtra.addChildElement('price', null, null).addTextNode(extra.Additional_Fee_Amount__c != null ? extra.Additional_Fee_Amount__c : '');
            }
        }
        // Extras - End

        // Vaps - Start
        if (oppProductVaps != null && oppProductVaps.size() > 0) {
            Dom.XmlNode xmlNodeVaps = xmlNodeRoot.addChildElement('vaps', null, null);

            for (OpportunityLineItem vap : oppProductVaps) {
                Dom.XmlNode xmlNodeVap = xmlNodeVaps.addChildElement('vap', null, null);

                xmlNodeVap.addChildElement('vapCode', null, null).addTextNode(vap.Product_name_Product_code__c != null && vap.Product_name_Product_code__c.contains('-') ? vap.Product_name_Product_code__c.substringAfterLast('-') : '');
                xmlNodeVap.addChildElement('vapVendor', null, null).addTextNode(vap.Scheme_Code__c != null ? vap.Scheme_Code__c : '');
                xmlNodeVap.addChildElement('vapPrem', null, null).addTextNode(String.valueOf(vap.VAP_Premium__c != null ? vap.VAP_Premium__c : 0));
            }
        }
        // Vaps - End

        // Encode Data
        String xmlString = doc.toXmlString();
        String xmlValue = xmlString.remove('<?xml version="1.0" encoding="UTF-8"?>');
        String xmlvalue1 = xmlValue.remove('ns0:');

        String encodedString = EncodingUtil.base64Encode(blob.valueof(xmlvalue1));

        //UPDATE CASE SCENARIO IN BCMS
            CAFUpdateCase_Resp_IB_v1 responseBean = CAFUpdateCase_IH_v1.updateCaseInBCMS(encodedString,String.valueOf(apps.Business_Originator_Reference_Number__c));
            Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(xmlvalue1, 'XML for bcmssavecase', StringConstants.SALESFORCE_STRING, 'bcmssavecase');
            SystemLogger.insertLog(log);
        
        String updatedDate = '';
        
        if (!Test.isRunningTest()){
            updatedDate = responseBean.SaveCaseResponse.updated!=null ? responseBean.SaveCaseResponse.updated : null;

            if (updatedDate!=null){
                Application_Product_CAF__c appsUpdate = new Application_Product_CAF__c(Id = apps.Id, Updated_in_BCMS__c = updatedDate);
                update appsUpdate;
            }           
        }
            
        return updatedDate;
    }
/**
 *
 * @description Method to format date for the approval history
 * @param applicationId
 * @author  Masechaba Maseli
 * @date: 08/01/2021
 * @return caseid
 */
    
    @AuraEnabled
    /*public static void createCase(String applicationId, string bcmsCaseId) {    
        CAF_Sanctioning_Controller.createCase(applicationId, bcmsCaseId);
    }*/
    public static String createCase(String applicationId){   
        //create case
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
        
        OpportunityLineItem oppProduct = new OpportunityLineItemsSelector().byApplicationProductCAF(applicationId);
        
        Service_Group__c serviceGroup = [Select Id,Name,Queue__c From Service_Group__c where Name=:'CAF Onboarding'];
        
        Id queueId = new GroupsSelector().selectByNameAndType(serviceGroup.Queue__c, 'Queue')[0].Id;
        Application_Product_CAF__c aPC = new ApplicationProductCAFSelector().selectByAppProdCAFId(applicationId);
        List<Document__c> documentList = new DocumentsSelector().getDocsRelatedToOpp(oppProduct.OpportunityId);
        List<Document__c> updateDocumentList = new List<Document__c>();
        
        Case fulfilmentcase = new Case();
        fulfilmentcase.RecordTypeId = caseRecordTypeId;
        fulfilmentcase.Status ='Review Context';
        fulfilmentcase.Get_SAP_Ref_No__c = true;
        fulfilmentCase.Opportunity__c = oppProduct.OpportunityId;
        fulfilmentCase.Product__c ='CAF';
        fulfilmentCase.Subject='CAF Case';
        fulfilmentcase.Relationship_Banker__c = oppProduct.Opportunity.OwnerId;
        fulfilmentcase.AccountId = oppProduct.Opportunity.AccountId;
        fulfilmentCase.Type ='CAF Fulfilment';
        fulfilmentCase.Id = aPC.Case__c;
        fulfilmentCase.sd_Service_Group__c = serviceGroup.Name;
        fulfilmentCase.sd_Service_Group_Id__c = serviceGroup.id;
        fulfilmentCase.OwnerId = queueId;
        fulfilmentCase.Application_Product_Id__c = applicationId ;
        fulfilmentCase.External_Reference_Type__c = 'BCMS';
        //fulfilmentCase.External_Reference_Number__c  = bcmsCaseId;
        fulfilmentCase.Application_Number__c = aPC.Name;
        fulfilmentCase.CAF_Application_Number__c = aPC.Name;
        //fulfilmentCase.ownerId = serviceGroup.Id;
        //add service group and service type 
        Set<Id> idSet = new Set<Id>();
        idSet.add(serviceGroup.Id);
        List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);
        
        if(!serviceGroupTypes.isEmpty()){
            
            fulfilmentCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
            fulfilmentCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
            fulfilmentCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
            fulfilmentCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
            fulfilmentCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
            fulfilmentCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
            fulfilmentCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
            fulfilmentCase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
            fulfilmentCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
        }
            upsert fulfilmentcase;
        	system.debug ('Fulfilment Case Number after upsert : ' + fulfilmentcase.CaseNumber) ;
            aPC.Case__c = fulfilmentcase.Id;
            update aPC;
        
        if(!documentList.isEmpty()){
            for(Document__c document: documentList){
                If(document.Application_Product_CAF__c == applicationId){ 
                   document.Case__c = fulfilmentcase.Id;
                   updateDocumentList.add(document);
                }
                
                If(document.Application_Product_CAF__c == null){
                    Document__c cloneDocument = new Document__c();
                    cloneDocument.Name = document.Name;
                    cloneDocument.Case__c = document.Case__c;
                    cloneDocument.Content_Size__c = document.Content_Size__c;
                    cloneDocument.Extension__c = document.Extension__c;
                    cloneDocument.Reference__c = document.Reference__c;
                    cloneDocument.Type__c = document.Type__c;
                    cloneDocument.Document_Status__c = document.Document_Status__c;
                    cloneDocument.ECM_Type__c = document.ECM_Type__c;
                    cloneDocument.Required__c = document.Required__c;
                    cloneDocument.Source_System__c = document.Source_System__c;
                    cloneDocument.File_Id__c = document.File_Id__c;
                    updateDocumentList.add(cloneDocument);}
                }
            
            upsert updateDocumentList;            
        } 
        return [SELECT CaseNumber from Case where Id =: fulfilmentcase.Id].CaseNumber;           
    }    
    /**
 *
 * @description Method to format date for the approval history
 * @param caseNumber
 * @param bcmsCaseId
 * @param aPCId
 * @author  Jaco de Lange 
 * @date: 08/01/2021
 *
 */
    @AuraEnabled
    public static void updateCase(String caseNumber, string bcmsCaseId, string aPCId) { 
        system.debug ('Update Case : ' + caseNumber+' BCMSCaseId: '+bcmsCaseId+' AppId : ' + aPCId);
        if ((caseNumber!=null || caseNumber!='') && (bcmsCaseId!=null || bcmsCaseId!='')){
            String caseId = [SELECT Id from Case where CaseNumber =: caseNumber LIMIT 1].Id;
            Case caseUpdate = new Case(Id = caseId, External_Reference_Number__c = bcmsCaseId);
            update caseUpdate; 
            
            if (!Test.isRunningTest()) {
                System.debug('INSIDE 992');
                fetchSAPRefNo_Schedule();
            }           
        }
    } 
    /**
 *
 * @description Method to ffetchSAPRefNo_Schedule
 * @author  Jaco de Lange 
 * @date: 08/01/2021
 *
 */
    @AuraEnabled
    @future (callout=true)
    public static void fetchSAPRefNo_Schedule() { 
		System.debug(' 1004 ');
        CAF_SAPRefNo_For_BCMSCase_ScheduleBatch getSAPRefNo = new CAF_SAPRefNo_For_BCMSCase_ScheduleBatch();

        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 2); 
        String ss = String.valueOf(Datetime.now().second());

        //parse to cron expression
        String nextScheduleTime = ss + ' ' + min + ' ' + hour + ' * * ?';

        String jobID = System.schedule('Fetch SAP Ref No', nextScheduleTime, getSAPRefNo);
        System.debug('jobID '+jobID);
    }
    /**
 *
 * @description Method to ffetchSAPRefNo_Schedule
 * @author  Jaco de Lange 
 * @date: 08/01/2021
 * @param caseNumber
 *
 */
    @AuraEnabled
    public static void deleteCase(String caseNumber) {       
        if (caseNumber!=null || caseNumber!=''){            
            Case caseRecDel = [SELECT Id from Case where CaseNumber =: caseNumber LIMIT 1];
            delete caseRecDel;            
        }
    }
}