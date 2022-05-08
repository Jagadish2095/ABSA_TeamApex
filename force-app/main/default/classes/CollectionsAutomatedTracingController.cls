/**
 * @description Controller class for CollectionsAutomatedTracing cmp
 * @author Jason Quevauvilliers
 * @created 2021-04-12
 */
public class CollectionsAutomatedTracingController {
	@AuraEnabled
	/**
	 * @description Calls CPBValidate Service
	 * @param idNumber
	 * @param clientSurname
	 * @return CPBValidate_Resp_IB_v1
	 */
	public static CPBValidate_Resp_IB_v1 getContactDetailsFromCPB(String idNumber, String clientSurname) {
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

		if (String.isBlank(currentUser.AB_Number__c)) {
			AuraHandledException e = new AuraHandledException('User AB Number Missing');
			e.setMessage('User AB Number Missing');
			throw e;
		}
      
		//Call Integration Service
		Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate(idNumber, clientSurname);
		//Asynchronously Insert Log
		SystemLogger.insertLog(responseMap.values()[0][0]);
		//Get Bean from Response Map
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		return responseBean;
	}
}