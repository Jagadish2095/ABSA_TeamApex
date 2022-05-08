({
    init: function(component, event, helper) 
    {
        var mediaTheme = component.get( 'v.mediaTheme' );
        var mediaBodyClass = component.get( 'v.mediaBodyClass' );
        var divClass = ('slds-p-around_x-small slds-scoped-notification slds-media slds-media_center ' + mediaTheme);
        var divMediaBodyClass = ('slds-media__body ' + mediaBodyClass);
        component.set('v.divClass', divClass);
        component.set('v.divMediaBodyClass', divMediaBodyClass);
    }
})