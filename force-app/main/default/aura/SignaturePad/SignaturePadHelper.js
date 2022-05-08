({
    doInit : function(component, event, helper) {
            var canvas, ctx, flag = false,
            prevX = 0,
            currX = 0,
            prevY = 0,
            currY = 0,
            dot_flag = false;
       
        var x = "black",
            y = 2,
            w,h;
        canvas=component.find('can').getElement();
        var ratio = Math.max(window.devicePixelRatio || 1, 1);
        w = canvas.width*ratio;
        h = canvas.height*ratio;
        ctx = canvas.getContext("2d");
        console.log('ctx:='+ctx);
       
        canvas.addEventListener("mousemove", function (e) {
            findxy('move', e)
        }, false);
        canvas.addEventListener("mousedown", function (e) {
            findxy('down', e)
        }, false);
        canvas.addEventListener("mouseup", function (e) {
            findxy('up', e)
        }, false);
        canvas.addEventListener("mouseout", function (e) {
            findxy('out', e)
        }, false);
        // Set up touch events for mobile, etc
        canvas.addEventListener("touchstart", function (e) {
            var touch = e.touches[0];
            console.log('touch start:='+touch);
            var mouseEvent = new MouseEvent("mousedown", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas.dispatchEvent(mouseEvent);
             e.preventDefault();
        }, false);
        canvas.addEventListener("touchend", function (e) {
            var mouseEvent = new MouseEvent("mouseup", {});
            canvas.dispatchEvent(mouseEvent);
        }, false);
        canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas.dispatchEvent(mouseEvent);
             e.preventDefault();
           
        }, false);
       
        // Get the position of a touch relative to the canvas
        function getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                x: touchEvent.touches[0].clientX - rect.left,
                y: touchEvent.touches[0].clientY - rect.top
            };
        }
       
        function findxy(res, e){
            const rect = canvas.getBoundingClientRect();
            if (res == 'down') {
                prevX = currX;
                prevY = currY;
                currX = e.clientX - rect.left ;
                currY = e.clientY -  rect.top;
               
                flag = true;
                dot_flag = true;
                if (dot_flag) {
                    ctx.beginPath();
                    ctx.fillStyle = x;
                    ctx.fillRect(currX, currY, 2, 2);
                    ctx.closePath();
                    dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                flag = false;
            }
            if (res == 'move') {
                if (flag) {
                    prevX = currX;
                    prevY = currY;
                    currX = e.clientX -  rect.left;
                    currY = e.clientY - rect.top;
                    draw(component,ctx);
                }
            }
        }
        function draw() {
            ctx.beginPath();
            ctx.moveTo(prevX, prevY);
            ctx.lineTo(currX, currY);
            ctx.strokeStyle = x;
            ctx.lineWidth = y;
            ctx.stroke();
            ctx.closePath();
        }
       
     //Calling another method to load related contacts on init    
    this.loadRelatedContacts(component, event, helper);
    },
    eraseHelper: function(component, event, helper){
        var m = confirm("Want to clear");
        if (m) {
            var canvas=component.find('can').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
       }
    },
    saveHelper:function(component, event, helper){
        var pad=component.find('can').getElement();
        var dataUrl = pad.toDataURL();
        console.log('dataUrl:='+dataUrl);
        console.log('opp id for sign'+component.get("v.recordId"));
        var strDataURI=dataUrl.replace(/^data:image\/(png|jpg);base64,/, "");
        var action = component.get("c.saveSignature");
        var optionslist = component.get("v.options");
        console.log('first Values is'+optionslist[0]);
        var selectedContact ;
        console.log('selected value'+component.find("mySelect").get("v.value"));
        if(component.find("mySelect").get("v.value")){
        selectedContact =  component.find("mySelect").get("v.value");
        }
        else{
        selectedContact = optionslist[0];
        }
        var optionsMap  = component.get("v.optionsMap");
        console.log('map value'+optionsMap[component.find("mySelect").get("v.value")]);
        action.setParams({
            signatureBody : strDataURI,
            oppId         : component.get("v.recordId"),
            conId         : optionsMap[selectedContact],
            conName       : selectedContact                  
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==="SUCCESS"){
                //alert("Signature saved successfully");
              var signatureStatus = res.getReturnValue(); 
              var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "info",
                        "title": "",
                        "message": signatureStatus
                    });
                    toastEvent.fire();
                // clear the pad after submit
                var canvas=component.find('can').getElement();
                 var ctx = canvas.getContext("2d");
                  var w = canvas.width;
                 var h = canvas.height;
                  ctx.clearRect(0, 0, w, h);
                
                
                
                
            }
            else{
                
                 // Configure error toast
                    let toastParams = {
                        title: "Error",
                        message: "Unknown error Data is not sufficient", // Default error message
                        type: "error"
                    };
                    
                    // Fire error toast
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams(toastParams);
                    toastEvent.fire();
                
            }
        });       
        $A.enqueueAction(action);
    },
      //try to load the related account data
    loadRelatedContacts: function(component, event, helper){
        var OpportunityId = component.get("v.recordId");
        var action = component.get("c.loadrelatedData");
        action.setParams({
            oppId : OpportunityId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==="SUCCESS"){
                 var arrayOfMapKeys = [];
                 var accNames= res.getReturnValue();
                    
                    component.set('v.optionsMap',accNames);
                    for (var key in accNames ){
                    arrayOfMapKeys.push(key); 
                    console.log('keys of map'+arrayOfMapKeys);
                   }
                   component.set('v.options',arrayOfMapKeys);
            }
        });       
        $A.enqueueAction(action);
    },
      
})