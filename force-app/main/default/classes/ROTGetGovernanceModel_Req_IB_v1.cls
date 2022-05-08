public class ROTGetGovernanceModel_Req_IB_v1 extends Base_IB {

    public GetGovernanceModel GetGovernanceModel;

    public class GetGovernanceModel {
        public String date1;
    }
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"date":', '"date1":');
    }
    
    public static ROTGetGovernanceModel_Req_IB_v1 createDummyRequest(){
        ROTGetGovernanceModel_Req_IB_v1 requestBean = new ROTGetGovernanceModel_Req_IB_v1();
        requestBean.GetGovernanceModel = new ROTGetGovernanceModel_Req_IB_v1.GetGovernanceModel();
        requestBean.GetGovernanceModel.date1 = '2020-12-01T00:00:00';
        return requestBean;
    }
    
}