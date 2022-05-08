/*
* Integration Handler for NCA Status Retrive Service
* @author Almas Aleem:Absa  
* @created 2020-11-26
*/
public class GetNCARetrieve_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'NCARetrieve';
    
    public static GetNCARetrieve_Resp_IB_v1 GetNCAStatus(Integer assetValue,Integer turnOver) {
        GetNCARetrieve_Req_IB_v1 requestBean = GetNCARetrieve_IU_v1.mapRequestFields(assetValue,turnOver); //request mapping
        system.debug('requestBean'+requestBean);
        
        GetNCARetrieve_Resp_IB_v1 responseBean = (GetNCARetrieve_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GetNCARetrieve_Resp_IB_v1.class); //service callout
        return responseBean;
    }
    //Added by Diksha for NCA Results writing different method so that it dosen't affect existing work.
    public static GetNCARetrieve_Resp_IB_v1 GetNCAStatus2(Integer assetValue,Integer turnOver,Integer clientType,Integer agreementSize,String agreementType,Integer trustees,Boolean anyJuristicTrustee,Boolean securedByMortgage) {  
        GetNCARetrieve_Req_IB_v1 requestBean = GetNCARetrieve_IU_v1.mapRequestFields(assetValue,turnOver,clientType,agreementSize,agreementType, trustees,anyJuristicTrustee,securedByMortgage); 
        system.debug('requestBean for nca'+json.serializePretty(requestBean));
        GetNCARetrieve_Resp_IB_v1 responseBean = (GetNCARetrieve_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GetNCARetrieve_Resp_IB_v1.class); //service callout
        return responseBean;
    }
    
}