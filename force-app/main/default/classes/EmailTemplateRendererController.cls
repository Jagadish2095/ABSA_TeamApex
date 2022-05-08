/**
* Used to render case email templates as a PDF.
*
* @author  Peter Guest (CloudSmiths)
* @since   2020-06-18
*
**/
public class EmailTemplateRendererController {
    
    public String htmlBody { get; set; }

    public EmailTemplateRendererController() {

        //Page parameters.
        Id templateId = ApexPages.currentpage().getparameters().get('templateId');
        Id whatId = ApexPages.currentpage().getparameters().get('whatId');

        //Render and get html.
        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(templateId, null, whatId);
        htmlBody = message.getHtmlBody();
    }
}