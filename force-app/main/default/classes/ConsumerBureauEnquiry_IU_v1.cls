/**
 * Integration utilities class for Consumer Bureau Enquiry
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date November 2020
 */
public class ConsumerBureauEnquiry_IU_v1 {
    public static ConsumerBureauEnquiry_Req_IB_v1 mapRequestFields(String apppcceId){
        ConsumerBureauEnquiry_Req_IB_v1 requestBean = new ConsumerBureauEnquiry_Req_IB_v1();
        ConsumerBureauEnquiry_Req_IB_v1.cls_ApplicationDV applicationDV = new ConsumerBureauEnquiry_Req_IB_v1.cls_ApplicationDV();
        applicationDV.APPPCCEID = apppcceId;
        ConsumerBureauEnquiry_Req_IB_v1.cls_Request request = new ConsumerBureauEnquiry_Req_IB_v1.cls_Request();
        request.ApplicationDV = applicationDV;
        requestBean.Request = request;

        return requestBean;
    }
}