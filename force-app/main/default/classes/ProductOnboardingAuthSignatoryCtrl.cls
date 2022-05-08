public class ProductOnboardingAuthSignatoryCtrl{
	/*  @AuraEnabled
	 public static Application_Product_Merchant__c getApplicationProductMerchant(id oppId) {
	 ApplicationProductMerchantsSelector apmSelector = new ApplicationProductMerchantsSelector();
	 Application_Product_Merchant__c appProdMerch = new Application_Product_Merchant__c();

	 List<Application_Product_Merchant__c> appProdMerchList = apmSelector.selectByOpportunityId(oppId);
	 if(appProdMerchList.size() > 0 && appProdMerchList != null && !appProdMerchList.isEmpty()){
	 appProdMerch = appProdMerchList[0];
	 }else{
	 appProdMerch=null;
	 }
	 return appProdMerch;
	 }*/
	@AuraEnabled
	public static List<AccountContactRelation> getAccountContactRelation(id oppId){
		AccountContactRelationSelector acrSelector = new AccountContactRelationSelector();
		OpportunitiesSelector oppSelector = new OpportunitiesSelector();
		List<AccountContactRelation> acrList;

		id accId = oppSelector.selectByOppId(oppId).AccountId;
		if (accId != null){
			acrList = acrSelector.selectRelationByAccountId(accId);
			if (acrList.size() <= 0 || acrList == null || acrList.isEmpty()){
				acrList = null;
			}
		}
		return acrList;
	}

	/**
	 * @Saurabh
	 * @param oppId  The Opportunity Id
	 * @return  List<OpportunityLineItem>   A list of OpportunityLineItems
	 * @W: 004264
	 */
	@AuraEnabled
	public static Map<string, OpportunityLineItem> getOppProductRecords(id oppId){
		OpportunityLineItemsSelector oppProdSelector = new OpportunityLineItemsSelector();
		List<OpportunityLineItem> allOliRecordsList = oppProdSelector.selectByOpportunityId(oppId);
		Map<string, OpportunityLineItem> oliMap = new Map<string, OpportunityLineItem>();
		if (!allOliRecordsList.isEmpty()){
			for (OpportunityLineItem oli : allOliRecordsList){
				oliMap.put(oli.Product2.Name, oli);
				system.debug('oliMapValue: ' + oliMap);
			}
			return oliMap;
		} else{
			return null;
		}
	}

	/**
	 * @Saurabh
	 * @param oppId  The Opportunity Id
	 * @return  List<ProductContactSignatoryRelationship__c>   A list of ProductContactSignatoryRelationship__c
	 * @W: 004264
	 */
	@AuraEnabled
	public static List<ProductContactSignatoryRelationship__c> getProductSignatoryRecords(id oppAccId){
		//create Selector class later
		List<ProductContactSignatoryRelationship__c> addedSignatoryList = [Select id, PrimaryAccountId__c, Name, Product_Name__c, Signing_Purpose__c
		                                                                   from ProductContactSignatoryRelationship__c 
		                                                                   where PrimaryAccountId__c = :oppAccId];
		if (!addedSignatoryList.isEmpty()){
			return addedSignatoryList;
		} else{
			return null;
		}
	}

	/**
	 * @Saurabh
	 * @param oppId  The Opportunity Id
	 * @return parent Account Record related to Opportunity
	 * @W: 004264
	 */
	@AuraEnabled
	public static Account getAccountRecordforOpp(id oppId){
		//create Selector class later
		AccountsSelector accSelector = new AccountsSelector();
		Account accRecord = accSelector.selectByOpportunityId(oppId);
		if (accRecord != null){
			return accRecord;
		} else{
			return null;
		}
	}

	@AuraEnabled
	public static void deleteProdConSigRel(id recId){
		ProductContactSignatoryRelationship__c[] doomedRecs = [SELECT Id, Name
		                         FROM ProductContactSignatoryRelationship__c
		                         WHERE Id = : recId];
		try{
			delete doomedRecs;
		} catch (DmlException ex){
            System.debug('There was an error deleting - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
	}
}