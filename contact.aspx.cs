using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class contact : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Page Load logic (if any)
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // Validation check
        if (Page.IsValid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    // Updated Query: Added Phone Column
                    string query = "INSERT INTO tbl_ContactQueries (Name, Email, Phone, Subject, Message) VALUES (@name, @email, @phone, @subject, @msg)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim()); // Added Phone Parameter
                        cmd.Parameters.AddWithValue("@subject", txtSubject.Text.Trim());
                        cmd.Parameters.AddWithValue("@msg", txtMessage.Text.Trim());

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Show Success Message
                lblMsg.Text = "<div class='alert alert-success'>Thank you! Your message has been sent successfully.</div>";

                // Clear Fields
                txtName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = ""; // Clear Phone
                txtSubject.Text = "";
                txtMessage.Text = "";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "<div class='alert alert-danger'>Error: " + ex.Message + "</div>";
            }
        }
    }
}