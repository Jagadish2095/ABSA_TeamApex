/**
 * @description       :
 * @author            : Tracy de Bruin
 * @last modified on  : 2021-11-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   2021-07-18   muvhuso.nekhubvi@absa.africa   Initial Version
 **/
public class DocumentManagementSelectionController{
    /**
     * @description Create Document Placeholders
     * @author Tracy de Bruin
     * @param primaryAccId
     * @param parentId
     **/
    public static void createDocumentPlaceholders(Id primaryAccId, Id parentId){
        //Get parent Object Type
        String objectName = parentId.getSObjectType().getDescribe().getName();

        //Get primary Account details
        Account primaryAccount = new AccountsSelector().selectById(primaryAccId);

        List<OnboardingUBOListViewController.ParentAccountWrapper> accountHierarchyWrapper = new List<OnboardingUBOListViewController.ParentAccountWrapper>();
        String accountHierarchy = primaryAccount.UBO_ParentAccountWrapper__c;
        if(accountHierarchy != null){
        	accountHierarchyWrapper = (List<OnboardingUBOListViewController.ParentAccountWrapper>)JSON.deserialize(accountHierarchy, List<OnboardingUBOListViewController.ParentAccountWrapper>.class );
        }
        //Check for existing documents/placeholders
        List<Document__c> primaryDocuments = new DocumentsSelector().selectDocumentsByOppId(parentId);
        Map<String, Document__c> existingDocuments = new Map<String, Document__c>();
        Map<String, Document__c> newDocumentsMap = new Map<String, Document__c>();
        Map<String, Document__c> existingDocumentsKeep = new Map<String, Document__c>();
        Map<String, Document__c> newAddressDocumentsMap = new Map<String, Document__c>();
        Map<String, Document__c> existingAddressDocuments = new Map<String, Document__c>();
        Map<String, Document__c> existingAddressDocumentsKeep = new Map<String, Document__c>();
        for (Document__c eachDoc : primaryDocuments){
            if (eachDoc.Contact__c != null && eachDoc.ECM_Type__c != 'Ent_ProofOfAddress'){
                existingDocuments.put('AccCon#' + eachDoc.Contact__c + '#' + eachDoc.ECM_Type__c, eachDoc);
            }

             else if (eachDoc.Account__c != null && eachDoc.ECM_Type__c != 'Ent_ProofOfAddress'){
                if (eachDoc.Account__c == primaryAccId){
                    existingDocuments.put('PrimaryClient#' + primaryAccId + '#' + eachDoc.ECM_Type__c, eachDoc);
                } else{
                    existingDocuments.put('AccAcc#' + eachDoc.Account__c + '#' + eachDoc.ECM_Type__c, eachDoc);
                }
            }

            if (eachDoc.ECM_Type__c == 'Ent_ProofOfAddress'){
                existingAddressDocuments.put(eachDoc.Account__c + '#' + eachDoc.ECM_Type__c, eachDoc);
            }
        }

        //Get Mandatory Documents
        Set<String> ecmTypes = new Set<String>();
        Map<String, List<String>> clientTypeMandatoryDocs = new Map<String, List<String>>();
        List<Mandatory_Doc__mdt> mandatoryClientDocs = new MandatoryDocumentSelector().getAllMandatoryDocuments();
        for (Mandatory_Doc__mdt eachMandatoryDoc : mandatoryClientDocs){
            if (!clientTypeMandatoryDocs.containsKey(eachMandatoryDoc.Entity_Type__c)){
                clientTypeMandatoryDocs.put(eachMandatoryDoc.Entity_Type__c, new List<String>{ eachMandatoryDoc.ECM_Type__c });
            } else{
                clientTypeMandatoryDocs.get(eachMandatoryDoc.Entity_Type__c).add(eachMandatoryDoc.ECM_Type__c);
            }
            ecmTypes.add(eachMandatoryDoc.ECM_Type__c);
        }

        //Get Document Templates based on Mandatory documents
        List<Document_Template__c> docTemplateList = new DocumentTemplateSelector().selectByECMType(ecmTypes, 'Opportunity Business Bank');
        Set<String> addressPlaceholdersToCreate = new Set<String>();
        Map<String, Document_Template__c> docTemplateMap = new Map<String, Document_Template__c>();
        for (Document_Template__c eachDocTemp : docTemplateList){
            docTemplateMap.put(eachDocTemp.ECM_Item_Type__c, eachDocTemp);
        }

        Map<Id, List<String>> entityDocuments = new Map<Id, List<String>>();

        //Use UBO field to determine document placeholders
        if(accountHierarchyWrapper != null && accountHierarchyWrapper.size() > 0) {
        for (OnboardingUBOListViewController.ParentAccountWrapper accWrapper : accountHierarchyWrapper){
            if (accWrapper.Accwrplist != null && accWrapper.Accwrplist.size() > 0){
                //Primary Entity Documents
                String uniqueKey = accWrapper.Type;
                if (!entityDocuments.containskey(accWrapper.recordId)){
                    if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                        entityDocuments.put(accWrapper.recordId, new List<String>(clientTypeMandatoryDocs.get(uniqueKey)));
                    }
                } else{
                    if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                        entityDocuments.get(accWrapper.recordId).addAll(clientTypeMandatoryDocs.get(uniqueKey));
                    }
                }
                //UBO Entities Section Documents
                if(accWrapper.Accwrplist != null && accWrapper.Accwrplist.size() > 0) {
                entityDocuments = getDocumentMap(primaryAccount, accWrapper.Accwrplist, entityDocuments, clientTypeMandatoryDocs);
            }
                    
        }
    } 
} else {
    //Primary Entity Documents
    String uniqueKey = primaryAccount.Client_Type__c;
    if (!entityDocuments.containskey(primaryAccount.Id)){
        if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
            entityDocuments.put(primaryAccount.Id, new List<String>(clientTypeMandatoryDocs.get(uniqueKey)));
        }
    } else{
        if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
            entityDocuments.get(primaryAccount.Id).addAll(clientTypeMandatoryDocs.get(uniqueKey));
        }
            }
        }

        //Related Parties Section Documents for AccountAccount Relationship
        List<FinServ__AccountAccountRelation__c> accAccRelList = new AccountAccountRelationSelector().selectByByRelatedPartySection(primaryAccId);
        for (FinServ__AccountAccountRelation__c eachAccAcc : accAccRelList){
            String uniqueKey = 'Related Party ' + eachAccAcc.FinServ__RelatedAccount__r.Client_Type__c;
            //Get Mandatory documents for entity
            List<String> entityMandatoryDocs = new List<String>();

            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                for (String eachEcmType : clientTypeMandatoryDocs.get(uniqueKey)){
                    if (eachEcmType == 'Ent_OwnershipStructure' && eachAccAcc.Shareholding_Percentage__c > 0){
                        if (!entityDocuments.containskey(eachAccAcc.FinServ__RelatedAccount__c)){
                            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                entityDocuments.put(eachAccAcc.FinServ__RelatedAccount__c, new List<String>{ eachEcmType });
                            }
                        }
                    } else if (eachEcmType == 'Ent_ProofOfAddress' && eachAccAcc.Shareholding_Percentage__c == 0){
                        if (!entityDocuments.containskey(eachAccAcc.FinServ__RelatedAccount__c)){
                            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                entityDocuments.put(eachAccAcc.FinServ__RelatedAccount__c, new List<String>{ eachEcmType });
                            }
                        } else{
                            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                entityDocuments.get(eachAccAcc.FinServ__RelatedAccount__c).add(eachEcmType);
                            }
                        }
                    } else if (eachEcmType != 'Ent_OwnershipStructure' && eachAccAcc.Shareholding_Percentage__c == 0){
                        if (!entityDocuments.containskey(eachAccAcc.FinServ__RelatedAccount__c)){
                            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                entityDocuments.put(eachAccAcc.FinServ__RelatedAccount__c, new List<String>{ eachEcmType });
                            }
                        } else if (eachEcmType == 'Ent_PublicDocument'){
                            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                entityDocuments.get(eachAccAcc.FinServ__RelatedAccount__c).add(eachEcmType);
                            }
                        }
                    }
                }
            }
        }

        //Related Parties Section Documents for AccountContact Relationship
        List<AccountContactRelation> accConRelList = new AccountContactRelationSelector().selectByRelatedPartySection(primaryAccId);
        for (AccountContactRelation eachAccCon : accConRelList){
            if (eachAccCon.Share_Percentage__c == 0){
                String uniqueKey = 'Related Party ' + eachAccCon.Contact.Account.Client_Type__c;
                //Get Mandatory documents for entity
                List<String> entityMandatoryDocs = new List<String>();
                String roles = eachAccCon.Roles;
                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                    for (String eachEcmType : clientTypeMandatoryDocs.get(uniqueKey)){
                        if (eachEcmType != 'Ent_ProofOfAddress'){
                            if (!entityDocuments.containskey(eachAccCon.ContactId)){
                                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                    entityDocuments.put(eachAccCon.ContactId, new List<String>{ eachEcmType });
                                }
                            }

                        } else if (eachEcmType == 'Ent_ProofOfAddress' && roles != null && roles.contains('Individual with Authority to Act')){
                            if (primaryAccount.Client_Type__c == 'Individual' || primaryAccount.Client_Type__c == 'Private Individual' || primaryAccount.Client_Type__c == 'Individual - Minor'){
                                if (!entityDocuments.containskey(eachAccCon.ContactId)){
                                    if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                        entityDocuments.put(eachAccCon.ContactId, new List<String>{ eachEcmType });
                                    }
                                }
                            }
                        }
                    }
                }

            }
        }

        //Loop over entityDocuments and check Id (Contact vs Account)
        Set<String> accIdSet = new Set<String>();
        Map<Id, Id> contactAccountId = new Map<Id, Id>();
        Set<Id> contactIds = new Set<Id>(entityDocuments.KeySet());
        List<Account> personAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(contactIds);
        for (Account eachClient : personAccounts){
            contactAccountId.put(eachClient.PersonContactId, eachClient.Id);
        }

        //Use entityDocuments to create the Document Placeholders
        Map<String, Document__c> accAccAddressPlacholders = new Map<String, Document__c>();
        List<Document__c> insertDocList = new List<Document__c>();
        List<Document__c> addressDocList = new List<Document__c>();
        List<Document__c> deleteDocList = new List<Document__c>();

        for (Id eachClient : entityDocuments.KeySet()){
            for (String eachDocType : entityDocuments.get(eachClient)){
                String objectTypeName = eachClient.getSObjectType().getDescribe().getName();
                Boolean addDocToList = true;
                Document_Template__c eachDocTemp = docTemplateMap.get(eachDocType);
               
                
                if (eachDocTemp != null){
                    Document__c eachDoc = new Document__c();
                    eachDoc.Name = eachDocTemp.ECM_Item_Type__c.left(75) + '.pdf';
                    eachDoc.ECM_Type__c = eachDocTemp.ECM_Item_Type__c;
                    eachDoc.Generate_Document__c = eachDocTemp.Generate_Document__c;
                 
                    //Check for existing Document before insert
                    String docUniqueKey = '';
                    if (eachClient == primaryAccId){
                        docUniqueKey = 'PrimaryClient#' + eachClient + '#' + eachDocTemp.ECM_Item_Type__c;
                    } else if (objectTypeName == 'Contact'){
                        docUniqueKey = 'AccCon#' + eachClient + '#' + eachDocTemp.ECM_Item_Type__c;
                    } else if (objectTypeName == 'Account'){
                        docUniqueKey = 'AccAcc#' + eachClient + '#' + eachDocTemp.ECM_Item_Type__c;
                    }

                    //Determine if key is a Account or Contact

                    if (objectTypeName == 'Contact'){
                        eachDoc.Account__c = contactAccountId.get(eachClient);
                        eachDoc.Contact__c = eachClient;
                    } else{
                        eachDoc.Account__c = eachClient;

                        //Check for multiple proof of address placeholders
                        if (eachDocType == 'Ent_ProofOfAddress'){
                            accAccAddressPlacholders.put(eachDoc.Account__c, eachDoc);
                            addDocToList = false;
                        }
                    }

                    accIdSet.add(eachDoc.Account__c);

                    if (objectName == 'Opportunity'){
                        eachDoc.Opportunity__c = parentId;
                    }

                    if (!existingDocuments.containsKey(docUniqueKey) && addDocToList == true){
                        insertDocList.add(eachDoc);
                        newDocumentsMap.put(docUniqueKey, eachDoc);
                        existingDocumentsKeep.put(docUniqueKey, eachDoc);
                    } else if (existingDocuments.containsKey(docUniqueKey)){
                        existingDocumentsKeep.put(docUniqueKey, eachDoc);
                    }
                }
            }
        }

        //Get Address records for Account Account Relations
        List<Address__c> addressLst = new AddressesSelector().selectByAccountIds(accIdSet);
        Set<String> addressDuplicateChecker = new Set<String>();
        Boolean primaryAddressCheck = false;
        for (Address__c eachAddress : addressLst){
            if(eachAddress.Address_Type__c != 'Postal') {
                String uniqueKey = eachAddress.Account__c + '#' + eachAddress.Shipping_Street__c;
                //Check for duplicate addresses
                if (primaryAccId == eachAddress.Account__c && primaryAddressCheck == false){
                    addressDuplicateChecker.add(uniqueKey);
                    primaryAddressCheck = true;
                }
                if (primaryAccId != eachAddress.Account__c){
                    addressDuplicateChecker.add(uniqueKey);
                }
            }
            
        }

        //Check to create additional Address Document Placeholders if its diffrent
        for (String eachAddress : addressDuplicateChecker){
            String accId = eachAddress.left(18);
            if (accAccAddressPlacholders.containsKey(accId)){
                Document__c eachDoc = new Document__c(Name = accAccAddressPlacholders.get(accId).Name, ECM_Type__c = accAccAddressPlacholders.get(accId).ECM_Type__c, Account__c = accAccAddressPlacholders.get(accId).Account__c, Opportunity__c = accAccAddressPlacholders.get(accId).Opportunity__c, Generate_Document__c = accAccAddressPlacholders.get(accId).Generate_Document__c);

                if (!existingAddressDocuments.containsKey(eachDoc.Account__c + '#' + eachDoc.ECM_Type__c)){
                    addressDocList.add(eachDoc);
                    newAddressDocumentsMap.put(eachDoc.Account__c + '#' + eachDoc.ECM_Type__c, eachDoc);
                    existingAddressDocumentsKeep.put(eachDoc.Account__c + '#' + eachDoc.ECM_Type__c, eachDoc);
                } else{
                    existingAddressDocumentsKeep.put(eachDoc.Account__c + '#' + eachDoc.ECM_Type__c, eachDoc);
                }
            }
        }

        //Compare Address insert vs existing list to determine if any Address placeholders need to be removed
        for (String eachNewDoc : existingAddressDocuments.keySet()){
            if (!existingAddressDocumentsKeep.containskey(eachNewDoc)){
                deleteDocList.add(existingAddressDocuments.get(eachNewDoc));
            }
        }

        //Compare insert vs existing list to determine if any placeholders need to be removed
        for (String eachNewDoc : existingDocuments.keySet()){
            if(!existingDocumentsKeep.containskey(eachNewDoc) && existingDocuments.get(eachNewDoc).Reference__c == null && existingDocuments.get(eachNewDoc).ECM_Type__c != 'Ent_HighRiskDocument') {
                deleteDocList.add(existingDocuments.get(eachNewDoc));
            }
        }

        //Insert Document Placeholders
        if (insertDocList != null && insertDocList.size() > 0){
            try {
                insert insertDocList;
            } catch (exception ex){
                string strErr =  'An unknown error occurred. Line : ' + ex.getLineNumber() + ' Error: ' + ex.getMessage();
            }
        }

        //Insert Document Placeholders
        if (addressDocList != null && addressDocList.size() > 0){
            insert addressDocList;
        }

        //Delete Placeholders thats not required anymore
        if (deleteDocList != null && deleteDocList.size() > 0){
            delete deleteDocList;
        }
    }

    /**
     * @description Recursive function to get required Document List per Entity
     * @param primaryAccount
     * @param entityWrapperList
     * @param entityDocuments
     * @param clientTypeMandatoryDocs
     * @return Map<Id, List<String>>
     **/
    public static Map<Id, List<String>> getDocumentMap(Account primaryAccount, List<OnboardingUBOListViewController.AccountWrapper> entityWrapperList, Map<Id, List<String>> entityDocuments, Map<String, List<String>> clientTypeMandatoryDocs){
        for (OnboardingUBOListViewController.AccountWrapper eachWrapper : entityWrapperList){

            String uniqueKey;
            if (eachWrapper.accType == 'AccountContact'){
                uniqueKey = 'UBO';
            } else{
                uniqueKey = 'Related Party ' + eachWrapper.Type;
            }

            String roles = eachWrapper.roles;

            if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                for (String eachEcmType : clientTypeMandatoryDocs.get(uniqueKey)){
                    if (eachWrapper.accType == 'AccountContact' && eachWrapper.UBO == 'Yes'){
                        if (eachEcmType != 'Ent_ProofOfAddress'){
                            if (!entityDocuments.containskey(eachWrapper.relatedAccountId)){
                                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                    entityDocuments.put(eachWrapper.relatedAccountId, new List<String>{ eachEcmType });
                                }
                            }
                        } else if (eachEcmType == 'Ent_ProofOfAddress' && roles != null && roles.contains('Individual with Authority to Act') && eachWrapper.ParentShareholding > 0){
                            if (primaryAccount.Client_Type__c == 'Individual' || primaryAccount.Client_Type__c == 'Private Individual' || primaryAccount.Client_Type__c == 'Individual - Minor'){
                                if (!entityDocuments.containskey(eachWrapper.relatedAccountId)){
                                    if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                        entityDocuments.put(eachWrapper.relatedAccountId, new List<String>{ eachEcmType });
                                    }
                                }
                            }
                        }
                    } else if (eachWrapper.accType == 'AccountAccount'){
                        if (eachEcmType == 'Ent_OwnershipStructure' && eachWrapper.ParentShareholding > 0){
                            if (!entityDocuments.containskey(eachWrapper.relatedAccountId)){
                                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                    entityDocuments.put(eachWrapper.relatedAccountId, new List<String>{ eachEcmType });
                                }
                            }
                        } else if (eachEcmType == 'Ent_ProofOfAddress' && eachWrapper.ParentShareholding == 0){
                            if (!entityDocuments.containskey(eachWrapper.relatedAccountId)){
                                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                    entityDocuments.put(eachWrapper.relatedAccountId, new List<String>{ eachEcmType });
                                }
                            }
                        } else if (eachEcmType != 'Ent_OwnershipStructure' && eachWrapper.ParentShareholding == 0){
                            if (!entityDocuments.containskey(eachWrapper.relatedAccountId)){
                                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                    entityDocuments.put(eachWrapper.relatedAccountId, new List<String>{ eachEcmType });
                                }
                            } else if (eachEcmType == 'Ent_PublicDocument'){
                                if (clientTypeMandatoryDocs.containsKey(uniqueKey)){
                                    entityDocuments.get(eachWrapper.relatedAccountId).add(eachEcmType);
                                }
                            }
                        }
                    }
                }
            }
            if (eachWrapper.childwrplist != null && eachWrapper.childwrplist.size() > 0){
                entityDocuments = getDocumentMap(primaryAccount, eachWrapper.childwrplist, entityDocuments, clientTypeMandatoryDocs);
            }
        }

        return entityDocuments;
    }

    /**
     * @description
     */
    public class AccDocumentWrapper{
        /**
         * @description
         */
        @AuraEnabled
        public String accName{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public Boolean isPrimary{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public Boolean isEddCase{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public List<DocPlaceholderWrapper> docPlaceholderWrappers{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public List<DocPlaceholderWrapper> docPlaceholderEddWrappers{ get; set; }

        /**
         * @description
         */
        public AccDocumentWrapper(){
            docPlaceholderWrappers = new List<DocPlaceholderWrapper>();
        }
    }

    /**
     * @description
     */
    public class DocPlaceholderWrapper{
        /**
         * @description
         */
        @AuraEnabled
        public Document__c docPlaceholder{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public string EcmType{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public string documentType{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public string selectedDocName{ get; set; }

        /**
         * @description
         */
        @AuraEnabled
        public List<String> documentNames{ get; set; }

        /**
         * @description
         */
        public DocPlaceholderWrapper(){
            documentNames = new List<String>();
        }
    }

    /**
     * @description get Document Placeholder
     * @author Tracy de Bruin
     * @param oppId
     * @return List<AccDocumentWrapper>
     **/
    @AuraEnabled
    public static List<AccDocumentWrapper> getAccDocumentWrapper(Id oppId){
        List<AccDocumentWrapper> accDocWrappers = new List<AccDocumentWrapper>();
        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);
        String primaryAccountId = oppRecord.AccountId;
        String caseId = oppRecord.Case__c;
        DocumentManagementSelectionController.createDocumentPlaceholders(primaryAccountId, oppRecord.Id);
        List<Document__c> docPlaceholders = new DocumentsSelector().selectDocumentsByOppId(oppId);
        Map<String, List<Document__c>> accountDocumentsMap = new Map<String, List<Document__c>>();
        Map<String, String> accNameId = new Map<String, String>();

        Set<String> ecmTypes = new Set<String>();
        //Add ECM Types to a Set
        for (Document__c eachDoc : docPlaceholders){
            ecmTypes.add(eachDoc.ECM_Type__c);
        }

        //Doc Template
        List<Document_Template__c> docTemplatesList = new DocumentTemplateSelector().selectByECMType(ecmTypes, 'Opportunity Business Bank');
        Map<String, String> ecmTypeDocType = new Map<String, String>();
        Map<String, List<String>> docTypeDocName = new Map<String, List<String>>();
        for (Document_Template__c eachDocTemp : docTemplatesList){
            ecmTypeDocType.put(eachDocTemp.ECM_Item_Type__c, eachDocTemp.Parent_Document_Type__c);
            if (docTypeDocName.containsKey(eachDocTemp.Parent_Document_Type__c)){
                docTypeDocName.get(eachDocTemp.Parent_Document_Type__c).add(eachDocTemp.Document_Type__c);
            } else{
                docTypeDocName.put(eachDocTemp.Parent_Document_Type__c, new List<String>{ 'Please Select...', eachDocTemp.Document_Type__c });
            }
        }


        //Document wrapper
        Map<String, List<DocPlaceholderWrapper>> accDocPlaceholderWrapper = new Map<String, List<DocPlaceholderWrapper>>();
        Map<String, List<DocPlaceholderWrapper>> accDocPlaceholderEddWrapper = new Map<String, List<DocPlaceholderWrapper>>();
        for (Document__c eachDoc : docPlaceholders){
            DocPlaceholderWrapper eachDocPlaceholderWrapper = new DocPlaceholderWrapper();
            eachDocPlaceholderWrapper.docPlaceholder = eachDoc;
            eachDocPlaceholderWrapper.EcmType = eachDoc.ECM_Type__c;
            eachDocPlaceholderWrapper.documentType = ecmTypeDocType.get(eachDoc.ECM_Type__c);
            eachDocPlaceholderWrapper.documentNames = docTypeDocName.get(eachDocPlaceholderWrapper.documentType);

            //Check for EDD/High Risk Document
            Boolean isHighRisk = false;
            if (eachDoc.Type__c == StringConstants.Management_sign_off_STRING || eachDoc.Type__c == StringConstants.EDD_level_ll_report_STRING || eachDoc.Type__c == StringConstants.POS_of_Income_funds_STRING || eachDoc.Type__c == StringConstants.FSP_Licence_STRING){
                isHighRisk = true;
            }

            if (eachDoc.Contact__c != null){
                //Check for Edd and add to seperate Map
                if (isHighRisk == true){
                    if (!accDocPlaceholderEddWrapper.containsKey(eachDoc.Contact__r.Name)){
                        accDocPlaceholderEddWrapper.put(eachDoc.Contact__r.Name, new List<DocPlaceholderWrapper>{ eachDocPlaceholderWrapper });
                    } else{
                        accDocPlaceholderEddWrapper.get(eachDoc.Contact__r.Name).add(eachDocPlaceholderWrapper);
                    }
                } else{
                    if (!accDocPlaceholderWrapper.containsKey(eachDoc.Contact__r.Name)){
                        accDocPlaceholderWrapper.put(eachDoc.Contact__r.Name, new List<DocPlaceholderWrapper>{ eachDocPlaceholderWrapper });
                    } else{
                        accDocPlaceholderWrapper.get(eachDoc.Contact__r.Name).add(eachDocPlaceholderWrapper);
                    }
                }
            } else if (eachDoc.Account__c != null){
                //Check for Edd and add to seperate Map
                if (isHighRisk == true){
                    if (!accDocPlaceholderEddWrapper.containsKey(eachDoc.Account__r.Name)){
                        accDocPlaceholderEddWrapper.put(eachDoc.Account__r.Name, new List<DocPlaceholderWrapper>{ eachDocPlaceholderWrapper });
                    } else{
                        accDocPlaceholderEddWrapper.get(eachDoc.Account__r.Name).add(eachDocPlaceholderWrapper);
                    }
                } else{
                    if (!accDocPlaceholderWrapper.containsKey(eachDoc.Account__r.Name)){
                        accDocPlaceholderWrapper.put(eachDoc.Account__r.Name, new List<DocPlaceholderWrapper>{ eachDocPlaceholderWrapper });
                    } else{
                        accDocPlaceholderWrapper.get(eachDoc.Account__r.Name).add(eachDocPlaceholderWrapper);
                    }
                }
            }

            if (eachDoc.Contact__c != null){
                if (accountDocumentsMap.containsKey(eachDoc.Contact__r.Name)){
                    accountDocumentsMap.get(eachDoc.Contact__r.Name).add(eachDoc);
                } else{
                    accountDocumentsMap.put(eachDoc.Contact__r.Name, new List<Document__c>{ eachDoc });
                }
                accNameId.put(eachDoc.Contact__r.Name, eachDoc.Contact__c);
            } else if (eachDoc.Account__c != null){
                if (accountDocumentsMap.containsKey(eachDoc.Account__r.Name)){
                    accountDocumentsMap.get(eachDoc.Account__r.Name).add(eachDoc);
                } else{
                    accountDocumentsMap.put(eachDoc.Account__r.Name, new List<Document__c>{ eachDoc });
                }
                accNameId.put(eachDoc.Account__r.Name, eachDoc.Account__c);
            }
        }

        for (String eachVal : accNameId.keySet()){
            AccDocumentWrapper eachAccDocWrappers = new AccDocumentWrapper();
            eachAccDocWrappers.accName = eachVal;
            eachAccDocWrappers.docPlaceholderWrappers = accDocPlaceholderWrapper.get(eachVal);
            eachAccDocWrappers.docPlaceholderEddWrappers = accDocPlaceholderEddWrapper.get(eachVal);

            if (accNameId.get(eachVal) == primaryAccountId){
                eachAccDocWrappers.isPrimary = true;
            }

            if (caseId != null && caseId != ''){
                eachAccDocWrappers.isEddCase = true;
            }

            accDocWrappers.add(eachAccDocWrappers);
        }

        return accDocWrappers;
    }

    /**
     * @description Save Document Placeholders
     * @author Tracy de Bruin
     * @param accDocWrapper
     * @param oppId
     * @param seniorManagementSignOff
     * @param adverseMediaReport
     * @param sourceOfFundsWealth
     * @param licence
     * @return String
     **/
    @AuraEnabled
    public static String updateDocuments(List<AccDocumentWrapper> accDocWrapper, String oppId, Boolean seniorManagementSignOff, Boolean adverseMediaReport, Boolean sourceOfFundsWealth, Boolean licence){
        List<Document__c> updateDocuments = new List<Document__c>();
        Map<String, Document__c> eddExistingDocuments = new Map<String, Document__c>();
        Map<String, Document_Template__c> documentTemplates = new Map<String, Document_Template__c>();
        List<Document__c> docPlaceholders = new DocumentsSelector().selectDocumentsByOppId(oppId);
        Set<String> ecmType = new Set<String>();

        //Add ECM Types to a Set
        for (Document__c eachDoc : docPlaceholders){
            ecmType.add(eachDoc.ECM_Type__c);
        }

        //Doc Template
        List<Document_Template__c> docTemplatesList = new DocumentTemplateSelector().selectByECMType(ecmType, 'Opportunity Business Bank');
        for (Document_Template__c docTemplate : docTemplatesList){
            documentTemplates.put(docTemplate.Document_Type__c.toLowerCase(), docTemplate);
        }
        try{
            List<DocPlaceholderWrapper> docPlaceholderWrapperList = new List<DocPlaceholderWrapper>();
            List<DocPlaceholderWrapper> docPlaceholderEddWrapperList = new List<DocPlaceholderWrapper>();
            for (AccDocumentWrapper eachItem : accDocWrapper){
                if (eachItem.docPlaceholderWrappers != null){
                    docPlaceholderWrapperList.addAll(eachItem.docPlaceholderWrappers);
                }

                if (eachItem.docPlaceholderEddWrappers != null){
                    docPlaceholderEddWrapperList.addAll(eachItem.docPlaceholderEddWrappers);
                }
            }

            //Loop over placeholder documents and add to update list
            for (DocPlaceholderWrapper eachItem : docPlaceholderWrapperList){
                if (eachItem.docPlaceholder.Type__c == 'Please Select...'){
                    eachItem.docPlaceholder.Type__c = null;
                }
                if (eachItem.docPlaceholder.Type__c != null){
                    eachItem.docPlaceholder.Generate_Document__c = documentTemplates.get(eachItem.docPlaceholder.Type__c.toLowerCase()).Generate_Document__c;
                }
                updateDocuments.add(eachItem.docPlaceholder);
            }

            //Loop over Edd placeholder documents and add to map
            for (DocPlaceholderWrapper eachItem : docPlaceholderEddWrapperList){
                eddExistingDocuments.put(eachItem.docPlaceholder.Type__c, eachItem.docPlaceholder);
            }

            //Create EDD DocumentPlaceholders
            String primaryAccountId = new OpportunitiesSelector().selectByOppId(oppId).AccountId;
            Set<String> ecmTypes = new Set<String>();
            ecmTypes.add('Ent_HighRiskDocument');
            List<Document_Template__c> docTemplateList = new DocumentTemplateSelector().selectByECMType(ecmTypes, 'Opportunity Business Bank');
            for (Document_Template__c eachDocTemp : docTemplateList){
                String docType = eachDocTemp.Document_Type__c;
                if ((seniorManagementSignOff == true && eachDocTemp.Document_Type__c == StringConstants.Management_sign_off_STRING) || (adverseMediaReport == true && eachDocTemp.Document_Type__c == StringConstants.EDD_level_ll_report_STRING) || (sourceOfFundsWealth == true && eachDocTemp.Document_Type__c == StringConstants.POS_of_Income_funds_STRING) || (licence == true && eachDocTemp.Document_Type__c == StringConstants.FSP_Licence_STRING)){
                    //Check for existing edd documents
                    if (!eddExistingDocuments.containsKey(eachDocTemp.Document_Type__c)){
                        Document__c eddDoc = new Document__c(Name = eachDocTemp.ECM_Item_Type__c.left(75) + '.pdf',ECM_Type__c = eachDocTemp.ECM_Item_Type__c,Account__c = primaryAccountId,Opportunity__c = oppId,Type__c = eachDocTemp.Document_Type__c);
                        updateDocuments.add(eddDoc);
                    }
                }
            }

            upsert updateDocuments;

            return 'SUCCESS';

        } catch (exception ex){
            return 'An unknown error occurred. Line : ' + ex.getLineNumber() + ' Error: ' + ex.getMessage();
        }
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param oppId
     * @return Opportunity
     **/
    @AuraEnabled
    public static Opportunity getOppRecord(Id oppId){

        Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(oppId);
        return oppRecord;
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param parentId
     * @param oppApplicationId
     * @param fileName
     * @param base64Data
     * @param contentType
     * @param fileId
     * @param done
     * @param documentType
     * @param signedManually
     * @param relatedPartyId
     * @param fExt
     * @param documentId
     * @param accountId
     * @param contactId
     * @return Id
     **/
    @AuraEnabled
    public static Id saveChunk(Id parentId, Id oppApplicationId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType, Boolean signedManually, String relatedPartyId, String fExt, string documentId, Id accountId, Id contactId){
        return DocumentController.saveChunkCAF(parentId, oppApplicationId, fileName, base64Data, contentType, fileId, done, documentType, signedManually, relatedPartyId, fExt, documentId, accountId, contactId);
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-08-18
     * @param opportunityId
     * @param templateName
     * @param accountId
     * @param contactId
     * @param documentId
     * @return Map<String, String>
     **/
    @AuraEnabled
    public static Map<String, String> generateNewDocument(Id opportunityId, String templateName, Id accountId, Id contactId, String documentId){
        //templateName = DOCUMENT_TYPES.get(templateName);
        List<SignatureRequest__c> signatureRequests = new List<SignatureRequest__c>();
        Map<String, String> result = GenerateDocument.generateNewDocument(opportunityId, templateName, signatureRequests, documentId);
        return result;
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param docId
     * @return String
     **/
    @AuraEnabled
    public static String getDocumentContent(String docId){
        try{
            return DocumentController.getDocumentContent(docId);
        } catch (Exception ex){
            String msg = ex.getMessage();
        }
        return null;
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param docId
     * @return String
     **/
    @AuraEnabled
    public static String restrictSystemDocs(Id docId){
        String generatedDoc = '';
        List<Document__c> docList = [SELECT Id, Reference__c, Document_Generated__c
        FROM Document__c
        WHERE id = :docId];
        if (!docList.isEmpty() && docList.size() > 0 && docList != null){
            generatedDoc = docList.get(0).Document_Generated__c;
        }
        return generatedDoc;
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param docId
     * @return String
     **/
    @AuraEnabled
    public static String deleteDocument(Id docId){
        String strToreturn = '';
        List<Document__c> docList = [SELECT Id, Reference__c, Document_Generated__c
        FROM Document__c
        WHERE id = :docId];
        if (!docList.isEmpty() && docList.size() > 0 && docList != null){
            docList.get(0).Reference__c = '';
            docList.get(0).Generated_Uploaded__c = '';
            update docList.get(0);
        }
        return strToreturn;
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param opportunityId
     * @param documentId
     * @return boolean
     **/
    @AuraEnabled
    public static boolean documentRestricted(Id opportunityId, Id documentId){
        if (!Test.isRunningTest()){
            return DocumentsShareControllerESign.documentRestricted(opportunityId, documentId);
        } else {
            return true;
        }
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param opportunityId
     * @return List<String>
     **/
    @AuraEnabled
    public static List<String> getAllClientEmailsSignature(Id opportunityId){
        return DocumentsShareControllerESign.getAllClientEmailsSignature(opportunityId);
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param fld
     * @return List<String>
     **/
    @AuraEnabled
    public static List<String> getDigitalSignatorySelectOptions(string fld){
        try{
            return DocumentsShareControllerESign.getDigitalSignatorySelectOptions(fld);
        } catch (Exception ex){
            String msg = ex.getMessage();

        }
        return null;
    }

    /**
     * @description
     * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
     * @param documentId
     * @return List<Map<String, Object>>
     **/
    @AuraEnabled
    public static List<Map<String, Object>> getSignatoriesData(Id documentId){
        return DocumentsShareControllerESign.getSignatoriesData(documentId);
    }

    /**
     * @author Vladimir Panajic
     * @description Method that gets a list of all Impression requests for an Opportunity
     *
     * @param opportunityId
     * @return impressionRequests
     */
    @AuraEnabled
    public static List<ImpressionRequest__c> fetchImpressionRequest(Id opportunityId){
        return DocumentsShareControllerESign.fetchImpressionRequest(opportunityId);
    }

    /**
     * @author Tracy de bruin
     * @description Method that updates impression request
     *
     * @param opportunityId
     */
    @AuraEnabled
    public static void updateImpressionRequests(Id opportunityId){
        ImpressionsController.updateImpressionRequests(opportunityId);
    }

    /**
     * @author Anka Ganta
     * @description Method that gets a list of selected signatories for a document : W-012954
     * @param documentId
     * @param acrRecs
     * @return List<Map<String, Object>>
     */
    @AuraEnabled
    public static List<Map<String, Object>> getSignatoriesDataSelected(Id documentId, List<Id> acrRecs){
        return DocumentsShareControllerESign.getSignatoriesDataSelected(documentId, acrRecs);
    }

    /**
     * @author Vladimir Panajic
     * @description Method that gets all of the clients mobile numbers
     *
     * @param opportunityId
     * @return List<String>
     */
    @AuraEnabled
    public static List<String> getMobileDetails(Id opportunityId){
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        List<String> mobile = new List<String>();
        List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, accounts.get(0).PersonContactId, 1);
        if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
            if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
                mobile.add(signatoryPartyOveridesList.get(0).Preferred_Mobile__c);
            }
        }
        if (account.PersonMobilePhone != null){
            mobile.add(account.PersonMobilePhone);
        }
        return mobile;
    }

    /**
     * @author Anka Ganta
     * @description Method that gets an updated list of all signatory items for a document : W-012954
     *
     * @param opportunityId
     * @param documentId
     * @param signatoryId
     * @param signatoriesInput
     * @param method
     * @param mobile
     * @param email
     * @param order
     * @return List<Map<String, Object>>
     */
    @AuraEnabled
    public static List<Map<String, Object>> getUpdatedSignatoriesDataSelected(Id opportunityId, Id documentId, Id signatoryId, String signatoriesInput, String method, String mobile, String email, String order){
        return DocumentsShareControllerESign.getUpdatedSignatoriesDataSelected(opportunityId, documentId, signatoryId, signatoriesInput, method, mobile, email, order);
    }

    /**
     * @author Vladimir Panajic
     * @description Method that calls Impression for document digital signature
     *
     * @param documentId
     * @param signatories
     * @return String
     */
    @AuraEnabled
    public static String sendForImpressionSignature(Id documentId, String signatories){
        try{
            return DocumentsShareControllerESign.sendForImpressionSignature(documentId, signatories);
        } catch (Exception ex){
            String msg = ex.getMessage();
        }
        return null;
    }

    /**
     * @description
     * @author
     * @param OppId
     * @return List<String>
     **/
    @AuraEnabled
    public static List<String> getPrimaryClientMandatoryDocuments(String OppId){
        //Get primary Account details
        try{
            Opportunity oppRecord = new OpportunitiesSelector().selectByOppId(OppId);
            Account primaryAccount = new AccountsSelector().selectById(oppRecord.AccountId);
            return DocumentManagementControler.getPrimaryClientMandatoryDocuments(primaryAccount.Client_Type__c, OppId);
        } catch (Exception ex){
            String msg = ex.getMessage();
        }
        return null;
    }

    /**
     * @author Vladimir Panajic
     * @description Method that gets all of the clients emails for sharing
     *
     * @param opportunityId
     * @return List<String>
     */
    @AuraEnabled
    public static List<String> getAllClientEmails(Id opportunityId){
        return DocumentsShareControllerESign.getAllClientEmails(opportunityId);
    }

    /**
     * @author Vladimir Panajic
     * @description Method that gets all of the clients mobile numbers
     *
     * @param opportunityId
     * @return List<String>
     */
    @AuraEnabled
    public static List<String> getMobile(Id opportunityId){
        return DocumentsShareControllerESign.getMobile(opportunityId);
    }
}