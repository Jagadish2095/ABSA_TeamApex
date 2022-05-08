/**
 * @description       : Individual customer Helper for the CasaScreenPrimary implementation
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-03
 * @last modified by  : PaulJohn.duRand@absa.africa
**/

public class CasaScreenPrimaryIndividualHelper implements ICasaScreenPrimaryClientHelper {
	/**
	* @description populate Request
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param objId
	* @return CASAScreenPrimaryClientV7_Req_IB_v1
	**/
	public CASAScreenPrimaryClientV7_Req_IB_v1 populateRequest(string objId) {
		string accountId = BranchFunctions.getAccountId(objId);
		Account account = [
			SELECT
				FirstName,
				LastName,
				ID_Type__pc,
				ID_Number__pc,
				Client_Group__c,
				PersonBirthdate,
				Nationality_List__pc,
				Country_of_Residence__pc,
				Country_of_Birth__pc
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
		Map<string, string> addressMap = BranchCustomerAddressHelper.getAddresses(accountId, new List<String>{ 'Residential' });
		Address__c address = [SELECT Shipping_Suburb__c FROM Address__c WHERE Id = :addressMap.Get('Residential') WITH SECURITY_ENFORCED];
		CASAScreenPrimaryClientV7_Req_IB_v1 requestBean = CASAScreenPrimaryClientV7_Req_IB_v1.GetInstance();
		requestBean.firstName = account.FirstName;
		requestBean.surnameComp = account.LastName;
		requestBean.idType = account.ID_Type__pc;
		requestBean.idRegNo = account.ID_Number__pc;
		requestBean.clientTypeGrp = account.Client_Group__c;
		requestBean.dob = String.ValueOf(account.PersonBirthdate).replace('-', '');
		requestBean.nationality = account.Nationality_List__pc;
		requestBean.town = address.Shipping_Suburb__c;
		requestBean.cntryOfRes = account.Country_of_Residence__pc;
		requestBean.cntryOfBirth = account.Country_of_Birth__pc;
		return requestBean;
	}

	/**
	* @description update Object
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param objId
	* @param response
	**/
	public void updateObject(string objId, CASAScreenPrimaryClientV7_Resp_IB_v1 response) {
		string accountId = BranchFunctions.getAccountId(objId);
		Contact con = getCasaUpdatable(accountId);
		con.CASA_Reference_Number__c = response.refNo;
		con.CASA_Screening_Status__c = (!response.casaStatus.contains('Error')) ? response.casaStatus : '';
		con.CASA_Screening_Date__c = system.Date.today();
		if (Contact.SObjectType.getDescribe().isUpdateable()) {
			update con;
		}
	}

	/**
	 * @description get Casa Details
	 * @param accountId
	 * @return Contact
	 */
	public Object getCasaDetails(string accountId) {
		Contact contactRecord = getCasaUpdatable(accountId);
		contactRecord.CASA_Screening_Status__c = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(contactRecord.CASA_Reference_Number__c);
		if (!contactRecord.CASA_Screening_Status__c.contains('Error') && Contact.SObjectType.getDescribe().isUpdateable()) {
			update contactRecord;
		}
		return getCasaDetailsObject(accountId);
	}

	/**
	* @description get Casa Reference
	* @author PaulJohn.duRand@absa.africa | 2021-08-03
	* @param accountId
	* @return String
	**/
	public String getCasaReference(string accountId) {
		Contact contact = [
			SELECT Id, CASA_Reference_Number__c
			FROM Contact
			WHERE AccountId = :accountId
			WITH SECURITY_ENFORCED
		];
		return contact.CASA_Reference_Number__c;
	}

    /**
    * @description update Analyst Comments
    * @author PaulJohn.duRand@absa.africa | 2021-08-03
    * @param accountId
    * @param comments
    **/
    public void updateAnalystComments(string accountId,string comments){
		Contact ContactRecord = getCasaUpdatable(accountId);
		ContactRecord.CASA_Analyst_Comments__c = comments;
		update ContactRecord;
    }

	/**
	* @description get Casa Updatable
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param accountId
	* @return Contact
	**/
	private Contact getCasaUpdatable(string accountId){
		Contact contact = [
			SELECT Id, CASA_Reference_Number__c, CASA_Screening_Status__c, CASA_Screening_Date__c,CASA_Analyst_Comments__c
			FROM Contact
			WHERE AccountId = :accountId
			WITH SECURITY_ENFORCED
		];
		return contact;
	}

	/**
	* @description get Casa Details Object
	* @author PaulJohn.duRand@absa.africa | 2021-08-02
	* @param accountId
	* @return Contact
	**/
	private Contact getCasaDetailsObject(string accountId){
		Contact primary = [
			SELECT Id, CASA_Reference_Number__c, CASA_Screening_Status__c, CASA_Screening_Date__c, Account.FirstName, Account.LastName, Account.ID_Number__pc
			FROM Contact
			WHERE AccountId = :accountId
			WITH SECURITY_ENFORCED
		];
		return primary;
	}
}