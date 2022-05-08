/**
 * @description Absa Life Member Maintenance class
 * @author  Koketso Mpshane
 * @since   2021-06-25
 */
public class AbsaLifeMemberMaintenance {
    /**
	 * @description fetchPolicyDetails
	 * @param policyNumber
	 * @return String
	 */
	@AuraEnabled
	public static String fetchPolicyDetails(String policyNumber) {
        String results;
		PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);

        //check if response is null
        if (responseBean == null) {
            return 'Error: Blank response received from service;';
        }

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        if(responseBean.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult != null){
            results = JSON.serialize(responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult);
        }

        return results;
	}

    /**
	 * @description Alter Sum Assured Amount
	 * @param contractGid
	 * @param lifeAssuredGid
	 * @param productId
	 * @return String
	 */
	@AuraEnabled
	public static String deleteMemberDetails(String contractGid, String lifeAssuredGid, String productId) {

		ContractDeleteComponent_Resp_IB_v1 responseBean = ContractDeleteComponent_IH_v1.ContractDeleteComponent(contractGid, lifeAssuredGid, Integer.valueOf(productId));

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        //check if response and response result is null
        if (responseBean == null || responseBean.Contract_Delete_ComponentResponse?.Contract_Delete_ComponentResult == null) {
            return 'Error: Blank response received from service;';
        }

        //check if response result is not successful
        if (responseBean.Contract_Delete_ComponentResponse?.Contract_Delete_ComponentResult == '0') {
            String errorMessages = 'Error: ';
            for(ContractDeleteComponent_Resp_IB_v1.V3_DC2_LoggedMsg errorMsg: responseBean.Contract_Delete_ComponentResponse?.pcolValidationMessages?.V3_DC2_LoggedMsg){
                errorMessages += errorMsg.Message + '; ';
            }
            return errorMessages;
        }
        return responseBean.Contract_Delete_ComponentResponse?.Contract_Delete_ComponentResult;
	}
    
    /**
	 * @description Contract cancel policy
	 * @param contractGid
	 * @param cancelRequestDate
	 * @param decisionReason
	 * @param decisionNote
	 * @return String
	 */
	@AuraEnabled
	public static String contractCancelPolicy(String contractGid, String cancelRequestDate, String decisionReason, String decisionNote) {

        String decisionReasonID = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
            'Exergy',
            'Cancel Reason',
            decisionReason,
            StringConstants.OUTBOUND_RECORD_TYPE
        );
        
		ContractCancel_Resp_IB_v1 responseBean = ContractCancel_IH_v1.ContractCancel(contractGid, Integer.valueOf(decisionReasonID), decisionNote, cancelRequestDate, decisionReason);

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        //check if response and response result is null
        if (responseBean == null || responseBean.Contract_CancelResponse?.Contract_CancelResult == null) {
            return 'Error: Blank response received from service;';
        }

        //check if response result is not successful
        if (responseBean.Contract_CancelResponse?.Contract_CancelResult == '0') {
            String errorMessages = 'Error: ';
            for(ContractCancel_Resp_IB_v1.DC2LoggedMsg errorMsg: responseBean.Contract_CancelResponse?.plstLoggedMessages?.DC2LoggedMsg){
                errorMessages += errorMsg.Message + '; ';
            }
            return errorMessages;
        }
        return responseBean.Contract_CancelResponse?.Contract_CancelResult;
	}
    
     /**
	 * @description Contract lapse policy
	 * @param contractGid
	 * @param movementDate
	 * @param reasonDesc
	 * @param note
	 * @return String
	 */
	@AuraEnabled
	public static String contractLapsePolicy(String contractGid, String movementDate, String reasonDesc, String note) {

        String lapseReasonID = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
            'Exergy',
            'Lapse Reason',
            reasonDesc,
            StringConstants.OUTBOUND_RECORD_TYPE
        );
        
		ContractLapse_Resp_IB_v1 responseBean = ContractLapse_IH_v1.ContractLapse(contractGid, movementDate, Integer.valueOf(lapseReasonID), reasonDesc, note);

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        //check if response and response result is null
        if (responseBean == null || responseBean.contractLapseResponse?.Contract_LapseResult == null) {
            return 'Error: Blank response received from service;';
        }

        //check if response result is not successful
        if (responseBean.contractLapseResponse?.Contract_LapseResult != true) {
            return 'Error: ' + responseBean.contractLapseResponse?.plstLoggedMessages?.DC2LoggedMsg.get(1).Message;
        }
        
        return 'Successful';
	}
    
    /**
	 * @description get policy cancellation reasons
     * @param reasonValueType
	 * @return List<String>
	 */
    @AuraEnabled
    public static List<String> getReasons(String reasonValueType) {
        List<String> results = new List<String>();
        List<Integration_Translation__c> translationList = [Select Internal_Value__c From Integration_Translation__c Where System_Name__c =:'Exergy' And Value_Type__c =: reasonValueType];
        
        if(translationList.size() > 0){
            for(Integration_Translation__c intTranslation: translationList){
                results.add(intTranslation.Internal_Value__c);
            }
        }
        return results;
    }
    
    /**
	 * @description get Exergy Lookup Values Mapping
	 * @return String
	 */
    @AuraEnabled
    public static String getExergyLookupValuesMapping() {
        
        StaticResource results = [Select Id, Body From StaticResource Where Name =: 'ExergyLookupValuesMapV1' Limit 1];
        return results.Body.toString();
        
    }
    
    /**
	 * @description Search Member Details
	 * @param idType
	 * @param idNumber
	 * @return String
	 */
	@AuraEnabled
	public static String searchMemberDetails(Integer idType, String idNumber) {

        ClientSearch_Resp_IB_v1 responseBean = ClientSearch_IH_v1.ClientSearch(idType, idNumber);

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        //check if response and response result is null
        if (responseBean == null || responseBean.Client_SearchResponse?.Client_SearchResult == null) {
            return 'Error: Blank response received from service;';
        }
        
        //check if client exists
        if (responseBean.Client_SearchResponse?.Client_SearchResult?.DC2Client?.Identifiers == null) {
            return 'Error: Client not found;';
        }

        return JSON.serialize(responseBean.Client_SearchResponse.Client_SearchResult.DC2Client);
    }
    
    /**
	 * @description Get BenefitType Details
	 * @param contractTypeId
	 * @return String
	 */
	@AuraEnabled
	public static String getBenefitTypeDetails(String contractTypeId) {

        ContractGetComponent_Resp_IB_v1 responseBean = ContractGetComponent_IH_v1.ContractGetComponent(Integer.valueOf(contractTypeId));

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        //check if response and response result is null
        if (responseBean == null || responseBean.Contract_getComponentsResponse?.Contract_getComponentsResult == null) {
            return 'Error: Blank response received from service;';
        }

        return JSON.serialize(responseBean.Contract_getComponentsResponse?.Contract_getComponentsResult?.DC2LookUp);
    }
    
    /**
	 * @description Add Member Details
	 * @param memberDetails
	 * @return String
	 */
	@AuraEnabled
	public static String addMemberDetails(Map<String, String> memberDetails) {
      
        ContractAddComponent_Resp_IB_v1 responseBean = ContractAddComponent_IH_v1.ContractAddComponent(memberDetails);

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        //check if response and response result is null
        if (responseBean == null || responseBean.Contract_Add_ComponentResponse?.Contract_Add_ComponentResult == null) {
            return 'Error: Blank response received from service;';
        }
        
        //check if client exists
        if (responseBean.Contract_Add_ComponentResponse.Contract_Add_ComponentResult?.IsSuccess != '1') {
            return 'Error: ' + responseBean.Contract_Add_ComponentResponse.Contract_Add_ComponentResult.ValidationError;
        }

        return JSON.serialize(responseBean.Contract_Add_ComponentResponse.Contract_Add_ComponentResult);
    }

}