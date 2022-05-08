/**
 * This is a sample class used to illustrate how to format a comment the heading for
 * an apex class.
 * @author   Unknown
 * @since    Unknown
 *
 * @udated  Englarmerdge Mongwe
 * @date    2020-08-30
 * @story   W-005598
 * Auto select highest % interest control as main
 * Save principal data as snapshot - W-005598
 **/
public class principalShareholderDetails {
    public static Boolean isMaxSingle = true;
    public static Boolean isMaxItemSelected = false;
    public static Boolean isHighestMaxValue = true;

	/**
     * list of related parties for an account
     *
     * @param accountId
     * @return listParties
    */
    @AuraEnabled
    public static Map<String, Object> getRelatedParties(Id oppId, Boolean submitForCasa) {
        Account acccount = new AccountsSelector().selectByOpportunityId(oppId);
        List<Map<String,Object>> listParties = new List<Map<String,Object>>();
        List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount.Id);
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Application_Principal__c> appPrinList = (isNotNullOrEmpty(appList) ? new ApplicationPrincipalsSelector().selectByApplicationId(appList[0].Id) : null);
        List<Application_Principal__c> appAllPrinList = (isNotNullOrEmpty(appList) ? new ApplicationPrincipalsSelector().getApplicationPrincipals(appList[0].Id) : null);

        Boolean IsInfoCorrect = false;
        if (isNotNullOrEmpty(appList)) {
            IsInfoCorrect = appList[0].Is_Principal_Shareholder_Info_Correct__c;
        }

        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        if(isNotNullOrEmpty(opportunities)) {
            if(opportunities[0].CASA_Reference_Number__c != null && opportunities[0].CASA_Reference_Number__c != '0') {
                submitForCasa = true;
            }
        }

