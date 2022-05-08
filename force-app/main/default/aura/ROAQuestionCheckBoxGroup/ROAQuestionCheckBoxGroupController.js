({
    handleChange : function(component, event, helper) {
        var answerValue = component.get("v.answerValue2");
        var sequenceNumber = component.get("v.sequenceNumber");
        var nextStage = component.get("v.nextStage");
        var possibleAnswers = component.get("v.possibleAnswers");
        var questionTracker = component.get("v.questionTracker");

        var questionId = component.get("v.questionId");
        var answerId = answerValue.toString();

        var compEvent = component.getEvent("roaQuestionaireSelectionEvent");
        compEvent.setParams({
            "questionId" : questionId,
            "answerId": answerId,
            "sequenceNumber": sequenceNumber,
            "nextStage" : nextStage,
            "possibleAnswers" : possibleAnswers,
            "questionTracker" : questionTracker
        });  
        compEvent.fire();
    }
});



/*({
	handleChange: function (component, event) {
		
	}
});*/