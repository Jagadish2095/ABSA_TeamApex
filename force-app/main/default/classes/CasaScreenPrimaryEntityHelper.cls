/**
 * @description       : CasaScreen Primary Entity Helper
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-04
 * @last modified by  : PaulJohn.duRand@absa.africa
**/

public class CasaScreenPrimaryEntityHelper implements ICasaScreenPrimaryClientHelper {
	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param objId
	* @return CASAScreenPrimaryClientV7_Req_IB_v1
	**/
	public CASAScreenPrimaryClientV7_Req_IB_v1 populateRequest(string objId) {
		string accountId = BranchFunctions.getAccountId(objId);

		return null;
	}

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param objId
	* @param response
	**/
	public void updateObject(string objId, CASAScreenPrimaryClientV7_Resp_IB_v1 response) {
		string accountId = BranchFunctions.getAccountId(objId);
		Account accountRecord = getCasaDetailsObject(accountId);
		accountRecord.CASA_Reference_Number__c = response.refNo;
		accountRecord.CASA_Screening_Status__c = (!response.casaStatus.contains('Error')) ? response.casaStatus : '';
		accountRecord.CASA_Screening_Date__c = system.Date.today();
		if (account.SObjectType.getDescribe().isUpdateable()) {
			update accountRecord;
		}
	}

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param accountId
	* @return Contact
	**/
	public Account getCasaDetails(string accountId){
		Account primary = [SELECT Id, Name, CASA_Reference_Number__c, CASA_Screening_Status__c, CASA_Screening_Date__c FROM Account WHERE Id = :accountId];
		primary.CASA_Screening_Status__c = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(primary.CASA_Reference_Number__c);
		if (!primary.CASA_Screening_Status__c.contains('Error')) {
			update primary;
		}
		return primary;
	}

    	/**
    * @description
    * @author PaulJohn.duRand@absa.africa | 2021-08-02
    * @param accountId
    * @return Object
    **/
    public string getCasaReference(string accountId){
        Account account = [
			SELECT Id, CASA_Reference_Number__c
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
		return account.CASA_Reference_Number__c;
    }

    /**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param accountId
	* @return Contact
	**/
	public Account getCasaUpdatable(string accountId){
		Account accountRecord = [
			SELECT Id, CASA_Reference_Number__c, CASA_Screening_Status__c, CASA_Screening_Date__c,CASA_Analyst_Comments__c
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
		return accountRecord;
	}

	/**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-03
	* @param accountId
	* @param comments
	**/
	public void updateAnalystComments(string accountId,string comments){
        Account ContactRecord = getCasaUpdatable(accountId);
		ContactRecord.CASA_Analyst_Comments__c = comments;
		update ContactRecord;
    }

    /**
	* @description
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param accountId
	* @return Contact
	**/
	private Account getCasaDetailsObject(string accountId){
		Account primary = [
			SELECT CASA_Reference_Number__c, CASA_Screening_Status__c, CASA_Screening_Date__c
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
		return primary;
	}
}