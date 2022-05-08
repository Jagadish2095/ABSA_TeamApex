/*
 * Request  Bean Class for bcmsgetdocumentsforcase
 * @author Haritha Police
 * @created 20-01-2021
 */
public class CAFGetDocumentsforCase_Req_IB_v1 extends Base_IB {
    public GetDocumentsForCase GetDocumentsForCase;

    public class GetDocumentsForCase {
        public String id;
        public String retrievedBy;
        public String showHidden;
    }

    public static CAFGetDocumentsforCase_Req_IB_v1 createDummyRequest() {
        CAFGetDocumentsforCase_Req_IB_v1 bean = new CAFGetDocumentsforCase_Req_IB_v1();
        bean.GetDocumentsForCase = new CAFGetDocumentsforCase_Req_IB_v1.GetDocumentsForCase();
        bean.GetDocumentsForCase.Id = '0d7b9d05-a783-4c2d-b7fc-36f2396dd040';
        bean.GetDocumentsForCase.retrievedBy = '';
        bean.GetDocumentsForCase.showHidden = '';
        return bean;
    }
}