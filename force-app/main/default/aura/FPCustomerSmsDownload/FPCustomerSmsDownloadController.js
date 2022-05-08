({
    handleEvent : function(component,event,helper){
        alert('handleEvent in child component');
            var Time =event.getParams('Time');
            var CommentText=event.getParams('CommentText');
            var UserName=event.getParams('UserName');
            var DateFrom=event.getParams('DateFrom');
            component.set('v.UserName',UserName);
            component.set('v.DateFrom',DateFrom);
            component.set('v.Time',Time);
            component.set('v.Commenttext',CommentText);
    },
    downloadDocument : function(component, event, helper){
        var CustomerSms = component.get('v.SmsData');
        var sendDataProc = component.get("v.sendData");
        
        
        var dataToSend = {
           Time : component.get('v.Time'),
           Commenttext:component.get('v.Commenttext')
        }; //this is data you want to send for PDF generation
      
        //invoke vf page js method
        sendDataProc(dataToSend, function(){
                    //handle callback
        });
       }     
})
