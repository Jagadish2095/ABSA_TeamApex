/**
* @description       : Controller class for Terms of Business Component
* @author            : Almas Aleem
* @last modified on  : 2021-10-18
* @last modified by  : almas.aleem@absa.africa
* Modifications Log
* Ver   Date         Author                       Modification
* 1.0   2021-06-12  Almas Aleem  Initial Version
**/

public class ProductTermsOfBusinessController {
    /**
* @description W-011426 - CC
* @author Himanshu.Nimje@absa.africa | 2021-06-12
* @param oppId
* @return List<Application_Product__c>
**/
    @auraEnabled
    public static List<Application_Product__c> getSelectedProduct(Id oppId) {
        List<Application_Product__c> appPrdList = [
            SELECT Id, Name, Product_Code__c, Product_Account_Number__c, Product_Type__c, Product_Status__c, Product_State__c, Product_Name__c
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId
        ];
        
        return appPrdList;
    }
    
    /**
* @description W-011426 - CC
* @author Himanshu.Nimje@absa.africa | 2021-06-12
**/
    public class CCProductTOB {
        @auraEnabled
        public String appProductLabel;
        @auraEnabled
        public Id appProdId;
        @auraEnabled
        public Application_Product__c appProduct;
        @auraEnabled
        public String CCAccountNumber;
        @auraEnabled
        public String CampaignCode;
        @auraEnabled
        public String ApplicantRisk;
        @auraEnabled
        public String MaximumNCARateType;
        @auraEnabled
        public String NCAAppplicable;
        @auraEnabled
        public String MaximumNCARate;
        @auraEnabled 
        public String NCAQuoteReq; //Added for W-013202
        @auraEnabled
        public String AgreementCategory;
        @auraEnabled
        public List<Terms_Of_Business__c> CCTOBList;
        /**
* @description W-011426 - CC
* @author Himanshu.Nimje@absa.africa | 2021-06-12
**/
        public CCProductTOB() {
            this.CCTOBList = new List<Terms_Of_Business__c>();
            this.appProduct = new Application_Product__c();
        }
    }
    
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-12
* @param oppId
* @return List<CCProductTOB>
**/
    @auraEnabled
    public static List<CCProductTOB> getCCProductTOB(Id oppId) {
        
        List<CCProductTOB> CCProductTOBList = new List<CCProductTOB>();
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Application_scoring__c appScore = [
            SELECT Id, OD_Applicant_Risk__c
            FROM application_scoring__c
            WHERE stage__c = '6' AND Application_Number__c = :app.Id
        ];
        
        List<Application_Product__c> ProductList = [
            SELECT
            id,
            Name,
            Application__r.Credit_Application_Accepted__c,
            Product_Name__c,
            Account_Number__c,
            Product_Amount__c,
            Product_State__c,
            Product_Status__c,
            Limit_Type__c,
            Temp_Account_Number__c,
            Agreement_Category__c,
            Campaign_Code__c,
            toLabel(Product_Type__c) producttype,
            Review_Date__c,
            Accept_TOB__c,
            Expiry_Date__c,
            Secured_By_Mortgage_Bond__c,
            NCA_Appplicable__c,
            Maximum_NCA_Rate_Type__c,
            Maximum_NCA_Rate__c,
            NCA_Quote_Required__c,
            (
                SELECT
                id,
                Application_Product__c,
                TOB_Classification__c,
                Tob_Description__c,
                Existing_Account__c,
                Requested__c,
                Offered_by_Powercurve__c,
                Final_Offered__c
                FROM Terms_Of_Business__r
            )
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId AND Product_Name__c = 'Credit Card'
        ];
        
        
        for (Application_Product__c appProd : ProductList) {
            // if(appProd.Terms_Of_Business__r  !=null){ remove after testing
            String accountNumber;
            if (appProd.Product_State__c == 'New') {
                accountNumber = appProd.Temp_Account_Number__c;
            } else {
                accountNumber = '' + appProd.Account_Number__c;
            }
            
            CCProductTOB ptob = new CCProductTOB();
            ptob.appProdId = appProd.Id;
            ptob.appProduct = appProd;
            ptob.appProductLabel = 'Credit Card' + '-' + appProd.Product_State__c + ' ' + accountNumber + '-' + appProd.Product_Status__c;
            ptob.CCAccountNumber = appProd.Temp_Account_Number__c;
            ptob.CampaignCode = appProd.Campaign_Code__c;
            ptob.NCAAppplicable = appProd.NCA_Appplicable__c;
            ptob.MaximumNCARateType = NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c) == ''
                ? appProd.Maximum_NCA_Rate_Type__c
                : NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c);
            ptob.MaximumNCARate = appProd.Maximum_NCA_Rate__c;
            ptob.NCAQuoteReq = appProd.NCA_Quote_Required__c; //Added for W-013202
            ptob.ApplicantRisk = string.valueof(appScore.OD_Applicant_Risk__c) != null ? string.valueof(appScore.OD_Applicant_Risk__c) : null;
            
            if (appProd.Secured_By_Mortgage_Bond__c == true) {
                appProd.Agreement_Category__c = 'Large Agreement';
                ptob.AgreementCategory = 'Large Agreement';
            } else {
                if (appProd.Product_Amount__c < 15000 && appProd.Product_Amount__c > 0) {
                    //Need to check Product amount for CC
                    appProd.Agreement_Category__c = 'Small Agreement';
                    ptob.AgreementCategory = 'Small Agreement';
                } else if (appProd.Product_Amount__c >= 15000 && appProd.Product_Amount__c < 250000) {
                    appProd.Agreement_Category__c = 'Intermediate Agreement';
                    ptob.AgreementCategory = 'Intermediate Agreement';
                } else if (appProd.Product_Amount__c >= 250000) {
                    appProd.Agreement_Category__c = 'Large Agreement';
                    ptob.AgreementCategory = 'Large Agreement';
                }
            }
            
