public class IntegrationTestDataFactory {

    public static void insertIntegrationSettings(String apiNameP, List<String> serviceNameListP){
        
        List<Integration_API__c> apiList = new List<Integration_API__c>();
        //API (Dev)
        Integration_API__c apiDev = new Integration_API__c();
        apiDev.Name = apiNameP;
        apiDev.Environment__c = 'Development';
        apiDev.Client_Secret__c = '*****';
        apiDev.Client_ID__c = '*****';
        apiDev.Base_URL__c = 'https://Absa330762.jitterbit.eu';
        apiList.add(apiDev);
        //API (UAT)
        Integration_API__c apiUAT = new Integration_API__c();
        apiUAT.Name = apiNameP;
        apiUAT.Environment__c = 'UAT';
        apiUAT.Client_Secret__c = '*****';
        apiUAT.Client_ID__c = '*****';
        apiDev.Base_URL__c = 'https://Absa330762.jitterbit.eu';
        apiList.add(apiUAT);
        //API (Prod)
        Integration_API__c apiProd = new Integration_API__c();
        apiProd.Name = apiNameP;
        apiProd.Environment__c = 'Production';
        apiProd.Client_Secret__c = '*****';
        apiProd.Client_ID__c = '*****';
        apiDev.Base_URL__c = 'https://Absa330762.jitterbit.eu';
        apiList.add(apiProd);
        insert apiList;
        
        List<Integration_Service__c> serviceList = new List<Integration_Service__c>();
        
        for(String serviceName : serviceNameListP){
            
            //Service(Dev)
            Integration_Service__c serviceDev = new Integration_Service__c();
            serviceDev.Integration_API_ID__c = apiDev.Id;
            serviceDev.Name = serviceName;
            serviceDev.Content_Type__c = 'application/json';
            serviceDev.Method__c = 'POST';
            serviceDev.URL_Extension__c = serviceName;
            serviceDev.Username__c = '***/*****@***/****';
            serviceDev.Password__c = '****************';
            serviceList.add(serviceDev);
            //Service(UAT)
            Integration_Service__c serviceUAT = new Integration_Service__c();
            serviceUAT.Integration_API_ID__c = apiUAT.Id;
            serviceUAT.Name = serviceName;
            serviceUAT.Content_Type__c = 'application/json';
            serviceUAT.Method__c = 'POST';
            serviceUAT.URL_Extension__c = serviceName;
            serviceUAT.Username__c = '***/****@*****/***';
            serviceUAT.Password__c = '****************';
            serviceList.add(serviceUAT);
            //Service(Prod)
            Integration_Service__c serviceProd = new Integration_Service__c();
            serviceProd.Integration_API_ID__c = apiProd.Id;
            serviceProd.Name = serviceName;
            serviceProd.Content_Type__c = 'application/json';
            serviceProd.Method__c = 'POST';
            serviceProd.URL_Extension__c = serviceName;
            serviceProd.Username__c = '***/****@*****/***';
            serviceProd.Password__c = '****************';
            serviceList.add(serviceProd);
        }
        insert serviceList;
    }
    //Anka Ganta: 2019-09-11,this mehtod works for JITTERBIT interface 
    public static void insertIntegrationSettingsJitterbit(String apiNameP, List<String> serviceNameListP){
        
        List<Integration_API__c> apiList = new List<Integration_API__c>();
        //API (Dev)
        Integration_API__c apiDev = new Integration_API__c();
        apiDev.Name = apiNameP;
        apiDev.Environment__c = 'Development';
        apiDev.Client_Secret__c = '*****';
        apiDev.Client_ID__c = '*****';
        apiList.add(apiDev);
        //API (UAT)
        Integration_API__c apiUAT = new Integration_API__c();
        apiUAT.Name = apiNameP;
        apiUAT.Environment__c = 'UAT';
        apiUAT.Client_Secret__c = '*****';
        apiUAT.Client_ID__c = '*****';
        apiList.add(apiUAT);
        //API (Prod)
        Integration_API__c apiProd = new Integration_API__c();
        apiProd.Name = apiNameP;
        apiProd.Environment__c = 'Production';
        apiProd.Client_Secret__c = '*****';
        apiProd.Client_ID__c = '*****';
        apiList.add(apiProd);
        insert apiList;
        
        List<Integration_Service__c> serviceList = new List<Integration_Service__c>();
        
        for(String serviceName : serviceNameListP){
            
            //Service(Dev)
            Integration_Service__c serviceDev = new Integration_Service__c();
            serviceDev.Integration_API_ID__c = apiDev.Id;
            serviceDev.Name = serviceName;
            serviceDev.Content_Type__c = 'application/json';
            serviceDev.Method__c = 'POST';
            serviceDev.URL_Extension__c = serviceName;
            serviceDev.Username__c = '**/***@****/******';
            serviceDev.Password__c = '****************';
            serviceList.add(serviceDev);
            //Service(UAT)
            Integration_Service__c serviceUAT = new Integration_Service__c();
            serviceUAT.Integration_API_ID__c = apiUAT.Id;
            serviceUAT.Name = serviceName;
            serviceUAT.Content_Type__c = 'application/json';
            serviceUAT.Method__c = 'POST';
            serviceUAT.URL_Extension__c = serviceName;
            serviceUAT.Username__c = '**/***@**********';
            serviceUAT.Password__c = '****************';
            serviceList.add(serviceUAT);
            //Service(Prod)
            Integration_Service__c serviceProd = new Integration_Service__c();
            serviceProd.Integration_API_ID__c = apiProd.Id;
            serviceProd.Name = serviceName;
            serviceProd.Content_Type__c = 'application/json';
            serviceProd.Method__c = 'POST';
            serviceProd.URL_Extension__c = serviceName;
            serviceProd.Username__c = '***/**@**********';
            serviceProd.Password__c = '****************';
            serviceList.add(serviceProd);
        }
        insert serviceList;
    }
    public static void insertIntegrationTranslations(){
        
        List<Integration_Translation__c> integrationTranslationList = new List<Integration_Translation__c>();
        //Create countryOfBirth record
        Integration_Translation__c countryOfBirth = new Integration_Translation__c();
        countryOfBirth.Name = 'South Africa';
        countryOfBirth.Internal_Value__c = 'South Africa';
        countryOfBirth.External_Value__c = 'SO003';
        countryOfBirth.System_Name__c = StringConstants.WBIF_STRING;
        countryOfBirth.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfBirth.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(countryOfBirth);
        
        //Create countryOfResidence record
        Integration_Translation__c countryOfResidence = new Integration_Translation__c();
        countryOfResidence.Name = 'South Africa';
        countryOfResidence.Internal_Value__c = 'South Africa';
        countryOfResidence.External_Value__c = 'SO003';
        countryOfResidence.System_Name__c = StringConstants.WBIF_STRING;
        countryOfResidence.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfResidence.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(countryOfResidence);
        
        //Create maritalStatus record
        Integration_Translation__c maritalStatus = new Integration_Translation__c();
        maritalStatus.Name = 'Married';
        maritalStatus.Internal_Value__c = 'Married';
        maritalStatus.External_Value__c = 'Married';
        maritalStatus.System_Name__c = StringConstants.WBIF_STRING;
        maritalStatus.Value_Type__c = StringConstants.FIELD_MARITAL_STATUS_STRING;
        maritalStatus.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(maritalStatus);
        
        //Create maritalStatus record
        Integration_Translation__c maritalStatusCIF = new Integration_Translation__c();
        maritalStatusCIF.Name = 'Married';
        maritalStatusCIF.Internal_Value__c = 'Married';
        maritalStatusCIF.External_Value__c = 'Married';
        maritalStatusCIF.System_Name__c = StringConstants.CIF_STRING;
        maritalStatusCIF.Value_Type__c = StringConstants.FIELD_MARITAL_STATUS_STRING;
        maritalStatusCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(maritalStatusCIF);
        
        //Create maritalStatus record
        Integration_Translation__c maritalContractCIF = new Integration_Translation__c();
        maritalContractCIF.Name = 'Married';
        maritalContractCIF.Internal_Value__c = 'Community of Property';
        maritalContractCIF.External_Value__c = 'Community of Property';
        maritalContractCIF.System_Name__c = StringConstants.CIF_STRING;
        maritalContractCIF.Value_Type__c = 'Marital Contract Type';
        maritalContractCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(maritalContractCIF);
        
        //Create Gender record
        Integration_Translation__c genderCIF = new Integration_Translation__c();
        genderCIF.Name = 'Ganer';
        genderCIF.Internal_Value__c = 'Male';
        genderCIF.External_Value__c = 'Male';
        genderCIF.System_Name__c = StringConstants.CIF_STRING;
        genderCIF.Value_Type__c = 'Gender';
        genderCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(genderCIF);
        
        //Create nationality record
        Integration_Translation__c nationality = new Integration_Translation__c();
        nationality.Name = 'South African';
        nationality.Internal_Value__c = 'South Africa';
        nationality.External_Value__c = 'SOU01';
        nationality.System_Name__c = StringConstants.WBIF_STRING;
        nationality.Value_Type__c = StringConstants.FIELD_NATIONALITY_STRING;
        nationality.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(nationality);
        
        //Create incomeSource record
        Integration_Translation__c incomeSource = new Integration_Translation__c();
        incomeSource.Name = 'Bonus';
        incomeSource.Internal_Value__c = 'Bonus';
        incomeSource.External_Value__c = '22';
        incomeSource.System_Name__c = StringConstants.WBIF_STRING;
        incomeSource.Value_Type__c = StringConstants.FIELD_SOURCE_OF_INCOME_STRING;
        incomeSource.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(incomeSource);
        
        //Create siebelStageName record
        Integration_Translation__c siebelStageName = new Integration_Translation__c();
        siebelStageName.Name = 'Sale Successful';
        siebelStageName.Internal_Value__c = 'Sale Successful';
        siebelStageName.External_Value__c = 'Successful Sale';
        siebelStageName.System_Name__c = StringConstants.SIEBEL_STRING;
        siebelStageName.Value_Type__c = StringConstants.FIELD_STAGE_NAME_STRING;
        siebelStageName.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(siebelStageName);
        
        //create opportunityProduct
        Integration_Translation__c opportunityProduct = new Integration_Translation__c();
        opportunityProduct.Name  = 'Estate Provider Plan';
        opportunityProduct.Internal_Value__c = 'Estate Provider Plan';
        opportunityProduct.External_Value__c = 'EPP';
        opportunityProduct.System_Name__c = StringConstants.SIEBEL_STRING;
        opportunityProduct.Value_Type__c = StringConstants.FIELD_PRODUCT_NAME_STRING;
        opportunityProduct.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(opportunityProduct);
        
        Integration_Translation__c countryOfBirth2 = new Integration_Translation__c();
        countryOfBirth2.Name = 'South Africa';
        countryOfBirth2.Internal_Value__c = 'South Africa';
        countryOfBirth2.External_Value__c = 'SO003';
        countryOfBirth2.System_Name__c = StringConstants.ECASA_STRING;
        countryOfBirth2.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfBirth2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(countryOfBirth2);
        
        Integration_Translation__c idType = new Integration_Translation__c();
        idType.Name = 'SA Identity Document';
        idType.Internal_Value__c = 'SA Identity Document';
        idType.External_Value__c = '1';
        idType.System_Name__c = StringConstants.ECASA_STRING;
        idType.Value_Type__c = StringConstants.FIELD_IDENTITY_TYPE_STRING;
        idType.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(idType);
        
        Integration_Translation__c nationality2 = new Integration_Translation__c();
        nationality2.Name = 'South African';
        nationality2.Internal_Value__c = 'South Africa';
        nationality2.External_Value__c = 'SOU01';
        nationality2.System_Name__c = StringConstants.ECASA_STRING;
        nationality2.Value_Type__c = StringConstants.FIELD_NATIONALITY_STRING;
        nationality2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(nationality2);
        
        Integration_Translation__c nationality3 = new Integration_Translation__c();
        nationality3.Name = 'South African';
        nationality3.Internal_Value__c = 'South Africa';
        nationality3.External_Value__c = 'SOU01';
        nationality3.System_Name__c = StringConstants.CIF_STRING;
        nationality3.Value_Type__c = StringConstants.FIELD_NATIONALITY_STRING;
        nationality3.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(nationality3);
        
        Integration_Translation__c countryOfBirth3 = new Integration_Translation__c();
        countryOfBirth3.Name = 'South African';
        countryOfBirth3.Internal_Value__c = 'South Africa';
        countryOfBirth3.External_Value__c = 'SOU01';
        countryOfBirth3.System_Name__c = StringConstants.CIF_STRING;
        countryOfBirth3.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfBirth3.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(countryOfBirth3);
        
        /*Integration_Translation__c emailOptOut = new Integration_Translation__c();
        emailOptOut.Name = 'False';
        emailOptOut.Internal_Value__c = 'false';
        emailOptOut.External_Value__c = 'N';
        emailOptOut.System_Name__c = StringConstants.CIF_STRING;
        emailOptOut.Value_Type__c = StringConstants.FIELD_OPTED_OUT;
        emailOptOut.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(emailOptOut);*/
        
        Integration_Translation__c homeLanguage = new Integration_Translation__c();
        homeLanguage.Name = 'English';
        homeLanguage.Internal_Value__c = 'English';
        homeLanguage.External_Value__c = 'E';
        homeLanguage.System_Name__c = StringConstants.CIF_STRING;
        homeLanguage.Value_Type__c = StringConstants.FIELD_LANGUAGE;
        homeLanguage.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(homeLanguage);
        
        Integration_Translation__c occupation = new Integration_Translation__c();
        occupation.Name = 'Advertising';
        occupation.Internal_Value__c = 'Advertising';
        occupation.External_Value__c = 'Advertising';
        occupation.System_Name__c = StringConstants.CIF_STRING;
        occupation.Value_Type__c = StringConstants.FIELD_OCCUPATION_CATEGORY_STRING;
        occupation.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(occupation);
        
        //Create countryOfResidenceEcasa ECASA record
        Integration_Translation__c countryOfResidenceEcasa = new Integration_Translation__c();
        countryOfResidenceEcasa.Name = 'South Africa';
        countryOfResidenceEcasa.Internal_Value__c = 'South Africa';
        countryOfResidenceEcasa.External_Value__c = 'SO003';
        countryOfResidenceEcasa.System_Name__c = StringConstants.ECASA_STRING;
        countryOfResidenceEcasa.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfResidenceEcasa.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(countryOfResidenceEcasa);
        
        //Create sourceOfIncome record
        Integration_Translation__c sourceOfIncome = new Integration_Translation__c();
        sourceOfIncome.Name = 'Bonus';
        sourceOfIncome.Internal_Value__c = 'Bonus';
        sourceOfIncome.External_Value__c = '22';
        sourceOfIncome.System_Name__c = StringConstants.ECASA_STRING;
        sourceOfIncome.Value_Type__c = StringConstants.FIELD_SOURCE_OF_INCOME_STRING;
        sourceOfIncome.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(sourceOfIncome);
        
        //Create occupation record
        Integration_Translation__c occupationCategory = new Integration_Translation__c();
        occupationCategory.Name = 'Sales Person';
        occupationCategory.Internal_Value__c = 'Sales Person';
        occupationCategory.External_Value__c = '4';
        occupationCategory.System_Name__c = StringConstants.ECASA_STRING;
        occupationCategory.Value_Type__c = StringConstants.FIELD_OCCUPATION_CATEGORY_STRING;
        occupationCategory.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(occupationCategory);
        
        //Create occupation record
        Integration_Translation__c occupationCategory2 = new Integration_Translation__c();
        occupationCategory2.Name = 'Advertising';
        occupationCategory2.Internal_Value__c = 'Advertising';
        occupationCategory2.External_Value__c = '4';
        occupationCategory2.System_Name__c = StringConstants.ECASA_STRING;
        occupationCategory2.Value_Type__c = StringConstants.FIELD_OCCUPATION_CATEGORY_STRING;
        occupationCategory2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE; 
        integrationTranslationList.add(occupationCategory2);
        
        //Create occupation record
        Integration_Translation__c occupationCategory3 = new Integration_Translation__c();
        occupationCategory3.Name = 'Advertising';
        occupationCategory3.Internal_Value__c = 'Advertising';
        occupationCategory3.External_Value__c = '4';
        occupationCategory3.System_Name__c = StringConstants.CIF_STRING;
        occupationCategory3.Value_Type__c = StringConstants.FIELD_OCCUPATION_CATEGORY_STRING;
        occupationCategory3.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE; 
        integrationTranslationList.add(occupationCategory3);
        
        //Create occupationStatus record
        Integration_Translation__c occupationStatus = new Integration_Translation__c();
        occupationStatus.Name = 'Full Time Employed';
        occupationStatus.Internal_Value__c = 'Full Time Employed';
        occupationStatus.External_Value__c = '1';
        occupationStatus.System_Name__c = StringConstants.ECASA_STRING;
        occupationStatus.Value_Type__c = StringConstants.FIELD_OCCUPATION_STATUS_STRING;
        occupationStatus.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(occupationStatus);
        
        //Create clientTypeIndividual record
        Integration_Translation__c clientTypeIndividual = new Integration_Translation__c();
        clientTypeIndividual.Name = 'Private Individual - SA Resident';
        clientTypeIndividual.Internal_Value__c = 'Individual';
        clientTypeIndividual.External_Value__c = '00101';
        clientTypeIndividual.System_Name__c = StringConstants.CIF_STRING;
        clientTypeIndividual.Value_Type__c = 'Client Type';
        clientTypeIndividual.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeIndividual);
        
