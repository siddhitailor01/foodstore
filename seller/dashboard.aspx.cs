using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

public partial class seller_dashboard : System.Web.UI.Page
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
            LoadStats();
            LoadGraphs();
            LoadRecentLeads();
        }
    }

    // --- 1. STATISTICS CARDS ---
    private void LoadStats()
    {
        string sId = Session["SellerID"].ToString();

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            // 1. Live Restaurants
            string sqlLive = "SELECT COUNT(*) FROM tbl_Restaurants WHERE SellerID=" + sId + " AND ApprovalStatus=1";
            SqlCommand cmdLive = new SqlCommand(sqlLive, con);
            lblLiveRest.Text = cmdLive.ExecuteScalar().ToString();

            // 2. Pending Count
            string sqlPending = "SELECT COUNT(*) FROM tbl_Restaurants WHERE SellerID=" + sId + " AND ApprovalStatus=0";
            SqlCommand cmdPending = new SqlCommand(sqlPending, con);
            lblPending.Text = cmdPending.ExecuteScalar().ToString();

            // 3. Menu Items
            string sqlSig = "SELECT COUNT(*) FROM tbl_Restaurants WHERE SellerID=" + sId + " AND SignatureDish IS NOT NULL AND SignatureDish <> ''";
            SqlCommand cmdSig = new SqlCommand(sqlSig, con);
            lblMenuItems.Text = cmdSig.ExecuteScalar().ToString();

            // 4. Total Interactions (All time CALLS)
            // Updated Query to only count calls if you want to be strict, 
            // otherwise counting all leads is fine if 'Call' is the only option in your system.
            string sqlLeads = @"SELECT COUNT(*) FROM tbl_Leads l 
                                INNER JOIN tbl_Restaurants r ON l.RestaurantID = r.RestaurantID 
                                WHERE r.SellerID=" + sId + " AND l.ActionType LIKE '%Call%'";
            SqlCommand cmdLeads = new SqlCommand(sqlLeads, con);
            lblTotalLeads.Text = cmdLeads.ExecuteScalar().ToString();
        }
    }

    // --- 2. GRAPHS DATA ---
    private void LoadGraphs()
    {
        string sId = Session["SellerID"].ToString();

        using (SqlConnection con = new SqlConnection(strCon))
        {
            con.Open();

            // Bar Chart (Top 5 Restaurants by Call Count)
            string sqlBar = @"SELECT TOP 5 r.Name, COUNT(l.LeadID) as ClickCount 
                              FROM tbl_Restaurants r 
                              LEFT JOIN tbl_Leads l ON r.RestaurantID = l.RestaurantID
                              WHERE r.SellerID = " + sId + @"
                              AND (l.ActionType LIKE '%Call%' OR l.ActionType IS NULL) 
                              GROUP BY r.Name ORDER BY ClickCount DESC";

            SqlCommand cmdBar = new SqlCommand(sqlBar, con);
            SqlDataReader rdr = cmdBar.ExecuteReader();

            StringBuilder sbNames = new StringBuilder();
            StringBuilder sbClicks = new StringBuilder();

            while (rdr.Read())
            {
                sbNames.Append(rdr["Name"].ToString() + ",");
                sbClicks.Append(rdr["ClickCount"].ToString() + ",");
            }
            rdr.Close();

            if (sbNames.Length > 0) sbNames.Length--;
            if (sbClicks.Length > 0) sbClicks.Length--;

            hfRestNames.Value = sbNames.ToString();
            hfRestClicks.Value = sbClicks.ToString();
        }
    }

    // --- 3. DAILY PERFORMANCE TABLE ---
    private void LoadRecentLeads()
    {
        string sId = Session["SellerID"].ToString();
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // Group data by Restaurant for TODAY only - WhatsApp column removed
            string sql = @"
                SELECT 
                    r.Name, 
                    r.CoverImage,
                    SUM(CASE WHEN l.ActionType LIKE '%Call%' THEN 1 ELSE 0 END) as CallCount,
                    MAX(l.ActionDate) as LastActive
                FROM tbl_Leads l 
                INNER JOIN tbl_Restaurants r ON l.RestaurantID = r.RestaurantID 
                WHERE r.SellerID = @sid 
                AND CAST(l.ActionDate AS DATE) = CAST(GETDATE() AS DATE) -- Filter for TODAY
                AND l.ActionType LIKE '%Call%'
                GROUP BY r.Name, r.CoverImage
                ORDER BY LastActive DESC";

            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@sid", sId);
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    rptLeads.DataSource = dt;
                    rptLeads.DataBind();
                }
            }
        }
    }

    // --- 4. HELPER: Time Formatting ---
    protected string GetTimeAgo(object dateObj)
    {
        if (dateObj == DBNull.Value) return "No activity";

        DateTime dt = Convert.ToDateTime(dateObj);
        TimeSpan ts = DateTime.Now - dt;

        if (ts.TotalMinutes < 1) return "Just Now";
        if (ts.TotalMinutes < 60) return (int)ts.TotalMinutes + "m ago";
        if (ts.TotalHours < 24) return (int)ts.TotalHours + "h ago";

        return dt.ToString("h:mm tt");
    }
}