/**
* @description Selector Layer for Application_Product__c objects
* @author  Thabo K Senkoman
* @since   2020-05-19
* @update Englarmerdge Mongwe
* @dateUpdated 2020-08-24
* Changed Application_Product_Credit__c to Application_Product__c object
**/
public class ApplicationProductSelector  extends fflib_SObjectSelector {
    /**
* @description To get sObjectType
* @return sObjectType
**/
    public Schema.SObjectType getSObjectType() {
        return Application_Product__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet> { SObjectType.Application_Product__c.FieldSets.Application_Product_Finder_Compact_View };
    }
    /**
* @description To getSObjectFieldList
* @return sObjectFieldList
**/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Product__c.Id,
            Application_Product__c.Account_Balance__c,
            Application_Product__c.Account_Number__c,
            Application_Product__c.Agreement_Category__c,
            Application_Product__c.Alternative_Fund_Code__c,
            Application_Product__c.Alternative_Fund_Indicator__c,
            Application_Product__c.Annual_Turnover__c,
            Application_Product__c.Application_Product_Parent__c,
            Application_Product__c.Asset_Value__c,
            Application_Product__c.Campaign_Code__c,
            Application_Product__c.Current_Overdraft_Limit__c,
            Application_Product__c.Decision_Confirmation__c,
            Application_Product__c.Decline_Category__c,
            Application_Product__c.Decline_Reason__c,
            Application_Product__c.Enforced_Reducing_Limit__c,
            Application_Product__c.Expiry_Date__c,
            Application_Product__c.IsMainProduct__c,
            Application_Product__c.Limit_Type__c,
            Application_Product__c.Maximum_NCA_Rate__c,
            Application_Product__c.Maximum_NCA_Rate_Type__c,
            Application_Product__c.NCA_Appplicable__c,
            Application_Product__c.Once_Off_Amount__c,
            Application_Product__c.Once_Off_Date__c,
            Application_Product__c.Opportunity__c,
            Application_Product__c.Opportunity_Product_Id__c,
            Application_Product__c.Overdraft_Limit__c,
            Application_Product__c.Overdraft_Purpose__c,
            Application_Product__c.Overdraft_Purpose_Other__c,
            Application_Product__c.Product_Amount__c,
            Application_Product__c.Product_Name__c,
            Application_Product__c.Product_Type__c,
            Application_Product__c.Reduction_Amount__c,
            Application_Product__c.Reduction_Date__c,
            Application_Product__c.Reduction_Frequency__c,
            Application_Product__c.Regular_Payday__c,
            Application_Product__c.Review_Date__c,
            Application_Product__c.Review_Date__c,
            Application_Product__c.Overdraft_Limit_New_Amount__c,
            Application_Product__c.Sanctioning_Status__c,
            Application_Product__c.Scoring_required__c,
            Application_Product__c.Secured_By_Mortgage_Bond__c,
            Application_Product__c.Temp_Account_Number__c,
            Application_Product__c.Variable_Amount_1__c,
            Application_Product__c.Variable_Amount_10__c,
            Application_Product__c.Variable_Amount_11__c,
            Application_Product__c.Variable_Amount_12__c,
            Application_Product__c.Variable_Amount_2__c,
            Application_Product__c.Variable_Amount_3__c,
            Application_Product__c.Variable_Amount_4__c,
            Application_Product__c.Variable_Amount_5__c,
            Application_Product__c.Variable_Amount_6__c,
            Application_Product__c.Variable_Amount_7__c,
            Application_Product__c.Variable_Amount_8__c,
            Application_Product__c.Variable_Amount_9__c,
            Application_Product__c.Variable_Date_1__c,
            Application_Product__c.Variable_Date_10__c,
            Application_Product__c.Variable_Date_11__c,
            Application_Product__c.Variable_Date_12__c,
            Application_Product__c.Variable_Date_2__c,
            Application_Product__c.Variable_Date_3__c,
            Application_Product__c.Variable_Date_4__c,
            Application_Product__c.Variable_Date_5__c,
            Application_Product__c.Variable_Date_6__c,
            Application_Product__c.Variable_Date_7__c,
            Application_Product__c.Variable_Date_8__c,
            Application_Product__c.Variable_Date_9__c,
            Application_Product__c.Product_Status__c,
            Application_Product__c.Total_contract_balance__c,
            Application_Product__c.Parent_Application_Product_Status__c
                };
        }
     /**
* @description  Return list of Application Product details for corresponding Account Id
* Author : Saiteja
* Date : 2021-03-11
* @param accId
* @return list of Application product details
**/
public List<Application_Product__c> applicationProdRelatedToAcc(Id accId) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Product_Type__c').
            selectField('Account_Number__c').
            selectField('Application__r.Account__c').
            selectField('Application__r.Purpose_of_Account__c').
            selectField('Application__r.Transactional_Account__c'). 
            selectField('Application__r.Source_of_Funds_Savings__c').
            selectField('Application__r.Account__r.Expected_transactional_activity__c').
            setCondition('Application__r.Account__c = :accId').
            toSOQL()
        );
    }
