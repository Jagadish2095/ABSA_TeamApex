/**
* Selector Layer for Application_Product_Merchant__c objects
*
* @author  Jason Quevauvilliers
* @since   2020-04-02
* @UpdateDate 2020/05/28 - Englarmerdge W004364
*/
public class ApplicationProductMerchantsSelector extends fflib_SObjectSelector {
    
    
        /**
* Method to retrieve the sObjectType
*
* @return  Schema.SObjectType  The sObjectType
*/
    public Schema.SObjectType getSObjectType() {
        return Application_Product_Merchant__c.sObjectType;
    }

        public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Application_Product_Merchant__c.Id,
            Application_Product_Merchant__c.AMEX_Merchant_Number__c,
            Application_Product_Merchant__c.Annual_Business_Turnover__c,
            Application_Product_Merchant__c.Annual_Card_Turnover__c,
            Application_Product_Merchant__c.Annual_Card_Turnover_R__c,
            Application_Product_Merchant__c.Name,
            Application_Product_Merchant__c.Association_Code__c,
            Application_Product_Merchant__c.Authorised_Signatory__c,
            Application_Product_Merchant__c.Average_Card_Transaction_Value__c,
            Application_Product_Merchant__c.Average_Ticket_Value_On_Credit_Card__c,
            Application_Product_Merchant__c.Average_Ticket_Value_On_Debit_Card__c,
            Application_Product_Merchant__c.Cancellation_Fee__c,
            Application_Product_Merchant__c.Cash_Back_Indicator__c,
            Application_Product_Merchant__c.Cash_Send_Indicator__c,
            Application_Product_Merchant__c.Chargeback_Fee__c,
            Application_Product_Merchant__c.Comments_And_Recommendation__c,
            Application_Product_Merchant__c.Communication_Required__c,
            Application_Product_Merchant__c.CMB_Indicator__c,
            Application_Product_Merchant__c.Conduct_Of_Account__c,
            Application_Product_Merchant__c.Configuration__c,
            Application_Product_Merchant__c.Cost_Centre__c,
            Application_Product_Merchant__c.CreatedById,
            Application_Product_Merchant__c.CSP__c,
            Application_Product_Merchant__c.CSP_Id__c,
            Application_Product_Merchant__c.CurrencyIsoCode,
            Application_Product_Merchant__c.Deferred_Goods_Or_Services__c,
            Application_Product_Merchant__c.Deferred_Goods_Or_Services_Reason__c,
            Application_Product_Merchant__c.Deposit_Monitoring__c,
            Application_Product_Merchant__c.Device_Type__c,
            Application_Product_Merchant__c.DCC_Indicator__c,
            Application_Product_Merchant__c.Goods_And_Services_Deferred_Delivery__c,
            Application_Product_Merchant__c.Goods_And_Services_Taken_At_POS__c,
            Application_Product_Merchant__c.Goods_Delivered_30_60_Days__c,
            Application_Product_Merchant__c.Goods_Delivered_30_60_Days_R__c,
            Application_Product_Merchant__c.Goods_Delivered_60_Days__c,
            Application_Product_Merchant__c.Goods_Delivered_60_Days_R__c,
            Application_Product_Merchant__c.Goods_Delivered_Within_1_7_Days__c,
            Application_Product_Merchant__c.Goods_Delivered_Within_1_7_Days_R__c,
            Application_Product_Merchant__c.Goods_Delivered_Within_15_30_Days__c,
            Application_Product_Merchant__c.Goods_Delivered_Within_15_30_Days_R__c,
            Application_Product_Merchant__c.Goods_Delivered_Within_8_14_Days__c,
            Application_Product_Merchant__c.Goods_Delivered_Within_8_14_Days_R__c,
            Application_Product_Merchant__c.Group_ID__c,
            Application_Product_Merchant__c.Group_Structure__c,
            Application_Product_Merchant__c.Header_Text_Row_1__c,
            Application_Product_Merchant__c.Header_Text_Row_2__c,
            Application_Product_Merchant__c.Header_Text_Row_3__c,
            Application_Product_Merchant__c.Initiation_Fee__c,
            Application_Product_Merchant__c.International_Card__c,
            Application_Product_Merchant__c.IP_Address__c,
            Application_Product_Merchant__c.LastModifiedById,
            Application_Product_Merchant__c.Local_Credit_Card__c,
            Application_Product_Merchant__c.Local_Debit_Card__c,
            Application_Product_Merchant__c.LVP_Indicator__c,
            Application_Product_Merchant__c.Mark_Off_File__c,
            Application_Product_Merchant__c.MCC__c,
            Application_Product_Merchant__c.Merchant_Class__c,
            Application_Product_Merchant__c.Merchant_Relationship_Type__c,
            Application_Product_Merchant__c.Minimum_Service_Fee__c,
            Application_Product_Merchant__c.Monthly_Card_Turnover_Deferred_Delivery__c,
            Application_Product_Merchant__c.Multi_Currency__c,
            Application_Product_Merchant__c.Nett_Settlement__c,
            Application_Product_Merchant__c.Number_of_Days__c,
            Application_Product_Merchant__c.Officer_Code__c,
            Application_Product_Merchant__c.Opportunity_Product_Id__c,
            Application_Product_Merchant__c.OwnerId,
            Application_Product_Merchant__c.Product_Service_Sell_Methods__c,
            Application_Product_Merchant__c.Purpose_Of_Application__c,
            Application_Product_Merchant__c.PYC__c,
            Application_Product_Merchant__c.PYC_Rebate__c,
            Application_Product_Merchant__c.RTC_Indicator__c,
            Application_Product_Merchant__c.Region__c,
            Application_Product_Merchant__c.Security_Offered__c,
            Application_Product_Merchant__c.Selected_Cards__c,
            Application_Product_Merchant__c.Single_Credit_Indicator__c,
            Application_Product_Merchant__c.Site_Code__c,
            Application_Product_Merchant__c.Status_MASS_Account__c,
            Application_Product_Merchant__c.Status_Merchant_Plan__c,
            Application_Product_Merchant__c.Status_Message_MASS_Account__c,
            Application_Product_Merchant__c.Status_Message_Merchant_Plan__c,
            Application_Product_Merchant__c.Status_Message_POSH_Merchant__c,
            Application_Product_Merchant__c.Status_POSH_Merchant__c,
            Application_Product_Merchant__c.Terminal_Batch_Time__c,
            Application_Product_Merchant__c.Terminal_Update_Time__c,
            Application_Product_Merchant__c.TZP_Indicator__c,
            Application_Product_Merchant__c.Total_Exposure_R__c,
            Application_Product_Merchant__c.Total_Percentage__c,
            Application_Product_Merchant__c.Trading_Activity__c,
            Application_Product_Merchant__c.Waive_Stationery_Fee__c,
            Application_Product_Merchant__c.Web_Developer_Company__c,
            Application_Product_Merchant__c.Web_Developer_Contact_Name_Number__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    /**
* Method that takes an opportunity ID
*
* @return List Application_Product_Merchant__c
*/
    public List<Application_Product_Merchant__c> selectByOpportunityId(Id opportunityId) {

        List<Application_Product_Merchant__c> appProdMerchList = new List<Application_Product_Merchant__c>();

        List<OpportunityLineItem> OpportunityLineItemList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId
                                                             AND Parent_Opportunity_Line_Item_Id__c = null];

