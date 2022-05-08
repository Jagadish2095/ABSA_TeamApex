/*<!--Controller for handling the TransUnion Consumer Service (MerchantTransUnionConsumerCheck)-->
<!--@author  Saurabh / Jason-->
<!--@since   2020-5-18-->
<!--@Work Id: W-004361--> */

/*
* @Updated By - Pitso Sekhu
* @Updated Date- 2021-03-18Em
* @Update Notes - Changes to EnquirerContactPhoneNo & EnquirerContactName from Hard coded value to Custom Label
*--------------------------------------
*/

public class MerchantTransUnionCheckController {

    /* Method which loads the TransUnion Service Existing Records (Credit_Risk_Check__c and Credit_Risk_Check_Entry__c)
    * @author  Saurabh / Jason
    * @Param : oppId
    * @return: Map<String,List<SObject>> for TransUnion
    */
    @AuraEnabled
    public static Map<String,List<SObject>> loadExistingTransUnionCheckRecordMap(string oppId){

        Map<String,List<SObject>> responseMap = new Map<String,List<SObject>>();
        //Query Opportunity Record
        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);
        //Query Credit_Risk_Check__c Records
        List<Credit_Risk_Check__c> creditRiskCheckList = new CreditRiskChecksSelector().selectByAccountIdAndServiceType(oppRecord.AccountId, 'TransUnion');
        List<Id> idList = new List<Id>();
        for(Credit_Risk_Check__c crc : creditRiskCheckList){
            idList.add(crc.Id);
        }
        //Query Credit_Risk_Check_Entry__c Records
        List<Credit_Risk_Check_Entry__c> creditRiskCheckEntryList = new CreditRiskCheckEntriesSelector().selectByCreditRiskCheckIdList(idList);
        responseMap.put('CreditRiskCheckList', creditRiskCheckList);
        responseMap.put('CreditRiskCheckEntryList', creditRiskCheckEntryList);

