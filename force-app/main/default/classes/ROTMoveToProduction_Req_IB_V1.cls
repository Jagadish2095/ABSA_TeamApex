public class ROTMoveToProduction_Req_IB_V1 extends Base_IB{

    public MoveToProduction MoveToProduction;
	public class stagingSchemes{
		public list<SchemeMoveModel> SchemeMoveModel;
	}
	public class SchemeMoveModel{
		public String GroupRestrictionObjectID;
	}
	public class MoveToProduction{
		public stagingSchemes stagingSchemes;
		public String user;
	}
    
    public static ROTMoveToProduction_Req_IB_V1 createDummyRequest(){
        ROTMoveToProduction_Req_IB_V1 requestBean = new ROTMoveToProduction_Req_IB_V1();
        requestBean.MoveToProduction = new ROTMoveToProduction_Req_IB_V1.MoveToProduction();
        requestBean.MoveToProduction.stagingSchemes = new ROTMoveToProduction_Req_IB_V1.stagingSchemes();
        requestBean.MoveToProduction.stagingSchemes.SchemeMoveModel = new List<ROTMoveToProduction_Req_IB_V1.SchemeMoveModel>();
		ROTMoveToProduction_Req_IB_V1.SchemeMoveModel request = new ROTMoveToProduction_Req_IB_V1.SchemeMoveModel();
        request.GroupRestrictionObjectID = 'CQGR0002-CIF';
        ROTMoveToProduction_Req_IB_V1.SchemeMoveModel request1 = new ROTMoveToProduction_Req_IB_V1.SchemeMoveModel();
        request1.GroupRestrictionObjectID = 'CQGR0002-CIF';
        requestBean.MoveToProduction.stagingSchemes.SchemeMoveModel.add(request);
        requestBean.MoveToProduction.stagingSchemes.SchemeMoveModel.add(request1);
        requestBean.MoveToProduction.user ='ESP';
        return requestBean;
    }
}