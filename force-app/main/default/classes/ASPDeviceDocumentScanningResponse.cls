/*
* Response object for ASPDeviceCustomerVerification
* @author  Paul du Randt
* @created 2020-02-08
*/

public class ASPDeviceDocumentScanningResponse {
    
    public List<Document> DocumentList;
    public class Document{
        public string DocumentCode;
        public string DocumentType;
        public string DocumentSubType;
        public string DocumentGUID;
        public string UploadMSG;
        public string ECMPID;
    }

    public ASPDeviceDocumentScanningResponse DummyResponse()
    {
        ASPDeviceDocumentScanningResponse ASPDevice = new ASPDeviceDocumentScanningResponse();
        ASPDevice.DocumentList = new List<Document>();
        ASPDeviceDocumentScanningResponse.Document Document = new Document();
        Document.DocumentCode = '01';
        Document.DocumentType = 'test';
        Document.DocumentSubType = 'test1';
        Document.DocumentGUID = '123456';
        Document.UploadMSG = 'fdvsdf';
        Document.ECMPID = 'test';
        ASPDevice.DocumentList.add(Document);
        return ASPDevice;
    }   

}