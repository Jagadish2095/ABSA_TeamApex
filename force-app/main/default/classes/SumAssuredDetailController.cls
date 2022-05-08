/**
 * @description userstory W-007781
 * @author  Chandra Bhushan Singh : ABSA
 * @since   2021-02-10
 * @updated Koketso Mpshane 07-06-2021
 */
public class SumAssuredDetailController {
	/**
	 * @description fetchPolicyDetails
	 * @param policyNumber
	 * @return String
	 */
	@AuraEnabled
	public static String fetchPolicyDetails(String policyNumber) {
        String results;
		PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }
        
        //check if response is null
        if (responseBean == null) {
            return 'Error: Blank response received from service;';
        }
        
        if(responseBean.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult != null){
            results = JSON.serialize(responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult);
        }
        
        return results;
	}

    /**
	 * @description Get calculated premium amount
	 * @param contractGid
	 * @param lifeAssuredGid
	 * @param productId
	 * @param coverAmount
	 * @return String
	 */
	@AuraEnabled
	public static String getCalculatedPremiumAmount(String contractGid, String lifeAssuredGid, String productId, String coverAmount) {
        
        String results;
		ContractPremiumSumAssured_Resp_IB_v1 responseBean = ContractPremiumSumAssured_IH_v1.ContractPremiumSumAssured(contractGid, lifeAssuredGid, Integer.valueOf(productId), Integer.valueOf(coverAmount));
        
        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }
        
        //check if response and response result is null
        if (responseBean == null || responseBean.Contract_Premium_SumAssuredResponse?.Contract_Premium_SumAssuredResult == null) {
            return 'Error: Blank response received from service;';
        }
        
        //check if response result is not successful
        if (responseBean.Contract_Premium_SumAssuredResponse?.Contract_Premium_SumAssuredResult == '0') {
            String errorMessages = 'Error: ';
            for(ContractPremiumSumAssured_Resp_IB_v1.V3_DC2_LoggedMsg errorMsg: responseBean.Contract_Premium_SumAssuredResponse?.pcolValidationMessages?.V3_DC2_LoggedMsg){
                errorMessages += errorMsg.Message + '; ';
            }
            return errorMessages;
        }
        
        return responseBean.Contract_Premium_SumAssuredResponse?.Contract_Premium_SumAssuredResult;
	}
    
    /**
	 * @description Alter Sum Assured Amount
	 * @param contractGid
	 * @param lifeAssuredGid
	 * @param productId
	 * @param coverAmount
	 * @return String
	 */
	@AuraEnabled
	public static String alterSumAssuredAmount(String contractGid, String lifeAssuredGid, String productId, String coverAmount) {
        
        String results;
		ContractAlterSumAssured_Resp_IB_v1 responseBean = ContractAlterSumAssured_IH_v1.ContractAlterSumAssured(contractGid, lifeAssuredGid, Integer.valueOf(productId), Integer.valueOf(coverAmount));
        
        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }
        
        //check if response and response result is null
        if (responseBean == null || responseBean.Contract_Alter_SumAssuredResponse?.Contract_Alter_SumAssuredResult == null) {
            return 'Error: Blank response received from service;';
        }
        
        //check if response result is not successful
        if (responseBean.Contract_Alter_SumAssuredResponse?.Contract_Alter_SumAssuredResult == '0') {
            String errorMessages = 'Error: ';
            for(ContractAlterSumAssured_Resp_IB_v1.V3_DC2_LoggedMsg errorMsg: responseBean.Contract_Alter_SumAssuredResponse?.pcolValidationMessages?.V3_DC2_LoggedMsg){
                errorMessages += errorMsg.Message + '; ';
            }
            return errorMessages;
        }
        
        return responseBean.Contract_Alter_SumAssuredResponse?.Contract_Alter_SumAssuredResult;
	}

}