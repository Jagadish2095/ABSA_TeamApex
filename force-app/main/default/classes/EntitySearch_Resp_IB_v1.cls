/**
 * @description       :
 * @author            : ravi.bodepalli@absa.africa
 * @last modified on  : 2021-10-25
 * @last modified by  : ravi.bodepalli@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-10-25   ravi.bodepalli@absa.africa    Initial Version
 **/
public class EntitySearch_Resp_IB_v1  extends Base_IB{
	
	public payLoad[] payLoad;
	public status status_z;
	
	/** @description EntitySearch_Resp_IB_v1 wrapper class */
	public class payLoad {
		public Integer EntityId;	//38
		public String LongName;	//Test Power
		public String ShortName;	//SGPower6
		public String SystemId;	//0011q00000qPTaTST
		public String EntityType;	//001
		public String BusinessPortfolio;	//SGP
		public String CreditPortfolio;	//Commercial
		public String WFId;	//00000000-0000-0000-0000-000000000000
		public String TaskId;	//00000000-0000-0000-0000-000000000000
		public Integer VersionId;	//1
		public String CreatedBy;	//93a54b4e-533e-4832-a6e3-c2aefaf4ea97
		public String CreatedDat;	//2021-09-10T11:53:03.371781
		public String t;	//Entity
		public boolean IsVisible;
		public Integer Access;	//5
	}
	/** @description EntitySearch_Resp_IB_v1 wrapper class */
	public class status {
		public info[] info;
	}
	/** @description EntitySearch_Resp_IB_v1 wrapper class */
	public class info {
		public boolean IsOverMax;
		public Integer ResultCount;	//1
	}	
    
    public override void setFieldNameSubstitutions(){
        fieldNameSubstitutionMap = new Map<String, String>();        
        fieldNameSubstitutionMap.put('WFId_', 'WFId');
        fieldNameSubstitutionMap.put('TaskId_', 'TaskId');
        fieldNameSubstitutionMap.put('VersionId_', 'VersionId');
        fieldNameSubstitutionMap.put('CreatedBy_', 'CreatedBy');
        fieldNameSubstitutionMap.put('CreatedDate_', 'CreatedDate');
        fieldNameSubstitutionMap.put('t_', 't');
        fieldNameSubstitutionMap.put('IsVisible_', 'IsVisible');
        fieldNameSubstitutionMap.put('Access_', 'Access');
		fieldNameSubstitutionMap.put('status', 'status__z');
}
}