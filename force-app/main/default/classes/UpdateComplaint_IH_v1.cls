/**
* Integration Handler for Update Complaint function
* @author Anka Ganta
* @created 2019-08-15
* @Updated 
* @Updated 
*/
public class UpdateComplaint_IH_v1 {

    /* Update Case/Complaint in SF
     * @param: UpdateComplaint_Req_IB_v1 instance / JSON String
     * @param: caseNumber
     * @return: UpdateComplaint_Resp_IB_v1 object*/
    public static UpdateComplaint_Resp_IB_v1 updateComplaint(UpdateComplaint_Req_IB_v1 wrpVals,String caseNumber){
        
        //Validate that all the required parameters were sent
       String errorMessage = wrpVals.Validate();
        
        if(String.isNotBlank(errorMessage)){
            //return bad response
            return UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_400, 400, errorMessage, null,null,null);
        }
        
        // Check if case Exists
         if(caseNumber != '' || caseNumber != null){
            
            Case updateCase;
            Task task;
            String description;
            
            try{
                updateCase = UpdateComplaint_IU_v1.mapFieldsCase(wrpVals,caseNumber);
                if(updateCase != null){
                update updateCase;
                System.debug('updated case'+updateCase);
                description = StringConstants.MSG_CASE_UPDATE_FROM_TOM;
                }
                //return good response 
                return UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_200, 200, description, updateCase.Id,wrpVals.tomDecision,wrpVals.TomReason);
            
             }catch(Exception e){
                //return bad response
                description = StringConstants.ERROR_MSG_COULD_NOT_UPDATE_RECORD + e.getMessage() + '. ' + e.getStackTraceString();
                return UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_500, 500, description, null,null,null);
            }
            
        }else if(caseNumber == null){
            //no user found - return bad response 
            return UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_406, 406, StringConstants.ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_NONE +caseNumber, null,null,null);
        }else{
            //multiple users found - return bad response 
            return UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_406, 406, StringConstants.ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_MULTIPLE + caseNumber, null,null,null);
        }
    }  
   
}