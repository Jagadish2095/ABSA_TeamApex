({
    init : function(component, event, helper) {
        //helper.fetchTranslationValues(component, 'v.existingPolicyCoverOptions', 'ABSA Life','Cover Options','Outbound');        
    },
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                if(helper.ValidateFields(component)){
                    var existingPolicy = 
                        {
                            Terminated : component.get('v.productTerminated'),
                            PolicyCover : component.get('v.existingCoverOption'),
                            Duration : component.get('v.duration'),
                            PreviousInsurer: component.get('v.previouseInsurer')
                        };
                    
                    component.set('v.existingPolicyQuestions', existingPolicy);
                    
                    navigate(actionClicked);
                }
                break;
            case 'BACK':
                navigate(actionClicked);
                break;
            case 'PAUSE':
                navigate(actionClicked);
                break;
        }
    },
})