({
    checkPaused : function(component, event, helper) {
        var action = component.get("c.getPausedInterviews");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var flowName = component.get('v.flowName');
            var hasPausedFlow = false;
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordRelations = response.getReturnValue();
                if (recordRelations.length > 0) {
                    var interviews = [];
                    for (var i = 0; i < recordRelations.length; i++) {
                        if (recordRelations[i].flowDeveloperName == flowName) {
                            hasPausedFlow = true;
                        }
                        interviews.push(
                            {
                                interviewId: recordRelations[i].interviewId,
                                interviewLabel: recordRelations[i].interviewLabel,
                                pauseLabel: recordRelations[i].pauseLabel,
                                currentElement: recordRelations[i].currentElement,
                                pausedDate: recordRelations[i].pausedDate,
                                pausedBy: recordRelations[i].pausedBy,
                                flowLabel: recordRelations[i].flowLabel,
                                flowVersionNumber: recordRelations[i].flowVersionNumber,
                                flowDeveloperName: recordRelations[i].flowDeveloperName
                            });
                    }
                    //hasPausedFlow = true;
                    if (hasPausedFlow) {
                        component.set('v.interviews', interviews);
                        component.set('v.pausedInterview', true);
                    } else {
                        component.set('v.flowId', '');
                        component.set('v.flowResume', false);
                        component.set('v.pausedInterview', false);
                        component.set('v.showFlow', true);
                    }
                } else {
                    component.set('v.flowId', '');
                    component.set('v.flowResume', false);
                    component.set('v.pausedInterview', false);
                    component.set('v.showFlow', true);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },

    handleResume: function (component, id) {
        component.set('v.flowId', id);
        component.set('v.flowResume', true);
        component.set('v.pausedInterview', false);
        component.set('v.showFlow', true);
    },

    handleRestart: function (component, id, flowName) {
        component.set('v.flowName', flowName);
        var action = component.get('c.deleteInterview');
        action.setParams({
            interviewId: id
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.flowId', '');
                component.set('v.flowResume', false);
                component.set('v.pausedInterview', false);
                component.set('v.showFlow', true);
            } else if (state === 'ERROR') {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})