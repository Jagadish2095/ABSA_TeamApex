({
    doInit: function(component, event, helper) {
        //alert('init: Start');
        var completeTwoResult = JSON.parse(component.get('v.CompleteTwoResult'));
        //alert('completeTwoResult');
        var quoteNumber = completeTwoResult.applyResponse.z_return.application.quote.z_number;
        //alert('quoteNumber: ' + quoteNumber);
        component.set('v.QuoteNumber', quoteNumber);
    },

    HandleResponse: function(component, event, helper) {
        if(component.get('v.QuoteStatus') != 'PENDING') {
            var completeTwoResult = JSON.parse(component.get('v.CompleteTwoResult'));
            var cftsAction = component.get('c.applyQuoteAccept');
            var applicationNumber = completeTwoResult.applyResponse.z_return.application.applicationNumber;
            var lockVersionId = completeTwoResult.applyResponse.z_return.application.lockVersionId;
            // console.log(component.get('v.applicationRecordId'));
            // console.log(applicationNumber);
            // console.log(lockVersionId);
            var QuoteStatus = component.get('v.QuoteStatus').toUpperCase();
            if (QuoteStatus == 'ACCEPT') {
                component.set('v.quoteAccepted', true);
            }
            // console.log(QuoteStatus);
            // console.log(component.get('v.QuoteNumber'));

            cftsAction.setParams({
                'applicationId' : component.get('v.applicationRecordId'),
                'applicationNumber' : applicationNumber,
                'lockVersionId' : lockVersionId,
                'decision' : QuoteStatus,
                'quoteNumber' : component.get('v.QuoteNumber')
            });
            cftsAction.setCallback(this, function(response) {
                var Response = response.getReturnValue() ;
                var navigate = component.get('v.navigateFlow');
                navigate('NEXT');
            });
            $A.enqueueAction(cftsAction);
        }
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');

        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
            case 'BACK':
                break;
            case 'PAUSE':
                navigate(actionClicked);
                break;
        }
    }
})