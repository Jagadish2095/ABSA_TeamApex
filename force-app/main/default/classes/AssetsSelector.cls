/**
* Apex Enterprise Design Patterns
* Selector Layer for Asset objects
*
* @author  Himanshu Nimje
* @since   2018-11-28
*/
public class AssetsSelector extends fflib_SObjectSelector {
    
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Asset.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList(){
       
        return new List<Schema.SObjectField> {
            
            	Asset.Id,
                Asset.Name,
                Asset.AccountId,    
                Asset.RecordTypeId,
                Asset.AssetLevel,
                Asset.Status, 
                Asset.SerialNumber,
                Asset.RootAssetId,
                Asset.Quantity,
                Asset.PurchaseDate,
                Asset.StockKeepingUnit,
                Asset.ProductCode,
                Asset.Product2Id,
                Asset.Price,
                Asset.ParentId,
                Asset.IsInternal,
                Asset.InstallDate,
                Asset.Description,
                Asset.ContactId,
                Asset.AssetServicedById,
                Asset.AssetProvidedById
                
              };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<Asset> selectById(Set<Id> idSet) {
        return (List<Asset>) selectSObjectsById(idSet);
    }
	//Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    
    
    //CUSTOM SELECTORS - START
    
    
    /**
     * Method that gets a list of Asset from Asset Name (Will Number) with no limit
     *
     * @param AssetName - Asset's number (Will Number)
     * @return a Asset List with ID and name
     */
    public List<Asset> selectAssetByName(String AssetName) {
        return Database.query(
                newQueryFactory().
                setCondition('Name = :AssetName').
                toSOQL()
        );
    }
    
    
    
     /**
     * Method that gets a list of Asset 
     *
     * @param AccountId - Asset's number (Will Number)
     * @return a Asset List with ID and name
     */
    public List<Asset> selectAssetByAccId(Id AccId) {
        return Database.query(
                newQueryFactory().
                setCondition('AccountId = :AccId').
                toSOQL()
        );
    }
    
    
    
    /**
     * Method that gets a list of Asset from Asset with no limit
     *
     * @param AssetSerialNumber - Asset's number (Will Number)
     * @param AssetProductCode - Asset's product code
     * @return a Asset List with ID and name
     */
    public List<Asset> selectAssetByNaturalKey(String AssetSerialNumber, String AssetProductCode) {
        return Database.query(
                newQueryFactory().
                setCondition('SerialNumber = :AssetSerialNumber AND ProductCode =: AssetProductCode').
                toSOQL()
        );
    }
   
    

    
    /**
     * Method that gets a list of Asset from Asset with no limit
     *
     * @param AssetSerialNumber - Asset's number (Will Number)
     *
     * @return a Asset List with ID and name
     */
    public List<Asset> selectAssetNumber(String AssetSerialNumber) {
        return Database.query(
            newQueryFactory().
                    selectField('Adviser_Code__c').
                    selectField('Adviser_Name__c').
                    setCondition('SerialNumber = :AssetSerialNumber').
                    toSOQL()
        );
    }
    
     /**
     * Retrieves assets of a certain type given the accountId and recordType.
     *
     * @param AccountId - Asset's number (Will Number)
     * @param assetType The type of asset to retrieve.
     * @return a Asset List with ID and name
     */
    public List<Asset> selectAssetsByAccId(Id AccId, String assetType) {
    	Id rtId = [SELECT Id, Name FROM RecordType WHERE Name =: assetType].Id;
        return Database.query(
                newQueryFactory().
                setCondition('AccountId = :AccId AND RecordTypeId = :rtId').
                toSOQL()
        );
    }
    
    /**
     * Retrieves assets of a certain type given the opportunityId and recordType.
     *
     * @param opportunityId - The opportunity
     * @param assetType The type of asset to retrieve.
     * @return a Asset List with ID and name
     */
    public List<Asset> selectAssetsByOpportunityId(Id oppId, String assetType) {
    	Id accId = [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId].AccountId;
    	Id rtId = [SELECT Id, Name FROM RecordType WHERE Name = :assetType].Id;
        return Database.query(
                newQueryFactory().
                setCondition('AccountId = :accId AND RecordTypeId = :rtId').
                toSOQL()
        );
    }
    
    /**
     * Selects assets given account and type of asset to be selected.
     */
    public List<Asset> selectByAccountIdAndAssetType(Id accId, String assetType) {
        Id recordTypeId = [SELECT Id, Name FROM RecordType WHERE Name = :assetType].Id;
        return Database.query(
                newQueryFactory().
                setCondition('AccountId = :AccId AND RecordTypeId = :recordTypeId').
                toSOQL()
        );
    }
    
    
    
    //CUSTOM SELECTORS - END
}