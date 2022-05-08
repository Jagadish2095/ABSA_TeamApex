/**
 * @description       : Apex Enterprise Design Patters OpportunityLineItmesSelector
 * @author            : Nelson Chisoko (Dariel)
**/
public class OpportunityLineItemsSelector extends fflib_SObjectSelector {

    /**
    * @description getSObjectType
    * @return Schema.SObjectType 
    **/

    
    public Schema.SObjectType getSObjectType() {
        return OpportunityLineItem.sObjectType;
    }

    /**
    * @description getSObjectFieldList
    * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {

            OpportunityLineItem.Id,
            OpportunityLineItem.PricebookEntryId,
            OpportunityLineItem.OpportunityId,
            OpportunityLineItem.Quantity,
            OpportunityLineItem.TotalPrice
            //OpportunityLineItem.Application__c

        };
    }

    /**
     * @description Returns all associated OpportunityLineItems
     * @param oppId     The Opportunity Id
     * @return  List<OpportunityLineItem>   A list of OpportunityLineItems
     */
    public List<OpportunityLineItem> selectByOpportunityId(Id oppId) {
        return Database.query(
            newQueryFactory().
            selectField('PricebookEntryId').
            selectField('OpportunityId').
            selectField('Quantity').
            selectField('TotalPrice').
            selectField('Application__c').
            selectField('Product2Id').
            selectField('Product2.Product_Classification__c').
            selectField('Product2.Price_Scheme_Code__c').
            selectField('Product2.Name').
            selectField('ProductCode').
            selectField('Name').
            selectField('UnitPrice').
            selectField('Account_Number__c').
            selectField('Product_Family__c').
            selectField('Policy_Number__c').
            selectField('Switches__c').
            selectField('FraudIndicator__c').
            selectField('Product_Name__c').
            selectField('Contact_Person__c').
            selectField('Application_Product_CAF__c').
            selectField('Fee_Structure_code__c').
            selectField('Opportunity.CreatedBy.Name').
            selectField('Vendor_Code__c').
            selectField('Id').
            selectField('Price_Scheme_Code__c').
            setCondition('OpportunityId =: oppId').
            toSOQL()
        );
    }

