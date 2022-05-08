/**
	 *@description Method :Integration Responce Bean
	 * @param none
	 * @author: Monde Masiza(Absa)
	 * @created date: 2019-03-04
	 * modified : Mbuyiseni Mbhokane
	 * @lastUpdated : 08/05/2021 | adding the dummyResponse method
* */

public class CreateLead_Resp_IB_v1 extends Base_IB {
	/**
	 * @description Method : response list
	 * @param none
	 */
    public List<Result> result;
	/**
	 * @@description Method :  response Class
	 * @param none
	 */
    
	public class Result {
		public String code;
		public String message;
	}

	/**
	 * @description Method :  create dummy data
	 * * @return responseBean 
	 */
	public static CreateLead_Resp_IB_v1 dummyResponse(){
		CreateLead_Resp_IB_v1 responseBean = new CreateLead_Resp_IB_v1();
		CreateLead_Resp_IB_v1.Result responseResult = new CreateLead_Resp_IB_v1.Result();
		List<CreateLead_Resp_IB_v1.Result> responseResultList = new List<CreateLead_Resp_IB_v1.Result>();

		responseResult.code = '0000';
		responseResult.message = 'Update member successful';
		responseResultList.add(responseResult);
		return responseBean;
	}
}