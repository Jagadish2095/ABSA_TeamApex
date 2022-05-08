/*
 * Request Integration Bean for AvafGetPartner Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetPartner_Req_IB_v1 extends Base_IB{

    public BAPI_SF_PARTNER_GET BAPI_SF_PARTNER_GET;

    public class BAPI_SF_PARTNER_GET{
        public String I_ACCOUNT;
        public String I_USER;
    }

    public static AvafGetPartner_Req_IB_v1 createDummyRequest(){
        AvafGetPartner_Req_IB_v1 requestBean = new AvafGetPartner_Req_IB_v1();
        requestBean.BAPI_SF_PARTNER_GET = new AvafGetPartner_Req_IB_v1.BAPI_SF_PARTNER_GET();

        requestBean.BAPI_SF_PARTNER_GET.I_ACCOUNT = '00077123135';
        requestBean.BAPI_SF_PARTNER_GET.I_USER = 'ABZZ123';

        return requestBean;
    }
}