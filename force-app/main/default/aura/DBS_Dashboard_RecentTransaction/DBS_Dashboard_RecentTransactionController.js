({
    doInit: function(component, event, helper) {
        
    },
    expandRowsHandler: function(component, event, helper) {
 
        if (event.currentTarget.dataset.relationship == "parent") {
            let clicked_row_id = event.currentTarget.dataset.id;

            var dataRows = component.get("v.transactionsList");

            var mapObj = {
                circle_icon_plus: "circle_icon_minus",
                circle_icon_minus: "circle_icon_plus"
            }
            let new_index = dataRows.findIndex(x => x.index === clicked_row_id);
            helper.collapsibleRowsHelper(component, clicked_row_id, mapObj[dataRows[new_index].icon_class]);
        }
    },
})