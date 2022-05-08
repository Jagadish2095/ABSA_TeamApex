/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Group Member object
 *
 * @author  Poulami Banerjee
 * @since   2021-05-13
 */
public class CampaignsSelector extends fflib_SObjectSelector{
    
    //MANDATORY ABSTRACT METHODS -
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Campaign.sObjectType;
	}
    
    /**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		 return new List<Schema.SObjectField> {
                Campaign.Id,
                Campaign.Name
        };
	}
    
    /**
	 * @description selectByCampaignCode description
	 *
	 * @param codeName (String): codeName
	 * @return Return Campaign: Return description
	 */
	public Campaign selectByCodeName(String codeName) {
		return [SELECT Id, Name,Description FROM Campaign WHERE Campaign_Code__c = :codeName LIMIT 1];
	}

}