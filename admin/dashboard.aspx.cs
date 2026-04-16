using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text; // For StringBuilder

public partial class admin_dashboard : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminID"] == null)
        {
            Response.Redirect("Login.aspx");
        }

        if (!IsPostBack)
        {
            LoadCounts();
            LoadGrowthData(); // New: For Line Chart
            LoadRecentActivity(); // New: For Table
            LoadGrowthChart();
        }
    }

    private void LoadCounts()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            // 1. Total Cities
            SqlCommand cmdCity = new SqlCommand("SELECT COUNT(*) FROM tbl_Cities", con);
            lblCities.Text = "<h3>" + cmdCity.ExecuteScalar().ToString() + "</h3>";

            // 2. Total Categories
            SqlCommand cmdCat = new SqlCommand("SELECT COUNT(*) FROM tbl_Categories", con);
            lblCategories.Text = "<h3>" + cmdCat.ExecuteScalar().ToString() + "</h3>";

            // 3. Active Restaurants
            SqlCommand cmdActive = new SqlCommand("SELECT COUNT(*) FROM tbl_Restaurants WHERE ApprovalStatus = 1", con);
            string activeCount = cmdActive.ExecuteScalar().ToString();
            lblActiveRest.Text = "<h3>" + activeCount + "</h3>";
            hfLiveCount.Value = activeCount; // Pass to Pie Chart

            // 4. Pending Restaurants
            SqlCommand cmdPending = new SqlCommand("SELECT COUNT(*) FROM tbl_Restaurants WHERE ApprovalStatus = 0", con);
            string pendingCount = cmdPending.ExecuteScalar().ToString();
            lblPending.Text = "<h3>" + pendingCount + "</h3>";
            hfPendingCount.Value = pendingCount; // Pass to Pie Chart
        }
    }

    private void LoadGrowthData()
    {
        // This fetches the count of restaurants registered per month for the current year
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // SQL to get Month Name and Count, grouped by Month
            string query = @"
    SELECT DATENAME(MONTH, ListingDate) AS MonthName, COUNT(*) AS Count 
    FROM tbl_Restaurants 
    WHERE YEAR(ListingDate) = YEAR(GETDATE()) 
    GROUP BY DATENAME(MONTH, ListingDate), MONTH(ListingDate) 
    ORDER BY MONTH(ListingDate)";

            SqlCommand cmd = new SqlCommand(query, con);
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            StringBuilder sbLabels = new StringBuilder();
            StringBuilder sbData = new StringBuilder();

            while (rdr.Read())
            {
                sbLabels.Append(rdr["MonthName"].ToString() + ",");
                sbData.Append(rdr["Count"].ToString() + ",");
            }

            // Remove trailing commas
            if (sbLabels.Length > 0) sbLabels.Length--;
            if (sbData.Length > 0) sbData.Length--;

            // If no data, provide defaults so chart doesn't crash
            if (sbLabels.Length == 0)
            {
                hfGrowthLabels.Value = "No Data";
                hfGrowthData.Value = "0";
            }
            else
            {
                hfGrowthLabels.Value = sbLabels.ToString();
                hfGrowthData.Value = sbData.ToString();
            }
        }
    }

    private void LoadRecentActivity()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Fetch Top 5 Recent Registrations with City Name
            string query = @"
    SELECT TOP 5 r.RestaurantID, r.Name, c.CityName, r.ListingDate as RegistrationDate, r.ApprovalStatus 
    FROM tbl_Restaurants r
    INNER JOIN tbl_Cities c ON r.CityID = c.CityID
    ORDER BY r.ListingDate DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    rptRecent.DataSource = dt;
                    rptRecent.DataBind();
                }
            }
        }
    }

    // --- Updated LoadGrowthChart Method ---
    private void LoadGrowthChart()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string query = @"
                SELECT 
                    DATENAME(MONTH, ListingDate) AS MonthName, 
                    MONTH(ListingDate) AS MonthNum,
                    COUNT(*) AS Total
                FROM tbl_Restaurants
                WHERE YEAR(ListingDate) = YEAR(GETDATE())
                GROUP BY DATENAME(MONTH, ListingDate), MONTH(ListingDate)
                ORDER BY MonthNum";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                StringBuilder sbLabels = new StringBuilder();
                StringBuilder sbData = new StringBuilder();

                // --- TRICK: Add a 'Start' point with 0 value ---
                // Isse chart hamesha 0 se start hoga aur line banegi
                sbLabels.Append("Start,");
                sbData.Append("0,");

                bool hasData = false;
                while (rdr.Read())
                {
                    sbLabels.Append(rdr["MonthName"].ToString() + ",");
                    sbData.Append(rdr["Total"].ToString() + ",");
                    hasData = true;
                }

                // Remove last comma
                if (sbLabels.Length > 0) sbLabels.Length--;
                if (sbData.Length > 0) sbData.Length--;

                hfGrowthLabels.Value = sbLabels.ToString();
                hfGrowthData.Value = sbData.ToString();
            }
        }
        catch (Exception ex)
        {
            hfGrowthLabels.Value = "Error";
            hfGrowthData.Value = "0";
        }
    }

    // Helper for Status Badge in Repeater
    protected string GetStatusBadge(object status)
    {
        int s = Convert.ToInt32(status);
        if (s == 0)
            return "<span class='status-pill pill-pending'>Pending</span>";
        else if (s == 1)
            return "<span class='status-pill pill-active'>Active</span>";
        else
            return "<span class='status-pill' style='background:#fee2e2; color:#991b1b;'>Rejected</span>";
    }
}