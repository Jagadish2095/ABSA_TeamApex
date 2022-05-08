/**
* @description Apex Enterprise Design Patters
* Selector layer for Application_Repayment_Account_CPF__c objects
*
* @author  Haritha P
* @since   01/06/2021
*/
public class ApplicationRepaymentAccountCPFSelector extends fflib_SObjectSelector{
    /**
    * @description Method to retrieve the sObjectType
    *
    * @return  Application_Repayment_Account_CPF__c
    */
        public Schema.SObjectType getSObjectType() {

            return Application_Repayment_Account_CPF__c.sObjectType;

        }

        /**
    * @description Method to retrieve the list of fields on the sObject
    *
    * @return  List<Schema.SObjectField>
    */
        public List<Schema.SObjectField> getSObjectFieldList() {

            return new List<Schema.SObjectField>{
                Application_Repayment_Account_CPF__c.Id,
                   Application_Repayment_Account_CPF__c.Application_Product_CPF__c
                    };
         }

        /**
        * @description Method to get list of Application_Repayment_Account_CPF__c rec by application product cpf Id
        * @author  | 2021-06-17 haritha
        * @param appPrdctId
        * @return List<Application_Repayment_Account_CPF__c>
        **/
        public  List<Application_Repayment_Account_CPF__c> selectByAppPrdctId(Id appPrdctId) {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
               // selectField('Secondary_Account_Applicable__c').
                selectField('Prime_rate_margin__c').
                selectField('Interest_rate_basis__c').
                selectField('Interest_service_frequency__c').
                selectField('Margin__c').
                selectField('Include_repayment_schedule__c').
                selectField('Instalment_amount__c').
                selectField('Instalment_periods__c').
                selectField('Term__c').
                selectField('Date_of_final_repayment__c').
                selectField('Final_repayment_date__c').
                selectField('Number_of_periods_months__c').
                selectField('Application_Product_CPF__c').
                selectField('Interest_Only_Period__c').
                selectField('Starting_Stepped_Instalment__c').
                selectField('Escalating_Perc__c').
                selectField('Instalment_periods__c').
                selectField('Interest_service_frequency__c').
                selectField('Final_Instalment_Amount__c').
                selectField('Equal_Instalments__c').
                selectField('Repayment_options__c').
                setCondition('Id =: appPrdctId').
                toSOQL()
            );
        }

        /**
        * @description Method to get list of Application_Repayment_Account_CPF__c rec by application product cpf Id and type
        * @author  | 2021-06-17  haritha
        * @param appPrdctId
        * @param type
        * @return List<Application_Repayment_Account_CPF__c>
        **/
        public  List<Application_Repayment_Account_CPF__c> selectByAppPrdctIdAndType(Id appPrdctId ,string type) {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
                selectField('Type__c').
                selectField('Prime_rate_margin__c').
                selectField('Interest_rate_basis__c').
                selectField('Interest_service_frequency__c').
                selectField('Margin__c').
                selectField('Include_repayment_schedule__c').
                selectField('Instalment_amount__c').
                selectField('Instalment_periods__c').
                selectField('Term__c').
                selectField('Date_of_final_repayment__c').
                selectField('Final_repayment_date__c').
                selectField('Number_of_periods_months__c').
                selectField('Application_Product_CPF__c').
                selectField('Interest_Only_Period__c').
                selectField('Starting_Stepped_Instalment__c').
                selectField('Escalating_Perc__c').
                selectField('Instalment_periods__c').
                selectField('Interest_service_frequency__c').
                selectField('Final_Instalment_Amount__c').
                selectField('Equal_Instalments__c').
                selectField('Repayment_options__c').
                selectField('Number_of_periods_after_first_drawdown__c').
                setCondition('Application_Product_CPF__c =: appPrdctId AND Type__c =:type' ).
                toSOQL()
            );
        }

/**
    * @description Method to get list of Application_Repayment_Account_CPF__c rec by application product cpf Id
    * @author  | 2021-07-15 Tinashe
    * @param appPrdctId
    * @return List<Application_Repayment_Account_CPF__c>
**/
        public  List<Application_Repayment_Account_CPF__c> selectAraByAppPrdctId(Id appPrdctId) {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
                selectField('Type__c').
                selectField('Prime_rate_margin__c').
                selectField('Interest_rate_basis__c').
                selectField('Interest_service_frequency__c').
                selectField('Margin__c').
                selectField('Include_repayment_schedule__c').
                selectField('Instalment_amount__c').
                selectField('Instalment_periods__c').
                selectField('Term__c').
                selectField('Date_of_final_repayment__c').
                selectField('Final_repayment_date__c').
                selectField('Number_of_periods_months__c').
                selectField('Application_Product_CPF__c').
                selectField('Interest_Only_Period__c').
                selectField('Starting_Stepped_Instalment__c').
                selectField('Escalating_Perc__c').
                selectField('Instalment_periods__c').
                selectField('Interest_service_frequency__c').
                selectField('Final_Instalment_Amount__c').
                selectField('Equal_Instalments__c').
                selectField('Repayment_options__c').
                selectField('Number_of_periods_after_first_drawdown__c').
                setCondition('Application_Product_CPF__c =: appPrdctId').
                toSOQL()
            );
        }
    }