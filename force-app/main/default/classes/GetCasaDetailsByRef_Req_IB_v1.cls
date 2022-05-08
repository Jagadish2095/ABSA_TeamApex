/*
* Request Bean class for GetCasaDetailsByRef
* @author Danie Booysen & Jason Quevauvilliers
* @created 2019-07-05
*/

public class GetCasaDetailsByRef_Req_IB_v1 extends Base_IB{
    
    public String refNo;
    public String startFrom;
    
    public static void dummyRequest(){
        GetCasaDetailsByRef_Req_IB_v1 requestBean = new GetCasaDetailsByRef_Req_IB_v1();
        requestBean.refNo = '243223';
        requestBean.startFrom = '';
    }
    
}