        if(OpportunityLineItemList != null && OpportunityLineItemList.size() > 0){

            String query = ' SELECT ';
            String field_name = null;
            Map< String, Schema.SObjectField > fieldObjectMap = Schema.getGlobalDescribe().get('Application_Product_Merchant__c').getDescribe().Fields.getMap();
            List<Schema.SObjectField> field_object_values_map = fieldObjectMap.values();
            for( Schema.SObjectField s : field_object_values_map ){
                field_name = s.getDescribe().getName();
                query += field_name + ', ';
            }
            query = query.subStringBeforeLast(',');
            query += ' FROM Application_Product_Merchant__c WHERE Opportunity_Product_Id__c =  \'' + OpportunityLineItemList[0].Id + '\'';
            appProdMerchList = (List<Application_Product_Merchant__c>)Database.query( query );
            System.debug('appProdMerchList: ' + appProdMerchList);

        }
        return appProdMerchList;
    }

    /**
* Method that takes an opportunity ID
*
* @return Id Field
*/
    public List<Application_Product_Merchant__c> selectIdsByOpportunityId(Id opportunityId) {

        List<Application_Product_Merchant__c> applicationProductMerchantList = new List<Application_Product_Merchant__c>();
        List<OpportunityLineItem> OpportunityLineItemList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId
                                                             AND Parent_Opportunity_Line_Item_Id__c = null];

        if(OpportunityLineItemList != null && OpportunityLineItemList.size() > 0){
            applicationProductMerchantList = [SELECT Id FROM Application_Product_Merchant__c
                                              WHERE Opportunity_Product_Id__c =: OpportunityLineItemList[0].Id];
        }
        return applicationProductMerchantList;
    }

    /**
    * Method that takes an opportunity ID
    *
    * @return Id Field
    */
    public List<Application_Product_Merchant__c> selectIdsByOpportunityLineItemId(Id opportunityLineItemId) {
        return Database.query(
            newQueryFactory().
            selectField('AMEX_Merchant_Number__c').
            selectField('Annual_Business_Turnover__c').
            selectField('Annual_Card_Turnover__c').
            selectField('Annual_Card_Turnover_R__c').
            selectField('Name').
            selectField('Association_Code__c').
            selectField('Authorised_Signatory__c').
            selectField('Average_Card_Transaction_Value__c').
            selectField('Average_Ticket_Value_On_Credit_Card__c').
            selectField('Average_Ticket_Value_On_Debit_Card__c').
            selectField('Cancellation_Fee__c').
            selectField('Cash_Back_Indicator__c').
            selectField('Cash_Send_Indicator__c').
            selectField('Chargeback_Fee__c').
            selectField('Comments_And_Recommendation__c').
            selectField('Communication_Required__c').
            selectField('CMB_Indicator__c').
            selectField('Conduct_Of_Account__c').
            selectField('Configuration__c').
            selectField('Cost_Centre__c').
            selectField('CreatedById').
            selectField('CSP__c').
            selectField('CSP_Id__c').
            selectField('CurrencyIsoCode').
            selectField('Deferred_Goods_Or_Services__c').
            selectField('Deferred_Goods_Or_Services_Reason__c').
            selectField('Deposit_Monitoring__c').
            selectField('Device_Type__c').
            selectField('DCC_Indicator__c').
            selectField('Goods_And_Services_Deferred_Delivery__c').
            selectField('Goods_And_Services_Taken_At_POS__c').
            selectField('Goods_Delivered_30_60_Days__c').
            selectField('Goods_Delivered_30_60_Days_R__c').
            selectField('Goods_Delivered_60_Days__c').
            selectField('Goods_Delivered_60_Days_R__c').
            selectField('Goods_Delivered_Within_1_7_Days__c').
            selectField('Goods_Delivered_Within_1_7_Days_R__c').
            selectField('Goods_Delivered_Within_15_30_Days__c').
            selectField('Goods_Delivered_Within_15_30_Days_R__c').
            selectField('Goods_Delivered_Within_8_14_Days__c').
            selectField('Goods_Delivered_Within_8_14_Days_R__c').
            selectField('Group_ID__c').
            selectField('Group_Structure__c').
            selectField('Header_Text_Row_1__c').
            selectField('Header_Text_Row_2__c').
            selectField('Header_Text_Row_3__c').
            selectField('Initiation_Fee__c').
            selectField('International_Card__c').
            selectField('IP_Address__c').
            selectField('LastModifiedById').
            selectField('Local_Credit_Card__c').
            selectField('Local_Debit_Card__c').
            selectField('LVP_Indicator__c').
            selectField('Mark_Off_File__c').
            selectField('MCC__c').
            selectField('Merchant_Class__c').
            selectField('Merchant_Relationship_Type__c').
            selectField('Minimum_Service_Fee__c').
            selectField('Monthly_Card_Turnover_Deferred_Delivery__c').
            selectField('Multi_Currency__c').
            selectField('Nett_Settlement__c').
            selectField('Number_of_Days__c').
            selectField('Officer_Code__c').
            selectField('Opportunity_Product_Id__c').
            selectField('OwnerId').
            selectField('Product_Service_Sell_Methods__c').
            selectField('Purpose_Of_Application__c').
            selectField('PYC__c').
            selectField('PYC_Rebate__c').
            selectField('RTC_Indicator__c').
            selectField('Region__c').
            selectField('Security_Offered__c').
            selectField('Selected_Cards__c').
            selectField('Single_Credit_Indicator__c').
            selectField('Site_Code__c').
            selectField('Status_MASS_Account__c').
            selectField('Status_Merchant_Plan__c').
            selectField('Status_Message_MASS_Account__c').
            selectField('Status_Message_Merchant_Plan__c').
            selectField('Status_Message_POSH_Merchant__c').
            selectField('Status_POSH_Merchant__c').
            selectField('Terminal_Batch_Time__c').
            selectField('Terminal_Update_Time__c').
            selectField('TZP_Indicator__c').
            selectField('Total_Exposure_R__c').
            selectField('Total_Percentage__c').
            selectField('Trading_Activity__c').
            selectField('Waive_Stationery_Fee__c').
            selectField('Web_Developer_Company__c').
            selectField('Web_Developer_Contact_Name_Number__c').
            setCondition('Opportunity_Product_Id__c = :opportunityLineItemId').
            toSOQL()
        );
    }
    
    

    /**
* PJAIN: 20200520
* Method that takes an ID
*
* @return List<Application_Product_Merchant__c>
*/
   public List<Application_Product_Merchant__c> selectById(Id applicationProductMerchantId) {
        return Database.query(
            newQueryFactory().
            selectField('AMEX_Merchant_Number__c').
            selectField('Annual_Business_Turnover__c').
            selectField('Annual_Card_Turnover__c').
            selectField('Annual_Card_Turnover_R__c').
            selectField('Name').
            selectField('Association_Code__c').
            selectField('Authorised_Signatory__c').
            selectField('Average_Card_Transaction_Value__c').
            selectField('Average_Ticket_Value_On_Credit_Card__c').
            selectField('Average_Ticket_Value_On_Debit_Card__c').
            selectField('Cancellation_Fee__c').
            selectField('Cash_Back_Indicator__c').
            selectField('Cash_Send_Indicator__c').
            selectField('Chargeback_Fee__c').
            selectField('Comments_And_Recommendation__c').
            selectField('Communication_Required__c').
            selectField('CMB_Indicator__c').
            selectField('Conduct_Of_Account__c').
            selectField('Configuration__c').
            selectField('Cost_Centre__c').
            selectField('CreatedById').
            selectField('CSP__c').
            selectField('CSP_Id__c').
            selectField('CurrencyIsoCode').
            selectField('Deferred_Goods_Or_Services__c').
            selectField('Deferred_Goods_Or_Services_Reason__c').
            selectField('Deposit_Monitoring__c').
            selectField('Device_Type__c').
            selectField('DCC_Indicator__c').
            selectField('Goods_And_Services_Deferred_Delivery__c').
            selectField('Goods_And_Services_Taken_At_POS__c').
            selectField('Goods_Delivered_30_60_Days__c').
            selectField('Goods_Delivered_30_60_Days_R__c').
            selectField('Goods_Delivered_60_Days__c').
            selectField('Goods_Delivered_60_Days_R__c').
            selectField('Goods_Delivered_Within_1_7_Days__c').
            selectField('Goods_Delivered_Within_1_7_Days_R__c').
            selectField('Goods_Delivered_Within_15_30_Days__c').
            selectField('Goods_Delivered_Within_15_30_Days_R__c').
            selectField('Goods_Delivered_Within_8_14_Days__c').
            selectField('Goods_Delivered_Within_8_14_Days_R__c').
            selectField('Group_ID__c').
            selectField('Group_Structure__c').
            selectField('Header_Text_Row_1__c').
            selectField('Header_Text_Row_2__c').
            selectField('Header_Text_Row_3__c').
            selectField('Initiation_Fee__c').
            selectField('International_Card__c').
            selectField('IP_Address__c').
            selectField('LastModifiedById').
            selectField('Local_Credit_Card__c').
            selectField('Local_Debit_Card__c').
            selectField('LVP_Indicator__c').
            selectField('Mark_Off_File__c').
            selectField('MCC__c').
            selectField('Merchant_Class__c').
            selectField('Merchant_Relationship_Type__c').
            selectField('Minimum_Service_Fee__c').
            selectField('Monthly_Card_Turnover_Deferred_Delivery__c').
            selectField('Multi_Currency__c').
            selectField('Nett_Settlement__c').
            selectField('Number_of_Days__c').
            selectField('Officer_Code__c').
            selectField('Opportunity_Product_Id__c').
            selectField('OwnerId').
            selectField('Product_Service_Sell_Methods__c').
            selectField('Purpose_Of_Application__c').
            selectField('PYC__c').
            selectField('PYC_Rebate__c').
            selectField('RTC_Indicator__c').
            selectField('Region__c').
            selectField('Security_Offered__c').
            selectField('Selected_Cards__c').
            selectField('Single_Credit_Indicator__c').
            selectField('Site_Code__c').
            selectField('Status_MASS_Account__c').
            selectField('Status_Merchant_Plan__c').
            selectField('Status_Message_MASS_Account__c').
            selectField('Status_Message_Merchant_Plan__c').
            selectField('Status_Message_POSH_Merchant__c').
            selectField('Status_POSH_Merchant__c').
            selectField('Terminal_Batch_Time__c').
            selectField('Terminal_Update_Time__c').
            selectField('TZP_Indicator__c').
            selectField('Total_Exposure_R__c').
            selectField('Total_Percentage__c').
            selectField('Trading_Activity__c').
            selectField('Waive_Stationery_Fee__c').
            selectField('Web_Developer_Company__c').
            selectField('Web_Developer_Contact_Name_Number__c').
            setCondition('Id = : applicationProductMerchantId').
            toSOQL()
        );
    }

    public List<Application_Product_Merchant__c> selectByOppId(Id oppId) {
        
     return [SELECT Id, Device_Type__c FROM Application_Product_Merchant__c
                                              WHERE Opportunity_Product_Id__c =: oppId];
    }
     /**
     * Himani Joshi 2020-09-03
     *
     * Method that queries using a set of Opportunity Line Item Ids
     *
     * @param Set<Id> opportunityLineItemIds
     * @return List<Application_Product_Merchant__c>
     */
    public List<Application_Product_Merchant__c> selectByOpportunityLineItemIds(Set<Id> opportunityLineItemIds) {
        List<Application_Product_Merchant__c> applicationProductMerchantList = [
            SELECT Id, csp__c, Opportunity_Product_Id__c
            FROM Application_Product_Merchant__c
            WHERE Opportunity_Product_Id__c IN :opportunityLineItemIds
        ];

        return applicationProductMerchantList;
    }
}