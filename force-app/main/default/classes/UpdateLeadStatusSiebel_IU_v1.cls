/**
* Integration Utility for Update Lead Status in Siebel function
* To be used by UpdateLeadStatusSiebel_IH_v1 for various operations
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-08-22
*/

public class UpdateLeadStatusSiebel_IU_v1 {
    
    /* Maps the request values when a lead status is updated in siebel
	* @param: External Id
	* @param: Closed Reason
	* @param: Sales method
	* @param: Sales stage
	* @return: Mapped instance of the update siebel request bean*/
    public static updateLeadStatusSiebel_Req_IB_v1 mapFieldsUpdateLeadStatusSiebelRequest(String externalIdP, String reasonWonLostP, String salesMethodP, String salesStageP){
        
        UpdateLeadStatusSiebel_Req_IB_v1 siebelUpdateLeadStatusRequest = new UpdateLeadStatusSiebel_Req_IB_v1();
        
        siebelUpdateLeadStatusRequest.id = externalIdP;
        siebelUpdateLeadStatusRequest.salesMethod = salesMethodP;
        siebelUpdateLeadStatusRequest.salesStage = salesStageP;
        siebelUpdateLeadStatusRequest.reasonWonLost = reasonWonLostP;
        
        return siebelUpdateLeadStatusRequest;
    }
    
    /* Maps the response values when a lead status is updated in siebel
	* @param: Status Code
	* @param: Status
	* @param: Response Body
	* @return: Mapped instance of the update siebel response bean*/
    public static updateLeadStatusSiebel_Resp_IB_v1 mapFieldsUpdateLeadStatusSiebelResponse(Integer statusCodeP, String statusP, String messageP){
        
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelUpdateLeadStatusResponse = new UpdateLeadStatusSiebel_Resp_IB_v1();
        
        siebelUpdateLeadStatusResponse.statusCode = statusCodeP;
        siebelUpdateLeadStatusResponse.status = statusP;
        siebelUpdateLeadStatusResponse.description = messageP;
        
        return siebelUpdateLeadStatusResponse;
    }
    
}