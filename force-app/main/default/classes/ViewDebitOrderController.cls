/*Controller for ViewDebitOrder Component
* @author Prasanna Patwardhan:Absa
* @since 26/10/2019
*/
public class ViewDebitOrderController {
            
    @AuraEnabled
    public static string viewDebitOrderDetails(String AccountId,string FrmDate){
        Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = DSretrieveDebitsCreditsInqV1_IH_v1.DSretrieveDebitsCreditsInqV1Details(AccountId,FrmDate);
      
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = (new List<DSretrieveDebitsCreditsInqV1_Resp_IB_v1>(responseMap.keySet()))[0];
               
        if(responseBean.statusCode == 200){
            DSretrieveDebitsCreditsInqV1_Resp_IB_v1.DSretrieveDebitsCreditsInqV1Response cls_retrieveDebitsCreditsInqWrapper = responseBean.DSretrieveDebitsCreditsInqV1Response;
            DSretrieveDebitsCreditsInqV1_Resp_IB_v1.Dsp973o dsp973o = cls_retrieveDebitsCreditsInqWrapper.Dsp973o;
            return JSON.serialize(dsp973o);
        }else{
            
            system.debug('Error');
        }
        
        return null;
        
    }
    
     @AuraEnabled
    Public static void sendEmailOnCaseClose(Id caseRecordId)
    {
               if(caseRecordId!=null){
                  Case caseObj = new Case(Id=caseRecordId);
                  caseObj.Status = 'Closed';
                  Update caseObj;
               }                                
     }
    
}