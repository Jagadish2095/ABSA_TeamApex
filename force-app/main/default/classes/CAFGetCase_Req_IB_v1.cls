/*
 * Request  Bean Class for bcmsgetcase
 * @author Haritha Police
 * @created 20-01-2021
 */
public class CAFGetCase_Req_IB_v1 extends Base_IB {
    public class GetCase {
        public String id;
        public String retrievedBy;
    }

    public GetCase GetCase;

    public static CAFGetCase_Req_IB_v1 createDummyRequest() {
        CAFGetCase_Req_IB_v1 requestBean = new CAFGetCase_Req_IB_v1();
        requestBean.GetCase = new CAFGetCase_Req_IB_v1.GetCase();
        requestBean.GetCase.Id = '0d7b9d05-a783-4c2d-b7fc-36f2396dd040';
        return requestBean;
    }
}