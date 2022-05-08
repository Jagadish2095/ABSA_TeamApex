/* @author  Thabo Senkomane
* @since   2020-09-25
*/
public class ApplicationExposureCashInvSelector  extends fflib_SObjectSelector  {
    public Schema.SObjectType getSObjectType() {
        return Application_Exposure_Cash_and_Investment__c.sObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Application_Exposure_Cash_and_Investment__c.Id,
            Application_Exposure_Cash_and_Investment__c.Name,
            Application_Exposure_Cash_and_Investment__c.Application__c,
            Application_Exposure_Cash_and_Investment__c.Product__c,
            Application_Exposure_Cash_and_Investment__c.Client_Name__c,
            Application_Exposure_Cash_and_Investment__c.Client_Code__c,
            Application_Exposure_Cash_and_Investment__c.Cash_Investment__c,
            Application_Exposure_Cash_and_Investment__c.LastModifiedDate
        };
    }

    public List<Application_Exposure_Cash_and_Investment__c> getAppCashInvestByCientCode(string clientCode,Id applicationId) {
        System.debug('applicationId ' + applicationId);
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Application__c').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
            selectField('Product__c').
            selectField('LastModifiedDate').
            selectField('Cash_Investment__c').
            selectField('Participation_Bond__c').
            selectField('Term_Deposits__c').
            selectField('Mortgage_Prepaid__c').
            selectField('Over_Control_SIte__c').
            selectField('CPF_Prepaid__c').
            selectField('Control_Branch__c').
            selectField('Savings__c').
            selectField('Customer_Investment_Account__c').
            selectField('Other_Available_Cash__c').
            selectField('Fleet_In_Credit__c').
            selectField('Notice_of_Deposits__c').
            selectField('Pens_Back_Prepaid__c').
            selectField('Fleet_Cash_Advance__c').
            selectField('AFC_In_Credit__c').
            selectField('Cheque_In_Credit__c').
            selectField('Credit_Card__c').
            selectField('Client_Total__c').
            setCondition('Client_Code__c =: clientCode AND Application__c =:applicationId').
            toSOQL()
        );
    }

    public List<Application_Exposure_Cash_and_Investment__c> getAllApplicationExposureCashInvestByAppId(Id applicationId) {
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Application__c').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
            selectField('Product__c').
            selectField('LastModifiedDate').
            selectField('Cash_Investment__c').
            selectField('Participation_Bond__c').
            selectField('Term_Deposits__c').
            selectField('Mortgage_Prepaid__c').
            selectField('Over_Control_SIte__c').
            selectField('CPF_Prepaid__c').
            selectField('Control_Branch__c').
            selectField('Savings__c').
            selectField('Customer_Investment_Account__c').
            selectField('Other_Available_Cash__c').
            selectField('Fleet_In_Credit__c').
            selectField('Notice_of_Deposits__c').
            selectField('Pens_Back_Prepaid__c').
            selectField('Fleet_Cash_Advance__c').
            selectField('Cheque_In_Credit__c').
            selectField('AFC_In_Credit__c').
            selectField('Credit_Card__c').
            selectField('Client_Total__c').
            setCondition('Application__c =: applicationId').
            toSOQL()
        );
    }
}