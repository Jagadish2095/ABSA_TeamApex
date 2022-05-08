public with sharing class BranchInterviewsController {
    @AuraEnabled
    public static FlowInterviewLog getInterviewDetails(String flowInterviewGuid) {
        FlowInterviewLog interviewLog = new FlowInterviewLog();
        try {
            interviewLog = [Select FlowVersionNumber, FlowDeveloperName, InterviewStatus, FlowNamespace, FlowLabel From FlowInterviewLog Where FlowInterviewGuid = :flowInterviewGuid With SECURITY_ENFORCED LIMIT 1];
        } catch (System.QueryException e) {
            System.debug(e.getMessage());
        }
        return interviewLog;
    }

    @AuraEnabled
    public static FlowInterview deleteInterview(Id interviewId) {
        FlowInterview interview = new FlowInterview();
        try {
            interview = [Select Id from FlowInterview Where Id = :interviewId With SECURITY_ENFORCED LIMIT 1];
            delete interview;
        } catch (System.QueryException e) {
            System.debug(e.getMessage());
        }
        return interview;
    }

    @AuraEnabled
    public static List<BranchInterviewsController.BranchPausedInterview> getPausedInterviews(Id recordId)
    {
        List<BranchInterviewsController.BranchPausedInterview> interviewList = new List<BranchInterviewsController.BranchPausedInterview>();
        BranchInterviewsController.BranchPausedInterview pausedInterview = new BranchInterviewsController.BranchPausedInterview();

        FlowRecordRelation[] recordInterviews = [Select ParentId, Parent.InterviewLabel, Parent.PauseLabel, Parent.CurrentElement, Parent.CreatedDate, Parent.Owner.Name, Parent.Guid From FlowRecordRelation Where RelatedRecordId = :recordId With SECURITY_ENFORCED];
        for(FlowRecordRelation flowRecord :recordInterviews)
        {
            pausedInterview = new BranchInterviewsController.BranchPausedInterview();
            pausedInterview = getFlowRecordRelationDetail(pausedInterview, flowRecord);
            pausedInterview = getFlowInterviewLogDetail(pausedInterview, BranchInterviewsController.getInterviewDetails(flowRecord.Parent.Guid));
            interviewList.add(pausedInterview);
        }
        return interviewList;
    }

    public static BranchInterviewsController.BranchPausedInterview getFlowRecordRelationDetail(BranchInterviewsController.BranchPausedInterview pausedInterview, FlowRecordRelation flowRecordRelation)
    {
        pausedInterview.interviewId = flowRecordRelation.ParentId;
        pausedInterview.interviewLabel = flowRecordRelation.Parent.InterviewLabel;
        pausedInterview.interviewGuid = flowRecordRelation.Parent.Guid;
        pausedInterview.pauseLabel = flowRecordRelation.Parent.PauseLabel;
        pausedInterview.pausedDate = flowRecordRelation.Parent.CreatedDate;
        pausedInterview.pausedBy = flowRecordRelation.Parent.Owner.Name;
        pausedInterview.currentElement = flowRecordRelation.Parent.CurrentElement;
        return pausedInterview;
    }

    public static BranchInterviewsController.BranchPausedInterview getFlowInterviewLogDetail(BranchInterviewsController.BranchPausedInterview pausedInterview, FlowInterviewLog flowInterviewLog)
    {
        pausedInterview.interviewStatus = flowInterviewLog.InterviewStatus;
        pausedInterview.flowVersionNumber = flowInterviewLog.FlowVersionNumber;
        pausedInterview.flowDeveloperName = flowInterviewLog.FlowDeveloperName;
        pausedInterview.flowNamespace = flowInterviewLog.FlowNamespace;
        pausedInterview.flowLabel = flowInterviewLog.FlowLabel;
        return pausedInterview;
    }

    public class BranchPausedInterview
    {
        @auraEnabled public Id interviewId;
		@auraEnabled public String interviewLabel;
        @auraEnabled public String interviewStatus;
        @auraEnabled public String interviewGuid;
        @auraEnabled public String pauseLabel;
        @auraEnabled public DateTime pausedDate;
        @auraEnabled public String pausedBy;
        @auraEnabled public String currentElement;
        @auraEnabled public Integer flowVersionNumber;
        @auraEnabled public String flowDeveloperName;
        @auraEnabled public String flowNamespace;
        @auraEnabled public String flowLabel;
    }
}