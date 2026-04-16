using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserMaster : System.Web.UI.MasterPage
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCities();

            // ✅ 0) SAVE / CLEAR LOCATION IN SESSION (City + Nearby)
            if (Request.QueryString["type"] == "nearby" &&
                !string.IsNullOrEmpty(Request.QueryString["lat"]) &&
                !string.IsNullOrEmpty(Request.QueryString["lng"]))
            {
                // Current Location selected => clear City, save nearby
                Session.Remove("CityID");
                Session.Remove("CityName");

                Session["NearType"] = "nearby";
                Session["UserLat"] = Request.QueryString["lat"];
                Session["UserLng"] = Request.QueryString["lng"];
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["cityid"]) &&
                     !string.IsNullOrEmpty(Request.QueryString["cityname"]))
            {
                // City selected => clear nearby, save city
                Session.Remove("NearType");
                Session.Remove("UserLat");
                Session.Remove("UserLng");

                Session["CityID"] = Request.QueryString["cityid"];
                Session["CityName"] = Request.QueryString["cityname"];
            }

            // ✅ 1) SAVE SEARCH IN SESSION (QueryString first)
            if (!string.IsNullOrEmpty(Request.QueryString["q"]))
            {
                Session["LastSearch"] = Request.QueryString["q"];
            }

            // ✅ 2) HANDLE LOCATION LABEL (Session based)
            if (Session["NearType"] != null && Session["NearType"].ToString() == "nearby")
            {
                lblCurrentLocation.Text = "Current Location";
            }
            else if (Session["CityName"] != null)
            {
                lblCurrentLocation.Text = Session["CityName"].ToString();
            }
            else
            {
                lblCurrentLocation.Text = "";
            }

            // ✅ 3) RESTORE SEARCH TERM (Session)
            if (Session["LastSearch"] != null)
            {
                txtGlobalSearch.Text = Session["LastSearch"].ToString();
            }
            else
            {
                txtGlobalSearch.Text = "";
            }

            // ✅ 4) SESSION LOGIC (User dropdown)
            if (Session["UserID"] != null)
            {
                pnlGuest.Visible = false;
                pnlUser.Visible = true;

                if (Session["UserName"] != null)
                    lblUserName.Text = Session["UserName"].ToString();
                else
                    lblUserName.Text = "Welcome";
            }
            else
            {
                pnlGuest.Visible = true;
                pnlUser.Visible = false;
            }
        }
    }

    private void BindCities()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string query = "SELECT CityID, CityName FROM tbl_Cities WHERE IsActive = 1 ORDER BY CityName ASC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        rptCities.DataSource = dt;
                        rptCities.DataBind();
                    }
                }
            }
        }
        catch
        {
            // ignore / log if needed
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Session.Clear();
        Response.Redirect("index.aspx");
    }

    // ✅ Global search: nearby OR city
    protected void btnGlobalSearch_Click(object sender, EventArgs e)
    {
        string searchText = txtGlobalSearch.Text.Trim();
        Session["LastSearch"] = searchText;   // ✅ persist search

        // ✅ If Nearby session active -> redirect with nearby params
        if (Session["NearType"] != null && Session["NearType"].ToString() == "nearby"
            && Session["UserLat"] != null && Session["UserLng"] != null)
        {
            string url = "Restaurants.aspx?type=nearby"
                       + "&lat=" + HttpUtility.UrlEncode(Session["UserLat"].ToString())
                       + "&lng=" + HttpUtility.UrlEncode(Session["UserLng"].ToString());

            if (!string.IsNullOrEmpty(searchText))
                url += "&q=" + HttpUtility.UrlEncode(searchText);

            Response.Redirect(url);
            return;
        }

        // ✅ Otherwise City mode
        string cityId = (Session["CityID"] != null) ? Session["CityID"].ToString() : "";
        string cityName = (Session["CityName"] != null) ? Session["CityName"].ToString() : "";

        // If no city selected, prompt user
        if (string.IsNullOrEmpty(cityId))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openLocationModal();", true);
            return;
        }

        string redirectUrl = "Restaurants.aspx?";
        if (!string.IsNullOrEmpty(searchText))
            redirectUrl += "q=" + HttpUtility.UrlEncode(searchText) + "&";

        redirectUrl += "cityid=" + HttpUtility.UrlEncode(cityId)
                    + "&cityname=" + HttpUtility.UrlEncode(cityName);

        Response.Redirect(redirectUrl);
    }

    // ✅ THIS IS THE IMPORTANT PART: carry search + location to any page link
    public string BuildNavUrl(string page)
    {
        var q = HttpUtility.ParseQueryString(string.Empty);

        // search
        if (Session["LastSearch"] != null && !string.IsNullOrWhiteSpace(Session["LastSearch"].ToString()))
            q.Set("q", Session["LastSearch"].ToString());

        // nearby
        if (Session["NearType"] != null && Session["NearType"].ToString() == "nearby"
            && Session["UserLat"] != null && Session["UserLng"] != null)
        {
            q.Set("type", "nearby");
            q.Set("lat", Session["UserLat"].ToString());
            q.Set("lng", Session["UserLng"].ToString());
        }
        // city
        else if (Session["CityID"] != null && Session["CityName"] != null)
        {
            q.Set("cityid", Session["CityID"].ToString());
            q.Set("cityname", Session["CityName"].ToString());
        }

        string qs = q.ToString();
        return string.IsNullOrEmpty(qs) ? page : (page + "?" + qs);
    }
}
