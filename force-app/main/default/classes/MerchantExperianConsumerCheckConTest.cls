@isTest
private class MerchantExperianConsumerCheckConTest {

    public static Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static final String POSITIVE_RESPONSE_BODY = '{"GetXML2ReportResult":[{"Session":{"User_ID":"TESTMAHL","FullName":"TESTMAHL","GroupName":"047353","Subscriber_ID":"047353","Group_ID":"047353","RequestType":"XML2","Environment":"TEST","Version":"1.0.0"},"InputData":{"First_Name_1":"DESERY","Surname":"GOVENDER","National_ID":"8109100231084","RSA_ID":"YES","Birthday":"19810910"},"SubscriberInfo":{"BusinessType":"0"},"ReturnData":{"Match":"1","Name":"DESERY  GOVENDER","Title":"MRS","Surname":"GOVENDER","FirstName1":"DESERY","ID":"8109100231084","Birthday":"19810910","Address":{"Relation":"Primary Address","ReportDate":"20200824","Address_Line1":"POSTNET SUITE RG    PRIVA","Address_Line2":null,"ZipCode":null},"ReferenceNo":"0452519812","Date":"2020-10-01","Time":"10:31","ExecTime":"7.2","SessionID":"THK9QJOCKHR"},"Detect":{"Flag":"Inactive","IDverification":{"IDverified":"Yes","SurnameVerified":"Yes","InitialsVerified":"Yes","ExperianIDnumber":"8109100231084","ExperianSurname":"GOVENDER","ExperianInitials":"DESERY"},"DisputeIndicator":"N"},"ScoreBlock":{"Delphi":[{"Score":"5","Scorecard_Identifier":"035","ReasonCode":"35073505350935083510","ScoreName":"Risk Rating","RequestID":"6"}]},"Enquiry":{"CPA":{"Own":[{"EnquiryDate":"20200929","SubscriberName":"ABSA RELATIONSHIP","Subscriber_Operator":"TESTMAHL"},{"EnquiryDate":"20200929","SubscriberName":"ABSA RELATIONSHIP","Subscriber_Operator":"TESTMAHL"},{"EnquiryDate":"20200929","SubscriberName":"ABSA RELATIONSHIP","Subscriber_Operator":"TESTMAHL"},{"EnquiryDate":"20200827","SubscriberName":"ABSA RELATIONSHIP","Subscriber_Operator":"TESTMAHL"}],"Other":[{"EnquiryDate":"20200910","SubscriberName":"MERCHTST","Subscriber_Operator":"MERCHTST"}]}},"Judgements":{"Judgement":[{"CourtName":"RANDBURG","CourtID":"204","CaseNumber":"142932018","JudgementDate":"20180906","JudgementAmount":"19120","TypeOfCourt":"2","Plaintiff":"THE INDEPENDENT INSTITUTE OF","Reason":"ARR","PublicDataCatCode":"100","PublicDataCatCodeDesc":"Judgement"},{"CourtName":"RANDBURG","CourtID":"204","CaseNumber":"61102018","JudgementDate":"20180716","JudgementAmount":"28650","TypeOfCourt":"2","Plaintiff":"THE INDEPENDENT INSTITUTE OF","Reason":"ARR","PublicDataCatCode":"100","PublicDataCatCodeDesc":"Judgement"}]},"Defaults":{"CPA":{"Other":[{"Subscriber":"OLD MUTUAL CONSOLIDATION","Subscriber_Code":"150345","AccountNo":"1               2345583002","AccountType":{"_code":null,"__text":null},"OpenDate":"20141016","OpenBalance":"60084","CreditLimit":"60084","CurrentBalance":"68377","BalanceDate":"20191106","LastPayment":"3043","LastPaymentDate":"20180306","Months_in_Arrears":"9","Status":{"_code":null,"__text":null},"StatusDate":"20191014","Industry_Code":null,"Installment":"1202","PaymentStatus":"09","OverdueAmount":"68377","Ownership_Type_Code":"0","Ownership_Type_Description":"Other","Payment_Type_Code":"00","Payment_Type_Description":"Other","Deferred_Payment_Date":"00000000","Repayment_Frequency_Code":"3","Repayment_Frequency_Desc":"Monthly","Account_Sold_Third_Party_Indicator":"0","Third_Party_Name":null,"No_of_Participants_Joint_Loan":"0","EndUseCode":"R","RepaymentPeriod":"0060","Worst_Payment_History":"W","Worst_history_in_the_last_12_months":"W","History_of_most_recent_12_months":"???????????9",'+
                                                        '"PaymentCycle":{"Payment":[{"StatusDate":"20201001","Months":"??","Status":{"_code":null,"__text":null},"OpenBalance":"0","CurrentBalance":"0","OverdueAmount":"0","Installment":"0"},{"StatusDate":"20200901","Months":"??","Status":{"_code":null,"__text":null},"OpenBalance":"0","CurrentBalance":"0","OverdueAmount":"0","Installment":"0"}]}}]},"Addresses":{"Address":[{"Relation":"Primary Address","ReportDate":"20200708","Address_Line1":"PO BOX 99","Address_Line2":"SONPARK","CityArea":"NELSPRUIT","ZipCode":"0012"}]},"Telephones":{"Telephone":[{"PhonePrefix":"83","PhoneNumber":"2106527","LastReportedDate":"20200308","PhoneType":"Cell"}]},"Employers":{"Employer":[{"Name":"DEPARTMENT OF HEALTH","Occupation":"ACCOUNTING CLERK    00","Employer_Address":"ACCOUNTING CLERK","Date_Supplied":"00000000","Income_Frequency":"M"}]},"Summary":{"Judgements":{"Total_Number_of_Judgments_Ever":"0","Number_of_Judgments_in_the_Last_30_days":"0","Number_of_Judgments_in_the_Last_90_days":"0","Number_of_Judgments_in_the_Last_180_days":"0","Number_of_Judgments_in_the_Last_year":"0","Number_of_Judgments_in_the_Last_2_years":"0","Number_of_Judgments_in_the_Last_3_years":"0","Number_of_Judgments_in_the_Last_4_years":"0","Number_of_Judgments_in_the_Last_5_years":"0","Total_Judgment_Value":"0","Highest_Judgment_Value":"0","Value_of_Most_Recent_Judgment":"0","Total_Number_of_Medical_Judgments":"0","Total_Value_of_Medical_Judgments":"0","Total_Number_of_Other_Judgments":"0","Total_Value_of_Other_Judgments":"0","Number_of_Judgments_in_the_Previous_6_Months":"0","Number_of_Judgments_in_the_Last_7_to_18_Months":"0","Number_of_Judgments_in_the_Last_19_to_36_Months":"0","Number_of_Judgments_Older_than_37_Months":"0"},"Adverses":{"CPA":{"Total_Number_of_Adverses_Ever":"2","Number_of_CPA_adverses_ever":"2"}},"Trace":{"Total_Number_of_Traces_Ever":"0","Number_of_Traces_in_the_Last_30_days":"0","Number_of_Traces_in_the_Last_60_days":"0","Number_of_Traces_in_the_Last_90_days":"0","Number_of_Traces_in_the_Last_180_days":"0","Number_of_Traces_in_the_Last_year":"0","Number_of_Traces_in_the_Last_2_years":"0","Number_of_Traces_in_the_Last_3_years":"0","Number_of_Traces_in_the_Last_4_years":"0","Number_of_Traces_in_the_Last_5_years":"0"},"Notices":{"Total_Number_of_Notices_Ever":"1","Number_of_Notices_in_the_Last_30_days":"0","Number_of_Notices_in_the_Last_90_days":"0","Number_of_Notices_in_the_Last_180_days":"0","Number_of_Notices_in_the_Last_year":"0","Number_of_Notices_in_the_Last_2_years":"0","Number_of_Notices_in_the_Last_3_years":"0","Number_of_Notices_in_the_Last_4_years":"0","Number_of_Notices_in_the_Last_5_years":"1","Number_of_Notices_in_the_Previous_6_Months":"0","Number_of_Notices_in_the_Last_7_to_18_Months":"0","Number_of_Notices_in_the_Last_19_to_36_Months":"0","Number_of_Notices_Older_than_37_Months":"1"},"Enquiries":{"CPA":{"Own":{"Total_Number_of_Own_Enquiries_Ever":"{7}","Number_of_Own_Enquiries_in_the_Last_30_days":"{7}","Number_of_Own_Enquiries_in_the_Last_90_days":"{7}","Number_of_Own_Enquiries_in_the_Last_180_days":"{7}","Number_of_Own_Enquiries_in_the_Last_year":"{7}"},'+
                                                        '"Other":{"Total_Number_of_Other_Enquiries_Ever":"{2}","Number_of_Other_Enquiries_in_the_Last_30_days":"{1}","Number_of_Other_Enquiries_in_the_Last_90_days":"{1}","Number_of_Other_Enquiries_in_the_Last_180_days":"{1}","Number_of_Other_Enquiries_in_the_Last_year":"{2}"},"All":{"Total_Number_of_All_Enquiries_Ever":"9"}}},"Payment_Profiles":{"CPA":{"Other":{"Number_of_Other_PPs_Ever":"{5}","Number_of_Other_Revolving_PPs_Ever":"{0}","Number_of_Other_Fixed_Installment_PPs_Ever":"{0}","Total_number_of_other_Delinquent_Accounts":"{3}","Total_number_of_other_Active_accounts":"{2}","Number_of_other_accounts_opened_4to12_months_ago":"{2}","Number_of_other_accounts_opened_for_at_least_12_months":"{3}","Total_number_of__active_non_delinquent_CPA_accounts_opened_L6m":"{0}","Number_of_Other_PPs_in_the_Last_30_Days":"{0}","Number_of_Other_PPs_in_the_Last_90_Days":"{0}","Number_of_Other_PPs_in_the_Last_180_Days":"{0}","Number_of_Other_PPs_in_the_Last_Year":"{2}","Number_of_Other_PPs_in_the_Last_2_Years":"{2}","Number_of_Other_PPs_in_the_Last_3_Years":"{2}","Number_of_Other_PPs_in_the_Last_4_Years":"{2}","Number_of_Other_PPs_in_the_Last_5_Years":"{2}","Number_of_Currently_Open_Other_PPs":"{5}","Months_Since_Most_Recent_opened_Other_PP":"{11}","Months_Since_Oldest_Opened_Other_PPs":"{158}","Capital_Amount_of_Other_PPs_Opened_in_the_Last_30_Days":"{0}","Capital_Amount_of_Other_PPs_Opened_in_the_Last_90_Days":"{0}","Capital_Amount_of_Other_PPs_Opened_in_Last_180_Days":"{0}","Capital_Amount_of_Other_PPs_Opened_in_the_Last_Year":"{69671}","Capital_Amount_of_Other_PPs_Opened_in_the_Last_2_Years":"{69671}","Monthly_Installment_Value_of_Currently_Open_Other_PPs":"{5358}","Monthly_CPA_Installment_Other":"{675}","Outstanding_CPA_Balance_Other":"{10650}","Total_value_of_Other_Delinquent_accounts":"{84999}","Total_outstanding_balance_on_Other_active_accounts":"{10650}","Outstanding_Balance_on_non_delinquent_revolving_CPA_opened_L6m":"{0}","Outstanding_Balance_on_delinquent_revolving_CPA_accounts":"{0}","Number_of_Closed_Other_PPs":"{0}","Number_of_Open_Revolving_Other_PPs":"{0}","Number_of_Closed_Revolving_Other_PPs":"{0}","Number_of_Open_Fixed_Installment_Other_PPs":"{0}","Number_of_Closed_Fixed_Installment_Other_PPs":"{0}","Worst_Arrears_on_Other_PPs_ever":"{W}","Worst_Arrears_on_Closed_Other_PPs":"{}","Worst_Arrears_on_Open_Other_PPs":"{W}","Worst_Arrears_Level_of_Most_Recent_Other_Opened_PP":"{9}","Number_of_Times_0_Arrears_of_Last_3_Other_Available_Histories":"{3}","Number_of_Times_1_Arrears_of_Last_3_Other_Available_Histories":"{12}","Number_of_Times_2_Arrears_of_Last_3_Other_Available_Histories":"{12}","Number_of_Times_3_Arrears_of_Last_3_Other_Available_Histories":"{12}","Number_of_Times_0_Arrears_of_Last_6_Other_Available_Histories":"{6}","Number_of_Times_1_Arrears_of_Last_6_Other_Available_Histories":"{23}","Number_of_Times_2_Arrears_of_Last_6_Other_Available_Histories":"{23}","Number_of_Times_3_Arrears_of_Last_6_Other_Available_Histories":"{23}","Number_of_Times_0_Arrears_of_Last_12_Other_Available_Histories":"{12}","Number_of_Times_1_Arrears_of_Last_12_Other_Available_Histories":"{41}",'+
                                                        '"Number_of_Times_2_Arrears_of_Last_12_Other_Available_Histories":"{41}","Number_of_Times_3_Arrears_of_Last_12_Other_Available_Histories":"{41}","Number_of_Times_0_Arrears_of_Last_24_Other_Available_Histories":"{24}","Number_of_Times_1_Arrears_of_Last_24_Other_Available_Histories":"{77}","Number_of_Times_2_Arrears_of_Last_24_Other_Available_Histories":"{77}","Number_of_Times_3_Arrears_of_Last_24_Other_Available_Histories":"{77}","Percent_0_Arrears_of_Last_3_Other_Available_Histories":"{20}","Percent_1_Arrears_of_Last_3_Other_Available_Histories":"{80}","Percent_2_Arrears_of_Last_3_Other_Available_Histories":"{80}","Percent_3_Arrears_of_Last_3_Other_Available_Histories":"{80}","Percent_0_Arrears_of_Last_6_Other_Available_Histories":"{20}","Percent_1_Arrears_of_Last_6_Other_Available_Histories":"{79}","Percent_2_Arrears_of_Last_6_Other_Available_Histories":"{79}","Percent_3_Arrears_of_Last_6_Other_Available_Histories":"{79}","Percent_0_Arrears_of_Last_12_Other_Available_Histories":"{22}","Percent_1_Arrears_of_Last_12_Other_Available_Histories":"{77}","Percent_2_Arrears_of_Last_12_Other_Available_Histories":"{77}","Percent_3_Arrears_of_Last_12_Other_Available_Histories":"{77}","Percent_0_Arrears_of_Last_24_Other_Available_Histories":"{23}","Percent_1_Arrears_of_Last_24_Other_Available_Histories":"{76}","Percent_2_Arrears_of_Last_24_Other_Available_Histories":"{76}","Percent_3_Arrears_of_Last_24_Other_Available_Histories":"{76}","Number_of_Written_Off_Other_PPs":"{2}","Number_of_Absconded_Other_PPs":"{0}","Number_of_Habitually_Slow_Other_PPs":"{0}","Number_of_Disputed_Other_PPs":"{0}","Current_Balance_of_All_Other_PPs":"{88159}","Total_Credit_Limit_of_Revolving_Other_PPs":"{0}","Total_Balance_of_Revolving_Other_PPs":"{0}","Total_Installment_of_Revolving_Other_PPs":"{0}","Total_Credit_Limit_of_Fixed_Installment_Other_PPS":"{0}","Total_Balance_of_Fixed_Installment_Other_PPs":"{0}","Total_Installment_of_Fixed_Installment_Other_PPs":"{0}","Total_Credit_Limit_of_Other_Open_Account_PPs":"{0}","Total_Balance_of_Other_Open_Account_PPs":"{0}","Total_Installment_of_Other_Open_Account_PPs":"{0}"},"All":{"Number_of_All_PPs_Ever":"6","Number_of_Currently_Open_All_PPs":"6","Number_of_Closed_All_PPs":"0","Total_Balance_of_All_Open_Account_PPs":"0"}},"NLR":{"All":{"Total_Monthly_One_Month_Installment_":"0"}}}}},"Notices":{"Notice":[{"CourtName":"P E","CourtID":"200","CaseNumber":"872016","NoticeDate":"20160119","NoticeAmount":"36037","TypeOfCourt":"2","Plaintiff":"AB VARIOUS CREDITORS","Reason":"AO","PublicDataCatCode":"1","PublicDataCatCodeDesc":"Admin Order"}]}}]}';
        @TestSetup
        static void createTestData(){

            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ExperianGetXML2Report_IH_v2.INTEGRATION_SERVICE_NAME});

            Account account = new Account(Name = 'Test Account');
            insert account;

            string RSAid='' ;
            Contact con = new Contact();
            con.FirstName='OOSTHUIZEN';
            con.AccountId=account.id;
            con.LastName='CHANEL';
            con.Birthdate=Date.valueOf('1989-03-06');
            con.ID_Number__c='8911270127087';
            con.ID_Type__c='SA Identity Document';
            if(con.ID_Type__c=='SA Identity Document'){
                RSAid='YES' ;
            }
            insert con;

            Contact con1 = new Contact();
            con1.FirstName='test';
            con1.AccountId=account.id;
            con1.LastName='test';
            con1.Birthdate=Date.valueOf('1989-03-07');
            con1.ID_Number__c='8911270127088';
            con1.ID_Type__c='SA Identity Document';
            insert con1;

            //Create Principal records
            Account testJointAccount = new Account();
            testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
            testJointAccount.Name = 'Mr Jack Stut';
            testJointAccount.Country_of_Registration__c='South Africa';
            testJointAccount.CIF__c = 'Jck+001';
            insert testJointAccount;
            system.debug('testJointAccount'+testJointAccount.id);

            AccountContactRelation acr =new AccountContactRelation();
            acr.AccountId=testJointAccount.id;
            acr.ContactId=con.id;
            acr.Roles='Director';
            insert acr;
            system.debug('acr'+acr.id);


            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'Test Opp';
            testOpp.CloseDate = Date.today();
            testOpp.StageName = 'Drafting';
            testOpp.accountId = testJointAccount.Id;
            insert testOpp;
            system.debug('testOpp'+testOpp.id);

        }

    @isTest
    public static void callExperianConsumerCheckService(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        System.debug('testOpportunity' + testOpportunity.id);
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        System.assertNotEquals(null, testOpportunity);
        MerchantExperianConsumerCheckController.callExperianConsumerCheckService(testOpportunity.id);
        MerchantExperianConsumerCheckController.loadExistingExperianCheckRecordsMap(testOpportunity.id);
        Test.stopTest();
    }
}