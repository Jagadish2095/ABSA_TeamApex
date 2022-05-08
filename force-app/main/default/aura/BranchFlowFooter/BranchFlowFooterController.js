({
    init : function(component, event, helper) {
        var availableActions = component.get('v.availableActions');
        for (var i = 0; i < availableActions.length; i++) {
              if ((availableActions[i] == 'PAUSE') && (component.get('v.showPause'))) {
                  component.set('v.canPause', true);
              } else if ((availableActions[i] == 'BACK') && (component.get('v.showBack'))) {
                 component.set('v.canBack', true);
              } else if ((availableActions[i] == 'NEXT') && (component.get('v.showNext'))) {
                component.set('v.canNext', true);
              } else if ((availableActions[i] == 'FINISH') && (component.get('v.showFinish'))) {
                component.set('v.canFinish', true);
             }
          }
    },
    
    onButtonPressed: function(component, event, helper) {
        var actionClicked = event.getSource().getLocalId();
        var navigate = component.getEvent('navigateFlowEvent');
        navigate.setParam('action', actionClicked);
        navigate.fire();
    }
})