/*
 * Response  Bean Class for bcmsgetdocumentsforcase
 * @author Haritha Police
 * @created 20-01-2021
 */
public class CAFGetDocumentsforCase_Resp_IB_v1 extends Base_IB {
    public GetDocumentsForCaseResponse GetDocumentsForCaseResponse;

    public class GetDocumentsForCaseResponse {
        public List<Documents> documents;
    }

    public class Documents {
        public String Id;
        public String DefinitionId;
        public String CaseId;
        public String ContentType;
        public String Name;
        public String Description;
        public String Data;
        public String ArchiveType;
        public Object ArchiveId;
        public String Status;
        public String Created;
        public String Updated;
        public String DocumentReasonId;
    }
}