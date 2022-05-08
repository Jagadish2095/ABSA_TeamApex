/*
* MerchantManagement class for creating a Merchant Account, Link the Account to a Merchant Plan and Link the Plan to POSH
* @author Danie Booysen
* @created 2020-05-22
*/
public with sharing class MerchantManagement implements Queueable, Database.AllowsCallouts{

    private final String oppRecordId; //D Booysen: 20200701: Private variable for usage by the execute method of the queueable interface

    //D Booysen: 20200701: Constructor for class
    // @param Id of the inbound Opportunity from the 'ApplicationTrigger'
    public MerchantManagement(Id inboundOppId){
        this.oppRecordId = inboundOppId;
    }

    //D Booysen: 20200701: The execute method for the queueable interface
    //Method called from the 'TriggerHandlerApplication' which initiated from the 'ApplicationTrigger' when the QA Status on the Application record is updated to Approved
    public void execute(QueueableContext context){
        try{
            createMASSAccount(oppRecordId);
        }Catch(Exception ex){
            String exceptionMessage = 'Exception: ' + ex.getMessage() + '. StackTrace: ' + ex.getStackTraceString();
            Sys_Log_Integration__c exceptionLog = SystemLogger.createInternalIntegrationLog('MerchantManagement.execute', 'CAMS', 500, 'Internal Server Error', exceptionMessage);

            // D Booysen: 20200802
            // Had to use DML to insert the exception log because there is a DML operation in createMASSAccount and using the
            // SystemLogger.insertLog callout method fails because of this DML - Callout limitation.
            // SystemLogger.insertLog(exceptionLog);

            insert exceptionLog;
        }
    }

    // PJAIN: 20200610: Method to get applicationId & applicationProductMerchantId
    @AuraEnabled
    public static Map<String, String> getIdsMap(String opportunityId) {

        Map<String, String> responseMap = new Map<String, String>();

        List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityOnboardId(opportunityId);
        if(applicationList != null && applicationList.size() > 0){
            responseMap.put('applicationId', applicationList[0].Id);
        }
        List<Application_Product_Merchant__c> applicationProductMerchantList = new ApplicationProductMerchantsSelector().selectIdsByOpportunityId(opportunityId);
        if(applicationProductMerchantList != null && applicationProductMerchantList.size() > 0){
            responseMap.put('applicationProductMerchantId', applicationProductMerchantList[0].Id);
        }
        return responseMap;
    }

    //Method handling the CAMS services callout and DML operations
    @AuraEnabled
    public static void createMASSAccount(Id opportunityId){

        //Declare variables
        String merchantId;
        Opportunity oppRecord;
        OpportunityLineItem oppProdRecord;
        Application__c appRecord;
        Application_Product_Merchant__c appProdMerchantRecord;
        Address__c addressRecord;
        AccountContactRelation accContactRelationRecord;
        User userRecord;
        Merchant_Id__c merchantIdRecord;
        Boolean isSendChatterNotification;
        String errorDetails;

        //Query the Opportunity
        List<Opportunity> oppList = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
        if (oppList == null || oppList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: oppList is null or empty');
        }
        oppRecord = oppList[0];
        //Query the Opportunity Product (OpportunityLineItem) related to the Opportunity
        List<OpportunityLineItem> oppProdList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(oppRecord.Id, 1);
        if (oppProdList == null || oppProdList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: oppProdList is null or empty');
        }
        oppProdRecord = oppProdList[0];
        //Query the Application related to the Opportunity
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityOnboardId(oppRecord.Id);
        if (appList == null || appList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: appList is null or empty');
        }
        appRecord = appList[0];
        //Query the Account related to the Opportunity
        Account account = new AccountsSelector().selectByOpportunityId(oppRecord.Id);
        if (account == null) {
            throw new MerchantManagementException('createMASSAccount error: Account is null or empty');
        }
        //Query the Application Product - Merchant related to the Opportunity
        List<Application_Product_Merchant__c> appProdMerchantList = new ApplicationProductMerchantsSelector().selectByOpportunityId(oppRecord.Id);
        if (appProdMerchantList == null || appProdMerchantList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: appProdMerchantList is null or empty');
        }
        appProdMerchantRecord = appProdMerchantList[0];
        //Query the Payment Plan related to the Application
        List<Payment_Plan__c> paymentPlanList = new PaymentPlansSelector().selectByTypeByApplicationId(appRecord.Id, 'Merchant Product', 2);
        if (paymentPlanList == null || paymentPlanList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: paymentPlanList for Banking Details is null or empty');
        }
        Map<String, Payment_Plan__c> ppBankingDetailsMap = new Map<String, Payment_Plan__c>();
        for(Payment_Plan__c pp : paymentPlanList){
            ppBankingDetailsMap.put(pp.Type_of_Details__c, pp);
        }
        //Query the Address related to the Trading Address on the Application
        List<Address__c> addressList = new AddressesSelector().selectByAddressId(appRecord.Trading_Address__c);
        if (addressList == null || addressList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: addressList is null or empty');
        }
        addressRecord = addressList[0];
        List<AccountContactRelation> accContactRelationList;
        //Assign the Contact Person Id
        Id contactPersonId = oppProdRecord.Contact_Person__c;
        if (String.isNotBlank(contactPersonId)) {
            //Get the object type that the contactPersonId is related to
            String sObjName = contactPersonId.getSObjectType().getDescribe().getName();
            //Query the Account Contact Relationship only when the contactPersonId is of type AccountContactRelation to get the contact information.
            //If the object is an Account (PersonAccount) the account which is already queried would be used for the contact information,
            //which means there is no need to query the Account Contact Relationship
            if(sObjName == 'AccountContactRelation'){
                //Query the Contact_Person__c AccountContactRelation related to the Application Product - Merchant
                accContactRelationList = new AccountContactRelationSelector().selectRelationById(contactPersonId);
                if (accContactRelationList == null || accContactRelationList.size() == 0) {
                    throw new MerchantManagementException('createMASSAccount error: accContactRelationList and personAccount is null or empty. There is no contact related to the Contact Person');
                }
                accContactRelationRecord = accContactRelationList[0];
            }
        }
        //Query the Device - Merchant records related to the Application Product - Merchant
        List<Device_Merchant__c> deviceMerchantList = new DevicesMerchantSelector().selectByAppProdMerchId(appProdMerchantRecord.Id);
        if (deviceMerchantList == null || deviceMerchantList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: deviceMerchantList is null or empty');
        }
        //Query the User/Banker
        List<User> userList = new UsersSelector().selectById(new Set<Id>{UserInfo.getUserId()});
        if (userList == null || userList.size() == 0) {
            throw new MerchantManagementException('createMASSAccount error: userList is null or empty');
        }
        userRecord = userList[0];
        //Assign the Opportunity Id to the referenceNumber
        String referenceNumber = oppRecord.Id;

        //Get the quote builder data, to get the     price scheme entry data, to get the existing value (Minimum Service Fee) for the Product
        String jsonString = MerchantQuoteBuilderController.getQuoteBuilderData(oppRecord.Id);
        if (String.isBlank(jsonString) || jsonString == 'null') {
            throw new MerchantManagementException('createMASSAccount error: MerchantQuoteBuilderController jsonString is null or empty');
        }
        MerchantQuoteBuilderController.PricingBean priceBeanContent = (MerchantQuoteBuilderController.PricingBean)JSON.deserialize(jsonString, MerchantQuoteBuilderController.PricingBean.class);
        if (priceBeanContent == null) {
            throw new MerchantManagementException('createMASSAccount error: priceBeanContent is null');
        }
        MerchantQuoteBuilderController.PriceSchemeEntryData priceSchemeData = priceBeanContent.priceSchemeEntryMap.get('[MDF]:[All]');
        String minServiceFee = String.valueOf(priceSchemeData.existingValue);

        // If the previous Status_MASS_Account__c is blank, then set isSendChatterNotification.
        if (String.isBlank(appProdMerchantRecord.Status_MASS_Account__c)) {
            isSendChatterNotification = true;
        } else {
            isSendChatterNotification = false;
        }
        if(appProdMerchantRecord.Status_MASS_Account__c != StringConstants.INTEGRATION_STATUS_SUCCESS){
            //map the request bean fields
            MPScreateMASSAccountV2_Req_IB_v1 createMASSAccRequestBean;
            if(accContactRelationRecord != null){
                createMASSAccRequestBean = mapCreateMASSAccountRequestFields(account, userRecord, appRecord, oppRecord, appProdMerchantRecord, ppBankingDetailsMap.get('Business Bank'), addressRecord, accContactRelationRecord, minServiceFee);
            }else{
                createMASSAccRequestBean = mapCreateMASSAccountRequestFields(account, userRecord, appRecord, oppRecord, appProdMerchantRecord, ppBankingDetailsMap.get('Business Bank'), addressRecord, null, minServiceFee);
            }
            //Call MPScreateMASSAccount service and handle response
            MPScreateMASSAccountV2_Resp_IB_v1 createMASSAccResponseBean = MPScreateMASSAccountV2_IH_v1.MPScreateMASSAccountV2(createMASSAccRequestBean);

            if(createMASSAccResponseBean.statusCode >= 200 && createMASSAccResponseBean.statusCode < 300){
                if(createMASSAccResponseBean.MPScreateMASSAccountV2Response.Zbp004o.result.contains('SUCCESS') || createMASSAccResponseBean.MPScreateMASSAccountV2Response.Zbp004o.result.contains('00000')){
                    //Successful response
                    appProdMerchantRecord.Status_MASS_Account__c = StringConstants.INTEGRATION_STATUS_SUCCESS;
                    appProdMerchantRecord.Status_Message_MASS_Account__c = createMASSAccResponseBean.MPScreateMASSAccountV2Response.Zbp004o.result;

                    //Assign merchantId and referenceNumber from response to a variables for passing to other methods
                    merchantId = createMASSAccResponseBean.MPScreateMASSAccountV2Response.Zbp004o.mrchAcctNbr;

                    //Create Merchant_Id__c record
                    merchantIdRecord = new Merchant_Id__c();
                    merchantIdRecord.Merchant_Id__c = merchantId;
                    merchantIdRecord.Merchant_Class__c = oppProdRecord.Merchant_Class__c;
                }else {
                    //Failed response
                    appProdMerchantRecord.Status_MASS_Account__c = StringConstants.INTEGRATION_STATUS_FAILED;
                    appProdMerchantRecord.Status_Message_MASS_Account__c = createMASSAccResponseBean.MPScreateMASSAccountV2Response.Zbp004o.result;
                }
            }else{
                //Failed response
                appProdMerchantRecord.Status_MASS_Account__c = StringConstants.INTEGRATION_STATUS_FAILED;
                appProdMerchantRecord.Status_Message_MASS_Account__c = Sys_Utilities_General.truncateFieldIfNeeded(createMASSAccResponseBean.message, 10000);
            }
        }else{
            merchantId = appRecord.Merchant_Id_Ref__r.Merchant_Id__c;
        }
        if (String.isNotBlank(merchantId)) {
            if(appProdMerchantRecord.Status_Merchant_Plan__c != StringConstants.INTEGRATION_STATUS_SUCCESS){
                //Call Merchant Plan Service
                MpsCreateMerchantPlanv1_Req_IB_v1 createMerchantPlanRequestBean = mapMerchantPlanRequestFields(priceBeanContent, appProdMerchantRecord, referenceNumber, merchantId);
                MpsCreateMerchantPlanv1_Resp_IB_v1 createMerchantPlanResponseBean = MpsCreateMerchantPlanv1_IH_v1.MpsCreateMerchantPlanv1(createMerchantPlanRequestBean);

                if(createMerchantPlanResponseBean.statusCode >= 200 && createMerchantPlanResponseBean.statusCode < 300){
                    if(createMerchantPlanResponseBean.MPScreateMerchantPlanV1Response.Zbp005o.result.contains('SUCCESS') || createMerchantPlanResponseBean.MPScreateMerchantPlanV1Response.Zbp005o.result.contains('00000')){
                        //Successful response
                        appProdMerchantRecord.Status_Merchant_Plan__c = StringConstants.INTEGRATION_STATUS_SUCCESS;
                        appProdMerchantRecord.Status_Message_Merchant_Plan__c = createMerchantPlanResponseBean.MPScreateMerchantPlanV1Response.Zbp005o.result;
                    }else {
                        //Failed response
                        appProdMerchantRecord.Status_Merchant_Plan__c = StringConstants.INTEGRATION_STATUS_FAILED;
                        appProdMerchantRecord.Status_Message_Merchant_Plan__c = createMerchantPlanResponseBean.MPScreateMerchantPlanV1Response.Zbp005o.result;
                    }
                }else{
                    //Failed response
                    appProdMerchantRecord.Status_Merchant_Plan__c = StringConstants.INTEGRATION_STATUS_FAILED;
                    appProdMerchantRecord.Status_Message_Merchant_Plan__c = Sys_Utilities_General.truncateFieldIfNeeded(createMerchantPlanResponseBean.message, 10000);
                }
            }
            // PJAIN: 20200721: Commented for Story W-005302
            /* if(appProdMerchantRecord.Status_POSH_Merchant__c != StringConstants.INTEGRATION_STATUS_SUCCESS){
                //Call Merchant POSH Service
                MpsCreatePoshMerchantv3_Req_IB_v1 createPOSHMerchantRequestBean = mapPOSHRequestFields(appProdMerchantRecord, oppProdRecord, account, deviceMerchantList, priceBeanContent, merchantId, referenceNumber, 'C', 'Y');
                MpsCreatePoshMerchantv3_Resp_IB_v1 createPOSHMerchantResponseBean = MpsCreatePoshMerchantv3_IH_v1.MpsCreatePoshMerchantv3(createPOSHMerchantRequestBean);

                if(createPOSHMerchantResponseBean.statusCode >= 200 && createPOSHMerchantResponseBean.statusCode < 300){
                    if(createPOSHMerchantResponseBean.MPScreatePOSHMerchantV3Response.Zbp006o.result.contains('SUCCESS') || createPOSHMerchantResponseBean.MPScreatePOSHMerchantV3Response.Zbp006o.result.contains('00000')){
                        //Successful response
                        appProdMerchantRecord.Status_POSH_Merchant__c = StringConstants.INTEGRATION_STATUS_SUCCESS;
                        appProdMerchantRecord.Status_Message_POSH_Merchant__c = createPOSHMerchantResponseBean.MPScreatePOSHMerchantV3Response.Zbp006o.result;

                    }else {
                        //Failed response
                        appProdMerchantRecord.Status_POSH_Merchant__c = StringConstants.INTEGRATION_STATUS_FAILED;
                        appProdMerchantRecord.Status_Message_POSH_Merchant__c = createPOSHMerchantResponseBean.MPScreatePOSHMerchantV3Response.Zbp006o.result;
                    }
                }else{
                    //Failed response
                    appProdMerchantRecord.Status_POSH_Merchant__c = StringConstants.INTEGRATION_STATUS_FAILED;
                    appProdMerchantRecord.Status_Message_POSH_Merchant__c = Sys_Utilities_General.truncateFieldIfNeeded(createPOSHMerchantResponseBean.message, 10000);
                }
            } */
        }

        //Update Application Product Merchant & OpportunityLineItem Dynamically using the metadata read path
        //deserialize the bean into an Untyped Object. Which allows us to use a get method
        String jsonStr = JSON.serialize(priceBeanContent);
        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);

        for(Field_Visibility_Per_Product__mdt mtdRecord : priceBeanContent.fieldVisibilityMdtList){
            if(mtdRecord.Additional_Attributes__c != null){
                //Get AdditionalAttributes for this mdt record
                MerchantQuoteBuilderController.AdditionalAttributes addAttributes = (MerchantQuoteBuilderController.AdditionalAttributes)JSON.deserialize(mtdRecord.Additional_Attributes__c, MerchantQuoteBuilderController.AdditionalAttributes.class);
                //Check which object to assign the value to
                if(mtdRecord.Object_Name__c == 'Application_Product_Merchant__c' && addAttributes.fieldAPIName != null){
                        //If we have a key they we get the value from the map
                        if(addAttributes.priceSchemeEntryMapKey != null){
                            MerchantQuoteBuilderController.PriceSchemeEntryData entryData = priceBeanContent.priceSchemeEntryMap.get(addAttributes.priceSchemeEntryMapKey);
                            if(entryData != null && entryData.updatedValue != null){
                                //Assigns the value to the Field on the Object by API NAme
                                appProdMerchantRecord.put(addAttributes.fieldAPIName, entryData.updatedValue);
                            }
                        }else{
                            if(untypedMap.get(addAttributes.valueReadPath) != null){
                                //Assigns the value to the Field on the Object by API NAme
                                appProdMerchantRecord.put(addAttributes.fieldAPIName, untypedMap.get(addAttributes.valueReadPath));
                            }
                        }
                }else if(mtdRecord.Object_Name__c == 'OpportunityLineItem' && addAttributes.fieldAPIName != null){
                    //If we have a key they we get the value from the map
                    if(addAttributes.priceSchemeEntryMapKey != null){
                        MerchantQuoteBuilderController.PriceSchemeEntryData entryData = priceBeanContent.priceSchemeEntryMap.get(addAttributes.priceSchemeEntryMapKey);
                        if(entryData != null && entryData.updatedValue != null){
                            //Assigns the value to the Field on the Object by API NAme
                            oppProdList[0].put(addAttributes.fieldAPIName, entryData.updatedValue);
                        }
                    }else{
                        if(untypedMap.get(addAttributes.valueReadPath) != null){
                            //Assigns the value to the Field on the Object by API NAme
                            oppProdList[0].put(addAttributes.fieldAPIName, untypedMap.get(addAttributes.valueReadPath));
                        }
                    }
                }
            }
        }
        update appProdMerchantRecord;
        update oppProdList;

        System.debug('After Update JASON: ' + merchantIdRecord);

        if (merchantIdRecord != null) {
            //Insert Merchant Id
            insert merchantIdRecord;
            //Link to the Merchant_Id__c(merchantIdRecord) record and update the Application
            appRecord.Merchant_Id_Ref__c = merchantIdRecord.Id;
            //Update Related Application
            update appRecord;
        }
        if (isSendChatterNotification) {
            errorDetails = '';
            if(appProdMerchantRecord.Status_MASS_Account__c == StringConstants.INTEGRATION_STATUS_FAILED){
                errorDetails += 'API service: MASS Merchant. Status: Failed. Error message: ' + appProdMerchantRecord.Status_Message_MASS_Account__c + '.\n';
            }
            if(appProdMerchantRecord.Status_Merchant_Plan__c == StringConstants.INTEGRATION_STATUS_FAILED){
                errorDetails += 'API service: Merchant Plan. Status: Failed. Error message: ' + appProdMerchantRecord.Status_Message_Merchant_Plan__c + '.\n';
            }
            if(appProdMerchantRecord.Status_POSH_Merchant__c == StringConstants.INTEGRATION_STATUS_FAILED){
                errorDetails += 'API service: POSH Merchant. Status: Failed. Error message: ' + appProdMerchantRecord.Status_Message_POSH_Merchant__c + '.\n';
            }
            if (String.isNotBlank(errorDetails)) {
                postChatterNotification(opportunityId, oppRecord.OwnerId, appRecord.QA_Status_Updated_By__c, errorDetails);
            }
        }
    }

    //Request mapping method for createMASSAccount
    //@param - accountP
    //@param - userP
    //@param - applicationP
    //@param - opportunityP
    //@param - appProdMerchP
    //@param - paymentPlanP
    //@param - addressP
    //@param - minServiceFeeP - Minimum Service Fee from the Quote builder for specified product
    //@return - MPScreateMASSAccountV2_Req_IB_v1
    public static MPScreateMASSAccountV2_Req_IB_v1 mapCreateMASSAccountRequestFields(Account accountP, User userP, Application__c applicationP, Opportunity opportunityP, Application_Product_Merchant__c appProdMerchP, Payment_Plan__c paymentPlanP, Address__c addressP, AccountContactRelation accContactRelationP, String minServiceFeeP) {

        String accountNumber = String.isNotBlank(paymentPlanP.Account_Number__c) ? paymentPlanP.Account_Number__c.left(23) : null;
        String branchCode = String.valueOf(paymentPlanP.Branch_Code__c);
        branchCode = String.isNotBlank(branchCode) ? branchCode.left(9) : null;
        String initials;
        String contactName;
        String contactPhone;
        if(accContactRelationP == null){
            contactPhone = accountP.PersonMobilePhone;
            initials = accountP.FirstName != null ? accountP.FirstName.left(1) : '';
            initials += accountP.MiddleName != null ? accountP.MiddleName.left(1) : '';
            contactName = initials + ' ' + accountP.LastName;
        }else{
            contactPhone = accContactRelationP.Contact.MobilePhone;
            initials = accContactRelationP.Contact.FirstName != null ? accContactRelationP.Contact.FirstName.left(1) : '';
            initials += accContactRelationP.Contact.MiddleName != null ? accContactRelationP.Contact.MiddleName.left(1) : '';
            contactName = initials + ' ' + accContactRelationP.Contact.LastName;
        }
        //Translations
        String translatedAssociationCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Association Code', appProdMerchP.Association_Code__c, 'Outbound');
        String translatedMerchRelationType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Merchant Relation Type', appProdMerchP.Merchant_Relationship_Type__c, 'Outbound');
        String translatedOfficerCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Officer Code', appProdMerchP.Officer_Code__c, 'Outbound');

        MPScreateMASSAccountV2_Req_IB_v1 requestBean = new MPScreateMASSAccountV2_Req_IB_v1();
        requestBean.MPScreateMASSAccountV2 = new MPScreateMASSAccountV2_Req_IB_v1.MPScreateMASSAccountV2();
        requestBean.MPScreateMASSAccountV2.nbsapdpi = new MPScreateMASSAccountV2_Req_IB_v1.Nbsapdpi();
        requestBean.MPScreateMASSAccountV2.zbp004i = new MPScreateMASSAccountV2_Req_IB_v1.Zbp004i();

        requestBean.MPScreateMASSAccountV2.nbsapdpi.channel = StringConstants.SALESFORCE_STRING;
        requestBean.MPScreateMASSAccountV2.nbsapdpi.application = StringConstants.SALESFORCE_STRING;
        requestBean.MPScreateMASSAccountV2.nbsapdpi.trace = 'N';

        requestBean.MPScreateMASSAccountV2.zbp004i.clientCode = String.isNotBlank(accountP.CIF__c) ? accountP.CIF__c.left(10) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.tellerNo = String.isNotBlank(userP.BRID__c) ? userP.BRID__c.right(7) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.casaRefNum = String.isNotBlank(opportunityP.CASA_Reference_Number__c) ? opportunityP.CASA_Reference_Number__c.left(9) : null;

        //Map Source of Funds Savings Multiselect Picklist W-004861 JQUEV
        if(applicationP.Source_of_Funds_Savings__c != null){
            List<String> sourceOfFundsList = applicationP.Source_of_Funds_Savings__c.split(';');
            for(Integer i = 0; i < sourceOfFundsList.size(); i++){
                System.debug('Source of Funds Internal Value: ' + sourceOfFundsList[i]);
                String value = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Source of Income', sourceOfFundsList[i], 'Outbound');
                System.debug('Source of Funds Translated Value: ' + value);
                switch on i {
                    when 0 {
                        requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds1 = value;
                    }
                    when 1 {
                        requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds2 = value;
                    }
                    when 2 {
                        requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds3 = value;
                    }
                    when 3 {
                        requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds4 = value;
                    }
                    when 4 {
                        requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds5 = value;
                    }
                 }
            }
        }

        requestBean.MPScreateMASSAccountV2.zbp004i.refNum = String.valueOf(opportunityP.Id).left(18);
        requestBean.MPScreateMASSAccountV2.zbp004i.action = 'C';//hard coded value
        requestBean.MPScreateMASSAccountV2.zbp004i.prinBk = 'ABSA';//hard coded value
        requestBean.MPScreateMASSAccountV2.zbp004i.assocBk = translatedAssociationCode;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchRelTyp = translatedMerchRelationType;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchDescNm = String.isNotBlank(accountP.Name) ? accountP.Name.left(25) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchDescCty = String.isNotBlank(addressP.Shipping_City__c) ? addressP.Shipping_City__c.left(13) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.contactNm = String.isNotBlank(contactName) ? contactName.left(25) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.contactPhNbr = contactPhone;
        requestBean.MPScreateMASSAccountV2.zbp004i.ddaAcctNbr = accountNumber;
        requestBean.MPScreateMASSAccountV2.zbp004i.ddaTrNbr = fillUpFieldLength(branchCode, 10);
        requestBean.MPScreateMASSAccountV2.zbp004i.costCtr = fillUpFieldLength(appProdMerchP.Cost_Centre__c, 10);
        requestBean.MPScreateMASSAccountV2.zbp004i.off = translatedOfficerCode;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchCatgCd = appProdMerchP.MCC__c.substringBefore(' -');
        requestBean.MPScreateMASSAccountV2.zbp004i.mailCd = 'EML';//hard coded
        requestBean.MPScreateMASSAccountV2.zbp004i.lang = 'E';//hard coded
        requestBean.MPScreateMASSAccountV2.zbp004i.ichgZipCode = addressP.Shipping_Zip_Postal_Code__c;
        requestBean.MPScreateMASSAccountV2.zbp004i.nettSettInd = appProdMerchP.Nett_Settlement__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.markoffInd = 'N';//hard coded'
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchId2 = '0';//N/A - Not catered for on the UI yet
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchId3 = '0';//N/A - Not catered for on the UI yet
        requestBean.MPScreateMASSAccountV2.zbp004i.feesDda = accountNumber;
        requestBean.MPScreateMASSAccountV2.zbp004i.brchFee = branchCode;
        requestBean.MPScreateMASSAccountV2.zbp004i.adjustmentDda = accountNumber;
        requestBean.MPScreateMASSAccountV2.zbp004i.brchAdj = branchCode;
        requestBean.MPScreateMASSAccountV2.zbp004i.chargebackDda = accountNumber;
        requestBean.MPScreateMASSAccountV2.zbp004i.brchCgb = branchCode;
        requestBean.MPScreateMASSAccountV2.zbp004i.siteCd = fillUpFieldLength(appProdMerchP.Site_Code__c, 6);
        requestBean.MPScreateMASSAccountV2.zbp004i.stationFeeCd = 'TF1';//hard coded
        requestBean.MPScreateMASSAccountV2.zbp004i.stationWaiveInd = appProdMerchP.Waive_Stationery_Fee__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.rtcInd = appProdMerchP.RTC_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.lvpInd = appProdMerchP.LVP_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.dccInd = appProdMerchP.DCC_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.cbInd = appProdMerchP.Cash_Back_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.singleCr = appProdMerchP.Single_Credit_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.cmbInd = appProdMerchP.CMB_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.csInd = appProdMerchP.Selected_Cards__c.contains('Cash Send') ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.tzpInd = appProdMerchP.TZP_Indicator__c ? 'Y' : 'N';
        requestBean.MPScreateMASSAccountV2.zbp004i.grossBPerc = '0';//N/A - has to have a value
        requestBean.MPScreateMASSAccountV2.zbp004i.fraudReview = 'COPH';//hard coded
        requestBean.MPScreateMASSAccountV2.zbp004i.minDisc = minServiceFeeP.substringBefore('.');
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr1 = String.isNotBlank(addressP.Shipping_Street__c) ? addressP.Shipping_Street__c.left(30) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr2 = String.isNotBlank(addressP.Shipping_Suburb__c) ? addressP.Shipping_Suburb__c.left(30) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr3 = String.isNotBlank(addressP.Shipping_City__c) ? addressP.Shipping_City__c.left(30) : null;
        requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr4 = String.isNotBlank(addressP.Shipping_State_Province__c) ? addressP.Shipping_State_Province__c.left(30) : null;

        //EMokgopanyane changes made for story W-004863 : 20201005
        OpportunityLineItemsSelector oppProdSelector = new OpportunityLineItemsSelector();
        List<OpportunityLineItem> oppProdList = oppProdSelector.selectParentLineItemsByOpportunityId(opportunityP.Id, 1);

        if(oppProdList[0].Product2.Name == StringConstants.MERCHANT_PRODUCT_NAME_E_COMMERCE) {
            requestBean.MPScreateMASSAccountV2.zbp004i.cspId = appProdMerchP.CSP__c;
        } else {
            requestBean.MPScreateMASSAccountV2.zbp004i.cspId = '0';//N/A - Out of scope for simplex
        }
        //EMokgopanyane end changes for story W-004863 : 20201005

        return requestBean;
    }

    // Method that adds '0' to the beginning of the string(fieldNameP) until field is the length of the fieldLengthP
    // @param fieldNameP - String
    // @param fieldLengthP - Integer
    // @returns a String filled up to specified field length
    public static String fillUpFieldLength(String fieldNameP, Integer fieldLengthP){
        if(fieldNameP != null){
            fieldNameP = fieldNameP.leftPad(fieldLengthP, '0');
        }
        return fieldNameP;
    }

    // Method that Maps the Objects and Strings to a MpsCreateMerchantPlanv1_Req_IB_v1 request bean
    // @param pricingBean - MerchantQuoteBuilderController.PricingBean
    // @param applicationProductMerchant - Application_Product_Merchant__c
    // @param opportunityId
    // @param merchantId
    // @return MpsCreateMerchantPlanv1_Req_IB_v1
    public static MpsCreateMerchantPlanv1_Req_IB_v1 mapMerchantPlanRequestFields (MerchantQuoteBuilderController.PricingBean pricingBean, Application_Product_Merchant__c applicationProductMerchant, Id opportunityId, String merchantId) {
        MpsCreateMerchantPlanv1_Req_IB_v1 requestBean;
        String selectedCards = applicationProductMerchant.Selected_Cards__c;

        if (String.isBlank(selectedCards)) {
            throw new MerchantManagementException('mapMerchantPlanRequestFields error: selectedCards is blank');
        }

        Set<String> selectedCardsSet = new Set<String>(selectedCards.split(';'));
        List<Accepted_Card__c> acceptedCardList = new AcceptedCardsSelector().selectByName(selectedCardsSet, StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD);
        acceptedCardList.addAll(new AcceptedCardsSelector().selectByType(StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_FEE_CATEGORY));

        if (acceptedCardList == null || acceptedCardList.size() < 1) {
            throw new MerchantManagementException('mapMerchantPlanRequestFields error: acceptedCardList is null or empty');
        }

        requestBean = createMerchantPlanRequestBean(opportunityId, merchantId);

        Set<String> processedPlanTypes = new Set<String>();

        for (Accepted_Card__c acceptedCard : acceptedCardList) {

            // Add processed Plan Types to processedPlanTypes set.
            // This is prevent processing the same Plan Type twice.
            if (processedPlanTypes.contains(acceptedCard.Plan_Type__c)) {
                continue;
            } else {
                processedPlanTypes.add(acceptedCard.Plan_Type__c);
            }

            MpsCreateMerchantPlanv1_Req_IB_v1.PlanTable newPlanTable = new MpsCreateMerchantPlanv1_Req_IB_v1.PlanTable();
            newPlanTable.plnType = acceptedCard.Plan_Type__c;
            newPlanTable.allowDiscCr = 'N';

            if (acceptedCard.Name == StringConstants.MERCHANT_AMERICAN_EXPRESS_CARD) {
                newPlanTable.amexMrchNbrNum = applicationProductMerchant.AMEX_Merchant_Number__c;
            }

            String mapKey = String.format(StringConstants.MERCHANT_PRICE_SCHEME_ENTRY_MAP_KEY_TEMPLATE, new List<String> {acceptedCard.Transaction_Group__r.Name, 'All'});
            MerchantQuoteBuilderController.PriceSchemeEntryData priceSchemeEntryData = pricingBean.priceSchemeEntryMap.get(mapKey);

            if (priceSchemeEntryData != null) {
                newPlanTable.onusPct = String.valueOf(priceSchemeEntryData.existingValue);
                newPlanTable.notOnusPct = String.valueOf(priceSchemeEntryData.existingValue);
            } else if (acceptedCard.Price_Override__c != null) {
                newPlanTable.onusPct = String.valueOf(acceptedCard.Price_Override__c);
                newPlanTable.notOnusPct = String.valueOf(acceptedCard.Price_Override__c);
            } else {
                throw new MerchantManagementException('mapMerchantPlanRequestFields error: Percent value cannot be found using Transaction Group or Price Override for acceptedCard: ' + acceptedCard);
            }

            requestBean.MpsCreateMerchantPlanv1.zbp005i.planTable.add(newPlanTable);
        }
        return requestBean;
    }

    // Method that Maps the Objects and Strings to a MpsCreateMerchantPlanv1_Req_IB_v1 request bean
    // @param opportunityId
    // @param merchantId
    // @return partial MpsCreateMerchantPlanv1_Req_IB_v1
    private static MpsCreateMerchantPlanv1_Req_IB_v1 createMerchantPlanRequestBean (Id opportunityId, String merchantId) {
        MpsCreateMerchantPlanv1_Req_IB_v1 requestBean = new MpsCreateMerchantPlanv1_Req_IB_v1();
        requestBean.MpsCreateMerchantPlanv1 = new MpsCreateMerchantPlanv1_Req_IB_v1.MpsCreateMerchantPlanv1();
        requestBean.MpsCreateMerchantPlanv1.nbsapdpi = new MpsCreateMerchantPlanv1_Req_IB_v1.Nbsapdpi();
        requestBean.MpsCreateMerchantPlanv1.zbp005i = new MpsCreateMerchantPlanv1_Req_IB_v1.Zbp005i();
        requestBean.MpsCreateMerchantPlanv1.zbp005i.planTable = new List<MpsCreateMerchantPlanv1_Req_IB_v1.PlanTable>();

        requestBean.MpsCreateMerchantPlanv1.nbsapdpi.channel = StringConstants.SALESFORCE_STRING;
        requestBean.MpsCreateMerchantPlanv1.nbsapdpi.application = StringConstants.SALESFORCE_STRING;
        requestBean.MpsCreateMerchantPlanv1.nbsapdpi.trace = 'N';

        requestBean.MpsCreateMerchantPlanv1.zbp005i.mrchAcctNbr = merchantId;
        requestBean.MpsCreateMerchantPlanv1.zbp005i.refNum = opportunityId;
        requestBean.MpsCreateMerchantPlanv1.zbp005i.action = 'C';

        return requestBean;
    }

    // Method that Maps the Objects and Strings to a MpsCreatePoshMerchantv3_Req_IB_v1 request bean
    // @param appProdMerchP - Application_Product_Merchant__c record
    // @param oppLineItemP - OpportunityLineItem record, used to get Product2.Name
    // @param accountP - Account record
    // @param deviceP - Device_Merchant__c record
    // @param mrchAcctNbrP - Merchant ID
    // @param refNumP - Reference Number (Opportunity ID)
    // @param actionP - 'C'
    // @param postilionIndP - 'Y'

    //PJAIN: 20200721: Commented for Story W-005302
    /* public static MpsCreatePoshMerchantv3_Req_IB_v1 mapPOSHRequestFields(Application_Product_Merchant__c appProdMerchP, OpportunityLineItem oppLineItemP, Account accountP, List<Device_Merchant__c> deviceListP, MerchantQuoteBuilderController.PricingBean pricingBeanP, String mrchAcctNbrP, String refNumP, String actionP, String postilionIndP) {

        MpsCreatePoshMerchantv3_Req_IB_v1 requestBean = new MpsCreatePoshMerchantv3_Req_IB_v1();
        requestBean.MpsCreatePoshMerchantv3 = new MpsCreatePoshMerchantv3_Req_IB_v1.MpsCreatePoshMerchantv3();
        requestBean.MpsCreatePoshMerchantv3.nbsapdpi = new MpsCreatePoshMerchantv3_Req_IB_v1.Nbsapdpi();
        requestBean.MpsCreatePoshMerchantv3.zbp006i = new MpsCreatePoshMerchantv3_Req_IB_v1.Zbp006i();
        requestBean.MpsCreatePoshMerchantv3.zbp006i.deviceTable = new List<MpsCreatePoshMerchantv3_Req_IB_v1.DeviceTable>();

        requestBean.MpsCreatePoshMerchantv3.nbsapdpi.channel = StringConstants.SALESFORCE_STRING;
        requestBean.MpsCreatePoshMerchantv3.nbsapdpi.application = StringConstants.SALESFORCE_STRING;
        requestBean.MpsCreatePoshMerchantv3.nbsapdpi.trace = 'N';

        requestBean.MpsCreatePoshMerchantv3.zbp006i.mrchAcctNbr = mrchAcctNbrP; // '1037746'
        requestBean.MpsCreatePoshMerchantv3.zbp006i.refNum = refNumP;   // 'GN20202010378'
        requestBean.MpsCreatePoshMerchantv3.zbp006i.action = actionP;// 'C'
        requestBean.MpsCreatePoshMerchantv3.zbp006i.groupId = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Group ID', appProdMerchP.Group_ID__c, StringConstants.OUTBOUND_RECORD_TYPE);
        requestBean.MpsCreatePoshMerchantv3.zbp006i.shortMrchName = accountP.Name.left(12);
        requestBean.MpsCreatePoshMerchantv3.zbp006i.config = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Configuration', appProdMerchP.Configuration__c, StringConstants.OUTBOUND_RECORD_TYPE);
        requestBean.MpsCreatePoshMerchantv3.zbp006i.mrchClass = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Merchant Class', oppLineItemP.Merchant_Class__c , StringConstants.OUTBOUND_RECORD_TYPE);
        requestBean.MpsCreatePoshMerchantv3.zbp006i.floorLimit = '0001';
        requestBean.MpsCreatePoshMerchantv3.zbp006i.supvCardInd = 'N';
        requestBean.MpsCreatePoshMerchantv3.zbp006i.cvRetMode = '0';
        requestBean.MpsCreatePoshMerchantv3.zbp006i.monitorFlag = appProdMerchP.Deposit_Monitoring__c ? 'Y' : 'N';
        requestBean.MpsCreatePoshMerchantv3.zbp006i.monitorDays = appProdMerchP.Number_of_Days__c.substringBefore(' days');
        requestBean.MpsCreatePoshMerchantv3.zbp006i.postilionInd = postilionIndP; //'Y'
        requestBean.MpsCreatePoshMerchantv3.zbp006i.branchId = appProdMerchP.Site_Code__c;

        String mapKey;
        if(oppLineItemP.Product2.Name.contains('SmartPay')){
            mapKey = '[SmartPay Terminal Rent]:[All]';
        }else if(oppLineItemP.Product2.Name.contains('Desktop')){
            mapKey = '[Desktop Terminal Rent]:[All]';
        } else {
            mapKey = '[Mobile Terminal Rent]:[All]';
        }
        Decimal price = pricingBeanP.priceSchemeEntryMap.get(mapKey).existingValue;
        String feeCodeInternalValue = '[' + oppLineItemP.Product2.Name + ']:[' + String.valueOf(price) + ']';
        System.debug('feeCodeInternalValue: ' + feeCodeInternalValue);
        for(Device_Merchant__c device : deviceListP){

            MpsCreatePoshMerchantv3_Req_IB_v1.DeviceTable newDeviceTable = new MpsCreatePoshMerchantv3_Req_IB_v1.DeviceTable();
            newDeviceTable.termBranchId = device.Branch_ID__c;
            String serialNumber = device.Serial_Number__c;
            while(serialNumber.length() > 6){
                serialNumber = serialNumber.substring(1);
            }
            String combiDeviceIdSerialNumber = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Device ID', oppLineItemP.Product2.Name, StringConstants.OUTBOUND_RECORD_TYPE) + serialNumber;
            newDeviceTable.deviceId = combiDeviceIdSerialNumber;
            newDeviceTable.feeCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CAMS_STRING, 'Fee Code', feeCodeInternalValue, StringConstants.OUTBOUND_RECORD_TYPE);
            newDeviceTable.dialTime = device.Dial_Time__c;
            requestBean.MpsCreatePoshMerchantv3.zbp006i.deviceTable.add(newDeviceTable);
        }

        return requestBean;
    } */

    // PJAIN: 20200610: Method to post chatter notification to owner & fulfillment officer in case of error
    public static void postChatterNotification(Id opportunityId, Id opportunityOwnerId, Id fulfillmentOfficerId, String errorDetails) {
        String messageBodyTemplate = ',\n\nOops! Something went wrong with the API service automation for Merchant Onboarding Opportunity ID: {0}\n\nDetails:\n{1}\n\nPlease click on the opportunity link to be redirected to the opportunity to manually review or retry: ';
        List<Object> messageBodyParameters = new List<Object> { opportunityId, errorDetails };
        String messageBody = String.format(messageBodyTemplate, messageBodyParameters);

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.MentionSegmentInput mentionSegmentInputOpportunityOwner = new ConnectApi.MentionSegmentInput();
        mentionSegmentInputOpportunityOwner.id = opportunityOwnerId;
        messageBodyInput.messageSegments.add(mentionSegmentInputOpportunityOwner);

        ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
        textSegmentInput1.text = ', ';
        messageBodyInput.messageSegments.add(textSegmentInput1);

        ConnectApi.MentionSegmentInput mentionSegmentInputFulfillmentOfficer = new ConnectApi.MentionSegmentInput();
        mentionSegmentInputFulfillmentOfficer.id = fulfillmentOfficerId;
        messageBodyInput.messageSegments.add(mentionSegmentInputFulfillmentOfficer);

        ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
        textSegmentInput2.text = messageBody;
        messageBodyInput.messageSegments.add(textSegmentInput2);
        ConnectApi.EntityLinkSegmentInput entityLinkSegmentInputOpportunity = new ConnectApi.EntityLinkSegmentInput();
        entityLinkSegmentInputOpportunity.entityId = opportunityId;
        messageBodyInput.messageSegments.add(entityLinkSegmentInputOpportunity);

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = opportunityId;

        // Do not execute the below line if running a test as it fails.
        if (!Test.isRunningTest()) {
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        }
    }

    //Custom Exception class for the createMASSAccount and related mapCreateMASSAccountRequestFields methods
    public class MerchantManagementException extends Exception {}
}