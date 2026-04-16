using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_allrestaurants : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid(string searchQuery = "")
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string sql = @"SELECT r.RestaurantID, r.Name, r.CoverImage, r.ApprovalStatus, 
                           c.CityName, s.FullName as SellerName 
                           FROM tbl_Restaurants r 
                           JOIN tbl_Cities c ON r.CityID = c.CityID 
                           JOIN tbl_Sellers s ON r.SellerID = s.SellerID ";

            if (!string.IsNullOrEmpty(searchQuery))
            {
                sql += " WHERE r.Name LIKE '%" + searchQuery + "%' OR c.CityName LIKE '%" + searchQuery + "%'";
            }

            sql += " ORDER BY r.RestaurantID DESC";

            using (SqlCommand cmd = new SqlCommand(sql, con))
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

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtSearch.Text.Trim());
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        BindGrid(txtSearch.Text.Trim());
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

        lblMsg.Text = "<div class='alert alert-danger'>Restaurant deleted permanently.</div>";
        BindGrid();
    }

    public string GetStatusBadge(object statusObj)
    {
        int status = Convert.ToInt32(statusObj);

        if (status == 1)
        {
            return "<span class='badge bg-success'>Active</span>";
        }
        else if (status == 2)
        {
            return "<span class='badge bg-danger'>Rejected</span>";
        }
        else
        {
            return "<span class='badge bg-warning text-dark'>Pending</span>";
        }
    }
}