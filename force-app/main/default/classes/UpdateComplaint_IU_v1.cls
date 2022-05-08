/**
* Integration Handler for Update Complaint function
* @author Anka Ganta : absa
* @created 2019-08-15
* @Updated 
* @Updated 
*/
public class UpdateComplaint_IU_v1 {
    
    /* Map fields to an Case
     * @param: caseNumber
     * @param: UpdateComplaint_Req_IB_v1 instance
     * @param: caseNumber
     
     * @return: Case*/
    public static Case mapFieldsCase(UpdateComplaint_Req_IB_v1 updateComplaintPatchP , String caseNumber){

       
        //Map fields to Case
        Case mapCase;
        
        List<Case> mapCaseList = [SELECT Id,TomDecision__C,TomReason__C,CaseNumber FROM Case WHERE CaseNumber = :caseNumber limit 1];
         
         if(mapCaseList.size()>0)  {        
         
            mapCase = mapCaseList[0];
            if(updateComplaintPatchP.tomDecision != null){
            mapCase.TomDecision__C = updateComplaintPatchP.tomDecision;
            }
            if(updateComplaintPatchP.tomReason != null){
            mapCase.TomReason__C = updateComplaintPatchP.tomReason;
            }
        }
        return mapCase;

    }
    

    
    /* Map Response fields to UpdateComplaint_Resp_IB_v1
     * @param: Status
     * @param: Description
     * @param: Case Id
     * @param: tomDecision
     * @param: tomReason
     * @return: UpdateComplaint_Resp_IB_v1 object*/
    public static UpdateComplaint_Resp_IB_v1 mapFieldsUpdateComplaintResponse(String statusP, Integer statusCodeP, String descriptionP, String caseIdP,String tomDecisionP, String tomReasonP){
        
        UpdateComplaint_Resp_IB_v1 updateComplaintResponse = new UpdateComplaint_Resp_IB_v1();
        
        updateComplaintResponse.status = statusP;
        updateComplaintResponse.statusCode = statusCodeP;
        updateComplaintResponse.description = descriptionP;
        updateComplaintResponse.tomDecision = tomDecisionP;
        updateComplaintResponse.tomReason = tomReasonP;
        if(caseIdP != null ){
            updateComplaintResponse.caseId = caseIdP;
        }
        
        
        return updateComplaintResponse;
    }
    
    
    
    
}