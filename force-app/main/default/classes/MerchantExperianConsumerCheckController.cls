/*Controller for handeling the Experian 
* Controller for : MerchantExperianConsumerCheck component
*/

public class MerchantExperianConsumerCheckController {

    /* Method which Calls the Experian Service
    * @Param : Id - oppId
    * @return: Map<String,List<SObject>> - Map of a list of Credit_Risk_Check__c and the related child records list Credit_Risk_Check_Entry__c
    */
    @AuraEnabled
    public static Map<String,List<SObject>> callExperianConsumerCheckService(Id oppId){
        System.debug('oppId: ' + oppId);

        Map<String,List<SObject>> responseSObjectMap = new Map<String,List<SObject>>();
        Map<Integer,Credit_Risk_Check__c> creditRiskCheckMap = new Map<Integer,Credit_Risk_Check__c>();
        Map<Integer,List<Credit_Risk_Check_Entry__c>> creditRiskCheckEntityListMap = new Map<Integer,List<Credit_Risk_Check_Entry__c>>();
        List<Credit_Risk_Check_Entry__c> creditRiskCheckEntryList = new List<Credit_Risk_Check_Entry__c>();
        List<Contact> directorsListwithFields = new List<Contact>();//W-005210: Danie on 2020/07/02

        Boolean sendforApproval = false;
        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);

        //Start of changes for W-005210 to include Sole Prop Account for Experian made by Danie on 2020/07/02
        List<Account> accountList = new AccountsSelector().selectCasaFieldsById(oppRecord.AccountId, 1);//Retrieves all the required fields
        Account accRecord;
        if(accountList != null && accountList.size() > 0) {
            accRecord = accountList[0];
        } else {
            throw new AuraHandledException('Account list is empty. Could not find account with Id: ' + oppRecord.AccountId);
        }

        if(accRecord.RecordType.Name == 'Individual Prospect' && (accRecord.Client_Type__c == 'SOLE TRADER') && (accRecord.Client_Group__c == 'SOLE TRADER CLIENT' )){
            directorsListwithFields = new ContactsSelector().selectCifFieldsByAccountId(accRecord.Id);//Retrieves all the required fields
        }else{
            Set<Id> directorContactIdSet = new Set<Id>();
            List<AccountContactRelation> availableDirectorsList = new AccountContactRelationSelector().selectbyAccountIdAndRoles(oppRecord.AccountId, 'Director');
            for (AccountContactRelation acr:availableDirectorsList ){
                directorContactIdSet.add(acr.ContactId);
            }
            directorsListwithFields = new ContactsSelector().selectCifFieldsBySetContactIds(directorContactIdSet);//Retrieves all the required fields
        }
        //End of W-005210 changes

