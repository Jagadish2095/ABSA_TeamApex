/**
 * @description       : EntityHierarchyCreate_Req_IB_v1
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Tawanda M.
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-10-25   Himanshu.Nimje@absa.africa   Initial Version
 **/

public class EntityHierarchyCreate_Req_IB_v1 extends Base_IB  {
    
    /**
	 * @description Structure Element
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
    public List<EntityHierarchy> EntityHierarchy ; 
    
    /**
	 * @description Structure Element
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
    public class EntityHierarchy {
        public String OperationType ; 
        public From_Z From_Z ; 
        public From_Z To ; 
        public String RelationshipType ; 
        public String RelationshipRole ; 
        public String HierarchyType ; 
        public String HierarchyControl ; 
        public String OwnershipPct ; 
        public String CreditAggregationPct ; 
        public String t_z ; 
        
    }
     
    /**
	 * @description Structure Element
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
    public class From_Z {
        public Integer EntityId ; 
    }
    
    /**
	 * @description FieldSubstitution method from Base IB
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"t_":', '"t_z":');
        fieldNameSubstitutionMap.put('"From":', '"From_Z":');        
	}
    
    
    /**
	 * @description Dummy Request
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 * @return GBgetCmsFullCrGroups_Req_IB_v1
	 **/
	public static EntityHierarchyCreate_Req_IB_v1 createDummyRequest() {
		EntityHierarchyCreate_Req_IB_v1 requestBean = new EntityHierarchyCreate_Req_IB_v1();
		requestBean.EntityHierarchy = new List<EntityHierarchyCreate_Req_IB_v1.EntityHierarchy>();
        EntityHierarchyCreate_Req_IB_v1.EntityHierarchy  EntityHierarchy01 = new EntityHierarchyCreate_Req_IB_v1.EntityHierarchy();
        EntityHierarchy01.OperationType='Create';
        EntityHierarchy01.RelationshipType='LegalBorrowing';
        EntityHierarchy01.RelationshipRole='LegalSubsidiary';
        EntityHierarchy01.HierarchyType='LEGAL';
        EntityHierarchy01.HierarchyControl='YES';
        EntityHierarchy01.OwnershipPct= '0.33';
        EntityHierarchy01.CreditAggregationPct= '1.0';
        EntityHierarchy01.t_z ='EntityHierarchyLegal';
        EntityHierarchy01.From_Z = new EntityHierarchyCreate_Req_IB_v1.From_Z();
        EntityHierarchy01.From_Z.EntityId =13;
        EntityHierarchy01.To = new EntityHierarchyCreate_Req_IB_v1.From_Z();
        EntityHierarchy01.To.EntityId =14;
        requestBean.EntityHierarchy.add(EntityHierarchy01);
		
		return requestBean;
	}
    
}