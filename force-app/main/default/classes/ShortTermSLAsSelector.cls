/**
 * @description       : short term insurance SLA
 * @author            : Monde Masiza
 * @last modified on  : 2021-06-01
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-01   Monde Masiza   Initial Version
**/
public with sharing class  ShortTermSLAsSelector extends fflib_SObjectSelector {
    /**
 * @description       : MANDATORY ABSTRACT METHODS - START getSObjectType
 * @author            : Monde Masiza
 * @return sObjectType
 * @last modified on  : 2021-06-01
 * Ver   Date         Author         Modification
 * 1.0   2021-06-01   Monde Masiza   Initial Version
**/
    public Schema.SObjectType getSObjectType(){
        return Short_Term_Insurance_SLA__mdt.sObjectType;
    }
    

    /**
    * @description get the sobject list
    * @author Monde Masiza | 2021-06-01 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Short_Term_Insurance_SLA__mdt.Category__c,
                Short_Term_Insurance_SLA__mdt.External_SLA_Time_Measure__c    
        };
    }
    
    
    /**
	* @description select By Role
	* @author Monde Masiza | 05-31-2021 
	* @param masterLabel 
	* @return List<GroupMember> 
	*
    */
	public List<Short_Term_Insurance_SLA__mdt> selectShortTermSLA(String masterLabel){
		return Database.query(
			newQueryFactory()
			.selectField('Category__c')
            .selectField('External_SLA_Time_Measure__c')
            .selectField('MasterLabel')
            .selectField('External_SLA_Units__c')
            .selectField('Internal_SLA_Time_Measure__c')
            .selectField('Internal_SLA_Units__c')
			.setCondition('MasterLabel = :masterLabel')
			.toSOQL()
		);
	}

}