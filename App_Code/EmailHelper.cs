using System;
using System.Net;
using System.Net.Mail;

public class EmailHelper
{
    private static string MyEmail = "siddhitailor91@gmail.com";
    private static string MyPassword = "qdybqjokzkdjfnai";

    public static void SendNotificationToAdmin(string subject, string messageBody)
    {
        try
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(MyEmail);
            mail.To.Add(MyEmail);
            mail.Subject = subject;
            mail.Body = messageBody;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential(MyEmail, MyPassword);
            smtp.EnableSsl = true;

            smtp.Send(mail);
        }
        catch (Exception ex)
        {

        }
    }

  
    public static void SendEmail(string toEmail, string subject, string messageBody)
    {
        try
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(MyEmail);
            mail.To.Add(toEmail); // Yahan hum Seller ka email dalenge jo bahar se aayega
            mail.Subject = subject;
            mail.Body = messageBody;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential(MyEmail, MyPassword);
            smtp.EnableSsl = true;

            smtp.Send(mail);
        }
        catch (Exception ex)
        {
            
        }
    }

} 