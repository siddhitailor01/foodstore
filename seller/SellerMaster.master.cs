using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class seller_SellerMaster : System.Web.UI.MasterPage
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
            LoadSellerInfo();
        }
    }

    private void LoadSellerInfo()
    {
        string sellerId = Session["SellerID"].ToString();

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "SELECT FullName FROM tbl_Sellers WHERE SellerID = @id";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@id", sellerId);
                con.Open();

                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    string fullName = result.ToString();

                    // 1. Pura naam set karein
                    lblSellerName.Text = fullName;

                    // 2. Pehla akshar nikal kar Avatar mein set karein
                    if (!string.IsNullOrEmpty(fullName))
                    {
                        lblProfileLetter.Text = fullName.Substring(0, 1).ToUpper();
                    }
                    else
                    {
                        lblProfileLetter.Text = "U"; // Fallback
                    }
                }
            }
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("Login.aspx");
    }
}