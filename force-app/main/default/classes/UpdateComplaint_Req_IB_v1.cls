global class UpdateComplaint_Req_IB_v1 extends Base_IB {
    
    public String caseNumber;
    public String tomDecision;
    public String tomReason;
    
    
    public override void setRequiredFields(){
        
        requiredFieldsSet = new Set<String>();
        
        requiredFieldsSet.add('caseNumber');
        requiredFieldsSet.add('tomDecision');
        requiredFieldsSet.add('caseNumber');
        
    }
    
    public void createDummyRequest(){
        
        this.tomDecision = 'Awaiting Feedback';
        this.tomReason = 'Awaiting Feedback';
        
        
    }
}