        List<Application_Principal__c> appAllNewPrinList = new List<Application_Principal__c>();
        for(AccountContactRelation accnRel : accnRelList) {
            //Apparently we need to get all related principals as the Exposures and Triad rely on all, not just selected principals. EMONGWE
            if((!isNotNullOrEmpty(appAllPrinList)) && isNotNullOrEmpty(appList)) {
                appAllNewPrinList.add(new Application_Principal__c(
                    AccConRelId__c = accnRel?.Id,
                    Application__c = appList[0].Id,
                    Casa_Reference__c = accnRel?.Contact.CASA_Reference_Number__c,
                    Casa_Result__c = accnRel?.Contact.CASA_Screening_Status__c,
                    CIF__c = accnRel?.Contact.CIF__c,
                    Controlling_Interest__c = accnRel?.Share_Percentage__c,
                    Id_Number__c = accnRel?.Contact.ID_Number__c,
                    ID_Type__c = accnRel?.Contact.ID_Type__c,
                    Main__c = false,
                    Is_Part_Of_Application__c = false,
                    Principal_Shareholder_Name__c = accnRel?.Contact.Name
                ));
            }

            List<Decimal> percInt = new List<Decimal>{0,0.00,null};
            Map<String,Object> mapObj = new Map<String,Object>();
            if(!percInt.contains(accnRel?.Share_Percentage__c)) {
                mapObj.put('Id', accnRel?.Id);
                mapObj.put('AccountId', accnRel?.AccountId);
                mapObj.put('ContactId', accnRel?.ContactId);
                mapObj.put('FullName', accnRel?.Contact.Name);
                mapObj.put('IDNumber', accnRel?.Contact.ID_Number__c);
                mapObj.put('CIF', accnRel?.Contact.CIF__c);
                mapObj.put('Nationality', accnRel?.Contact.Nationality__c);
                mapObj.put('Birthdate', String.valueOf(accnRel?.Contact.Birthdate));
                mapObj.put('SharePercentage', string.valueOf(accnRel?.Share_Percentage__c));
                //mapObj.put('CIF', accnRel?.Account.CIF__c);
                mapObj.put('HighestQualification', (accnRel?.Contact.Highest_Qualification__c == null ? '' : accnRel?.Contact.Highest_Qualification__c));
                //mapObj.put('residentailAddress', accnRel?.Account.Business_Address_Line_1__c);
                //mapObj.put('ResidentialAddress', appilication.Residential_Address__c);
                mapObj.put('DateShareholdingAcquired', String.valueOf(accnRel?.Date_Shareholding_Acquired__c));
                mapObj.put('NumberOfYearInTheSpecificIndustry', (accnRel?.Contact.Account.Number_Of_YearIn_The_Specific_Industry__c == null ? '' : accnRel?.Contact.Account.Number_Of_YearIn_The_Specific_Industry__c));
                mapObj.put('MonthsActivelyInvolvedInTheBusiness', (accnRel?.Contact.Account.Months_Actively_Involved_In_The_Business__c == null ? '' : accnRel?.Contact.Account.Months_Actively_Involved_In_The_Business__c));

                //Saurabh : Removing check as per User Story W: 005585 if(submitForCasa == true) {
                    mapObj.put('CASAReferenceNumber', (accnRel?.Contact.CASA_Reference_Number__c == null ? '' : accnRel?.Contact.CASA_Reference_Number__c));
                    mapObj.put('CASAScreeningStatus', (accnRel?.Contact.CASA_Screening_Status__c == null ? '' : accnRel?.Contact.CASA_Screening_Status__c));
                //}
                if(isNotNullOrEmpty(appPrinList)) {
                    for(Application_Principal__c output : appPrinList) {
                        if(output.AccConRelId__c == accnRel?.Id && output.Is_Part_Of_Application__c) {
                            //by virtue of being found, the principals are auto selected
                            mapObj.put('ChkSelected', true);
                            isMaxItemSelected = setMaxItemSelected(output.Controlling_Interest__c, acccount.Id, accnRelList.size());

                            if(output.Main__c == true) {
                                mapObj.put('RadSelected', true);
                                mapObj.put('RadDisabled', ((isHighestMaxValue && isMaxSingle) ? true : false));
                                mapObj.put('ChkDisabled', ((isHighestMaxValue && isMaxSingle) ? true : false));
                            }
                            else if(output.Main__c == false) {
                                mapObj.put('RadDisabled', ((!isHighestMaxValue) ? true : false));
                                mapObj.put('ChkDisabled', false);
                            }
                            break;
                        }
                        else {
                            mapObj.put('RadDisabled', true);
                        }
                    }
                }
                else {
                    isMaxItemSelected = setMaxItemSelected(accnRel?.Share_Percentage__c, acccount.Id, accnRelList.size());

                    if(isMaxItemSelected) {
                        if(accnRelList.size() == 1) {
                            mapObj.put('ChkSelected', true);
                            mapObj.put('ChkDisabled', true);
                            mapObj.put('RadSelected', true);
                            mapObj.put('RadDisabled', true);
                        }

                        if(accnRelList.size() > 1) {
                            mapObj.put('ChkSelected', ((isHighestMaxValue && isMaxSingle) ? true : false));
                            mapObj.put('RadSelected', ((isHighestMaxValue && isMaxSingle) ? true : false));
                            mapObj.put('RadDisabled', (isHighestMaxValue && !isMaxSingle ? false : true));
                            mapObj.put('ChkDisabled', ((isHighestMaxValue && isMaxSingle) ? true : false));
                        }
                    }
                    else if(!isMaxItemSelected) {
                        mapObj.put('RadSelected', false);
                        mapObj.put('RadDisabled', true);
                        mapObj.put('ChkDisabled', false);
                    }
                }

                listParties.add(mapObj);
            }
            try{
                Account personAccount = new AccountsSelector().selectAccountByPersonContactId(accnRel?.Contact.Id, 1);
                Integer MonthsSinceShareholding = (accnRel?.Date_Shareholding_Acquired__c != null ? accnRel.Date_Shareholding_Acquired__c.monthsBetween(Date.today()) : 0);
                if(MonthsSinceShareholding != null) {//&& personAccount?.Months_Since_Shareholding__c == null) {
                    personAccount.Months_Since_Shareholding__c = MonthsSinceShareholding;
                    update personAccount;
                }
            }
            catch(Exception ex) {
                throw new AuraHandledException('Update failed for Months Since Shareholding: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            }
        }

        try{
            if(isNotNullOrEmpty(appAllNewPrinList))
                insert appAllNewPrinList;
        }
        catch(Exception ex){
            return new Map<String, Object>{'PrincipalInfoStatus' => null, 'PrincipalData' => null, 'Status' => ('Error inserting principals'+ ex.getDmlMessage(0)) };
        }

        return new Map<String, Object>{'PrincipalInfoStatus' => IsInfoCorrect, 'PrincipalData' => listParties};
    }

    @AuraEnabled
    public static String updateInformation(Id acrId, String highestQualification, String residentailAddress,
                                           String numberOfYearInIndustry, String monthsActivelyInvolvedInTheBusiness,
                                           String monthsSinceShareholding, String dateShareholdingAcquired,
                                           Boolean isNonSAResident, Boolean isTemporaryResident) {

        String returnReponse = null;
        AccountContactRelation accnRel = new AccountContactRelationSelector().selectbyAccountContactRelationId(acrId);
        Account personAccount = new AccountsSelector().selectAccountByPersonContactId(accnRel?.Contact?.Id, 1);

        /*Contact contact = new ContactSelector().selectByPersonId(accnRel?.Contact.Id, 1);
        contact.Highest_Qualification__c = highestQualification;
        applicationRec.Residential_Address__c =  residentailAddress;
        acccount.Number_Of_YearIn_The_Specific_Industry__c = numberOfYearInIndustry;
        acccount.Months_Actively_Involved_In_The_Business__c = monthsActivelyInvolvedInTheBusiness;
        acccount.Is_the_Client_a_Non_resident__c = isNonSAResident;
        acccount.Is_the_Client_a_Temporary_Resident__c = isTemporaryResident;*/

        if(personAccount != null && accnRel != null) {
            personAccount.Highest_Qualification__pc = highestQualification;
            personAccount.Number_Of_YearIn_The_Specific_Industry__c = numberOfYearInIndustry;
            personAccount.Months_Actively_Involved_In_The_Business__c = monthsActivelyInvolvedInTheBusiness;
            personAccount.Is_the_Client_a_Non_resident__c = isNonSAResident;
            personAccount.Is_the_Client_a_Temporary_Resident__c = isTemporaryResident;
            personAccount.Business_Address_Line_1__c = residentailAddress;
            accnRel.Date_Shareholding_Acquired__c = Date.valueOf(dateShareholdingAcquired);
            personAccount.Months_Since_Shareholding__c = (Integer.valueOf(monthsSinceShareholding) == 0 ? accnRel?.Date_Shareholding_Acquired__c?.monthsBetween(Date.today()) : Integer.valueOf(monthsSinceShareholding));

            try {
                //update contact;
                update accnRel;
                update personAccount;
                returnReponse = 'Principal Details Updated Successfully!';
            }
            catch(Exception exp) {
                returnReponse = String.valueOf('Failed to ' + exp.getMessage());
            }
        }

        return returnReponse;
    }

    @AuraEnabled
    public static Map<String, Object> getSelectedParties(Id acrId) {
        AccountContactRelation accnRel = new AccountContactRelationSelector().selectbyAccountContactRelationId(acrId);
        Map<String,String> mapObj = new Map<String,String>();
        Account personAccount = new AccountsSelector().selectAccountByPersonContactId(accnRel?.Contact.Id, 1);

        if (!isNull(accnRel)) {
            mapObj.put('Id', accnRel?.Id);
            mapObj.put('AccountId', accnRel?.AccountId);
            mapObj.put('ContactId', accnRel?.ContactId);
            mapObj.put('FullName', accnRel?.Contact.Name);
            mapObj.put('IDNumber', accnRel?.Contact.ID_Number__c);
            mapObj.put('CASAReferenceNumber', accnRel?.Contact.CASA_Reference_Number__c);
            mapObj.put('CIF', accnRel?.Contact.CIF__c);
            mapObj.put('ClientType', personAccount?.Client_Type__c);
            mapObj.put('CASAScreeningStatus', accnRel?.Contact.CASA_Screening_Status__c);
            mapObj.put('Nationality', accnRel?.Contact.Nationality__c);
            mapObj.put('IdType', accnRel?.Contact.ID_Type__c);
            mapObj.put('Birthdate', String.valueOf(accnRel?.Contact.Birthdate));
            mapObj.put('SharePercentage', String.valueOf(accnRel?.Share_Percentage__c));
            mapObj.put('Roles', accnRel?.Roles);
            mapObj.put('StartDate', String.valueOf(accnRel?.StartDate));
            mapObj.put('DateShareholdingAcquired', String.valueOf(accnRel?.Date_Shareholding_Acquired__c));
            mapObj.put('CASAScreeningDate', String.valueOf(accnRel?.Contact.CASA_Screening_Date__c));
            mapObj.put('ClientName', accnRel?.Account.Name);
            mapObj.put('isNonSAResident', String.valueOf(personAccount?.Is_the_Client_a_Non_resident__c/*accnRel?.Account.Is_the_Client_a_Non_resident__c*/ == null ? false : /*accnRel?.Account.Is_the_Client_a_Non_resident__c*/personAccount?.Is_the_Client_a_Non_resident__c));
            mapObj.put('isTemporaryResident', String.valueOf(personAccount?.Is_the_Client_a_Temporary_Resident__c/*accnRel?.Account.Is_the_Client_a_Temporary_Resident__c*/ == null ? false : /*accnRel?.Account.Is_the_Client_a_Temporary_Resident__c*/personAccount?.Is_the_Client_a_Temporary_Resident__c));

            //mapObj.put('MonthsSinceShareholding', String.valueOf(accnRel?.Date_Shareholding_Acquired__c.monthsBetween(Date.today())));
            mapObj.put('MonthsSinceShareholding', personAccount?.Months_Since_Shareholding__c == null ? String.valueOf(accnRel?.Date_Shareholding_Acquired__c?.monthsBetween(Date.today())) : String.valueOf(personAccount?.Months_Since_Shareholding__c));

            mapObj.put('NumberOfYearInTheSpecificIndustry', personAccount?.Number_Of_YearIn_The_Specific_Industry__c);//accnRel?.Account.Number_Of_YearIn_The_Specific_Industry__c);
            mapObj.put('MonthsActivelyInvolvedInTheBusiness', personAccount?.Months_Actively_Involved_In_The_Business__c);//accnRel?.Account.Months_Actively_Involved_In_The_Business__c);
            mapObj.put('HighestQualification', personAccount?.Highest_Qualification__pc);//accnRel?.Contact.Highest_Qualification__c);
            mapObj.put('ContactSecId', accnRel?.Contact.Id);
            mapObj.put('AccountSecId', accnRel?.Account.Id);

            List<Address__c> addressList = new AddressesSelector().selectByAccountAndType(accnRel?.AccountId,'Residential');
            Address__c residAddress = (addressList?.size() > 0 ? addressList[0] : null);

            String addOption = (residAddress?.Address1__c != null ? residAddress?.Address1__c + ', ' : '');
            addOption += (residAddress?.Address2__c != null ? residAddress?.Address2__c + ', ' : '');
            addOption += (residAddress?.Billing_Suburb__c != null ? residAddress?.Billing_Suburb__c + ', ' : '');
            addOption += (residAddress?.Billing_City__c != null ? residAddress?.Billing_City__c + ', ' : '');
            addOption += (residAddress?.Billing_Zip_Postal_Code__c != null ? residAddress?.Billing_Zip_Postal_Code__c : '');

            if(personAccount?.Business_Address_Line_1__c != null) {
                mapObj.put('ResidentialAddress', personAccount?.Business_Address_Line_1__c);
            }
            else {
                mapObj.put('ResidentialAddress', addOption);
            }

            //mapObj.put('ResidentialAddress', personAccount?.Business_Address_Line_1__c);
        }

        return mapObj;
    }

    /**
     * TdB : Screen Priary Company and Principals
     *
     * @param OppId
     * @return Casa screening results
    */
    @AuraEnabled
    public static String principalCasaScreening(Id oppId) {
        String caseScreeeningResults = null;

        if(oppId != null) {
            caseScreeeningResults = OnboardingCASAScreeningController.callToCASAScreening(oppId);
        }

        return caseScreeeningResults;
    }

    @AuraEnabled
    public static Application__c getApplication(Id opportunityId) {
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityOnboardId(opportunityId);

        if(isNotNullOrEmpty(appList)){
            return appList[0];
        }
        return null;
    }

    /**
     * W-005598
     */
    @AuraEnabled
    public static String updatePrincipals(Id oppId, List<Id> selectedIDs, Id selectedMainID, Boolean IsInfoCorrect) {
        String returnMessage = 'SUCCESS';
        Account acccount = new AccountsSelector().selectIndvByOpportunityIdNew(oppId);
        List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount?.Id);
        List<Application__c> appDet = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().getApplicationPrincipals(appDet[0].Id);

        if(selectedIDs != null) {
            List<Application_Principal__c> appPrinUpList = new List<Application_Principal__c>();

            for(Integer i = 0; i < selectedIDs.size(); i++) {
                Id idI = selectedIDs[i];

                for(AccountContactRelation accnRel : accnRelList) {

                    if(accnRel?.Id == idI) {
                        Application_Principal__c appPrin = new Application_Principal__c();

                        if(isNotNullOrEmpty(appPrinList)) {
                            for(Application_Principal__c output : appPrinList) {
                                if(output.AccConRelId__c == accnRel?.Id) {
                                    appPrin.Id = output.Id;
                                    appPrin.AccConRelId__c = accnRel?.Id;
                                    appPrin.Application__c = appDet[0].Id;
                                    appPrin.Casa_Reference__c = accnRel?.Contact.CASA_Reference_Number__c;
                                    appPrin.Casa_Result__c = accnRel?.Contact.CASA_Screening_Status__c;
                                    appPrin.CIF__c = accnRel?.Contact.CIF__c;
                                    appPrin.Controlling_Interest__c = accnRel?.Share_Percentage__c;
                                    appPrin.Id_Number__c = accnRel?.Contact.ID_Number__c;
                                    appPrin.ID_Type__c = accnRel?.Contact.ID_Type__c; //Saurabh Added for W:006981
                                    appPrin.Main__c = (accnRel?.Id == selectedMainID ? true : false);
                                    appPrin.Is_Part_Of_Application__c = true;
                                    appPrin.Principal_Shareholder_Name__c = accnRel?.Contact.Name;
                                    appPrinUpList.add(appPrin);
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }
            }

            try {
                update appPrinUpList;
            }
            catch (Exception ex) {
                returnMessage = 'FAILURE: ' + ex.getDmlMessage(0);
            }
        }

        if(isNotNullOrEmpty(appDet)) {
            Application__c app = appDet[0];
            app.Is_Principal_Shareholder_Info_Correct__c = IsInfoCorrect;

            try {
                update app;
            }
            catch (Exception ex) {
                returnMessage = 'FAILURE: ' + ex.getDmlMessage(0);
            }
        }

        return returnMessage;
    }

    private static Boolean setMaxItemSelected(Decimal value, Id accId, Integer listSize) {
        //For auto selection of highest Share Percentage principal
        AggregateResult[] groupedResults = [SELECT MIN(Share_Percentage__c)min, MAX(Share_Percentage__c)max FROM AccountContactRelation WHERE AccountId = :accId AND Share_Percentage__c != 0];
        Decimal maxValue = (Decimal)groupedResults[0].get('max');
        Decimal minValue = (Decimal)groupedResults[0].get('min');
        AccountContactRelation[] maxValueList = [SELECT Id FROM AccountContactRelation WHERE AccountId = :accId AND Share_Percentage__c =: maxValue];

        if(value > minValue || value == minValue) {
            isMaxSingle = (maxValueList?.size() > 1 ? false : true);
            isHighestMaxValue = (maxValue != value ? false : true);
            return true;
        }
        return false;
    }

    private static Boolean isNull(sObject objectToCheck) {
        return (objectToCheck == null);
    }

    private static Boolean isNotNullOrEmpty(List<sObject> objList) {
        return objList?.size() > 0 ;
    }
}