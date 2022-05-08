/**
 * Created by MinalRama on 2021/02/10.
 */

({
    init : function (cmp) {
        var flow = cmp.find("flow");
        var recid = cmp.get("v.recordId");
        var productName = cmp.get("v.productName");
        console.log(recid + '??????????');
        console.log(productName + '??????????');
        var inputVariables = [
        {
            name : 'Product_Name',
            type : 'String',
            value : productName
        },
        {
            name : 'RecordId',
            type : 'String',
            value : recid
        },
        {
            name : 'clientFirstName',
            type : 'String',
            value : 'Flexi Funeral'
         },
         {
             name : 'clientLastName',
             type : 'String',
             value : 'Flexi Funeral'
         },
         {
           name : 'quoteId',
           type : 'String',
           value : ''
         },
        ];
        flow.startFlow("Cross_Sell_Quote_Flow", inputVariables);
    },
statusChange : function (cmp, event) {
        console.log( 'Eventstatus>>>>>>>>' +  event.getParam('status'));
        if (event.getParam('status') === "FINISHED_SCREEN") {
        cmp.set("v.showFinish", true);
        }
    }

    });