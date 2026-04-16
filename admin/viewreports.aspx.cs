using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_viewreports : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindGrid();
    }

    private void BindGrid()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Hum Restaurant aur Seller ka phone number bhi layenge taaki Admin call karke verify kar sake
            string query = @"SELECT rpt.ReportID, rpt.ReportReason, rpt.UserMessage, rpt.ReportDate, rpt.RestaurantID,
                             res.Name as RestaurantName, sel.Phone as SellerPhone
                             FROM tbl_Reports rpt
                             JOIN tbl_Restaurants res ON rpt.RestaurantID = res.RestaurantID
                             JOIN tbl_Sellers sel ON res.SellerID = sel.SellerID
                             WHERE rpt.Status = 'New' ORDER BY rpt.ReportDate DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
            }
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "CloseShop")
        {
            // Action 1: Restaurant ko band (Deactivate) kar do
            int restID = Convert.ToInt32(e.CommandArgument);
            UpdateRestaurantStatus(restID, 0); // 0 = Deactivate/Pending
            lblMsg.Text = "<div class='alert alert-success'>Restaurant Deactivated based on report.</div>";
        }
        else if (e.CommandName == "IgnoreReport")
        {
            // Action 2: Report ko 'Resolved' mark kar do taaki list se hat jaye
            int reportID = Convert.ToInt32(e.CommandArgument);
            CloseReport(reportID);
            lblMsg.Text = "<div class='alert alert-info'>Report Ignored.</div>";
        }
        BindGrid();
    }

    private void UpdateRestaurantStatus(int id, int status)
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Restaurant ka approval status wapas 0 (Pending/Hold) kar diya
            SqlCommand cmd = new SqlCommand("UPDATE tbl_Restaurants SET ApprovalStatus=@s WHERE RestaurantID=@id", con);
            cmd.Parameters.AddWithValue("@s", status);
            cmd.Parameters.AddWithValue("@id", id);
            con.Open(); cmd.ExecuteNonQuery();
        }
    }

    private void CloseReport(int id)
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            SqlCommand cmd = new SqlCommand("UPDATE tbl_Reports SET Status='Resolved' WHERE ReportID=@id", con);
            cmd.Parameters.AddWithValue("@id", id);
            con.Open(); cmd.ExecuteNonQuery();
        }
    }
}