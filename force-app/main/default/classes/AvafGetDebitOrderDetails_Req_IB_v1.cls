/*
 * Request Integration Bean for AvafDebitOrderDetails Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetDebitOrderDetails_Req_IB_v1 extends Base_IB{

    public BAPI_SF_DO_DETAILS[] BAPI_SF_DO_DETAILS;

    public class BAPI_SF_DO_DETAILS{
        public String I_ACCOUNT;
        public String I_USER;
    }

    public static AvafGetDebitOrderDetails_Req_IB_v1 createDummyRequest(){
        AvafGetDebitOrderDetails_Req_IB_v1 requestBean = new AvafGetDebitOrderDetails_Req_IB_v1();
        List<AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS> doDetailsList = new List<AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS>();

        AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS doDetailsObj = new AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS();
        doDetailsObj.I_ACCOUNT = '00077123135';
        doDetailsObj.I_USER = 'ABZZ123';
        doDetailsList.add(doDetailsObj);

        requestBean.BAPI_SF_DO_DETAILS = doDetailsList;
        return requestBean;
    }
}