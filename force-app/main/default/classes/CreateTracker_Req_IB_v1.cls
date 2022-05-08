public class CreateTracker_Req_IB_v1 extends Base_IB 
{
	public String channel;
	public String application;
	public String trace;
	public String willNo;
	public String tstatus;
	public String dateCreated;
	public String timeCreated;
	public String userId;
	public String sstatus;
	public String statCd;
	public String filLoc;
	public String prevId;
	public String action; 
	public String comments;
	public String branchCd;
    
    public CreateTracker_Req_IB_v1 createDummyRequest() {           
        CreateTracker_Req_IB_v1 createTracker = new CreateTracker_Req_IB_v1();
        createTracker.channel = 'WILLS';
        createTracker.application = 'WILLS';
        createTracker.trace = 'Y';
        createTracker.willNo = '41000014420';
        createTracker.tstatus = 'D';
        createTracker.dateCreated = '20190128';
        createTracker.timeCreated = '1524';
        createTracker.userId = 'usr112';
        createTracker.sstatus = 'ARKCD';
        createTracker.statCd = 'ARKCDxiqbsMyglenFtph';
        createTracker.filLoc = 'location';
        createTracker.prevId = 'usr333';
        createTracker.action = 'FILED';
        createTracker.comments = 'testing';
        createTracker.branchCd = '3232';
        
        
        System.debug('CreateTracker Req: ' + createTracker);
        return createTracker;
    }
    
    public override void setFieldNameSubstitutions(){
        
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('date', 'dateCreated');
        fieldNameSubstitutionMap.put('time', 'timeCreated');
        
    }
}