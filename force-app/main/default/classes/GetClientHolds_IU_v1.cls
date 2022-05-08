/*US:W-002572
*Description:Web Service utility class to get Client Holds From CIF For Client Hold Indicator
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-07-31
*/
public class GetClientHolds_IU_v1 {

       public static GetClientHolds_Req_IB_v1 mapRequestFields(String cifNumber){
        
       //map request bean to http request
      GetClientHolds_Req_IB_v1 requestBean = new GetClientHolds_Req_IB_v1();
            requestBean.clcda =cifNumber; //Client Code to map           
            System.debug('Get Client Holds Request Bean: ' + requestBean);
            return requestBean;
    }
    
    //Populates the Get Client Details response bean from an http response
    public static GetClientHolds_Resp_IB_v1 mapResponseFields(HttpResponse respP){    
        GetClientHolds_Resp_IB_v1 responseBean = new GetClientHolds_Resp_IB_v1();
        responseBean = (GetClientHolds_Resp_IB_v1)responseBean.deserialize( respP.getBody(), GetClientHolds_Resp_IB_v1.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Get Client Details Response Bean: ' + responseBean);
        return responseBean;
    }
    
}