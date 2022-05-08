/**
* @description Helper class to create CFTS objects, call the CFTS service and persist the results
* @author  Celliers Inggs
* @created 2020-10-22
* @last modified on  : 09-01-2021
* @last modified by  : Aaron Castelyn (ABSA)
*/

public without sharing class CCApplicationServiceHelper 
{
    /**
    * @description Call Prescreen on the CCApplication service
    * @param accountId
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    @AuraEnabled
    public static CCApplicationService_apply_Resp_IB_v1 applyPreScreen(Id accountId){
        // Id accountId = '0019E00001Pv8ADQAZ'; //Clifford
        // Id accountId = '0019E00001PxrMQQAZ'; //Paul

        // Id accountId = '0019E00001PyWTKQA3'; //Thomas

        // Id accountId = '0019E00001WEvY7QAL';
        
        String errorMessage = '';
        CCApplicationService_PreScreen_Req_IB_v1 requestBean = CCApplicationService_PreScreen_Req_IB_v1.getNewInstance();
        CCApplicationService_apply_Resp_IB_v1 response =  new CCApplicationService_apply_Resp_IB_v1();
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        requestBean.apply.arg0.validateDetails ='true';
        requestBean.apply.arg0.application.applicationNumber = '';
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.campaignId = '';	
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.application.productGroupId = '1';     
        requestBean.apply.arg0.application.transactionType = '';        
        
        Account acc = null;

        if (accountId != null){
            acc = [SELECT Account.Id, 
            FirstName,LastName,ID_Number__pc,ID_Type__pc,Country_of_Citizenship__c,PersonMobilePhone,Initials__pc,Titles__pc,
            Account.Name, Country_of_Birth__pc, Communication_Language__pc, Gender__pc, Home_Language__pc,PersonBirthdate,
            PersonEmail, Marital_Status__pc,Marital_Contract_Type__pc, Preferred_Communication_Method__pc, Date_Issued__pc,
            Next_of_Kin_Cellphone_Number__pc, Next_of_Kin_First_Name_s__pc, Next_of_Kin_Last_Name__pc, Next_of_kin_Relationship__pc,
            Next_of_Kin_Email_Address__pc , Nationality__pc ,Country_of_Residence__pc , Statement_Preference__pc
            FROM Account
            WHERE Account.Id = :accountId WITH SECURITY_ENFORCED];
        }

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = acc.ID_Number__pc;
        requestBean.apply.arg0.application.primaryApplicant.titleType = acc.Titles__pc;
        requestBean.apply.arg0.application.primaryApplicant.surname = acc.LastName;
        requestBean.apply.arg0.application.primaryApplicant.firstNames = acc.FirstName;
        requestBean.apply.arg0.application.primaryApplicant.emailAddress = acc.PersonEmail;
        requestBean.apply.arg0.application.primaryApplicant.cellPhoneNumber.z_number = acc.PersonMobilePhone;   
        requestBean.apply.arg0.application.primaryApplicant.idOrRegistrationNo = acc.ID_Number__pc;
        requestBean.apply.arg0.application.primaryApplicant.identificationType = '01';
        requestBean.apply.arg0.application.primaryApplicant.placeOfResidence = '01';
        requestBean.apply.arg0.application.knockOutQuestions.curatorship = 'true';
        requestBean.apply.arg0.application.knockOutQuestions.casaClauseRead = 'true';
  
        String fullNameAndSurname =  acc.FirstName + ' ' + acc.Lastname ;
        
        List<String> fullNameAndSurnameList = fullNameAndSurname.split(' ');
        String initials = ''; 
        
        //System.debug(fullNameAndSurnameList);
        
        for(String x : fullNameAndSurnameList) {
            initials = initials + x.left(1);
        }
       
        requestBean.apply.arg0.application.primaryApplicant.initials = initials;
        //system.debug(JSON.serialize(requestBean));

        // response = (CCApplicationService_apply_Resp_IB_v1)CCApplicationService_apply_IH_v1.CCApplicationServicePreScreen(requestBean);
        // System.System.debug(JSON.Serialize(response));

        try{
            response = (CCApplicationService_apply_Resp_IB_v1)CCApplicationService_apply_IH_v1.ccApplicationServicePreScreen(requestBean);
        }
        catch(Exception ex){
            errorMessage = 'An error occured while creating a new application' + ex.getMessage();

            throw new AuraHandledException('Error: '+errorMessage);
        }

        //System.debug(response);
        return response;
    }

    /**
    * @description Call ClientUpdate on the CCApplication service
    * @param accountId
    * @param applicationId
    * @param applicationNumber
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyClientUpdate(Id accountId, Id applicationId, string applicationNumber)
    {
        // string applicationNumber = '102108161421351322';
        
        // Id AccountId = '0019E00001Pv8ADQAZ'; //Clifford
        // Id AccountId = '0019E00001PxrMQQAZ'; //Paul
        // Id accountId = '0019E00001PyWTKQA3'; //Thomas
        
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul
        // Id applicationId = 'a0u9E00000Gzf4QQAR'; //Thomas

        String errorMessage = '';
        
        CCApplicationService_CltUpdate_Req_IB_v1 requestBean =  CCApplicationService_CltUpdate_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();
        
        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;

        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.campaignId = '';	
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.productGroupId = '1';        
        requestBean.apply.arg0.application.transactionType = '';

        requestBean.apply.arg0.validateDetails ='true';

        Account acc = null;

        if (accountId != null)
        {
            acc = [SELECT Account.Id, 
            FirstName,LastName,ID_Number__pc,ID_Type__pc,Country_of_Citizenship__c,PersonMobilePhone,Initials__pc,PersonTitle,
            Account.Name, Country_of_Birth__pc, Communication_Language__pc, Gender__pc, Home_Language__pc,PersonBirthdate,
            PersonEmail, Marital_Status__pc,Marital_Contract_Type__pc, Preferred_Communication_Method__pc, Date_Issued__pc,
            Next_of_Kin_Cellphone_Number__pc, Next_of_Kin_First_Name_s__pc, Next_of_Kin_Last_Name__pc, Next_of_kin_Relationship__pc,
            Next_of_Kin_Email_Address__pc , Nationality__pc ,Country_of_Residence__pc , Statement_Preference__pc, Nationality_List__pc
            FROM Account
            WHERE Account.Id = :accountId WITH SECURITY_ENFORCED];
        }
        else if (applicationId != null)
        {
            acc = [SELECT Account.Id, 
            FirstName,LastName,ID_Number__pc,ID_Type__pc,Country_of_Citizenship__c,PersonMobilePhone,Initials__pc,PersonTitle,
            Account.Name, Country_of_Birth__pc, Communication_Language__pc, Gender__pc, Home_Language__pc,PersonBirthdate,
            PersonEmail, Marital_Status__pc,Marital_Contract_Type__pc, Preferred_Communication_Method__pc, Date_Issued__pc,
            Next_of_Kin_Cellphone_Number__pc, Next_of_Kin_First_Name_s__pc, Next_of_Kin_Last_Name__pc, Next_of_kin_Relationship__pc,
            Next_of_Kin_Email_Address__pc , Country_of_Residence__pc , Statement_Preference__pc, Nationality_List__pc
            FROM Account
            WHERE Account.Id IN (SELECT Account__c FROM Application__c WHERE Id = :applicationId) WITH SECURITY_ENFORCED];
        }
        
        Product2 p = null;
        Opportunity opp = null;

        try {
            Application__c app = [SELECT Opportunity__c 
            FROM Application__c 
            WHERE Id = :applicationId WITH SECURITY_ENFORCED LIMIT 1];

            p = [SELECT ProductCode, Price_Scheme_Code__c 
                FROM Product2 
                WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem WHERE OpportunityId = :app.Opportunity__c AND ProductCode != NULL) 
                AND Family != NULL WITH SECURITY_ENFORCED LIMIT 1 ];

            opp = [SELECT CBPIndicator__c FROM Opportunity WHERE Id = :app.Opportunity__c WITH SECURITY_ENFORCED];
        }
        catch(Exception ex) {
            errorMessage = 'Product information retrieval failed: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);    
        }        

        requestBean.apply.arg0.application.packageId = opp.CBPIndicator__c;
        requestBean.apply.arg0.application.pricingSchemeCode = p.Price_Scheme_Code__c;

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);

        requestBean.apply.arg0.application.statementDeliveryMethodSelected.code = 'EML';
        requestBean.apply.arg0.application.statementDeliveryMethodSelected.description = 'eMail';
       
        requestBean.apply.arg0.application.primaryApplicant.customerType = '001';
        requestBean.apply.arg0.application.primaryApplicant.gender = (acc.Gender__pc != null) ? acc.Gender__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.countryOfBirth = (acc.Country_of_Birth__pc != null) ? acc.Country_of_Birth__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.homeLanguage = (acc.Home_Language__pc != null) ? acc.Home_Language__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.familyStatus.maritalStatus = (acc.Marital_Status__pc != null) ? acc.Marital_Status__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.emailAddress = (acc.PersonEmail != null) ? acc.PersonEmail : '';
        requestBean.apply.arg0.application.primaryApplicant.communicationLanguage = (acc.Communication_Language__pc != null) ? acc.Communication_Language__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.preferredCommunicationChannel = (acc.Preferred_Communication_Method__pc != null) ? acc.Preferred_Communication_Method__pc : '';

        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.fullNames = (acc.Next_of_Kin_First_Name_s__pc != null) ? acc.Next_of_Kin_First_Name_s__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.surname = (acc.Next_of_Kin_Last_Name__pc != null) ? acc.Next_of_Kin_Last_Name__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.relationship = (acc.Next_of_kin_Relationship__pc != null) ? acc.Next_of_kin_Relationship__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.cellPhoneNumber.number_Z = (acc.Next_of_Kin_Cellphone_Number__pc != null) ? acc.Next_of_Kin_Cellphone_Number__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.emailAddress = (acc.Next_of_Kin_Email_Address__pc != null) ? acc.Next_of_Kin_Email_Address__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.nextOfKin.relationship =  (acc.Next_of_kin_Relationship__pc != null) ? acc.Next_of_kin_Relationship__pc : '';
        
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.countryOfResidence =  (acc.Country_of_Residence__pc != null) ? acc.Country_of_Residence__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.nationality = (acc.Nationality_List__pc != null) ? acc.Nationality_List__pc : '';

        Address__c addr = [SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, 
        Shipping_Zip_Postal_Code__c
        FROM Address__c
        WHERE Account__c = :acc.Id
        AND Address_Type__c = 'Residential' WITH SECURITY_ENFORCED LIMIT 1];          

        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.addressLine1 = (addr.Shipping_Street__c != null) ? addr.Shipping_Street__c : '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.addressLine2 = (addr.Shipping_Street_2__c != null) ? addr.Shipping_Street_2__c : '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.suburb = (addr.Shipping_Suburb__c != null) ? addr.Shipping_Suburb__c : '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.city = (addr.Shipping_City__c != null) ? addr.Shipping_City__c : '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.postalCode = (addr.Shipping_Zip_Postal_Code__c != null) ? addr.Shipping_Zip_Postal_Code__c : '';
        requestBean.apply.arg0.application.primaryApplicant.residentialAddress.country = (addr.Shipping_Country__c != null) ? addr.Shipping_Country__c : '';

        Address__c addrPostal = [SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, 
        Shipping_Zip_Postal_Code__c
        FROM Address__c
        WHERE Account__c = :acc.Id
        AND Address_Type__c = 'Postal' WITH SECURITY_ENFORCED LIMIT 1];         

        requestBean.apply.arg0.application.primaryApplicant.postalAddress.addressLine1 = (addrPostal.Shipping_Street__c != null) ? addrPostal.Shipping_Street__c : '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.addressLine2 = (addrPostal.Shipping_Street_2__c != null) ? addrPostal.Shipping_Street_2__c : '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.suburb = (addrPostal.Shipping_Suburb__c != null) ? addrPostal.Shipping_Suburb__c : '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.city = (addrPostal.Shipping_City__c != null) ? addrPostal.Shipping_City__c : '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.postalCode = (addrPostal.Shipping_Zip_Postal_Code__c != null) ? addrPostal.Shipping_Zip_Postal_Code__c : '';
        requestBean.apply.arg0.application.primaryApplicant.postalAddress.country = (addrPostal.Shipping_Country__c != null) ? addrPostal.Shipping_Country__c : '';
        
        //System.debug(JSON.Serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceClientUpdate(requestBean);
        // System.System.debug(JSON.Serialize(response));

        try
        {
            response = CCApplicationService_apply_IH_v1.ccApplicationServiceClientUpdate(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'Receiving of client bereau information failed: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return response;
    }

    /**
    * @description Call FinalScoring on the CCApplication service    
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @param preAssessedCreditLimit
    * @param mayCheckCreditWorthiness
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyFinalScoring(Id applicationId, string applicationNumber, string lockVersionId, string preAssessedCreditLimit, string mayCheckCreditWorthiness)
    {           
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul
        // Id applicationId = 'a0u9E00000Gzf4QQAR'; //Thomas

        // string applicationNumber = '102108161421351322';
        // string lockVersionId = '54757';
        // string preAssessedCreditLimit = '';
        // string mayCheckCreditWorthiness = 'Y';

        String errorMessage = '';

        CCApplicationService_FnlScorng_Req_IB_v1 requestBean = CCApplicationService_FnlScorng_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();
        
        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;

        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.customerType = '001';
        requestBean.apply.arg0.application.lockVersionId = lockVersionId;
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        
        requestBean.apply.arg0.application.knockOutQuestions.registeredForeingTax = 'false';

        Application__c app = [SELECT Source_of_Funds__c, Source_of_Funds_Savings__c, Account__c 
            FROM Application__c 
            WHERE Id = :applicationId WITH SECURITY_ENFORCED LIMIT 1];

        Account acc = [SELECT Id, Employer_Name__pc, Industry, Income_Tax_Number__c, 
            Number_Of_Dependents__c, Occupation_Category__pc, Occupation_Level__pc, 
            Occupation_Status__pc, Post_Matric_Qualification__pc, Income_Source__pc, ID_Number__pc, PersonBirthDate
            FROM Account
            WHERE Account.Id = :app.Account__c WITH SECURITY_ENFORCED];

        Address__c addr = [SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, 
            Shipping_Zip_Postal_Code__c
            FROM Address__c
            WHERE Account__c = :acc.Id
            AND Address_Type__c = 'Employers' WITH SECURITY_ENFORCED LIMIT 1];        

            //select Id, Name from Account where ID_Number__pc = '6009270117083'

            //select Id, Name from Application__c where Account__c = '0019E00001TFlcGQAT'

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);

        //Do we still need to submit preAssessed values?
        //requestBean.apply.arg0.application.primaryApplicant.preAssessed = preAssessedCreditLimit;
        

        requestBean.apply.arg0.application.primaryApplicant.dateOfBirth = (acc.PersonBirthDate != null) ? String.valueOf(acc.PersonBirthDate) : '';
        requestBean.apply.arg0.application.primaryApplicant.occupationStatus = (acc.Occupation_Status__pc != null) ? acc.Occupation_Status__pc : ''; 
        requestBean.apply.arg0.application.primaryApplicant.occupationCode =         
            ((acc.Occupation_Category__pc != null) && (!acc.Occupation_Category__pc.contains('Not required'))) ? acc.Occupation_Category__pc : ''; 
        
        requestBean.apply.arg0.application.primaryApplicant.occupationLevel = (acc.Occupation_Level__pc != null ) ? acc.Occupation_Level__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.employmentSector = (acc.Industry != null) ? acc.Industry : ''; 

        requestBean.apply.arg0.application.primaryApplicant.hasPostMatricQualification = (acc.Post_Matric_Qualification__pc != null) ? 'true' : 'false';
        requestBean.apply.arg0.application.primaryApplicant.qualification.qualificationType = (acc.Post_Matric_Qualification__pc != null) ? acc.Post_Matric_Qualification__pc : '';

        requestBean.apply.arg0.application.primaryApplicant.incomeTaxNumber = (acc.Income_Tax_Number__c != null) ? String.valueOf(acc.Income_Tax_Number__c) : '';

        // System.debug(acc.Employer_Name__pc);
        requestBean.apply.arg0.application.primaryApplicant.employer.name = acc.Employer_Name__pc;

        requestBean.apply.arg0.application.primaryApplicant.employer.address.addressLine1 = addr.Shipping_Street__c;
        requestBean.apply.arg0.application.primaryApplicant.employer.address.addressLine2 = addr.Address2__c;
        requestBean.apply.arg0.application.primaryApplicant.employer.address.suburb = addr.Shipping_Suburb__c;
        requestBean.apply.arg0.application.primaryApplicant.employer.address.city = addr.Shipping_City__c;
        requestBean.apply.arg0.application.primaryApplicant.employer.address.postalCode = addr.Shipping_Zip_Postal_Code__c;
        requestBean.apply.arg0.application.primaryApplicant.employer.address.country = addr.Shipping_Country__c;        

        // The Income and expense fields are populated by the calling class

        CCApplicationServiceHelper.MonthlyIncome income = (CCApplicationServiceHelper.MonthlyIncome)JSON.deserialize(CCApplicationServiceHelper.getIncome(applicationId), CCApplicationServiceHelper.MonthlyIncome.class);
        CCApplicationServiceHelper.MonthlyDebtExpenses debt = (CCApplicationServiceHelper.MonthlyDebtExpenses)JSON.deserialize(CCApplicationServiceHelper.getDebtExpenses(applicationId), CCApplicationServiceHelper.MonthlyDebtExpenses.class);
        CCApplicationServiceHelper.MonthlyLivingExpenses living = (CCApplicationServiceHelper.MonthlyLivingExpenses)JSON.deserialize(CCApplicationServiceHelper.GetLivingExpenses(applicationId), CCApplicationServiceHelper.MonthlyLivingExpenses.class);

        Double disposableMonthlyIncome = CCApplicationServiceHelper.getIncomeLeft(applicationId);

        requestBean.apply.arg0.application.consents.deaConsent = string.valueOf(income.bankStatementsConsent);

        requestBean.apply.arg0.application.primaryApplicant.sourceOfIncome = (acc.Income_Source__pc != null) ? acc.Income_Source__pc : 'SALARY/WAGES';
        //requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds = (app.Source_of_Funds__c != null) ? app.Source_of_Funds__c : 'SALARY/WAGES';

        if (app.Source_of_Funds_Savings__c != null)
        {
            List<String> sofs = app.Source_of_Funds_Savings__c.split(';', 0);

            if (sofs.size() > 0)
            {
                for(String s : sofs)
                {
                    requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds.Add(CCApplicationServiceHelper.getSOFValue(s));
                }
            }
            else {
                requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds.Add(CCApplicationServiceHelper.getSOFValue(sofs[0]));    
            }
        }
        else {
            requestBean.apply.arg0.application.primaryApplicant.sourceOfFunds.Add('20');     
        }

        requestBean.apply.arg0.application.primaryApplicant.income.grossMonthlyIncome = String.valueOf(CCApplicationServiceHelper.getTotalIncome(applicationId));
        requestBean.apply.arg0.application.primaryApplicant.income.grossMonthlySalary = String.valueOf(income.grossIncome.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.income.nettMonthlyIncome = String.valueOf(income.netIncome.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.income.disposableMonthlyIncome = String.valueOf(disposableMonthlyIncome);
        requestBean.apply.arg0.application.primaryApplicant.income.rentalIncome = String.valueOf(income.rentalIncome.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.income.otherIncome.description = '';
        requestBean.apply.arg0.application.primaryApplicant.income.otherIncome.amount = '';       
        
        requestBean.apply.arg0.application.primaryApplicant.expense.vehicleInstalment = String.valueOf(debt.assetPayment.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.personalLoanInstalment = String.valueOf(debt.loanPayment.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.creditCardInstalment = String.valueOf(debt.creditPayment.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.bondInstalmentOrRent = String.valueOf(debt.homeloanPayment.Applicant_Value__c);        
        requestBean.apply.arg0.application.primaryApplicant.expense.otherFixedDebtExpense.amount = String.valueOf(debt.retailPayment.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.otherFixedDebtExpense.description = (debt.retailPayment.Applicant_Value__c > 0.00) ? 'Retail Accounts' : '';

        requestBean.apply.arg0.application.primaryApplicant.expense.jointDebt = (debt.jointResponsible) ? 'Y' : 'N';

        requestBean.apply.arg0.application.primaryApplicant.expense.household = String.valueOf(living.householdExpense.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.transport = String.valueOf(living.fuelExpense.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.schoolOrUniversityFee = String.valueOf(living.educationFee.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.insuranceOrFuneralPolicy = String.valueOf(living.insurancePolicies.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.rent = String.valueOf(living.rent.Applicant_Value__c);
        requestBean.apply.arg0.application.primaryApplicant.expense.maintenance = String.valueOf(living.maintenanceExpense.Applicant_Value__c);        
        requestBean.apply.arg0.application.primaryApplicant.expense.otherExpense.description = (living.otherAmount.Applicant_Value__c > 0.00) ? living.otherAmount.Name : '';
        requestBean.apply.arg0.application.primaryApplicant.expense.otherExpense.amount = String.valueOf(living.otherAmount.Applicant_Value__c);        


        Double totalDebt = debt.assetPayment.Applicant_Value__c + debt.loanPayment.Applicant_Value__c +
            debt.creditPayment.Applicant_Value__c + debt.homeloanPayment.Applicant_Value__c + debt.retailPayment.Applicant_Value__c;

        Double totalLiving = living.householdExpense.Applicant_Value__c + living.fuelExpense.Applicant_Value__c + 
            living.educationFee.Applicant_Value__c + living.insurancePolicies.Applicant_Value__c + 
            living.rent.Applicant_Value__c + living.otherAmount.Applicant_Value__c;

        requestBean.apply.arg0.application.primaryApplicant.expense.totalFixedDebtExpense = String.valueOf(totalDebt);
        requestBean.apply.arg0.application.primaryApplicant.expense.totalLivingExpense = String.valueOf(totalLiving);

        requestBean.apply.arg0.application.primaryApplicant.numberOfDependents = String.valueOf(living.dependents);
        requestBean.apply.arg0.application.primaryApplicant.financialInformationSuppliedCorrect = 'true';
        requestBean.apply.arg0.application.primaryApplicant.mayCheckCreditWorthiness = (mayCheckCreditWorthiness.length() > 0) ? mayCheckCreditWorthiness : 'Y';       

        requestBean.apply.arg0.validateDetails ='true';

        // System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceFinalScoring(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            response = CCApplicationService_apply_IH_v1.ccApplicationServiceFinalScoring(requestBean);        
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured while scoring the client application: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return response;
    }

    /**
    * @description Call Complete1 on the CCApplication service    
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @param creditLifeRequired
    * @param cardProdSubProdGroupId
    * @param creditLimitApproved
    * @param creditLimitSelected
    * @param noticeDelivery
    * @param annualCreditLimitIncreases
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyComplete1(Id applicationId, string applicationNumber, string lockVersionId, string creditLifeRequired, string cardProdSubProdGroupId, string creditLimitApproved, string creditLimitSelected, string noticeDelivery, string annualCreditLimitIncreases)
    {   
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul
        // Id applicationId = 'a0u9E00000Gzf4QQAR'; //Thomas

        // string applicationNumber = '102108101111461834';
        // string lockVersionId = '54588';
        // string creditLifeRequired = 'Y';
        // string cardProdSubProdGroupId = '162';
        // string creditLimitApproved = '140000'; 
        // string creditLimitSelected = '140000'; 
        // string noticeDelivery = '1';
        // string annualCreditLimitIncreases = 'Y';

        String errorMessage = '';

        CCApplicationService_Complete1_Req_IB_v1 requestBean = CCApplicationService_Complete1_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();
        
        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.annualCreditLimitIncreases = annualCreditLimitIncreases;
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.customerType = '001';
        requestBean.apply.arg0.application.lockVersionId = lockVersionId;
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.cardProdSubProdGroupId = cardProdSubProdGroupId;        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.application.creditLifeRequired = creditLifeRequired;
        requestBean.apply.arg0.application.creditLimitApproved = creditLimitApproved;
        requestBean.apply.arg0.application.creditLimitSelected = creditLimitSelected;
        requestBean.apply.arg0.application.hasAcceptedSpecifiedCreditLimit = (Double.valueOf(creditLimitSelected) > 0) ? 'false' : 'true';
        requestBean.apply.arg0.application.consents.noticeDelivery = noticeDelivery; 

        requestBean.apply.arg0.application.knockOutQuestions.absaRewards = 'Y';
        requestBean.apply.arg0.application.knockOutQuestions.creditLifeTermsAndConditionsRead = 'Y';

        requestBean.apply.arg0.validateDetails ='false';

        Account acc = [SELECT ID_Number__pc
            FROM Account
            WHERE Account.Id IN (SELECT Account__c FROM Application__c WHERE Id = :applicationId) WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);
        
        // System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceComplete1(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            response = CCApplicationService_apply_IH_v1.ccApplicationServiceComplete1(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured during Complete1: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return response;
    }

    /**
    * @description Call Complete2 on the CCApplication service    
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId    
    * @param cardProdSubProdGroupId
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyComplete2(Id applicationId, string applicationNumber, string lockVersionId, string cardProdSubProdGroupId)
    {   
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul
        // Id applicationId = 'a0u9E00000Gzf4QQAR'; //Thomas
        
        // string applicationNumber = '102108101111461834';
        // string lockVersionId = '54588';        
        // string cardProdSubProdGroupId = '162';
                
        String errorMessage = '';

        CCApplicationService_Complete2_Req_IB_v1 requestBean = CCApplicationService_Complete2_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';        
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.lockVersionId = lockVersionId;
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.cardProdSubProdGroupId = cardProdSubProdGroupId;        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;        
        requestBean.apply.arg0.application.hasAcceptedSpecifiedCreditLimit = '';

        requestBean.apply.arg0.validateDetails ='true';

        Account acc = [SELECT Name, CIF__c, ID_Number__pc, CASA_Reference_Number__pc, CASA_Risk_Status__c, CASA_Sequence_Number__c, Country_of_Residence__pc, Nationality_List__pc
            FROM Account
            WHERE Account.Id IN (SELECT Account__c FROM Application__c WHERE Id = :applicationId) WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);
        
        Payment_Plan__c pp = null;
        //System.debug('PaymentPlan query');
        List<Payment_Plan__c> ppList = [SELECT Account_Holder_Name__c, Account_Number__c, Account_Type__c, Bank_Name__c, Branch_Code__c, 
            Branch_Name__c, Other_Bank_Name__c, Debit_Order_Debit_Day__c 
            FROM Payment_Plan__c 
            WHERE Application__c = :applicationId WITH SECURITY_ENFORCED];

        if (!ppList.isEmpty())
        {
            //System.debug(ppList);
            pp = ppList[0];
        }

        if (pp != null)
        {
            
            requestBean.apply.arg0.application.debitOrderDetails.accountHolderName = ((pp != null) && (pp.Account_Holder_Name__c != null)) ? pp.Account_Holder_Name__c : acc.Name; //'T MAKWANI'; 
            requestBean.apply.arg0.application.debitOrderDetails.accountNumber = ((pp != null) && (pp.Account_Number__c != null)) ? pp.Account_Number__c : ''; //'4048565521 - Paul';
            requestBean.apply.arg0.application.debitOrderDetails.accountType.code = ((pp != null) && (pp.Account_Type__c != null)) ? pp.Account_Type__c : 'C'; //'C';
            requestBean.apply.arg0.application.debitOrderDetails.accountType.description = ''; //'Cheque Account'; //translations

            BankInfo__c bi = new BankInfo__c();

            if ((pp.Bank_Name__c != null) && (pp.Bank_Name__c != ''))
            {
                bi = [SELECT Bank_short_name__c, Branch_code__c, Other_bank__c FROM BankInfo__c WHERE Name = :pp.Bank_Name__c WITH SECURITY_ENFORCED];
            }

            if (bi.Other_bank__c == false)
            {
                requestBean.apply.arg0.application.debitOrderDetails.bankInstitutionName = ((bi.Bank_short_name__c != null)) ? bi.Bank_short_name__c : 'ABSA'; //'other';
                requestBean.apply.arg0.application.debitOrderDetails.otherBankInstitutionName = '';
            }
            else
            {
                requestBean.apply.arg0.application.debitOrderDetails.bankInstitutionName = 'other';
                requestBean.apply.arg0.application.debitOrderDetails.otherBankInstitutionName = ((bi.Bank_short_name__c != null)) ? bi.Bank_short_name__c : ''; //'Capitec';
            }    

                
            requestBean.apply.arg0.application.debitOrderDetails.branchCode = ((bi.Branch_code__c != null)) ? String.valueOf(bi.Branch_code__c) : '632005'; //'470010';
            requestBean.apply.arg0.application.debitOrderDetails.branchName = ''; 

            requestBean.apply.arg0.application.debitOrderDetails.debitOrderType.description = 'Minimum Amount';
            requestBean.apply.arg0.application.debitOrderDetails.debitOrderType.id = 'M';

            requestBean.apply.arg0.application.debitOrderDetails.paymentAmount = ''; //*
            requestBean.apply.arg0.application.debitOrderDetails.paymentType.code = 'M'; //*
            requestBean.apply.arg0.application.debitOrderDetails.paymentType.description = 'Maximum Amount'; //* - Anne to confirm
            requestBean.apply.arg0.application.debitOrderDetails.paymentDay = ((pp != null) && (pp.Debit_Order_Debit_Day__c != null)) ? pp.Debit_Order_Debit_Day__c : ''; //'4';
            requestBean.apply.arg0.application.debitOrderDetails.payPerDC = 'Y'; //Paymentplan
        }

        requestBean.apply.arg0.application.primaryApplicant.clientCode = acc.CIF__c;

        Application_Product__c ap = null;
        //System.debug('ApplicationProduct query');
        List<Application_Product__c> apList = [SELECT Card_Delivery_Method__c, Card_Delivery_Site_Code__c,
            Country__c, Delivery_Address_1__c, Postal_code__c, Suburb__c, Town__c
            FROM Application_Product__c 
            WHERE Application__c = :applicationId WITH SECURITY_ENFORCED];

        if (!apList.isEmpty())
        {
            //System.debug(apList);
            ap = apList[0];
        }

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.courierCollectionFee = ''; //*
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.description = '';        
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.id = ((ap != null) && (ap.Card_Delivery_Method__c != null)) ? ap.Card_Delivery_Method__c : 'B'; //'B'; //translations B = site info, S = street addr

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.id = ((ap != null) && (ap.Card_Delivery_Site_Code__c != null)) ? ap.Card_Delivery_Site_Code__c : userInfo.SiteCode__c; // '8198'; //-- site code
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.nameLong = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.nameShort = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.status = '';

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.addressLine1 = ((ap != null) && (ap.Delivery_Address_1__c != null)) ? ap.Delivery_Address_1__c : '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.addressLine2 = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.city = ((ap != null) && (ap.Town__c != null)) ? ap.Town__c : '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.country = ((ap != null) && (ap.Country__c != null)) ? ap.Country__c : '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.postalCode = ((ap != null) && (ap.Postal_code__c != null)) ? ap.Postal_code__c : '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.suburb = ((ap != null) && (ap.Suburb__c != null)) ? ap.Suburb__c : '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.subType = ''; //*
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.type = ''; //application_product

        requestBean.apply.arg0.application.primaryApplicant.cardTypeSelected.description = '';
        requestBean.apply.arg0.application.primaryApplicant.cardTypeSelected.id = 'C';
        
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.countryOfResidence =  (acc.Country_of_Residence__pc != null) ? acc.Country_of_Residence__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.nationality = (acc.Nationality_List__pc != null) ? acc.Nationality_List__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.referenceNumber = (acc.CASA_Reference_Number__pc != null) ? acc.CASA_Reference_Number__pc : '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.versionNumber = (acc.CASA_Sequence_Number__c != null) ? acc.CASA_Sequence_Number__c : '1';//'2'; //* 
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.riskRating = (acc.CASA_Risk_Status__c != null) ? acc.CASA_Risk_Status__c : '';//'M'; //* - get values from SF

        Application_Financial_Account__c fa = [SELECT Account_Number__c, Account_Type__c, Institution_Name__c
            FROM Application_Financial_Account__c 
            WHERE Application__c = :applicationId
            AND Account_Purpose__c = 'Salary' WITH SECURITY_ENFORCED];
            
        BankInfo__c bi2 = [SELECT Bank_short_name__c, Branch_code__c, Other_bank__c FROM BankInfo__c WHERE Name = :fa.Institution_Name__c WITH SECURITY_ENFORCED];

        if (bi2.Other_bank__c == false)
        {
            requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.bankInstitutionName = (bi2.Bank_short_name__c != null) ? bi2.Bank_short_name__c : '';
            requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.otherBankInstitutionName = '';            
        }
        else
        {
            requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.bankInstitutionName = 'other';
            requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.otherBankInstitutionName = (bi2.Bank_short_name__c != null) ? bi2.Bank_short_name__c : '';            
        }

        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.accountNumber = (fa.Account_Number__c != null) ? String.valueOf(fa.Account_Number__c) : ''; //'4047893133'; //salary account
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.branchName = ''; //*
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.branchCode = (bi2.Branch_code__c != null) ? String.valueOf(bi2.Branch_code__c) : ''; //'632005'; //*
        
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.salaryAccountType = (fa.Account_Type__c != null) ? fa.Account_Type__c.substring(0, 1) : ''; //'C'; //application_financial_account account_type = salary
        

        Address__c addrPostal = [SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, 
            Shipping_Zip_Postal_Code__c
            FROM Address__c
            WHERE Account__c = :acc.Id
            AND Address_Type__c = 'Postal' WITH SECURITY_ENFORCED LIMIT 1];  

        if ((ap != null) && (ap.Card_Delivery_Method__c != null) && (ap.Card_Delivery_Method__c == 'Courier'))
        {   
            requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.addressLine1 = (addrPostal.Shipping_Street__c != null) ? addrPostal.Shipping_Street__c : '';
            requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.addressLine2 = (addrPostal.Address2__c != null) ? addrPostal.Address2__c : '';
            requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.suburb = (addrPostal.Shipping_Suburb__c != null) ? addrPostal.Shipping_Suburb__c : '';
            requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.city = (addrPostal.Shipping_City__c != null) ? addrPostal.Shipping_City__c : '';
            requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.postalCode = (addrPostal.Shipping_Zip_Postal_Code__c != null) ? addrPostal.Shipping_Zip_Postal_Code__c : '';
            requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.country = (addrPostal.Shipping_Country__c != null) ? addrPostal.Shipping_Country__c : '';            
        }   

        // System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceComplete2(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            if (requestBean.apply.arg0.application.primaryApplicant.clientCode.length() < 10)
            {
                throw new AuraHandledException('The length of CIF key ' + requestBean.apply.arg0.application.primaryApplicant.clientCode + 'is less than 10 characters');
            }

            response = CCApplicationService_apply_IH_v1.ccApplicationServiceComplete2(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured during Complete2: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return response;
    }

    /**
    * @description Call QuoteAccept on the CCApplication service    
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @param decision
    * @param quoteNumber
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyQuoteAccept(Id applicationId, string applicationNumber, string lockVersionId, string decision, string quoteNumber)
    {   
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul

        // string applicationNumber = '102108101111461834';
        // string lockVersionId = '54593';                
        // string decision = 'ACCEPT';
        // string quoteNumber = '93416';

        String errorMessage = '';

        CCApplicationService_QteAccept_Req_IB_v1 requestBean = CCApplicationService_QteAccept_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';        
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.creditStatus.id = '';        
        requestBean.apply.arg0.application.creditStatus.description = '';        
        requestBean.apply.arg0.application.lockVersionId = lockVersionId;
        requestBean.apply.arg0.application.productGroupId = '1';        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;

        requestBean.apply.arg0.application.quote.cardProdSubProdGroupId = '';
        requestBean.apply.arg0.application.quote.creditLifeRequired = '';
        requestBean.apply.arg0.application.quote.creditLimit = '';
        requestBean.apply.arg0.application.quote.decision = decision; //'ACCEPT'; //'REJECT';
        requestBean.apply.arg0.application.quote.emailOrFaxInfo = '';
        requestBean.apply.arg0.application.quote.linkedAccountNumberSelected = '';
        requestBean.apply.arg0.application.quote.z_number = quoteNumber;
        requestBean.apply.arg0.application.quote.numberOfQuotesIssued = '';
        requestBean.apply.arg0.application.quote.statusCode = '';

        requestBean.apply.arg0.validateDetails ='true';

        Account acc = [SELECT ID_Number__pc
            FROM Account
            WHERE Account.Id IN (SELECT Account__c FROM Application__c WHERE Id = :applicationId) WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);
        
        //System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceQuoteAccept(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            response = CCApplicationService_apply_IH_v1.ccApplicationServiceQuoteAccept(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured while updating quote: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return response;
    }

    /**
    * @description Call InstantAccountOpening on the CCApplication service    
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyInstantAccountOpening(Id applicationId, string applicationNumber, string lockVersionId)
    {   
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul

        // string applicationNumber = '102108101111461834';
        // string lockVersionId = '54593';

        String errorMessage = '';

        CCApplicationService_InstAcc_Req_IB_v1 requestBean = CCApplicationService_InstAcc_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';        
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.creditStatus.id = '';        
        requestBean.apply.arg0.application.creditStatus.description = '';        
        requestBean.apply.arg0.application.lockVersionId = lockVersionId;
        requestBean.apply.arg0.application.productGroupId = '1';        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;

        requestBean.apply.arg0.validateDetails ='true';

        Account acc = [SELECT ID_Number__pc
            FROM Account
            WHERE Account.Id IN (SELECT Account__c FROM Application__c WHERE Id = :applicationId) WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);
        
        // System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceInstantAccountOpening(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            response = CCApplicationService_apply_IH_v1.ccApplicationServiceInstantAccountOpening(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured during instant account opening: ' + ex.getMessage();

            throw new AuraHandledException('Error: '+errorMessage);
        }

        return response;
    }

    /**
    * @description Call InitiateDebiCheck on the CCApplication service    
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_apply_Resp_IB_v1 applyInitiateDebiCheck(Id applicationId, string applicationNumber, string lockVersionId)
    {        
        // Id applicationId = 'a0u9E00000GVw8eQAD'; //Clifford
        // Id applicationId = 'a0u9E00000GVw55QAD'; //Paul

        // string applicationNumber = '102108101111461834';
        // string lockVersionId = '54593';

        String errorMessage = '';

        CCApplicationService_DebiCheck_Req_IB_v1 requestBean = CCApplicationService_DebiCheck_Req_IB_v1.getNewInstance();
        
        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.apply.arg0.application.applicationNumber = applicationNumber;
        requestBean.apply.arg0.application.applicationType = 'P';        
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.creditStatus.id = '';        
        requestBean.apply.arg0.application.creditStatus.description = '';        
        requestBean.apply.arg0.application.lockVersionId = lockVersionId;
        requestBean.apply.arg0.application.productGroupId = '1';        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = userInfo.SiteCode__c;

        requestBean.apply.arg0.validateDetails ='true';

        Account acc = [SELECT ID_Number__pc
            FROM Account
            WHERE Account.Id IN (SELECT Account__c FROM Application__c WHERE Id = :applicationId) WITH SECURITY_ENFORCED];

        requestBean.apply.arg0.application.externalConsumerData.customerId = acc.ID_Number__pc ;
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'BSF';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = String.valueOf(applicationId);
 
        Payment_Plan__c pp = null;
        //System.debug('PaymentPlan query');
        List<Payment_Plan__c> ppList = [SELECT Account_Number__c, Debit_authentication_Type__c, MAC_Code__c 
            FROM Payment_Plan__c 
            WHERE Application__c = :applicationId WITH SECURITY_ENFORCED];

        if (!ppList.isEmpty())
        {
            //System.debug(ppList);
            pp = ppList[0];
        }

        requestBean.apply.arg0.application.debitOrderDetails.accountNumber = ((pp != null) && (pp.Account_Number__c != null)) ? pp.Account_Number__c : ''; //'1727756957'; //The account number is only when doing packages.        
        requestBean.apply.arg0.application.debitOrderDetails.mandateDetails.authType = ((pp != null) && (pp.Debit_authentication_Type__c != null)) ? pp.Debit_authentication_Type__c : ''; //'0228'; //bison
        requestBean.apply.arg0.application.debitOrderDetails.mandateDetails.macCode = ((pp != null) && (pp.MAC_Code__c != null)) ? pp.MAC_Code__c : ''; //'12345678'; //bison

        //System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_apply_IH_v1.CCApplicationServiceInitiateDebiCheck(requestBean);
        // System.debug(JSON.serialize(response));
		System.debug('requestBean**'+requestBean);
        try
        { 
            response = CCApplicationService_apply_IH_v1.ccApplicationServiceInitiateDebiCheck(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured while initiating debi check: ' + ex.getMessage();

            throw new AuraHandledException('Error: '+errorMessage);
        }
		System.debug('response**'+response);
        return response;
    }

    /**
    * @description Call CancelApplication on the CCApplication service        
    * @param applicationNumber
    * @param lockVersionId
    * @param cancelReasonId
    * @return CCApplicationService_apply_Resp_IB_v1 
    */
    public static CCApplicationService_cancel_Resp_IB_v1 cancelApplication(string applicationNumber, string lockVersionId, string cancelReasonId)
    {
        String errorMessage = '';

        // public String applicationNumber = '102106230742031683';
		// public String cancelReasonId = '1';		
        // public String lockVersionId = '0';
        
        CCApplicationService_cancel_Req_IB_v1 requestBean = CCApplicationService_cancel_Req_IB_v1.getNewInstance();
        
        CCApplicationService_cancel_Resp_IB_v1 response = new CCApplicationService_cancel_Resp_IB_v1();

        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.cancelApplication.arg0.requestCommons.channelCode = 'B';
        requestBean.cancelApplication.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.cancelApplication.arg0.requestCommons.messageLanguage ='E';
        requestBean.cancelApplication.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.cancelApplication.arg0.requestCommons.systemName = 'BSF';
        requestBean.cancelApplication.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.cancelApplication.arg0.applicationNumber = applicationNumber;
        requestBean.cancelApplication.arg0.lockVersionId = lockVersionId;
        requestBean.cancelApplication.arg0.corpCode = 'ABSA';
        requestBean.cancelApplication.arg0.cancelReasonId = cancelReasonId;

        //System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_cancel_IH_v1.CCApplicationServiceCancel(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            response = CCApplicationService_cancel_IH_v1.ccApplicationServiceCancel(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured while cancelling the application: ' + ex.getMessage();

            throw new AuraHandledException('Error: '+errorMessage);
        }

        return response;
    }

    /**
    * @description Call GetApplicationInformation on the CCApplication service        
    * @param applicationNumber
    * @return CCApplicationService_get_Resp_IB_v1 
    */
    public static CCApplicationService_get_Resp_IB_v1 getApplicationInformation(string applicationNumber)
    {
        String errorMessage = '';

        // public String applicationNumber = '102107151416305567';
        
        CCApplicationService_get_Req_IB_v1 requestBean = CCApplicationService_get_Req_IB_v1.getNewInstance();
        
        CCApplicationService_get_Resp_IB_v1 response = new CCApplicationService_get_Resp_IB_v1();

        string usr = System.UserInfo.getUserId();
        
        User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];

        requestBean.getApplicationInformation.arg0.requestCommons.channelCode = 'B';
        requestBean.getApplicationInformation.arg0.requestCommons.employeeNumber =  userInfo.EmployeeNumber;
        requestBean.getApplicationInformation.arg0.requestCommons.messageLanguage ='E';
        requestBean.getApplicationInformation.arg0.requestCommons.siteId = userInfo.SiteCode__c;
        requestBean.getApplicationInformation.arg0.requestCommons.systemName = 'BSF';
        requestBean.getApplicationInformation.arg0.requestCommons.userId = userInfo.AB_Number__c;
        
        requestBean.getApplicationInformation.arg0.applicationNumber = applicationNumber;

        //System.debug(JSON.serialize(requestBean));
        // response = CCApplicationService_get_IH_v1.GetApplicationInformation(requestBean);
        // System.debug(JSON.serialize(response));

        try
        {
            response = CCApplicationService_get_IH_v1.getApplicationInformation(requestBean);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured while retrieving the application: ' + ex.getMessage();

            throw new AuraHandledException('Error: '+errorMessage);
        }

        return response;
    }

    /**
    * @description Get income data from Application_Income_and_Expense__c    
    * @param applicationId
    * @return String
    */
    public static String getIncome(Id applicationId)
    {
        CCApplicationServiceHelper.MonthlyIncome result = new CCApplicationServiceHelper.MonthlyIncome();
        
        result.applicationId = applicationId;
        
        result.otherIncome = CCApplicationServiceHelper.getRecord(applicationId, 'Monthly Income', 'Other Income');
        result.grossIncome = CCApplicationServiceHelper.getRecord(applicationId, 'Monthly Income', 'Gross Income');
        result.netIncome = CCApplicationServiceHelper.getRecord(applicationId, 'Monthly Income', 'Net Income');
        result.rentalIncome = CCApplicationServiceHelper.getRecord(applicationId, 'Monthly Income', 'Rental Income');

        Application_Income_and_Expense__c other = getRecord(applicationId, 'Monthly Income', 'Other');
        Application_Income_and_Expense__c consent = getRecord(applicationId, 'Monthly Income', 'Bank Statements Consent');
        
        result.other = (other.Applicant_Value__c > 0);
        result.bankStatementsConsent = (consent.Applicant_Value__c > 0);
        result.sourceOfFunds = CCApplicationServiceHelper.getApplicationSOF(applicationId);
        
        return JSON.serialize(result);
    }

    /**
    * @description Get debt expenses data from Application_Income_and_Expense__c    
    * @param applicationId
    * @return String
    */
    public static String getDebtExpenses(Id applicationId)
    {
        //Id applicationId = 'a0u5E00000CM9lCQAT'; 

    	CCApplicationServiceHelper.MonthlyDebtExpenses result = new CCApplicationServiceHelper.MonthlyDebtExpenses();
        
        result.applicationId = applicationId;
        
        result.assetPayment = CCApplicationServiceHelper.getRecord(applicationId, 'Fixed Debt', 'Asset Payment');
        result.creditPayment = CCApplicationServiceHelper.getRecord(applicationId, 'Fixed Debt', 'Credit Payment');
        result.loanPayment = CCApplicationServiceHelper.getRecord(applicationId, 'Fixed Debt', 'Loan Payment');
        result.homeloanPayment = CCApplicationServiceHelper.getRecord(applicationId, 'Fixed Debt', 'Homeloan Payment');
        result.retailPayment = CCApplicationServiceHelper.getRecord(applicationId, 'Fixed Debt', 'Retail Payment');
        
        Application_Income_and_Expense__c joint = CCApplicationServiceHelper.getRecord(applicationId, 'Fixed Debt', 'Joint Responsible');
        
        result.jointResponsible = (joint.Applicant_Value__c > 0);        
        
        //system.debug(result);

        return JSON.serialize(result);
    }

    /**
    * @description Get living expenses data from Application_Income_and_Expense__c    
    * @param applicationId
    * @return String
    */
    public static String getLivingExpenses(Id applicationId)
    {
    	CCApplicationServiceHelper.MonthlyLivingExpenses result = new CCApplicationServiceHelper.MonthlyLivingExpenses();
        
        result.applicationId = applicationId;
        
        result.householdExpense = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Household Expense');        
        result.fuelExpense = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Fuel Expense');        
        result.educationFee = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Education Fee');        
        result.insurancePolicies = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Insurance Polices');
        result.maintenanceExpense = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Maintenance Expense');
        result.rent = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Rent');
        result.otherAmount = CCApplicationServiceHelper.getRecord(applicationId, 'Living Expenses', 'Other Amount');
        
        result.otherExpenses = (result.otherAmount.Applicant_Value__c > 0.00);
        
        return JSON.serialize(result);
    }

    /**
    * @description getRecord    
    * @param applicationId
    * @param category
    * @param expenseValue
    * @return Application_Income_and_Expense__c
    */
    public static Application_Income_and_Expense__c getRecord(Id applicationId, string category, string expenseValue)
    {
        Application_Income_and_Expense__c result;
       
        try {
            result = [SELECT Id, Application__c, Name, Category__c, Expense_Value__c, Applicant_Value__c 
                      FROM Application_Income_and_Expense__c 
                      WHERE Application__c = :applicationId 
                      AND Category__c = :category
                      AND Expense_Value__c = :expenseValue WITH SECURITY_ENFORCED LIMIT 1];
        }
        catch (QueryException ex) {
            throw new AuraHandledException('Error in GetRecord: ' + ex.getMessage());    
        }
        
        return result;
    }

    /**
    * @description Get Source of Funds data from Application__c
    * @param applicationId
    * @return String
    */
    public static string getApplicationSOF(Id applicationId)
    {
        Application__c app = [SELECT Source_of_Funds_Savings__c
            FROM Application__c
            WHERE Id = :applicationId WITH SECURITY_ENFORCED];

        return app.Source_of_Funds_Savings__c;    
    }

    /**
    * @description Calculate income left after expenses
    * @param applicationId
    * @return Double
    */
    public static Double getIncomeLeft(Id applicationId)
    {
        Double incomeLeft = 0;

        AggregateResult a  = [SELECT SUM(Applicant_Value__c)TotalIncome 
                                                    FROM Application_Income_and_Expense__c 
                                                    WHERE Application__c = :applicationId
                                                    AND Category__c = 'Monthly Income'
                                                    AND Expense_Value__c IN ('Net Income', 'Rental Income', 'Other Income')];
        
        AggregateResult b = [SELECT SUM(Applicant_Value__c)TotalExpenses
                            FROM Application_Income_and_Expense__c  
                            WHERE Application__c = :applicationId
                            AND Category__c IN ('Fixed Debt', 'Living Expenses')
                            AND Expense_Value__c IN ('Asset Payment','Credit Payment', 'Loan Payment', 'Homeloan Payment', 'Retail Payment', 'Household Expense', 'Fuel Expense', 'Education Fee', 'Insurance Polices', 'Maintenance Expense', 'Rent', 'Other Amount')];
            
        Double income = Double.valueOf(a.get('TotalIncome'));
        Double expenses = Double.valueOf(b.get('TotalExpenses'));
        
        incomeLeft = income - expenses;
        
        return incomeLeft;
    }

    /**
    * @description Calculate total income before expenses
    * @param applicationId
    * @return Double
    */
    public static Double getTotalIncome(Id applicationId)
    {
        Double incomeLeft = 0;

        AggregateResult a  = [SELECT SUM(Applicant_Value__c)TotalIncome 
                                                    FROM Application_Income_and_Expense__c 
                                                    WHERE Application__c = :applicationId
                                                    AND Category__c = 'Monthly Income'
                                                    AND Expense_Value__c IN ('Net Income', 'Rental Income', 'Other Income')];
        
        
            
        Double income = Double.valueOf(a.get('TotalIncome'));
        
        return income;
    }


    /**
    * @description Get the SOF value from Integration Translation    
    * @param description 
    * @return string 
    **/
    public static string getSOFValue(string description)
    {
        string result = '';

        Integration_Translation__c data = [SELECT External_Value__c 
            FROM Integration_Translation__c 
            WHERE System_Name__c = 'CIFCodesList'
            AND Value_Type__c = 'Sof'
            AND Direction__c = 'Outbound'
            AND Internal_Value__c = :description WITH SECURITY_ENFORCED];

        result = ((data != null) && (data.External_Value__c != null)) ? data.External_Value__c : '';

        return result;
    }

    /**
    * @description Monthly income data
    */
    public class MonthlyIncome
    {
        @auraEnabled public Id applicationId;        
    	@auraEnabled public Application_Income_and_Expense__c grossIncome;
        @auraEnabled public Application_Income_and_Expense__c netIncome;    
        @auraEnabled public Application_Income_and_Expense__c rentalIncome;
        @auraEnabled public Application_Income_and_Expense__c otherIncome;
        @auraEnabled public Boolean other;
        @auraEnabled public Boolean bankStatementsConsent;
        @auraEnabled public String sourceOfFunds;
    }
    
    /**
    * @description Monthly debt data
    */
    public class MonthlyDebtExpenses
    {
        @auraEnabled public Id applicationId;        
        @auraEnabled public Application_Income_and_Expense__c assetPayment;
        @auraEnabled public Application_Income_and_Expense__c creditPayment;
        @auraEnabled public Application_Income_and_Expense__c loanPayment;
        @auraEnabled public Application_Income_and_Expense__c homeloanPayment;
        @auraEnabled public Application_Income_and_Expense__c retailPayment;
        @auraEnabled public Boolean jointResponsible;
    }
    
    /**
    * @description Monthly living expenses data
    */
    public class MonthlyLivingExpenses
    {
        @auraEnabled public Id applicationId;        
		@auraEnabled public Application_Income_and_Expense__c householdExpense;
        @auraEnabled public Application_Income_and_Expense__c fuelExpense;
        @auraEnabled public Application_Income_and_Expense__c educationFee;
        @auraEnabled public Application_Income_and_Expense__c insurancePolicies;
        @auraEnabled public Application_Income_and_Expense__c maintenanceExpense;
        @auraEnabled public Application_Income_and_Expense__c rent;
        @auraEnabled public Integer dependents;
        @auraEnabled public Boolean otherExpenses;        
        @auraEnabled public Application_Income_and_Expense__c otherAmount;        
    }
}