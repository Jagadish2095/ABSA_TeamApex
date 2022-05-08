/*
 * Integration response Bean  Class for bcmscreatecase
 * @author Sandile Mathe
 * @created 12-01-2021
 */
public class CAFCreateCase_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public CreateCaseResponse CreateCaseResponse;

    public class CreateCaseResponse {
        @AuraEnabled public CreatedCase createdCase;
    }

    public class CreatedCase {
        @AuraEnabled public String Id;
        public String ParentId;
        public String ReferenceNumber;
        public String DefinitionId;
        public String DefinitionVersion;
        public String Password;
        public String Data;
        public String Status;
        public String Created;
        public String Updated;
        public String DisplayName;
        public String FreeTextTag;
    }
}