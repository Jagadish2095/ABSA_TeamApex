/**
 * Integration utilities class for Consumer Bureau Enquiry
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date November 2020
 */
public class ConsumerBureauEnquiry_Req_IB_v1 extends Base_IB {
    public cls_Request Request;

    public class cls_Request {
        public cls_ApplicationDV ApplicationDV;
    }

    public class cls_ApplicationDV {
        public String APPPCCEID;
    }
}