/**
     * @description selectById description
     * ## idSet (Set<ID>): idSet
     * @param idSet
     * @return List<Application_Product__c>: Return description
     **/
        public List<Application_Product__c> selectById(Set<ID> idSet) {
        return (List<Application_Product__c>) selectSObjectsById(idSet);
    }
    public override String getOrderBy() {
        return 'CreatedDate ASC, Name';
    }
/**
     * @description selectByOpportunityId description
     *
     * ## opportunityId (Id): opportunityId
     * @param opportunityId
     * @return List<Application_Product__c>: Return description
     */
    public List<Application_Product__c> selectByOpportunityId(Id opportunityId) {
        List<Application_Product__c> appProdList ;
        String query = ' SELECT ';
        String field_name = null;

        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Application_Product__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();

        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }

        query = query.subStringBeforeLast(',');
        query += ' FROM Application_Product__c WHERE Opportunity__c =:opportunityId';

        appProdList = (List<Application_Product__c>)Database.query( query );

        return appProdList;
    }
    /**
     * @description selectIdsByOpportunityLineItemId description
     *
     * ## opportunityLineItemId (Id): opportunityLineItemId
     * @param opportunityLineItemId
     * @return List<Application_Product__c>: Return description
     **/
    public List<Application_Product__c> selectIdsByOpportunityLineItemId(Id opportunityLineItemId) {

        List<Application_Product__c> applicationProductList = [SELECT Id
                                                               FROM Application_Product__c
                                                               WHERE Opportunity_Product_Id__c =: opportunityLineItemId];

        return applicationProductList;
    }

    /**
     * @description  Application Product Based on Application Product Id
     * Author : Almas Aleem :Absa
     * Date : 2020-06-30
     * @param appCredId
     * @return Application Product
    **/
    public Application_Product__c selectApplicationProductById(String appCredId) {

        Application_Product__c appProd ;
        String query = ' SELECT ';
        String field_name = null;

        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Application_Product__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();

        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }

        query = query.subStringBeforeLast(',');
        query += ' FROM Application_Product__c WHERE Id =  \'' + appCredId + '\'';

        appProd = (Application_Product__c)Database.query( query );

        return appProd;
    }
    /**
     * @description Application Product Based on Account Number
     * Author : Englarmerdge Mongwe :Absa
     * Date : 2020-09-03
     * @param  accNumber
     * @return Application Product
    **/
    public Application_Product__c selectApplicationAccountNumber(Decimal accNumber) {
        return (Application_Product__c) Database.query(
            newQueryFactory().
            setCondition('Account_Number__c =: accNumber').
            toSOQL()
        );
    }
    
    /**
     * @description  Application Product Based on Application_Product_Parent__c
     * Author : Englarmerdge Mongwe :Absa
     * Date : 2020-09-03
     * @param  appPrdId
     * @return Application Product
    **/
    public Application_Product__c selectApplicationProductByParentId(String appPrdId) {
        return (Application_Product__c) Database.query(
            newQueryFactory().
            setCondition('Application_Product_Parent__c = :appPrdId').
            setLimit(1).
            toSOQL()
        );
    }
    
   /**
     * @description Application Product History Based on Application_Product_c Id
     * Author : Almas Aleem :Absa
     * Date : 2020-10-26
     * @param  appPrdList
     * @return Application Product History
    **/
    public List<Application_Product__History> selectApplicationProductHistory(List<Application_Product__c> appPrdList) {
        List<Application_Product__History> appProductHistory = [SELECT Id ,oldValue,newValue,parentId,Field ,CreatedById, CreatedDate FROM Application_Product__History WHERE parentId IN:appPrdList];
        return appProductHistory;
    }

    /**
     * @description Application Product History Based on Application_Product_c Id
     * Author : Almas Aleem :Absa
     * Date : 2020-10-26
     * @param appProdId 
     * @return Application Product History
    **/
    public List<Application_Product__History> selectApplicationProductHistoryById(Id appProdId) {
        List<Application_Product__History> appProductHistory = [SELECT Id ,Parent.Approve_Comment__c,oldValue,newValue,parentId,Field ,CreatedById, CreatedDate FROM Application_Product__History WHERE parentId =:appProdId];
        return appProductHistory;
    }

    /**
     * Danie Booysen
     * @description selectByOpportunityIdWithTOB description
     *
     * ## opportunityId (Id): opportunityId
     * ## queryTOB (Boolean): queryTOB
     * ## descriptionTOB (String): descriptionTOB
     * @param opportunityId  
     * @param  queryTOB 
     * @param   descriptionTOB
     * @return List<Application_Product__c>: Return description
     **/
    public List<Application_Product__c> selectByOpportunityIdWithTOB(Id opportunityId, Boolean queryTOB, String descriptionTOB) {

        List<Application_Product__c> appProdList = new List<Application_Product__c>();

        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Application_Product__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();
        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }
        if(queryTOB){
            String queryInner = ' ( SELECT ';
            String field_name_inner = null;
            Map< String, Schema.SObjectField > field_inner_oject_map = Schema.getGlobalDescribe().get('Terms_Of_Business__c').getDescribe().Fields.getMap();
            List<Schema.SObjectField> field_inner_object_values_map = field_inner_oject_map.values();
            for( Schema.SObjectField s : field_inner_object_values_map ){
                field_name_inner = s.getDescribe().getName();
                queryInner += field_name_inner + ', ';
            }
            queryInner = queryInner.subStringBeforeLast(',');
            queryInner += ' FROM Terms_Of_Business__r WHERE Tob_Description__c =:descriptionTOB )';
            query += queryInner;
        }else{
            query = query.subStringBeforeLast(',');
        }
        //query += ' FROM Application_Product__c WHERE Opportunity_Product_Id__c =  \'' + OpportunityLineItemList[0].Id + '\''+' ORDER By Product_Name__c DESC';
        query += ' FROM Application_Product__c WHERE Opportunity__c =:opportunityId ORDER By Product_Name__c DESC';

        appProdList = (List<Application_Product__c>)Database.query(query);
        return appProdList;
    }

    /**
     * @author Tinashe M Shoko
     * @description selectLinkedUniqueIDAndRefAccByOppId 
     *
     * ## opportunityId (Id): opportunityId
     * @param opportunityId
     * @return List<Application_Product__c>: Return description
     **/
    public List<Application_Product__c> selectLinkedUniqueIDAndRefAccByOppId(Id opportunityId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Temp_Account_Number__c').
            selectField('Account_Number__c').
            selectField('Current_Overdraft_Limit__c').
            selectField('Overdraft_Limit_New_Amount__c').
            selectField('Account_Balance__c').
            setCondition('Opportunity__c =: opportunityId AND IsMainProduct__c = false and Application_Product_Parent__c = null AND Account_Number__c != null'). //and Account_Balance__c != null
            toSOQL()
        );
    }

    /**
     * @description selectUniqueIentifiers 
     * ## opportunityId (Id): opportunityId
     * @param opportunityId
     * @return List<Application_Product__c>: Return description
     **/
    public List<Application_Product__c> selectUniqueIentifiers(Id opportunityId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Temp_Account_Number__c').
            selectField('Account_Number__c').
            setCondition('Opportunity__c =: opportunityId AND IsMainProduct__c = false and Application_Product_Parent__c = null AND Account_Number__c = null and Account_Balance__c = null').
            toSOQL()
        );
    }

    /**
     * Gulafsha
     * @description selectforCase 
     *
     * ## productid (String): productid
     * @param productid
     * @return List<Application_Product__c>: Return description
     **/
    public List<Application_Product__c> selectforCase(String productid) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Account_Number__c').
            selectField('Expiry_Date__c').
            selectField('Review_Date__c').
            selectField('Overdraft_Limit__c').
            selectField('Reduction_Amount__c').
            selectField('Enforced_Reducing_Limit__c').
            selectField('Action_Required__c').
            selectField('Reduction_Date__c').
            selectField('Reduction_Frequency__c').
            selectField('Once_Off_Amount__c').
            selectField('Once_Off_Date__c').
            selectField('Regular_Payday__c').
            selectField('Opportunity__c').
            selectField('Overdraft_Type__c').
            selectField('Annual_Turnover__c').
            selectField('Number_or_Trustees__c').
            selectField('Scoring_required__c').
            selectField('Debit_interest_Type__c').
            selectField('Initiation_Fee__c').
            selectField('Effective_Rate__c').
            selectField('Teller_Number__c').
            selectField('Asset_Value__c').
            selectField('Security_Cession_Indicator__c').
            selectField('Limit_Type__c').
            selectField('Debit_Order_Required__c').
            selectField('Alternative_Fund_Code__c').
            selectField('Domicible_Branch_Code__c').
            selectField('CCApplicationDetails__c').//added by Manish for W-011374
            selectField('Account_Name__c').//added by Manish for W-011374
            setCondition('Id =: productid').
            toSOQL()
        );
    }

    /**
    *@description Return Application Products Based on Opp Id
    *@Author : Manish :Absa
    *@Date : 2021-05-24
    *@param oppId oppId
    *@return List<Application_Product__c>
    */
    public List<Application_Product__c> selectApplicationProductByOppId(String oppId) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Product_Type__c').
            selectField('Management_Type_Managed_Code__c').
            selectField('Independent_Financial_Advisor__c').
            selectField('PRI_Number__c').
            selectField('Cash_accruals__c').
            selectField('Regular_withdrawal_amount_R__c').
            selectField('Frequency_of_payment_required__c').
            selectField('Other_special_requirements__c').
            setCondition('Opportunity__c =: oppId').
            toSOQL()
        );
    }

    /**
     * @description selectApplicationProductByproductName description
     *
     * @param oppId (String): oppId
     * @param productName (String): productName
     * @return List<Application_Product__c>: Return description
     */
    public List<Application_Product__c> selectApplicationProductByproductName(String oppId,String productName) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            setCondition('Opportunity__c =: oppId and Product_Name__c =:productName').
            toSOQL()
        );
    }
    /**
     * @description Return Application Products Based on Opp Id
     *
     * @param oppId (String): oppId
     * @return List<Application_Product__c>: Return description
     */
    public List<Application_Product__c> selectApplicationProductByCreditOppId(String oppId) {
        return Database.query(
            newQueryFactory().
            selectField('Temp_Account_Number__c').
            selectField('Account_Number__c').
            selectField('Product_Name__c').
            selectField('Overdraft_Limit_New_Amount__c').
            selectField('Current_Overdraft_Limit__c').
            selectField('Product_Amount__c').
            setCondition('Opportunity__c =: oppId and Application_Product_Parent__c != null').
            toSOQL()
        );
    }
    /**
*@description Return Application Products Based on Opp Id
*@Date : 2021-08-27
*@param oppId oppId
*@return List<Application_Product__c>
*/
    public List<Application_Product__c> selectApplicationProductByOpportunityId(String oppId) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Internet_Banking__c').
            selectField('Opportunity_Product_Id__c').
            selectField('Purpose_of_Account__c').
            selectField('Purpose_of_Account_Text__c').
            selectField('Source_of_Funds_Savings__c').
            selectField('Account_Activity_Calculator__c').
            selectField('Client_Under_Supervision__c').
            selectField('Advice_Given__c').
            selectField('ROA_SectionC_Table_Value__c').
            selectField('ROA_SectionD_Table_Value__c').
            selectField('General_Notes__c').
            setCondition('Application__r.Opportunity__c = :oppId').
            toSOQL()
        );
    }
    /**
*@description Return Application Products Based on Opportunity Product Id
*@param oppPrdctId opportuniytProductIds
*@return List<Application_Product__c>
*/
    public List<Application_Product__c> selectApplicationProductByOpportunityProductIds(List<String> oppPrdctId) {
        return Database.query(
            newQueryFactory(false).
            selectField('Id').
            selectField('Opportunity_Product_Id__c').
            selectField('Client_Under_Supervision__c').
            selectField('Advice_Given__c').
            selectField('Confirmation_of_Record_Completion__c').
            selectField('ROA_SectionC_Table_Value__c').
            selectField('ROA_SectionD_Table_Value__c').
            selectField('General_Notes__c').
            selectField('Source_of_Funds_Savings__c').
            selectField('Client_Type__c').
            selectField('Account_Activity_Calculator__c').
            selectField('Meeting_Of__c').
            selectField('Meeting_Held_At__c').
            selectField('Meeting_Date__c').
            selectField('Extract_signed_date__c').
            selectField('Total_number_of_accounts_to_be_Open__c').
            selectField('Req_NumOf_signs_to_Open_Close_Accounts__c').
            selectField('Comments_on_explanation_given_for_Source__c').
            selectField('Credits_received_via__c').
			selectField('Where_will_the_credits_be_coming_from__c').
            selectField('Number_of_staff_members__c').
            selectField('Payment_date_of_staff__c').
			selectField('Where_are_the_suppliers_located__c').
            selectField('Reason_for_debit_orders__c'). 
            setCondition('Opportunity_Product_Id__c IN :oppPrdctId').
            toSOQL()
        );
    }
    /** 
    * @description selectIdsByOpportunityId
    * @param opportunityId
    * @return List<Application_Product__c>
    */
    public List<Application_Product__c> selectIdsByOpportunityId(Id opportunityId) {
        
        List<Application_Product__c> applicationProductList = new List<Application_Product__c>();
        List<OpportunityLineItem> OpportunityLineItemList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId
                                                             AND Parent_Opportunity_Line_Item_Id__c = null];
        
        if(OpportunityLineItemList.size() > 0){
            applicationProductList = [SELECT Id,Regular_withdrawal_amount_R__c,Frequency_of_payment_required__c FROM Application_Product__c
                                      WHERE Opportunity_Product_Id__c =: OpportunityLineItemList[0].Id];
        }
        return applicationProductList;
    }
    
}