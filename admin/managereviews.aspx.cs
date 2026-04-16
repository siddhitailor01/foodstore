using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_managereviews : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminID"] == null) // Admin Login Check
        {
            Response.Redirect("Login.aspx");
        }

        if (!IsPostBack)
        {
            BindReviews();
        }
    }

    private void BindReviews()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // JOIN query taaki Restaurant ka Naam bhi dikhe
            string query = @"SELECT r.ReviewID, r.UserName, r.Rating, r.ReviewText, r.ReviewDate, 
                                    res.Name as RestaurantName 
                             FROM tbl_Reviews r
                             INNER JOIN tbl_Restaurants res ON r.RestaurantID = res.RestaurantID
                             WHERE r.IsApproved = 0 
                             ORDER BY r.ReviewDate DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    gvReviews.DataSource = dt;
                    gvReviews.DataBind();
                }
            }
        }
    }

    protected void gvReviews_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int reviewId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "ApproveReview")
        {
            // Update Status to 1
            ExecuteQuery("UPDATE tbl_Reviews SET IsApproved = 1 WHERE ReviewID = " + reviewId);
            lblMsg.Text = "<div class='alert alert-success'>Review Approved Successfully!</div>";
        }
        else if (e.CommandName == "DeleteReview")
        {
            // Delete Row
            ExecuteQuery("DELETE FROM tbl_Reviews WHERE ReviewID = " + reviewId);
            lblMsg.Text = "<div class='alert alert-danger'>Review Deleted!</div>";
        }

        BindReviews(); // Refresh Grid
    }

    private void ExecuteQuery(string query)
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    // Helper: Number to Stars (Frontend ke liye)
    public string GenerateStars(int rating)
    {
        string stars = "";
        for (int i = 0; i < rating; i++) stars += "★";
        for (int i = rating; i < 5; i++) stars += "☆";
        return stars;
    }
}