        System.debug('directorsListwithFields: ' + directorsListwithFields);
        if(directorsListwithFields.size() > 0){
            Integer directorIndex = 0;

                //Call Experian Service
                ExperianGetXML2Report_Resp_IB_v2 responseBean = ExperianGetXML2Report_IH_v2.ExperianGetXML2Report(directorsListwithFields);
                System.debug('# ' + responseBean);

                if(responseBean.statusCode == 200){
                    //Map Response Fields if successful
                    for(ExperianGetXML2Report_Resp_IB_v2.GetXML2ReportResult experianContact : responseBean.GetXML2ReportResult){
                        Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> responseMapFromMapFields = mapExperianResponse(experianContact, oppRecord.AccountId);
                        List<Credit_Risk_Check__c> mapKeys = new List<Credit_Risk_Check__c>(responseMapFromMapFields.keySet());
                        Credit_Risk_Check__c  creditRiskCheck = mapKeys[0];
                        creditRiskCheckMap.put(directorIndex, creditRiskCheck);
                        creditRiskCheckEntityListMap.put(directorIndex, responseMapFromMapFields.values()[0]);

                        //Added for Approval Process
                        if((creditRiskCheck.Judgements__c!=null && creditRiskCheck.Judgements__c!='') || (creditRiskCheck.Notices__c!=null && creditRiskCheck.Notices__c!='')){
                            if(Integer.valueOf(creditRiskCheck.Judgements__c) >= 1 || (Integer.valueOf(creditRiskCheck.Notices__c) >= 1 )){
                                sendforApproval = true;
                            }
                        }
                        directorIndex++;
                    }
                }else if(responseBean.statusCode == 400){
                    throw new AuraHandledException('The Experian Risk Check was unsuccessful. Please ensure that all the directors of this Account have the following populated in their Contact record: Last Name, First Name, ID number, Birthdate (if ID type is Passport) ');
                }else{
                    throw new AuraHandledException('Experian Check Failed');
                }

            try{
                Integer creditRiskIndex = 0;
                if(!creditRiskCheckMap.values().isEmpty()){
                    insert creditRiskCheckMap.values();

                    do{
                        for(Credit_Risk_Check_Entry__c creditRiskEntry : creditRiskCheckEntityListMap.get(creditRiskIndex)){
                            creditRiskEntry.Credit_Risk_Check__c = creditRiskCheckMap.get(creditRiskIndex).Id;
                            creditRiskCheckEntryList.add(creditRiskEntry);
                        }
                        creditRiskIndex++;
                    }while(creditRiskIndex < creditRiskCheckMap.values().size());

                    if(!creditRiskCheckEntryList.isEmpty()){
                        insert creditRiskCheckEntryList;
                    }
                }
                //Start Changes made by Himani for #W-005292
                if(sendforApproval) {
                responseSObjectMap.put('sendforApproval', new List<SObject>());
                }
                //End Changes made by Himani for #W-005292
            }catch(DmlException de){
                responseSObjectMap.put('error', new List<SObject>());
                for(Integer i=0; i<de.getNumDml(); i++) {
                    System.debug('getDmlFieldNames= ' + de.getDmlFieldNames(i) + '' + 'getDmlMessage= ' + de.getDmlMessage(i));
                }
            }
        }else{
            responseSObjectMap.put('noContact', new List<SObject>());
        }
        responseSObjectMap.put('CreditRiskCheckList', creditRiskCheckMap.values());
        responseSObjectMap.put('CreditRiskCheckEntryList', creditRiskCheckEntryList);
        return responseSObjectMap;
    }

    /* Method which loads the Experian Service Existing Records
    * @Param : String - oppId
    * @return: List<Credit_Risk_Check__c> for Experian
    */
    @AuraEnabled
    public static Map<String,List<SObject>> loadExistingExperianCheckRecordsMap(String oppId){
        Map<String,List<SObject>> responseMap = new Map<String,List<SObject>>();

        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);
        List<Credit_Risk_Check__c> creditRiskCheckList = new CreditRiskChecksSelector().selectByAccountIdAndServiceType(oppRecord.AccountId, 'Experian');
        List<Id> idList = new List<Id>();
        for(Credit_Risk_Check__c crc : creditRiskCheckList){
            idList.add(crc.Id);
        }
        List<Credit_Risk_Check_Entry__c> creditRiskCheckEntryList = new CreditRiskCheckEntriesSelector().selectByCreditRiskCheckIdList(idList);

        responseMap.put('CreditRiskCheckList', creditRiskCheckList);
        responseMap.put('CreditRiskCheckEntryList', creditRiskCheckEntryList);
        return responseMap;
    }

    /* Method which maps the response from the Experian Service to Salesforce Objects/Fields
    * @Param : ExperianGetXML2Report_Resp_IB_v2.GetXML2ReportResult - experianContactP,
    * @Param : Id accountIdP
    * @return: Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> - Map of a Credit_Risk_Check__c and the related child records list Credit_Risk_Check_Entry__c
    */
    public static Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> mapExperianResponse(ExperianGetXML2Report_Resp_IB_v2.GetXML2ReportResult experianContactP, Id accountIdP){

        Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> responseMap = new Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>>();
        Credit_Risk_Check__c  storeExperianResponseRecord = new Credit_Risk_Check__c();
        List<Credit_Risk_Check_Entry__c> experianCreditRiskEntryList = new List<Credit_Risk_Check_Entry__c>();
        Credit_Risk_Check_Entry__c creditRiskCheckEntry;

        storeExperianResponseRecord.AccountId__c = accountIdP;
        storeExperianResponseRecord.Service_Type__c ='Experian';

        if(experianContactP != null){

            storeExperianResponseRecord.Operator_Name__c = UserInfo.getName();//current user

            if(experianContactP.ScoreBlock != null){
                if(experianContactP.ScoreBlock.Delphi != null){
                    for(ExperianGetXML2Report_Resp_IB_v2.Delphi delphiScore : experianContactP.ScoreBlock.Delphi){
                        if(delphiScore.ScoreName == 'Delphi New Business G4 Banking'){
                            storeExperianResponseRecord.Credit_Score__c = delphiScore.Score;
                        }
                    }
                }
            }

            if(experianContactP.ReturnData != null){
                storeExperianResponseRecord.Reference_Number__c = experianContactP.ReturnData.ReferenceNo;
                storeExperianResponseRecord.Enquiry_Date__c = experianContactP.ReturnData.Date_Z + ' ' + experianContactP.ReturnData.Time_Z;

                //Customer Details
                storeExperianResponseRecord.Name = experianContactP.ReturnData.FirstName1;
                storeExperianResponseRecord.Surname__c = experianContactP.ReturnData.Surname;
                storeExperianResponseRecord.Title__c = experianContactP.ReturnData.Title;
                storeExperianResponseRecord.Date_of_Birth__c = experianContactP.ReturnData.Birthday;
                storeExperianResponseRecord.ID_Number__c = experianContactP.ReturnData.ID;

                //Primary Address
                if(experianContactP.ReturnData.Address != null){
                    if(experianContactP.ReturnData.Address.Relation == 'Primary Address'){
                        storeExperianResponseRecord.Address_Line_1__c = experianContactP.ReturnData.Address.Address_Line1;
                        storeExperianResponseRecord.Address_Line_2__c = experianContactP.ReturnData.Address.Address_Line2;
                        storeExperianResponseRecord.Address_Line_3__c = experianContactP.ReturnData.Address.CityArea;
                        storeExperianResponseRecord.Address_Line_4__c = experianContactP.ReturnData.Address.City;
                    }
                }
            }

            if(experianContactP.Defaults.Summary != null){
                //Summary
                //Total Judgements already mapped - Judgements__c
                if(experianContactP.Defaults.Summary.Notices != null){
                    storeExperianResponseRecord.Notices__c = experianContactP.Defaults.Summary.Notices.Total_Number_of_Notices_Ever;
                }
                //Total Defaults already mapped - Defaults__c
                //Total ABSA already mapped - ABSA_Enquiries__c
                //Total OTHERS already mapped - Other_Enquiries__c
                if(experianContactP.Defaults.Summary.Adverses != null){
                    if(experianContactP.Defaults.Summary.Adverses.CPA != null){
                        storeExperianResponseRecord.Bank_Adv__c = experianContactP.Defaults.Summary.Adverses.CPA.Total_Number_of_Adverses_Ever;
                    }
                }

                //Enquiries
                if(experianContactP.Defaults.Summary.Enquiries != null){
                    if(experianContactP.Defaults.Summary.Enquiries.CPA != null){
                        //All Enquiries
                        if(experianContactP.Defaults.Summary.Enquiries.CPA.All != null){
                            storeExperianResponseRecord.Total_Enquiries__c = experianContactP.Defaults.Summary.Enquiries.CPA.All.Total_Number_of_All_Enquiries_Ever;
                        }
                        //Absa Enquiries
                        if(experianContactP.Defaults.Summary.Enquiries.CPA.Own != null){
                            storeExperianResponseRecord.ABSA_Enquiries__c = experianContactP.Defaults.Summary.Enquiries.CPA.Own.Total_Number_of_Own_Enquiries_Ever;
                            storeExperianResponseRecord.Absa_Enquiries_in_the_last_30_Days__c = experianContactP.Defaults.Summary.Enquiries.CPA.Own.Number_of_Own_Enquiries_in_the_Last_30_days;
                            storeExperianResponseRecord.Absa_Enquiries_in_the_last_90_Days__c = experianContactP.Defaults.Summary.Enquiries.CPA.Own.Number_of_Own_Enquiries_in_the_Last_90_days;
                            storeExperianResponseRecord.Absa_Enquiries_in_the_last_180_Days__c = experianContactP.Defaults.Summary.Enquiries.CPA.Own.Number_of_Own_Enquiries_in_the_Last_180_days;
                            storeExperianResponseRecord.Absa_Enquiries_in_the_last_1_Year__c = experianContactP.Defaults.Summary.Enquiries.CPA.Own.Number_of_Own_Enquiries_in_the_Last_year;
                        }
                        //Other Enquiries
                        if(experianContactP.Defaults.Summary.Enquiries.CPA.Other != null){
                            storeExperianResponseRecord.Other_Enquiries__c = experianContactP.Defaults.Summary.Enquiries.CPA.Other.Total_Number_of_Other_Enquiries_Ever;
                            storeExperianResponseRecord.Other_Enquiries_in_the_last_30_Days__c = experianContactP.Defaults.Summary.Enquiries.CPA.Other.Number_of_Other_Enquiries_in_the_Last_30_days;
                            storeExperianResponseRecord.Other_Enquiries_in_the_last_90_Days__c = experianContactP.Defaults.Summary.Enquiries.CPA.Other.Number_of_Other_Enquiries_in_the_Last_90_days;
                            storeExperianResponseRecord.Other_Enquiries_in_the_last_180_Days__c = experianContactP.Defaults.Summary.Enquiries.CPA.Other.Number_of_Other_Enquiries_in_the_Last_180_days;
                            storeExperianResponseRecord.Other_Enquiries_in_the_last_1_Year__c = experianContactP.Defaults.Summary.Enquiries.CPA.Other.Number_of_Other_Enquiries_in_the_Last_year;
                        }
                    }
                }

                //Judgements
                if(experianContactP.Defaults.Summary.Judgements != null){
                    storeExperianResponseRecord.Judgements__c = experianContactP.Defaults.Summary.Judgements.Total_Number_of_Judgments_Ever;
                    storeExperianResponseRecord.Judgement_Value__c = experianContactP.Defaults.Summary.Judgements.Total_Judgment_Value;
                    storeExperianResponseRecord.Judgement_Highest_Value__c = experianContactP.Defaults.Summary.Judgements.Highest_Judgment_Value;
                    storeExperianResponseRecord.Judgement_Highest_Value_Date__c = experianContactP.Defaults.Summary.Judgements.Months_Since_Highest_Judgment;
                    storeExperianResponseRecord.Judgement_Recent_Date__c = experianContactP.Defaults.Summary.Judgements.Months_Since_Most_Recent_Judgment;
                    storeExperianResponseRecord.Judgement_Recent_Value__c = experianContactP.Defaults.Summary.Judgements.Value_of_Most_Recent_Judgment;
                    storeExperianResponseRecord.Judgements_in_the_last_1_Year__c = experianContactP.Defaults.Summary.Judgements.Number_of_Judgments_in_the_Last_year;
                    storeExperianResponseRecord.Judgements_in_the_last_2_Years__c = experianContactP.Defaults.Summary.Judgements.Number_of_Judgments_in_the_Last_2_years;
                    storeExperianResponseRecord.Judgements_in_the_last_5_Years__c = experianContactP.Defaults.Summary.Judgements.Number_of_Judgments_in_the_Last_5_years;
                }

                //Payment Profile Part 1
                if(experianContactP.Defaults.Summary.Payment_Profiles != null){
                    if(experianContactP.Defaults.Summary.Payment_Profiles.CPA != null){
                        if(experianContactP.Defaults.Summary.Payment_Profiles.CPA.All != null){
                            storeExperianResponseRecord.Total_Payment_Profiles__c = experianContactP.Defaults.Summary.Payment_Profiles.CPA.All.Number_of_All_PPs_Ever;
                            storeExperianResponseRecord.No_of_Closed_Payment_Profiles__c = experianContactP.Defaults.Summary.Payment_Profiles.CPA.All.Number_of_Closed_All_PPs;
                            storeExperianResponseRecord.No_of_Currently_Open_Payment_Profiles__c = experianContactP.Defaults.Summary.Payment_Profiles.CPA.All.Number_of_Currently_Open_All_PPs;
                            storeExperianResponseRecord.Total_Current_Balance_of_Payment_Profile__c = experianContactP.Defaults.Summary.Payment_Profiles.CPA.All.Total_Balance_of_All_Open_Account_PPs;
                            storeExperianResponseRecord.PP_Total_Monthly_Installment__c = experianContactP.Defaults.Summary.Payment_Profiles.CPA.All.Total_Monthly_One_Month_Installment_Z;
                        }
                    }
                }
            }

            //Payment Profile Part 2
            if(experianContactP.Detect != null){
                if(experianContactP.Detect.IDverification != null){
                    storeExperianResponseRecord.PP_ID_Verified__c = experianContactP.Detect.IDverification.IDverified;
                }
                storeExperianResponseRecord.PP_Dispute_Indicator__c = experianContactP.Detect.DisputeIndicator;
            }

            //Enquirers
            if(experianContactP.Enquiry != null){
                if(experianContactP.Enquiry.CPA != null){
                    if(experianContactP.Enquiry.CPA.Own != null){
                        for(ExperianGetXML2Report_Resp_IB_v2.Own enquirer: experianContactP.Enquiry.CPA.Own){
                            creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                            creditRiskCheckEntry.Entry_Type__c = 'Enquirer';
                            creditRiskCheckEntry.Date__c = enquirer.EnquiryDate;
                            creditRiskCheckEntry.Subscriber__c = enquirer.SubscriberName;
                            creditRiskCheckEntry.Contact_Name_Number__c = enquirer.SubscriberTel;
                            experianCreditRiskEntryList.add(creditRiskCheckEntry);
                        }
                    }
                }
            }

            //Judgements
            if(experianContactP.Judgements != null){
                if(experianContactP.Judgements.Judgement != null){
                    for(ExperianGetXML2Report_Resp_IB_v2.Judgement judgement: experianContactP.Judgements.Judgement){
                        creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                        creditRiskCheckEntry.Entry_Type__c = 'Judgement';
                        creditRiskCheckEntry.Date__c = judgement.JudgementDate;
                        creditRiskCheckEntry.Amount__c = judgement.JudgementAmount;
                        creditRiskCheckEntry.Court_Type__c = judgement.TypeOfCourt;
                        creditRiskCheckEntry.Nature__c = judgement.PublicDataCatCodeDesc;
                        creditRiskCheckEntry.Court_Name__c = judgement.CourtName;
                        creditRiskCheckEntry.Case_No__c = judgement.CaseNumber;
                        creditRiskCheckEntry.Plaintiff__c = judgement.Plaintiff;
                        experianCreditRiskEntryList.add(creditRiskCheckEntry);
                    }
                }
            }

            //Notices
            if(experianContactP.Notices != null){
                if(experianContactP.Notices.Notice != null){
                    for(ExperianGetXML2Report_Resp_IB_v2.Notice notice: experianContactP.Notices.Notice){
                        creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                        creditRiskCheckEntry.Entry_Type__c = 'Notice';
                        creditRiskCheckEntry.Date__c = notice.NoticeDate;
                        creditRiskCheckEntry.Type__c = notice.PublicDataCatCodeDesc;
                        creditRiskCheckEntry.Plaintiff__c = notice.Plaintiff;
                        experianCreditRiskEntryList.add(creditRiskCheckEntry);
                    }
                }
            }

            //Defaults
            Integer numberOfDefaults = 0; //Initialize the total defaults counter to 0 before checking to see if any defaults exists
            if(experianContactP.Defaults != null){
                if(experianContactP.Defaults.CPA != null){
                    if(experianContactP.Defaults.CPA.Other != null){
                        for(ExperianGetXML2Report_Resp_IB_v2.Other defaultEntry: experianContactP.Defaults.CPA.Other){
                            creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                            creditRiskCheckEntry.Entry_Type__c = 'Default';
                            creditRiskCheckEntry.Subscriber__c = defaultEntry.Subscriber;
                            creditRiskCheckEntry.Code__c = defaultEntry.Subscriber_Code;
                            creditRiskCheckEntry.Date__c = defaultEntry.LastPaymentDate;
                            creditRiskCheckEntry.Amount__c = defaultEntry.OverdueAmount;
                            experianCreditRiskEntryList.add(creditRiskCheckEntry);
                            numberOfDefaults++;
                        }
                    }
                }
            }
            //Total Defaults
            storeExperianResponseRecord.Defaults__c = String.valueOf(numberOfDefaults);

        }
        responseMap.put(storeExperianResponseRecord, experianCreditRiskEntryList);
        return responseMap;
    }

}