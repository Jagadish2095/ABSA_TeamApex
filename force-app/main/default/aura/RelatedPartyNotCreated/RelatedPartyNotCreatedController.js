({
    handleNavigate: function (component, event, helper) {		
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
       
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':       
                    navigate("NEXT");
                    resolve("success");         

                break;
            case 'BACK':
                navigate(actionClicked);
                break;
            case 'PAUSE':
                navigate(actionClicked); 
                break;
            }
        }

})