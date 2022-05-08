({
    showError : function(errorMessage) {
        if(errorMessage){            
            if(errorMessage.match(/(\b[A-Z][A-Z]+([_]*[A-Z]+)*)/g) != null){
            let errorKey = errorMessage.match(/(\b[A-Z][A-Z]+([_]*[A-Z]+)*)/g).pop();            
            errorMessage = errorMessage.split(errorKey+", ").pop().split(": [").shift();
            }
            
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                title: 'Error!',
                message: errorMessage,
                type: 'error'
            });
            toastEvent.fire();
        }
    }
})