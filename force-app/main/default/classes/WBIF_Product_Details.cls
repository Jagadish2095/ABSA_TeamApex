/**
 * @description WBIF_Product_Details
 **/
public class WBIF_Product_Details{
    @AuraEnabled
    public string ProductName;
    @AuraEnabled
    public string ProductIdentifier;
    @AuraEnabled
    public List<WbifMemberType> MemberTypes;
    @AuraEnabled
    public List<WBIF_Product_Details.ContractOption> ContractOptions;

    /**
     * @description WbifMemberType
     **/
    public class WbifMemberType{
        @AuraEnabled
        public string MemberTypeValue;
        @AuraEnabled
        public string MemberTypeName;
        @AuraEnabled
        public string BenefitId;
        @AuraEnabled
        public List<WBIF_Product_Details.CoverOption> CoverOptions;
    }
    /**
     * @description CoverOption
     **/
    public class CoverOption{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
    }
    /**
     * @description ContractOption
     **/
    public class ContractOption{
        @AuraEnabled
        public string Key;
        @AuraEnabled
        public string value;
        @AuraEnabled
        public string Name;
    }
    /**
     * @description ExistingPolicy
     **/
    public class ExistingPolicy{
        @AuraEnabled
        public String Terminated;
        @AuraEnabled
        public String PolicyCover;
        @AuraEnabled
        public String Duration;
        @AuraEnabled
		public Boolean ReplacementPolicy;
        @AuraEnabled
		public String PreviousInsurer;
    }
}