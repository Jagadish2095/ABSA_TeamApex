/*
 * Integration Utility for GetTriads Service
 * @author Almas Aleem
 * @created 2020-09-16
 */
public class GetTriads_IU_v1 {
    
    /* Creates a request bean 
     * @param: string ClientCode
     * @return: GetTriads_IB_v1 bean object
     */
    public static GetTriads_Req_IB_v1 mapRequestFields(String clientCode){
         GetTriads_Req_IB_v1 requestBean = new GetTriads_Req_IB_v1();
        requestBean.TRC519I = new GetTriads_Req_IB_v1.TRC519I();
        requestBean.TRC519I.TRC519I_INPUT_DATA = new GetTriads_Req_IB_v1.TRC519I_INPUT_DATA();
        requestBean.TRC519I.TRC519I_INPUT_DATA.TRC519I_CLIENT = clientCode; //client Code ,CIF Number
        //requestBean.TRC519I.TRC519I_INPUT_DATA.TRC519I_ACCOUNT_NO = '00981223'; //account number optional field
        requestBean.NBSAPDPI  = new GetTriads_Req_IB_v1.NBSAPDPI();
       	GetTriads_Req_IB_v1.NBSAPLI  nbsapli = new GetTriads_Req_IB_v1.NBSAPLI();
        nbsapli.NBNAPLI_APPLICATION='jofp';
        nbsapli.NBNAPLI_TRACE='k';     
        requestBean.NBSAPDPI.NBSAPLI = nbsapli;
    
        return requestBean;
        
    }
	 
}