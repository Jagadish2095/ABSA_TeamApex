/**
 * @description A reusable class that provides a static method that calls the CIF or MDM as source services depending on if the account has a CIF Key or only an ID Number
* that gets account information and then creates that account
*
* @author  Danie Booysen & Jason Quevauvilliers
* @since   2019-07-22
*/
public without sharing class AccountCreate_CIF_MDM {
    /**
*
* @description createAccountFromCIF
* @param cifKeyP
* @param accountNumP
* @param siteCodeP
* @author  Sandile Mathe
* @return caseid
*
*/
   public static GIPResponse createAccountFromCIF(String cifKeyP, String accountNumP, String siteCodeP){
       List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
       GIPResponse methodResponse = new GIPResponse();
       Boolean isNewClient = false;
       
       try{
           //Call get Client Details
           Map<GetClientDetailsCIF_Resp_IB_v1, Sys_Log_Integration__c> clientDetailsResponseMap = GetClientDetailsCIF_IH_v1.getClientDetailsMap(
               cifKeyP,
               accountNumP,
               siteCodeP
           );
           //Get the log
           clientDetailsResponseMap.values()[0].Method_Name__c = '1. ' + clientDetailsResponseMap.values()[0].Method_Name__c;
           logList.add(clientDetailsResponseMap.values()[0]);
           List<GetClientDetailsCIF_Resp_IB_v1> clientDetailsList = new List<GetClientDetailsCIF_Resp_IB_v1>(clientDetailsResponseMap.keySet());
           //Assign the Bean
           GetClientDetailsCIF_Resp_IB_v1 clientDetailsResponseBean = clientDetailsList[0];
           //System.debug('GetClientDetails Main Account: ' + clientDetailsResponseBean.statusCode + ' ' + clientDetailsResponseBean.message);
           
           if(clientDetailsResponseBean.statusCode == 200 && clientDetailsResponseBean.indCifRecFound == 'Y'){
               //Query to check if account exists otherwise create new account
               List<Account> cifAccountList = new AccountsSelector().selectByCIF(clientDetailsResponseBean.clientCode, 1);
               //System.debug('getClientDetails Main Account. Number of existing account found: ' + cifAccountList.size());
               Account mainAccount;
               if(cifAccountList.size() == 1){
                   mainAccount = cifAccountList[0];
                   isNewClient = false;
               }else{
                   mainAccount = new Account();
                   isNewClient = true;
               }
               mainAccount.Valid_Update_Bypass__c = true;
               //System.debug('getClientDetails Main Account Client Group: ' + clientDetailsResponseBean.clientGroup);
               if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                   mainAccount.Client_Since_Date__c = Date.valueOf(
                       clientDetailsResponseBean.dateClientOpened.subString(0, 4) +
                       '-' +
                       clientDetailsResponseBean.dateClientOpened.subString(4, 6) +
                       '-' +
                       clientDetailsResponseBean.dateClientOpened.subString(6, 8)
                   );
                   }
               
               if(clientDetailsResponseBean.clientGroup == 'I'){
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub
                   
                  /* if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       
                       mainAccount.Client_Since_Date__c = Date.valueOf(clientDetailsResponseBean.dateClientOpened.subString(0,4) + '-' + clientDetailsResponseBean.dateClientOpened.subString(4,6) + '-' + clientDetailsResponseBean.dateClientOpened.subString(6,8));
                   }*/
                   
                   // mainAccount.Client_Since_Date__c =date.valueof(clientDetailsResponseBean.dateClientOpened); //added by Madhava for customerhub
                   //INDIVIDUAL
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   //Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   //Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Individual';
                   //Map Account Fields
                   mainAccount = mapCifAccountFieldsGetClientDetails(mainAccount, clientDetailsResponseBean);
                   
                   upsert mainAccount;
                   
                   //Create/Update Address__c objects
                   List<Address__c> addressList = [
                       SELECT Account__c, Address_Type__c, Shipping_Street__c, Shipping_City__c, Shipping_Suburb__c, Shipping_Zip_Postal_Code__c
                       FROM Address__c
                       WHERE Account__c = :mainAccount.Id AND Address_Type__c = 'Employers'
                   ];
                   //System.debug('Main Account existing Employers Address__c: ' + addressList);
                   Boolean employersAddressFoundInSF;
                   if(addressList.size() == 0){
                       employersAddressFoundInSF = false;
                   }else if(addressList.size() == 1){
                       employersAddressFoundInSF = true;
                   }
                   
                   Boolean employersAddressFoundInCIF = false;
                   Address__c address;
                   
                   for(GetClientDetailsCIF_Resp_IB_v1.cls_addressEntry cifAddress : clientDetailsResponseBean.addressEntry){
                       if(cifAddress.addrType == '70'){
                           if(cifAddress.addrLine2 != '' && cifAddress.addrTown != '' && cifAddress.addrPostlCode != '' && cifAddress.addrPostlCode != null){
                               employersAddressFoundInCIF = true;
                               address = employersAddressFoundInSF ? addressList[0] : new Address__c();
                               address.Address_Type__c = 'Employers';
                               address.Shipping_Street__c = cifAddress.addrLine2;
                               address.Shipping_City__c = cifAddress.addrTown;
                               address.Shipping_Suburb__c = cifAddress.addrSuburbRsa;
                               address.Account__c = mainAccount.Id;
                               address.Shipping_Zip_Postal_Code__c = formatPostalCode(cifAddress.addrPostlCode);
                           }
                       }
                   }
                   if(employersAddressFoundInCIF){
                       //System.debug('Main Account Address to Upsert: ' + address);
                       upsert address;
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
               }else if(clientDetailsResponseBean.clientGroup == 'J'){
                   //JOINT ACCOUNT
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub
                   
                   //by Madhava for customer hub
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       mainAccount.Client_Since_Date__c = Date.valueOf(
                           clientDetailsResponseBean.dateClientOpened.subString(0, 4) +
                           '-' +
                           clientDetailsResponseBean.dateClientOpened.subString(4, 6) +
                           '-' +
                           clientDetailsResponseBean.dateClientOpened.subString(6, 8)
                       );
                   }
                   
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   //Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   //Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Joint & Several';
                   mainAccount.CIF__c = clientDetailsResponseBean.clientCode;
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   Map<GIPResponse, List<Sys_log_Integration__c>> participantResponseMap = createParticipantsCIF(mainAccount, siteCodeP);
                   
                   logList.addAll(participantResponseMap.values()[0]);
                   
                   List<GIPResponse> GIPResponseList = new List<GIPResponse>(participantResponseMap.keySet());
                   //Assign the Bean
                   methodResponse = GIPResponseList[0];
                   //Get Joint Participants
               }else if(clientDetailsResponseBean.clientGroup == 'S'){
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub
                   
                   //by madhava for customerhub
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       mainAccount.Client_Since_Date__c = Date.valueOf(
                           clientDetailsResponseBean.dateClientOpened.subString(0, 4) +
                           '-' +
                           clientDetailsResponseBean.dateClientOpened.subString(4, 6) +
                           '-' +
                           clientDetailsResponseBean.dateClientOpened.subString(6, 8)
                       );
                   }
                   
                   // PJAIN: 20190918
                   // Implemented as a quick and dirty fix for Relationship Banking
                   // It just creates basic account with minimum information.
                   // Addresses, Phone numbers, Participants, Relationships, Countries,
                   // Industries etc are not catered for in this solution.
                   // This has been agreed with Ramadise Makhanya
                   //
                   // SOLE PROPRIETOR
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   //Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   //Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Sole Trader';
                   mainAccount.Client_Group__c = 'SOLE TRADER CLIENT';
                   mainAccount.CIF__c = clientDetailsResponseBean.clientCode;
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
               }else if(clientDetailsResponseBean.clientGroup == 'N'){
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub
                   //by madhava for customerhub
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       mainAccount.Client_Since_Date__c = Date.valueOf(
                           clientDetailsResponseBean.dateClientOpened.subString(0, 4) +
                           '-' +
                           clientDetailsResponseBean.dateClientOpened.subString(4, 6) +
                           '-' +
                           clientDetailsResponseBean.dateClientOpened.subString(6, 8)
                       );
                   }
                   
                   // PJAIN: 20190918
                   // Implemented as a quick and dirty fix for Relationship Banking
                   // It just creates basic account with minimum information.
                   // Addresses, Phone numbers, Participants, Relationships, Countries,
                   // Industries etc are not catered for in this solution.
                   // This has been agreed with Ramadise Makhanya
                   //
                   // NON INDIVIDUAL - COMPANY
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   // Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   // Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   
                   String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                       StringConstants.CIF_STRING,
                       'Client Type',
                       clientDetailsResponseBean.clientType,
                       StringConstants.INBOUND_RECORD_TYPE
                   );
                   mainAccount.Client_Type__c = clientTypeTranslated;
                   
                   mainAccount.CIF__c = clientDetailsResponseBean.clientCode;
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   //TdB - Additional mappings for Onboarding
                   mainAccount.Registration_Number__c = clientDetailsResponseBean.idNumber;
                   
                   String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                       StringConstants.CIF_STRING,
                       'Identity Type',
                       clientDetailsResponseBean.idDocType,
                       StringConstants.INBOUND_RECORD_TYPE
                   );
                   mainAccount.ID_Type__c = idTypeTranslated;
                   
                   String clientGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                       StringConstants.CIF_STRING,
                       'Client Type Group',
                       clientDetailsResponseBean.clientGroup,
                       StringConstants.INBOUND_RECORD_TYPE
                   );
                   mainAccount.Client_Group__c = clientGroupTranslated;
                   
                   String ccountryOfOriginTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                       StringConstants.CIF_STRING,
                       'Country',
                       clientDetailsResponseBean.countryOfOrigin,
                       StringConstants.INBOUND_RECORD_TYPE
                   );
                   mainAccount.Country_of_Registration__c = ccountryOfOriginTranslated;
                   
                   String countryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                       StringConstants.CIF_STRING,
                       'Country',
                       clientDetailsResponseBean.countryIncorp,
                       StringConstants.INBOUND_RECORD_TYPE
                   );
                   mainAccount.Country_of_Incorporation__c = countryOfIncorporationTranslated;
                   
                   String countryOfOperation;
                   for(GetClientDetailsCIF_Resp_IB_v1.cls_countryEntOprtData cifcountryEntOprtData : clientDetailsResponseBean.countryEntOprtData){
                       String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                           StringConstants.CIF_STRING,
                           'Country',
                           cifcountryEntOprtData.countryEntOprt,
                           StringConstants.INBOUND_RECORD_TYPE
                       );
                       if(countryOfOperationTranslated != null && countryOfOperationTranslated != '') {
                           if(countryOfOperation == null) {
                               countryOfOperation = countryOfOperationTranslated;
                           } else {
                               countryOfOperation = countryOfOperation + ';' + countryOfOperationTranslated;
                           }
                       }
                   }
                   if(countryOfOperation != null) {
                       mainAccount.Country_of_Operation__c = countryOfOperation;
                   }

                   if(clientDetailsResponseBean.dateIdentified != null && clientDetailsResponseBean.dateIdentified.length() == 8){
                       mainAccount.Date_Identified__c = Date.newInstance(
                           Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(4, 8)),
                           Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(2, 4)),
                           Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(0, 2))
                       );
                   }
                   
                   if(clientDetailsResponseBean.dateVerified != null && clientDetailsResponseBean.dateVerified.length() == 8){

                       mainAccount.Date_Verified__c = Date.newInstance(
                           Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(4, 8)),
                           Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(2, 4)),
                           Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(0, 2))
                       );

                   }
                   
                   mainAccount.Identified_by_Employee_Number__c = clientDetailsResponseBean.employeeIdentified;
                   mainAccount.Verified_by_Employee_Number__c = clientDetailsResponseBean.employeeVerified;
                   mainAccount.Language__c = clientDetailsResponseBean.language;
                   
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       mainAccount.Date_Established__c = Date.newInstance(
                           Integer.valueOf(clientDetailsResponseBean.dateClientOpened.subString(0, 4)),
                           Integer.valueOf(clientDetailsResponseBean.dateClientOpened.subString(4, 6)),
                           Integer.valueOf(clientDetailsResponseBean.dateClientOpened.subString(6, 8))
                       );
                   }

                   if (
                       clientDetailsResponseBean.taxNumber != null &&
                       clientDetailsResponseBean.taxNumber != '' &&
                       clientDetailsResponseBean.taxNumber != '0'
                   ) {
                       mainAccount.Income_Tax_Number__c = clientDetailsResponseBean.taxNumber;
                   }
                   if(clientDetailsResponseBean.vatRegistrationNo != null && clientDetailsResponseBean.vatRegistrationNo != '') {
                       mainAccount.VAT_Registration_Number__c = Decimal.ValueOf(clientDetailsResponseBean.vatRegistrationNo);
                   }

                   String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                       StringConstants.CIF_STRING,
                       StringConstants.FIELD_SOURCE_OF_INCOME_STRING,
                       clientDetailsResponseBean.sourceOfIncome,
                       StringConstants.INBOUND_RECORD_TYPE
                   );
                   mainAccount.Source_of_Income__c = srcOfincomeTranslated;
                   
                   if(clientDetailsResponseBean.affectedPerson != null && clientDetailsResponseBean.affectedPerson != '0') {
                       String affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                           StringConstants.CIF_STRING,
                           'Affected Person',
                           clientDetailsResponseBean.affectedPerson,
                           StringConstants.INBOUND_RECORD_TYPE
                       );
                       mainAccount.Q4b_How_is_the_Client_Affected__c = affectedPersonTranslated;
                   }

                   if(clientDetailsResponseBean.exconExpiryDate != null && clientDetailsResponseBean.exconExpiryDate.length() == 8){
                       mainAccount.Q4c_Exchange_Control_Expiry_date__c = Date.newInstance(
                           Integer.valueOf(clientDetailsResponseBean.exconExpiryDate.subString(0, 4)),
                           Integer.valueOf(clientDetailsResponseBean.exconExpiryDate.subString(4, 6)),
                           Integer.valueOf(clientDetailsResponseBean.exconExpiryDate.subString(6, 8))
                       );
                   }
                   
                   for(GetClientDetailsCIF_Resp_IB_v1.cls_foreignTaxData cifForeignTax : clientDetailsResponseBean.foreignTaxData){
                       if(cifForeignTax.foreignTaxNo != null && cifForeignTax.foreignTaxNo != '' && cifForeignTax.foreignTaxNo != '0') {
                           mainAccount.Foreign_Tax_Number__c = Decimal.ValueOf(cifForeignTax.foreignTaxNo);
                           String foreignTaxCtryTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                               StringConstants.CIF_STRING,
                               'Country',
                               cifForeignTax.foreignTaxCtry,
                               StringConstants.INBOUND_RECORD_TYPE
                           );
                           mainAccount.Country_of_Foreign_tax__c = foreignTaxCtryTranslated;
                           break;
                       } 
                   }

                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   if(isNewClient == true){
                       //TdB - Additional Address mappings for Onboarding
                       List<Address__c> addressLst = mapCIFAddressTypes(mainAccount, clientDetailsResponseBean);
   
                       if(addressLst != null && addressLst.size() > 0) {
                           insert addressLst;
                       }
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
               }else if(clientDetailsResponseBean.clientGroup == 'E'){
                   // PJAIN: 20190918
                   // Implemented as a quick and dirty fix for Relationship Banking
                   // It just creates basic account with minimum information.
                   // Addresses, Phone numbers, Participants, Relationships, Countries,
                   // Industries etc are not catered for in this solution.
                   // This has been agreed with Ramadise Makhanya
                   //
                   // ESTATE LATE CLIENT
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   // Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   // Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Estate Late';
                   mainAccount.CIF__c = clientDetailsResponseBean.clientCode;
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
               }else if(clientDetailsResponseBean.clientGroup == 'P'){
                   // PJAIN: 20190918
                   // Implemented as a quick and dirty fix for Relationship Banking
                   // It just creates basic account with minimum information.
                   // Addresses, Phone numbers, Participants, Relationships, Countries,
                   // Industries etc are not catered for in this solution.
                   // This has been agreed with Ramadise Makhanya
                   //
                   // PARTNERSHIP
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   // Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   // Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Partnership';
                   mainAccount.CIF__c = clientDetailsResponseBean.clientCode;
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
               }else{
                   //Invalid clientGroup none found
                   methodResponse.response = 'Client Group \'' + clientDetailsResponseBean.clientGroup + '\' is not a valid value in Salesforce.';
                   //System.debug(methodResponse.response);
               }
           }else{
               //Error on getClientDetailsCIF
               methodResponse.response = clientDetailsResponseBean.message != null &&
                   clientDetailsResponseBean.message != ''
                   ? clientDetailsResponseBean.message
                   : 'Client not found on CIF';
               //System.debug(methodResponse.response);
           }
       }catch(Exception e){
           //Exception response bean and log
           String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
           logList.add(
               SystemLogger.createInternalIntegrationLog(
                   'AccountCreate_CIF_MDM.createAccountFromCIF',
                   'Create Account Salesforce From CIF',
                   500,
                   StringConstants.INTEGRATION_STATUS_FAILED,
                   message
               )
           );
           methodResponse.response = message;
           //System.debug(message);
       }
       if(logList.size() > 0){
           insert logList;
       }
       //System.debug('Create Account From CIF final Response: ' + methodResponse);
       return methodResponse;
   }
      /**
*
* @description createParticipantsCIF
* @param mainAccountP
* @param siteCodeP
* @author  Sandile Mathe
* @return caseid
*
*/
   public static Map<GIPResponse, List<Sys_log_Integration__c>> createParticipantsCIF(Account mainAccountP, String siteCodeP){
       GIPResponse methodResponse = new GIPResponse();
       List<Sys_log_Integration__c> logList = new List<Sys_log_Integration__c>();
       Map<GIPResponse, List<Sys_log_Integration__c>> responseMap = new Map<GIPResponse, List<Sys_log_Integration__c>>();
       List<Account> participantAccountList = new List<Account>();
       //System.debug('createParticipantsCIF Method');
       
       try{
           //Get Joint Participants
           Map<GetJointParticipant_Resp_IB_v1, Sys_Log_Integration__c> getJntPartResponseMap = GetJointParticipant_IH_v1.getJointParticipantMap(
               mainAccountP.CIF__c
           );
           getJntPartResponseMap.values()[0].Method_Name__c = '2. ' + getJntPartResponseMap.values()[0].Method_Name__c;
           logList.add(getJntPartResponseMap.values()[0]);
           List<GetJointParticipant_Resp_IB_v1> getJntParticipantList = new List<GetJointParticipant_Resp_IB_v1>(getJntPartResponseMap.keySet());
           //Assign the Bean
           GetJointParticipant_Resp_IB_v1 getJntPartResponseBean = getJntParticipantList[0];
           //System.debug('GetJntParticipants for Main Account in CIF: ' + getJntPartResponseBean.statusCode + ' ' + getJntPartResponseBean.message);
           
           if(getJntPartResponseBean.statusCode == 200 && getJntPartResponseBean.nbrRetrv != '0'){
               Set<String> idNumberSet = new Set<String>();
               for(GetJointParticipant_Resp_IB_v1.cls_JntEntry jntPart : getJntPartResponseBean.jntEntry){
                   idNumberSet.add(jntPart.idNumber);
               }
               List<Account> existingPartAccountList = [SELECT Id, ID_Number__pc, PersonContactId FROM Account WHERE ID_Number__pc IN : idNumberSet];
               //System.debug('GetJntParticipants Number of existing Participant accounts found: ' + existingPartAccountList.size());
               
               //For each joint participant
               for(GetJointParticipant_Resp_IB_v1.cls_JntEntry jntPart : getJntPartResponseBean.jntEntry){
                   Account partAccount;
                   Boolean foundPartAccount = false;
                   for(Account acc : existingPartAccountList){
                       if(acc.ID_Number__pc == jntPart.idNumber){
                           partAccount = acc;
                           foundPartAccount = true;
                       }
                   }
                   if(!foundPartAccount){
                       partAccount = new Account();
                   }
                   
                   //Get Extra data using the Id returned
                   Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> jntClientMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(
                       jntPart.idNumber,
                       jntPart.idDocType,
                       siteCodeP
                   );
                   jntClientMap.values()[0].Method_Name__c = '3. ' + jntClientMap.values()[0].Method_Name__c;
                   logList.add(jntClientMap.values()[0]);
                   List<GetClientDetailsByIdCIF_Resp_IB_v1> jntClientList = new List<GetClientDetailsByIdCIF_Resp_IB_v1>(jntClientMap.keySet());
                   //Assign the Bean
                   GetClientDetailsByIdCIF_Resp_IB_v1 getClientDetailsByIdJntResponseBean = jntClientList[0];
                   /*System.debug(
                       'GetClientDetails for each Participant: ' +
                       getClientDetailsByIdJntResponseBean.statusCode +
                       ' message: ' +
                       getClientDetailsByIdJntResponseBean.message +
                       '. Nbr of Records found: ' +
                       getClientDetailsByIdJntResponseBean.nbrEntsRetrieved
                   );*/
                   
                   if(getClientDetailsByIdJntResponseBean.statusCode == 200 && getClientDetailsByIdJntResponseBean.nbrEntsRetrieved != '0'){
                       String entryCIFKey = '';
                       Integer entryCount = 0;
                       for(GetClientDetailsByIdCIF_Resp_IB_v1.cls_tblEntry entry : getClientDetailsByIdJntResponseBean.tblEntry){
                           //System.debug('CIF Key: ' + entry.cifKey + '. clientGroup: ' + entry.cifClntGroup);
                           if(entry.cifClntGroup == 'I'){
                               entryCIFKey = entry.cifKey;
                               entryCount++;
                           }
                       }
                       if(entryCount == 1){
                           //Call get Client Details
                           Map<GetClientDetailsCIF_Resp_IB_v1, Sys_Log_Integration__c> entryGetClientDetailsMap = GetClientDetailsCIF_IH_v1.getClientDetailsMap(
                               entryCIFKey,
                               '0',
                               '009970'
                           ); //Clarify - Parameters
                           //Get the log
                           entryGetClientDetailsMap.values()[0].Method_Name__c = '4. ' + entryGetClientDetailsMap.values()[0].Method_Name__c;
                           logList.add(entryGetClientDetailsMap.values()[0]);
                           List<GetClientDetailsCIF_Resp_IB_v1> entryGetClientDetailsList = new List<GetClientDetailsCIF_Resp_IB_v1>(
                               entryGetClientDetailsMap.keySet()
                           );
                           //Assign the Bean
                           GetClientDetailsCIF_Resp_IB_v1 entryGetClientDetailsResponseBean = entryGetClientDetailsList[0];
                           /*System.debug(
                               'GetClientDetails for each entry returned from getJntParticipant: ' +
                               entryGetClientDetailsResponseBean.statusCode +
                               ' message: ' +
                               entryGetClientDetailsResponseBean.message +
                               '. Client Found: ' +
                               entryGetClientDetailsResponseBean.indCifRecFound
                           );*/
                           
                           if(entryGetClientDetailsResponseBean.statusCode == 200 && entryGetClientDetailsResponseBean.indCifRecFound == 'Y'){
                               foundPartAccount = false;
                               for(Account acc : existingPartAccountList){
                                   if(acc.ID_Number__pc == entryGetClientDetailsResponseBean.idNumber){
                                       partAccount = acc;
                                       foundPartAccount = true;
                                   }
                               }
                               if(!foundPartAccount){
                                   partAccount = new Account();
                               }
                               
                               partAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                               partAccount.Client_Type__c = 'Individual';
                               
                               entryGetClientDetailsResponseBean =  tempConcatinateTitleAndLanguage(entryGetClientDetailsResponseBean);
                               entryGetClientDetailsResponseBean = translateToInternalValues(entryGetClientDetailsResponseBean);
                               
                               Account participantAccount = mapCifAccountFieldsGetClientDetails(partAccount, entryGetClientDetailsResponseBean);
                               
                               participantAccountList.add(participantAccount);
                           }else{
                               //If Error in GetClientDetails we don't care - Create From getJntParticipants
                               //No Records Found
                               //Logs are already added into list
                               //Map from JntPart Bean
                               //Record type is Individual Prospect
                               partAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
                               partAccount.Client_Type__c = 'Individual';
                               
                               jntPart =  tempConcatinateTitleAndLanguage(jntPart);
                               jntPart = translateToInternalValues(jntPart);
                               
                               Account participantAccount = mapAccountFieldsJntParticipant(partAccount, jntPart);
                               
                               participantAccountList.add(participantAccount);
                               //System.debug('Error in GetClientDetails we dont care - Create From getJntParticipants');
                           }
                       }else{
                           //GetClientDetailsById Success - Logs added to list - Create From getJntParticipants
                           //Multiple or No entries found with type I
                           partAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();// Clarify / Verify
                           partAccount.Client_Type__c = 'Individual';
                           
                           jntPart =  tempConcatinateTitleAndLanguage(jntPart);
                           jntPart = translateToInternalValues(jntPart);
                           
                           Account participantAccount = mapAccountFieldsJntParticipant(partAccount, jntPart);
                           
                           participantAccountList.add(participantAccount);
                           //System.debug('Multiple or No entries found with type I');
                       }
                   }else{
                       //If Error in GetClientDetailsById we don't care - Create From getJntParticipants
                       //Logs are already added into list
                       //Map from JntPart Bean
                       //Record type is Individual Prospect
                       partAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
                       partAccount.Client_Type__c = 'Individual';
                       
                       jntPart =  tempConcatinateTitleAndLanguage(jntPart);
                       jntPart = translateToInternalValues(jntPart);
                       
                       Account participantAccount = mapAccountFieldsJntParticipant(partAccount, jntPart);
                       
                       participantAccountList.add(participantAccount);
                       //System.debug('Error in GetClientDetailsById we dont care - Create From getJntParticipants');
                   }
               }
               //INSERT MAIN ACCOUNT
               upsert mainAccountP;
               
               //INSERT JOINT ACCOUNTS FROM ACCOUNT LIST
               if(!Test.isRunningTest()){
                   upsert participantAccountList;
               }
               
               List<Account> insertedPartAccList = [SELECT PersonContactId FROM Account WHERE Id IN : participantAccountList];
               
               Set<Id> personContactIdSet = new Set<Id>();
               for(Account partAcc : insertedPartAccList){
                   if(partAcc.PersonContactId != null){
                       personContactIdSet.add(partAcc.PersonContactId);
                   }
               }
               List<AccountContactRelation> acrList = [
                   SELECT AccountId, ContactId
                   FROM AccountContactRelation
                   WHERE AccountId = :mainAccountP.Id AND ContactId IN :personContactIdSet
               ];
               List<AccountContactRelation> acrListToInsert = new List<AccountContactRelation>();
               //System.debug('personContactIdSet: ' + personContactIdSet);
               //System.debug('insertedPartAccList: ' + insertedPartAccList);
               //System.debug('Existing AccountContactRelationships: ' + acrList);
               
               for(Account partAcc : insertedPartAccList){
                   Boolean acrFound = false;
                   for(AccountContactRelation acr : acrList){
                       if(acr.ContactId == partAcc.PersonContactId){
                           acrFound = true;
                       }
                   }
                   if(!acrFound){
                       AccountContactRelation acrObj = new AccountContactRelation();
                       acrObj.AccountId = mainAccountP.Id;
                       acrObj.ContactId = partAcc.PersonContactId;
                       acrListToInsert.add(acrObj);
                   }
               }
               if(acrListToInsert.size() > 0){
                   //System.debug('AccountContactRelationships To Insert: ' + acrListToInsert);
                   insert acrListToInsert;
               }
               
               String message = '';
               if(mainAccountP.Id == null){
                   message = 'Main Account was not found or Updated. ';
               }
               if(participantAccountList.size() == 0){
                   message += 'No Participants were found or Updated. ';
               }
               if(message == ''){
                   message = 'Success';
               }
               methodResponse.response = message;
               methodResponse.accountId = mainAccountP.Id;
           }else if(getJntPartResponseBean.statusCode == 200 && getJntPartResponseBean.nbrRetrv == '0'){
               //Get Joint Participant - No Participants Found
               methodResponse.response = 'No Participants found for the account with CIF Key: ' + mainAccountP.CIF__c;
           }else{
               //Get Joint Participant Error
               methodResponse.response = getJntPartResponseBean.message;
           }
       }catch(Exception e){
           //Exception response bean and log
           String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
           logList.add(
               SystemLogger.createInternalIntegrationLog(
                   'AccountCreate_CIF_MDM.createParticipantsCIF',
                   'Create Account Salesforce From CIF',
                   500,
                   StringConstants.INTEGRATION_STATUS_FAILED,
                   message
               )
           );
           methodResponse.response = message;
           //System.debug(message);
       }
       //System.debug('LOG LIST: ' + logList);
       ///System.debug('Create Participants from CIF method final response: ' + methodResponse);
       responseMap.put(methodResponse, logList);
       
       return responseMap;
   }
        /**
*
* @description createAccountFromMDM
* @param queryTypeP
* @param regIdP
* @author  Sandile Mathe
* @return caseid
*
*/
   public static GIPResponse createAccountFromMDM(String queryTypeP, String regIdP){
       List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
       GIPResponse methodResponse = new GIPResponse();
       
       if(queryTypeP != null && regIdP != null){
           try{
               Map<RegSer_InvolvedParties_Resp_IB_v1, Sys_Log_Integration__c> getInvolvedPartiesMap = RegSer_InvolvedParties_IH_v1.getInvolvedPartiesMap(
                   queryTypeP,
                   regIdP
               );
               
               getInvolvedPartiesMap.values()[0].Method_Name__c = '1. ' + getInvolvedPartiesMap.values()[0].Method_Name__c;
               logList.add(getInvolvedPartiesMap.values()[0]);
               List<RegSer_InvolvedParties_Resp_IB_v1> getInvolvedPartiesList = new List<RegSer_InvolvedParties_Resp_IB_v1>(getInvolvedPartiesMap.keySet());
               //Assign the Bean
               RegSer_InvolvedParties_Resp_IB_v1 getInvolvedPartiesResponseBean = getInvolvedPartiesList[0];
               /*System.debug(
                   'getInvolvedParties for Main Account: ' +
                   getInvolvedPartiesResponseBean.statusCode +
                   ' ' +
                   getInvolvedPartiesResponseBean.message
               );*/
               
               if(getInvolvedPartiesResponseBean.statusCode == 200){
                   //Success: GetInvolvedParties
                   //Query to check if account exists otherwise create new account
                   List<Account> accountList = new List<Account>();
                   if(queryTypeP == 'SAID' || queryTypeP == 'Passport'){
                       accountList = new AccountsSelector().selectByIdNumber(regIdP, 1);
                   }else if(queryTypeP == 'CIF'){
                       accountList = new AccountsSelector().selectByCIF(regIdP, 1);
                   }else if(queryTypeP == 'SUIN'){
                       accountList = new AccountsSelector().selectBySUIN(regIdP, 1);
                   }
                   
                   Account mainAccount;
                   if(accountList.size() == 1){
                       mainAccount = accountList[0];
                   }else{
                       mainAccount = new Account();
                   }
                   
                   String clientType;
                   if(getInvolvedPartiesResponseBean.content.individual != null){
                       clientType = getInvolvedPartiesResponseBean.content.individual.clientClassification.description;
                   }else if(getInvolvedPartiesResponseBean.content.informalOrganisation != null){
                       clientType = getInvolvedPartiesResponseBean.content.informalOrganisation.type.description;
                   }else if(getInvolvedPartiesResponseBean.content.formalOrganisation != null){
                       clientType = getInvolvedPartiesResponseBean.content.formalOrganisation.type.description;
                   }
                   //System.debug('Main Account Client Type: ' + clientType);
                   
                   if(clientType == 'Private Individual' || clientType == 'Staff'){
                       //INDIVIDUAL
                       //Account Mapping
                       mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                       mainAccount.Client_Type__c = 'Individual';
                       //Map Account Fields
                       mainAccount = mapMDMAccountFieldsGetInvParty(mainAccount, getInvolvedPartiesResponseBean, queryTypeP, regIdP);
                       
                       upsert mainAccount;
                       
                       methodResponse.response = 'Success';
                       methodResponse.accountId = mainAccount.Id;
                   }else if(clientType.toLowerCase().contains('joint')){
                       //JOINT
                       //Account Mapping
                       mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                       mainAccount.Client_Type__c = 'Joint & Several';
                       mainAccount.Name = getInvolvedPartiesResponseBean.content.name;
                       for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : getInvolvedPartiesResponseBean.content.identifications){
                           if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
                               mainAccount.CIF__c = identification.numbers;
                           }
                       }
                       mainAccount.Risk_Rating__c = getInvolvedPartiesResponseBean.content.riskRating;
                       
                       Map<GIPResponse, List<Sys_log_Integration__c>> createPrtResponseMap = createParticipantsMDM(mainAccount);
                       
                       logList.addAll(createPrtResponseMap.values()[0]);
                       
                       List<GIPResponse> GIPResponseList = new List<GIPResponse>(createPrtResponseMap.keySet());
                       //Assign the Bean
                       methodResponse = GIPResponseList[0];
                   }else if(clientType == 'Sole Proprietor'){
                       // PJAIN: 20190918
                       // Implemented as a quick and dirty fix for Relationship Banking
                       // It just creates basic account with minimum information.
                       // Addresses, Phone numbers, Participants, Relationships, Countries,
                       // Industries etc are not catered for in this solution.
                       // This has been agreed with Ramadise Makhanya
                       //
                       // SOLE PROPRIETOR
                       // Account Mapping
                       mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                       mainAccount.Client_Type__c = 'Sole Trader';
                       mainAccount.Name = getInvolvedPartiesResponseBean.content.name;
                       for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : getInvolvedPartiesResponseBean.content.identifications){
                           if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
                               mainAccount.CIF__c = identification.numbers;
                           }
                       }
                       mainAccount.Risk_Rating__c = getInvolvedPartiesResponseBean.content.riskRating;
                       
                       // UPSERT MAIN ACCOUNT
                       upsert mainAccount;
                       
                       methodResponse.response = 'Success';
                       methodResponse.accountId = mainAccount.Id;
                   }else if(clientType == 'Estate late client'){
                       // PJAIN: 20190918
                       // Implemented as a quick and dirty fix for Relationship Banking
                       // It just creates basic account with minimum information.
                       // Addresses, Phone numbers, Participants, Relationships, Countries,
                       // Industries etc are not catered for in this solution.
                       // This has been agreed with Ramadise Makhanya
                       //
                       // ESTATE LATE CLIENT
                       // Account Mapping
                       mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                       mainAccount.Client_Type__c = 'Estate Late';
                       mainAccount.Name = getInvolvedPartiesResponseBean.content.name;
                       for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : getInvolvedPartiesResponseBean.content.identifications){
                           if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
                               mainAccount.CIF__c = identification.numbers;
                           }
                       }
                       mainAccount.Risk_Rating__c = getInvolvedPartiesResponseBean.content.riskRating;
                       
                       // UPSERT MAIN ACCOUNT
                       upsert mainAccount;
                       
                       methodResponse.response = 'Success';
                       methodResponse.accountId = mainAccount.Id;
                   }else if(clientType == 'Partnership'){
                       // PJAIN: 20190918
                       // Implemented as a quick and dirty fix for Relationship Banking
                       // It just creates basic account with minimum information.
                       // Addresses, Phone numbers, Participants, Relationships, Countries,
                       // Industries etc are not catered for in this solution.
                       // This has been agreed with Ramadise Makhanya
                       //
                       // PARTNERSHIP
                       // Account Mapping
                       mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                       mainAccount.Client_Type__c = 'Partnership';
                       mainAccount.Name = getInvolvedPartiesResponseBean.content.name;
                       for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : getInvolvedPartiesResponseBean.content.identifications){
                           if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
                               mainAccount.CIF__c = identification.numbers;
                           }
                       }
                       mainAccount.Risk_Rating__c = getInvolvedPartiesResponseBean.content.riskRating;
                       
                       // UPSERT MAIN ACCOUNT
                       upsert mainAccount;
                       
                       methodResponse.response = 'Success';
                       methodResponse.accountId = mainAccount.Id;
                   }else if(!String.isEmpty(clientType)){
                       // PJAIN: 20190918
                       // Implemented as a quick and dirty fix for Relationship Banking
                       // It just creates basic account with minimum information.
                       // Addresses, Phone numbers, Participants, Relationships, Countries,
                       // Industries etc are not catered for in this solution.
                       // This has been agreed with Ramadise Makhanya
                       //
                       // NON INDIVIDUAL - COMPANY
                       // Account Mapping
                       mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                       mainAccount.Client_Type__c = 'Company';
                       mainAccount.Name = getInvolvedPartiesResponseBean.content.name;
                       for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : getInvolvedPartiesResponseBean.content.identifications){
                           if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
                               mainAccount.CIF__c = identification.numbers;
                           }
                       }
                       mainAccount.Risk_Rating__c = getInvolvedPartiesResponseBean.content.riskRating;
                       
                       // UPSERT MAIN ACCOUNT
                       upsert mainAccount;
                       
                       methodResponse.response = 'Success';
                       methodResponse.accountId = mainAccount.Id;
                   }else{
                       //Client Type is invalid
                       methodResponse.response = 'Client Type from Get Involved Parties is invalid: ' + clientType;
                       //System.debug('Client Type from Get Involved Parties is invalid: ' + clientType);
                   }
               }else{
                   //Error: Get Involved Parties
                   //Log already added to list
                   methodResponse.response = getInvolvedPartiesResponseBean.message;
                   //System.debug(getInvolvedPartiesResponseBean.message);
               }
           }catch(Exception e){
               String message = e.getMessage() + ' ' + e.getStackTraceString();
               logList.add(
                   SystemLogger.createInternalIntegrationLog(
                       'AccountCreate_CIF_MDM.createAccountFromMDM',
                       'Create Account Salesforce From MDM',
                       500,
                       StringConstants.INTEGRATION_STATUS_FAILED,
                       message
                   )
               );
               methodResponse.response = message;
               //System.debug(message);
           }
       }else{
           String message = '';
           if(queryTypeP == null){
               message += 'Query Type is Null';
           }
           if(regIdP == null){
               message += 'ID Number / Passport (RegId) is Null';
           }
           logList.add(
               SystemLogger.createInternalIntegrationLog(
                   'AccountCreate_CIF_MDM.createAccountFromMDM',
                   'Create Account Salesforce From MDM',
                   500,
                   StringConstants.INTEGRATION_STATUS_FAILED,
                   message
               )
           );
           methodResponse.response = message;
           //System.debug(message);
       }
       
       if(logList.size() > 0){
           insert logList;
       }
       //System.debug('CreateAccount MDM final Response: ' + methodResponse);
       return methodResponse;
   }
            /**
* @description createParticipantsMDM
* @param mainAccountP
* @author  Sandile Mathe
* @return caseid
*
*/
   public static Map<GIPResponse, List<Sys_log_Integration__c>> createParticipantsMDM(Account mainAccountP){
       //System.debug('Inside Create Part Method');
       GIPResponse methodResponse = new GIPResponse();
       List<Sys_log_Integration__c> logList = new List<Sys_log_Integration__c>();
       Map<GIPResponse, List<Sys_log_Integration__c>> responseMap = new Map<GIPResponse, List<Sys_log_Integration__c>>();
       List<Account> participantAccountList = new List<Account>();
       
       //Get Joint Participants
       Map<GetJointParticipant_Resp_IB_v1, Sys_Log_Integration__c> getJntPartResponseMap = GetJointParticipant_IH_v1.getJointParticipantMap(
           mainAccountP.CIF__c
       );
       getJntPartResponseMap.values()[0].Method_Name__c = '2. ' + getJntPartResponseMap.values()[0].Method_Name__c;
       logList.add(getJntPartResponseMap.values()[0]);
       List<GetJointParticipant_Resp_IB_v1> getJntParticipantList = new List<GetJointParticipant_Resp_IB_v1>(getJntPartResponseMap.keySet());
       //Assign the Bean
       GetJointParticipant_Resp_IB_v1 getJntPartResponseBean = getJntParticipantList[0];
       String message = '';
       /*System.debug(
           'getJntPartResponse From Main Account MDM: ' +
           getJntPartResponseBean.statusCode +
           '. Nbr Retrieved: ' +
           getJntPartResponseBean.nbrRetrv +
           ' ' +
           getJntPartResponseBean.message
       );*/
       
       if(getJntPartResponseBean.statusCode == 200 && getJntPartResponseBean.nbrRetrv != '0'){
           Set<String> idNumberSet = new Set<String>();
           for(GetJointParticipant_Resp_IB_v1.cls_JntEntry jntPart : getJntPartResponseBean.jntEntry){
               idNumberSet.add(jntPart.idNumber);
           }
           List<Account> existingPartAccountList = [SELECT Id, ID_Number__pc, PersonContactId FROM Account WHERE ID_Number__pc IN : idNumberSet];
           //System.debug('Nbr of existing Participant Accounts: ' + existingPartAccountList.size());
           //For each joint participant
           for(GetJointParticipant_Resp_IB_v1.cls_JntEntry jntPart : getJntPartResponseBean.jntEntry){
               Account partAccount;
               Boolean foundPartAccount = false;
               for(Account acc : existingPartAccountList){
                   if(acc.ID_Number__pc == jntPart.idNumber){
                       partAccount = acc;
                       foundPartAccount = true;
                   }
               }
               if(!foundPartAccount){
                   partAccount = new Account();
               }
               
               String docType;
               if(jntPart.idDocType == '1'){
                   docType = 'SAID';
               }
               if(jntPart.idDocType == '3'){
                   docType = 'Passport';
               }
               
               //System.debug('docType: ' + docType + ' ' + jntPart.idNumber + ' ' + jntPart.idDocType);
               
               Map<RegSer_InvolvedParties_Resp_IB_v1, Sys_Log_Integration__c> jntGetInvolvedPartiesMap = RegSer_InvolvedParties_IH_v1.getInvolvedPartiesMap(
                   docType,
                   jntPart.idNumber
               );
               
               jntGetInvolvedPartiesMap.values()[0].Method_Name__c = '3. ' + jntGetInvolvedPartiesMap.values()[0].Method_Name__c;
               logList.add(jntGetInvolvedPartiesMap.values()[0]);
               List<RegSer_InvolvedParties_Resp_IB_v1> jntGetInvolvedPartiesList = new List<RegSer_InvolvedParties_Resp_IB_v1>(
                   jntGetInvolvedPartiesMap.keySet()
               );
               //Assign the Bean
               RegSer_InvolvedParties_Resp_IB_v1 jntGetInvolvedPartiesResponseBean = jntGetInvolvedPartiesList[0];
               
               /*System.debug(
                   'GetInvolvedParties Response from each GetJntPart entry: ' +
                   jntGetInvolvedPartiesResponseBean.statusCode +
                   ' ' +
                   jntGetInvolvedPartiesResponseBean.message
               );*/
               
               if(jntGetInvolvedPartiesResponseBean.statusCode == 200){
                   //Success
                   //Map from Get Involved Parties
                   partAccount = mapMDMAccountFieldsGetInvParty(partAccount, jntGetInvolvedPartiesResponseBean, docType, jntPart.idNumber);
                   participantAccountList.add(partAccount);
               }else{
                   //Get Involved Parties for each Participant failed
                   //Map From Get Joint Participant
                   partAccount = mapAccountFieldsJntParticipant(partAccount, jntPart);
                   participantAccountList.add(partAccount);
                   //Add Account to list to upsert at end
               }
           }
           upsert mainAccountP;
           upsert participantAccountList;
           
           List<Account> insertedPartAccList = [SELECT PersonContactId FROM Account WHERE Id IN : participantAccountList];
           
           Set<Id> personContactIdSet = new Set<Id>();
           for(Account partAcc : insertedPartAccList){
               if(partAcc.PersonContactId != null){
                   personContactIdSet.add(partAcc.PersonContactId);
               }
           }
           List<AccountContactRelation> acrList = [
               SELECT AccountId, ContactId
               FROM AccountContactRelation
               WHERE AccountId = :mainAccountP.Id AND ContactId IN :personContactIdSet
           ];
           List<AccountContactRelation> acrListToInsert = new List<AccountContactRelation>();
           //System.debug('personContactIdSet: ' + personContactIdSet);
           //System.debug('insertedPartAccList: ' + insertedPartAccList);
           //System.debug('Existing AccountContactRelationships: ' + acrList);
           
           for(Account partAcc : insertedPartAccList){
               Boolean acrFound = false;
               for(AccountContactRelation acr : acrList){
                   if(acr.ContactId == partAcc.PersonContactId){
                       acrFound = true;
                   }
               }
               if(!acrFound){
                   AccountContactRelation acrObj = new AccountContactRelation();
                   acrObj.AccountId = mainAccountP.Id;
                   acrObj.ContactId = partAcc.PersonContactId;
                   acrListToInsert.add(acrObj);
               }
           }
           if(acrListToInsert.size() > 0){
               insert acrListToInsert;
           }
           
           message = '';
           if(mainAccountP.Id == null){
               message = 'Main Account was not found or Updated. ';
           }
           if(participantAccountList.size() == 0){
               message += 'No Participants were found or Updated. ';
           }
           if(message == ''){
               message = 'Success';
           }
       }else{
           //Get Jnt Part Error
           message = getJntPartResponseBean.message;
       }
       
       methodResponse.response = message;
       methodResponse.accountId = mainAccountP.Id;
       //System.debug('CreateParticipants MDM final Response: ' + methodResponse);
       
       responseMap.put(methodResponse, logList);
       
       return responseMap;
   }
   
   private static Account mapCifAccountFieldsGetClientDetails(Account accountP, GetClientDetailsCIF_Resp_IB_v1 clientDetailsResponseP){
       //Translated value mappings
       accountP.PersonTitle = clientDetailsResponseP.titleCode;
       accountP.Gender__pc = clientDetailsResponseP.gender;
       accountP.ID_Type__pc = clientDetailsResponseP.idDocType;
       accountP.Marital_Contract_Type__pc = clientDetailsResponseP.mariageContrctType;
       accountP.Marital_Status__pc = clientDetailsResponseP.maritalStatus;
       accountP.Income_Source__pc = clientDetailsResponseP.sourceOfIncome;
       accountP.Monthly_Income__pc = clientDetailsResponseP.incomeGroup;
       accountP.Communication_Language__pc = clientDetailsResponseP.language;
       accountP.Country_of_Birth__pc = clientDetailsResponseP.countryOfBirth;
       accountP.Country_of_Origin__pc = clientDetailsResponseP.countryOfOrigin;
       accountP.Nationality__pc = clientDetailsResponseP.clientNationality;
       if(clientDetailsResponseP.homeLanguage != 'N'){
           accountP.Home_Language__pc = clientDetailsResponseP.homeLanguage;
       }
       accountP.Client_Group__c = clientDetailsResponseP.clientGroup;
       accountP.Employer_Name__pc = clientDetailsResponseP.employerAdd1;
       accountP.Occupation__pc = clientDetailsResponseP.occupationCode;
       accountP.Occupation_Category__pc = clientDetailsResponseP.occupationCode;
       accountP.Occupation_Status__pc = clientDetailsResponseP.occupationStatus;
       accountP.Preferred_Communication_Method__pc = clientDetailsResponseP.prefrdCommtionMthd;
       accountP.Contact_Method__pc = clientDetailsResponseP.prefrdCommtionMthd;
       
       //Name Tags
       accountP.LastName = clientDetailsResponseP.surname;
       accountP.FirstName = clientDetailsResponseP.firstNames;
       //accountP.Person_Informal_Name__pc = clientDetailsResponseP.firstNames;    //Not Applicable to CIF
       accountP.Initials__pc = clientDetailsResponseP.initials;
       if(clientDetailsResponseP.idDocType == 'Passport'){
           accountP.CountryPassport__pc = clientDetailsResponseP.clientNationality;//Translation
           accountP.Passport_Number__pc = clientDetailsResponseP.idNumber;
       }
       accountP.ID_Number__pc = clientDetailsResponseP.idNumber;
       
       accountP.CIF__c = clientDetailsResponseP.clientCode;
       accountP.PersonEmail = clientDetailsResponseP.emailAddress;
       
       //accountP.Risk_Rating__c = clientDetailsResponseP.firstNames;  //Not Applicable to CIF
       
       if(clientDetailsResponseP.birthDate != null && clientDetailsResponseP.birthDate.length() == 8){
           accountP.PersonBirthdate = Date.valueOf(
               clientDetailsResponseP.birthDate.subString(0, 4) +
               '-' +
               clientDetailsResponseP.birthDate.subString(4, 6) +
               '-' +
               clientDetailsResponseP.birthDate.subString(6, 8)
           );
       }
       
       // Contact info Tags
       // The following Code is to cater for an issue with CIF
       // where the mobile phone can only be 10 digits long
       // This will eventually be removed
       if(clientDetailsResponseP.cellphone.length() > 10){
           //Take last 10 Digits
           Integer numberLength = clientDetailsResponseP.cellphone.length();
           accountP.PersonMobilePhone = clientDetailsResponseP.cellphone.Substring(numberLength - 10, numberLength);
       }else if(clientDetailsResponseP.cellphone.length() < 10){
           //Add 0 infront until number is 10 digits
           while(clientDetailsResponseP.cellphone.length() < 10){
               clientDetailsResponseP.cellphone = '0' + clientDetailsResponseP.cellphone;
           }
           accountP.PersonMobilePhone = clientDetailsResponseP.cellphone;
       }else{
           //Number is the correct length
           accountP.PersonMobilePhone = clientDetailsResponseP.cellphone;
       }
       
       if(clientDetailsResponseP.workTelCode != '' && clientDetailsResponseP.workTelephone != ''){
           accountP.Phone = clientDetailsResponseP.workTelCode + clientDetailsResponseP.workTelephone;
       }
       if(clientDetailsResponseP.homeTelCode != '' && clientDetailsResponseP.homeTelephone != ''){
           accountP.PersonHomePhone = clientDetailsResponseP.homeTelCode + clientDetailsResponseP.homeTelephone;
       }
       
       //Address Mapping
       for(GetClientDetailsCIF_Resp_IB_v1.cls_addressEntry address : clientDetailsResponseP.addressEntry){
           if(address.addrType == '10'){
               //Residential Add - Physical - Shipping
               String addressLine2Shipping = address.addrLine2 != null && address.addrLine2 != '' ? '\n' + address.addrLine2 : '';
               accountP.ShippingStreet = address.addrLine1 + addressLine2Shipping;
               accountP.ShippingCity = address.addrTown;
               accountP.ShippingPostalCode = formatPostalCode(address.addrPostlCode);
           }
       }
       String addressLine2Billing = clientDetailsResponseP.postlAddrLine2 != null &&
           clientDetailsResponseP.postlAddrLine2 != ''
           ? '\n' + clientDetailsResponseP.postlAddrLine2
           : '';
       accountP.BillingStreet = clientDetailsResponseP.postlAddrLine1 + addressLine2Billing;
       accountP.BillingCity = clientDetailsResponseP.postlTown;
       accountP.BillingPostalCode = formatPostalCode(clientDetailsResponseP.postlCodeRsa);
       
       //Credit Marketing Consent & Indicators
       accountP.Credit_Marketing_Consent__pc = clientDetailsResponseP.creditIndicator; //Translation needed
       String creditMarketingIndicators = '';
       
       if(clientDetailsResponseP.creditTelephone == 'Y'){
           creditMarketingIndicators += 'Phone;';
       }
       if(clientDetailsResponseP.creditSms == 'Y'){
           creditMarketingIndicators +='SMS;';
       }
       if(clientDetailsResponseP.creditPost == 'Y'){
           creditMarketingIndicators +='Mail;';
       }
       if(clientDetailsResponseP.creditEmail == 'Y'){
           creditMarketingIndicators +='Email;';
       }
       if(clientDetailsResponseP.creditAvoice == 'Y'){
           creditMarketingIndicators +='Voice Recording;';//Voice Recording;
       }
       if(creditMarketingIndicators.contains(';')){
           accountP.Credit_Marketing_Indicator__pc = creditMarketingIndicators.substringBeforeLast(';');
       }
       
       //Non Credit Marketing Consent & Indicators
       accountP.Non_Credit_Marketing_Consent__pc = clientDetailsResponseP.nonCreditIndicator;  //Translation needed
       String nonCreditMarketingIndicators = '';
       
       if(clientDetailsResponseP.nonCreditTelephone == 'Y'){
           nonCreditMarketingIndicators += 'Phone;';
       }
       if(clientDetailsResponseP.nonCreditSms == 'Y'){
           nonCreditMarketingIndicators +='SMS;';
       }
       if(clientDetailsResponseP.nonCreditPost == 'Y'){
           nonCreditMarketingIndicators +='Mail;';
       }
       if(clientDetailsResponseP.nonCreditEmail == 'Y'){
           nonCreditMarketingIndicators +='Email;';
       }
       if(clientDetailsResponseP.nonCreditAvoice == 'Y'){
           nonCreditMarketingIndicators +='Call;';//Voice Recording;
       }
       if(nonCreditMarketingIndicators.contains(';')){
           accountP.Non_Credit_Marketing_Indicator__pc = nonCreditMarketingIndicators.substringBeforeLast(';');
       }
       //Additional Mappings
       if(clientDetailsResponseP.taxNumber != '0'){
           accountP.Income_Tax_Number__pc = clientDetailsResponseP.taxNumber;
       }
       return accountP;
   }
   
   private static Account mapAccountFieldsJntParticipant(Account accountP, GetJointParticipant_Resp_IB_v1.cls_JntEntry jntEntryResponseP){
       accountP.PersonTitle = jntEntryResponseP.titleCode; //Translation
       accountP.ID_Type__pc = jntEntryResponseP.idDocType; //Translation
       accountP.Occupation_Status__pc = jntEntryResponseP.occupationStatus; //Translation
       accountP.Occupation__pc = jntEntryResponseP.occupationCode; //Awaiting Feedback
       accountP.Occupation_Category__pc = jntEntryResponseP.occupationCode; //Awaiting Feedback
       accountP.Income_Source__pc = jntEntryResponseP.sourceOfIncome;  //Translation
       
       //Name Tags
       accountP.LastName = jntEntryResponseP.surname;
       accountP.FirstName = jntEntryResponseP.firstNames;
       //accountP.Person_Informal_Name__pc = jntEntryResponseP.firstNames; //Awaiting Feedback
       accountP.Initials__pc = jntEntryResponseP.initials;
       
       if(jntEntryResponseP.idDocType == 'Passport'){
           accountP.CountryPassport__pc = jntEntryResponseP.clientNationality;
           accountP.Passport_Number__pc = jntEntryResponseP.idNumber;
       }
       accountP.ID_Number__pc = jntEntryResponseP.idNumber;
       
       //accountP.ID_Number__pc = jntEntryResponseP.idNumber;
       //accountP.Risk_Rating__c = jntEntryResponseP.firstNames;   //Awaiting Feedback
       
       if(jntEntryResponseP.birthDate != null && jntEntryResponseP.birthDate.length() == 8){
           accountP.PersonBirthdate = Date.valueOf(
               jntEntryResponseP.birthDate.subString(0, 4) +
               '-' +
               jntEntryResponseP.birthDate.subString(4, 6) +
               '-' +
               jntEntryResponseP.birthDate.subString(6, 8)
           );
       }
       
       // Contact info Tags
       // The following Code is to cater for an issue with CIF
       // where the mobile phone can only be 10 digits long
       // This will eventually be removed
       if(jntEntryResponseP.cellphone.length() > 10){
           //Take last 10 Digits
           Integer numberLength = jntEntryResponseP.cellphone.length();
           accountP.PersonMobilePhone = jntEntryResponseP.cellphone.Substring(numberLength - 10, numberLength);
       }else if(jntEntryResponseP.cellphone.length() < 10){
           //Add 0 infront until number is 10 digits
           while(jntEntryResponseP.cellphone.length() < 10){
               jntEntryResponseP.cellphone = '0' + jntEntryResponseP.cellphone;
           }
           accountP.PersonMobilePhone = jntEntryResponseP.cellphone;
       }else{
           //Number is the correct length
           accountP.PersonMobilePhone = jntEntryResponseP.cellphone;
       }
       
       if(jntEntryResponseP.workTelCode != '' && jntEntryResponseP.workTelephone != ''){
           accountP.Phone = jntEntryResponseP.workTelCode + jntEntryResponseP.workTelephone;
       }
       if(jntEntryResponseP.homeTelCode != '' && jntEntryResponseP.homeTelephone != ''){
           accountP.PersonHomePhone = jntEntryResponseP.homeTelCode + jntEntryResponseP.homeTelephone;
       }
       
       String addressLine2Shipping = jntEntryResponseP.resAddrLine2 != null &&
           jntEntryResponseP.resAddrLine2 != ''
           ? '\n' + jntEntryResponseP.resAddrLine2
           : '';
       accountP.ShippingStreet = jntEntryResponseP.resAddrLine1 + addressLine2Shipping;
       accountP.ShippingCity = jntEntryResponseP.resTown;
       accountP.ShippingPostalCode = formatPostalCode(jntEntryResponseP.resPosCde);
       accountP.ShippingCountry = jntEntryResponseP.countryOfRes;  //Translation
       
       accountP.BillingStreet = jntEntryResponseP.resAddrLine1 + addressLine2Shipping;
       accountP.BillingCity = jntEntryResponseP.resTown;
       accountP.BillingPostalCode = formatPostalCode(jntEntryResponseP.resPosCde);
       accountP.BillingCountry = jntEntryResponseP.countryOfRes;   //Translation
       
       return accountP;
   }
   
   private static Account mapMDMAccountFieldsGetInvParty(
       Account accountP,
       RegSer_InvolvedParties_Resp_IB_v1 invPartyResponseP,
       String idTypeP,
       String identifierP
   ) {
       accountP.PersonTitle = invPartyResponseP.content.individual.salutation != null ? invPartyResponseP.content.individual.salutation.description : null;    //Translation
       
       if(idTypeP == 'SAID'){
           accountP.ID_Type__pc = 'SA Identity Document';
       }else if(idTypeP == 'Passport'){
           accountP.ID_Type__pc = 'Passport';
       }
       accountP.Occupation__pc = invPartyResponseP.content.individual.occupation;
       accountP.Occupation_Category__pc = invPartyResponseP.content.individual.occupation;
       accountP.Occupation_Status__pc = invPartyResponseP.content.individual.occupationStatus;
       
       accountP.Income_Source__pc = invPartyResponseP.content.sourcesOfIncome.size() > 0 ? invPartyResponseP.content.sourcesOfIncome[0].description : null;
       
       //Name Tags
       accountP.LastName = invPartyResponseP.content.individual.surname;
       accountP.FirstName = invPartyResponseP.content.individual.name;
       accountP.Person_Informal_Name__pc = invPartyResponseP.content.individual.knownAs;
       accountP.Initials__pc = invPartyResponseP.content.individual.initials;
       accountP.ID_Number__pc = identifierP;
       accountP.Risk_Rating__c = invPartyResponseP.content.riskRating;
       accountP.Marital_Status__pc = invPartyResponseP.content.individual.maritalStatus != null
           ? invPartyResponseP.content.individual.maritalStatus.description
           : null;
       accountP.Marital_Contract_Type__pc = invPartyResponseP.content.individual.maritalContractType != null
           ? invPartyResponseP.content.individual.maritalContractType.description
           : null;
       accountP.Gender__pc = invPartyResponseP.content.individual.gender != null ? invPartyResponseP.content.individual.gender.description : null;
       accountP.SUIN__c = invPartyResponseP.content.suin;
       for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : invPartyResponseP.content.identifications){
           if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
               accountP.CIF__c = identification.numbers;
           }
       }
       if(invPartyResponseP.content.individual.dateOfBirth != null){
           accountP.PersonBirthdate = Date.valueOf(invPartyResponseP.content.individual.dateOfBirth);
       }
       
       // Contact info Tags
       for(RegSer_InvolvedParties_Resp_IB_v1.cls_addresses_telephonicAddress telNumber : invPartyResponseP.content.addresses.telephonicAddress){
           if(telNumber.context != null){
               if(telNumber.context.description == 'MainCellPhone'){
                   // The following Code is to cater for an issue with CIF
                   // where the mobile phone can only be 10 digits long
                   // This will eventually be removed
                   String phoneNumber = telNumber.diallingCode + telNumber.numbers;
                   
                   if(phoneNumber.length() > 10){
                       //Take last 10 Digits
                       Integer numberLength = phoneNumber.length();
                       accountP.PersonMobilePhone = phoneNumber.Substring(numberLength - 10, numberLength);
                   }else if(phoneNumber.length() < 10){
                       //Add 0 infront until number is 10 digits
                       while(phoneNumber.length() < 10){
                           phoneNumber = '0' + phoneNumber;
                       }
                       accountP.PersonMobilePhone = phoneNumber;
                   }else{
                       //Number is the correct length
                       accountP.PersonMobilePhone = phoneNumber;
                   }
               }
               if(telNumber.context.description == 'MainWorkPhone'){
                   accountP.Phone = telNumber.diallingCode + telNumber.numbers;
               }
               if(telNumber.context.description == 'MainHomePhone'){
                   accountP.PersonHomePhone = telNumber.diallingCode + telNumber.numbers;
               }
           }
       }
       
       for(RegSer_InvolvedParties_Resp_IB_v1.cls_addresses_addresses address : invPartyResponseP.content.addresses.addresses){
           if(address.context != null){
               if(address.context.description == 'Residential'){
                   //Map Shipping
                   String addressLine2Shipping = address.addressName2 != null && address.addressName2 != '' ? '\n' + address.addressName2 : '';
                   accountP.ShippingStreet = address.addressName1 + addressLine2Shipping;
                   accountP.ShippingCity = address.cityName;
                   accountP.ShippingPostalCode = formatPostalCode(address.postalCode);
                   accountP.ShippingCountry = address.countryName;
               }else if(address.context.description == 'Postal'){
                   //Map Billing
                   String addressLine2Billing = address.addressName2 != null && address.addressName2 != '' ? '\n' + address.addressName2 : '';
                   accountP.BillingStreet = address.addressName1 + addressLine2Billing;
                   accountP.BillingCity = address.cityName;
                   accountP.BillingPostalCode = formatPostalCode(address.postalCode);
                   accountP.BillingCountry = address.countryName;
               }
           }
       }
       return accountP;
   }
   
   private static GetClientDetailsCIF_Resp_IB_v1 translateToInternalValues(GetClientDetailsCIF_Resp_IB_v1  clientDetailsResponseP){
       String personTitleTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Title',
           clientDetailsResponseP.titleCode,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String genderTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Gender',
           clientDetailsResponseP.gender,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Identity Type',
           clientDetailsResponseP.idDocType,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String maritalConTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Marital Contract Type',
           clientDetailsResponseP.mariageContrctType,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Marital Status',
           clientDetailsResponseP.maritalStatus,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String occStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Occupation Status',
           clientDetailsResponseP.occupationStatus,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Source of Income',
           clientDetailsResponseP.sourceOfIncome,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String monthlyIncomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Monthly Income',
           clientDetailsResponseP.incomeGroup,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String countryOfRegTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Country',
           clientDetailsResponseP.countryOfOrigin,
           StringConstants.INBOUND_RECORD_TYPE
       ); //aka: Country Of Origin
       String languageTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Language',
           clientDetailsResponseP.language,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Country',
           clientDetailsResponseP.countryOfBirth,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.ECASA_STRING,
           'Nationality',
           clientDetailsResponseP.clientNationality,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String homeLangTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Language',
           clientDetailsResponseP.homeLanguage,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String crIndTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Credit Marketing Consent',
           clientDetailsResponseP.creditIndicator,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String nonCrIndTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Non-Credit Marketing Consent',
           clientDetailsResponseP.nonCreditIndicator,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String occupationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Occupation Category',
           clientDetailsResponseP.occupationCode,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String prefComMethTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Preferred Communication Method',
           clientDetailsResponseP.prefrdCommtionMthd,
           StringConstants.INBOUND_RECORD_TYPE
       );
       
      String clientGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Client Type Group',
           clientDetailsResponseP.clientGroup,
           StringConstants.INBOUND_RECORD_TYPE
);
       //System.debug('personTitleTranslated: ' + personTitleTranslated);
       //System.debug('genderTranslated: ' + genderTranslated);
       //System.debug('idTypeTranslated: ' + idTypeTranslated);
       /*System.debug('maritalConTypeTranslated: ' + maritalConTypeTranslated);
       System.debug('maritalStatusTranslated: ' + maritalStatusTranslated);
       System.debug('occStatusTranslated: ' + occStatusTranslated);
       System.debug('incomeSourceTranslated: ' + incomeSourceTranslated);
       System.debug('monthlyIncomeTranslated: ' + monthlyIncomeTranslated);
       System.debug('countryOfRegTranslated: ' + countryOfRegTranslated);
       System.debug('languageTranslated: ' + languageTranslated);
       System.debug('countryOfBirthTranslated: ' + countryOfBirthTranslated);
       System.debug('nationalityTranslated: ' + nationalityTranslated);
       System.debug('homeLangTranslated: ' + homeLangTranslated);
       System.debug('crIndTranslated: ' + crIndTranslated);
       System.debug('nonCrIndTranslated: ' + nonCrIndTranslated);
       System.debug('occupationTranslated: ' + occupationTranslated);
       System.debug('prefComMethTranslated: ' + prefComMethTranslated);*/
       
       clientDetailsResponseP.titleCode = personTitleTranslated;
       clientDetailsResponseP.gender = genderTranslated;
       clientDetailsResponseP.idDocType = idTypeTranslated;
       clientDetailsResponseP.mariageContrctType = maritalConTypeTranslated;
       clientDetailsResponseP.maritalStatus = maritalStatusTranslated;
       clientDetailsResponseP.occupationStatus = occStatusTranslated;
       clientDetailsResponseP.sourceOfIncome = incomeSourceTranslated;
       clientDetailsResponseP.incomeGroup = monthlyIncomeTranslated;
       clientDetailsResponseP.countryOfOrigin = countryOfRegTranslated;
       clientDetailsResponseP.language = languageTranslated;
       clientDetailsResponseP.countryOfBirth = countryOfBirthTranslated;
       clientDetailsResponseP.clientNationality = nationalityTranslated;
       clientDetailsResponseP.homeLanguage = homeLangTranslated;
       clientDetailsResponseP.creditIndicator = crIndTranslated;
       clientDetailsResponseP.nonCreditIndicator = nonCrIndTranslated;
       clientDetailsResponseP.occupationCode = occupationTranslated;
       clientDetailsResponseP.prefrdCommtionMthd = prefComMethTranslated;
       clientDetailsResponseP.clientGroup = clientGroupTranslated;

       return clientDetailsResponseP;
   }
   
   private static GetJointParticipant_Resp_IB_v1.cls_JntEntry translateToInternalValues(GetJointParticipant_Resp_IB_v1.cls_JntEntry  jntEntryResponseP){
       String personTitleTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Title',
           jntEntryResponseP.titleCode,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Identity Type',
           jntEntryResponseP.idDocType,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String occStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Occupation Status',
           jntEntryResponseP.occupationStatus,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String occupationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Occupation Category',
           jntEntryResponseP.occupationCode,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Source of Income',
           jntEntryResponseP.sourceOfIncome,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.CIF_STRING,
           'Country',
           jntEntryResponseP.countryOfRes,
           StringConstants.INBOUND_RECORD_TYPE
       );
       String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
           StringConstants.ECASA_STRING,
           'Nationality',
           jntEntryResponseP.clientNationality,
           StringConstants.INBOUND_RECORD_TYPE
       );
       
       /*System.debug('personTitleTranslated: ' + personTitleTranslated);
       System.debug('idTypeTranslated: ' + idTypeTranslated);
       System.debug('occStatusTranslated: ' + occStatusTranslated);
       System.debug('occupationTranslated: ' + occupationTranslated);
       System.debug('incomeSourceTranslated: ' + incomeSourceTranslated);
       System.debug('countryOfResTranslated: ' + countryOfResTranslated);
       System.debug('nationalityTranslated: ' + nationalityTranslated);*/
       
       jntEntryResponseP.titleCode = personTitleTranslated;
       jntEntryResponseP.idDocType = idTypeTranslated;
       jntEntryResponseP.occupationStatus = occStatusTranslated;
       jntEntryResponseP.occupationCode = occupationTranslated;
       jntEntryResponseP.sourceOfIncome = incomeSourceTranslated;
       jntEntryResponseP.countryOfRes = countryOfResTranslated;
       jntEntryResponseP.clientNationality = nationalityTranslated;
       
       return jntEntryResponseP;
   }
   
                /**
* @description GIPResponse
* @author  Sandile Mathe
* @return caseid
*
*/
   public class GIPResponse {
       public String response;
       public Id accountId;
   }
   
   private static GetJointParticipant_Resp_IB_v1.cls_JntEntry tempConcatinateTitleAndLanguage(GetJointParticipant_Resp_IB_v1.cls_JntEntry  jntEntryResponseP){
       jntEntryResponseP.titleCode = jntEntryResponseP.titleCode + 'E';
       
       return jntEntryResponseP;
   }
   
   private static GetClientDetailsCIF_Resp_IB_v1 tempConcatinateTitleAndLanguage(GetClientDetailsCIF_Resp_IB_v1  clientDetailsResponseP){
       if(clientDetailsResponseP.language != null && String.isNotBlank(clientDetailsResponseP.language)){
           clientDetailsResponseP.titleCode = clientDetailsResponseP.titleCode + clientDetailsResponseP.language;
       }else{
           clientDetailsResponseP.titleCode = clientDetailsResponseP.titleCode + 'E';
       }
       return clientDetailsResponseP;
   }
   
   private static String formatPostalCode(String postalCodeP){
       while(postalCodeP.length() < 4){
           postalCodeP = '0' + postalCodeP;
       }
       return postalCodeP;
   }
   
   private static List<Address__c> mapCIFAddressTypes(Account mainAccount, GetClientDetailsCIF_Resp_IB_v1 clientDetailsResponseBean){
       List<Address__c> addressList = new List<Address__c>();
       
       Address__c tempAddress = new Address__c();
       for(GetClientDetailsCIF_Resp_IB_v1.cls_addressEntry eachAddressEntry : clientDetailsResponseBean.addressEntry){
           if(eachAddressEntry.addrType != null && eachAddressEntry.addrType != '0') {
               String addressTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                   StringConstants.CIF_STRING,
                   'Address Type',
                   eachAddressEntry.addrType,
                   StringConstants.INBOUND_RECORD_TYPE
               );
               tempAddress = new Address__c();
               tempAddress.Address_Type__c = addressTypeTranslated;
               tempAddress.Shipping_Street__c = eachAddressEntry.addrLine1;
               tempAddress.Shipping_Suburb__c = eachAddressEntry.addrSuburbRsa;
               tempAddress.Shipping_City__c = eachAddressEntry.addrTown;
               tempAddress.Shipping_Zip_Postal_Code__c = eachAddressEntry.addrPostlCode;
               tempAddress.Account__c = mainAccount.id;
               addressList.add(tempAddress);
           } 
       }
       
       //TdB - Postal Address
       if(clientDetailsResponseBean.postlAddrLine1 != null && clientDetailsResponseBean.postlAddrLine1 != '') {
           tempAddress = new Address__c();
           tempAddress.Address_Type__c = StringConstants.POSTAL_STRING;
           tempAddress.Shipping_Street__c = clientDetailsResponseBean.postlAddrLine1;
           tempAddress.Shipping_Suburb__c = clientDetailsResponseBean.postlSuburb;
           tempAddress.Shipping_City__c = clientDetailsResponseBean.postlTown;
           tempAddress.Shipping_Zip_Postal_Code__c = clientDetailsResponseBean.postlCodeRsa;
           tempAddress.Account__c = mainAccount.id;
           addressList.add(tempAddress);
       }
       
       //TdB - Registered Address
       if(clientDetailsResponseBean.regAddrLine1 != null && clientDetailsResponseBean.regAddrLine1 != '') {
           tempAddress = new Address__c();
           tempAddress.Address_Type__c = StringConstants.REGISTERED_ADDR_STRING;
           tempAddress.Shipping_Street__c = clientDetailsResponseBean.regAddrLine1;
           tempAddress.Shipping_Suburb__c = clientDetailsResponseBean.regSuburb;
           tempAddress.Shipping_City__c = clientDetailsResponseBean.regTown;
           tempAddress.Shipping_Zip_Postal_Code__c = clientDetailsResponseBean.regCodeRsa;
           tempAddress.Account__c = mainAccount.id;
           addressList.add(tempAddress);
       }
       
       //TdB - Head Office Address
       if(clientDetailsResponseBean.hoAddrLine1 != null && clientDetailsResponseBean.hoAddrLine1 != '') {
           tempAddress = new Address__c();
           tempAddress.Address_Type__c = StringConstants.HEAD_OFFICE_ADDR_STRING;
           tempAddress.Shipping_Street__c = clientDetailsResponseBean.hoAddrLine1;
           tempAddress.Shipping_Suburb__c = clientDetailsResponseBean.hoSuburb;
           tempAddress.Shipping_City__c = clientDetailsResponseBean.hoTown;
           tempAddress.Shipping_Zip_Postal_Code__c = clientDetailsResponseBean.hoCodeRsa;
           tempAddress.Account__c = mainAccount.id;
           addressList.add(tempAddress);
       }
       return addressList;
   }
   
    //TdB - TEMP use diffrent mappings due to RBB and Wills diffrent requirements
                 /**
* @description createParticipantsMDM
* @param cifKeyP
* @param accountNumP
* @param siteCodeP
* @author  TdB
* @return caseid
*
*/
   public static GIPResponse createRBBAccountFromCIF(String cifKeyP, String accountNumP, String siteCodeP){
       
       List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
       GIPResponse methodResponse = new GIPResponse();
       Boolean isNewClient = false;
       
       try{
           //Call get Client Details
           Map<GetClientDetailsCIF_Resp_IB_v1,Sys_Log_Integration__c> clientDetailsResponseMap = GetClientDetailsCIF_IH_v1.getClientDetailsMap(cifKeyP, accountNumP, siteCodeP);
           //Get the log
           clientDetailsResponseMap.values()[0].Method_Name__c = '1. ' + clientDetailsResponseMap.values()[0].Method_Name__c;
           logList.add(clientDetailsResponseMap.values()[0]);
           List<GetClientDetailsCIF_Resp_IB_v1> clientDetailsList = new List<GetClientDetailsCIF_Resp_IB_v1>(clientDetailsResponseMap.keySet());
           //Assign the Bean
           GetClientDetailsCIF_Resp_IB_v1 clientDetailsResponseBean = clientDetailsList[0];
           
           if(clientDetailsResponseBean.statusCode == 200 && clientDetailsResponseBean.indCifRecFound == 'Y'){
               
               //Query to check if account exists otherwise create new account
               List<Account> cifAccountList = new AccountsSelector().selectByCIF(clientDetailsResponseBean.clientCode, 1);

               Account mainAccount;
               if(cifAccountList.size() == 1){
                   mainAccount = cifAccountList[0];
                   isNewClient = false;
               }else{
                   mainAccount = new Account();
                   isNewClient = true;
               }
               
               //Mappings accross all entity types
               if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                   mainAccount.Client_Since_Date__c = Date.valueOf(clientDetailsResponseBean.dateClientOpened.subString(0,4) + '-' + clientDetailsResponseBean.dateClientOpened.subString(4,6) + '-' + clientDetailsResponseBean.dateClientOpened.subString(6,8));
               }
               mainAccount.CIF__c = clientDetailsResponseBean.clientCode;
               mainAccount.Sub_Classification_Code__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Sub Classification Code', clientDetailsResponseBean.subClassCde, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Preferred_Communication_Method__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', clientDetailsResponseBean.prefrdCommtionMthd, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Financial_Year_End__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Financial Year End', clientDetailsResponseBean.companyYearEnd, StringConstants.INBOUND_RECORD_TYPE);
                   
                   if(clientDetailsResponseBean.thirdPartyInd == 'Y') {
                       mainAccount.Credit_Worthiness_Consent__c = true;
                   }
                   
                   if(clientDetailsResponseBean.nonCreditEmail == 'Y') {
                       mainAccount.Is_Marketing_Consent_Email__c = true;
                   }
                   
                   if(clientDetailsResponseBean.nonCreditSms == 'Y') {
                       mainAccount.Is_Marketing_Consent_SMS__c = true;
                   }
                   
                   if(clientDetailsResponseBean.nonCreditTelephone == 'Y') {
                       mainAccount.Is_Marketing_Consent_Phone__c = true;
                   }
                   
                   if(clientDetailsResponseBean.nonCreditPost == 'Y') {
                       mainAccount.Is_Marketing_Consent_Post__c = true;
                   }
                   
                   if(clientDetailsResponseBean.nonCreditAvoice == 'Y') {
                       mainAccount.Is_Marketing_Consent_voice_rec__c = true;
                   }
                   
                   if(clientDetailsResponseBean.cpaThreshold == 'Y') {
                       mainAccount.Does_the_Client_fall_under_the_CPA__c = true;
                   }
                   
                   if(clientDetailsResponseBean.ncaThreshold == 'Y') {
                       mainAccount.Does_the_Client_fall_under_the_NCA__c = true;
                   }
                   
                   mainAccount.Standard_Industry_SIC_Code__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', clientDetailsResponseBean.siccCode5, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Standard_Industry_SIC_Category__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Category',clientDetailsResponseBean.siccCode5, StringConstants.INBOUND_RECORD_TYPE);
                   
                   
                   Integer counterTemp = 0;
                   for(GetClientDetailsCIF_Resp_IB_v1.cls_clsPercEntry cifAgriClass : clientDetailsResponseBean.clsPercEntry){
                       if(cifAgriClass.classification != null) {
                           counterTemp = counterTemp + 1;
                           String classificationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'SIC Classification', cifAgriClass.classification, StringConstants.INBOUND_RECORD_TYPE);
                           Decimal percentageVal = Decimal.valueOf(cifAgriClass.percentage);
                           if(counterTemp == 1) {
                               mainAccount.SIC_Classification_1__c = classificationTranslated;
                               mainAccount.SIC_Classification_1_Percentage__c = percentageVal;
                           } else if (counterTemp == 2) {
                               mainAccount.SIC_Classification_2__c = classificationTranslated;
                               mainAccount.SIC_Classification_2_Percentage__c = percentageVal;
                           } else if (counterTemp == 3) {
                               mainAccount.SIC_Classification_3__c = classificationTranslated;
                               mainAccount.SIC_Classification_3_Percentage__c = percentageVal;
                               break;
                           }
                       } 
                   }
                                       
                   String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Identity Type', clientDetailsResponseBean.idDocType, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.ID_Type__c = idTypeTranslated;
                   
                   String clientGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Client Type Group', clientDetailsResponseBean.clientGroup, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Client_Group__c = clientGroupTranslated;
                   
                   String ccountryOfOriginTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Country',clientDetailsResponseBean.countryOfOrigin, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Country_of_Registration__c = ccountryOfOriginTranslated;
                   
                   String countryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Country', clientDetailsResponseBean.countryIncorp, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Country_of_Incorporation__c = countryOfIncorporationTranslated;
                   
                   String countryOfOperation;
                   for(GetClientDetailsCIF_Resp_IB_v1.cls_countryEntOprtData cifcountryEntOprtData : clientDetailsResponseBean.countryEntOprtData){
                       String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Country',cifcountryEntOprtData.countryEntOprt, StringConstants.INBOUND_RECORD_TYPE);
                       if(countryOfOperationTranslated != null && countryOfOperationTranslated != '') {
                           if(countryOfOperation == null) {
                               countryOfOperation = countryOfOperationTranslated;
                           } else {
                               countryOfOperation = countryOfOperation + ';' + countryOfOperationTranslated;
                           }
                       }
                   }
                   if(countryOfOperation != null) {
                       mainAccount.Country_of_Operation__c = countryOfOperation;
                   }

                   if(clientDetailsResponseBean.dateIdentified != null && clientDetailsResponseBean.dateIdentified.length() == 8){
                       //mainAccount.Date_Identified__c = Date.newInstance(Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(0,4)) , Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(4,6)), Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(6,8)));
                       //updated the date format as we are getting the date in 16072021 format
                       mainAccount.Date_Identified__c = Date.newInstance(Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(4,8)) , Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(2,4)), Integer.valueOf(clientDetailsResponseBean.dateIdentified.subString(0,2)));
                   }
                   
                   if(clientDetailsResponseBean.dateVerified != null && clientDetailsResponseBean.dateVerified.length() == 8){
                       //mainAccount.Date_Verified__c = Date.newInstance(Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(0,4)),Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(4,6)), Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(6,8)));
                       //updated the date format as we are getting the date in 16072021 format
                       mainAccount.Date_Verified__c = Date.newInstance(Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(4,8)),Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(2,4)), Integer.valueOf(clientDetailsResponseBean.dateVerified.subString(0,2)));
                   }
                   
                   mainAccount.Identified_by_Employee_Number__c = clientDetailsResponseBean.employeeIdentified;
                   mainAccount.Verified_by_Employee_Number__c = clientDetailsResponseBean.employeeVerified;
                   mainAccount.Language__c = clientDetailsResponseBean.language;
                   
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       mainAccount.Date_Established__c = Date.newInstance(Integer.valueOf(clientDetailsResponseBean.dateClientOpened.subString(0,4)), Integer.valueOf(clientDetailsResponseBean.dateClientOpened.subString(4,6)) , Integer.valueOf(clientDetailsResponseBean.dateClientOpened.subString(6,8)));
                   }
                   
                   if(clientDetailsResponseBean.taxNumber != null && clientDetailsResponseBean.taxNumber != '' && clientDetailsResponseBean.taxNumber != '0') {
                       mainAccount.Income_Tax_Number__c = clientDetailsResponseBean.taxNumber;
                   }
                   
                   if(clientDetailsResponseBean.vatRegistrationNo != null && clientDetailsResponseBean.vatRegistrationNo != '' && clientDetailsResponseBean.vatRegistrationNo != 'Y' && clientDetailsResponseBean.vatRegistrationNo != 'N') {
                       mainAccount.VAT_Registration_Number__c = Decimal.ValueOf(clientDetailsResponseBean.vatRegistrationNo);
                   }

                   String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, clientDetailsResponseBean.sourceOfIncome, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Source_of_Income__c = srcOfincomeTranslated;
                   
                   if(clientDetailsResponseBean.affectedPerson != null && clientDetailsResponseBean.affectedPerson != '0') {
                       String affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Affected Person', clientDetailsResponseBean.affectedPerson, StringConstants.INBOUND_RECORD_TYPE);
                       mainAccount.Q4b_How_is_the_Client_Affected__c = affectedPersonTranslated;
                   }

                   if(clientDetailsResponseBean.exconExpiryDate != null && clientDetailsResponseBean.exconExpiryDate.length() == 8){
                       mainAccount.Q4c_Exchange_Control_Expiry_date__c = Date.newInstance(Integer.valueOf(clientDetailsResponseBean.exconExpiryDate.subString(0,4)) , Integer.valueOf(clientDetailsResponseBean.exconExpiryDate.subString(4,6)) , Integer.valueOf(clientDetailsResponseBean.exconExpiryDate.subString(6,8)));
                   }
                   
                   for(GetClientDetailsCIF_Resp_IB_v1.cls_foreignTaxData cifForeignTax : clientDetailsResponseBean.foreignTaxData){
                       if(cifForeignTax.foreignTaxNo != null && cifForeignTax.foreignTaxNo != '' && cifForeignTax.foreignTaxNo != '0') {
                           mainAccount.Foreign_Tax_Number__c = Decimal.ValueOf(cifForeignTax.foreignTaxNo);
                           String foreignTaxCtryTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Country', cifForeignTax.foreignTaxCtry, StringConstants.INBOUND_RECORD_TYPE);
                           mainAccount.Country_of_Foreign_tax__c = foreignTaxCtryTranslated;
                           break;
                       } 
                   }

               
               //INDIVIDUAL
               if(clientDetailsResponseBean.clientGroup == 'I'){
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub

                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   //Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   //Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Individual';
                   //Map Account Fields
                   mainAccount = mapCifAccountFieldsGetClientDetails(mainAccount, clientDetailsResponseBean);
                   
                   upsert mainAccount;
                   
                   if(isNewClient == true){
                       //TdB - Additional Address mappings for Onboarding
                       List<Address__c> addressLst = mapCIFAddressTypes(mainAccount, clientDetailsResponseBean);
   
                       if(addressLst != null && addressLst.size() > 0) {
                           insert addressLst;
                       }
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
                   
               }
               
               //JOINT AND SEVERAL
               else if(clientDetailsResponseBean.clientGroup == 'J'){
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub
                   
                   //by Madhava for customer hub
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       
                       mainAccount.Client_Since_Date__c = Date.valueOf(clientDetailsResponseBean.dateClientOpened.subString(0,4) + '-' + clientDetailsResponseBean.dateClientOpened.subString(4,6) + '-' + clientDetailsResponseBean.dateClientOpened.subString(6,8));
                   }
                   
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   //Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   //Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Joint & Several';
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   Map<GIPResponse, List<Sys_log_Integration__c>> participantResponseMap = createParticipantsCIF(mainAccount, siteCodeP);
                   
                   logList.addAll(participantResponseMap.values()[0]);
                   
                   List<GIPResponse> GIPResponseList = new List<GIPResponse>(participantResponseMap.keySet());
                   //Assign the Bean
                   methodResponse = GIPResponseList[0];
                   //Get Joint Participants
                   
               }
               
               //SOLE TRADER
               else if(clientDetailsResponseBean.clientGroup == 'S'){
                 mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub

                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   //Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   //Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                   //Map Account Fields
                   mainAccount = mapCifAccountFieldsGetClientDetails(mainAccount, clientDetailsResponseBean);

                   mainAccount.Client_Type__c = 'Sole Trader';
                   mainAccount.Client_Group__c = 'SOLE TRADER CLIENT';
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   
                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   if(isNewClient == true){
                       //TdB - Additional Address mappings for Onboarding
                       List<Address__c> addressLst = mapCIFAddressTypes(mainAccount, clientDetailsResponseBean);
   
                       if(addressLst != null && addressLst.size() > 0) {
                           insert addressLst;
                       }
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
                   
               }
               
               //NON INDIVIDUAL
               else if(clientDetailsResponseBean.clientGroup == 'N'){
                   mainAccount.SBU_Segment__c = clientDetailsResponseBean.sbuSegment; // added for customer hub
                   //by madhava for customerhub
                   if(clientDetailsResponseBean.dateClientOpened != null && clientDetailsResponseBean.dateClientOpened.length() == 8){
                       
                       mainAccount.Client_Since_Date__c = Date.valueOf(clientDetailsResponseBean.dateClientOpened.subString(0,4) + '-' + clientDetailsResponseBean.dateClientOpened.subString(4,6) + '-' + clientDetailsResponseBean.dateClientOpened.subString(6,8));
                   }

                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   // Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   // Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   
                   String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Client Type', clientDetailsResponseBean.clientType, StringConstants.INBOUND_RECORD_TYPE);
                   mainAccount.Client_Type__c = clientTypeTranslated;

                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   //TdB - Additional mappings for Onboarding
                   mainAccount.Registration_Number__c = clientDetailsResponseBean.idNumber;
                   mainAccount.Trust_Number__c = clientDetailsResponseBean.practiceNumber;
                   

                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   if(isNewClient == true){
                       //TdB - Additional Address mappings for Onboarding
                       List<Address__c> addressLst = mapCIFAddressTypes(mainAccount, clientDetailsResponseBean);
   
                       if(addressLst != null && addressLst.size() > 0) {
                           insert addressLst;
                       }
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
                   
               }
               
               //ESTATE LATE
               else if(clientDetailsResponseBean.clientGroup == 'E'){
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   // Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   // Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Estate Late';
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   if(isNewClient == true){
                       //TdB - Additional Address mappings for Onboarding
                       List<Address__c> addressLst = mapCIFAddressTypes(mainAccount, clientDetailsResponseBean);
   
                       if(addressLst != null && addressLst.size() > 0) {
                           insert addressLst;
                       }
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
               }
               
               //PARTNERSHIP
               else if(clientDetailsResponseBean.clientGroup == 'P'){
                   clientDetailsResponseBean =  tempConcatinateTitleAndLanguage(clientDetailsResponseBean);
                   // Translate to SF Values
                   clientDetailsResponseBean = translateToInternalValues(clientDetailsResponseBean);
                   // Account Mapping
                   mainAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                   mainAccount.Client_Type__c = 'Partnership';
                   mainAccount.Country_of_Registration__c = clientDetailsResponseBean.countryOfOrigin;
                   mainAccount.Name = clientDetailsResponseBean.surname;
                   
                   // UPSERT MAIN ACCOUNT
                   upsert mainAccount;
                   
                   if(isNewClient == true){
                       //TdB - Additional Address mappings for Onboarding
                       List<Address__c> addressLst = mapCIFAddressTypes(mainAccount, clientDetailsResponseBean);
   
                       if(addressLst != null && addressLst.size() > 0) {
                           insert addressLst;
                       }
                   }
                   
                   methodResponse.response = 'Success';
                   methodResponse.accountId = mainAccount.Id;
                   
               }else{
                   //Invalid clientGroup none found
                   methodResponse.response = 'Client Group \'' + clientDetailsResponseBean.clientGroup + '\' is not a valid value in Salesforce.';
                   //System.debug(methodResponse.response);
               }
           }else{
               //Error on getClientDetailsCIF
               methodResponse.response = clientDetailsResponseBean.message != null && clientDetailsResponseBean.message != '' ? clientDetailsResponseBean.message : 'Client not found on CIF';
               //System.debug(methodResponse.response);
           }
       }catch(Exception e){
           //Exception response bean and log
           String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
           logList.add(SystemLogger.createInternalIntegrationLog('AccountCreate_CIF_MDM.createAccountFromCIF', 'Create Account Salesforce From CIF', 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
           methodResponse.response = message;
           //System.debug(message);
       }
       if(logList.size() > 0){
           insert logList;
       }
       //System.debug('Create Account From CIF final Response: ' + methodResponse);
       return methodResponse;
   }
}