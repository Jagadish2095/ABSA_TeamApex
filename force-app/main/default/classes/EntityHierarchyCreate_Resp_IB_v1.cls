/**
* @description       : EntityHierarchyCreate_Resp_IB_v1
* @author            : Himanshu.Nimje@absa.africa
* @last modified on  : 12-03-2021
* @last modified by  : Tawanda M.
* Modifications Log
* Ver   Date         Author                       Modification
* 1.0   2021-10-25   Himanshu.Nimje@absa.africa   Initial Version
**/
public class EntityHierarchyCreate_Resp_IB_v1 extends Base_IB {
    
    public List<PayLoad> payLoad; 
    public Status status_z; 
    
    public class PayLoad {
        public List<ValidationErrors> validationErrors_P;
        public List<EntityHierarchy> EntityHierarchy; 
    }

    public class EntityHierarchy {
        public From_Z From_Z; // in json: From
        public From_Z To; 
        public String RelationshipType; 
        public String RelationshipRole; 
        public String HierarchyType; 
        public String HierarchyControl; 
        public Double OwnershipPct; 
        public String t_EH; 
        public String OperationType; 
        public Double CreditAggregationPct; 
        public Integer LinkId; 
        public Boolean IsValid_EH; 
        public Boolean IsDeleted_EH; 
        public Integer Access_EH; 
        public Integer BaseVersionId_EH; 
        public Integer VersionId_EH;
    }

    public class From_Z {
        public Integer EntityId; 
    }

    public class ValidationErrors {
        public String Error_P;
        public String ModelId_P;
        public Integer EntityId;
    }
    
    public class Status {
        public List<Error> error; 
    }

    public class Error {
        public String ResourceId; 
        public Boolean ShowMessage; 
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        //For Validation Entries
        fieldNameSubstitutionMap.put('"_validationErrors":', '"validationErrors_P":');
        fieldNameSubstitutionMap.put('"Error_":', '"Error_P":');
        fieldNameSubstitutionMap.put('"ModelId_":', '"ModelId_P":');
        //Status
        fieldNameSubstitutionMap.put('status', 'status_z');
        //For Payload Entries
        fieldNameSubstitutionMap.put('"t_":', '"t_P":');
        fieldNameSubstitutionMap.put('"IsValid_":', '"IsValid_P":');
        fieldNameSubstitutionMap.put('"IsDeleted_":', '"IsDeleted_P":');
        fieldNameSubstitutionMap.put('"Access_":', '"Access_P":');
        fieldNameSubstitutionMap.put('"BaseVersionId_":', '"BaseVersionId_P":');
        fieldNameSubstitutionMap.put('"VersionId_":', '"VersionId_P":');
        fieldNameSubstitutionMap.put('"Inapplicable_":', '"Inapplicable_P":');
        fieldNameSubstitutionMap.put('"Associations_":', '"Associations_P":');
        fieldNameSubstitutionMap.put('"UpdatedBy_":', '"UpdatedBy_P":');
        //for BankFocusAttribute
        fieldNameSubstitutionMap.put('"t_":', '"t_BFA":');
        fieldNameSubstitutionMap.put('"IsValid_":', '"IsValid_BFA":');
        fieldNameSubstitutionMap.put('"IsDeleted_":', '"IsDeleted_BFA":');
        fieldNameSubstitutionMap.put('"BaseVersionId_":', '"BaseVersionId_BFA":');
        fieldNameSubstitutionMap.put('"VersionId_":', '"VersionId_BFA":');
        fieldNameSubstitutionMap.put('"Inapplicable_":', '"Inapplicable_BFA":');
        fieldNameSubstitutionMap.put('"Associations_":', '"Associations_BFA":');
        //for EntityHierarchy
        fieldNameSubstitutionMap.put('"t_":', '"t_EH":');
        fieldNameSubstitutionMap.put('"IsValid_":', '"IsValid_EH":');
        fieldNameSubstitutionMap.put('"IsDeleted_":', '"IsDeleted_EH":');
        fieldNameSubstitutionMap.put('"Access_":', '"Access_EH":');
        fieldNameSubstitutionMap.put('"BaseVersionId_":', '"BaseVersionId_EH":');
        fieldNameSubstitutionMap.put('"VersionId_":', '"VersionId_EH":');
        fieldNameSubstitutionMap.put('"Inapplicable_":', '"Inapplicable_EH":'); 
        //from_Y
        fieldNameSubstitutionMap.put('"Access_":', '"Access_Y":'); 
        //MarqAttribute
        fieldNameSubstitutionMap.put('"t_":', '"t_M":');
        fieldNameSubstitutionMap.put('"IsValid_":', '"IsValid_M":');
        fieldNameSubstitutionMap.put('"IsDeleted_":', '"IsDeleted_M":');
        fieldNameSubstitutionMap.put('"BaseVersionId_":', '"BaseVersionId_M":');
        fieldNameSubstitutionMap.put('"VersionId_":', '"VersionId_M":');
        fieldNameSubstitutionMap.put('"Inapplicable_":', '"Inapplicable_M":');
        fieldNameSubstitutionMap.put('"Associations_":', '"Associations_M":'); 
        //IndustrySelection
        fieldNameSubstitutionMap.put('"t_":', '"t_IS":');
        fieldNameSubstitutionMap.put('"IsValid_":', '"IsValid_IS":');
        fieldNameSubstitutionMap.put('"IsDeleted_":', '"IsDeleted_IS":');
        fieldNameSubstitutionMap.put('"Access_":', '"Access_IS":');
        fieldNameSubstitutionMap.put('"BaseVersionId_":', '"BaseVersionId_IS":');
        fieldNameSubstitutionMap.put('"VersionId_":', '"VersionId_IS":');
        fieldNameSubstitutionMap.put('"Inapplicable_":', '"Inapplicable_IS":'); 
        //OsirisAttribute
        fieldNameSubstitutionMap.put('"t_":', '"t_z":');   
        fieldNameSubstitutionMap.put('"IsValid_":', '"IsValid_z":'); 
        fieldNameSubstitutionMap.put('"IsDeleted_":', '"IsDeleted_z":'); 
        fieldNameSubstitutionMap.put('"BaseVersionId_":', '"BaseVersionId_z":'); 
        fieldNameSubstitutionMap.put('"VersionId_":', '"VersionId_z":'); 
        fieldNameSubstitutionMap.put('"Inapplicable_":', '"Inapplicable_z":'); 
        fieldNameSubstitutionMap.put('"Associations_":', '"Associations_z":'); 
        
    }
    
}