        //Create clientTypeBusiness record
        Integration_Translation__c clientTypeBusiness = new Integration_Translation__c();
        clientTypeBusiness.Name = 'Joint and Several - SA Resident';
        clientTypeBusiness.Internal_Value__c = 'Joint & Several';
        clientTypeBusiness.External_Value__c = '00301';
        clientTypeBusiness.System_Name__c = StringConstants.CIF_STRING;
        clientTypeBusiness.Value_Type__c = 'Client Type';
        clientTypeBusiness.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeBusiness);
        //==============================
        //Create idTypeCIF record
        Integration_Translation__c idTypeCIF = new Integration_Translation__c();
        idTypeCIF.Name = 'Identity Document';
        idTypeCIF.Internal_Value__c = 'SA Identity Document';
        idTypeCIF.External_Value__c = '01';
        idTypeCIF.System_Name__c = StringConstants.CIF_STRING;
        idTypeCIF.Value_Type__c = 'Identity Type';
        idTypeCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(idTypeCIF);
        
        //Create personTitleCIF record
        Integration_Translation__c personTitleCIF = new Integration_Translation__c();
        personTitleCIF.Name = 'Mr';
        personTitleCIF.Internal_Value__c = 'Mr.';
        personTitleCIF.External_Value__c = '01';
        personTitleCIF.System_Name__c = StringConstants.CIF_STRING;
        personTitleCIF.Value_Type__c = 'Title';
        personTitleCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(personTitleCIF);
        
        //Create incomeSourceCIF record
        Integration_Translation__c incomeSourceCIF = new Integration_Translation__c();
        incomeSourceCIF.Name = 'Bonus';
        incomeSourceCIF.Internal_Value__c = 'Bonus';
        incomeSourceCIF.External_Value__c = '22';
        incomeSourceCIF.System_Name__c = StringConstants.CIF_STRING;
        incomeSourceCIF.Value_Type__c = 'Source of Income';
        incomeSourceCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(incomeSourceCIF);
        
        //Create nationalityCIF record
        Integration_Translation__c nationalityCIF = new Integration_Translation__c();
        nationalityCIF.Name = 'South Africa';
        nationalityCIF.Internal_Value__c = 'South Africa';
        nationalityCIF.External_Value__c = 'SOU01';
        nationalityCIF.System_Name__c = StringConstants.CIF_STRING;
        nationalityCIF.Value_Type__c = 'Nationality';
        nationalityCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(nationalityCIF);
        
        //Create countryCIF record
        Integration_Translation__c countryCIF = new Integration_Translation__c();
        countryCIF.Name = 'South Africa';
        countryCIF.Internal_Value__c = 'South Africa';
        countryCIF.External_Value__c = 'SO003';
        countryCIF.System_Name__c = StringConstants.CIF_STRING;
        countryCIF.Value_Type__c = 'Country';
        countryCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(countryCIF);
        
        //Create occupationStatusCIF record
        Integration_Translation__c occupationStatusCIF = new Integration_Translation__c();
        occupationStatusCIF.Name = 'Full Time Employed';
        occupationStatusCIF.Internal_Value__c = 'Full Time Employed';
        occupationStatusCIF.External_Value__c = '01';
        occupationStatusCIF.System_Name__c = StringConstants.CIF_STRING;
        occupationStatusCIF.Value_Type__c = 'Occupation Status';
        occupationStatusCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(occupationStatusCIF);
        
        //Create occupationCategoryCIF record
        Integration_Translation__c occupationCategoryCIF = new Integration_Translation__c();
        occupationCategoryCIF.Name = 'Administration';
        occupationCategoryCIF.Internal_Value__c = 'Administration';
        occupationCategoryCIF.External_Value__c = '02';
        occupationCategoryCIF.System_Name__c = StringConstants.CIF_STRING;
        occupationCategoryCIF.Value_Type__c = 'Occupation Category';
        occupationCategoryCIF.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(occupationCategoryCIF);
        
        //Create accountTypeEPS record
        Integration_Translation__c accountTypeEPS = new Integration_Translation__c();
        accountTypeEPS.Name = 'Cheque Account';
        accountTypeEPS.Internal_Value__c = 'Cheque';
        accountTypeEPS.External_Value__c = '01';
        accountTypeEPS.System_Name__c = 'EPS';
        accountTypeEPS.Value_Type__c = 'Account Type';
        accountTypeEPS.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(accountTypeEPS);
        
        //Create Language AFR record
        Integration_Translation__c languageAFR = new Integration_Translation__c();
        languageAFR.Name = 'Afrikaans';
        languageAFR.Internal_Value__c = 'Afrikaans';
        languageAFR.External_Value__c = 'A';
        languageAFR.System_Name__c = 'CIF';
        languageAFR.Value_Type__c = 'Language';
        languageAFR.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(languageAFR);
        
        //Create Language ENG record
        Integration_Translation__c languageENG = new Integration_Translation__c();
        languageENG.Name = 'English';
        languageENG.Internal_Value__c = 'English';
        languageENG.External_Value__c = 'E';
        languageENG.System_Name__c = 'CIF';
        languageENG.Value_Type__c = 'Language';
        languageENG.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(languageENG);
        
        //Create accountTypeAVS record
        Integration_Translation__c accountTypeAVS = new Integration_Translation__c();
        accountTypeAVS.Name = 'Savings Account';
        accountTypeAVS.Internal_Value__c = 'Savings';
        accountTypeAVS.External_Value__c = '02';
        accountTypeAVS.System_Name__c = 'AVS';
        accountTypeAVS.Value_Type__c = 'Account Type';
        accountTypeAVS.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(accountTypeAVS);
        
        //Create bankNameAVS record
        Integration_Translation__c bankNameAVS = new Integration_Translation__c();
        bankNameAVS.Name = 'ABSA';
        bankNameAVS.Internal_Value__c = 'ABSA BANK LIMITED';
        bankNameAVS.External_Value__c = '16';
        bankNameAVS.System_Name__c = 'AVS';
        bankNameAVS.Value_Type__c = 'Bank Name';
        bankNameAVS.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(bankNameAVS);
        
        //Create crMarkConcent record
        /*Integration_Translation__c crMarkConcent = new Integration_Translation__c();
        crMarkConcent.Name = 'Yes';
        crMarkConcent.Internal_Value__c = 'Yes';
        crMarkConcent.External_Value__c = 'Y';
        crMarkConcent.System_Name__c = StringConstants.CIF_STRING;
        crMarkConcent.Value_Type__c = 'Credit Marketing Consent';
        crMarkConcent.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(crMarkConcent);*/
        
        //Create ncrMarkConcent record
        Integration_Translation__c ncrMarkConcent = new Integration_Translation__c();
        ncrMarkConcent.Name = 'Yes';
        ncrMarkConcent.Internal_Value__c = 'Yes';
        ncrMarkConcent.External_Value__c = 'Y';
        ncrMarkConcent.System_Name__c = StringConstants.CIF_STRING;
        ncrMarkConcent.Value_Type__c = 'Non-Credit Marketing Consent';
        ncrMarkConcent.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(ncrMarkConcent);
        
        //Create crMarkConcentNo record
        /*Integration_Translation__c crMarkConcentNo = new Integration_Translation__c();
        crMarkConcentNo.Name = 'No';
        crMarkConcentNo.Internal_Value__c = 'No';
        crMarkConcentNo.External_Value__c = 'N';
        crMarkConcentNo.System_Name__c = StringConstants.CIF_STRING;
        crMarkConcentNo.Value_Type__c = 'Credit Marketing Consent';
        crMarkConcentNo.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(crMarkConcentNo);*/
        
        //Create ncrMarkConcentNo record
        Integration_Translation__c ncrMarkConcentNo = new Integration_Translation__c();
        ncrMarkConcentNo.Name = 'No';
        ncrMarkConcentNo.Internal_Value__c = 'No';
        ncrMarkConcentNo.External_Value__c = 'N';
        ncrMarkConcentNo.System_Name__c = StringConstants.CIF_STRING;
        ncrMarkConcentNo.Value_Type__c = 'Non-Credit Marketing Consent';
        ncrMarkConcentNo.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(ncrMarkConcentNo);
        
        Integration_Translation__c clientTypeECASAInd = new Integration_Translation__c();
        clientTypeECASAInd.Name = 'Individual Client';
        clientTypeECASAInd.Internal_Value__c = 'Individual Client';
        clientTypeECASAInd.External_Value__c = '1';
        clientTypeECASAInd.System_Name__c = StringConstants.ECASA_STRING;
        clientTypeECASAInd.Value_Type__c = 'Client Type';
        clientTypeECASAInd.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeECASAInd);
        
        Integration_Translation__c clientTypeECASAJnt = new Integration_Translation__c();
        clientTypeECASAJnt.Name = 'Joint & Several';
        clientTypeECASAJnt.Internal_Value__c = 'Joint & Several';
        clientTypeECASAJnt.External_Value__c = '1';
        clientTypeECASAJnt.System_Name__c = StringConstants.ECASA_STRING;
        clientTypeECASAJnt.Value_Type__c = 'Client Type';
        clientTypeECASAJnt.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeECASAJnt);
        
        Integration_Translation__c clientTypeGrpECASAInd = new Integration_Translation__c();
        clientTypeGrpECASAInd.Name = 'Individual';
        clientTypeGrpECASAInd.Internal_Value__c = 'Individual';
        clientTypeGrpECASAInd.External_Value__c = 'I';
        clientTypeGrpECASAInd.System_Name__c = StringConstants.ECASA_STRING;
        clientTypeGrpECASAInd.Value_Type__c = 'Client Type Group';
        clientTypeGrpECASAInd.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeGrpECASAInd);
        
        Integration_Translation__c clientTypeGrpECASAIndCli = new Integration_Translation__c();
        clientTypeGrpECASAIndCli.Name = 'Individual Client';
        clientTypeGrpECASAIndCli.Internal_Value__c = 'Individual Client';
        clientTypeGrpECASAIndCli.External_Value__c = 'I';
        clientTypeGrpECASAIndCli.System_Name__c = StringConstants.ECASA_STRING;
        clientTypeGrpECASAIndCli.Value_Type__c = 'Client Type Group';
        clientTypeGrpECASAIndCli.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeGrpECASAIndCli);
        
        Integration_Translation__c clientTypeGrpECASAJnt = new Integration_Translation__c();
        clientTypeGrpECASAJnt.Name = 'Joint & Several';
        clientTypeGrpECASAJnt.Internal_Value__c = 'Joint & Several';
        clientTypeGrpECASAJnt.External_Value__c = 'J';
        clientTypeGrpECASAJnt.System_Name__c = StringConstants.ECASA_STRING;
        clientTypeGrpECASAJnt.Value_Type__c = 'Client Type Group';
        clientTypeGrpECASAJnt.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(clientTypeGrpECASAJnt);
        
        Integration_Translation__c relationshipECASAInd = new Integration_Translation__c();
        relationshipECASAInd.Name = 'Individual Client';
        relationshipECASAInd.Internal_Value__c = 'Individual Client';
        relationshipECASAInd.External_Value__c = '1';
        relationshipECASAInd.System_Name__c = StringConstants.ECASA_STRING;
        relationshipECASAInd.Value_Type__c = 'Relationship';
        relationshipECASAInd.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(relationshipECASAInd);
        
        Integration_Translation__c relationshipECASAJnt = new Integration_Translation__c();
        relationshipECASAJnt.Name = 'Joint & Several';
        relationshipECASAJnt.Internal_Value__c = 'Joint & Several';
        relationshipECASAJnt.External_Value__c = '1';
        relationshipECASAJnt.System_Name__c = StringConstants.ECASA_STRING;
        relationshipECASAJnt.Value_Type__c = 'Relationship';
        relationshipECASAJnt.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        integrationTranslationList.add(relationshipECASAJnt);
        
        Integration_Translation__c casaStatusInbound = new Integration_Translation__c();
        casaStatusInbound.Name = 'Proceed';
        casaStatusInbound.Internal_Value__c = 'Proceed';
        casaStatusInbound.External_Value__c = 'P';
        casaStatusInbound.System_Name__c = StringConstants.ECASA_STRING;
        casaStatusInbound.Value_Type__c = 'eCasa Status';
        casaStatusInbound.Direction__c = StringConstants.INBOUND_RECORD_TYPE;   
        integrationTranslationList.add(casaStatusInbound);
        
        Integration_Translation__c casaStatusByRefInbound = new Integration_Translation__c();
        casaStatusByRefInbound.Name = 'Proceed';
        casaStatusByRefInbound.Internal_Value__c = 'Proceed';
        casaStatusByRefInbound.External_Value__c = 'P';
        casaStatusByRefInbound.System_Name__c = StringConstants.ECASA_STRING;
        casaStatusByRefInbound.Value_Type__c = 'eCasa Status By Ref';//eCasa Status By Ref
        casaStatusByRefInbound.Direction__c = StringConstants.INBOUND_RECORD_TYPE;   
        integrationTranslationList.add(casaStatusByRefInbound);
        //StringConstants.CIF_STRING, 'Credit Marketing Consent', accountP.Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        
        Integration_Translation__c crdMarkConCIF = new Integration_Translation__c();
        crdMarkConCIF.Name = 'Yes';
        crdMarkConCIF.Internal_Value__c = 'Yes';
        crdMarkConCIF.External_Value__c = 'Y';
        crdMarkConCIF.System_Name__c = StringConstants.CIF_STRING;
        crdMarkConCIF.Value_Type__c = 'Credit Marketing Consent';//eCasa Status By Ref
        crdMarkConCIF.Direction__c = StringConstants.INBOUND_RECORD_TYPE;   
        integrationTranslationList.add(crdMarkConCIF);

        Integration_Translation__c groupId = new Integration_Translation__c();
        groupId.Name = 'POSH Merchant';
        groupId.Internal_Value__c = 'A00 - GENERAL';
        groupId.External_Value__c = 'A00';
        groupId.System_Name__c = StringConstants.CAMS_STRING;
        groupId.Value_Type__c = 'Group ID';
        groupId.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(groupId); 

        Integration_Translation__c config = new Integration_Translation__c();
        config.Name = 'POSH Merchant';
        config.Internal_Value__c = 'ABSA DEVICES-P';
        config.External_Value__c = '09';
        config.System_Name__c = StringConstants.CAMS_STRING;
        config.Value_Type__c = 'Configuration';
        config.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(config);

        Integration_Translation__c merchantClass = new Integration_Translation__c();
        merchantClass.Name = 'POSH Merchant';
        merchantClass.Internal_Value__c = 'RETAIL';
        merchantClass.External_Value__c = '01';
        merchantClass.System_Name__c = StringConstants.CAMS_STRING;
        merchantClass.Value_Type__c = 'Merchant Class';
        merchantClass.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(merchantClass);

        Integration_Translation__c feeCode = new Integration_Translation__c();
        feeCode.Name = 'POSH Merchant';
        feeCode.Internal_Value__c = '[Mobile - SmartPay]:[10.0]';//Price is set to 10 because that is how it is setup in the PricingTestDataFactory
        feeCode.External_Value__c = 'C80';
        feeCode.System_Name__c = 'CAMS';
        feeCode.Value_Type__c = 'Fee Code';
        feeCode.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        integrationTranslationList.add(feeCode);

        insert integrationTranslationList;
    }
}