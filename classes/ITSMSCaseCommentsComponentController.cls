/*
 * Class ITSMSCaseCommentsComponentController
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: included in ITSMSCaseDetail page
 *  Description:  provides functionality to view/add case comments.
 */
public with sharing class ITSMSCaseCommentsComponentController {

    public Id caseId {get; set;}
    public CaseComment newComment {get;set;}
    public boolean newCommentNeeded {
        get{
            if (newCommentNeeded == null)
                newCommentNeeded = false;
            return newCommentNeeded;
        }
        set;
    }
    public list<cComments> comments{
        get{
            List<cComments> comments = new List<cComments>();
            for(CaseComment comment : [Select LastModifiedDate, LastModifiedBy.Id, LastModifiedBy.Name, IsPublished, CreatedDate, CreatedBy.Id, CreatedBy.Name, CommentBody 
                               From CaseComment c where ParentId = :caseId order by c.LastModifiedDate desc])
            {
                cComments tempcComment = new cComments();
                tempcComment.cComment = comment;

                // Build String to display.
                string[] formatComment = new String[] { comment.LastModifiedBy.Name, comment.LastModifiedDate.format() };
                tempcComment.commentModified = String.format(ITSMSConstants.CASE_COMMENT, formatComment); 

                if(comment.IsPublished)
                    tempcComment.PublicPrivateAction = 'Make Private';
                else
                    tempcComment.PublicPrivateAction = 'Make Public';
                //Add to list
                comments.add(tempcComment); 
            }
            return comments;
        }
        set;
    }
    public PageReference NewComment()
    {
        newCommentNeeded = true;
        newComment = new CaseComment(ParentID = caseId);
        return null;
    }

    public PageReference saveComment()
    {
        insert newComment;
        newCommentNeeded = false;
        return null;
    }
    public PageReference cancelComment()
    {
        newCommentNeeded = false;
        return null;
    }   


    public class cComments {

        public CaseComment cComment {get; set;}
        public String commentModified {get; set;}
        public String PublicPrivateAction {get; set;}
    }
}