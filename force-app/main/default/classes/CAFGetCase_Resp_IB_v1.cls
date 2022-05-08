/*
 * Response  Bean Class for bcmsgetcase
 * @author Haritha Police
 * @created 20-01-2021
 */
public class CAFGetCase_Resp_IB_v1 extends Base_IB {
    public class TheCase {
        public String Id;
        public string ParentId;
        public String ReferenceNumber;
        public String DefinitionId;
        public String DefinitionVersion;
        public string Password;
        public String Data;
        public String Status;
        public String Created;
        public String Updated;
        public string DisplayName;
        public string FreeTextTag;
    }

    public GetCaseResponse GetCaseResponse;

    public class GetCaseResponse {
        public TheCase theCase;
    }
}