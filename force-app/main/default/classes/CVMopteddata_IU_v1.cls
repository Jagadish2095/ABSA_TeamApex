/*
 * Integration Utility class for vBlistusersv1 Service
 * @author  Rankwe Lulu
 * @created 2020-10-12
 */
public class CVMopteddata_IU_v1 {
    
    public static CVMopteddata_Req_IB_v1 mapRequestFields(List<String> cifKeyList){
        
        CVMopteddata_Req_IB_v1 requestBean = new CVMopteddata_Req_IB_v1();
        List<CVMopteddata_Req_IB_v1.Cls_CVMopteddata> cvmopteddataLst =  new List<CVMopteddata_Req_IB_v1.Cls_CVMopteddata>();
        CVMopteddata_Req_IB_v1.Cls_CVMopteddata reqBean = new CVMopteddata_Req_IB_v1.Cls_CVMopteddata(); 
        
        for(String cifKey : cifKeyList){
            
            reqBean = new CVMopteddata_Req_IB_v1.Cls_CVMopteddata();
            
            reqBean.ProviderName ='CFM';
            reqBean.Message ='Customer 1';
            reqBean.CIFkey = cifKey; 
            cvmopteddataLst.add(reqBean);
        }
        requestBean.CVMopteddata = cvmopteddataLst;
        
        return requestBean;
        
        
   

    }
    
    
    

}