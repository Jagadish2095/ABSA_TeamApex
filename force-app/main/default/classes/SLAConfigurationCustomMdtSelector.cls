/**
* Apex Enterprise Design Patterns
* @description Selector Layer for custom metadata type SLA_Configuration__mdt
*
* @author  Poulami Banerjee
* @since   2021-05-13
*/
public class SLAConfigurationCustomMdtSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    /**
     * @description getSObjectType
     *
     * @return Return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType(){
        return SLA_Configuration__mdt.sObjectType;
    }
/**
 * @description getSObjectFieldList description
 *
 * @return Return List<Schema.SObjectField>: Return description
 */
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                SLA_Configuration__mdt.Id,
                SLA_Configuration__mdt.Service_Group__c,
               	SLA_Configuration__mdt.MasterLabel
        };
    }
    /**
     * @description selectByLabel description
     *
     * @param specsearch (String): specsearch
     * @return Return List<SLA_Configuration__mdt>: Return description
     */
    public List<SLA_Configuration__mdt> selectByLabel(String specsearch) { 
        return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('External_SLA_Units__c')
				.selectField('Internal_SLA_Time_Measure__c')
            	.selectField('Internal_SLA_Units__c')
            	.selectField('External_SLA_Time_Measure__c')
            	.selectField('MasterLabel')
            	.selectField('Service_Group__c')
            	.selectField('DeveloperName')
				.setCondition('MasterLabel =: specsearch')
				.toSOQL()
		);
       
    }
}