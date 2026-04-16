using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_login : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Agar pehle se login hai toh Dashboard bhejo
            if (Session["SellerID"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (txtEmail.Text == "" || txtPass.Text == "")
        {
            lblMsg.Text = "Please enter Email and Password!";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                // Hum ID, Name ke saath 'IsApproved' bhi mangwa rahe hain check karne ke liye
                string query = "SELECT SellerID, FullName, IsApproved FROM tbl_Sellers WHERE Email=@e AND Password=@p";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPass.Text.Trim()); // Real project me Encrypted password match karna

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // 1. Check Approval Status
                    bool isApproved = false;
                    if (dr["IsApproved"] != DBNull.Value)
                    {
                        isApproved = Convert.ToBoolean(dr["IsApproved"]);
                    }

                    if (isApproved == false)
                    {
                        // Agar Approved nahi hai (Pending hai)
                        lblMsg.Text = "Your account is <b>Pending Approval</b>.<br>Please wait for Admin confirmation.";
                    }
                    else
                    {
                        // 2. Agar Approved hai -> Login Success
                        Session["SellerID"] = dr["SellerID"].ToString();
                        Session["SellerName"] = dr["FullName"].ToString();

                        Response.Redirect("Dashboard.aspx");
                    }
                }
                else
                {
                    // Email ya Password galat hai
                    lblMsg.Text = "Invalid Email or Password!";
                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error: " + ex.Message;
        }
    }
}