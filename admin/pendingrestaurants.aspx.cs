using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_pendingrestaurants : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = @"SELECT r.RestaurantID, r.Name, r.Phone, c.CityName, cat.CategoryName 
                             FROM tbl_Restaurants r 
                             JOIN tbl_Cities c ON r.CityID = c.CityID 
                             JOIN tbl_Categories cat ON r.CategoryID = cat.CategoryID 
                             WHERE r.ApprovalStatus = 0";

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
        int restId = Convert.ToInt32(e.CommandArgument);
        int newStatus = 0;

        if (e.CommandName == "Approve")
        {
            newStatus = 1;
        }
        else if (e.CommandName == "Reject")
        {
            newStatus = 2;
        }

        if (newStatus <= 0) return;

        // ✅ Seller Email + Restaurant Name fetch
        string sellerEmail = "";
        string restName = "";

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            // ✅ Restaurant + Seller Email (RestaurantID se)
            string fetchQuery = @"
                SELECT r.Name, s.Email
                FROM tbl_Restaurants r
                INNER JOIN tbl_Sellers s ON r.SellerID = s.SellerID
                WHERE r.RestaurantID = @id";

            using (SqlCommand cmdFetch = new SqlCommand(fetchQuery, con))
            {
                cmdFetch.Parameters.AddWithValue("@id", restId);

                using (SqlDataReader dr = cmdFetch.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        restName = dr["Name"] != DBNull.Value ? dr["Name"].ToString() : "";
                        sellerEmail = dr["Email"] != DBNull.Value ? dr["Email"].ToString() : "";
                    }
                }
            }

            // ✅ Update status
            string updateQuery = "UPDATE tbl_Restaurants SET ApprovalStatus = @status WHERE RestaurantID = @id";
            using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, con))
            {
                cmdUpdate.Parameters.AddWithValue("@status", newStatus);
                cmdUpdate.Parameters.AddWithValue("@id", restId);
                cmdUpdate.ExecuteNonQuery();
            }
        }

        // ✅ Send Email to Seller after status update
        try
        {
            if (!string.IsNullOrWhiteSpace(sellerEmail))
            {
                if (newStatus == 1)
                {
                    string subject = "Restaurant Approved ✅ - " + restName;

                    string body = @"
                        <h3>Congratulations! Your restaurant has been approved ✅</h3>
                        <p><b>Restaurant:</b> " + restName + @"</p>
                        <p>Now your restaurant is live on the website.</p>
                        <p>Thank you!</p>";

                    EmailHelper.SendEmail(sellerEmail, subject, body);
                }
                else if (newStatus == 2)
                {
                    string subject = "Restaurant Rejected ❌ - " + restName;

                    string body = @"
                        <h3>Your restaurant submission was rejected ❌</h3>
                        <p><b>Restaurant:</b> " + restName + @"</p>
                        <p>Please review your details and submit again with correct information.</p>
                        <p>Thank you!</p>";

                    EmailHelper.SendEmail(sellerEmail, subject, body);
                }
            }
        }
        catch
        {
            // ignore email errors to not break approval flow
        }

        // ✅ Refresh grid
        BindGrid();
    }
}
