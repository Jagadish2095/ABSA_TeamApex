public class ECM_AddResult_IB_V1 extends Base_IB {
    
    
    public String Pid { get; set; }
    public AddResult AddResult { get; set; }
    
    public class AddResult {
        public String Status { get; set; }
    	public String Details { get; set; }
    }
    
    public static ECM_AddResult_IB_V1 getExample() {
        ECM_AddResult_IB_V1 example = new ECM_AddResult_IB_V1();
       	ECM_AddResult_IB_V1.AddResult addResult = new ECM_AddResult_IB_V1.AddResult();
        addResult.Status = 'Ok';
        addResult.Details = 'Details';
        example.AddResult = addResult;
        example.Pid = '12456';
        return example;
    }

}