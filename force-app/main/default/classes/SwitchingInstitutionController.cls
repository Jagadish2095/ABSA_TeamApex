/**
 * @description       : Switching Institution Controller
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-15   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
 **/
public class SwitchingInstitutionController {
	/**
	 * @description searchNameLike
	 * @return List<Map<String,Object>>
	 * @param nameLike
	 */
	@AuraEnabled
	public static List<Map<String, Object>> searchNameLike(String nameLike) {
		List<Map<String, Object>> returnList = new List<Map<String, Object>>();
		string searchName = '%' + nameLike.trim() + '%';

		List<SwitchingInstitutions_Resp_IB_v1.Item> institutions = SwitchingInstitutions_IH_v1.getSwitchInstitutionByNameAndArchived('0', nameLike);

		for (SwitchingInstitutions_Resp_IB_v1.Item institution : institutions) {
			Map<String, Object> mapSite = new Map<String, Object>();
			mapSite.put('Name', institution.name);
			mapSite.put('Participation', institution.route);
			returnList.add(mapSite);
		}

		return returnList;
	}
	/**
	 * @description saveInstitution
	 * @return string
	 * @param name
	 * @param email
	 */
	@AuraEnabled
	public static string saveInstitutionToSwitchIt(string name, string email) {
		string returnMessage = '';
		try {
			SwitchingInstitutions_Req_IB_v1 switchingInstitutionRequestBean = new SwitchingInstitutions_Req_IB_v1();
			switchingInstitutionRequestBean.name = name;
			switchingInstitutionRequestBean.contactEmail = email;

			SwitchingInstitutions_Resp_IB_v1.Item institutionResp = SwitchingInstitutions_IH_v1.createSwitchingInstitution(switchingInstitutionRequestBean);
			if (institutionResp.exceptiondetails != null) {
				returnMessage = institutionResp.exceptiondetails.status + ': ' + institutionResp.exceptiondetails.message;
				throw new AuraHandledException(returnMessage);
			} else {
				return returnMessage = 'SUCCESS';
			}
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage() + ' ' + returnMessage);
		}
	}
}