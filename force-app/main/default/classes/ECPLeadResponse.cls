/**
 * @description       :
 * @author            : jacobuschristiaan.delange@absa.africa
 * @group             :
 * @last modified on  : 2021-05-27
 * @last modified by  : jacobuschristiaan.delange@absa.africa
 * Modifications Log
 * Ver   Date         Author                                  Modification
 * 1.0   2021-05-25   jacobuschristiaan.delange@absa.africa   Initial Version
 **/
public class ECPLeadResponse {
	public Boolean isValid;
	public String requestId;

	/**
	 * @description
	 * @author jacobuschristiaan.delange@absa.africa | 2021-05-25
	 * @param json
	 * @return ECPLeadResponse
	 **/
	public static ECPLeadResponse parse(String json) {
		return (ECPLeadResponse) System.JSON.deserialize(json, ECPLeadResponse.class);
	}
}