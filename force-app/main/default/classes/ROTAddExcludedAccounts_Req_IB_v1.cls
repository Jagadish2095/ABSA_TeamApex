public class ROTAddExcludedAccounts_Req_IB_v1 extends Base_IB{
    
    public AddExcludedAccounts AddExcludedAccounts;
    
    public class AddExcludedAccounts{
        public String user;
        public excludedAccounts excludedAccounts;
    }
    
    public class excludedAccounts{
        public list<Cls_AddExcludedAccountModel> AddExcludedAccountModel;
    }
    
    
    public class Cls_AddExcludedAccountModel{
        public String IsEffectiveEndDateInfinity;
        public String GroupRestrictionClusterID;
        public String EffectiveStartDate;
        public String GroupRestrictionObjectID;
        public String EffectiveEndDate;
        public String AccountNumber;
        public String Description;
    }
    
    
    public static ROTAddExcludedAccounts_Req_IB_v1 createDummyRequest(){
        
        ROTAddExcludedAccounts_Req_IB_v1 requestBean = new ROTAddExcludedAccounts_Req_IB_v1();
        requestBean.AddExcludedAccounts = new ROTAddExcludedAccounts_Req_IB_v1.AddExcludedAccounts();
        requestBean.AddExcludedAccounts.excludedAccounts = new ROTAddExcludedAccounts_Req_IB_v1.ExcludedAccounts();        
        requestBean.AddExcludedAccounts.excludedAccounts.AddExcludedAccountModel  = new List<ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel>();        
        List<ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel> excludedAccountModelList = new List<ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel>();
        
        
        requestBean.AddExcludedAccounts.user = 'SALESFORCE';
        ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel excludedAccountModel= new ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel();
        excludedAccountModel.Description ='JB Pillar';
        excludedAccountModel.IsEffectiveEndDateInfinity = 'true';
        excludedAccountModel.GroupRestrictionClusterID = 'ABS';
        excludedAccountModel.EffectiveStartDate = '2021-01-20T00:00:00';
        excludedAccountModel.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        excludedAccountModel.EffectiveEndDate = '2021-02-06T00:00:00';
        excludedAccountModel.AccountNumber = '4048430986';
        
        excludedAccountModelList.add(excludedAccountModel);        
        requestBean.AddExcludedAccounts.excludedAccounts.AddExcludedAccountModel  = excludedAccountModelList;

        return requestBean;
    }
}