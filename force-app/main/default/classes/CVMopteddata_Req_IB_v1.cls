/*
 * Request Integration Bean for vBlistusersv1 Service
 * @author Rankwe Lulu
 * @created 2020-10-12
 */
public class CVMopteddata_Req_IB_v1 extends Base_IB{

    public list<Cls_CVMopteddata> CVMopteddata;
    
    public class Cls_CVMopteddata{
        public String Message;
        public String ProviderName;
        public String CIFkey;
        
    }
    public static CVMopteddata_Req_IB_v1 createDummyRequest(){
        CVMopteddata_Req_IB_v1 requestBean = new CVMopteddata_Req_IB_v1();
        List<CVMopteddata_Req_IB_v1.Cls_CVMopteddata> cvmopteddataLst =  new List<CVMopteddata_Req_IB_v1.Cls_CVMopteddata>();
        CVMopteddata_Req_IB_v1.Cls_CVMopteddata reqBean = new CVMopteddata_Req_IB_v1.Cls_CVMopteddata(); 
            
        reqBean = new CVMopteddata_Req_IB_v1.Cls_CVMopteddata();
        
        reqBean.ProviderName ='Customer1';
        reqBean.Message ='msg';
        reqBean.CIFkey = 'CIF_NDHL008'; 
        cvmopteddataLst.add(reqBean);
        
        requestBean.CVMopteddata = cvmopteddataLst;
        
        return requestBean;
    }

    
}