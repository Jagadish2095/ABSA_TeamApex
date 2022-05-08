/**
 * @description Request object for ASPDeviceKofaxDocumentScanningRequest
 * @author  Paul du Randt
 * @created 2021-03-30
 */
public class ASPDeviceKofaxDocumentScanningRequest {
    public string Comments;
    public string CIFNumber;
    public string CCApplicationNumber;
    public string UserEmail;
    public string CustomerID;
    /**
     * @description Get Dummy Request function
     * @return ASPDeviceKofaxDocumentScanningRequest
     */
    public ASPDeviceKofaxDocumentScanningRequest getDummyReq(){
        ASPDeviceKofaxDocumentScanningRequest req = new ASPDeviceKofaxDocumentScanningRequest();
        req.Comments = '';
        req.CIFNumber = '';
        req.CCApplicationNumber = '';
        req.UserEmail = '';
        req.CustomerID = '';
        return req;
    }
}