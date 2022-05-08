public class ROTAddTransactionTypes_Req_IB_v1 extends Base_IB{
    public AddTransactionTypes AddTransactionTypes;
    public class AddTransactionTypes{
        public String user;
        public accounts accounts;
    }
    public class AddTransactionTypeModel{
        public Boolean IsEffectiveEndDateInfinity;
        public String GroupRestrictionClusterID;
        public String GroupRestrictionObjectID;
        public String EffectiveStartDate;
        public String Code;
        public String EffectiveEndDate;
        public String Description;
    }
    public class accounts{
        public list<AddTransactionTypeModel> AddTransactionTypeModel;
    }
    
    public static ROTAddTransactionTypes_Req_IB_v1 createDummyRequest(){
        ROTAddTransactionTypes_Req_IB_v1 requestBean = new ROTAddTransactionTypes_Req_IB_v1();
        requestBean.AddTransactionTypes = new ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypes();
        requestBean.AddTransactionTypes.accounts = new ROTAddTransactionTypes_Req_IB_v1.accounts();
        requestBean.AddTransactionTypes.accounts.AddTransactionTypeModel = new List<ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel>();
        ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel request= new ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel();
        request.Code = 'FN71 CWT';
        request.Description = 'JB Pillar';
        request.EffectiveEndDate = '2021-02-06T00:00:00';
        request.EffectiveStartDate = '2021-01-22T00:00:00';
        request.GroupRestrictionClusterID = 'ABS';
        request.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        request.IsEffectiveEndDateInfinity = true;
        
        ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel request1= new ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel();
        request1.Code = 'FN71 FIA';
        request1.Description = '4047738913';
        request1.EffectiveEndDate = '2021-02-24T00:00:00';
        request1.EffectiveStartDate = '2021-02-10T00:00:00';
        request1.GroupRestrictionClusterID = 'ABS';
        request1.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        request1.IsEffectiveEndDateInfinity = true;
        requestBean.AddTransactionTypes.accounts.AddTransactionTypeModel.add(request);
        requestBean.AddTransactionTypes.accounts.AddTransactionTypeModel.add(request1);
        requestBean.AddTransactionTypes.user = 'SALESFORCE';
        return requestBean;
    }
}