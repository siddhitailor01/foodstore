using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class seller_leadhistory : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["SellerID"] == null)
        {
            Response.Redirect("Login.aspx");
        }

        if (!IsPostBack)
        {
            BindRestaurantsDropdown();
            // Default: Show current month data
            txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
            txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            BindHistoryGrid();
        }
    }

    // --- 1. FILL RESTAURANT DROPDOWN ---
    private void BindRestaurantsDropdown()
    {
        string sId = Session["SellerID"].ToString();
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Sirf wahi restaurants laaye jo is Seller ke hain
            string query = "SELECT RestaurantID, Name FROM tbl_Restaurants WHERE SellerID = @sid";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@sid", sId);

            con.Open();
            ddlRestaurant.DataSource = cmd.ExecuteReader();
            ddlRestaurant.DataTextField = "Name";
            ddlRestaurant.DataValueField = "RestaurantID";
            ddlRestaurant.DataBind();

            // Add 'All' option
            ddlRestaurant.Items.Insert(0, new ListItem("All Restaurants", "0"));
        }
    }

    // --- 2. LOAD DATA ---
    private void BindHistoryGrid()
    {
        string sId = Session["SellerID"].ToString();

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = @"
                SELECT 
                    l.LeadID, 
                    l.ActionDate, 
                    l.ActionType,
                    r.Name, 
                    r.CoverImage
                FROM tbl_Leads l
                INNER JOIN tbl_Restaurants r ON l.RestaurantID = r.RestaurantID
                WHERE r.SellerID = @sid 
                AND l.ActionType LIKE '%Call%'";

            // --- FILTERS ---

            // 1. Restaurant Filter
            if (ddlRestaurant.SelectedValue != "0")
            {
                query += " AND r.RestaurantID = @rid";
            }

            // 2. Date Filter
            if (!string.IsNullOrEmpty(txtStartDate.Text) && !string.IsNullOrEmpty(txtEndDate.Text))
            {
                // CAST as DATE to ignore time part for inclusive search
                query += " AND CAST(l.ActionDate AS DATE) BETWEEN @start AND @end";
            }

            query += " ORDER BY l.ActionDate DESC"; // Latest first

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@sid", sId);

            if (ddlRestaurant.SelectedValue != "0")
            {
                cmd.Parameters.AddWithValue("@rid", ddlRestaurant.SelectedValue);
            }

            if (!string.IsNullOrEmpty(txtStartDate.Text) && !string.IsNullOrEmpty(txtEndDate.Text))
            {
                cmd.Parameters.AddWithValue("@start", txtStartDate.Text);
                cmd.Parameters.AddWithValue("@end", txtEndDate.Text);
            }

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            gvHistory.DataSource = dt;
            gvHistory.DataBind();
        }
    }

    // --- BUTTON CLICKS ---
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        gvHistory.PageIndex = 0; // Search krne par page 1 par wapas aao
        BindHistoryGrid();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        ddlRestaurant.SelectedIndex = 0;
        txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
        txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        BindHistoryGrid();
    }

    // --- PAGINATION ---
    protected void gvHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvHistory.PageIndex = e.NewPageIndex;
        BindHistoryGrid();
    }
}