           // system.debug('appProd.Terms_Of_Business__r----' + appProd.Terms_Of_Business__r);
            for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                if (tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')) {
                    ptob.CCTOBList.add(tob);
                }
            }
            
            CCProductTOBList.add(ptob);
            //}
        }
       // system.debug('CCProductTOBList----' + CCProductTOBList);
        return CCProductTOBList;
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @param ratetype
* @return String
**/
    public static String NCAratetypeTranslator(String ratetype) {
        String returnValue = '';
        Map<String, String> mapvalue = new Map<String, String>();
        
        mapValue.put('51', 'Credit Facilities');
        mapValue.put('52', 'Unsecured Agreements');
        mapValue.put('53', 'Mortgage Agreements');
        mapValue.put('54', 'Other Credit Agreements');
        mapValue.put('60', '	Out of NCA');
        
        returnValue = mapValue.get(ratetype);
        return returnValue;
    }
    
    /** will use meta data later  for below code**/
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @return List<FieldWrapper>
**/
    @auraEnabled
    public static List<FieldWrapper> getfWrapperList() {
        //read metadata---
        List<OverdraftTOBFields__mdt> productFieldList = [SELECT MasterLabel, FieldName__c FROM OverdraftTOBFields__mdt];
        
        List<FieldWrapper> fieldWrapList = new List<FieldWrapper>();
        for (OverdraftTOBFields__mdt productField : productFieldList) {
            List<String> fieldnames = productField.FieldName__c.split(',');
            FieldWrapper fieldWrap = new FieldWrapper();
            fieldWrap.DescText = productField.MasterLabel;
            fieldWrap.editableFields = new List<EditableFields>();
            for (String field : fieldnames) {
                editableFields editf = new editableFields();
                editf.fieldName = field;
                editf.isReadOnly = true; //for other fields which are not editable
                
                if (field.containsIgnoreCase('Pricing_Decision') || field.containsIgnoreCase('Comments__c')) {
                    continue;
                }
                
                if (productField.MasterLabel == 'Once-Off Reduction Amount') {
                    if (field == 'Adjusted_Number__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                if (productField.MasterLabel == 'Regular Reduction Amount') {
                    if (field == 'Adjusted_Number__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                if (productField.MasterLabel == 'Overdraft Limit') {
                    if (field == 'Adjusted_Number__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                if (
                    productField.MasterLabel == 'Variable Amount 1' ||
                    productField.MasterLabel == 'Variable Amount 2' ||
                    productField.MasterLabel == 'Variable Amount 3' ||
                    productField.MasterLabel == 'Variable Amount 4' ||
                    productField.MasterLabel == 'Variable Amount 5' ||
                    productField.MasterLabel == 'Variable Amount 6' ||
                    productField.MasterLabel == 'Variable Amount 7' ||
                    productField.MasterLabel == 'Variable Amount 8' ||
                    productField.MasterLabel == 'Variable Amount 9' ||
                    productField.MasterLabel == 'Variable Amount 10' ||
                    productField.MasterLabel == 'Variable Amount 11' ||
                    productField.MasterLabel == 'Variable Amount 12'
                ) {
                    if (field == 'Adjusted_Number__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                if (productField.MasterLabel == 'Overdraft Limit Type') {
                    if (field == 'Adjusted_by_Sanctioner_Picklist__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                if (productField.MasterLabel == 'Regular Reduction Frequency') {
                    if (field == 'Adjusted_By_Sanctioner_Frequency__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                
                if (productField.MasterLabel == 'Once-Off Reduction Date' || productField.MasterLabel == 'Reduction Date for Regular') {
                    if (field == 'Adjusted_Date__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                
                if (
                    (productField.MasterLabel == 'Variable Date 1' ||
                     productField.MasterLabel == 'Variable Date 2' ||
                     productField.MasterLabel == 'Variable Date 3' ||
                     productField.MasterLabel == 'Variable Date 4' ||
                     productField.MasterLabel == 'Variable Date 5' ||
                     productField.MasterLabel == 'Variable Date 6' ||
                     productField.MasterLabel == 'Variable Date 7' ||
                     productField.MasterLabel == 'Variable Date 8' ||
                     productField.MasterLabel == 'Variable Date 9' ||
                     productField.MasterLabel == 'Variable Date 10' ||
                     productField.MasterLabel == 'Variable Date 11' ||
                     productField.MasterLabel == 'Variable Date 12')
                ) {
                    if (field == 'Adjusted_Date__c') {
                        editf.isReadOnly = false;
                    } else {
                        editf.isReadOnly = true;
                    }
                }
                
                fieldWrap.editableFields.add(editf);
            }
            fieldWrapList.add(fieldWrap);
        }
        
        return fieldWrapList;
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @return List<FieldWrapper>
**/
    @auraEnabled
    public static List<FieldWrapper> getfWrapperListOrigination() {
        //read metadata---
        List<OverdraftTOBFields__mdt> productFieldList = [SELECT MasterLabel, FieldName__c FROM OverdraftTOBFields__mdt];
        
        List<FieldWrapper> fieldWrapList = new List<FieldWrapper>();
        for (OverdraftTOBFields__mdt productField : productFieldList) {
            List<String> fieldnames = productField.FieldName__c.split(',');
            FieldWrapper fieldWrap = new FieldWrapper();
            fieldWrap.DescText = productField.MasterLabel;
            fieldWrap.editableFields = new List<EditableFields>();
            for (String field : fieldnames) {
                editableFields editf = new editableFields();
                if (field.containsIgnoreCase('Adjusted') || field.containsIgnoreCase('Pricing_Decision') || field.containsIgnoreCase('Comments__c')) {
                    continue;
                } else {
                    editf.fieldName = field;
                    editf.isReadOnly = true; //for other fields which are not editable
                }
                
                fieldWrap.editableFields.add(editf);
            }
            fieldWrapList.add(fieldWrap);
        }
        return fieldWrapList;
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @return List<FieldsHideAndShow>
**/
    @AuraEnabled
    public static List<FieldsHideAndShow> getLimitTypeFields() {
        List<FieldsHideAndShow> showFields = new List<FieldsHideAndShow>();
        
        FieldsHideAndShow sf = new FieldsHideAndShow();
        sf.LimitType = 'Fixed';
        sf.DescTextList = new List<String>();
        showFields.add(sf);
        
        sf = new FieldsHideAndShow();
        sf.LimitType = 'Indefinite';
        sf.DescTextList = new List<String>();
        showFields.add(sf);
        
        sf = new FieldsHideAndShow();
        sf.LimitType = 'Reducing - Once Off Only';
        sf.DescTextList = new List<String>{ 'Once-Off Reduction Amount', 'Once-Off Reduction Date' };
            showFields.add(sf);
        
        sf = new FieldsHideAndShow();
        sf.LimitType = 'Reducing - Once Off And Recurring';
        sf.DescTextList = new List<String>{
            'Once-Off Reduction Amount',
                'Once-Off Reduction Date',
                'Regular Reduction Amount',
                'Reduction Date for Regular',
                'Regular Reduction Frequency'
                };
                    showFields.add(sf);
        
        sf = new FieldsHideAndShow();
        sf.LimitType = 'Reducing - Recurring Only';
        sf.DescTextList = new List<String>{ 'Regular Reduction Amount', 'Reduction Date for Regular', 'Regular Reduction Frequency' };
            showFields.add(sf);
        
        sf = new FieldsHideAndShow();
        sf.LimitType = 'Variable';
        sf.DescTextList = new List<String>{
            'Once-Off Reduction Amount',
                'Once-Off Reduction Date',
                'Regular Reduction Amount',
                'Reduction Date for Regular',
                'Regular Reduction Frequency',
                'Variable Amount 1',
                'Variable Date 1',
                'Variable Amount 2',
                'Variable Date 2',
                'Variable Amount 3',
                'Variable Date 3',
                'Variable Amount 4',
                'Variable Date 4',
                'Variable Amount 5',
                'Variable Date 5',
                'Variable Amount 6',
                'Variable Date 6',
                'Variable Amount 7',
                'Variable Date 7',
                'Variable Amount 8',
                'Variable Date 8',
                'Variable Amount 9',
                'Variable Date 9',
                'Variable Amount 10',
                'Variable Date 10',
                'Variable Amount 11',
                'Variable Date 11',
                'Variable Amount 12',
                'Variable Date 12'
                };
                    showFields.add(sf);
        
        return showFields;
    }
    /**
* @description W-011426 - CC
* @author Almas Aleem  | 2021-06-12
**/
    public class FieldWrapper {
        @auraEnabled
        public String DescText;
        @auraEnabled
        public list<EditableFields> editableFields;
        @auraEnabled
        public List<String> FieldNames;
        
        // @auraEnabled public Map<String,Boolean> EditableFields;
    }
    /**
* @description W-011426 - CC
* @author Almas Aleem  | 2021-06-12
**/
    public class FieldsHideAndShow {
        @auraEnabled
        public String LimitType;
        @auraEnabled
        public List<String> DescTextList;
    }
    /**
* @description W-011426 - CC
* @author Almas Aleem  | 2021-06-12
**/
    public class EditableFields {
        @auraEnabled
        public String fieldName;
        @auraEnabled
        public Boolean isReadOnly;
        
        /*public EditableFields(String fieldName,Boolean isReadOnly){
this.fieldName = fieldName;
this.isReadOnly = isReadOnly;
}*/
    }
    
    /**
* @description this method return wrapper list of product tob and product info
* @author Almas Aleem | 2021-06-12
* @param oppId
* @return List<ProductTOB>
**/
    @auraEnabled
    public static List<ProductTOB> getProductTOBOrigination(Id oppId) {
        List<ProductTOB> productTOBList = new List<ProductTOB>();
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        Application__c applicationRec = [
            SELECT Id, Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c, Credit_Application_Acceptedby__c
            FROM Application__c
            WHERE Opportunity__c = :oppId
            LIMIT 1
        ];
        List<FieldsHideAndShow> fieldList = getLimitTypeFields();
        
        //use selector later
        List<Application_Product__c> ProductList = [
            SELECT
            id,
            Name,
            Application__r.Credit_Application_Accepted__c,
            Product_Name__c,
            Account_Number__c,
            Product_State__c,
            Product_Status__c,
            Limit_Type__c,
            Temp_Account_Number__c,
            Agreement_Category__c,
            toLabel(Product_Type__c) producttype,
            Review_Date__c,
            Accept_TOB__c,
            Expiry_Date__c,
            NCA_Appplicable__c,
            NCA_Quote_Required__c,
            Maximum_NCA_Rate_Type__c,
            Maximum_NCA_Rate__c,
            (
                SELECT
                id,
                Application_Product__c,
                TOB_Classification__c,
                Tob_Description__c,
                Comments__c,
                Existing_Account__c,
                Final_Offered__c,
                Offered_by_Powercurve__c,
                Requested_Amount__c,
                Existing_Account_Number__c,
                Final_Offered_Number__c,
                PowerCurve_Offered_Number__c,
                Existing_Account_Date__c,
                Final_Offered_Date__c,
                PowerCurve_Offered_Date__c,
                Requested__c,
                Requested_Number__c,
                Requested_Date__c
                FROM Terms_Of_Business__r
            )
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId AND Application_Product_Parent__c = NULL AND Product_Status__c != 'Withdraw' AND Product_Name__c = 'Cheque'
        ]; //Added by Himanshu
        //List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProducts(appPrdList) ; ,  //selector for tob based on products
        
        Map<Id, List<Terms_Of_Business__c>> prodTobmap = new Map<Id, List<Terms_Of_Business__c>>();
        List<Terms_Of_Business__c> tobList;
        
        //in future add check of term loan or over draft
        //Added By Himanshu Nimje : PMD issue Avoid Ops in Loop
        Map<String, Application_Product__c> childWithParentProductMap = new Map<String, Application_Product__c>();
        List<Application_Product__c> childappProdList = [
            SELECT
            id,
            name,
            Product_Amount__c,
            Overdraft_Purpose__c,
            Campaign_Code__c,
            Limit_Type__c,
            Application_Product_Parent__c,
            Secured_By_Mortgage_Bond__c,
            Asset_Value__c,
            Annual_Turnover__c
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId AND Application_Product_Parent__c != NULL
        ];
        if (childappProdList != null || !childappProdList.isEmpty()) {
            for (Application_Product__c apc : childappProdList) {
                childWithParentProductMap.put(apc.Application_Product_Parent__c, apc);
            }
        }
        //End by Himanshu Nimje
        Application_Product__c appProdobj = new Application_Product__c();
        Map<String,String> OverdraftPurposeTranslationMap = TranslatePicklist(appProdobj,'Overdraft_Purpose__c');
        for (Application_Product__c appProd : ProductList) {
            if (appProd.Terms_Of_Business__r != null) {
                String accountNumber;
                if (appProd.Product_State__c == 'New') {
                    accountNumber = appProd.Temp_Account_Number__c;
                } else {
                    accountNumber = '' + appProd.Account_Number__c;
                }
                
                Application_Product__c childappProd = childWithParentProductMap.get(appProd.id); //Added by Himanshu Nimje
                
                //if(!appProd.Terms_Of_Business__r.isEmpty() && appProd.Terms_Of_Business__r.size()>0){
                ProductTOB ptob = new ProductTOB();
                //  ptob.DescriptionWithFieldType = new Map<String,String>();
                ptob.appProdId = appProd.Id;
                ptob.NCAQuoteReq = appProd?.NCA_Quote_Required__c; //Added for W-013202
                ptob.appProduct = appProd;
                ptob.appProductLabel = 'Overdraft Faciltiy' + '-' + appProd.Product_State__c + ' ' + accountNumber + '-' + appProd.Product_Status__c;
                
                // ptob.ChequeAccountNumber = appProd.Temp_Account_Number__c;
                ptob.ChequeAccountNumber = accountNumber;
                ptob.ProductType = '' + appProd.get('producttype');
                ptob.PurposeofOverdraft = '' + (OverdraftPurposeTranslationMap.containskey(childappProd.Overdraft_Purpose__c)?OverdraftPurposeTranslationMap.get(childappProd.Overdraft_Purpose__c):'');
                //ptob.ApplicantRisk = childappProd. ;
                ptob.ReviewDate = appProd.Review_Date__c;
                ptob.ExpiryDate = appProd.Expiry_Date__c;
                ptob.CampaignCode = childappProd.Campaign_Code__c;
                ptob.NCAAppplicable = appProd.NCA_Appplicable__c;
                ptob.MaximumNCARateType = NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c) == ''
                    ? appProd.Maximum_NCA_Rate_Type__c
                    : NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c);
                ptob.MaximumNCARate = appProd.Maximum_NCA_Rate__c;
                ptob.isaccepted = appProd.Accept_TOB__c;
                ptob.isacceptedApplicationLevel = applicationRec.Credit_Application_Accepted__c;
                
                if (childappProd.Secured_By_Mortgage_Bond__c == true) {
                    appProd.Agreement_Category__c = 'Large Agreement';
                    ptob.AgreementCategory = 'Large Agreement';
                } else {
                    if (childappProd.Product_Amount__c < 15000 && childappProd.Product_Amount__c > 0) {
                        appProd.Agreement_Category__c = 'Small Agreement';
                        ptob.AgreementCategory = 'Small Agreement';
                    } else if (childappProd.Product_Amount__c >= 15000 && childappProd.Product_Amount__c < 250000) {
                        appProd.Agreement_Category__c = 'Intermediate Agreement';
                        ptob.AgreementCategory = 'Intermediate Agreement';
                    } else if (childappProd.Product_Amount__c >= 250000) {
                        appProd.Agreement_Category__c = 'Large Agreement';
                        ptob.AgreementCategory = 'Large Agreement';
                    }
                }
                
                //ptob.AgreementCategory = appProd.Agreement_Category__c;
                String limitValue = '';
                
               
                for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                    if (tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')) {
                        if (tob.Tob_Description__c == 'Overdraft Limit Type') {
                            if (tob.Final_Offered__c != null && tob.Final_Offered__c !='') {
                                limitValue = tob.Final_Offered__c;
                            } else if (appProd.Product_State__c.equalsIgnoreCase('New')) {
                                limitValue = tob.Requested__c;
                            } else {
                                limitValue = tob.Requested__c;
                            }
                            ptob.limitType = limitValue;
                            
                            ptob.termstobList.add(tob);
                        }
                        if (tob.Tob_Description__c == 'Overdraft Limit' || tob.Tob_Description__c == 'Current Balance') {
                            ptob.termstobList.add(tob);
                        }
                        // ptob.termstobList.add(tob);
                    }
                }
                
                for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                    if (tob.TOB_Classification__c.equalsIgnoreCase('Additional Info')) {
                        ptob.additionaltobList.add(tob);
                    } else if (tob.TOB_Classification__c.equalsIgnoreCase('Pricing And Fees')) {
                        ptob.pricingtobList.add(tob);
                    }
                }
                
                if (limitValue != null) {
                    if (limitValue.containsIgnoreCase('Reducing')) {
                        for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                            if (tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')) {
                                if (tob.Tob_Description__c.containsIgnoreCase('Reduction')) {
                                    ptob.termstobList.add(tob);
                                }
                            }
                        }
                    } else if (limitValue.containsIgnoreCase('Variable')) {
                        for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                            if (tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')) {
                                if (tob.Tob_Description__c.containsIgnoreCase('Variable')) {
                                    ptob.termstobList.add(tob);
                                }
                            }
                        }
                    }
                }
                //ptob.tobList = prodTobmap.get(appProdId);
                productTOBList.add(ptob);
            }
        }
        
        return productTOBList;
    }
    
    /**
* @description
* @author Almas Aleem| 2021-06-12
* @param oppId
* @return List<ProductTOB>
**/
    @auraEnabled
    public static List<ProductTOB> getproductTOB(Id oppId) {
        List<ProductTOB> productTOBList = new List<ProductTOB>();
        
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        
        //use selector later
        List<Application_Product__c> ProductList = [
            SELECT
            id,
            Name,
            Product_Name__c,
            Account_Number__c,
            Product_State__c,
            Product_Status__c,
            Limit_Type__c,
            Temp_Account_Number__c,
            Agreement_Category__c,
            toLabel(Product_Type__c) producttype,
            Review_Date__c,
            Expiry_Date__c,
            NCA_Appplicable__c,
            Maximum_NCA_Rate_Type__c,
            Maximum_NCA_Rate__c,
            (
                SELECT
                id,
                Application_Product__c,
                TOB_Classification__c,
                Tob_Description__c,
                Adjusted_by_Sanctioner__c,
                Comments__c,
                Existing_Account__c,
                Final_Offered__c,
                Offered_by_Powercurve__c,
                Requested_Amount__c,
                Existing_Account_Number__c,
                Final_Offered_Number__c,
                PowerCurve_Offered_Number__c,
                Adjusted_Number__c,
                Adjusted_Date__c,
                Existing_Account_Date__c,
                Final_Offered_Date__c,
                PowerCurve_Offered_Date__c,
                toLabel(Adjusted_by_Sanctioner_Picklist__c) sancpick,
                Requested__c,
                Requested_Number__c,
                Requested_Date__c
                FROM Terms_Of_Business__r
            )
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId AND Application_Product_Parent__c = NULL
        ];
        //List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProducts(appPrdList) ; ,  //selector for tob based on products
        
        Map<Id, List<Terms_Of_Business__c>> prodTobmap = new Map<Id, List<Terms_Of_Business__c>>();
        List<Terms_Of_Business__c> tobList;
        
        //in future add check of term loan or over draft
        
        //Added By Himanshu Nimje : PMD issue Avoid Ops in Loop
        Map<String, Application_Product__c> childWithParentProductMap = new Map<String, Application_Product__c>();
        List<Application_Product__c> childappProdList = [
            SELECT
            id,
            name,
            Product_Amount__c,
            Overdraft_Purpose__c,
            Campaign_Code__c,
            Limit_Type__c,
            Application_Product_Parent__c,
            Secured_By_Mortgage_Bond__c,
            Asset_Value__c,
            Annual_Turnover__c
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId AND Application_Product_Parent__c != NULL
        ];
        if (childappProdList != null || !childappProdList.isEmpty()) {
            for (Application_Product__c apc : childappProdList) {
                childWithParentProductMap.put(apc.Application_Product_Parent__c, apc);
            }
        }
        //End by Himanshu Nimje
        
        for (Application_Product__c appProd : ProductList) {
            if (appProd.Terms_Of_Business__r != null) {
                String accountNumber;
                if (appProd.Product_State__c == 'New') {
                    accountNumber = appProd.Temp_Account_Number__c;
                } else {
                    accountNumber = '' + appProd.Account_Number__c;
                }
                
                Application_Product__c childappProd = childWithParentProductMap.get(appProd.id); //Added by Himanshu Nimje
                
                //if(!appProd.Terms_Of_Business__r.isEmpty() && appProd.Terms_Of_Business__r.size()>0){
                ProductTOB ptob = new ProductTOB();
                //  ptob.DescriptionWithFieldType = new Map<String,String>();
                ptob.appProdId = appProd.Id;
                
                ptob.appProduct = appProd;
                ptob.appProductLabel = 'Overdraft Faciltiy' + '-' + appProd.Product_State__c + ' ' + accountNumber + '-' + appProd.Product_Status__c;
                
                ptob.ChequeAccountNumber = appProd.Temp_Account_Number__c;
                ptob.ProductType = '' + (appProd.get('producttype')!=null?appProd.get('producttype'):'');
                ptob.PurposeofOverdraft = '' + (childappProd?.Overdraft_Purpose__c!=null?childappProd.Overdraft_Purpose__c:'');
                //ptob.ApplicantRisk = childappProd. ;
                ptob.ReviewDate = appProd.Review_Date__c;
                ptob.ExpiryDate = appProd.Expiry_Date__c;
                ptob.CampaignCode = childappProd?.Campaign_Code__c;
                ptob.NCAAppplicable = appProd.NCA_Appplicable__c;
                ptob.MaximumNCARateType = NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c) == ''
                    ? appProd.Maximum_NCA_Rate_Type__c
                    : NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c);
                ptob.MaximumNCARate = appProd.Maximum_NCA_Rate__c;
                
                if (childappProd?.Secured_By_Mortgage_Bond__c == true) {
                    appProd.Agreement_Category__c = 'Large Agreement';
                    ptob.AgreementCategory = 'Large Agreement';
                } else {
                    if (childappProd?.Product_Amount__c < 15000 && childappProd?.Product_Amount__c > 0) {
                        appProd.Agreement_Category__c = 'Small Agreement';
                        ptob.AgreementCategory = 'Small Agreement';
                    } else if (childappProd?.Product_Amount__c >= 15000 && childappProd?.Product_Amount__c < 250000) {
                        appProd.Agreement_Category__c = 'Intermediate Agreement';
                        ptob.AgreementCategory = 'Intermediate Agreement';
                    } else if (childappProd?.Product_Amount__c >= 250000) {
                        appProd.Agreement_Category__c = 'Large Agreement';
                        ptob.AgreementCategory = 'Large Agreement';
                    }
                }
                String limitValue;
                
                for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                    if (tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')) {
                        if (tob.Tob_Description__c == 'Overdraft Limit Type') {
                            if (
                                tob.Offered_by_Powercurve__c != null &&
                                (tob.Offered_by_Powercurve__c.containsIgnoreCase('Reducing') || tob.Offered_by_Powercurve__c.containsIgnoreCase('Variable'))
                            ) {
                                
                                limitValue = tob.Offered_by_Powercurve__c;
                                //system.debug('limitValue offered---'+limitValue);
                            } else if ( String.valueOf(tob.get('sancpick')) != null  ) {
                                limitValue = '' + tob.get('sancpick');
                               // system.debug('limitValue sanctioning---'+limitValue);
                            } else if (appProd.Product_State__c.equalsIgnoreCase('New')) {
                                limitValue = tob.Requested__c;
                                //system.debug('limitValue new---'+limitValue);
                            } else {
                                limitValue = tob.Requested__c;
                                //system.debug('limitValue existing---'+limitValue);
                            }
                            
                            ptob.limitType = limitValue; //!=''?limitValue : tob.Adjusted_by_Sanctioner_Picklist__c ;
                        }
                        ptob.termstobList.add(tob);
                    } else if (tob.TOB_Classification__c.equalsIgnoreCase('Additional Info')) {
                        ptob.additionaltobList.add(tob);
                    } else if (tob.TOB_Classification__c.equalsIgnoreCase('Pricing And Fees')) {
                        ptob.pricingtobList.add(tob);
                    }
                }
                //ptob.tobList = prodTobmap.get(appProdId);
                productTOBList.add(ptob);
            }
        }
        return productTOBList;
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @param appProdId
**/
    public static void updateDeclineTOB(Id appProdId) {
        List<Terms_Of_Business__c> tobList = [
            SELECT
            id,
            Application_Product__c,
            TOB_Classification__c,
            Tob_Description__c,
            Application_Product__r.Product_Status__c,
            Adjusted_by_Sanctioner__c,
            Comments__c,
            Existing_Account__c,
            Final_Offered__c,
            Offered_by_Powercurve__c,
            Requested_Amount__c,
            Existing_Account_Number__c,
            Final_Offered_Number__c,
            PowerCurve_Offered_Number__c,
            Adjusted_Number__c,
            Adjusted_Date__c,
            Existing_Account_Date__c,
            Final_Offered_Date__c,
            PowerCurve_Offered_Date__c,
            toLabel(Adjusted_by_Sanctioner_Picklist__c) sancpick,
            Requested__c,
            toLabel(Adjusted_By_Sanctioner_Frequency__c) sancFreq,
            Requested_Number__c,
            Requested_Date__c
            FROM Terms_Of_Business__c
            WHERE Application_Product__c = :appProdId
        ];
        
        List<Terms_Of_Business__c> tobList1 = new List<Terms_Of_Business__c>();
        String limitValue;
        for (Terms_Of_Business__c tob : tobList) {
            if (tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit Type')) {
                tob.Final_Offered__c = null;
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit')) {
                tob.Final_Offered_Number__c = 0;
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
                tob.Final_Offered_Number__c = 0;
                tob.Adjusted_Number__c = 0;
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')) {
                tob.Final_Offered_Date__c = null;
                tob.Adjusted_Date__c = null;
            }
            
            if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
                tob.Final_Offered_Number__c = 0;
                tob.Adjusted_Number__c = 0;
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')) {
                tob.Final_Offered_Date__c = null;
                tob.Adjusted_Date__c = null;
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')) {
                tob.Final_Offered__c = ''; //tob.Adjusted_By_Sanctioner_Frequency__c ;
            }
            if (
                tob.Tob_Description__c == 'Variable Amount 1' ||
                tob.Tob_Description__c == 'Variable Amount 2' ||
                tob.Tob_Description__c == 'Variable Amount 3' ||
                tob.Tob_Description__c == 'Variable Amount 4' ||
                tob.Tob_Description__c == 'Variable Amount 5' ||
                tob.Tob_Description__c == 'Variable Amount 6' ||
                tob.Tob_Description__c == 'Variable Amount 7' ||
                tob.Tob_Description__c == 'Variable Amount 8' ||
                tob.Tob_Description__c == 'Variable Amount 9' ||
                tob.Tob_Description__c == 'Variable Amount 10' ||
                tob.Tob_Description__c == 'Variable Amount 11' ||
                tob.Tob_Description__c == 'Variable Amount 12'
            ) {
                tob.Final_Offered_Number__c = 0;
                tob.Adjusted_Number__c = 0;
            }
            
            if (
                (tob.Tob_Description__c == 'Variable Date 1' ||
                 tob.Tob_Description__c == 'Variable Date 2' ||
                 tob.Tob_Description__c == 'Variable Date 3' ||
                 tob.Tob_Description__c == 'Variable Date 4' ||
                 tob.Tob_Description__c == 'Variable Date 5' ||
                 tob.Tob_Description__c == 'Variable Date 6' ||
                 tob.Tob_Description__c == 'Variable Date 7' ||
                 tob.Tob_Description__c == 'Variable Date 8' ||
                 tob.Tob_Description__c == 'Variable Date 9' ||
                 tob.Tob_Description__c == 'Variable Date 10' ||
                 tob.Tob_Description__c == 'Variable Date 11' ||
                 tob.Tob_Description__c == 'Variable Date 12')
            ) {
                tob.Final_Offered_Date__c = null;
                tob.Adjusted_Date__c = null;
            }
            
            if (tob.Tob_Description__c.equalsIgnoreCase('Limit')) { // added for credit card
                tob.Final_Offered_Number__c = 0;
                tob.Adjusted_Number__c = 0;
            }
        }
        
        try {
            update tobList;
            // update tobList1;
        } catch (Exception e) {
            AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());
 
        }
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @param appProdId
* @return String
**/
    @auraEnabled
    public static String saveTOB(Id appProdId) {
        List<Terms_Of_Business__c> tobList = [
            SELECT
            id,
            Application_Product__c,
            TOB_Classification__c,
            Tob_Description__c,
            Application_Product__r.Product_Status__c,
            Adjusted_by_Sanctioner__c,
            Comments__c,
            Existing_Account__c,
            Final_Offered__c,
            Offered_by_Powercurve__c,
            Requested_Amount__c,
            Existing_Account_Number__c,
            Final_Offered_Number__c,
            PowerCurve_Offered_Number__c,
            Adjusted_Number__c,
            Adjusted_Date__c,
            Existing_Account_Date__c,
            Final_Offered_Date__c,
            PowerCurve_Offered_Date__c,
            toLabel(Adjusted_by_Sanctioner_Picklist__c) sancpick,
            Requested__c,
            toLabel(Adjusted_By_Sanctioner_Frequency__c) sancFreq,
            Requested_Number__c,
            Requested_Date__c,
            Application_Product__r.Product_Name__c
            FROM Terms_Of_Business__c
            WHERE Application_Product__c = :appProdId AND Application_Product__r.Product_Status__c = 'Accepted'
        ];
        
        List<Terms_Of_Business__c> tobList1 = new List<Terms_Of_Business__c>();
        String limitValue;
        Application_product__c appProd = new Application_product__c(Id=appProdId);
        
        for (Terms_Of_Business__c tob : tobList) {
            if (tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit')) {
                tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit Type')) {
                tob.Final_Offered__c = tob.get('sancpick') == null ? tob.Final_Offered__c : '' + tob.get('sancpick');
                limitValue = tob.get('sancpick') == null ? null : '' + tob.get('sancpick');
            }
            if (tob.Tob_Description__c.equalsIgnoreCase('Limit')) { // added for credit card
                tob.Final_Offered__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered__c : String.valueOf(tob.Adjusted_Number__c);
                appProd.Product_Amount__c = tob.Adjusted_Number__c;
            }
        }
        
        // update tobList;
        for (Terms_Of_Business__c tob : tobList) {
            if(tob.Application_Product__r.product_Name__c =='Cheque'){
            
       

            if (limitValue != null) {
                if (limitValue.equalsIgnoreCase('Fixed')) {
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')) {
                        tob.Final_Offered__c = ''; //tob.Adjusted_By_Sanctioner_Frequency__c ;
                    }
                    if (
                        tob.Tob_Description__c == 'Variable Amount 1' ||
                        tob.Tob_Description__c == 'Variable Amount 2' ||
                        tob.Tob_Description__c == 'Variable Amount 3' ||
                        tob.Tob_Description__c == 'Variable Amount 4' ||
                        tob.Tob_Description__c == 'Variable Amount 5' ||
                        tob.Tob_Description__c == 'Variable Amount 6' ||
                        tob.Tob_Description__c == 'Variable Amount 7' ||
                        tob.Tob_Description__c == 'Variable Amount 8' ||
                        tob.Tob_Description__c == 'Variable Amount 9' ||
                        tob.Tob_Description__c == 'Variable Amount 10' ||
                        tob.Tob_Description__c == 'Variable Amount 11' ||
                        tob.Tob_Description__c == 'Variable Amount 12'
                    ) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    
                    if (
                        (tob.Tob_Description__c == 'Variable Date 1' ||
                         tob.Tob_Description__c == 'Variable Date 2' ||
                         tob.Tob_Description__c == 'Variable Date 3' ||
                         tob.Tob_Description__c == 'Variable Date 4' ||
                         tob.Tob_Description__c == 'Variable Date 5' ||
                         tob.Tob_Description__c == 'Variable Date 6' ||
                         tob.Tob_Description__c == 'Variable Date 7' ||
                         tob.Tob_Description__c == 'Variable Date 8' ||
                         tob.Tob_Description__c == 'Variable Date 9' ||
                         tob.Tob_Description__c == 'Variable Date 10' ||
                         tob.Tob_Description__c == 'Variable Date 11' ||
                         tob.Tob_Description__c == 'Variable Date 12')
                    ) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                }
                
                if (limitValue.equalsIgnoreCase('Reducing - Once Off Only')) {
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
                        tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')) {
                        tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                    }
                    
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')) {
                        tob.Final_Offered__c = ''; //tob.Adjusted_By_Sanctioner_Frequency__c ;
                    }
                    if (
                        tob.Tob_Description__c == 'Variable Amount 1' ||
                        tob.Tob_Description__c == 'Variable Amount 2' ||
                        tob.Tob_Description__c == 'Variable Amount 3' ||
                        tob.Tob_Description__c == 'Variable Amount 4' ||
                        tob.Tob_Description__c == 'Variable Amount 5' ||
                        tob.Tob_Description__c == 'Variable Amount 6' ||
                        tob.Tob_Description__c == 'Variable Amount 7' ||
                        tob.Tob_Description__c == 'Variable Amount 8' ||
                        tob.Tob_Description__c == 'Variable Amount 9' ||
                        tob.Tob_Description__c == 'Variable Amount 10' ||
                        tob.Tob_Description__c == 'Variable Amount 11' ||
                        tob.Tob_Description__c == 'Variable Amount 12'
                    ) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    
                    if (
                        (tob.Tob_Description__c == 'Variable Date 1' ||
                         tob.Tob_Description__c == 'Variable Date 2' ||
                         tob.Tob_Description__c == 'Variable Date 3' ||
                         tob.Tob_Description__c == 'Variable Date 4' ||
                         tob.Tob_Description__c == 'Variable Date 5' ||
                         tob.Tob_Description__c == 'Variable Date 6' ||
                         tob.Tob_Description__c == 'Variable Date 7' ||
                         tob.Tob_Description__c == 'Variable Date 8' ||
                         tob.Tob_Description__c == 'Variable Date 9' ||
                         tob.Tob_Description__c == 'Variable Date 10' ||
                         tob.Tob_Description__c == 'Variable Date 11' ||
                         tob.Tob_Description__c == 'Variable Date 12')
                    ) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    toblist1.add(tob);
                }
                if (limitValue.equalsIgnoreCase('Reducing - Once Off And Recurring')) {
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
                        tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')) {
                        tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
                        tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')) {
                        tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')) {
                        tob.Final_Offered__c = '' + tob.get('sancFreq'); //tob.Adjusted_By_Sanctioner_Frequency__c ;
                    }
                    if (
                        tob.Tob_Description__c == 'Variable Amount 1' ||
                        tob.Tob_Description__c == 'Variable Amount 2' ||
                        tob.Tob_Description__c == 'Variable Amount 3' ||
                        tob.Tob_Description__c == 'Variable Amount 4' ||
                        tob.Tob_Description__c == 'Variable Amount 5' ||
                        tob.Tob_Description__c == 'Variable Amount 6' ||
                        tob.Tob_Description__c == 'Variable Amount 7' ||
                        tob.Tob_Description__c == 'Variable Amount 8' ||
                        tob.Tob_Description__c == 'Variable Amount 9' ||
                        tob.Tob_Description__c == 'Variable Amount 10' ||
                        tob.Tob_Description__c == 'Variable Amount 11' ||
                        tob.Tob_Description__c == 'Variable Amount 12'
                    ) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    
                    if (
                        (tob.Tob_Description__c == 'Variable Date 1' ||
                         tob.Tob_Description__c == 'Variable Date 2' ||
                         tob.Tob_Description__c == 'Variable Date 3' ||
                         tob.Tob_Description__c == 'Variable Date 4' ||
                         tob.Tob_Description__c == 'Variable Date 5' ||
                         tob.Tob_Description__c == 'Variable Date 6' ||
                         tob.Tob_Description__c == 'Variable Date 7' ||
                         tob.Tob_Description__c == 'Variable Date 8' ||
                         tob.Tob_Description__c == 'Variable Date 9' ||
                         tob.Tob_Description__c == 'Variable Date 10' ||
                         tob.Tob_Description__c == 'Variable Date 11' ||
                         tob.Tob_Description__c == 'Variable Date 12')
                    ) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    toblist1.add(tob);
                }
                if (limitValue.equalsIgnoreCase('Reducing - Recurring Only')) {
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
                        tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')) {
                        tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                    }
                    if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')) {
                        tob.Final_Offered__c = '' + tob.get('sancFreq'); //tob.Adjusted_By_Sanctioner_Frequency__c ;
                    }
                    
                    if (
                        tob.Tob_Description__c == 'Variable Amount 1' ||
                        tob.Tob_Description__c == 'Variable Amount 2' ||
                        tob.Tob_Description__c == 'Variable Amount 3' ||
                        tob.Tob_Description__c == 'Variable Amount 4' ||
                        tob.Tob_Description__c == 'Variable Amount 5' ||
                        tob.Tob_Description__c == 'Variable Amount 6' ||
                        tob.Tob_Description__c == 'Variable Amount 7' ||
                        tob.Tob_Description__c == 'Variable Amount 8' ||
                        tob.Tob_Description__c == 'Variable Amount 9' ||
                        tob.Tob_Description__c == 'Variable Amount 10' ||
                        tob.Tob_Description__c == 'Variable Amount 11' ||
                        tob.Tob_Description__c == 'Variable Amount 12'
                    ) {
                        tob.Final_Offered_Number__c = 0;
                        tob.Adjusted_Number__c = 0;
                    }
                    
                    if (
                        (tob.Tob_Description__c == 'Variable Date 1' ||
                         tob.Tob_Description__c == 'Variable Date 2' ||
                         tob.Tob_Description__c == 'Variable Date 3' ||
                         tob.Tob_Description__c == 'Variable Date 4' ||
                         tob.Tob_Description__c == 'Variable Date 5' ||
                         tob.Tob_Description__c == 'Variable Date 6' ||
                         tob.Tob_Description__c == 'Variable Date 7' ||
                         tob.Tob_Description__c == 'Variable Date 8' ||
                         tob.Tob_Description__c == 'Variable Date 9' ||
                         tob.Tob_Description__c == 'Variable Date 10' ||
                         tob.Tob_Description__c == 'Variable Date 11' ||
                         tob.Tob_Description__c == 'Variable Date 12')
                    ) {
                        tob.Final_Offered_Date__c = null;
                        tob.Adjusted_Date__c = null;
                    }
                    toblist1.add(tob);
                }
                if (limitValue.equalsIgnoreCase('Variable')) {
                    if (
                        tob.Tob_Description__c == 'Variable Amount 1' ||
                        tob.Tob_Description__c == 'Variable Amount 2' ||
                        tob.Tob_Description__c == 'Variable Amount 3' ||
                        tob.Tob_Description__c == 'Variable Amount 4' ||
                        tob.Tob_Description__c == 'Variable Amount 5' ||
                        tob.Tob_Description__c == 'Variable Amount 6' ||
                        tob.Tob_Description__c == 'Variable Amount 7' ||
                        tob.Tob_Description__c == 'Variable Amount 8' ||
                        tob.Tob_Description__c == 'Variable Amount 9' ||
                        tob.Tob_Description__c == 'Variable Amount 10' ||
                        tob.Tob_Description__c == 'Variable Amount 11' ||
                        tob.Tob_Description__c == 'Variable Amount 12'
                    ) {
                        tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                    }
                    
                    if (
                        (tob.Tob_Description__c == 'Variable Date 1' ||
                         tob.Tob_Description__c == 'Variable Date 2' ||
                         tob.Tob_Description__c == 'Variable Date 3' ||
                         tob.Tob_Description__c == 'Variable Date 4' ||
                         tob.Tob_Description__c == 'Variable Date 5' ||
                         tob.Tob_Description__c == 'Variable Date 6' ||
                         tob.Tob_Description__c == 'Variable Date 7' ||
                         tob.Tob_Description__c == 'Variable Date 8' ||
                         tob.Tob_Description__c == 'Variable Date 9' ||
                         tob.Tob_Description__c == 'Variable Date 10' ||
                         tob.Tob_Description__c == 'Variable Date 11' ||
                         tob.Tob_Description__c == 'Variable Date 12')
                    ) {
                        tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                    }
                    
                    toblist1.add(tob);
                }
            } else if (limitValue == null) {
                if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
                    tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                }
                if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')) {
                    tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                }
                
                if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
                    tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                }
                if (tob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')) {
                    tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                }
               
                if (
                    tob.Tob_Description__c == 'Variable Amount 1' ||
                    tob.Tob_Description__c == 'Variable Amount 2' ||
                    tob.Tob_Description__c == 'Variable Amount 3' ||
                    tob.Tob_Description__c == 'Variable Amount 4' ||
                    tob.Tob_Description__c == 'Variable Amount 5' ||
                    tob.Tob_Description__c == 'Variable Amount 6' ||
                    tob.Tob_Description__c == 'Variable Amount 7' ||
                    tob.Tob_Description__c == 'Variable Amount 8' ||
                    tob.Tob_Description__c == 'Variable Amount 9' ||
                    tob.Tob_Description__c == 'Variable Amount 10' ||
                    tob.Tob_Description__c == 'Variable Amount 11' ||
                    tob.Tob_Description__c == 'Variable Amount 12'
                ) {
                    tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ? tob.Final_Offered_Number__c : tob.Adjusted_Number__c;
                }
                
                if (
                    (tob.Tob_Description__c == 'Variable Date 1' ||
                     tob.Tob_Description__c == 'Variable Date 2' ||
                     tob.Tob_Description__c == 'Variable Date 3' ||
                     tob.Tob_Description__c == 'Variable Date 4' ||
                     tob.Tob_Description__c == 'Variable Date 5' ||
                     tob.Tob_Description__c == 'Variable Date 6' ||
                     tob.Tob_Description__c == 'Variable Date 7' ||
                     tob.Tob_Description__c == 'Variable Date 8' ||
                     tob.Tob_Description__c == 'Variable Date 9' ||
                     tob.Tob_Description__c == 'Variable Date 10' ||
                     tob.Tob_Description__c == 'Variable Date 11' ||
                     tob.Tob_Description__c == 'Variable Date 12')
                ) {
                    tob.Final_Offered_Date__c = tob.Adjusted_Date__c == null ? tob.Final_Offered_Date__c : tob.Adjusted_Date__c;
                }
            }
            }     
        }
        
        try {
            update tobList;
            // update tobList1;
            update appProd;
        } catch (Exception e) {
            AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

        }
        return 'success';
    }
    
    /**
* @description W-011426 - CC
* @author Almas Aleem | 2021-06-12
**/
    public class ProductTOB {
        @auraEnabled
        public Id appProdId;
        @auraEnabled
        public Application_Product__c appProduct;
        @auraEnabled
        public String ChequeAccountNumber;
        @auraEnabled
        public String ProductType;
        @auraEnabled
        public String PurposeofOverdraft;
        @auraEnabled
        public String ApplicantRisk;
        @auraEnabled
        public Date ReviewDate;
        @auraEnabled
        public Date ExpiryDate;
        @auraEnabled
        public String CampaignCode;
        @auraEnabled
        public String NCAAppplicable;
        @auraEnabled
        public String MaximumNCARateType;
        @auraEnabled
        public String MaximumNCARate;
        @auraEnabled
        public String AgreementCategory;
        @auraEnabled
        public String appProductLabel;
        @auraEnabled
        public Boolean isaccepted;
        @auraEnabled 
        public String NCAQuoteReq; //Added for W-013202
        @auraEnabled
        public Boolean isacceptedApplicationLevel;
        // @auraEnabled public List<appProdHistory> appProductHistory;
        @auraEnabled
        public String limitType;
        
        @auraEnabled
        public List<Terms_Of_Business__c> termstobList;
        @auraEnabled
        public List<Terms_Of_Business__c> pricingtobList;
        @auraEnabled
        public List<Terms_Of_Business__c> additionaltobList;
        /**
* @description W-011426 - CC
* @author Almas Aleem | 2021-06-12
**/
        public ProductTOB() {
            this.termstobList = new List<Terms_Of_Business__c>();
            this.pricingtobList = new List<Terms_Of_Business__c>();
            this.additionaltobList = new List<Terms_Of_Business__c>();
            // this.appProductHistory = new List<appProdHistory>() ;
            this.appProduct = new Application_Product__c();
        }
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @param prodId
**/
    @auraEnabled
    public static void submitDecisionHistory(Id prodId) {
        Decision_History__c history = new Decision_History__c();
        
        Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(prodId);
        history.Application_Product__c = prodId;
        history.Comments__c = appProd.Approve_Comment__c;
        // history.Status__c = appProd.Product_Status__c;
        history.Decision__c = appProd.Product_Status__c;
        history.Sanctioner__c = userInfo.getUserId();
        
        try {
            insert history;
            
            //update the accepted product to finals
            // saveTOB(prodId);
        } catch (DMLException e) {
            AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

        }
    }
    
    /**
* @description
* @author Almas Aleem | 2021-06-12
* @param prodId
* @return List<Decision_History__c>
**/
    @auraEnabled
    public static List<Decision_History__c> getProductDecisionHistory(Id prodId) {
        List<Decision_History__c> decisionList = [
            SELECT Id, Application_Product__c, Outcome__c, Decision__c, CreatedById, Comments__c, Sanctioner__c, Sanctioner__r.Name, CreatedDate
            FROM Decision_History__c
            WHERE Application_Product__c = :prodId
            ORDER BY createdDate DESC
        ];
        
        return decisionList; //appProdHistoryList;
    }
    
    /**
	 * @description TranslatePicklist
	 * @author  Gulafsha | 2021-06-23
	 * @param objectName
	 * @param fieldName
	 * @return Map<String,String>
	 **/
    @auraEnabled
    public static Map<String,String> TranslatePicklist(SObject objectName, String fieldName){
        Map<String,String> mp=new map<string,string>();
        Schema.DescribeFieldResult fieldResult = objectName.getSObjectType().getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> plEntryList = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry plEntry : plEntryList) {
            if (plEntry.active) {
                mp.put(plEntry.value, plEntry.label);
            }
        }
       
        return mp;
    }
    
      /**
* @description
* @author almas.aleem@absa.africa | 2021-08-03
* @param oppId
* @return List<ProductTOB>
**/
    @auraEnabled
    public static List<LDPproductTOB> getTOBProductsForLDP(Id oppId){
         
        List<LDPproductTOB> LDPproductTOBList = new List<LDPproductTOB>();
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
       /* Application_scoring__c appScore = [
            SELECT Id, OD_Applicant_Risk__c
            FROM application_scoring__c
            WHERE stage__c = '6' AND Application_Number__c = :app.Id
        ];*/
        
        List<Application_Product__c> ProductList = [
            SELECT
            id,
            Name,
            Application__r.Credit_Application_Accepted__c,
            Product_Name__c,
            Account_Number__c,
            Product_Amount__c,
            Product_State__c,
            Product_Status__c,
            Limit_Type__c,
            Temp_Account_Number__c,
            Agreement_Category__c,
            Campaign_Code__c,
            toLabel(Product_Type__c) producttype,
            Review_Date__c,
            Accept_TOB__c,
            Expiry_Date__c,
            Secured_By_Mortgage_Bond__c,
            NCA_Appplicable__c,
            Maximum_NCA_Rate_Type__c,
            Maximum_NCA_Rate__c,
            NCA_Quote_Required__c,Facility_account_number__c,
            (
                SELECT
                id,
                Application_Product__c,
                TOB_Classification__c,
                Tob_Description__c,
                Existing_Account__c,
                Requested__c,
                Offered_by_Powercurve__c,
                Final_Offered__c
                FROM Terms_Of_Business__r
            )
            FROM Application_Product__c
            WHERE Opportunity__c = :oppId AND Product_Name__c = 'Bank Guarantee'
        ];
        
        
        for (Application_Product__c appProd : ProductList) {
            // if(appProd.Terms_Of_Business__r  !=null){ remove after testing
            String accountNumber;
            if (appProd.Product_State__c == 'New') {
                accountNumber = appProd.Temp_Account_Number__c;
            } else {
                accountNumber = '' + appProd.Facility_account_number__c;
            }
            
            LDPproductTOB ptob = new LDPproductTOB();
            ptob.appProdId = appProd.Id;
            ptob.appProduct = appProd;
            ptob.appProductLabel = 'Bank Guarantee' + '-' + appProd.Product_State__c + ' ' + accountNumber + '-' + appProd.Product_Status__c;
            ptob.LDPAccountNumber = appProd.Temp_Account_Number__c;
          ptob.LDPAccountNumber = appProd.Temp_Account_Number__c;
           
             ptob.NCAAppplicable = appProd.NCA_Appplicable__c; //'Out Of NCA';//appProd.NCA_Appplicable__c;
            ptob.MaximumNCARateType = NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c) == ''
                ? appProd.Maximum_NCA_Rate_Type__c
                : NCAratetypeTranslator(appProd.Maximum_NCA_Rate_Type__c);
            ptob.MaximumNCARate = appProd.Maximum_NCA_Rate__c;
            ptob.NCAQuoteReq = appProd.NCA_Quote_Required__c; 
             
            if (appProd.Secured_By_Mortgage_Bond__c == true) {
                appProd.Agreement_Category__c = 'Large Agreement';
                ptob.AgreementCategory = 'Large Agreement';
            } else {
                if (appProd.Product_Amount__c < 15000 && appProd.Product_Amount__c > 0) {
                    //Need to check Product amount for CC
                    appProd.Agreement_Category__c = 'Small Agreement';
                    ptob.AgreementCategory = 'Small Agreement';
                } else if (appProd.Product_Amount__c >= 15000 && appProd.Product_Amount__c < 250000) {
                    appProd.Agreement_Category__c = 'Intermediate Agreement';
                    ptob.AgreementCategory = 'Intermediate Agreement';
                } else if (appProd.Product_Amount__c >= 250000) {
                    appProd.Agreement_Category__c = 'Large Agreement';
                    ptob.AgreementCategory = 'Large Agreement';
                }
            }
            
            
           
                  for (Terms_Of_Business__c tob : appProd.Terms_Of_Business__r) {
                if (tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')) {
                    ptob.TOBList.add(tob);
                }
            }
            
            LDPproductTOBList.add(ptob);
            //}
        }
        
        return LDPproductTOBList;
    }
    
/**
* @description  LDP
* @author Almas Aleem | 2021-06-12
**/
public class LDPproductTOB{
    @auraEnabled
    public String appProductLabel;
    @auraEnabled
    public Id appProdId;
    @auraEnabled
    public Application_Product__c appProduct;
    @auraEnabled
    public String LDPAccountNumber;
    @auraEnabled
    public List<Terms_Of_Business__c> TOBList;
     @auraEnabled
    public String MaximumNCARateType;
    @auraEnabled
    public String NCAAppplicable;
    @auraEnabled
    public String MaximumNCARate;
    @auraEnabled 
    public String NCAQuoteReq; 
    @auraEnabled
    public String AgreementCategory;
    /**
* @description  LDP consturctor 
* @author Almas Aleem | 2021-06-12
**/
     public LDPproductTOB() {
        this.TOBList= new List<Terms_Of_Business__c>();
        this.appProduct = new Application_Product__c();
    }
}
}