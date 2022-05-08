/**
 * @description       : controller class for client credi details
 * @author            : englarmerdge.mongwe@absa.africa
 * @last modified on  : 2021-06-10
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-06-10   englarmerdge.mongwe@absa.africa   Initial Version
**/
public class clientDetailsSectionCredit {

    /**
    * @description get client details from CIF
    * @author englarmerdge.mongwe@absa.africa | 2021-06-10
    * @param opprtunityId
    * @return Map<String, Object>
    **/
    @AuraEnabled
    public static Map<String, Object> getClientDetails(Id opprtunityId) {
        Map<String, Object> clientDetails = new Map<String, Object>();
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(opprtunityId);
        List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectbyAccount(account.Id);
        AccountContactRelation acr = new AccountContactRelation();

        if(acrList.size() > 0 && acrList != null) {
            acr = acrList[0];
        }

        GetClientDetails_Resp_IB_v1 responseBean;
        if(account.AccountNumber != null) {
            responseBean = GetClientDetails_IH_v1.getClientDetails(account.CIF__c, account.AccountNumber, account.Sic);
        }
        else {
            responseBean = GetClientDetails_IH_v1.getClientDetails(account.CIF__c, '0', account.Sic);
        }

        if(responseBean != null || account != null) {
            clientDetails.put('Id', account.Id);
            clientDetails.put('FullName', account.Name == null ? responseBean.surname : account.Name);
            clientDetails.put('RegistrationNumber', account.Registration_Number__c == null ? responseBean.idNumber : account.Registration_Number__c);
            clientDetails.put('DateEstablished', account.Date_Established__c == null ? responseBean.dateClientOpened : String.valueOf(account.Date_Established__c));
            clientDetails.put('CountryOfIncorporation', account.Country_of_Incorporation__c == '' ? responseBean.countryIncorp : account.Country_of_Incorporation__c);
            //clientDetails.put('BusinessStartDate', account.Business_Start_Date__c != null ? String.valueOf(account.Business_Start_Date__c) : null);
            /*if(responseBean.dateIssued != '0')
            {
                clientDetails.put('BusinessStartDate', responseBean.dateIssued);
            }
            else if(acr.StartDate != null) {
                clientDetails.put('BusinessStartDate', acr.StartDate);
            }
            else {
                clientDetails.put('BusinessStartDate', responseBean.dateIssued);
            }*/
            String sicCode = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF', 'Standard Industry SIC Code', responseBean.siccCode5, 'Outbound');
            String sicCode2 = (sicCode == null ? sicCode : responseBean.siccCode5 + ' - ' + sicCode);

            clientDetails.put('StandardIndustryCodeDesc', sicCode);
            clientDetails.put('StandardIndustryCodeSIC', (sicCode2 == null ? account.Standard_Industry_SIC_Code__c : sicCode2));
            clientDetails.put('IsClientInBusinessRescue', (responseBean.inBusinessRescue == null ? '' : (responseBean.inBusinessRescue == 'Y' ? 'Yes':'No')));
            clientDetails.put('IsClientIntendsToGoIntoBusinessRescue', account.Client_Intent_To_Go_Into_Business_Rescue__c  == null ? false : account.Client_Intent_To_Go_Into_Business_Rescue__c);
           	clientDetails.put('IsClientIntendsInsolvencyLiquidation', account.Client_intends_to_declare_insolvency__c == null ? false : account.Client_intends_to_declare_insolvency__c);
            clientDetails.put('IsClientDeclaredInsolvencyLiquidationPast', account.Client_ever_been_declared_Insolvent__c == null ? false : account.Client_ever_been_declared_Insolvent__c);
            clientDetails.put('IsClientIsStokvel', account.Client_is_a_stokvel__c == null ? false : account.Client_is_a_stokvel__c);
            clientDetails.put('IsClientIsAMunicipality', account.Client_is_a_municipality__c == null ? false : account.Client_is_a_municipality__c);
            clientDetails.put('IsTradingIndicator', account.Trading_indicator__c == null ? false : account.Trading_indicator__c);
            /*clientDetails.put('IsEmailCredit', account.Is_Marketing_Consent_Email__c == null ? false : account.Is_Marketing_Consent_Email__c);
            clientDetails.put('IsSMSCredit', account.Is_Marketing_Consent_SMS__c == null ? false : account.Is_Marketing_Consent_SMS__c);
            clientDetails.put('IsPhoneCredit', account.Is_Marketing_Consent_Phone__c == null ? false : account.Is_Marketing_Consent_Phone__c);
            clientDetails.put('EmailCredit', account.Marketing_Consent_Info__c == null ? '' : account.Marketing_Consent_Info__c);
            clientDetails.put('SMSCredit', account.Marketing_Consent_SMS__c == null ? '' : account.Marketing_Consent_SMS__c);
            clientDetails.put('PhoneCredit', account.Marketing_Consent_Phone__c == null ? '' : account.Marketing_Consent_Phone__c);
            clientDetails.put('IsEmailNonCredit', account.Is_Non_Credit_Marketing_Consent_Email__c == null ? false : account.Is_Non_Credit_Marketing_Consent_Email__c);
            clientDetails.put('IsSMSNonCredit', account.Is_Non_Credit_Marketing_Consent_SMS__c == null ? false : account.Is_Non_Credit_Marketing_Consent_SMS__c);
            clientDetails.put('IsPhoneNonCredit', account.Is_Non_Credit_Marketing_Consent_Phone__c == null ? false : account.Is_Non_Credit_Marketing_Consent_Phone__c);
            clientDetails.put('EmailNonCredit', account.Non_Credit_Marketing_Consent_Email__c == null ? '' : account.Non_Credit_Marketing_Consent_Email__c);
            clientDetails.put('SMSNonCredit', account.Non_Credit_Marketing_Consent_SMS__c == null ? '' : account.Non_Credit_Marketing_Consent_SMS__c);
            clientDetails.put('PhoneNonCredit', account.Non_Credit_Marketing_Consent_Phone__c == null ? '' : account.Non_Credit_Marketing_Consent_Phone__c);
            */
            clientDetails.put('FullName', account.Name);
            clientDetails.put('CIF', (account.CIF__c == null ? '' : account.CIF__c));
            clientDetails.put('IDNumber', (account.ID_Number__pc == null ? '' : account.ID_Number__pc));
            clientDetails.put('IDType', (account.ID_Type__pc == null ? '' : account.ID_Type__pc));
            clientDetails.put('SDSID', (account.SDS_ID__c == null ? '' : account.SDS_ID__c));
            clientDetails.put('MDMCODE', ''); //need to find out
            clientDetails.put('CASAReferenceNumber', (account.CASA_Reference_Number__c == null ? account.CASA_Reference_Number__pc : account.CASA_Reference_Number__c));
            clientDetails.put('CASARiskProfilingRequired', (account.CASA_Risk_Status__c == null ? '' : account.CASA_Risk_Status__c));
            clientDetails.put('CASAResult', (account.CASA_Screening_Status__pc == null ? '' : account.CASA_Screening_Status__pc));
            clientDetails.put('CASAScreeningDate', (account.CASA_Screening_Date__pc == null ? '' : String.valueOf(account.CASA_Screening_Date__pc)));
            clientDetails.put('TemporaryResidentPermitNumber', (responseBean.tempPermitNbr == null || responseBean.tempPermitNbr == '' ? account.Temporary_Resident_Permit_Number__c : Decimal.valueOf(responseBean.tempPermitNbr)));
            clientDetails.put('TemporaryResidentPermitExpiryDate', (account.Temporary_Resident_Permit_Expiry_Date__c == null ? (responseBean.permitExpDte == '0' ? '' : responseBean.permitExpDte) : String.valueOf(account.Temporary_Resident_Permit_Expiry_Date__c)));
            clientDetails.put('DateOfBirth', (responseBean.birthDate == null ? '' : responseBean.birthDate));
            clientDetails.put('CountryOfBirth', (account.Country_of_Birth__pc == null ? '' : account.Country_of_Birth__pc));
            clientDetails.put('CountryPassportIssued', (account.Country_Passport_Issued__pc == null ? '' : account.Country_Passport_Issued__pc));
            clientDetails.put('Nationality', (account.Nationality__pc == null ? '' : account.Nationality__pc));
            clientDetails.put('Gender', (account.Gender__pc == null ? '' : account.Gender__pc));
            clientDetails.put('ClientType', (account.Client_Type__c == null ? '' : account.Client_Type__c));
            clientDetails.put('MaritalStatus', (account.Marital_Status__pc == null ? '' : account.Marital_Status__pc));
            clientDetails.put('MaritalContractType', (account.Marital_Contract_Type__pc == null ? '' : account.Marital_Contract_Type__pc));
            clientDetails.put('IsClientANonResident', (account.Is_the_Client_a_Non_resident__c == null ? false : account.Is_the_Client_a_Non_resident__c));
            clientDetails.put('IsClientATemporaryResident', (account.Is_the_Client_a_Temporary_Resident__c == null ? false : account.Is_the_Client_a_Temporary_Resident__c));
            clientDetails.put('ResidentialStatusAddress', (account.Residential_Status_Address__c == null ? '' : account.Residential_Status_Address__c)); //input
            clientDetails.put('ResidentialStatusBorder', (account.Residential_Status__c == null ? '' : account.Residential_Status__c));//input
            clientDetails.put('DateCurrentAddressSince', (account.Date_Current_Address_Since__c == null ? '' : String.valueOf(account.Date_Current_Address_Since__c))); //input
            clientDetails.put('FinancialYearEnd', (account.Financial_Year_End__c == null ? '' : account.Financial_Year_End__c));
            clientDetails.put('IsClientPartOfAnEnterpriseDevelopmentFund', (account.Is_Client_Part_Of_Enter_Development_Fund__c == null ? false : account.Is_Client_Part_Of_Enter_Development_Fund__c));//input
            clientDetails.put('DevelopmentFundPartnerClientCode', (account.Development_Fund_Partner_Client_Code__c == null ? '' : account.Development_Fund_Partner_Client_Code__c));//input
            clientDetails.put('DevelopmentFundName', (account.Development_Fund_Name__c == null ? '' : account.Development_Fund_Name__c));//input
            clientDetails.put('ClientOperatesUnderAnExistingFranchiseContractAgreement', (account.Is_Part_of_Franchise__c == null ? false : account.Is_Part_of_Franchise__c));//input
            clientDetails.put('FranchiseCode', (account.Franchise_Code__c == null ? '' : account.Franchise_Code__c));//input
            clientDetails.put('FranchiseName', (account.Franchise_Name__c == null ? '' : account.Franchise_Name__c));//input
            //clientDetails.put('BusinessRescueAffectedParty', (account.Business_Rescue_Affected_Party__c == null ? (responseBean.ibrAffected == 'Y' ? 'Yes' : 'No') : account.Business_Rescue_Affected_Party__c));
			clientDetails.put('BusinessRescueAffectedParty', responseBean.ibrAffected == 'Y' ? 'Yes' : 'No'); //added by Manish for W-011757
			clientDetails.put('fundNumber', (account.Trust_Or_Other_Fund_Number__c == null ? '' : account.Trust_Or_Other_Fund_Number__c));
			clientDetails.put('Segment', (account.SBU_Segment__c == null ? '' : account.SBU_Segment__c));

            List<Map<String, String>> addressOption = new List<Map<String, String>>();
            Map<String, String> mapAddress = new Map<String, String>();

            if(responseBean.addressEntry != null) {
                for(GetClientDetails_Resp_IB_v1.cls_addressEntry address : responseBean.addressEntry) {
                    if(!isEmptyOrNull(address.addrLine1)) {
                        String addOption = (addressType(address.addrType) + ' - ' + address.addrLine1 + ', ' + address.addrLine2 + ', ' + address.addrSuburbRsa + ', ' + address.addrTown + ', ' + address.addrPostlCode);
                        mapAddress.put('Address', addOption);
                        addressOption.add(mapAddress);
                    }
                }
            }

            clientDetails.put('ResidentialStatusAddressOptions', addressOption);

            if(responseBean.finCrimeHold == 'N') {
                clientDetails.put('FinCrimeHold', 'No');
            }
            else if(responseBean.finCrimeHold == 'Y') {
                clientDetails.put('FinCrimeHold', 'Yes');
            }
        }
		//System.debug('c%%'+clientDetails.get('BusinessStartDate'));
        System.debug('clientDetails:::: ' + JSON.serializePretty(clientDetails));
        return clientDetails;
    }

    private static Boolean isEmptyOrNull(String obj){
        return obj == null || obj == '';
    }

    private static String addressType(String addType) {
        String sicCode = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF', 'Address Type', addType, 'Outbound');
        return sicCode;
    }
}