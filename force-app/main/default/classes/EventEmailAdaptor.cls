/**
* Generic class that is used by process builder to send emails and store them on the specified whatId
* @author  Kyle Alexander
* @created 2018-07-25
*/

global class EventEmailAdaptor {
    private static String timeZone;

    /**
     * Method invoked by a process which looks up the contact email and calls the email handler with the required parameters
     *
     * @param requests invokable variables provided by process builder
     */
    @InvocableMethod
    public static void sendEmail(List<SendEmailRequest> requests) {
        timeZone = UserInfo.getTimeZone().getID();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        for (SendEmailRequest emailRequest : requests) {
            contactIds.add(emailRequest.whoId);
            opportunityIds.add(emailRequest.whatId);
        }
        Map<Id, Contact> contacts = new Map<Id, Contact>(new ContactsSelector().selectByListContactIds(contactIds));
        Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>(new OpportunitiesSelector().selectByListOpportunityIds(opportunityIds));
        for (SendEmailRequest req : requests) {
            try {
                User user = [SELECT id, Name from User where id = :opportunities.get(req.whatId).OwnerId limit 1];
                sendCustomEmail(req.whatId, req.whoId, contacts.get(req.whoId).Email, contacts.get(req.whoId).Name, opportunities.get(req.whatId), user, req);
            } catch (Exception e) {
                System.debug(e.getLineNumber() + ' ' + e.getMessage());
            }
        }
    }

    global class SendEmailRequest {
        @InvocableVariable
        global String description;

        @InvocableVariable
        global Datetime endDate;

        @InvocableVariable
        global Datetime startDate;

        @InvocableVariable
        global String subject;

        @InvocableVariable
        global String whatId;

        @InvocableVariable
        global String whoId;

        @InvocableVariable
        global String location;
        
        @InvocableVariable
        global String emailType;
        
        @InvocableVariable
        global Datetime eventCreatedDate;
    }

    /**
     * Sets the custom email html body
     *
     * @param whatId
     * @param targetObjectId
     * @param emailAddress
     * @param name
     * @param opp
     * @param user
     * @param req
     */
    public static void sendCustomEmail(Id whatId, Id targetObjectId, String emailAddress, String name, Opportunity opp, User user, SendEmailRequest req){

        List<Document> lstDocumentHeader = [Select Id,Name,LastModifiedById from Document where Name = 'Email Header' limit 1];
        String strOrgIdHeader = UserInfo.getOrganizationId();
        String strDocUrlHeader = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentHeader[0].Id+'&oid=' + strOrgIdHeader;

        List<Document> lstDocumentBar = [Select Id,Name,LastModifiedById from Document where Name = 'Email Colour Bar' limit 1];
        String strOrgIdBar = UserInfo.getOrganizationId();
        String strDocUrlBar = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentBar[0].Id+'&oid=' + strOrgIdBar;

        List<Document> lstDocumentSaveDate = [Select Id,Name,LastModifiedById from Document where Name = 'Email Save Date' limit 1];
        String strOrgIdSaveDate = UserInfo.getOrganizationId();
        String strDocUrlSaveDate = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.ImageServer?id='+lstDocumentSaveDate[0].Id+'&oid=' + strOrgIdSaveDate;

        String htmlBody;
        if(req.emailType != null && req.emailType.equals('Delayed Email')){
            htmlBody = '<!DOCTYPE html PUBLIC \'-//W3C//DTD XHTML 1.0 Transitional//EN\' \'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\'>'+
            '<html xmlns=\'http://www.w3.org/1999/xhtml\'>'+
            ''+
            '<head>'+
            '    <meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\' />'+
            '    <title>Estate Provider Plan</title>'+
            '    <style type=\'text/css\'>'+
            '        body {'+
            '            background-color: #f2f2f2;'+
            '            margin-top: 0px;'+
            '            font-size: 11px;'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            color: #58595b;'+
            '            line-height: 16px;'+
            '        }'+
            '        '+
            '        .HeadingMain {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 28px;'+
            '            font-style: normal;'+
            '            color: #DC0032;'+
            '        }'+
            '        '+
            '        .HypelinkRed {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 11px;'+
            '            font-style: normal;'+
            '            font-weight: bold;'+
            '            color: #dc0032;'+
            '            text-decoration: underline;'+
            '        }'+
            '        '+
            '        .Bodytext {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 11px;'+
            '            color: #fa551e;'+
            '        }'+
            '        '+
            '        .Bodytext2 {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 11px;'+
            '            color: #870a3c;'+
            '        }'+
            '        '+
            '        .BodytextHead {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 12px;'+
            '            color: #58595B;'+
            '        }'+
            '        '+
            '        .REG {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 7pt;'+
            '            color: #58595B;'+
            '            line-height: 14pt;'+
            '        }'+
            '        '+
            '        .REGHyperLink {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 8pt;'+
            '            color: #dc0050;'+
            '            line-height: 14pt;'+
            '        }'+
            '    </style>'+
            '</head>'+
            ''+
            '<body>'+
            '    <table width=\'650\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\'>'+
            '        <tr>'+
            '            <td align=\'left\' valign=\'top\'>'+
            '                <table width=\'100%\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\' bgcolor=\'#ffffff\'>'+
            '                    <tr>'+
            '                        <td align=\'left\' valign=\'top\' bgcolor=\'#FFFFFF\' style=\'padding-top:0px; padding-left:0px; padding-bottom: 0px;\'><img src=' + strDocUrlHeader + ' width=\'650\' height=\'160\' alt=\'\' /></td>'+
            '                    </tr>'+
            '                </table>'+
            '            </td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td align=\'left\' valign=\'top\'>'+
            '                <table width=\'100%\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\' bgcolor=\'#ffffff\'>'+
            '                    <tr>'+
            '                        <td bgcolor=\'#FFFFFF\' style=\'padding-left:22px; padding-right: 22px;\'>'+
            '                            <p><span class=\'Bodytext\'><span lang=\'EN-GB\' xml:lang=\'EN-GB\'><br />'+
            '                          Dear ' + name +
            '                          <br />'+
            '                          </span></span>'+
            '                            </p>'+
            '                        </td>'+
            '                    </tr>'+
            '                    <tr>'+
            '                        <td bgcolor=\'#FFFFFF\' style=\'padding-left:22px; padding-right: 22px;\'>'+
            '                            <p>On ' + req.eventCreatedDate.format('yyyy-MM-dd') + ', you requested that ' + user.name  + ' from Absa Insurance and Financial Advisers contact you to further discuss the purpose and benefits of the Estate Provider Plan.</p>'+
            '                            <p>This is just a friendly reminder that the adviser will call you soon, as agreed in our previous communication to you. </p>'+
            '                            <p>Download calendar invite'+
            '                                <br />'+
            '							 	 <p><a href=\'http://addtocalendar.com/atc/outlook?f=m&e[0][date_start]='+ req.startDate.format('yyyy-MM-dd HH:mm:ss', timeZone) +'&e[0][date_end]=' + req.endDate.format('yyyy-MM-dd HH:mm:ss', timeZone) + '&e[0][timezone]=' + timeZone + '&e[0][title]=' + req.subject + '&e[0][description]=' + req.description + '&e[0][location]=' + req.location + '&e[0][organizer]=' + user.name + '&e[0][privacy]=public\'> <img src=' + strDocUrlSaveDate + ' width=\'133\' height=\'69\' alt=\'\' />' + '</a></p>'+
            '                                <br /> Executor fees and liquidity will definitely have an impact when you wind up your estate. If you prepare for this, it will benefit your family members and heirs.</p>'+
            '                            <p>If you need to reschedule, please reply to this email.</p>'+
            '                        </td>'+
            '                    </tr>'+
            '                    <tr>'+
            '                        <td bgcolor=\'#FFFFFF\' style=\'padding-left:22px; padding-right: 22px;\'>'+
            '                            <p><span class=\'Bodytext2\' lang=\'EN-GB\' xml:lang=\'EN-GB\'><strong><br />'+
            '                          Kind regards</strong></span></p>'+
            '                            <p><span class=\'Bodytext\' lang=\'EN-GB\' xml:lang=\'EN-GB\'><strong>'+
            '                          Absa Insurance and Financial Advisers <br />'+
            '                          </strong></span>Virtual Advice Department'+
            '                                <br /> virtualadviser@absa.co.za'+
            '                                <br /> 011 225 1797</p>'+
            '                            <p>Note: Office hours - 08:00 to 16:30'+
            '                                <br />'+
            '                            </p>'+
            '                        </td>'+
            '                    </tr>'+
            '                </table>'+
            '            </td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td bgcolor=\'#FFFFFF\' align=\'left\' valign=\'top\' style=\'padding-left:0px; padding-right: 0px; padding-bottom: 0px;\'>'+
            '                <p class=\'REG\'><img src=' + strDocUrlBar + ' width=\'650\' height=\'9\' alt=\'\' /></p>'+
            '            </td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td bgcolor=\'#FFFFFF\' align=\'left\' valign=\'top\' style=\'padding-left:22px; padding-right: 22px; padding-bottom: 13px;\'><span class=\'REG\'>Absa Insurance and Financial Advisers (Pty) Ltd (Registration no 1970/002732/07), a duly authorized financial services provider <br />under licence number: 4012</span></td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td align=\'left\' valign=\'top\'>'+
            '                <table width=\'100%\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\'>'+
            '                    <tr>'+
            '                        <td style=\'font-family:Arial; font-size:10px; line-height: 13px; color:#58595b; padding-left:22px; padding-top:13px; padding-bottom:26px; padding-right: 22px;\'>'+
            '                            <p><span class=\'REG\'>E-mail disclaimer and company information: <a href=\'http://www.absa.co.za/disclaimer\' class=\'REGHyperLink\' style=\'color:#ed1c23\'>absa.co.za/disclaimer</a><br />'+
            '                              If you do not wish to receive any marketing correspondence, please send an e-mail to <a href=\'mailto:unsubscribe@absa.co.za\' class=\'REGHyperLink\' style=\'color:#ed1c23\'>unsubscribe@absa.co.za</a><br />'+
            '                              to be removed from the mailing list.</span>'+
            '                                <br />'+
            '                                <br />'+
            '                            </p>'+
            '                        </td>'+
            '                    </tr>'+
            '                </table>'+
            '            </td>'+
            '        </tr>'+
            '    </table>'+
            '</body>'+
            ''+
            '</html>';
        }
        else if(req.emailType != null && req.emailType.equals('Initial Email')){
            htmlBody = '<!DOCTYPE html PUBLIC \'-//W3C//DTD XHTML 1.0 Transitional//EN\' \'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\'>'+
            '<html xmlns=\'http://www.w3.org/1999/xhtml\'>'+
            ''+
            '<head>'+
            '    <meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\' />'+
            '    <title>Estate Provider Plan</title>'+
            '    <style type=\'text/css\'>'+
            '        body {'+
            '            background-color: #f2f2f2;'+
            '            margin-top: 0px;'+
            '            font-size: 11px;'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            color: #58595b;'+
            '            line-height: 16px;'+
            '        }'+
            '        '+
            '        .HeadingMain {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 28px;'+
            '            font-style: normal;'+
            '            color: #DC0032;'+
            '        }'+
            '        '+
            '        .HypelinkRed {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 11px;'+
            '            font-style: normal;'+
            '            font-weight: bold;'+
            '            color: #dc0032;'+
            '            text-decoration: underline;'+
            '        }'+
            '        '+
            '        .Bodytext {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 11px;'+
            '            color: #fa551e;'+
            '        }'+
            '        '+
            '        .Bodytext2 {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 11px;'+
            '            color: #870a3c;'+
            '        }'+
            '        '+
            '        .BodytextHead {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 12px;'+
            '            color: #58595B;'+
            '        }'+
            '        '+
            '        .REG {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 7pt;'+
            '            color: #58595B;'+
            '            line-height: 14pt;'+
            '        }'+
            '        '+
            '        .REGHyperLink {'+
            '            font-family: Arial, Helvetica, sans-serif;'+
            '            font-size: 8pt;'+
            '            color: #dc0050;'+
            '            line-height: 14pt;'+
            '        }'+
            '    </style>'+
            '</head>'+
            ''+
            '<body>'+
            '    <table width=\'650\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\'>'+
            '        <tr>'+
            '            <td align=\'left\' valign=\'top\'>'+
            '                <table width=\'100%\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\' bgcolor=\'#ffffff\'>'+
            '                    <tr>'+
            '                        <td align=\'left\' valign=\'top\' bgcolor=\'#FFFFFF\' style=\'padding-top:0px; padding-left:0px; padding-bottom: 0px;\'><img src=' + strDocUrlHeader + ' width=\'650\' height=\'160\' alt=\'\' /></td>'+
            '                    </tr>'+
            '                </table>'+
            '            </td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td align=\'left\' valign=\'top\'>'+
            '                <table width=\'100%\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\' bgcolor=\'#ffffff\'>'+
            '                    <tr>'+
            '                        <td bgcolor=\'#FFFFFF\' style=\'padding-left:22px; padding-right: 22px;\'>'+
            '                            <p><span class=\'Bodytext\'><span lang=\'EN-GB\' xml:lang=\'EN-GB\'><br />'+
            '                          Dear ' + name +
            '                          <br />'+
            '                          </span></span>'+
            '                            </p>'+
            '                        </td>'+
            '                    </tr>'+
            '                    <tr>'+
            '                        <td bgcolor=\'#FFFFFF\' style=\'padding-left:22px; padding-right: 22px;\'>'+
            '                            <p>On ' + req.eventCreatedDate.format('yyyy-MM-dd') + ', you requested that ' + user.name  + ' from Absa Insurance and Financial Advisers contact you to further discuss the purpose and benefits of the Estate Provider Plan.</p>'+
            '                            <p>Executor fees and liquidity will definitely have an impact when you wind up your estate. If you prepare for this, it will benefit your family members and heirs.</p>'+

            '                            <p>This is just a friendly reminder that this discussion will take place on the date and time indicated below. We would appreciate if you please click on the calendar invite / link below to add the meeting to your calendar.</p>'+
            '                            <p>Download calendar invite'+
            '                            <br />'+
            '							 <p><a href=\'http://addtocalendar.com/atc/outlook?f=m&e[0][date_start]='+ req.startDate.format('yyyy-MM-dd HH:mm:ss', timeZone) +'&e[0][date_end]=' + req.endDate.format('yyyy-MM-dd HH:mm:ss', timeZone) + '&e[0][timezone]=' + timeZone + '&e[0][title]=' + req.subject + '&e[0][description]=' + req.description + '&e[0][location]=' + req.location + '&e[0][organizer]=' + user.name + '&e[0][privacy]=public\'> <img src=' + strDocUrlSaveDate + ' width=\'133\' height=\'69\' alt=\'\' />' + '</a></p>'+
            '                            <p>If you need to reschedule, please reply to this email.</p>'+
            '                        </td>'+
            '                    </tr>'+
            '                    <tr>'+
            '                        <td bgcolor=\'#FFFFFF\' style=\'padding-left:22px; padding-right: 22px;\'>'+
            '                            <p><span class=\'Bodytext2\' lang=\'EN-GB\' xml:lang=\'EN-GB\'><strong><br />'+
            '                          Kind regards</strong></span></p>'+
            '                            <p><span class=\'Bodytext\' lang=\'EN-GB\' xml:lang=\'EN-GB\'><strong>'+
            '                          Absa Insurance and Financial Advisers <br />'+
            '                          </strong></span>Virtual Advice Department'+
            '                                <br /> virtualadviser@absa.co.za'+
            '                                <br /> 011 225 1797</p>'+
            '                            <p>Note: Office hours - 08:00 to 16:30'+
            '                                <br />'+
            '                            </p>'+
            '                        </td>'+
            '                    </tr>'+
            '                </table>'+
            '            </td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td bgcolor=\'#FFFFFF\' align=\'left\' valign=\'top\' style=\'padding-left:0px; padding-right: 0px; padding-bottom: 0px;\'>'+
            '                <p class=\'REG\'><img src=' + strDocUrlBar + ' width=\'650\' height=\'9\' alt=\'\' /></p>'+
            '            </td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td bgcolor=\'#FFFFFF\' align=\'left\' valign=\'top\' style=\'padding-left:22px; padding-right: 22px; padding-bottom: 13px;\'><span class=\'REG\'>Absa Insurance and Financial Advisers (Pty) Ltd (Registration no 1970/002732/07), a duly authorized financial services provider <br />under licence number: 4012</span></td>'+
            '        </tr>'+
            '        <tr>'+
            '            <td align=\'left\' valign=\'top\'>'+
            '                <table width=\'100%\' border=\'0\' align=\'center\' cellpadding=\'0\' cellspacing=\'0\'>'+
            '                    <tr>'+
            '                        <td style=\'font-family:Arial; font-size:10px; line-height: 13px; color:#58595b; padding-left:22px; padding-top:13px; padding-bottom:26px; padding-right: 22px;\'>'+
            '                            <p><span class=\'REG\'>E-mail disclaimer and company information: <a href=\'http://www.absa.co.za/disclaimer\' class=\'REGHyperLink\' style=\'color:#ed1c23\'>absa.co.za/disclaimer</a><br />'+
            '                              If you do not wish to receive any marketing correspondence, please send an e-mail to <a href=\'mailto:unsubscribe@absa.co.za\' class=\'REGHyperLink\' style=\'color:#ed1c23\'>unsubscribe@absa.co.za</a><br />'+
            '                              to be removed from the mailing list.</span>'+
            '                                <br />'+
            '                                <br />'+
            '                            </p>'+
            '                        </td>'+
            '                    </tr>'+
            '                </table>'+
            '            </td>'+
            '        </tr>'+
            '    </table>'+
            '</body>'+
            ''+
            '</html>';
        }


	List<String> emailAddresses = new List<String>();
        emailAddresses.add(emailAddress);

        // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
        // contents to a new SingleEmailMessage. Then send those new messages.
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
        emailToSend.setToAddresses(emailAddresses);
        emailToSend.setPlainTextBody(null);
        emailToSend.setHTMLBody(htmlBody);
        emailToSend.setSubject(req.subject);
        emailToSend.setSaveAsActivity(true);
        emailToSend.setWhatId(whatId);
        lstMsgsToSend.add(emailToSend);
        Messaging.sendEmail(lstMsgsToSend);
    }
}