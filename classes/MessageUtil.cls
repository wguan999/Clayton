public class MessageUtil {
	public static void writeInfo(string message) {
		ApexPages.Message apexmsg=new ApexPages.Message(ApexPages.Severity.Info,message);
		ApexPages.addMessage(apexmsg);   	
	}
}