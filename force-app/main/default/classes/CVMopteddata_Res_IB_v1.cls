/*
 * Response Integration Bean for vBlistusersv1 Service
 * @author Rankwe Lulu
* @created 2020-10-12
*/
public class CVMopteddata_Res_IB_v1 extends Base_IB{
    public Integer statusCode;
    public String ProviderName{get;set;}
    public String Message{get;set;}
    public String CIFkey{get;set;}
    
    public static CVMopteddata_Res_IB_v1 createDummyResponse(){
        
        CVMopteddata_Res_IB_v1 response = new CVMopteddata_Res_IB_v1();       
        response.ProviderName ='Customer1';
        response.Message ='msg';
        response.CIFkey = 'CIF_NDHL008'; 

        return response;
        
        
    }

}