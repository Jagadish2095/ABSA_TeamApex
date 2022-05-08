public class ROTExpireSchemeNode_Req_IB_V1 extends Base_IB{

    public ExpireSchemeNode ExpireSchemeNode;
	public class expiryModel{
		public String GroupRestrictionObjectID;
		public String GroupRestrictionClusterID;
		public String ObjectID;
		public String ExpiryDate;
		public String EntityType;
		public String EffectiveStartDate;
	}
	public class ExpireSchemeNode{
		public expiryModel expiryModel;
		public String user;
	}
    
    public static ROTExpireSchemeNode_Req_IB_V1 createDummyRequest(){
        ROTExpireSchemeNode_Req_IB_V1 request = new ROTExpireSchemeNode_Req_IB_V1();
        request.ExpireSchemeNode = new ROTExpireSchemeNode_Req_IB_V1.ExpireSchemeNode();
        request.ExpireSchemeNode.expiryModel = new ROTExpireSchemeNode_Req_IB_V1.expiryModel();
        request.ExpireSchemeNode.expiryModel.EffectiveStartDate = '2021-04-12T00:00:00';
        request.ExpireSchemeNode.expiryModel.EntityType = 'TransactionType';
        request.ExpireSchemeNode.expiryModel.ExpiryDate = '2021-05-26T00:00:00';
        request.ExpireSchemeNode.expiryModel.GroupRestrictionClusterID = 'ABS';
        request.ExpireSchemeNode.expiryModel.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        request.ExpireSchemeNode.expiryModel.ObjectID = 'FN71 FIA';
        request.ExpireSchemeNode.user =  '?';
        return request;
    }
}