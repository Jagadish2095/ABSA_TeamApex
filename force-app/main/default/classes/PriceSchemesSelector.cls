/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Price_Scheme__c objects
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2020-04-20 
 */
public class PriceSchemesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description Get SObject Type
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Price_Scheme__c.sObjectType;
	}

	/**
	 * @description Get SObject Field List
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Price_Scheme__c.Id,
			Price_Scheme__c.Name,
			Price_Scheme__c.Type__c,
			Price_Scheme__c.Account__c,
			Price_Scheme__c.Product_Family__c,
			Price_Scheme__c.Start_Date__c,
			Price_Scheme__c.End_Date__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	/**
	 * @description Select By Id Set
	 * @param idSet
	 * @return List<Price_Scheme__c>
	 */
	public List<Price_Scheme__c> selectById(Set<Id> idSet) {
		return (List<Price_Scheme__c>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	/**
	 * @description PJAIN: 20200422
	 * @param accountId
	 * @param productFamily
	 * @param type
	 * @param recordLimit
	 * @return List<Price_Scheme__c>
	 */
	public List<Price_Scheme__c> selectByAccountTypeProductFamily(Id accountId, String productFamily, String type, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Is_Negotiable__c')
				.setCondition(
					'Account__c =: accountId' +
					' AND Type__c =: type' +
					' AND Product_Family__c =: productFamily' +
					' AND Start_Date__c <= TODAY' +
					' AND (End_Date__c >= TODAY' +
					' OR No_End_Date__c = true)'
				)
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description PJAIN: 20200422
	 * @param productFamily
	 * @param type
	 * @param recordLimit
	 * @return List<Price_Scheme__c>
	 */
	public List<Price_Scheme__c> selectByTypeProductFamily(String productFamily, String type, Integer recordLimit) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Is_Negotiable__c')
				.setCondition(
					'Type__c =: type' +
					' AND Product_Family__c =: productFamily' +
					' AND Start_Date__c <= TODAY' +
					' AND (End_Date__c >= TODAY' +
					' OR No_End_Date__c = true)'
				)
				.setLimit(recordLimit)
				.toSOQL()
		);
	}

	/**
	 * @description Anka Ganta: 2020-08-24
	 * @param productFamily
	 * @param ProductName
	 * @param ProductCode
	 * @return List<Price_Scheme__c>
	 */
	public List<Price_Scheme__c> selectByProductFamilyProductName(String productFamily, String ProductName, String ProductCode) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('Scheme_Code__c')
				.selectField('Product_Family__c')
				.selectField('Product_Name__c')
				.selectField('Product_Code__c')
				.selectField('Is_Negotiable__c')
				.setCondition(
					'Product_Family__c =: productFamily' +
					' AND Product_Name__c =: productName' +
					' AND Product_Code__c =: productCode' +
					' AND Start_Date__c <= TODAY' +
					' AND (End_Date__c >= TODAY' +
					' OR No_End_Date__c = true)'
				)
				.toSOQL()
		);
	}

	/**
	 * @description Masechaba Maseli: 21112020
	 * @return List<Price_Scheme__c>
	 */
	public List<Price_Scheme__c> selectByEndDate() {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('Scheme_Code__c')
				.selectField('Product_Family__c')
				.selectField('Product_Name__c')
				.selectField('Product_Code__c')
				.selectField('Is_Negotiable__c')
				.selectField('Package_Name__c')
				.setCondition('Start_Date__c <= TODAY' + ' AND (End_Date__c >= TODAY' + ' OR No_End_Date__c = true)')
				.toSOQL()
		);
	}

	/**
     * @description Returns a single product based on a given product family
     *
     * @param family
     * @return List<Price_Scheme__c>
     * Englarmerdge Mongwe: 20210104
     */
    public List<Price_Scheme__c> selectByFamily(String family) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Product_Family__c').
            selectField('Product_Name__c').
            selectField('Product_Code__c').
            setCondition('Product_Family__c = :family').
            toSOQL()
        );
    }

	/**
	 * @description Returns List of Price_Scheme__c where their Name is in the Name Set
	 * @param priceSchemeNameSet
	 * @return List<Price_Scheme__c>
	 */
	public List<Price_Scheme__c> selectByNameSet(Set<String> priceSchemeNameSet) {
		return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Name')
            .setCondition('Name IN : priceSchemeNameSet')
            .toSOQL());
	}
}