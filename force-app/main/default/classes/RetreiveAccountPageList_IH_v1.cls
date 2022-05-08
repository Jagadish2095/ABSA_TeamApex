/**
* @description Integration Handler class for Retreive Account PageList Service
* @author Manideep kenche
* @created 2021-08-20
*/
public class RetreiveAccountPageList_IH_v1 {
    
public static final String INTEGRATION_SERVICE_NAME = 'Retrieve Account Page List';

/**
* @description RetreiveAccountPageList
* @param AGENCY_ID
* @return RetreiveAccountPageList_Resp_IB_v1
*/    
     public static RetreiveAccountPageList_Resp_IB_v1 RetreiveAccountPageList(string AGENCY_ID){
        
        
        Map<String, string> storeheader = RetreiveAccountPageList_IU_v1.mapRequestFields(AGENCY_ID);
        
        RetreiveAccountPageList_Resp_IB_v1 responseBean = (RetreiveAccountPageList_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(null,null,storeheader,INTEGRATION_SERVICE_NAME, RetreiveAccountPageList_Resp_IB_v1.class);
        
        return responseBean;
    }
}