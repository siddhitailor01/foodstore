using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_AdminMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminID"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else
        {
            if (!IsPostBack)
            {
                lblAdminName.Text = "Welcome, " + Session["AdminUser"].ToString();
                UpdateNotifications();
            }
        }
    }


    private void UpdateNotifications()
    {
        string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM tbl_Sellers WHERE IsApproved=0", con);
            int sellerCount = (int)cmd1.ExecuteScalar();

            if (sellerCount > 0)
            {
                lblSellerCount.Text = sellerCount.ToString();
                lblSellerCount.Visible = true; // Badge dikhao
            }

            SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM tbl_Restaurants WHERE ApprovalStatus=0", con);
            int restCount = (int)cmd2.ExecuteScalar();

            if (restCount > 0)
            {
                lblRestCount.Text = restCount.ToString();
                lblRestCount.Visible = true; // Badge dikhao
            }
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon(); 
        Response.Redirect("Login.aspx"); 
    }
}