        return responseMap;
    }

    /* Method which Calls the TransUnion Service
    * @author  Saurabh / Jason
    * @Param : oppId
    * @return: Map<String,List<SObject>> for TransUnion
    */
    @AuraEnabled
    public static Map<String,List<SObject>> callTransUnionConsumerCheckService(string oppId){

        Map<String,List<SObject>> responseSObjectMap = new Map<String,List<SObject>>();
        Map<Integer,Credit_Risk_Check__c> creditRiskCheckMap = new Map<Integer,Credit_Risk_Check__c>();
        Map<Integer,List<Credit_Risk_Check_Entry__c>> creditRiskCheckEntityListMap = new Map<Integer,List<Credit_Risk_Check_Entry__c>>();
        List<Credit_Risk_Check_Entry__c> creditRiskCheckEntryList = new List<Credit_Risk_Check_Entry__c>();
        List<Contact> directorsListwithFields = new List<Contact>();

        boolean sendforApproval = false;
        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);
        Set<Id> directorContactIdSet = new Set<Id>();


        //Start of Changes made by Saurabh to check for a Sole Prop Account
        Account accRecord = [SELECT Id,  RecordType.Name, Client_Type__c, Client_Group__c FROM Account where Id =: oppRecord.AccountId];

        if(accRecord.RecordType.Name == 'Individual Prospect' && (accRecord.Client_Type__c == 'SOLE TRADER') && (accRecord.Client_Group__c == 'SOLE TRADER CLIENT' )){
            directorsListwithFields =  [SELECT LastName,Name, FirstName, AccountId, Id,MobilePhone, Email, Birthdate, ID_Number__c, ID_Type__c FROM Contact where AccountId =: accRecord.Id ];
        }else{
            List<Id> directorContactIdList = new List<Id>();
            List<AccountContactRelation> availableDirectorsList = [SELECT id, ContactId, AccountId,Roles FROM AccountContactRelation WHERE AccountId =: oppRecord.AccountId AND Roles includes ('Director')];
            for (AccountContactRelation acr:availableDirectorsList ){
                directorContactIdList.add(acr.ContactId);
            }
            directorsListwithFields = [SELECT LastName,Name, FirstName, AccountId, Id,MobilePhone, Email, Birthdate, ID_Number__c, ID_Type__c FROM Contact where Id =: directorContactIdList ];
        }
        //End of Saurabh's changes

        Integer directorIndex = 0;
        //iterating over Each Director to call TransUnion
        for (Contact con : directorsListwithFields){

            //Map request
            TransunionProcessRequest41_Req_IB_v1 requestBean = mapTransunionRequestFields(con, oppId);
            //Send Request and Receive Response
            TransunionProcessRequest41_Resp_IB_v1 responseBean = TransunionProcessRequest41_IH_v1.TransunionProcessRequest41(requestBean);

            if(responseBean.statusCode == 200 && responseBean.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ErrorMessage != null ){
                //Error in Response
             throw new AuraHandledException( responseBean.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ErrorMessage + ' for ' + con.Name);

            } else if(responseBean.statusCode == 200){

                //Map response to SObjects
                Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> responseMapFromMapFields = mapTransunionResponseFields(responseBean, oppRecord, con);
                List<Credit_Risk_Check__c> mapKeys = new List<Credit_Risk_Check__c>(responseMapFromMapFields.keySet());
                Credit_Risk_Check__c  creditRiskCheck = mapKeys[0];
                //Store SObjects in map at the same key
                creditRiskCheckMap.put(directorIndex, creditRiskCheck);
                creditRiskCheckEntityListMap.put(directorIndex, responseMapFromMapFields.values()[0]);

                //Check if Approval Process is Needed
                if(creditRiskCheck.Notices__c != null && Integer.valueOf(creditRiskCheck.Notices__c) > 0){
                    sendforApproval = true;
                }else if(creditRiskCheck.Judgements__c != null && Integer.valueOf(creditRiskCheck.Judgements__c) > 0){
                    sendforApproval = true;
                }
            }else{
                throw new AuraHandledException('TransUnion Check Failed for: ' + con.Name);
            }
            directorIndex++;
        }
        //DMLs
        try{
            Integer creditRiskIndex = 0;
            if(!creditRiskCheckMap.values().isEmpty()){
                //Insert Credit_Risk_Check__c Records
                insert creditRiskCheckMap.values();
                //Map Credit_Risk_Check__c Id Field for the corresponding Credit_Risk_Check__c Record
                do{
                    for(Credit_Risk_Check_Entry__c creditRiskEntry : creditRiskCheckEntityListMap.get(creditRiskIndex)){
                        creditRiskEntry.Credit_Risk_Check__c = creditRiskCheckMap.get(creditRiskIndex).Id;
                        creditRiskCheckEntryList.add(creditRiskEntry);
                    }
                    creditRiskIndex++;
                }while(creditRiskIndex < creditRiskCheckMap.values().size());

                if(!creditRiskCheckEntryList.isEmpty()){
                    //Insert Credit_Risk_Check_Entry__c Records
                    insert creditRiskCheckEntryList;
                }
            }
            //Start Changes made by Himani for #W-005293
            if(sendforApproval) {
               responseSObjectMap.put('sendforApproval', new List<SObject>());
            }
            //End Changes made by Himani for #W-005293

            //Code commented as part of changes made for #W-005293
            /*
            if(sendforApproval) {
                oppRecord.Trigger_Approval_Process__c = 'TransUnion Risk Check';
                oppRecord.Approval_Status__c = 'Pending';
                oppRecord.Merchant_TransUnion_Inquiry_Passed__c = false;
                update oppRecord;
            }else{
                oppRecord.Merchant_TransUnion_Inquiry_Passed__c = true;
                update oppRecord;
            }
            */
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        responseSObjectMap.put('CreditRiskCheckList', creditRiskCheckMap.values());
        responseSObjectMap.put('CreditRiskCheckEntryList', creditRiskCheckEntryList);
        return responseSObjectMap;
    }

    /* Method which maps the request fields for the TransUnion Service
    * @author  Saurabh
    * @Param : conP, oppId
    * @return: TransunionProcessRequest41_Req_IB_v1 for TransUnion
    */
    public static TransunionProcessRequest41_Req_IB_v1 mapTransunionRequestFields(Contact conP, Id oppIdP) {
        String city;
        String suburb;
        String address;
        String postalCode;
        string birthday;
        string idNumber;
        List<Address__c> conAddress = new AddressesSelector().addressesRelatedToContact(conP.Id);

        for (Address__c addr : conAddress){
            if (addr.Address_Type__c == 'Physical Address' || addr.Address_Type__c == 'Residential' || addr.Address_Type__c == 'Postal' ){
                //City
                if(addr.Shipping_City__c == '' || addr.Shipping_City__c == null){
                    city = addr.Address3__c;
                }else{
                    city = addr.Shipping_City__c;
                }
                //Postal Code
                if(addr.Shipping_Zip_Postal_Code__c == '' || addr.Shipping_Zip_Postal_Code__c == null){
                    postalCode = addr.Address5__c;
                }else{
                    postalCode = addr.Shipping_Zip_Postal_Code__c;
                }
                //Suburb
                if(addr.Shipping_Suburb__c == '' || addr.Shipping_Suburb__c == null){
                    suburb = addr.Address2__c;
                }else{
                    suburb = addr.Shipping_Suburb__c;
                }
                //Address Line 1
                if(addr.Shipping_Street__c == '' || addr.Shipping_Street__c == null){
                    address = addr.Address1__c;
                }else{
                    address = addr.Shipping_Street__c;
                }
            }
        }
        if(conP.Birthdate == null ){
            throw new AuraHandledException('BirthDate Not available for: ' + conP.Name);
        }else{
            birthday = (string.valueof(conP.Birthdate)).replace('-','');
        }

        if(conP.ID_Type__c =='SA Identity Document'){
            idNumber= conP.ID_Number__c;
        }else{
            throw new AuraHandledException('SA Id Not available for: ' + conP.Name);
        }

        //creating RequestBean Instance
        TransunionProcessRequest41_Req_IB_v1 requestBean = new TransunionProcessRequest41_Req_IB_v1();
        requestBean.ProcessRequestTrans41 = new TransunionProcessRequest41_Req_IB_v1.ProcessRequestTrans41();
        requestBean.ProcessRequestTrans41.BureauEnquiry41 = new TransunionProcessRequest41_Req_IB_v1.BureauEnquiry41();
        requestBean.ProcessRequestTrans41.Destination = System.Label.TransUnionDestination; //can be configured in Prod
        requestBean.ProcessRequestTrans41.BureauEnquiry41.ClientRequestID = String.valueOf(oppIdP).substring(0, 15); //generating unique 15 digit request id//'200310080706859';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.SubscriberCode = System.Label.TransUnion_SubscriberCode; //can be configured in Prod
        requestBean.ProcessRequestTrans41.BureauEnquiry41.ClientReference = String.valueOf(oppIdP).substring(0, 15);
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BranchNumber = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BatchNumber = System.Label.TransUnion_Batch_No;//can be configured in Prod
        requestBean.ProcessRequestTrans41.BureauEnquiry41.SecurityCode = System.Label.TransUnion_SecurityCode;//can be configured in Prod
        requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquirerContactName = System.Label.TransUnion_EnquirerContactName;//can be configured in Prod
        requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquirerContactPhoneNo = System.Label.TransUnion_EnquirerContactPhoneNo;//can be configured in Prod
        requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquiryAmount = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquiryType = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Surname = conP.LastName;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Forename1 = conP.FirstName;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Forename2 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Forename3 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.MaidenName = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BirthDate = birthday;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.IdentityNo1 = idNumber;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.IdentityNo2 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Sex = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Title = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.MaritalStatus = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.NoOfDependants = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.AddressLine1 = address;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.AddressLine2 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Suburb = suburb;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.City = city;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.PostalCode = postalcode;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.ProvinceCode = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address1Period = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.OwnerTenant = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.HomeTelCode = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.HomeTelNo = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.WorkTelCode = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.WorkTelNo = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.SpouseForename1 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.SpouseForename2 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Line1 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Line2 = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Suburb = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2City = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2PostalCode = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2ProvinceCode = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Period = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Occupation = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Employer = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.EmploymentPeriod = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.Salary = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BankName = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BankBranch = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BankBranchCode = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.BankAccountNumber = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.OperatorIdentity = '';
        requestBean.ProcessRequestTrans41.BureauEnquiry41.CellNo = conP.MobilePhone;
        requestBean.ProcessRequestTrans41.BureauEnquiry41.EmailAddress = conP.Email;

        return requestBean;
    }

    /* Method which maps the Response fields for the TransUnion Service
    * @author  Saurabh / Jason
    * @Param : respBeanP, oppP, conP
    * @return: Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> for TransUnion
    */
    public static Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> mapTransunionResponseFields(TransunionProcessRequest41_Resp_IB_v1 respBeanP, Opportunity oppP, Contact conP) {

        Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>> responseMap = new Map<Credit_Risk_Check__c,List<Credit_Risk_Check_Entry__c>>();
        List<Credit_Risk_Check_Entry__c> crceList = new List<Credit_Risk_Check_Entry__c>();
        Credit_Risk_Check__c  creditRiskCheck = new Credit_Risk_Check__c();
        creditRiskCheck.AccountId__c = oppP.AccountId;
        creditRiskCheck.Service_Type__c = 'TransUnion';
        creditRiskCheck.Name = conP.Name;
        creditRiskCheck.ServiceResponse__c = Sys_Utilities_General.truncateFieldIfNeeded(string.valueOf(respBeanP), 131070);//Field length of Rich Text Area
        creditRiskCheck.Operator_Name__c = UserInfo.getName();

        if(respBeanP.Envelope != null){
            if(respBeanP.Envelope.body != null){
                if(respBeanP.Envelope.body.ProcessRequestTrans41Response != null){
                    if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result != null){
                        //Enquiry Date
                        creditRiskCheck.Enquiry_Date__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ProcessingStartDate;
                        //Credit Score
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ScoreCardAC01 != null){	
                            creditRiskCheck.Credit_Score__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EmpiricaEM04.EmpiricaScore;
                        }
                        //ITC Reference Number
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EchoData0001 != null){
                            creditRiskCheck.Reference_Number__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EchoData0001.ClientReference;
                        }
                        //Customer Info
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04 != null){
                            String initials = '';
                            initials += respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Forename1 != null ? respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Forename1.substring(0,1) : '';
                            initials += respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Forename2 != null ? respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Forename2.substring(0,1) : '';
                            initials += respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Forename3 != null ? respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Forename3.substring(0,1) : '';

                            creditRiskCheck.Initials__c = initials;
                            creditRiskCheck.Surname__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Surname;
                            creditRiskCheck.Title__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.Title;
                            creditRiskCheck.Date_of_Birth__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.DateOfBirth;
                            creditRiskCheck.ID_Number__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.IdentityNo1;
                            creditRiskCheck.Marital_Status__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.MaritalStatusDesc;
                            creditRiskCheck.Telephone_Number__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.TelephoneNumbers;
                            creditRiskCheck.Spouse_Name__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerInfoNO04.SpouseName1;
                        }
                        //Employment Info
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EmploymentNM04 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EmploymentNM04.EmploymentNM04.size() > 0){
                                creditRiskCheck.Employer_Name__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EmploymentNM04.EmploymentNM04[0].EmployerName;
                            }
                        }
                        //Address
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AddressNA07 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AddressNA07.AddressNA07.size() > 0){
                                creditRiskCheck.Address_Line_1__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AddressNA07.AddressNA07[0].Line1;
                                creditRiskCheck.Address_Line_2__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AddressNA07.AddressNA07[0].Line2;
                                creditRiskCheck.Address_Line_3__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AddressNA07.AddressNA07[0].Suburb;
                                creditRiskCheck.Address_Line_4__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AddressNA07.AddressNA07[0].City;
                            }
                        }
                        //AKA Names
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AKANamesNK04 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AKANamesNK04.AKANamesNK04.size() > 0){
                                creditRiskCheck.AKA_Name_1__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AKANamesNK04.AKANamesNK04[0].AKAName;
                                if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AKANamesNK04.AKANamesNK04.size() > 1){
                                    creditRiskCheck.AKA_Name_2__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AKANamesNK04.AKANamesNK04[1].AKAName;
                                }
                            }
                        }
                        //Totals Ever
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AggregateNX33 != null){
                            creditRiskCheck.Total_Enquiries__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AggregateNX33.EnquiriesEver;
                            creditRiskCheck.Bank_Adv__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AggregateNX33.TotalAdverseEver;
                            creditRiskCheck.Notices__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AggregateNX33.TotalNoticesEver;
                            creditRiskCheck.Judgements__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.AggregateNX33.TotalJudgments;
                        }

                        //Debt Counselling for Notices
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DebtCounsellingDC01 != null){
                            creditRiskCheck.Debt_Restructuring_Counselling__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DebtCounsellingDC01.DebtCounsellingDescription;
                        }

                        //In The Last
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50 != null){
                            //Enquiries
                            creditRiskCheck.Absa_Enquiries_in_the_last_1_Year__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.OwnEnquiries1YrBack;
                            creditRiskCheck.Absa_Enquiries_in_the_last_2_Years__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.OwnEnquiries2YrsBack;
                            creditRiskCheck.Absa_Enquiries_in_the_last_2_Years_Plus__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.OwnEnquiriesMoreThen2YrsBack;
                            creditRiskCheck.Other_Enquiries_in_the_last_1_Year__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.OtherEnquiries1YrBack;
                            creditRiskCheck.Other_Enquiries_in_the_last_2_Years__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.OtherEnquiries2YrsBack;
                            creditRiskCheck.Other_Enquiries_in_the_last_2_Years_Plus__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.OtherEnquiriesMoreThen2YrsBack;
                            //Judgements
                            creditRiskCheck.Judgements_in_the_last_1_Year__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.Judgements1YrBack;
                            creditRiskCheck.Judgements_in_the_last_2_Years__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.Judgements2YrsBack;
                            creditRiskCheck.Judgements_in_the_last_2_Years_Plus__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.JudgementsMoreThen2YrsBack;
                            //Defaults
                            creditRiskCheck.Defaults_in_the_last_1_Year__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.Defaults1YrBack;
                            creditRiskCheck.Defaults_in_the_last_2_Years__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.Defaults2YrsBack;
                            creditRiskCheck.Defaults_in_the_last_2_Years_Plus__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC50.DefaultsMoreThen2YrsBack;
                        }
                        //Trace Alerts
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC04 != null){
                            creditRiskCheck.Trace_Alert_in_the_last_1_Year__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC04.TraceAlerts1YrBack;
                            creditRiskCheck.Trace_Alert_in_the_last_2_Years__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC04.TraceAlerts2YrsBack;
                            creditRiskCheck.Trace_Alert_in_the_last_2_Years_Plus__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.ConsumerCountersNC04.TraceAlertsMoreThen2YrsBack;
                        }
                        //Defaults
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DefaultsD701Part1 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DefaultsD701Part1.DefaultD701Part1 != null){

                                creditRiskCheck.Defaults__c = String.valueOf(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DefaultsD701Part1.DefaultD701Part1.size());
                                creditRiskCheck.Defaults_Recent_Date__c = respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DefaultsD701Part1.DefaultD701Part1[0].InformationDate;

                                for(TransunionProcessRequest41_Resp_IB_v1.DefaultD701Part1 defaultEntry : respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.DefaultsD701Part1.DefaultD701Part1){
                                    //Create Credit Risk Entry Object
                                    Credit_Risk_Check_Entry__c creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                                    creditRiskCheckEntry.Entry_Type__c = 'Default';
                                    creditRiskCheckEntry.Date__c = defaultEntry.InformationDate;
                                    creditRiskCheckEntry.Amount__c = defaultEntry.DefaultAmount;
                                    creditRiskCheckEntry.Type__c = defaultEntry.DefaultType;
                                    creditRiskCheckEntry.Source__c = defaultEntry.SupplierName;
                                    creditRiskCheckEntry.Account_Number__c = defaultEntry.AccountNo;
                                    creditRiskCheckEntry.Remarks__c = defaultEntry.Remarks1; //+ defaultEntry.Remarks2;
                                    crceList.add(creditRiskCheckEntry);
                                }
                            }else{
                                creditRiskCheck.Defaults__c = '00';
                            }
                        }else{
                            creditRiskCheck.Defaults__c = '00';
                        }

                        //Enquiries
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EnquiriesNE50 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EnquiriesNE50.EnquiryNE50 != null){
                                Integer totalEnquiries = 0;
                                Integer totalAbsaEnquiries = 0;
                                Integer totalOtherEnquiries = 0;

                                for(TransunionProcessRequest41_Resp_IB_v1.EnquiryNE50 enquiry : respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.EnquiriesNE50.EnquiryNE50){
                                    //Create Credit Risk Entry Object
                                    Credit_Risk_Check_Entry__c creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                                    creditRiskCheckEntry.Entry_Type__c = 'Enquirer';
                                    creditRiskCheckEntry.Date__c = enquiry.DateOfEnquiry;
                                    creditRiskCheckEntry.Subscriber__c =  enquiry.Subscriber;
                                    creditRiskCheckEntry.Contact_Name_Number__c =  enquiry.Contact;
                                    crceList.add(creditRiskCheckEntry);
                                    //Count Enquierer Types
                                    if(enquiry.Subscriber != null && enquiry.Subscriber.contains('Absa')){
                                        totalAbsaEnquiries++;
                                    }else{
                                        totalOtherEnquiries++;
                                    }
                                    totalEnquiries++;
                                }
                                creditRiskCheck.Total_Enquiries__c = String.valueOf(totalEnquiries);
                                creditRiskCheck.ABSA_Enquiries__c = String.valueOf(totalAbsaEnquiries);
                                creditRiskCheck.Other_Enquiries__c = String.valueOf(totalOtherEnquiries);
                            }
                        }

                        //Notices
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.NoticesNN08 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.NoticesNN08.NoticesNN08 != null){
                                for(TransunionProcessRequest41_Resp_IB_v1.NoticesNN08 notice : respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.NoticesNN08.NoticesNN08){
                                    //Create Credit Risk Entry Object
                                    Credit_Risk_Check_Entry__c creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                                    creditRiskCheckEntry.Entry_Type__c = 'Notice';
                                    creditRiskCheckEntry.Date__c = notice.CaptureDate;
                                    creditRiskCheckEntry.Notice_Date__c = notice.NoticeDate;
                                    creditRiskCheckEntry.Type__c = notice.NoticeType;
                                    //creditRiskCheckEntry.Debt_Restructuring TBC
                                    creditRiskCheckEntry.Code__c = notice.CourtTypeCode;
                                    creditRiskCheckEntry.Description__c = notice.CourtTypeDesc;
                                    crceList.add(creditRiskCheckEntry);
                                }
                            }
                        }

                        //Judgements
                        if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.JudgementsNJ07 != null){
                            if(respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.JudgementsNJ07.JudgementsNJ07 != null){
                                Integer highestValue = 0; //Int variable because we need to calculate the highest value
                                String highestValueDate;
                                String recentValue;
                                Integer recentValueDate = 0; //Int variable because we need to calculate most recent date (highest value)

                                for(TransunionProcessRequest41_Resp_IB_v1.JudgementsNJ07 judgement : respBeanP.Envelope.body.ProcessRequestTrans41Response.ProcessRequestTrans41Result.JudgementsNJ07.JudgementsNJ07){
                                    //Create Credit Risk Entry Object
                                    Credit_Risk_Check_Entry__c creditRiskCheckEntry = new Credit_Risk_Check_Entry__c();
                                    creditRiskCheckEntry.Entry_Type__c = 'Judgement';
                                    creditRiskCheckEntry.Date__c = judgement.JudgmentDate;
                                    creditRiskCheckEntry.Amount__c = judgement.Amount;
                                    creditRiskCheckEntry.Type__c = judgement.JudgmentTypeDesc;
                                    creditRiskCheckEntry.Nature__c = judgement.NatureOfDebtDesc;
                                    creditRiskCheckEntry.Court_Type__c = judgement.CourtTypeDesc;
                                    creditRiskCheckEntry.Case_No__c = judgement.CaseNo;
                                    creditRiskCheckEntry.Plaintiff__c = judgement.Plaintiff;
                                    crceList.add(creditRiskCheckEntry);

                                    //Check if current Amount is the highest
                                    if(judgement.Amount != null && Integer.valueOf(judgement.Amount) > highestValue){
                                        highestValue = Integer.valueOf(judgement.Amount);
                                        highestValueDate = judgement.JudgmentDate;
                                    }
                                    //Check if current Date is the most recent (highest)
                                    if(judgement.JudgmentDate != null && Integer.valueOf(judgement.JudgmentDate) > recentValueDate){
                                        recentValue = judgement.Amount;
                                        recentValueDate = Integer.valueOf(judgement.JudgmentDate);
                                    }
                                }
                                creditRiskCheck.Judgement_Highest_Value__c = String.valueOf(highestValue);
                                creditRiskCheck.Judgement_Highest_Value_Date__c = highestValueDate;
                                creditRiskCheck.Judgement_Recent_Value__c = recentValue;
                                creditRiskCheck.Judgement_Recent_Date__c =  recentValueDate != 0 ? String.valueOf(recentValueDate) : null; //Set Date back to null if no other dates were found
                            }
                        }
                    }
                }
            }
        }
        //Add Objects to Response Map
        responseMap.put(creditRiskCheck, crceList);
        return responseMap;
    }
}