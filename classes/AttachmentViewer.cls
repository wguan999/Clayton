public class AttachmentViewer
{
public List<Attachment> att{get;set;}

        
public AttachmentViewer()
{
//att=[Select a.Id,a.ContentType,a.ParentId,a.Parent.Type,a.Parent.Name,a.OwnerId,a.Owner.Name, a.Name, a.LastModifiedDate, a.BodyLength From Attachment a where contentType='application/pdf'];
att=[Select a.Id,a.ContentType,a.ParentId,a.Parent.Type,a.Parent.Name,a.OwnerId,a.Owner.Name, a.Name, a.LastModifiedDate, a.BodyLength From Attachment a];

}

}