/**
 * Created by MinalRama on 2021/02/11.
 */

({
    init : function (cmp) {
        var flow = cmp.find("flow");
        var recid = cmp.get("v.recordId");
        console.log(recid + '??????????');
        var inputVariables = [
        {
            name : 'recordId',
            type : 'String',
            value : recid
        }
        ];
        flow.startFlow("Flexi_Funeral_Quote_Flow", inputVariables);
    },
    statusChange : function (cmp, event) {
            console.log( 'Eventstatus Flexo>>>>>>>>' +  event.getParam('status'));
            if (event.getParam('status') === "FINISHED_SCREEN") {
            cmp.set("v.showFinish", true);
            }
        }
    });