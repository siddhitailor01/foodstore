using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_viewqueries : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminID"] == null)
        {
            Response.Redirect("login.aspx"); 
        }

        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "SELECT * FROM tbl_ContactQueries ORDER BY QueryDate DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    gvQueries.DataSource = dt;
                    gvQueries.DataBind();
                }
            }
        }
    }

    protected void gvQueries_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        // QueryID nikalo jise delete karna hai
        int id = Convert.ToInt32(gvQueries.DataKeys[e.RowIndex].Value);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "DELETE FROM tbl_ContactQueries WHERE QueryID = @id";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Delete ke baad grid refresh karo aur message dikhao
        BindGrid();
        lblMsg.Text = "<div class='alert alert-success'>Message deleted successfully.</div>";
    }
}