    /**
    * @description Returns  associated OpportunityLineItems
    * @param oppId     The Opportunity Id
    * @param recordLimit     recordLimit
    * @return  OpportunityLineItem Id
    * Added by Diksha
    */
    public OpportunityLineItem selectByOppId(Id oppId,Integer recordLimit) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Id').
            selectField('product2Id').
            selectField('ProductCode').
            selectField('Product2.Family').
            selectField('Product2.Name').
            selectField('Product2.ProductCode').//W-005411
            selectField('Product2.Primary_Service_Provider__r.Name').
            selectField('Opportunity.AccountId').
            selectField('Opportunity.Sys_ThreadId__c').
            selectField('Policy_number__c').
            selectField('Product_Name__c').
            selectField('Contact_Person__c').
            selectField('Application_Product_CAF__c').
            selectField('Opportunity.Income_Source__c').
            setCondition('OpportunityId =: oppId').
            setLimit(recordLimit).
            toSOQL()
        );
    }

    /**
    * PJAIN: 20200420
    *
    * @description Returns OpportunityLineItems by Id
    * @param opportunityLineItemId     The Opportunity Line Item Id
    * @return  OpportunityLineItems
    */
    public List<OpportunityLineItem> selectById(Id opportunityLineItemId) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Id').
            selectField('Quantity').
            selectField('Contract_Duration_Type__c').
            selectField('Contact_Person__c').
            selectField('Product_Name__c').
            selectField('policy_number__c').
            selectField('Product2.Name').
            selectField('Product2.ProductCode').
            selectField('Product2.Family').
            selectField('product2Id').
            selectField('ProductCode').
            selectField('Application_Product_CAF__c').
            selectField('Case_Number__c').
            selectField('UnitPrice'). //JQUEV 20200710
            selectField('Type_Extra__c').
            selectField('Other_Extra_Description__c').
            selectField('Financed_Amount__c').
            selectField('Article_Description__c').
            selectField('Additional_Fee_Amount__c').
            selectField('Parent_Opportunity_Line_Item_Id__c').
            selectField('Vendor_Code__c').
            selectField('Insurance_Company__c').
            selectField('Number_of_weeks_cover_selected__c').
            selectField('Rand_value_per_week__c').
            selectField('VAP_Premium__c').
            setCondition('Id =: opportunityLineItemId').
            toSOQL()
        );
    }

    /**
    * PJAIN: 20200414
    * @description Returns only Parent Opportunity Line Items associated with Opportunity Id
    * @param opportunityId      The Opportunity Id
    * @param recordLimit      The recordLimit
    * @return List<OpportunityLineItem> opportunityLineItems
    * Tinashe M Shoko - 01-06-2020 Added selectField('Contact_Person__c').
    * for Merchant Onboarding Deployment Plan - W-004546, W-004443, W-004834
	*/
    public List<OpportunityLineItem> selectParentLineItemsByOpportunityId(Id opportunityId, Integer recordLimit) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Investment_amount_R__c').
            selectField('Name').
            selectField('Quantity').
            selectField('Contract_Duration_Type__c').
            selectField('Merchant_Class__c'). // PJAIN: 20200522
            selectField('Product2Id').
            selectField('Product2.Name').
            selectField('Product2.Family').
            selectField('Product2.Product_Classification__c').
            selectField('Product2.Maximum_Quantity__c').
            selectField('Product2.Contract_Duration_Type__c').
            selectField('Opportunity.StageName').
            selectField('Opportunity.Quote_Number__c').
            selectField('Opportunity.Quote_Generation_Date__c').
            selectField('Opportunity.Quote_Status__c').
            selectField('Opportunity.AccountId').
            selectField('Opportunity.Account.Name').
            selectField('Opportunity.RecordTypeId'). // PJAIN: 20200530
            selectField('UnitPrice'). //JQUEV 20200710
            selectField('Contact_Person__c'). // Tinashe Shoko 20200602
            selectField('Policy_Number__c'). // Tinashe Shoko 20200602
            selectField('Signing_Instructions__c').
            selectField('Special_Instruction__c').
            selectField('Signing_Purpose__c').
            selectField('SigningAuthorityFromDate__c').
            selectField('In_terms_of_Resolution_date__c').
            selectField('Number_of_Signatories_for_account__c').
            selectField('Account_Opening_Date__c').
            selectField('Investment_amount_R__c').
            selectField('Price_Scheme_Code__c').
            setCondition('OpportunityId =: opportunityId AND Parent_Opportunity_Line_Item_Id__c = null').
            setLimit(recordLimit).
            toSOQL()
        );
    }

    /**
    * PJAIN: 20200420
    * @description Returns only Related Opportunity Line Items associated with Parent Opportunity Line Item Id
    * @param parentOpportunityLineItemId    The Opportunity Id
    * @return                               OpportunityLineItems
    */
    public List<OpportunityLineItem> selectRelatedLineItemsByParentId(Id parentOpportunityLineItemId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Product2Id').
            setCondition('Parent_Opportunity_Line_Item_Id__c =: parentOpportunityLineItemId').
            toSOQL()
        );
    }
    /**
     * Himani Joshi 2020-09-03
     * @description Returns only Parent Opportunity Line Items associated with specified Opportunity record type and product
     * @param opportunityRecordTypeName
     * @param productName
     * @return List<OpportunityLineItem>
     */
    public List<OpportunityLineItem> selectParentLinesByOppRecordTypeAndProduct(String opportunityRecordTypeName, String productName) {
        return Database.query(
            newQueryFactory()
                .selectField('Id')
                .selectField('OpportunityId')
                .selectField('Opportunity.Account.Name')
                .selectField('Opportunity.Website_URL__c')
                .setCondition('Opportunity.RecordType.Name =: opportunityRecordTypeName AND Product2.Name =: productName AND Parent_Opportunity_Line_Item_Id__c = NULL')
                .toSOQL()
        );
    }


    /**
     * @description Returns a list of OpportunityLineItem
     * @param oppListId List of opportunityIds
     * @return List<OpportunityLineItem>
     */
       public List<OpportunityLineItem> selectByListOfIds(List<Id> oppListId) {
        return Database.query(
            newQueryFactory()
                .selectField('PricebookEntryId')
                .selectField('OpportunityId')
                .selectField('Quantity')
                .selectField('TotalPrice')
                .selectField('Application__c')
                .selectField('Product2Id')
                .selectField('Product2.Product_Classification__c')
                .selectField('Product2.Name')
                .selectField('ProductCode')
                .selectField('Name')
                .selectField('UnitPrice')
                .selectField('Product_Family__c')
            	.selectField('Contact_Person__c')
                .selectField('policy_number__c')
                .selectField('Product_Name__c')
                .selectField('Fee_Structure_code__c')
            	.selectField('Opportunity.CIF_Number__c')
                .setCondition('Id IN: oppListId')
                .toSOQL()
        );
    }
    /**
    * Lesibe: 20210107
    * @description Returns OpportunityLineItems by Id
    * @param opportunityLineItemId     The Opportunity Line Item Id
    * @param type     The Opportunity Line Item type
    * @return List<OpportunityLineItem> OpportunityLineItems
    */
    public List<OpportunityLineItem> selectByIdAndType(Id opportunityLineItemId, String type) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Id').
            selectField('Quantity').
            selectField('Contract_Duration_Type__c').
            selectField('Contact_Person__c').
            selectField('Product_Name__c').
            selectField('policy_number__c').
            selectField('Product2.Name').
            selectField('Product2.ProductCode').
            selectField('Product2.Family').
            selectField('product2Id').
            selectField('ProductCode').
            selectField('UnitPrice'). //JQUEV 20200710
            selectField('Type_Extra__c').
            selectField('Additional_Fee_Amount__c').
            selectField('Parent_Opportunity_Line_Item_Id__c').
            selectField('Vendor_Code__c').
            selectField('Insurance_Company__c').
            selectField('Number_of_weeks_cover_selected__c').
            selectField('Rand_value_per_week__c').
            selectField('VAP_Premium__c').
            selectField('Product_name_Product_code__c').
            setCondition('Id =: opportunityLineItemId AND Type__c =: type').
            toSOQL()
        );
    }
    /**
    * @description Returns OpportunityLineItems by Id
    * @author Lesibe: 20210107
    * @param parentOppId The Opportunity Line Item parentOppId
    * @param type The Opportunity Line Item type
    * @return List<OpportunityLineItem> OpportunityLineItems
    **/
    public List<OpportunityLineItem> selectByParentOppIdAndType(Id parentOppId, String type) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Id').
            selectField('Quantity').
            selectField('Contract_Duration_Type__c').
            selectField('Contact_Person__c').
            selectField('Product_Name__c').
            selectField('policy_number__c').
            selectField('Product2.Name').
            selectField('Product2.ProductCode').
            selectField('Product2.Family').
            selectField('product2Id').
            selectField('ProductCode').
            selectField('UnitPrice'). //JQUEV 20200710
            selectField('Type_Extra__c').
            selectField('Additional_Fee_Amount__c').
            selectField('Parent_Opportunity_Line_Item_Id__c').
            selectField('Vendor_Code__c').
            selectField('Scheme_Code__c').
            selectField('Insurance_Company__c').
            selectField('Number_of_weeks_cover_selected__c').
            selectField('Rand_value_per_week__c').
            selectField('VAP_Premium__c').
            selectField('Product_name_Product_code__c').
            selectField('Extras_Quantity__c').
            selectField('VAPs_Quantity__c').
            selectField('Other_Extra_Description__c').
            setCondition('Parent_Opportunity_Line_Item_Id__c =: parentOppId AND Type__c =: type').
            toSOQL()
        );
    }
    /**
    * Lesibe: 20210107
    * @description Returns OpportunityLineItems by Id
    * @param oppId     The Opportunity Line Item parentOppId
    * @param type     The Opportunity Line Item type
    * @return List<OpportunityLineItem> OpportunityLineItems
    */
    public List<OpportunityLineItem> selectByOppIdAndType(String oppId, String type) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Article_Description__c').
            selectField('Financed_Amount__c').
            selectField('Extras_Quantity__c').
            selectField('VAPs_Quantity__c').
            selectField('Application_Product_CAF__c').
            selectField('Parent_Opportunity_Line_Item_Id__c').
            setCondition('OpportunityId =: oppId AND Type__c =: type').
            toSOQL()
        );
    }
     /**
     * @description Returns a list of opportunity list of Id
     * @param applicationProdCAF
     * @return OpportunityLineItem
     */
   public OpportunityLineItem byApplicationProductCAF(String applicationProdCAF) {
        return Database.query(
            newQueryFactory()
                .selectField('PricebookEntryId')
                .selectField('OpportunityId')
                .selectField('Quantity')
                .selectField('TotalPrice')
                .selectField('Application__c')
                .selectField('Product2Id')
                .selectField('Product2.Product_Classification__c')
                .selectField('Product2.Name')
                .selectField('ProductCode')
                .selectField('Name')
                .selectField('UnitPrice')
                .selectField('Id')
                .selectField('Product_Family__c')
                .selectField('Application_Product_CAF__c')
            	.selectField('Contact_Person__c')
                .selectField('policy_number__c')
                .selectField('Product_Name__c')
                .selectField('Fee_Structure_code__c')
            	.selectField('Opportunity.CIF_Number__c')
                .selectField('Opportunity.OwnerId')
                .selectField('Opportunity.AccountId')
                .selectField('Scheme_Code__c')
                .selectField('Application_number__c')
                .selectField('Case_Number__c')
                .selectField('Application_Product_CAF__r.Case__r.OwnerId')
                .selectField('Application_Product_CAF__r.Case__c')
                .selectField('Opportunity.OwnerId')
                .selectField('Opportunity.QA_Approver__r.Id')
                .selectField('Opportunity.QA_Approver__c')
                .selectField('Article_Description__c')
                .selectField('Financed_Amount__c')
                .selectField('Extras_Quantity__c')
                .selectField('VAPs_Quantity__c')
                .setCondition('Application_Product_CAF__c =: applicationProdCAF')
                .toSOQL()
        );
    }
     /**
    * @description selectBySPMOpp
    * @param oppId     SPM Opportunity ID
    * @param productName1     productName
    * @param productName2     productName
    * @return List<OpportunityLineItem> OpportunityLineItems
    */
    public List<OpportunityLineItem> selectBySPMOpp(String oppId, String productName1, String productName2) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Investment_Allocation__c').
            setCondition('OpportunityId =: oppId AND Investment_Allocation__c != NULL AND Name != :productName1 AND Name !=: productName2').
            toSOQL()
        );
    }
}