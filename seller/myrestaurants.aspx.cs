using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class seller_myrestaurants : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
        Response.Cache.SetNoStore();
        if (!IsPostBack)
        {
            if (Session["SellerID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            BindGrid();
        }
    }

    private void BindGrid()
    {
        int sellerId = Convert.ToInt32(Session["SellerID"]);

        using (SqlConnection con = new SqlConnection(strCon))
        {

            string query = @"SELECT r.RestaurantID, r.Name, r.Phone, r.CoverImage, r.ApprovalStatus, 
                             c.CityName, cat.CategoryName, ISNULL(a.AreaName, '-') as AreaName
                             FROM tbl_Restaurants r
                             JOIN tbl_Cities c ON r.CityID = c.CityID
                             JOIN tbl_Categories cat ON r.CategoryID = cat.CategoryID
                             LEFT JOIN tbl_Areas a ON r.AreaID = a.AreaID
                             WHERE r.SellerID = @sid
                             ORDER BY r.RestaurantID DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@sid", sellerId);

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

    public string GetStatusBadge(object statusObj)
    {
        int status = Convert.ToInt32(statusObj);
        if (status == 1)
        {
            return "<span class='badge bg-success'>Live (Active)</span>";
        }
        else if (status == 2)
        {
            return "<span class='badge bg-danger'>Rejected</span>";
        }
        else
        {
            return "<span class='badge bg-warning text-dark'>Pending Approval</span>";
        }
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int restId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "DELETE FROM tbl_Restaurants WHERE RestaurantID = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", restId);

            con.Open();
            cmd.ExecuteNonQuery();
        }

        lblMsg.Text = "<div class='alert alert-danger'>Restaurant deleted successfully.</div>";
        BindGrid(); 
    }

   
}