/*
 * Request Integration Bean for SAPGetList Service
 * @author Jason Quevauvilliers
 * @created 2020-11-04
 */
public class AvafVapsGetList_Req_IB_v1 extends Base_IB{

    public List<BAPI_SF_VAPS> BAPI_SF_VAPS_LIST;

    public class BAPI_SF_VAPS{
        public String I_Account;
        public String I_USER;
    }

    public static AvafVapsGetList_Req_IB_v1 createDummyRequest() {
        AvafVapsGetList_Req_IB_v1 requestBean = new AvafVapsGetList_Req_IB_v1();
        List<AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS> vapsList = new List<AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS>();

        AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS vaps = new AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS();
        vaps.I_Account = '00073556860';
        vaps.I_USER = 'ab0131R';
        vapsList.add(vaps);

        requestBean.BAPI_SF_VAPS_LIST = vapsList;

        return requestBean;
    }
}