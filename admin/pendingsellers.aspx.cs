using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_pendingsellers : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // ✅ last search restore
            if (Session["SellerSearch"] != null)
                txtSearch.Text = Session["SellerSearch"].ToString();

            BindGrid(txtSearch.Text);
        }
    }

    // ✅ Pending + Approved dono show + Search
    private void BindGrid(string nameFilter = "")
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = @"
            SELECT s.SellerID, s.FullName, s.Email, s.Phone, s.IsApproved, s.RegistrationDate,
                   c.CityName
            FROM tbl_Sellers s
            LEFT JOIN tbl_Cities c ON s.CityID = c.CityID
            WHERE (@Name = '' OR s.FullName LIKE '%' + @Name + '%')
            ORDER BY s.IsApproved ASC, s.RegistrationDate DESC"; // ✅ Pending upar (0), Approved neeche (1)

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Name", string.IsNullOrWhiteSpace(nameFilter) ? "" : nameFilter.Trim());

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
        string q = txtSearch.Text.Trim();
        Session["SellerSearch"] = q;
        BindGrid(q);
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        Session.Remove("SellerSearch");
        BindGrid("");
    }

    protected void txtSearch_TextChanged(object sender, EventArgs e)
    {
        // Enter press par auto search
        string q = txtSearch.Text.Trim();
        Session["SellerSearch"] = q;
        BindGrid(q);
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int sellerId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "Approve")
        {
            ApproveSellerWithEmail(sellerId);
        }
        else if (e.CommandName == "Reject")
        {
            DeleteSeller(sellerId);
            lblMsg.Text = "<div class='alert alert-danger'>Seller Request Rejected and Deleted.</div>";

            // ✅ refresh with current search
            BindGrid(txtSearch.Text);
        }
    }

    private void ApproveSellerWithEmail(int sellerId)
    {
        string sellerName = "";
        string sellerEmail = "";
        bool alreadyApproved = false;

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            // Step 1: Details + status
            string getDetailsQuery = "SELECT FullName, Email, IsApproved FROM tbl_Sellers WHERE SellerID = @id";
            SqlCommand cmdGet = new SqlCommand(getDetailsQuery, con);
            cmdGet.Parameters.AddWithValue("@id", sellerId);

            SqlDataReader dr = cmdGet.ExecuteReader();
            if (dr.Read())
            {
                sellerName = dr["FullName"].ToString();
                sellerEmail = dr["Email"].ToString();

                if (dr["IsApproved"] != DBNull.Value && Convert.ToBoolean(dr["IsApproved"]) == true)
                    alreadyApproved = true;
            }
            dr.Close();

            if (alreadyApproved)
            {
                lblMsg.Text = "<div class='alert alert-info'>This seller is already approved.</div>";
                return;
            }

            // Step 2: Approve
            string updateQuery = "UPDATE tbl_Sellers SET IsApproved = 1 WHERE SellerID = @id";
            SqlCommand cmdUpdate = new SqlCommand(updateQuery, con);
            cmdUpdate.Parameters.AddWithValue("@id", sellerId);
            cmdUpdate.ExecuteNonQuery();
        }

        // Step 3: Email
        if (!string.IsNullOrEmpty(sellerEmail))
        {
            string subject = "Account Approved - FoodStore";

            // ✅ apna actual login url daalna
            string loginUrl = "http://localhost/Seller/Login.aspx";

            string body = "Hello <b>" + sellerName + "</b>,<br><br>" +
                          "Congratulations! Your seller account has been approved by the Admin.<br>" +
                          "You can now login and start adding your restaurants.<br><br>" +
                          "<b>Login here:</b> <a href='" + loginUrl + "'>Click Here</a><br><br>" +
                          "Welcome to the family!<br>Team FoodStore";

            EmailHelper.SendEmail(sellerEmail, subject, body);
        }

        lblMsg.Text = "<div class='alert alert-success'>Seller Approved & Email Sent Successfully!</div>";

        // ✅ refresh with current search
        BindGrid(txtSearch.Text);
    }

    private void DeleteSeller(int id)
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "DELETE FROM tbl_Sellers WHERE SellerID = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", id);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }
}
