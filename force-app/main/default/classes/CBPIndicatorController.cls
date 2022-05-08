/*
* CBPIndicatorController
** @author  Satya Boyenepalli: Absa
* @version v1.0
* @since   2020-11-14
*/
public with sharing class CBPIndicatorController {
    @AuraEnabled    
    public static IZcreateUniqueKeyV1_Resp_IB_v1  getCBPIndicator()
    {
         IZcreateUniqueKeyV1_Resp_IB_v1 responsegetcbiindicator  = new IZcreateUniqueKeyV1_Resp_IB_v1();
        try{
            IZcreateUniqueKeyV1_Req_IB_v1 requestBean = new IZcreateUniqueKeyV1_Req_IB_v1();
            requestBean.NBSAPDPI  = new IZcreateUniqueKeyV1_Req_IB_v1.NBSAPDPI ();
            requestBean.NBSAPDPI.InputHeaders  = new IZcreateUniqueKeyV1_Req_IB_v1.InputHeaders ();
            
            requestBean.NBSAPDPI.InputHeaders.channelName = 'F';
            requestBean.NBSAPDPI.InputHeaders.applicationName = 'F';
            requestBean.NBSAPDPI.InputHeaders.traceIndicator = 'N';
            
            requestBean.NBSMSGI  = new IZcreateUniqueKeyV1_Req_IB_v1.NBSMSGI ();
            requestBean.NBSMSGI.InputErrorMessage  = new IZcreateUniqueKeyV1_Req_IB_v1.InputErrorMessage ();
            
            requestBean.NBSMSGI.InputErrorMessage.inputErrorMessageLanguage = 'E';
            requestBean.NBSMSGI.InputErrorMessage.inputErrorMessageTarget = 'STD';
            
            requestBean.IZBKEYI  = new IZcreateUniqueKeyV1_Req_IB_v1.IZBKEYI ();
            requestBean.IZBKEYI.InputDetail  = new IZcreateUniqueKeyV1_Req_IB_v1.InputDetail ();
            
            requestBean.IZBKEYI.InputDetail.requestType = 'A'; 
            
            responsegetcbiindicator = (IZcreateUniqueKeyV1_Resp_IB_v1)IZcreateUniqueKeyV1_IH_v1.IZcreateUniqueKey(requestBean);
            
        } catch(Exception exc){

            throw new AuraHandledException(exc.getMessage());
                    
        }
      
       return responsegetcbiindicator;
      
    }
    
}