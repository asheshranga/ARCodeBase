/*
 * Class ITSMSMultiAttachmentComponentController
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: Controller for Visualforce component ITSMSMultiAttachment
 *    functionality for attaching multiple files/documents to an object
 */
public with sharing class ITSMSMultiAttachmentComponentController {
    // initialize variables
    public Id sobjId {get; set;}     // parent object
    public boolean attachmentsExist {get;set;} // controls display of existing attachments
    public List<Attachment> attachments;  // attachments already entered
    public List<Attachment> newAttachments {get; set;}
    public static final Integer numberToAdd = integer.valueOf(ITSMSConstants.ATTACHMENTS_INCREMENT);  //number of attachments to add to the list when the user clicks 'Add More'

    // Constructor 
    public ITSMSMultiAttachmentComponentController()    {
        newAttachments=new List<Attachment>();
        addMore();
    }   

    // Retrieve any existing attachments 
    public List<Attachment> getAttachments()     {
        // only execute the SOQL if the list hasn't been initialised
        if (null==attachments)
            attachments=[select Id, ParentId, Name, Description from Attachment where parentId=:sobjId];
        if (attachments.size() > 0 )
            attachmentsExist = true;
        return attachments;
    }
    
    // setup for multiple attachments 
    public void addMore() {
        // append # attachments possible to add to the new attachments list
        for (Integer idx=0; idx<numberToAdd; idx++)
        {
            newAttachments.add(new Attachment());
        }
    }    

    // Save attachments 
    public void saveAttachment() {
        List<Attachment> toInsert=new List<Attachment>();
        for (Attachment newAtt : newAttachments)
        {
            if (newAtt.Body!=null)
            {
                newAtt.parentId=sobjId;
                toInsert.add(newAtt);
            }
        }
        try
        {
            insert toInsert;
        } catch (Exception e) {system.debug('@@ error occurred:'+e.getMessage());}
        newAttachments.clear();
        addMore();
        attachments=null;
        getAttachments();
    }
}