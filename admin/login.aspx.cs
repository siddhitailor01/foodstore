using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Admin_login : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["AdminID"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (txtUser.Text == "" || txtPass.Text == "")
        {
            lblMsg.Text = "Please enter both Username and Password!";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string query = "SELECT AdminID, Username FROM tbl_Admin WHERE Username=@user AND Password=@pass";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@user", txtUser.Text.Trim());
                cmd.Parameters.AddWithValue("@pass", txtPass.Text.Trim()); // Note: Real project me password Encrypted hona chahiye

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        Session["AdminID"] = dr["AdminID"].ToString();
                        Session["AdminUser"] = dr["Username"].ToString();
                    }

                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    lblMsg.Text = "Invalid Username or Password!";
                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error: " + ex.Message;
        }
    }
}